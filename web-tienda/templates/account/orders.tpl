<div class="container mb-5">
    {% embed "snipplets/page-header.tpl" %}
        {% block page_header_text %}{{ "Mi cuenta" | translate }}{% endblock page_header_text %}
    {% endembed %}
    <div class="d-grid grid-md-auto-4 visible-when-content-ready">
        <div class="font-medium mb-4">
            <div class="d-flex mb-3 align-items-center">
                <h6 class="d-inline-block w-100 m-0">{{ 'Datos personales' | translate }}</h6>
                {{ 'Editar' | translate | a_tag(store.customer_info_url, '', 'btn-link') }}
            </div>
            {% set info_spacing = 'mb-2' %}
            <div class="mb-4 font-medium">
                <div class="{{ info_spacing }}">
                    {{customer.name}}
                </div>
                <div class="{{ info_spacing }}">
                    {{customer.email}}
                </div>
                {% if customer.cpf_cnpj %}
                    <div class="{{ info_spacing }}">
                        {{ 'DNI / CUIT' | translate }}: {{ customer.cpf_cnpj | format_id_number(customer.billing_country) }}
                    </div>
                {% endif %}
                {% if customer.business_name %}
                    <div class="{{ info_spacing }}">
                        {{ 'Razón social' | translate }}: {{ customer.business_name }}
                    </div>
                {% endif %}
                {% if customer.trade_name %}
                    <div class="{{ info_spacing }}">
                        {{ 'Nombre comercial' | translate }}: {{ customer.trade_name }}
                    </div>
                {% endif %}
                {% if customer.state_registration %}
                    <div class="{{ info_spacing }}">
                        {{ 'Inscripción estatal' | translate }}: {{ customer.state_registration }}
                    </div>
                {% endif %}
                {# Giro business activity used only by CL stores #}
                {% if customer.business_activity %}
                    <div class="{{ info_spacing }}">
                        {{ 'Giro' | translate }}: {{ customer.business_activity }}
                    </div>
                {% endif %}
                {% if customer.fiscal_regime %}
                    <div class="{{ info_spacing }}">
                        {{ 'Régimen fiscal' | translate }}: {{ customer.fiscal_regime | format_fiscal_regime }}
                    </div>
                {% endif %}
                {% if customer.phone %}
                    <div class="{{ info_spacing }}">
                       {{ 'Teléfono' | translate }}: {{ customer.phone }}
                    </div>
                {% endif %}
            </div>
            {% if customer.default_address %}
                <div class="mb-3 d-flex align-items-center">
                    <h6 class="d-inline-block w-100 m-0">{{ 'Mis direcciones' | translate }}</h6>
                    {{ 'Editar' | translate | a_tag(store.customer_address_url(customer.default_address), '', 'btn-link') }}
                </div>

                <div class="mb-4 font-medium">
                    <div class="{{ info_spacing }}">
                        {{ customer.default_address | format_address_short }}
                    </div>
                    {{ 'Otras direcciones' | translate | a_tag(store.customer_addresses_url, '', 'btn-link') }}
                </div>
            {% endif %}
            <div class="mb-4">
                {{ "Cerrar sesión" | translate | a_tag(store.customer_logout_url, '', 'btn btn-link font-big') }}
            </div>
        </div>
        <div data-store="account-orders">
            {% if customer.orders %}
                {% if customer.ordersCount > 50 %}
                    <div class="h6 mb-3 mx-md-2">
                        {{ 'Últimas 50 órdenes' | translate }}
                    </div>
                {% endif %}
                <div class="d-grid grid-md-3 ml-md-4">
                    {% for order in customer.orders %}
                        {% set add_checkout_link = order.pending %}
                        <div class="mb-3 mx-md-2" data-store="account-order-item-{{ order.id }}">
                            {% embed "snipplets/card.tpl" with{card_footer: true, card_custom_class: 'card-collapse mb-0', card_collapse: true} %}
                                {% block card_head %}
                                    <div class="d-flex align-items-center">
                                        <div class="mr-2">
                                             <a class="btn-link" href="{{ store.customer_order_url(order) }}"><strong>{{'Orden:' | translate}} #{{order.number}}</strong></a>
                                        </div>
                                        <div class="js-card-collapse-toggle text-right font-small">
                                            {{ order.date | i18n_date('%d/%m/%Y') }}
                                        </div>
                                    </div>
                                {% endblock %}
                                {% block card_body %}
                                <div class="d-grid grid-1-auto">
                                    <div class="mr-3">
                                        {% set status_classes = 'd-flex mb-2 align-items-center font-medium' %}
                                        {% set status_icon_classes = 'icon-inline mr-2 icon-w svg-icon-text' %}
                                        <div class="{{ status_classes }}">
                                            <svg class="{{ status_icon_classes }}"><use xlink:href="#credit-card"/></svg> {{'Pago' | translate}}: <span class="{{ order.payment_status }} ml-1"> <strong>{{ (order.payment_status == 'pending'? 'Pendiente' : (order.payment_status == 'authorized'? 'Autorizado' : (order.payment_status == 'paid'? 'Pagado' : (order.payment_status == 'voided'? 'Cancelado' : (order.payment_status == 'refunded'? 'Reintegrado' : 'Abandonado'))))) | translate }}</strong></span>
                                        </div>
                                        <div class="{{ status_classes }}">
                                            <svg class="{{ status_icon_classes }}"><use xlink:href="#truck"/></svg> {{'Envío' | translate}}: <strong class="ml-1"> {{ (order.shipping_status == 'fulfilled'? 'Enviado' : 'No enviado') | translate }} </strong>
                                        </div>
                                        <div class="mt-3 mb-2 font-big font-weight-bold">
                                            {{'Total' | translate}} {{ order.total | money }}
                                        </div>
                                        <a class="btn-link d-block mb-3" href="{{ store.customer_order_url(order) }}">{{'Ver detalle' | translate}}</a>
                                    </div>

                                    <div class="order-item-image-container">
                                        {% for item in order.items %}
                                            {% if loop.first %} 
                                                {% if loop.length > 1 %} 
                                                    <span class="card-img-pill">{{ loop.length }} {{'Productos' | translate }}</span>
                                                {% endif %}
                                                {{ item.featured_image | product_image_url("") | img_tag(item.featured_image.alt, {class: 'order-item-image'}) }}
                                            {% endif %}
                                        {% endfor %}
                                    </div>
                                </div>
                                {% endblock %}
                                {% block card_foot %}
                                    {% if add_checkout_link %}
                                        <a class="btn btn-primary btn-medium d-block" href="{{ order.checkout_url | add_param('ref', 'orders_list') }}" target="_blank">{{'Realizar el pago' | translate}}</a>
                                    {% elseif order.order_status_url != null %}
                                        <a class="btn btn-primary btn-medium d-block" href="{{ order.order_status_url | add_param('ref', 'orders_list') }}" target="_blank">{% if 'Correios' in order.shipping_name %}{{'Seguí la entrega' | translate}}{% else %}{{'Seguí tu orden' | translate}}{% endif %}</a>
                                    {% endif %}
                                {% endblock %}
                            {% endembed %}
                        </div>
                    {% endfor %}
                </div>
            {% else %}
                <div class="text-center">
                    <svg class="icon-inline mr-1 icon-lg svg-icon-primary"><use xlink:href="#cart"/></svg>
                    <p class="my-2">{{ '¡Hacé tu primera compra!' | translate }}</p>
                    {{ 'Ir a la tienda' | translate | a_tag(store.url, '', 'btn btn-primary px-5 mt-2') }}
                </div>
            {% endif %}
        </div>
    </div>
</div>