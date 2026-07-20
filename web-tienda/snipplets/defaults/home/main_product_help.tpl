{# Main product that work as example #}

{% include "snipplets/svg/empty-placeholders.tpl" %}

{% set product_view_box = '0 0 1000 1000' %}
{% set product_promotional_price = store.country == 'BR' ? "18200" : "182000" %}
{% set product_regular_price = store.country == 'BR' ? "28000" : "280000" %}

<section class="section-featured-home" data-store="home-product-main">
	<div class="container mt-3 py-4">
		<div class="product-columns mb-4">
			<div class="product-images mb-4 mb-md-0">
				<div class="product-images-slider position-relative mb-md-0 mb-3">
					<div class="d-block p-relative">
						<svg viewBox='{{ product_view_box }}'><use xlink:href="#item-product-placeholder-3"/></svg>
					</div>
				</div>
				<div class="product-images-thumbs order-md-first text-md-center grid grid-6 d-md-block">
					<div class="product-thumb mb-md-2">
						<svg viewBox='{{ product_view_box }}'><use xlink:href="#item-product-placeholder-3"/></svg>
					</div>
					<div class="product-thumb mb-md-2">
						<svg viewBox='{{ product_view_box }}'><use xlink:href="#product-image-green-placeholder"/></svg>
					</div>
					<div class="product-thumb">
						<svg viewBox='{{ product_view_box }}'><use xlink:href="#product-image-red-placeholder"/></svg>
					</div>
				</div>
			</div>
			<div class="product-info pt-md-3">
				{% if product_detail %}
					<div class="breadcrumbs font-small mb-2">
						<a class="crumb" href="{{ store.url }}" title="{{ store.name }}">{{ "Inicio" | translate }}</a>
						<span class="separator">></span>
						<a class="crumb" href="{{ store.products_url }}" title="{{ "Productos" | translate }}">{{ "Productos" | translate }}</a>
						<span class="separator">></span>
						<span class="crumb active">{{ "Producto de ejemplo" | translate }}</span>
					</div>
				{% endif %}
				<div class="h4 mb-3">{{ "Producto de ejemplo" | translate }}</div>
				<div class="price-container mb-3">
					<div id="compare_price_display" class="js-compare-price-display price-compare" style="display:block;">{{ product_regular_price | money }}</div>
					<div class="d-flex align-items-center">
						<span class="js-price-display h3 font-family-body" id="price_display">{{product_promotional_price | money }}</span>
						<span class="font-family-body font-big text-accent ml-2">
						   -35% OFF
						</span>
					</div>
				</div>
				{# Product installments #}
				<div class="font-medium mb-3">{{ "Hasta 12 cuotas" | translate }}</div>

				{# Product form, includes: Variants, CTA and Shipping calculator #}
				<div class="js-product-form">
					<div class="js-product-variants grid grid-2 mb-3">
						<div class="form-group">
							<label class="form-label" for="variation_1">{{ "Color" | translate }}</label>
							<select id="variation_1" class="form-select js-variation-option js-refresh-installment-data  " name="variation[0]">
								<option value="{{ "Verde" | translate }}">{{ "Verde" | translate }}</option>
								<option value="{{ "Rojo" | translate }}">{{ "Rojo" | translate }}</option>
							</select>
							<div class="form-select-icon">
								<svg class="icon-inline icon-w-14"><use xlink:href="#chevron-down"/></svg>
							</div>
						</div>
					</div>
					<div class="grid grid-auto-1 mb-4">
						<div class="form-quantity-container">
							{% embed "snipplets/forms/form-input.tpl" with{
							type_number: true, input_value: '1',
							input_name: 'quantity' ~ item.id, 
							input_custom_class: 'js-quantity-input', 
							input_label: false, 
							input_append_content: true, 
							input_group_custom_class: 'js-quantity form-quantity', 
							form_control_container_custom_class: 'px-0',
							form_data_component: 'product.adding-amount',
							form_control_quantity: true,
							input_min: '1',
							data_component: 'adding-amount.value',
							input_aria_label: 'Cambiar cantidad' | translate } %}
								{% block input_prepend_content %}
								<div class="grid grid-3-auto grid-no-gap align-items-center" data-component="product.quantity">
									<span class="js-quantity-down form-quantity-icon btn icon-45px" data-component="product.quantity.minus">
										<svg class="icon-inline"><use xlink:href="#minus"/></svg>
									</span>
								{% endblock input_prepend_content %}
								{% block input_append_content %}
									<span class="js-quantity-up form-quantity-icon btn icon-45px" data-component="product.quantity.plus">
										<svg class="icon-inline"><use xlink:href="#plus"/></svg>
									</span>
								</div>
								{% endblock input_append_content %}
							{% endembed %}
						</div>
						<div class="cart-button-container">
							<input type="submit" class="btn btn-primary btn-block" value="{{ 'Agregar al carrito' | translate }}" />
						</div>
					</div>
				</form>
				{# Product description #}
				<div class="user-content mb-4">
					<p>{{ "¡Este es un producto de ejemplo! Para poder probar el proceso de compra, debes" | translate }}
						<a href="/admin/products" target="_top">{{ "agregar tus propios productos." | translate }}</a>
					</p>
				</div>
			</div>
		</div>
	</div>
</section>