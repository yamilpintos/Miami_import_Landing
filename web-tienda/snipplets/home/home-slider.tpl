{% set has_main_slider = settings.slider and settings.slider is not empty %}
{% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}
{% set has_slider_full_width = settings.slider_full %}
{% set slider_alignment = settings.slider_align == 'center' ? 'swiper-text-centered' %}
{% set slider = mobile ? settings.slider_mobile : settings.slider %}
{% set slider_name = mobile ? 'js-home-mobile-slider' : 'js-home-main-slider' %}
{% set slider_navigation = mobile ? false : true %}
{% set slider_outside_button = not has_slider_full_width ? 'swiper-button-outside' %}
{% set slider_pagination = mobile ? 'js-swiper-home-pagination-mobile' : 'js-swiper-home-pagination' %}
{% set slider_data_align = settings.slider_align %}

{% set first_image_priority_high_value = 
	settings.home_order_position_1 == 'slider' and (
		(has_mobile_slider and mobile) or
		(not has_mobile_slider and has_main_slider)
	)
%}

{% if not mobile %}
	<div class="js-home-main-slider-container {% if not has_main_slider and not params.preview %}hidden{% endif %}">
{% endif %}

<div class="js-home-slider-container {{ slider_name }}-visibility position-relative {% if has_main_slider and has_mobile_slider %}{% if mobile %}d-md-none{% else %}d-none d-md-block{% endif %}{% elseif not settings.toggle_slider_mobile and mobile %}hidden{% endif %}{% if not has_slider_full_width %} container{% endif %}" data-align="{{ slider_data_align }}">
	
	{{ component(
		'gallery',{
			gallery_name: slider,
			gallery_container_classes: slider_name,
			gallery_navigation: slider_navigation,
			gallery_prev_svg_classes: 'icon-inline icon-2x icon-flip-horizontal',
			gallery_prev_svg_id: 'arrow-long',
			gallery_next_svg_classes: 'icon-inline icon-2x',
			gallery_next_svg_id: 'arrow-long',
			gallery_prev_classes: 'js-swiper-home-prev svg-icon-text ' ~ slider_outside_button,
			gallery_next_classes: 'js-swiper-home-next svg-icon-text ' ~ slider_outside_button,
			gallery_pagination_classes: slider_pagination ~ ' swiper-pagination-outside',

			galley_image_aspect_ratio: true,
			gallery_first_image_priority_high: first_image_priority_high_value,
			gallery_image_alt: 'Carrusel' | translate ~ ' ',
			gallery_image_classes: 'slider-image',
			gallery_image_lazy_classes: 'fade-in',

			text_classes: {
				container: 'swiper-text ' ~ slider_alignment,
				number_pagination: 'swiper-fractions',
				title: 'h1 my-2',
				description: 'mt-2 mb-3',
			},
			custom_content: '<div class="placeholder placeholder-fade"></div>',
			link_aria_label: 'Carrusel' | translate,
			link_classes: {
				button: 'btn btn-primary',
			},

		})
	}}
</div>

{% if not mobile %}
	</div>
{% endif %}
