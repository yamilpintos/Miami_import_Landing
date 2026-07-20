<div class="js-informative-banner-container swiper-slide" {% if not banner_show %}style="display: none"{% endif %}>
	{% if banner_services_url %}
		<a href="{{ banner_services_url | setting_url }}">
	{% endif %}
	{% if banner_services_icon == 'image' and banner_services_image %}
		{% set banner_image_alt = banner_services_title ? banner_services_title : 'Banner de' | translate %}
		{{ component(
			'image',{
				image_name: "#{banner}.jpg",
				image_classes: 'js-informative-banner-img js-informative-banner-img-' ~ loop.index ~ ' service-item-image mb-3 fade-in',
				image_lazy: true,
				image_lazy_js: true,
				custom_content: '<div class="placeholder placeholder-fade"></div>',
				image_alt: banner_image_alt,
			})
		}}
	{% else %}
		<div class="js-informative-banner-icon-{{ banner_index }} mb-3">
			{% if banner_services_icon == 'shipping' %}
				<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#truck"/></svg>
			{% elseif banner_services_icon == 'card' %}
				<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#credit-card"/></svg>
			{% elseif banner_services_icon == 'security' %}
				<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#security"/></svg>
			{% elseif banner_services_icon == 'returns' %}
				<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#returns"/></svg>
			{% elseif banner_services_icon == 'whatsapp' %}
				<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#whatsapp-line"/></svg>
			{% elseif banner_services_icon == 'promotions' %}
				<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#promotions"/></svg>
			{% elseif banner_services_icon == 'cash' %}
				<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#cash"/></svg>
			{% endif %}
		</div>
	{% endif %}
	<h3 class="js-informative-banner-title js-informative-banner-title-{{ banner_index }} h6 mb-2"{% if not banner_services_title %} style="display: none"{% endif %}>{{ banner_services_title }}</h3>
	<p class="js-informative-banner-description js-informative-banner-description-{{ banner_index }} m-0 font-small"{% if not banner_services_description %} style="display: none"{% endif %}>{{ banner_services_description }}</p>
	{% if banner_services_url %}
		</a>
	{% endif %}
</div>
