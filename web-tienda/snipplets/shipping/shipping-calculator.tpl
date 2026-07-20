{# Check if store has free shipping without regions or categories #}

{% set has_free_shipping = cart.free_shipping.cart_has_free_shipping or cart.free_shipping.min_price_free_shipping.min_price %}

{# Free shipping visibility variables #}

{% set free_shipping_messages_visible = (product_detail and has_free_shipping) or (not product_detail and has_free_shipping and cart.free_shipping.min_price_free_shipping.min_price_raw == 0) %}

{% set cart_zipcode = product_detail ? false : cart.shipping_zipcode %}

<div data-store="shipping-calculator">
	<div class="js-shipping-calculator-head shipping-calculator-head position-relative transition-soft {% if cart_zipcode %}with-zip{% else %}with-form{% endif %} {% if free_shipping_messages_visible %}with-free-shipping{% endif %} {% if store.branches %}mb-4{% endif %}">
 		<div class="js-shipping-calculator-with-zipcode {% if cart_zipcode %}js-cart-saved-zipcode transition-up-active{% endif %} mb-4 w-100 transition-up position-absolute">
			<div class="d-grid grid-1-auto align-items-center">
				<span class="font-small mr-3">
					<span>{{ "Entregas para el CP:" | translate }}</span>
					<strong class="js-shipping-calculator-current-zip">{{ cart_zipcode }}</strong>
				</span>
				<span>
					<a class="js-shipping-calculator-change-zipcode btn btn-link font-small" href="#">{{ "Cambiar CP" | translate }}</a>
				</span>
			</div>
		</div>

		<div class="js-shipping-calculator-form shipping-calculator-form transition-up position-absolute w-100">

			{# Shipping calcualtor input #}

			{% embed "snipplets/forms/form-input.tpl" with{type_tel: true, input_value: cart_zipcode, input_name: 'zipcode', input_custom_class: 'js-shipping-input', input_placeholder: "Tu código postal" | translate, input_aria_label: 'Tu código postal' | translate, input_label: false, input_append_content: true, input_group_custom_class: '', form_control_container_custom_class: 'input-append mb-1'} %}

				{# Input label #}

				{% block input_prepend_content %}
					<div class="form-label">
						{{ "Medios de envío" | translate }}
					</div>
				{% endblock input_prepend_content %}

				{# Input button #}

				{% block input_add_on %}
					<button class="js-calculate-shipping btn btn-inline" aria-label="{{ 'Calcular envío' | translate }}">	
						<span class="js-calculate-shipping-wording">{{ "Calcular" | translate }}</span>
						<span class="js-calculating-shipping-wording" style="display: none;">{{ "Calculando" | translate }}</span>
						<span class="float-right loading ml-2" style="display: none;">
							<svg class="icon-inline icon-smd icon-spin svg-icon-text"><use xlink:href="#spinner-third"/></svg>
						</span>
					</button>
					{% if shipping_calculator_variant %}
						<input type="hidden" name="variant_id" id="shipping-variant-id" value="{{ shipping_calculator_variant.id }}">
					{% endif %}
				{% endblock input_add_on %}

				{# Help info #}

				{% block input_append_content %}
					{% set zipcode_help_countries = ['BR', 'AR', 'MX'] %}
					{% if store.country in zipcode_help_countries %}
						{% set zipcode_help = 
							store.country == 'AR' ? 'https://www.correoargentino.com.ar/formularios/cpa' :
							store.country == 'BR' ? 'http://www.buscacep.correios.com.br/sistemas/buscacep/' :
							store.country == 'MX' ? 'https://www.correosdemexico.gob.mx/SSLServicios/ConsultaCP/Descarga.aspx'
						%}
						<a class="{% if product_detail %}js-shipping-zipcode-help{% endif %} btn btn-link font-small" href="{{ zipcode_help }}" target="_blank">{{ "No sé mi código postal" | translate }}</a>
					{% endif %}
				{% endblock input_append_content%}
				
				{# Alerts #}

				{% block input_form_alert %}
					<div class="mt-2">
						<div class="js-ship-calculator-error invalid-zipcode alert alert-danger mb-0" style="display: none;">
							
							{# Specific error message considering if store has multiple languages #}

							{% for language in languages %}
								{% if language.active %}
									{% if languages | length > 1 %}
										{% set wrong_zipcode_wording = ' para ' | translate ~ language.country_name ~ '. Podés intentar con otro o' | translate %}
									{% else %}
										{% set wrong_zipcode_wording = '. ¿Está bien escrito?' | translate %}
									{% endif %}
									{{ "No encontramos este código postal{1}" | translate(wrong_zipcode_wording) }}

									{% if languages | length > 1 %}
										{% set language_modal_target = product_detail ? 'product' : 'cart' %}
										<button data-target="#modal-{{ language_modal_target }}-shipping-country" class="js-modal-open-private btn btn-link font-small">{{ 'cambiar tu país de entrega' | translate }}</button>
									{% endif %}
								{% endif %}
							{% endfor %}
						</div>
						<div class="js-ship-calculator-error js-ship-calculator-common-error alert alert-danger mb-0" style="display: none;">{{ "Ocurrió un error al calcular el envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
						<div class="js-ship-calculator-error js-ship-calculator-external-error alert alert-danger mb-0" style="display: none;">{{ "El calculo falló por un problema con el medio de envío. Por favor intentá de nuevo en unos segundos." | translate }}</div>
					</div>
				{% endblock input_form_alert %}
			{% endembed %}
		</div>
	</div>
	<div class="js-shipping-calculator-spinner pb-4" style="display: none;">
		{% include "snipplets/placeholders/shipping-placeholder.tpl"%}
	</div>
	<div class="js-shipping-calculator-response {% if store.breanches %}mb-3{% else %}mb-4 pb-1{% endif %} transition-soft {% if product_detail %}list {% else %} radio-buttons-group{% endif %}" style="display: none;"></div>
</div>


{# Shipping country modal #}

{% if languages | length > 1 %}

	{% set country_modal_id = product_detail ? 'product' : 'cart' %}

	{# country modal #}

	{% set modal_shipping_country_body %}
		{% embed "snipplets/forms/form-select.tpl" with{select_label: true, select_label_name: 'País donde entregaremos tu compra' | translate, select_aria_label: 'País donde entregaremos tu compra' | translate, select_custom_class: 'js-country-select' } %}
			{% block select_options %}
				{% for language in languages %}
					<option value="{{ language.country }}" data-country-url="{{ language.url }}" {% if language.active %}selected{% endif %}>{{ language.country_name }}</option>
				{% endfor %}
			{% endblock select_options%}
		{% endembed %}
	{% endset %}

	{{ component(
		'modal',{
			modal_id: 'modal-' ~ country_modal_id ~ '-shipping-country',
			data_component: country_modal_id ~ '-shipping-country',
			layout: {
				width_mobile: 'small',
				width_desktop: 'small',
			},
			content: {
				title: 'País de entrega' | translate,
				body: modal_shipping_country_body,
				footer: '<a href="#" class="js-save-shipping-country btn btn-primary btn-medium d-inline-block">' ~ 'Aplicar' | translate ~ '</a>',
			},
			icons: {
				close_icon_id: 'times',
			},
			modal_classes: {
				modal: 'js-modal-shipping-country',
				close_icon: 'icon-inline',
				footer: 'text-right',
			}
		}) 
	}}
	
{% endif %}
