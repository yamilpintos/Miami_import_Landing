{# Product quantity #}

{% set label_text = product.isSubscribable() ? 'Cantidad' | translate %}

<div class="form-quantity-container">
    {% embed "snipplets/forms/form-input.tpl" with{
    type_number: true, input_value: '1',
    input_name: 'quantity' ~ item.id, 
    input_custom_class: 'js-quantity-input', 
    input_label_text: label_text,
    input_append_content: true, 
    input_group_custom_class: 'js-quantity m-0', 
    form_control_container_custom_class: 'px-0',
    form_data_component: 'product.adding-amount',
    form_control_quantity: true,
    input_min: '1',
    data_component: 'adding-amount.value',
    input_aria_label: 'Cambiar cantidad' | translate } %}
        {% block input_prepend_content %}
        <div class="form-quantity grid grid-3-auto grid-no-gap align-items-center" data-component="product.quantity">
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
    {% if settings.product_stock %}
        <div class="font-small py-2 text-center">
            <span class="js-product-stock">{{ product.selected_or_first_available_variant.stock }}</span> {{ "en stock" | translate }}
        </div>
    {% endif %}
</div>