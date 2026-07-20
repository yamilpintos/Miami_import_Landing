<div class="container mb-4" data-store="account-order-detail-{{ order.id }}">
    {% embed "snipplets/page-header.tpl" %}
        {% block page_header_text %}{{ 'Orden #{1}' | translate(order.number) }}{% endblock page_header_text %}
    {% endembed %}
    <div class="d-grid grid-md-auto-3 visible-when-content-ready">
        <div class="mb-4 font-medium">
            {% if log_entry %}
                <h4>{{ 'Estado actual del envío' | translate }}:</h4>{{ log_entry }}
            {% endif %}
            <div class="mb-3">
                <svg class="icon-inline mr-1 icon-w svg-icon-text"><use xlink:href="#calendar"/></svg> {{'Fecha' | translate}}: <strong>{{ order.date | i18n_date('%d/%m/%Y') }}</strong> 
            </div>
            <div class="mb-3">
                <svg class="icon-inline mr-1 icon-w svg-icon-text"><use xlink:href="#info-circle"/></svg> {{'Estado' | translate}}: <strong>{{ (order.status == 'open'? 'Abierta' : (order.status == 'closed'? 'Cerrada' : 'Cancelada')) | translate }}</strong>
            </div>
            <div class="mb-1">
                <svg class="icon-inline mr-1 icon-w svg-icon-text"><use xlink:href="#credit-card"/></svg> {{'Pago' | translate}}: <strong>{{ (order.payment_status == 'pending'? 'Pendiente' : (order.payment_status == 'authorized'? 'Autorizado' : (order.payment_status == 'paid'? 'Pagado' : (order.payment_status == 'voided'? 'Cancelado' : (order.payment_status == 'refunded'? 'Reintegrado' : 'Abandonado'))))) | translate }} </strong>
            </div>
            <div class="mb-3">
                <svg class="icon-inline mr-1 icon-w svg-icon-text"><use xlink:href="#wallet"/></svg> {{'Medio de pago' | translate}}: <strong>{{ order.payment_name }}</strong>
            </div>

            {% if order.address %}
                <div class="mb-3">
                    <svg class="icon-inline mr-1 icon-w svg-icon-text"><use xlink:href="#truck"/></svg> {{'Envío' | translate}}: <strong>{{ (order.shipping_status == 'fulfilled'? 'Enviado' : 'No enviado') | translate }}</strong>
                </div>
                <div class="mb-3"> 
                    <svg class="icon-inline mr-1 icon-w svg-icon-text"><use xlink:href="#map-marker"/></svg> <strong>{{ 'Dirección de envío' | translate }}:</strong>
                    <span class="d-block d-block mt-1 pl-4">
                        {{ order.address | format_address }}
                    </span>
                </div>
            {% endif %}
        </div>
        <div class="ml-md-4">
            <div class="mb-3 pb-3 bottom-line d-none d-md-grid order-grid font-medium">
                <div>
                    {{ 'Producto' | translate }}
                </div>
                <div class="text-center">
                    {{ 'Precio' | translate }}
                </div>
                <div class="text-center">
                    {{ 'Cantidad' | translate }}
                </div>
                <div class="text-right">
                    {{ 'Total' | translate }}
                </div>
            </div>
            <div class="order-detail mb-3">
                {% for item in order.items %}
                    <div class="order-item order-grid d-grid grid-2 grid-auto-1 mb-3 align-items-center font-medium font-md-body">
                        <div class="d-grid grid-auto-1 align-items-center mr-3 mr-md-0">
                            <div class="order-item-image-container">
                                {{ item.featured_image | product_image_url("small") | img_tag(item.featured_image.alt, {class: 'd-block order-item-image'}) }} 
                            </div>
                            <div class="mx-3 font-medium">
                                {{ item.name }} <span class="d-inline-block d-md-none text-center">x{{ item.quantity }}</span>
                            </div>
                        </div>
                        <div class="d-none d-md-block text-center">
                            {{ item.unit_price | money }}
                        </div>
                        <div class="d-none d-md-block text-center">
                            {{ item.quantity }}
                        </div>
                        <div class="text-right">
                            {{ item.subtotal | money }}
                        </div>
                    </div>
                {% endfor %}
            </div>
            {% set totals_text_classes = 'mb-2 d-grid grid-1-auto font-medium' %}
            <div class="w-md-40 float-md-right">
                {% if order.show_shipping_price %}
                    <div class="{{ totals_text_classes }}">
                        <span>{{ 'Costo de envío ({1})' | translate(order.shipping_name) }}:</span>
                        <span>
                            {% if order.shipping == 0  %}
                                {{ 'Gratis' | translate }}
                            {% else %}
                                {{ order.shipping | money_long }}
                            {% endif %}
                        </span>
                    </div>
                {% else %}
                    <div class="{{ totals_text_classes }}">
                        <span>{{ 'Costo de envío ({1})' | translate(order.shipping_name) }}:</span>
                        <span>
                            {{ 'A convenir' | translate }}
                        </span>
                    </div>
                {% endif %}
                {% if order.discount %}
                    <div class="{{ totals_text_classes }}">
                        <span>{{ 'Descuento ({1})' | translate(order.coupon) }}:</span>
                        <span>{{ order.discount | money }}</span>
                    </div>
                {% endif %}
                {% if order.shipping or order.discount %}
                    <div class="{{ totals_text_classes }}">
                        <span>{{ 'Subtotal' | translate }}:</span>
                        <span>{{ order.subtotal | money }}</span>
                    </div>
                {% endif %}  
                <div class="font-big mb-3 d-grid grid-1-auto">
                    <span>{{ 'Total' | translate }}:</span> 
                    <span>{{ order.total | money }}</span>
                </div>
                {% if order.pending %}
                    <a class="btn btn-primary btn-big w-100" href="{{ order.checkout_url | add_param('ref', 'orders_details') }}" target="_blank">{{ 'Realizar el pago' | translate }}</a>
                {% endif %}
            </div>
        </div>
	</div>
</div>