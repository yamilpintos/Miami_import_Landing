{% if settings.brands and settings.brands is not empty %}
	<div class="container text-md-center py-md-5 py-4 pr-0 px-md-3">
		<h2 class="js-brands-title h4 mb-4"{% if not settings.brands_title %} style="display:none"{% endif %}>{{ settings.brands_title }}</h2>
		<div class="position-relative mb-3">
			{{ component(
				'gallery',{
					gallery_name: settings.brands,
					gallery_container_classes: 'js-swiper-brands brand-swiper text-center',
					gallery_prev_svg_classes: 'icon-inline icon-2x icon-flip-horizontal',
					gallery_prev_svg_id: 'arrow-long',
					gallery_next_svg_classes: 'icon-inline icon-2x',
					gallery_next_svg_id: 'arrow-long',
					gallery_prev_classes: 'js-swiper-brands-prev swiper-button-outside svg-icon-text d-none d-md-block',
					gallery_next_classes: 'js-swiper-brands-next swiper-button-outside svg-icon-text d-none d-md-block',
					gallery_image_alt: 'Marca de' | translate ~ ' ' ~ store.name ~ ' ',
					gallery_image_classes: 'brand-image fade-in',
					gallery_image_lazy: true,
					gallery_image_lazy_js: true,
					custom_content: '<div class="placeholder placeholder-fade"></div>',
					link_aria_label: 'Marca de' | translate ~ ' ' ~ store.name,
				})
			}}
		</div>
	</div>
{% endif %}
