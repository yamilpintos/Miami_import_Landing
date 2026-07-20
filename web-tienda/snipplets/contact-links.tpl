<ul class="list list-unstyled">
	{% set list_classes = 'mb-3 font-medium' %}
	{% set list_with_icons_classes = with_icons ? 'd-flex align-items-center' %}
	{% set icon_classes = 'icon-inline mr-2' %}

	{# MIAMI_IMPORT: Instagram al inicio con link directo #}
	<li class="{{ list_classes }} {{ list_with_icons_classes }}">
		<a href="https://www.instagram.com/miamimport_/" target="_blank" rel="noopener" aria-label="Instagram Miami Import">
			<svg class="{{ icon_classes }} icon-lg"><use xlink:href="#instagram"/></svg>
			@miamimport_
		</a>
	</li>

	{# MIAMI_IMPORT: store.whatsapp con icono WhatsApp #}
	{% if store.whatsapp %}
		<li class="{{ list_classes }} {{ list_with_icons_classes }}">
			<a href="{{ store.whatsapp }}" target="_blank" rel="noopener">
				<svg class="{{ icon_classes }} icon-lg"><use xlink:href="#whatsapp-line"/></svg>
				{{ store.whatsapp |trim('https://wa.me/') }}
			</a>
		</li>
	{% endif %}

	{# MIAMI_IMPORT: store.phone tambien como WhatsApp (es nuestro segundo numero).
	   wa.me admite el numero con + y espacios — los limpia internamente. #}
	{% if store.phone %}
		<li class="{{ list_classes }} {{ list_with_icons_classes }}">
			<a href="https://wa.me/{{ store.phone }}" target="_blank" rel="noopener">
				<svg class="{{ icon_classes }} icon-lg"><use xlink:href="#whatsapp-line"/></svg>
				{{ store.phone }}
			</a>
		</li>
	{% endif %}

	{% if store.email %}
		<li class="{{ list_classes }} {{ list_with_icons_classes }}">
			<a href="mailto:{{ store.email }}">
				{% if with_icons %}
					<svg class="{{ icon_classes }} icon-w"><use xlink:href="#email"/></svg>
				{% endif %}
				{{ store.email }}
			</a>
		</li>
	{% endif %}

	{# MIAMI_IMPORT: prefijo "Direccion:" al store.address #}
	{% if store.address and not is_order_cancellation %}
		<li class="{{ list_classes }} {{ list_with_icons_classes }}">
			{% if with_icons %}
				<svg class="{{ icon_classes }} icon-lg"><use xlink:href="#map-marker"/></svg>
			{% endif %}
			<span><strong>Dirección:</strong> {{ store.address }}</span>
		</li>
	{% endif %}
	{% if store.blog %}
		<li class="{{ list_classes }} {{ list_with_icons_classes }}">
			<a target="_blank" href="{{ store.blog }}">
				{% if with_icons %}
					<svg class="{{ icon_classes }} icon-w"><use xlink:href="#comments"/></svg>
				{% endif %}
				{{ "¡Visitá nuestro Blog!" | translate }}
			</a>
		</li>
	{% endif %}
</ul>