{# Cart utility #}

{% set utility_icon_md_color_class = settings.desktop_utility_colors ? 'utility-icon-md-colors' %}
{% set utility_icon_only_md_color_class = settings.desktop_utility_colors and settings.utilities_type_desktop == 'icons' ? 'utility-icon-md-big' %}
{% set utility_badge_md_spacing_class = settings.desktop_utility_colors and settings.utilities_type_desktop == 'icons' ? 'mt-2' %}
{% set cart_icon = settings.utilities_cart_icon == 'cart' ? 'cart' : 'bag' %}

<span id="ajax-cart" data-component='cart-button'>
	<a 
		{% if settings.ajax_cart and template != 'cart' %}
			href="#"
			data-target="#modal-cart"
		{% else %}
			href="{{ store.cart_url }}" 
		{% endif %}
		class="{% if settings.ajax_cart and template != 'cart' %}js-modal-open-private{% endif %} header-utility"
		>
		<span class="js-header-utility-icon header-icon-big {{ utility_icon_md_color_class }} {{ utility_icon_only_md_color_class }}">
			<svg class="js-utility-cart-icon icon-inline utility-icon icon-lg"><use xlink:href="#{{ cart_icon }}"/></svg>
			<span class="js-cart-widget-amount badge {{ utility_badge_md_spacing_class }} {% if settings.utilities_type_desktop == 'icons_text' %}d-md-none{% endif %}">{{ "{1}" | translate(cart.items_count ) }}</span>
		</span>
		{% if settings.utilities_type_desktop == 'icons_text' or params.preview %}
			<div class="js-header-utility-text js-header-utility-text-cart utility-text d-none {% if settings.utilities_type_desktop == 'icons_text' %}d-md-grid{% endif %}" {% if settings.utilities_type_desktop == 'icons' %}style="display: none;"{% endif %}>
				<div class="font-weight-bold d-flex">
					<span class="mr-1">{{ 'Carrito' | translate }}</span>
					<span>(<span class="js-cart-widget-amount">{{ "{1}" | translate(cart.items_count ) }}</span>)</span>
				</div>
				<div class="js-cart-widget-total {% if cart.items_count != '0' %}d-md-inline-block{% endif %}" data-priceraw="{{ cart.total }}">{{ cart.total | money }}</div>
			</div>
		{% endif %}
	</a>	
</span>