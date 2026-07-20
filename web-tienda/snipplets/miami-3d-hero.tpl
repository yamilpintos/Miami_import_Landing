{# ============================================================
   MIAMI_IMPORT — Hero 3D cinematografico (Champagne Noir)

   Escena Three.js custom que reemplaza el fondo plano del hero
   por una pieza 3D animada: TorusKnot gold metalizado con
   environment mapping (reflejos), particulas doradas additive
   blended (gold dust) y postprocessing UnrealBloom (el glow
   tipico de sites de lujo: Balenciaga, Dior, Bottega).

   Estrategia:
   - importmap nativo => modulos ES6 de three.js v0.158 desde
     jsDelivr CDN. Cero build step, cero npm.
   - El <script type="module"> con defer => no bloquea el FMP.
   - Skipea en mobile (perf) y prefers-reduced-motion (a11y).
   - El canvas se inyecta dentro de .miami-hero y queda en z-0,
     debajo del contenido HTML del hero (z-5).
   ============================================================ #}

<script type="importmap">
{
  "imports": {
    "three": "https://cdn.jsdelivr.net/npm/three@0.158.0/build/three.module.js",
    "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.158.0/examples/jsm/"
  }
}
</script>

<script type="module">
  // Skip rapido: nada que hacer si no esta el hero o si el visitante
  // pidio reduced-motion (a11y), o si es mobile (< 768px, perf).
  if (
    document.querySelector('.miami-hero') &&
    !(window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) &&
    window.innerWidth >= 768
  ) {
    // Imports ES6 dinamicos: si el browser no soporta importmap o falla
    // el fetch, atrapamos y degradamos a la base CSS sin romper la pagina.
    Promise.all([
      import('three'),
      import('three/addons/postprocessing/EffectComposer.js'),
      import('three/addons/postprocessing/RenderPass.js'),
      import('three/addons/postprocessing/UnrealBloomPass.js'),
      import('three/addons/postprocessing/OutputPass.js')
    ]).then(([THREE, { EffectComposer }, { RenderPass }, { UnrealBloomPass }, { OutputPass }]) => {
      const heroEl = document.querySelector('.miami-hero');
      if (!heroEl) return;

      // -------- Setup scene / camera / renderer --------
      const scene = new THREE.Scene();
      scene.background = null; // transparente para que el bg CSS se vea

      const W0 = heroEl.clientWidth || window.innerWidth;
      const H0 = heroEl.clientHeight || window.innerHeight;
      const camera = new THREE.PerspectiveCamera(48, W0 / H0, 0.1, 100);
      camera.position.set(0, 0, 6.5);

      const renderer = new THREE.WebGLRenderer({
        antialias: true,
        alpha: true,
        powerPreference: 'high-performance'
      });
      renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
      renderer.setSize(W0, H0);
      renderer.setClearColor(0x000000, 0);
      renderer.toneMapping = THREE.ACESFilmicToneMapping;
      renderer.toneMappingExposure = 1.2;

      const canvas = renderer.domElement;
      canvas.style.position = 'absolute';
      canvas.style.top = '0';
      canvas.style.left = '0';
      canvas.style.width = '100%';
      canvas.style.height = '100%';
      canvas.style.zIndex = '0';
      canvas.style.pointerEvents = 'none';
      canvas.setAttribute('data-miami-3d', '1');
      heroEl.appendChild(canvas);

      // -------- Environment map procedural --------
      // PMREMGenerator + escena de luces => HDR fake que le da
      // reflejos cinematograficos al material gold. Sin esto, el
      // metal se ve plano/muerto.
      const pmrem = new THREE.PMREMGenerator(renderer);
      pmrem.compileEquirectangularShader();

      const envScene = new THREE.Scene();
      envScene.background = new THREE.Color(0x070707);
      // Keylight calido (dorado), fill frio (cobre profundo), rim (champagne suave).
      const envLights = [
        { c: 0xffd28a, x:  6, y:  4, z:  6, i: 3.4 },
        { c: 0x8a6a3a, x: -5, y: -3, z:  4, i: 2.6 },
        { c: 0xb99b63, x:  0, y:  6, z: -4, i: 2.0 },
        { c: 0xffe6b0, x: -3, y:  0, z: -6, i: 1.4 }
      ];
      envLights.forEach(l => {
        const light = new THREE.PointLight(l.c, l.i, 30);
        light.position.set(l.x, l.y, l.z);
        envScene.add(light);
      });
      const envTexture = pmrem.fromScene(envScene, 0.04).texture;
      scene.environment = envTexture;

      // Lights de la escena principal (refuerzan el specular)
      scene.add(new THREE.AmbientLight(0x141414, 0.5));
      const keyLight = new THREE.DirectionalLight(0xfff0d0, 1.2);
      keyLight.position.set(5, 5, 5);
      scene.add(keyLight);
      const rimLight = new THREE.DirectionalLight(0xb99b63, 0.85);
      rimLight.position.set(-5, -3, -2);
      scene.add(rimLight);

      // -------- Pieza central: TorusKnot gold metalizado --------
      // TorusKnot(radius, tubeRadius, tubularSegments, radialSegments, p, q)
      // p=2, q=3 => figura tipo lazo elegante, no demasiado densa.
      const knotGeo = new THREE.TorusKnotGeometry(1.55, 0.42, 260, 36, 2, 3);
      const knotMat = new THREE.MeshStandardMaterial({
        color: 0xb99b63,
        metalness: 1.0,
        roughness: 0.18,
        envMap: envTexture,
        envMapIntensity: 1.4
      });
      const knot = new THREE.Mesh(knotGeo, knotMat);
      knot.rotation.set(0.4, 0.2, 0);
      scene.add(knot);

      // -------- Particulas: gold dust additive blended --------
      const PARTICLE_COUNT = 2000;
      const positions = new Float32Array(PARTICLE_COUNT * 3);
      const speeds = new Float32Array(PARTICLE_COUNT);
      for (let i = 0; i < PARTICLE_COUNT; i++) {
        // Distribuidas en un volumen ancho pero finito alrededor del knot
        positions[i * 3]     = (Math.random() - 0.5) * 28;
        positions[i * 3 + 1] = (Math.random() - 0.5) * 18;
        positions[i * 3 + 2] = (Math.random() - 0.5) * 14 - 1.5;
        speeds[i] = 0.0005 + Math.random() * 0.0015;
      }
      const particleGeo = new THREE.BufferGeometry();
      particleGeo.setAttribute('position', new THREE.BufferAttribute(positions, 3));
      const particleMat = new THREE.PointsMaterial({
        color: 0xd4bb88,
        size: 0.045,
        transparent: true,
        opacity: 0.75,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
        sizeAttenuation: true
      });
      const particles = new THREE.Points(particleGeo, particleMat);
      scene.add(particles);

      // Segunda capa de particulas mas grandes (focos brillantes lejanos)
      const HIGHLIGHT_COUNT = 90;
      const hlPositions = new Float32Array(HIGHLIGHT_COUNT * 3);
      for (let i = 0; i < HIGHLIGHT_COUNT; i++) {
        hlPositions[i * 3]     = (Math.random() - 0.5) * 22;
        hlPositions[i * 3 + 1] = (Math.random() - 0.5) * 14;
        hlPositions[i * 3 + 2] = (Math.random() - 0.5) * 10 - 3;
      }
      const hlGeo = new THREE.BufferGeometry();
      hlGeo.setAttribute('position', new THREE.BufferAttribute(hlPositions, 3));
      const hlMat = new THREE.PointsMaterial({
        color: 0xffe6b0,
        size: 0.15,
        transparent: true,
        opacity: 0.55,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
        sizeAttenuation: true
      });
      const highlights = new THREE.Points(hlGeo, hlMat);
      scene.add(highlights);

      // -------- Postprocessing: bloom (el "glow" premium) --------
      // strength = intensidad, radius = dispersion, threshold = a partir
      // de que brillo aparece el bloom. Tuneado para que el oro brille
      // pero el negro siga limpio.
      const composer = new EffectComposer(renderer);
      composer.addPass(new RenderPass(scene, camera));
      const bloom = new UnrealBloomPass(
        new THREE.Vector2(W0, H0),
        0.95,  // strength
        0.85,  // radius
        0.18   // threshold (bajo => mucho del oro brilla)
      );
      composer.addPass(bloom);
      composer.addPass(new OutputPass());

      // -------- Mouse parallax --------
      let targetMX = 0, targetMY = 0;
      let mx = 0, my = 0;
      heroEl.addEventListener('mousemove', (e) => {
        const rect = heroEl.getBoundingClientRect();
        targetMX = ((e.clientX - rect.left) / rect.width) * 2 - 1;
        targetMY = ((e.clientY - rect.top) / rect.height) * 2 - 1;
      });
      heroEl.addEventListener('mouseleave', () => {
        targetMX = 0; targetMY = 0;
      });

      // -------- Resize observer --------
      const ro = new ResizeObserver(() => {
        const w = heroEl.clientWidth, h = heroEl.clientHeight;
        if (w === 0 || h === 0) return;
        camera.aspect = w / h;
        camera.updateProjectionMatrix();
        renderer.setSize(w, h);
        composer.setSize(w, h);
        bloom.setSize(w, h);
      });
      ro.observe(heroEl);

      // -------- Pause cuando el hero sale del viewport (perf) --------
      let isVisible = true;
      const io = new IntersectionObserver((entries) => {
        entries.forEach(e => { isVisible = e.isIntersecting; });
      }, { threshold: 0.05 });
      io.observe(heroEl);

      // -------- Animation loop --------
      const clock = new THREE.Clock();
      let rafId;
      function animate() {
        rafId = requestAnimationFrame(animate);
        if (!isVisible) return;

        const t = clock.getElapsedTime();

        // Mouse lerp para movimiento suave
        mx += (targetMX - mx) * 0.06;
        my += (targetMY - my) * 0.06;

        // Rotacion idle del knot (cinematica, lenta)
        knot.rotation.x = 0.4 + t * 0.18;
        knot.rotation.y = 0.2 + t * 0.24;
        knot.rotation.z = Math.sin(t * 0.3) * 0.08;

        // El knot tambien sigue al mouse sutilmente
        knot.position.x = mx * 0.6;
        knot.position.y = -my * 0.35;

        // Particulas: drift lento + rotacion del field entero
        particles.rotation.y = t * 0.018;
        highlights.rotation.y = -t * 0.012;

        // Camera parallax (efecto profundidad)
        camera.position.x += (mx * 0.7 - camera.position.x) * 0.04;
        camera.position.y += (-my * 0.45 - camera.position.y) * 0.04;
        camera.lookAt(0, 0, 0);

        composer.render();
      }
      animate();

      // Limpieza por si el usuario navega antes de que termine
      window.addEventListener('beforeunload', () => {
        cancelAnimationFrame(rafId);
        ro.disconnect();
        io.disconnect();
        renderer.dispose();
        pmrem.dispose();
      });

      // Marca el hero como "3D listo" para que CSS pueda esconder
      // el gradiente del ::before (Vanta-replacement)
      heroEl.classList.add('is-3d-ready');
    }).catch((err) => {
      // Si falla algun import (CDN caido / browser viejo / network), no
      // hacemos nada — el hero queda con su look CSS de siempre.
      console.warn('[MIAMI 3D] No se pudo cargar la escena:', err);
    });
  }
</script>
