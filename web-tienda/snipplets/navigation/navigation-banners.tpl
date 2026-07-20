{% set img_setting_name = 'menu_banner_desktop.jpg' %}
{% set img_link = settings.menu_banner_desktop_url %}

{% if img_setting_name | has_custom_image %}
	{% if img_link %}
		<a href="{{ img_link }}">
	{% endif %}
			{{ component(
				'image',{
					image_name: img_setting_name,
					image_classes: 'navigation-banner',
				})
			}}
	{% if img_link %}
		</a>
	{% endif %}
{% endif %}
