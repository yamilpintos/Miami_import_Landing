{% set item_type_classes = item.product.is_non_shippable ? 'js-cart-item-non-shippable' : 'js-cart-item-shippable' %}
{% set item_page_classes = cart_page ? 'cart-page-item align-items-md-center' %}
{% set compare_at_price = item.compare_at_price %}
{% set hide_compare_price_subtotal = not item.compare_at_price_subtotal or item.is_subscription_item %}

{{ component('nubesdk-slot', { type: "before_line_item", pick: item.id }) }}

<div class="js-cart-item {{ item_type_classes }} cart-item {{ item_page_classes }} mb-4" data-item-id="{{ item.id }}" data-store="cart-item-{{ item.product.id }}" data-component="cart.line-item">

    {# Cart item image #}

    <div class="cart-item-image-container">
        <a href="{{ item.url }}">
            {{ component(
                'image',{
                    image_name: item.featured_image,
                    image_classes: 'img-fluid cart-item-image',
                    image_alt: item.short_name,
                    product_image: true,
                })
            }}
        </a>
    </div>
    <div class="cart-item-info-container">
        <div class="cart-item-product-info">
            {# Cart item name #}

            <div class="cart-item-name-container mb-1" data-component="line-item.name">
                <a href="{{ item.url }}" data-component="name.short-name" class="cart-item-name" data-component="line-item.name">
                    {{ item.short_name }}
                </a>
                <span class="cart-item-variant" data-component="name.short-variant-name">{{ item.short_variant_name }}</span>

                {{ component(
                    'cart-labels', {
                        group: true,
                        subscription_label: true,
                        shipping_icon: true,
                        shipping_svg_id: 'truck',
                        labels_classes: {
                            group: 'mt-2 mb-1',
                            shipping: 'text-accent cart-item-label d-flex align-items-center mb-2',
                            shipping_icon: 'icon-inline icon-lg svg-icon-accent mr-1',
                            promotion: 'label label-accent cart-item-small-label', 
                            subscription: 'font-smallest opacity-80 mt-1 mb-2',
                        },
                    })
                }}
            </div>

            {# Cart item delete #}
            
            <div class="cart-item-delete {% if cart_page %}d-md-none{% endif %}">
                <button type="button" class="btn btn-link cart-item-delete-button" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="line-item.remove">
                    {{ "Eliminar" | translate }}
                </button>
            </div>
        </div>
        <div class="cart-item-totals-container align-items-center">
        
            {# Cart item quantity #}

            <div class="cart-item-quantity" data-component="line-item.subtotal">
                {% embed "snipplets/forms/form-input.tpl" with{
                type_number: true, 
                input_value: item.quantity,
                input_name: 'quantity[' ~ item.id ~ ']',
                input_data_attr: 'item-id',
                input_data_val: item.id,
                input_custom_class: 'js-cart-quantity-input cart-quantity-input p-0', 
                input_label: false, 
                input_append_content: true, 
                input_group_custom_class: 'js-quantity form-quantity small', 
                form_data_component: 'quantity.value',
                form_control_quantity: true,
                input_aria_label: 'Cambiar cantidad' | translate } %}
                    {% block input_prepend_content %}
                        <div class="grid grid-3-auto grid-no-gap align-items-center">
                            <span class="js-cart-quantity-btn btn icon-30px" onclick="LS.minusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.minus">
                                <svg class="icon-inline"><use xlink:href="#minus"/></svg>
                            </span>
                    {% endblock input_prepend_content %}
                    {% block input_append_content %}
                            <span class="js-cart-input-spinner cart-item-spinner" style="display: none;">
                                <svg class="icon-inline icon-spin svg-icon-text"><use xlink:href="#spinner-third"/></svg>
                            </span>
                            <span class="js-cart-quantity-btn btn icon-30px" onclick="LS.plusQuantity({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="quantity.plus">
                                <svg class="icon-inline"><use xlink:href="#plus"/></svg>
                            </span>
                        </div>
                    {% endblock input_append_content %}
                {% endembed %}
            </div>

            {% set cart_page_price_class = 'cart-item-subtotal' %}

            {% if cart_page %}
                {# Cart item unit price #}
                <div class="cart-item-unit-price d-none d-md-block">
                    <div class="js-cart-item-unit-price-compare-price-container cart-compare-price-container mb-1" data-line-item-id="{{ item.id }}"{% if not compare_at_price %} style="display: none"{% endif %}>
                        <span class="text-accent mr-1">-{{ item.product.promotional_price_percentage | round }}%</span>
                        <span class="js-cart-item-unit-price-compare-price price-compare opacity-50" data-line-item-id="{{ item.id }}" data-component="compare_price.value" data-component-value='{{ compare_at_price | money }}'>{{ compare_at_price | money }}</span>
                    </div>
                    <div class="js-cart-item-unit-price {{ cart_page_price_class }}" data-line-item-id="{{ item.id }}">{{ item.unit_price | money }}</div>
                </div>
            {% endif %}

            {# Cart item subtotal #}

            <div class="cart-item-subtotal text-right {% if cart_page %}text-md-left{% endif %}">
                <div class="js-cart-item-subtotal-compare-price-container cart-compare-price-container mb-1" data-line-item-id="{{ item.id }}"{% if hide_compare_price_subtotal %} style="display: none"{% endif %}>
                    <span class="text-accent mr-1">-{{ item.product.promotional_price_percentage | round }}%</span>
                    <span class="js-cart-item-subtotal-compare-price price-compare opacity-50" data-line-item-id="{{ item.id }}" data-component="subtotal_compare_price.value" data-component-value='{{ item.compare_at_price_subtotal | money }}'>{{ item.compare_at_price_subtotal | money }}</span>
                </div>
                <div class="js-cart-item-subtotal" data-line-item-id="{{ item.id }}" data-component="subtotal.value" data-component-value='{{ item.subtotal | money }}'>{{ item.subtotal | money }}</div>
            </div>
        </div>

        {% if cart_page %}
            
            {# Cart page item delete #}
                    
            <div class="cart-item-delete d-none d-md-block text-right">
                <button type="button" class="btn btn-link" onclick="LS.removeItem({{ item.id }}{% if not cart_page %}, true{% endif %})" data-component="line-item.remove">
                    {{ "Eliminar" | translate }}
                </button>
            </div>
        {% endif %}
    </div>
</div>
    