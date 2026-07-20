{% set footer_menu_type = footer_menu_secondary ? '_secondary' %}
{% set footer_menu = attribute(settings, 'footer_menu' ~ footer_menu_type) %}
{% set footer_menu_title = attribute(settings, 'footer_menu' ~ footer_menu_type ~ '_title') %}
{% set footer_mobile_toggle_title = settings.footer_menus_toggle and footer_menu_title %}
{% set footer_nav_classes = footer_mobile_toggle_title ? 'js-accordion-private-container accordion-container m-md-0' : footer_menu_title ? 'mb-3' : 'mb-3 pb-3 pb-md-0' %}

{% set theme_editor = params.preview %}

<div class="{{ footer_nav_classes }} mb-md-0">
	{% if footer_mobile_toggle_title %}
		<a href="#" class="js-accordion-private-toggle-mobile accordion-title mb-md-4">
	{% endif %}
		{% if footer_menu_title or theme_editor %}
			{% if not settings.footer_menus_toggle %}
				<div class="js-footer-menu-title-container mb-4" {% if not footer_menu_title %}style="display: none;"{% endif %}>
			{% endif %}
					{% set brand_editor_js_classes = footer_menu_secondary ? 'js-footer-menu-secondary-title' : 'js-footer-menu-title' %}
					<span class="{{ brand_editor_js_classes }} font-weight-bold">
						{{ footer_menu_title }}
					</span>
			{% if not settings.footer_menus_toggle %}
				</div>
			{% endif %}
		{% endif %}
	{% if footer_mobile_toggle_title %}
			<span class="d-md-none">
				<span class="js-accordion-private-toggle-inactive">
					<svg class="icon-inline icon-w-14 icon-md ml-2"><use xlink:href="#plus"/></svg>
				</span>
				<span class="js-accordion-private-toggle-inactive" style="display: none;">
					<svg class="icon-inline icon-w-14 icon-md ml-2"><use xlink:href="#minus"/></svg>
				</span>
			</span>
		</a>
		<div class="js-accordion-private-content js-accordion-private-content-mobile p-3 p-md-0">
	{% endif %}
			<ul class="list list-unstyled">
				{% for item in menus[footer_menu] %}
					<li {% if not loop.last %}class="mb-3"{% endif %}>
						<a href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %}>{{ item.name }}</a>
					</li>
				{% endfor %}
			</ul>
	{% if footer_mobile_toggle_title %}
		</div>
	{% endif %}
</div>
