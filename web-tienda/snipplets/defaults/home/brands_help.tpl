{# Slider brands that work as examples #}

{% set brand_logo_view_box = '0 0 576 512' %}
<div class="js-brands-placeholder">
	<div class="container text-md-center pr-0 px-md-3">
		<div class="position-relative py-md-5 py-4">
			<h2 class="h4 mb-4">{{ 'Nuestras marcas' | translate }}</h2>
			<div class="js-swiper-empty-brands swiper-container mb-3">
				<div class="swiper-wrapper">
					<div class="swiper-slide slide-container">
						<svg class="icon-inline icon-4x brand-image svg-icon-text" viewBox="{{ brand_logo_view_box }}"><use xlink:href="#help-logo"/></svg>
					</div>
					<div class="swiper-slide slide-container">
						<svg class="icon-inline icon-4x brand-image svg-icon-text" viewBox="{{ brand_logo_view_box }}"><use xlink:href="#help-logo"/></svg>
					</div>
					<div class="swiper-slide slide-container">
						<svg class="icon-inline icon-4x brand-image svg-icon-text" viewBox="{{ brand_logo_view_box }}"><use xlink:href="#help-logo"/></svg>
					</div>
					<div class="swiper-slide slide-container">
						<svg class="icon-inline icon-4x brand-image svg-icon-text" viewBox="{{ brand_logo_view_box }}"><use xlink:href="#help-logo"/></svg>
					</div>
					<div class="swiper-slide slide-container">
						<svg class="icon-inline icon-4x brand-image svg-icon-text" viewBox="{{ brand_logo_view_box }}"><use xlink:href="#help-logo"/></svg>
					</div>
					<div class="swiper-slide slide-container">
						<svg class="icon-inline icon-4x brand-image svg-icon-text" viewBox="{{ brand_logo_view_box }}"><use xlink:href="#help-logo"/></svg>
					</div>
					<div class="swiper-slide slide-container">
						<svg class="icon-inline icon-4x brand-image svg-icon-text" viewBox="{{ brand_logo_view_box }}"><use xlink:href="#help-logo"/></svg>
					</div>
				</div>
			</div>
			<div class="placeholder-overlay placeholder-slider transition-soft">
				<div class="placeholder-info">
					<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
					<div class="placeholder-description font-small-xs">
						{{ "Podés subir logos desde" | translate }} <strong>"{{ "Marcas" | translate }}"</strong>
					</div>
					{% if not params.preview %}
						<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
					{% endif %}
				</div>
			</div>
		</div>
	</div>
	<div class="js-swiper-empty-brands-prev swiper-button-prev d-none d-md-block svg-icon-text">
		<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
	</div>
	<div class="js-swiper-empty-brands-next swiper-button-next d-none d-md-block svg-icon-text">
		<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
	</div>
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-brands-top" style="display:none">
	{% include 'snipplets/home/home-brands.tpl' %}
</div>