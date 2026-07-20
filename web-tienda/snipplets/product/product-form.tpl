<div class="pt-md-3">

	{# Breadcrumbs removidos a pedido de Miami Import — pagina limpia #}

	{% set accent_label_classes = 'label label-big label-accent mt-3 mb-2' %}

	{% set custom_label = product.getPromotionCustomLabel %}
	{% set has_custom_promotion_label = custom_label and custom_label | trim %}

	{% if has_custom_promotion_label %}
		<div class="{{ accent_label_classes }}">{{ custom_label }}</div>
	{% endif %}

	{% set promotion_title_classes = has_custom_promotion_label ? 'font-medium text-accent mt-3 mb-2' : accent_label_classes %}

	{{ component('promotions-details', {
		promotions_details_classes: {
			container: 'js-product-promo-container mb-3',
			promotion_title: promotion_title_classes,
			valid_scopes: 'font-small mb-0',
			categories_combinable: 'font-small mb-0',
			not_combinable: 'font-small opacity-60',
			progressive_discounts_table: 'table mb-2',
			progressive_discounts_hidden_table: 'table-body-inverted',
			progressive_discounts_show_more_link: 'btn-link btn-link-primary mb-4',
			progressive_discounts_show_more_icon: 'icon-inline',
			progressive_discounts_hide_icon: 'icon-inline icon-flip-vertical',
			progressive_discounts_promotion_quantity: 'font-weight-light text-lowercase'
		},
		accordion_show_svg_id: 'chevron-down',
		accordion_hide_svg_id: 'chevron-down',
	}) }}

	{# Sold products quantity #}

	{% set products_sold_limit = settings.quantity_products_sold ? settings.quantity_products_sold : 0 %}
	{% if settings.products_sold and (product.sold_qty > products_sold_limit) %}
		<div class="font-small mt-3 mb-2">
			{% if product.sold_qty > 10 %}
				+{{ (product.sold_qty/ 10)|round(0, 'floor') * 10 }}
			{% else %}
				{{ product.sold_qty }}
			{% endif %}
			{{ "vendidos" | translate }}
		</div>
	{% endif %}

	{# Product name #}

	{{ component('nubesdk-slot', { type: "before_product_detail_name" }) }}

	{% if home_main_product %}
		<h2 class="js-product-name h4 mb-3">{{ product.name }}</h2>
	{% else %}
		{# Product SKU #}
		{% if settings.product_sku and product.sku %}
			<div class="font-small opacity-60 mt-3 mb-2">
				{{ "SKU" | translate }}: <span class="js-product-sku">{{ product.sku }}</span>
			</div>
		{% endif %}

		<h1 class="js-product-name h4 mb-3" data-store="product-name-{{ product.id }}">{{ product.name }}</h1>

		{{ component('nubesdk-slot', { type: "after_product_detail_name" }) }}
	{% endif %}


	{# Product price #}

	{% set is_subscription_only_product = product.isSubscribable() and product.isSubscriptionOnly() %}

	{{ component('nubesdk-slot', { type: "before_product_detail_price" }) }}
	
	{% if product.compare_at_price > product.price %}
		{% set discount_rate_percentage = ((product.compare_at_price) - (product.price)) * 100 / (product.compare_at_price) %}
	{% endif %}
	{% if not is_subscription_only_product %}
	<div class="js-price-container price-container mb-3" data-store="product-price-{{ product.id }}">
		<div id="compare_price_display" class="js-compare-price-display price-compare font-medium" {% if not product.compare_at_price or not product.display_price %}style="display:none;"{% else %} style="display:block;"{% endif %}>
			{% if product.compare_at_price and product.display_price %}
				{{ product.compare_at_price | money }}
			{% endif %}
		</div>
		<div class="d-flex align-items-center">
			<span class="js-price-display h3 font-family-body" id="price_display" {% if not product.display_price %}style="display:none;"{% endif %} data-product-price="{{ product.price }}">
				{% if product.display_price %}
					{{ product.price | money }}
				{% endif %}
			</span>
			<span class="font-family-body font-big text-accent ml-2" {% if not product.compare_at_price %}style="display:none;"{% endif %}>
				<span class="js-offer-percentage">{{ discount_rate_percentage | round }}</span>% OFF
			</span>
		</div>
		{% set show_compare_price_saved_amount = not (settings.payment_discount_price and product.maxPaymentDiscount.value > 0) and settings.compare_price_saved_money %}

		{{ component('compare-price-saved-amount', {
				visibility_condition: show_compare_price_saved_amount,
				discount_percentage: false,
				container_classes: "d-flex align-items-center mt-1 text-accent",
				text_classes: {
					amount_message_container: 'd-inline-block font-big',
				},
			})
		}}

		{% set price_discount_disclaimer_margin_class = show_compare_price_saved_amount ? 'mt-2' : 'mt-1' %}

		{{ component('price-discount-disclaimer', {
			container_classes: 'font-small opacity-60 ' ~ price_discount_disclaimer_margin_class ~ ' mb-2',
		}) }}

		{{ component('price-without-taxes', {
				container_classes: "mt-1 mb-2 font-small opacity-60",
			})
		}}

		{{ component('payment-discount-price', {
				visibility_condition: settings.payment_discount_price,
				location: 'product',
				container_classes: "mt-1 mb-3 font-big text-accent",
				text_classes: {
					price: 'h5 font-family-body'
				}
			})
		}}
	</div>
	{% endif %}

	{{ component('subscriptions/subscription-price', {
		location: is_subscription_only_product ? 'product_detail',
		subscription_classes: {
			container: 'mb-3',
			prices_container: 'd-flex flex-wrap align-items-center mb-1',
			price_compare: 'price-compare font-medium w-100',
			price_with_subscription: 'h3 font-family-body mr-2 mb-1',
			discount: 'font-big text-accent',
			price_without_taxes_container: 'mt-1 mb-2 font-small opacity-60',
		},
		subscription_discount_position: 'inline',
	}) }}

	{{ component('nubesdk-slot', { type: "after_product_detail_price" }) }}

	{% set installments_info = product.installments_info_from_any_variant %}
	{% set hasDiscount = product.maxPaymentDiscount.value > 0 %}
	{% set show_payments_info = settings.product_detail_installments and product.show_installments and product.display_price and installments_info %}

	{% if not home_main_product and (show_payments_info or hasDiscount) %}
		<div {% if installments_info %}data-target="#installments-modal"{% endif %} class="{% if installments_info %}js-modal-open-private js-fullscreen-modal-open{% endif %} js-product-payments-container mt-1 mb-3 px-0" {% if not product.display_price or not (product.get_max_installments and product.get_max_installments(false)) %}style="display: none;"{% endif %}>
	{% endif %}
		{% if show_payments_info %}
			{{ component('installments', {'location' : 'product_detail', container_classes: { installment: "mb-2 font-medium"}}) }}
		{% endif %}

		{% set hideDiscountContainer = not (hasDiscount and product.showMaxPaymentDiscount) %}
		{% set hideDiscountDisclaimer = not product.showMaxPaymentDiscountNotCombinableDisclaimer %}

		<div class="js-product-discount-container mb-2 font-medium" {% if hideDiscountContainer %}style="display: none;"{% endif %}>
			<span class="text-accent">{{ product.maxPaymentDiscount.value }}% {{'de descuento' | translate }}</span> {{'pagando con' | translate }} {{ product.maxPaymentDiscount.paymentProviderName }}
			<div class="js-product-discount-disclaimer font-small mt-1 opacity-60" {% if hideDiscountDisclaimer %}style="display: none;"{% endif %}>
                {{ (product.showMaxPaymentDiscountCombinesWithSomeDiscounts
                    ? "No acumulable con algunas promociones"
                    : "No acumulable con otras promociones")
                | translate }}
			</div>
		</div>
	{% if not home_main_product and (show_payments_info or hasDiscount) %}
			<a id="btn-installments" class="d-inline-block btn-link font-small" href="#" {% if not (product.get_max_installments and product.get_max_installments(false)) %}style="display: none;"{% endif %}>
				{% if not hasDiscount and not settings.product_detail_installments %}
					{{ "Ver medios de pago" | translate }}
				{% else %}
					{{ "Ver más detalles" | translate }}
				{% endif %}
			</a>
		</div>
	{% endif %}

	{# Product form, includes: Variants, CTA and Shipping calculator #}

	<form id="product_form" class="js-product-form mt-4" method="post" action="{{ store.cart_url }}" data-store="product-form-{{ product.id }}">
		<input type="hidden" name="add_to_cart" value="{{product.id}}" />

		{# Product availability #}
		{% set show_product_quantity = product.available and product.display_price %}

		{# Gift promotion message #}

		{{ component('gift-promotion-message', {
			gift_svg_id: 'gift',
			container_classes: {
				container: 'font-medium mb-4',
				icon: 'icon-inline svg-icon-accent icon-lg float-left mr-2',
				highlight: 'text-accent',
			},
		}) }}

		{# Free shipping minimum message #}
		{% set has_free_shipping = cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price %}
		{% set has_product_free_shipping = product.free_shipping %}

		{% if not product.is_non_shippable and show_product_quantity and (has_free_shipping or has_product_free_shipping) %}
			<div class="js-free-shipping-minimum-message free-shipping-message font-medium mb-4">
				<span class="float-left mr-2">
					<svg class="icon-inline svg-icon-accent icon-lg"><use xlink:href="#truck"/></svg>
				</span>
				<span>
					<span class="text-accent">{{ "Envío gratis" | translate }}</span>
					<span {% if has_product_free_shipping %}style="display: none;"{% else %}class="js-shipping-minimum-label"{% endif %}>
						{{ "superando los" | translate }} <span>{{ cart.free_shipping.min_price_free_shipping.min_price }}</span>
					</span>
				</span>
				{% if not has_product_free_shipping %}
					<div class="js-free-shipping-discount-not-combinable font-small opacity-60 mt-1">
						{{ "No acumulable con otras promociones" | translate }}
					</div>
				{% endif %}
			</div>
		{% endif %}

		{% if template == "product" %}
			{% set show_size_guide = true %}
		{% endif %}

		{% if product.variations %}
			{% include "snipplets/product/product-variants.tpl" with {show_size_guide: show_size_guide} %}
		{% endif %}

		{% if settings.last_product and show_product_quantity %}
			<div class="{% if product.variations %}js-last-product {% endif %}text-stock font-big mb-4" style="display: none;">
				{{ settings.last_product_text }}
			</div>
			{% if settings.latest_products_available %}
				{% set latest_products_limit = settings.latest_products_available %}
				<div class="{% if product.variations %}js-latest-products-available {% endif %}text-stock font-big mb-4" data-limit="{{ latest_products_limit }}" {% if product.selected_or_first_available_variant.stock > latest_products_limit or product.selected_or_first_available_variant.stock == null or product.selected_or_first_available_variant.stock == 1 %} style="display: none;"{% endif %}>
					{{ "¡Solo quedan" | translate }} <span class="js-product-stock">{{ product.selected_or_first_available_variant.stock }}</span> {{ "en stock!" | translate }}
				</div>
			{% endif %}
		{% endif %}

		{% if product.is_kit %}
			{{ component('kit_products', {
				kit_products_classes: {
					container: 'mb-4',
					list: 'list-unstyled mb-0',
					item: 'd-flex align-items-center pt-2 pb-2',
					image_wrap: 'flex-shrink-0 mr-3',
					image: 'kit-products-item-img',
					text: 'flex-grow-1 min-w-0 font-small',
					quantity: 'font-small',
					name: 'kit-products-item-name font-medium mb-0',
				},
			}) }}
		{% endif %}

		{{ component('nubesdk-slot', { type: "before_product_detail_add_to_cart" }) }}

		<div class="{% if show_product_quantity and not product.isSubscribable() %}grid grid-auto-1{% endif %} mb-4">
			{% set product_quantity_home_product_value = home_main_product ? true : false %}
			{% if show_product_quantity %}
				{% include "snipplets/product/product-quantity.tpl" with {home_main_product: product_quantity_home_product_value} %}
			{% endif %}

		{{ component('subscriptions/subscription-selector', {
			allow_subscription_only: is_subscription_only_product,
			subscription_only_container: '',
			subscription_classes: {
					container: 'radio-button-container mt-4 mb-2',

					radio_button: 'radio-button-accent',
					radio_button_text: 'd-grid grid-1-auto',
					radio_button_icon: 'radio-button-icons',
					radio_button_icon_svg: 'icon-inline icon-sm svg-icon-primary',
					purchase_option_info_container: '',
					purchase_option_name: 'font-weight-bold',
					purchase_option_price: 'text-right',
					purchase_option_single_frequency: 'mt-2 pt-1 font-small opacity-80',
					purchase_option_discount: 'label label-accent label-small ml-1',

					dropdown_container: 'form-group mt-3 mb-0',
					dropdown_button: 'form-select p-2 position-relative',
					dropdown_icon: 'form-select-icon icon-inline icon-sm',
					dropdown_options: 'form-select-options',
					dropdown_option: 'form-select-option d-grid grid-1-auto',
					dropdown_option_info: 'font-medium',
					dropdown_option_price: 'font-small',
					dropdown_option_discount: 'text-accent mt-1 font-small font-weight-bold',

					cart_alert: 'font-small text-center mt-2 pb-3',
					cart_alert_icon: 'icon-inline mr-1',
					shipping_message: 'mb-3',
					shipping_message_title_container: 'font-medium d-flex align-items-center mb-2',
					shipping_message_icon: 'icon-inline icon-lg svg-icon-text mr-2',
					shipping_message_title: 'ml-1',
					shipping_message_text: 'box font-small',

					legal_message: 'font-smallest text-center mb-2 pb-1',
					legal_link: 'font-smallest btn-link',
					legal_modal: 'bottom modal-width-small modal-md-width-small',
					legal_modal_close_icon: 'icon-inline',
					legal_modal_details_title: 'font-medium mb-3',
					legal_modal_details_paragraph: 'font-small pb-4 mb-0',
					legal_modal_details_link: 'font-small btn-link'
				},
				dropdown_icon: true,
				dropdown_icon_svg_id: 'chevron-down',

				cart_alert_icon: true,
				cart_alert_icon_svg_id: 'info-circle',

				shipping_message_icon: true,
				shipping_message_icon_svg_id: 'truck',

				legal_modal_close_icon_id: 'times',
			}) }}

			{% set state = store.is_catalog ? 'catalog' : (product.available ? product.display_price ? 'cart' : 'contact' : 'nostock') %}
			{% set texts = {'cart': "Agregar al carrito", 'contact': "Consultar precio", 'nostock': "Sin stock", 'catalog': "Consultar"} %}
			<div class="cart-button-container {% if product.isSubscribable() %}mt-2{% endif %}">

				{# Add to cart CTA #}

				<input type="submit" class="js-addtocart js-prod-submit-form btn btn-primary btn-big btn-block {{ state }}" value="{{ texts[state] | translate }}" {% if state == 'nostock' %}disabled{% endif %} data-store="product-buy-button" data-component="product.add-to-cart"/>

				{# Fake add to cart CTA visible during add to cart event #}

				{% include 'snipplets/placeholders/button-placeholder.tpl' with {custom_class: "w-100"} %}

			</div>
		</div>
		{% if settings.ajax_cart %}
			<div class="js-added-to-cart-product-message grid grid-auto-1 grid-no-gap align-items-center font-small mt-3 mb-4 pb-2" style="display: none;">
				<svg class="icon-inline icon-lg svg-icon-text mr-2"><use xlink:href="#check"/></svg>
				<span>
					{{'Ya agregaste este producto.' | translate }}<a href="#" class="js-modal-open-private btn-link font-small ml-1" data-target="#modal-cart">{{ 'Ver carrito' | translate }}</a>
				</span>
			</div>
		{% endif %}

		{{ component('nubesdk-slot', { type: "after_product_detail_add_to_cart" }) }}

	</form>

	{% if not home_main_product %}
		{# Product informative banners #}
		<div class="pb-4">
			{% include 'snipplets/product/product-informative-banner.tpl' %}
		</div>

		{# Shipping and pickup options #}

		{% set show_product_fulfillment = settings.shipping_calculator_product_page and (store.has_shipping or store.branches) and not product.free_shipping and not product.is_non_shippable %}

		{% if show_product_fulfillment %}
			<div class="pb-4 w-md-80">
				{# Shipping calculator and branch link #}

				<div id="product-shipping-container" class="product-shipping-calculator list" {% if not product.display_price or not product.has_stock %}style="display:none;"{% endif %} data-shipping-url="{{ store.shipping_calculator_url }}">
					{% if store.has_shipping %}
						{% include "snipplets/shipping/shipping-calculator.tpl" with {'shipping_calculator_variant' : product.selected_or_first_available_variant, 'product_detail': true} %}
					{% endif %}
				</div>

				{% if store.branches %}
					{# Link for branches #}
					{% include "snipplets/shipping/branches.tpl" with {'product_detail': true} %}
				{% endif %}
			</div>

		{% endif %}
	{% endif %}
</div>

{% if not home_main_product %}
	{# Product payments details #}
	{% include 'snipplets/product/product-payment-details.tpl' %}
{% endif %}
