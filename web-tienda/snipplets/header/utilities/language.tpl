{# Languages utility #}

{% set utility_icon_md_color_class = settings.desktop_utility_colors and not secondary_nav ? 'utility-icon-md-colors' %}
{% set utility_icon_only_md_color_class = settings.desktop_utility_colors and settings.utilities_type_desktop == 'icons' ? 'utility-icon-md-big' %}

{% if dropdown %}
	<span class="js-utility-account-desktop header-utility nav-dropdown {% if secondary_nav %}ml-4{% endif %}" {% if (settings.utilities_type_desktop == 'icons' and secondary_nav) or (settings.utilities_type_desktop == 'icons_text' and not secondary_nav) %}style="display: none;"{% endif %}>
{% else %}
	<button class="js-modal-open-private header-utility" data-target="#modal-languages" aria-label="{{ 'Idiomas y monedas' | translate }}" data-modal-url="#modal-languages" data-component="languages-button">
{% endif %}
		<span class="js-header-utility-icon header-icon-big {{ utility_icon_md_color_class }} {{ utility_icon_only_md_color_class }}">
			<svg class="icon-inline utility-icon icon-lg"><use xlink:href="#world"/></svg>
		</span>
		<div class="utility-text d-flex align-items-center text-uppercase ml-1 ml-md-0">
			{% for language in languages if language.active %}
				{{ language.country }}
			{% endfor %}
			{% if dropdown %}
				<svg class="icon-inline icon-lg icon-rotate-90 ml-1"><use xlink:href="#chevron"/></svg>
			{% endif %}
		</div>
{% if dropdown %}
		<div class="nav-dropdown-content desktop-dropdown desktop-dropdown-small">
			{% include 'snipplets/navigation/navigation-languages.tpl' %}
		</div>
	</span>
{% else %}
	</button>
{% endif %}