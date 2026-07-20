{# /*============================================================================
  #Home featured grid
==============================================================================*/

#Properties

#Featured Slider

#}

{% set featured_products = featured_products | default(false) %}
{% set new_products = new_products | default(false) %}
{% set sale_products = sale_products | default(false) %}

{# Check if slider is used #}

{% set has_featured_products_and_slider = featured_products and (settings.featured_products_format_mobile == 'slider' or settings.featured_products_format_desktop == 'slider')  %}
{% set has_new_products_and_slider = new_products and (settings.new_products_format_mobile == 'slider' or settings.new_products_format_desktop == 'slider') %}
{% set has_sale_products_and_slider = sale_products and (settings.sale_products_format_mobile == 'slider' or settings.sale_products_format_desktop == 'slider') %}
{% set use_slider = has_featured_products_and_slider or has_new_products_and_slider or has_sale_products_and_slider %}

{% if featured_products %}
	{% set sections_products = sections.primary.products %}
	{% set section_name = 'primary' %}
	{% set section_columns_desktop = settings.featured_products_desktop %}
	{% set section_columns_mobile = settings.featured_products_mobile %}
	{% set section_format_desktop = settings.featured_products_format_desktop %}
	{% set section_format_mobile = settings.featured_products_format_mobile %}
	{% set section_slider = settings.featured_products_format_mobile == 'slider' or settings.featured_products_format_desktop == 'slider' %}
	{% set section_slider_both = settings.featured_products_format_mobile == 'slider' and settings.featured_products_format_desktop == 'slider' %}
	{% set section_slider_mobile_only = settings.featured_products_format_mobile == 'slider' and settings.featured_products_format_desktop == 'grid' %}
	{% set section_slider_desktop_only = settings.featured_products_format_desktop == 'slider' and settings.featured_products_format_mobile == 'grid' %}
	{% set section_slider_id = 'featured' %}
	{% set section_title = settings.featured_products_title %}
{% endif %}
{% if new_products %}
	{% set sections_products = sections.new.products %}
	{% set section_name = 'new' %}
	{% set section_columns_desktop = settings.new_products_desktop %}
	{% set section_columns_mobile = settings.new_products_mobile %}
	{% set section_format_desktop = settings.new_products_format_desktop %}
	{% set section_format_mobile = settings.new_products_format_mobile %}
	{% set section_slider = settings.new_products_format_mobile == 'slider' or settings.new_products_format_desktop == 'slider' %}
	{% set section_slider_both = settings.new_products_format_mobile == 'slider' and settings.new_products_format_desktop == 'slider' %}
	{% set section_slider_mobile_only = settings.new_products_format_mobile == 'slider' and settings.new_products_format_desktop == 'grid' %}
	{% set section_slider_desktop_only = settings.new_products_format_desktop == 'slider' and settings.new_products_format_mobile == 'grid' %}
	{% set section_slider_id = 'new' %}
	{% set section_title = settings.new_products_title %}
{% endif %}
{% if sale_products %}
	{% set sections_products = sections.sale.products %}
	{% set section_name = 'sale' %}
	{% set section_columns_desktop = settings.sale_products_desktop %}
	{% set section_columns_mobile = settings.sale_products_mobile %}
	{% set section_format_desktop = settings.sale_products_format_desktop %}
	{% set section_format_mobile = settings.sale_products_format_mobile %}
	{% set section_slider = settings.sale_products_format_mobile == 'slider' or settings.sale_products_format_desktop == 'slider' %}
	{% set section_slider_both = settings.sale_products_format_mobile == 'slider' and settings.sale_products_format_desktop == 'slider' %}
	{% set section_slider_mobile_only = settings.sale_products_format_mobile == 'slider' and settings.sale_products_format_desktop == 'grid' %}
	{% set section_slider_desktop_only = settings.sale_products_format_desktop == 'slider' and settings.sale_products_format_mobile == 'grid' %}
	{% set section_slider_id = 'sale' %}
	{% set section_title = settings.sale_products_title %}
{% endif %}

{% set grid_mobile_class = 
	section_columns_mobile == 2 ? 'grid-2' :
	section_columns_mobile == 1 ? 'grid-1'
%}

{% set grid_desktop_class = 
	section_columns_desktop == 6 ? 'grid-md-6' : 
	section_columns_desktop == 5 ? 'grid-md-5' : 
	section_columns_desktop == 4 ? 'grid-md-4'
%}

{% if use_slider %}
	{% set section_slider_classes = 
		section_slider_both ? 'swiper-products-slider flex-nowrap' : 
		section_slider_mobile_only ? 'swiper-mobile-only flex-nowrap flex-md-wrap' : 
		section_slider_desktop_only ? 'swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0'
	%}
	{% set section_arrows_visibility_classes = section_slider_mobile_only ? 'd-none' : 'd-none d-md-block' %}
	{% set section_pagination_visibility_classes = section_slider_mobile_only ? 'd-block d-md-none' : section_slider_desktop_only ? 'd-none d-md-block' %}
{% endif %}


<div class="js-products-{{ section_slider_id }}-container container position-relative py-4">
	<h2 class="js-products-{{ section_slider_id }}-title h4 mb-3"{% if not section_title %} style="display:none;"{% endif %}>{{ section_title }}</h2>
	{% if use_slider %}
		<div class="js-swiper-{{ section_slider_id }} swiper-container">
	{% endif %}
		<div class="js-products-{{ section_slider_id }}-grid{% if use_slider %} swiper-wrapper{% endif %} {{ section_slider_classes }}{% if not section_slider_both %} grid {{ grid_desktop_class }}{% endif %} {{ grid_mobile_class }}" data-desktop-columns="{{ section_columns_desktop }}" data-mobile-columns="{{ section_columns_mobile }}" data-desktop-format="{{ section_format_desktop }}" data-mobile-format="{{ section_format_mobile }}">
			{% for product in sections_products %}
				{% if use_slider %}
					{% include 'snipplets/product-item.tpl' with {'slide_item': true, 'section_name': section_name } %}
				{% else %}
					{% include 'snipplets/product-item.tpl' %}
				{% endif %}
			{% endfor %}
		</div>
	{% if use_slider %}
		</div>
		<div class="js-swiper-{{ section_slider_id }}-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100 {{ section_pagination_visibility_classes }}"></div>
		<div class="js-swiper-{{ section_slider_id }}-prev swiper-button-prev svg-icon-text swiper-button-outside {{ section_arrows_visibility_classes }}">
			<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
		</div>
		<div class="js-swiper-{{ section_slider_id }}-next swiper-button-next svg-icon-text swiper-button-outside {{ section_arrows_visibility_classes }}">
			<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
		</div>
	{% endif %}
</div>
