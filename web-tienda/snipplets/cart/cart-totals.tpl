{# Cart totals used on cart-summary.tpl #}

{# Price without taxes classes #}

{% set price_without_taxes_container_classes = "d-grid grid-1-auto mb-2 font-small opacity-60" %}
{% set price_without_taxes_price_classes = "text-right" %}

{# Cart subtotal #}

{% if cart_subtotal %}
  <div class="js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif %} data-store="cart-subtotal">
    <div class="d-grid grid-1-auto mb-2 font-big">
      <span>
        {{ "Subtotal" | translate }}
        
        <span class="js-subtotal-shipping-wording" {% if not (cart.has_shippable_products or show_calculator_on_cart) %}style="display: none"{% endif %}>{{ " (sin envío)" | translate }}</span>
        :
      </span>
      <span class="js-ajax-cart-total js-cart-subtotal text-right" data-priceraw="{{ cart.subtotal }}" data-component="cart.subtotal" data-component-value={{ cart.subtotal }}>{{ cart.subtotal | money }}</span>
    </div>
  </div>

  {# Price without taxes #}

  {{ component('price-without-taxes', {
      location: 'cart',
      container_classes: price_without_taxes_container_classes,
      text_classes: {
        price: price_without_taxes_price_classes,
      },
    })
  }}
{% endif %}


{# Cart promotions #}

{% if cart_promotions %}
  <div class="js-total-promotions font-big text-accent">
    <span class="js-promo-discount" style="display:none;"> {{ "Descuento" | translate }}</span>
    <span class="js-promo-in" style="display:none;">{{ "en" | translate }}</span>
    <span class="js-promo-all" style="display:none;">{{ "todos los productos" | translate }}</span>
    <span class="js-promo-buying" style="display:none;"> {{ "comprando" | translate }}</span>
    <span class="js-promo-units-or-more" style="display:none;"> {{ "o más" | translate }}</span>
    {% for promotion in cart.promotional_discount.promotions_applied %}
      {% if not promotion.is_subscription_promotion %}
        {% if(promotion.scope_value_id) %}
          {% set id = promotion.scope_value_id %}
        {% else %}
          {% set id = 'all' %}
        {% endif %}
          <span class="js-total-promotions-detail-row d-grid grid-1-auto mb-2" id="{{ id }}">
            <span>
              {% if promotion.discount_script_type != "custom" %}
                {% if promotion.discount_script_type == "NAtX%off" %}
                  {{ promotion.selected_threshold.discount_decimal_percentage * 100 }}% OFF
                {% elseif promotion.isBuyXPayY %}
                  {{ promotion.buy }}x{{ promotion.pay }}
                {% elseif promotion.isCrossSelling %}
                  {{ "Descuento" | translate }}
                {% else %}
                  {{ promotion.discount_script_type }}
                {% endif %}

                {{ "en" | translate }} {% if id == 'all' %}{{ "todos los productos" | translate }}{% else %}{{ promotion.scope_value_name }}{% endif %}

                {% if promotion.discount_script_type == "NAtX%off" %}
                  <span>{{ "Comprando {1} o más" | translate(promotion.selected_threshold.quantity) }}</span>
                {% endif %}
              {% else %}
                {{ promotion.scope_value_name }}
              {% endif %}
              :
            </span>
            <span class="text-right">-{{ promotion.total_discount_amount_short }}</span>
          </span>
      {% endif %}
    {% endfor %}
  </div>
{% endif %}

{# Cart shipping costs #}

{% set show_cart_fulfillment = settings.shipping_calculator_cart_page and (store.has_shipping or store.branches) %}

{% if cart_shipping_costs and show_cart_fulfillment %}
  <div id="shipping-cost-container" class="js-fulfillment-info js-visible-on-cart-filled js-shipping-cost-table font-big" {% if cart.items_count == 0 or (not cart.has_shippable_products) %}style="display:none;"{% endif %}>
    <div class="d-grid grid-1-auto mb-2">
      <span>{{ 'Envío:' | translate }}</span>
      <span class="text-right">
        <span id="shipping-cost" class="text-right opacity-40">{{ "Calculalo para verlo" | translate }}</span>
        <span class="js-calculating-shipping-cost text-right opacity-40" style="display: none">{{ "Calculando" | translate }}...</span>
        <span class="js-shipping-cost-empty text-right opacity-40" style="display: none">{{ "Calculalo para verlo" | translate }}</span>
      </span>
    </div>    
  </div>
{% endif %}

{# Cart total #}

{% if cart_total %}
  <div class="js-cart-total-container js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif %} data-store="cart-total">
    <div class="d-grid grid-1-auto mb-3 font-huge">
      <span class="">{{ "Total" | translate }}:</span>
      <span class="text-right">
        <div class="js-cart-total {% if cart.free_shipping.cart_has_free_shipping %}js-free-shipping-achieved{% endif %} {% if cart.shipping_data.selected %}js-cart-saved-shipping{% endif %}" data-component="cart.total" data-component-value={{ cart.total }}>{{ cart.total | money }}</div>
          {{ component('payment-discount-price', {
              visibility_condition: settings.payment_discount_price,
              location: 'cart',
              container_classes: 'text-accent font-small font-weight-normal mt-1 text-right',
            }) 
          }}

          {% if not settings.payment_discount_price %}
            {{ component('installments', {'location': 'cart', 'short_wording' : true, container_classes: { installment: "font-small font-weight-normal mt-1 text-right"}}) }}
          {% endif %}
      </span>
    </div>

    {# IMPORTANT Do not remove this hidden total, it is used by JS to calculate cart total #}
    <div class='total-price hidden'>
      {{ "Total" | translate }}: {{ cart.total | money }}
    </div>
  </div>
{% endif %}
