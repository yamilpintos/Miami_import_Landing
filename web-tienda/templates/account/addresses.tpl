<div class="container">
    {% embed "snipplets/page-header.tpl" %}
        {% block page_header_text %}{{ "Mis direcciones" | translate }}{% endblock page_header_text %}
    {% endembed %}
    <div class="d-grid grid-md-auto-4 mb-5 visible-when-content-ready">
        {% for address in customer.addresses %}
            {# User addresses listed - Main Address #}

            {% if loop.first %}
                <div>
                    <h6 class="d-inline-block w-100 mb-3">{{ 'Principal' | translate }}</h6>

            {# User addresses listed - Other Addresses #}

            {% elseif loop.index == 2 %}
                <div class="ml-md-4">
                    <h6 class="d-inline-block w-100 mb-3 mx-md-2">{{ 'Otras direcciones' | translate }}</h6>
                    <div class="d-grid grid-md-3">

            {% endif %}
                    {% if not loop.first %}
                        <div class="card mx-md-2 mb-3">
                    {% endif %}
                            <div class="font-weight-bold mb-2 font-medium">{{ address.name }} {{ 'Editar' | translate | a_tag(store.customer_address_url(address), '', 'btn-link font-weight-normal float-right') }}</div>
                            <div class="font-small">{{ address | format_address }}</div>
                    {% if not loop.first %}
                        </div>
                    {% endif %}
            {% if not loop.first and loop.last %}
                    </div>
            {% endif %}
            {% if loop.first %} 
                    <a class="btn-link mt-2 mb-4 pb-2 d-inline-block" href="{{ store.customer_new_address_url }}"> {{ 'Agregar una nueva dirección' | translate }}</a>
                </div>
            {% elseif loop.last %}
                </div>
            {% endif %}
        {% endfor %}
    </div>
</div>