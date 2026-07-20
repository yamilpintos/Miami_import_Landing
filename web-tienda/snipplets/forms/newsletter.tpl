{% set alert_success = 
	'<div class="alert alert-success mt-3 mb-0">' ~ "¡Gracias por suscribirte! A partir de ahora vas a recibir nuestras novedades en tu email" | translate ~ '</div>' 
%}

{% set alert_failed = 
	'<div class="alert alert-danger mt-3 mb-0">' ~ "Necesitamos tu email para enviarte nuestras novedades." | translate ~ '</div>' 
%}

<form method="post" action="/winnie-pooh" {% if form_empty_action_js %}onsubmit="this.setAttribute('action', '');"{% endif %} id="{{ form_id }}" class="{{ form_classes }}" data-store="{{ form_data_store }}">
	<div class="input-append">
		{% embed "snipplets/forms/form-input.tpl" with{input_for: 'email', type_email: true, input_name: 'email', input_id: 'email', input_placeholder: 'Email' | translate, input_group_custom_class: 'mb-0', input_custom_class: input_custom_class, input_aria_label: 'Email' | translate } %}
		{% endembed %}
		<div class="winnie-pooh" style="display: none;">
			<label for="winnie-pooh-newsletter">{{ "No completar este campo" | translate }}</label>
			<input id="winnie-pooh-newsletter" type="text" name="winnie-pooh"/>
		</div>
		<input type="hidden" name="name" value="{{ 'Sin nombre' | translate }}" />
		<input type="hidden" name="message" value="{{ 'Pedido de inscripción a newsletter' | translate }}" />
		<input type="hidden" name="type" value="newsletter" />
		<input type="submit" name="contact" class="btn btn-inline {{ submit_custom_class }}" value="{{ 'Enviar' | translate }}" />
		{% if ajax_submit %}
			<span class="js-news-spinner news-spinner" style="display: none;">
				<svg class="icon-inline icon-spin svg-icon-text"><use xlink:href="#spinner-third"/></svg>
			</span>
		{% endif %}
	</div>
	{% if ajax_submit %}
		<div class="js-news-success" style='display: none;'>
			{{ alert_success | raw }}
		</div>
		<div class="js-news-failed" style='display: none;'>
			{{ alert_failed | raw }}
		</div>
	{% else %}
		{% if contact and contact.type == 'newsletter' %}
			{% if contact.success %}
				{{ alert_success | raw }}
			{% else %}
				{{ alert_failed | raw }}
			{% endif %}
		{% endif %}
	{% endif %}
</form>