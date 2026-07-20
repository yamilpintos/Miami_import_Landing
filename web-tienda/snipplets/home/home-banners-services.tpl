{% macro for_each_banner_include(template) %}
	{% for index in 1..4 %}
		{% set banner = 'banner_services_0' ~ index %}

		{% set banner_services_icon = attribute(settings,"#{banner}_icon") %}
		{% set banner_services_image = "#{banner}.jpg" | has_custom_image %}
		{% set banner_services_title = attribute(settings,"#{banner}_title") %}
		{% set banner_services_description = attribute(settings,"#{banner}_description") %}
		{% set banner_services_url = attribute(settings,"#{banner}_url") %}
		{% set banner_index = index %}
		{% set banner_show =  banner_services_title or banner_services_description %}

		{% include template %}
	{% endfor %}
{% endmacro %}

{% import _self as banner_services %}

<div class="js-informative-banners-container container py-5" {% if not has_informative_banners %}style="display: none"{% endif %}>
	<div class="js-informative-banners swiper-container text-center my-3">
		<div class="swiper-wrapper">
			{{ banner_services.for_each_banner_include('snipplets/home/home-banners-services-item.tpl') }}
		</div>
	</div>
	<div class="js-informative-banners-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside d-md-none"></div>
</div>
