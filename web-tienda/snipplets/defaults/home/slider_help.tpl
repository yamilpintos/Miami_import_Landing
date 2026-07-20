{% include "snipplets/svg/empty-placeholders.tpl" %}

{# Slider that work as example #}

{% set slide_view_box = '0 0 1440 770' %}

<div class="js-home-slider-placeholder section-slider">
	<div class="js-home-empty-slider swiper-container" style="visibility:hidden; height:0;">
		<div class="swiper-wrapper">
			<div class="swiper-slide slide-container">
				<div class="slider-slide slider-slide-empty">
					<svg viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
				</div>
			</div>
			<div class="swiper-slide slide-container">
				<div class="slider-slide slider-slide-empty">
					<svg viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
				</div>
			</div>
			<div class="swiper-slide slide-container">
				<div class="slider-slide slider-slide-empty">
					<svg viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
				</div>
			</div>
		</div>
		<div class="placeholder-overlay placeholder-slider transition-soft">
            <div class="placeholder-info">
            	<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
                <div class="placeholder-description font-small-xs">
                    {{ "Podés subir imágenes principales desde" | translate }} <strong>"{{ "Carrusel de imágenes" | translate }}"</strong>
                </div>
                {% if not params.preview %}
                    <a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
                {% endif %}
            </div>
        </div>
		<div class="js-swiper-empty-home-prev swiper-button-prev d-none d-md-block svg-icon-text">
			<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
		</div>
	    <div class="js-swiper-empty-home-next swiper-button-next d-none d-md-block svg-icon-text">
	    	<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
	    </div>
	</div>
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-home-slider-top" style="display:none">
	{% include 'snipplets/home/home-slider.tpl' %}
	{% if has_mobile_slider %}
		{% include 'snipplets/home/home-slider.tpl' with {mobile: true} %}
	{% endif %}
</div>