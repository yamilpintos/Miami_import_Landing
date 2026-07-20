{# Account utility #}

{% set utility_icon_md_color_class = settings.desktop_utility_colors ? 'utility-icon-md-colors' %}
{% set utility_icon_only_md_color_class = settings.desktop_utility_colors and settings.utilities_type_desktop == 'icons' ? 'utility-icon-md-big' %}

{% set account_icon_visibility_classes = settings.utilities_type_desktop == 'icons_text' ? 'd-md-none' %}

<span class="js-header-utility-icon js-header-utility-icon-only header-utility {{ account_icon_visibility_classes }} {{ utility_icon_md_color_class }} {{ utility_icon_only_md_color_class }}" {% if settings.utilities_type_desktop == 'icons_text' and params.preview %}style="display: none;"{% endif %}>
	{% set account_url = not customer ? store.customer_login_url : store.customer_home_url %}
	{% if mobile %}
		<span class="font-medium">
	{% else %}
		<a href="{{ account_url }}" class="header-icon">
	{% endif %}
		<svg class="icon-inline utility-icon icon-lg"><use xlink:href="#user"/></svg>
		{% if mobile %}
			{% set register_link = 'mandatory' not in store.customer_accounts %}
			{% if not customer %}
				{{ "Mi cuenta" | translate | a_tag(store.customer_login_url, '', 'ml-1') }}
			{% else %}
				{% set customer_short_name = customer.name|split(' ')|slice(0, 1)|join %} 
				{{ "¡Hola, {1}!" | t(customer_short_name) | a_tag(store.customer_home_url, '', 'ml-1 mr-1') }}
				/
				{{ "Cerrar sesión" | translate | a_tag(store.customer_logout_url, '', 'ml-1') }}
			{% endif %}		
		{% endif %}
	{% if mobile %}
		</span>
	{% else %}
		</a>
	{% endif %}
</span>
{% if (settings.utilities_type_desktop == 'icons_text' or params.preview) and not mobile %}
	<span class="js-header-utility-with-text header-utility d-none {% if settings.utilities_type_desktop == 'icons_text' %}d-md-grid{% endif %}" {% if settings.utilities_type_desktop == 'icons' %}style="display: none;"{% endif %}>
		<span class="js-header-utility-icon {{ utility_icon_md_color_class }}">
			<svg class="icon-inline utility-icon icon-lg"><use xlink:href="#user"/></svg>
		</span>
		<span class="utility-text">
			{% set register_link = 'mandatory' not in store.customer_accounts %}
			{% if not customer %}
				<div class="font-weight-bold">
					{{ "Entrá" | translate | a_tag(store.customer_login_url, '', '') }} {% if register_link %}/{% endif %}
				</div>
				{% if register_link %}
					<div>
						{{ "Registráte" | translate | a_tag(store.customer_register_url, '', '') }}
					</div>
				{% endif %}
			{% else %}
				{% set customer_short_name = customer.name|split(' ')|slice(0, 1)|join %} 
				<div class="font-weight-bold">
					{{ "¡Hola, {1}!" | t(customer_short_name) | a_tag(store.customer_home_url, '', '') }}
				</div>
				<div>
					{{ "Cerrar sesión" | translate | a_tag(store.customer_logout_url, '', '') }}
				</div>
			{% endif %}		
		</span>
	</span>
{% endif %}