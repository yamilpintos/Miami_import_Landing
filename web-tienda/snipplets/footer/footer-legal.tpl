{% set has_payment_logos = settings.payments %}
{% set has_shipping_logos = settings.shipping %}
{% set has_shipping_payment_logos = has_payment_logos or has_shipping_logos %}
{% set has_seal_logos = store.afip or ebit or settings.custom_seal_code or ("seal_img.jpg" | has_custom_image) %}

{% if has_shipping_payment_logos %}
	<div class="footer-payments-shipping-container d-md-flex">
		{# Logos Payments and Shipping #}

		{% set payment_shipping_container_classes = 'mr-md-3 mb-3 mb-md-0' %}
		{% set payment_shipping_title_classes = 'd-block d-md-inline-block align-middle mb-2 mr-md-2' %}

		{% if has_payment_logos %}
			<div class="{{ payment_shipping_container_classes }} mr-3">
				<span class="{{ payment_shipping_title_classes }}">{{ "Medios de pago" | translate }}</span>
				<span class="d-inline-block align-middle">
					{{ component('payment-shipping-logos', {'type' : 'payments'}) }}
				</span>
			</div>
		{% endif %}

		{% if has_shipping_logos %}
			<div class="{{ payment_shipping_container_classes }}">
				<span class="{{ payment_shipping_title_classes }}">{{ "Medios de envío" | translate }}</span>
				<span class="d-inline-block align-middle">
					{{ component('payment-shipping-logos', {'type' : 'shipping'}) }}
				</span>
			</div>
		{% endif %}

	</div>
{% endif %}
<div class="footer-legal-container font-small">
	{% if has_seal_logos %}
		<div class="footer-seals-container mb-4">
			<div class="footer-seals-container">
				{# AFIP - EBIT - Custom Seal #}
				{% if store.afip or ebit %}
					{% if store.afip %}
						<div class="footer-logo afip seal-afip">
							{{ store.afip | raw }}
						</div>
					{% endif %}
					{% if ebit %}
						<div class="footer-logo ebit seal-ebit">
							{{ ebit }}
						</div>
					{% endif %}
				{% endif %}
				{% if "seal_img.jpg" | has_custom_image or settings.custom_seal_code %}
					{% if "seal_img.jpg" | has_custom_image %}
						<div class="footer-logo custom-seal">
							{% if settings.seal_url != '' %}
								<a href="{{ settings.seal_url | setting_url }}" target="_blank">
							{% endif %}
								{{ component(
									'image',{
										image_name: 'seal_img.jpg',
										image_classes: 'custom-seal-img',
										image_alt: 'Sello de' | translate ~ store.name,
									})
								}}
							{% if settings.seal_url != '' %}
								</a>
							{% endif %}
						</div>
					{% endif %}
					{% if settings.custom_seal_code %}
						<div class="custom-seal custom-seal-code">
							{{ settings.custom_seal_code | raw }}
						</div>
					{% endif %}
				{% endif %}
			</div>
		</div>
	{% endif %}
	<div>
		{{ component('claim-info', {
				container_classes: "d-md-inline-block mb-3  mb-md-2",
				text_classes: {text_consumer_defense: 'd-inline-block'},
				link_classes: {
					link_consumer_defense: "btn-link font-small",
					link_order_cancellation: "btn-link font-small",
				},
			}) 
		}}
		<div>
			<span class="d-block d-md-inline-block mb-2 mb-md-0 mr-1">
				{#
				La leyenda que aparece debajo de esta linea de código debe mantenerse
				con las mismas palabras y con su apropiado link a Tienda Nube;
				como especifican nuestros términos de uso: http://www.tiendanube.com/terminos-de-uso .
				Si quieres puedes modificar el estilo y posición de la leyenda para que se adapte a
				tu sitio. Pero debe mantenerse visible para los visitantes y con el link funcional.
				Os créditos que aparece debaixo da linha de código deverá ser mantida com as mesmas
				palavras e com seu link para Nuvem Shop; como especificam nossos Termos de Uso:
				http://www.nuvemshop.com.br/termos-de-uso. Se você quiser poderá alterar o estilo
				e a posição dos créditos para que ele se adque ao seu site. Porém você precisa
				manter visivél e com um link funcionando.
				#}
				{{ new_powered_by_link }}
			</span>
			<span class="d-block d-md-inline-block align-super">
				{{ "Copyright {1} - {2}. Todos los derechos reservados." | translate( (store.business_name ? store.business_name : store.name) ~ (store.business_id ? ' - ' ~ store.business_id : ''), "now" | date('Y') ) }}
			</span>
		</div>
	</div>
</div>