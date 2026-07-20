<section class="section-instafeed-home" data-store="home-instagram-feed">
	<div class="js-instagram-feed">
		<div class="container text-center py-4">
			{% set instuser = store.instagram|split('/')|last %}
			<a target="_blank" href="{{ store.instagram }}" class="mb-0" aria-label="{{ 'Instagram de' | translate }} {{ store.name }}">
				<div class="instafeed-title mb-3">
					<svg class="icon-inline icon-2x svg-icon-text mr-md-3 mb-md-0 mb-3"><use xlink:href="#instagram"/></svg>
					<h2 class="h4 instafeed-user mb-0">{{ 'Seguinos en' | translate }} @{{ instuser }}</h2>
				</div>
			</a>
			<div class="js-ig-success js-swiper-instafeed swiper-container">
				<div class="swiper-wrapper"
					data-ig-feed
					data-ig-items-count="6"
					data-ig-item-class="swiper-slide"
					data-ig-link-class="instafeed-link m-md-0"
					data-ig-image-class="instafeed-img"
					data-ig-aria-label="{{ 'Publicación de Instagram de' | translate }} {{ store.name }}"
					style="display: none;">
				</div>
				<div class="js-swiper-instafeed-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100 mt-2 d-md-none"></div>
			</div>
		</div>
	</div>
</section>
