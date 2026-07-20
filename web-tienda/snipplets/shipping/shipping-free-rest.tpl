{% if product_detail %}
	
	{% if not product.free_shipping %}
		{# Wording to notice that adding one more product free shipping is achieved #}

		<div class="js-shipping-add-product-label font-weight-bold mb-4" style="display: none;">
			<span class='js-fs-add-this-product'>{{ "¡Agregá este producto y " | translate }}</span>
			<span class='js-fs-add-one-more' style='display: none;'>{{ "¡Agregá uno más y " | translate }}</span>
			<strong class='text-accent'>{{ "tenés envío gratis!" | translate }}</strong>
		</div>
	{% endif %}

{% else %}

	<div class="js-fulfillment-info js-allows-non-shippable" {% if not cart.has_shippable_products %}style="display: none"{% endif %}>

		{# Free shipping progress bar #}
		<div class="js-ship-free-rest shipping-progress-bar box font-medium py-4">
			<div class="js-bar-progress bar-progress">
				<div class="js-bar-progress-active bar-progress-active transition-soft"></div>
			</div>
			<div class="js-ship-free-rest-message ship-free-rest-message">
				<div class="ship-free-rest-text bar-progress-success font-big text-accent transition-soft">
					{{ "¡Genial! Tenés envío gratis" | translate }}
				</div>
				<div class="ship-free-rest-text bar-progress-amount transition-soft">
					{{ "¡Estás a <span class='js-ship-free-dif font-big'></span> de tener <span class='text-accent'>envío gratis</span>!" | translate }}
				</div>
				<div class="ship-free-rest-text bar-progress-condition transition-soft">
					<span class="text-accent font-big">{{ "Envío gratis" | translate }}</span> {{ "superando los" | translate }} <span>{{ cart.free_shipping.min_price_free_shipping.min_price }}</span>
				</div>
			</div>
		</div>
	</div>
{% endif %}