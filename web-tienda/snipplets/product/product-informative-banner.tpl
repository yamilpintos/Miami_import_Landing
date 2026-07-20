{% for banner in ['product_informative_banner_01', 'product_informative_banner_02'] %}
    {% set product_banner_show = attribute(settings,"#{banner}_show") %}
    {% set product_informative_banner_image = "#{banner}.jpg" | has_custom_image %}
    {% set product_informative_banner_icon = attribute(settings,"#{banner}_icon") %}
    {% set product_informative_banner_title = attribute(settings,"#{banner}_title") %}
    {% set product_informative_banner_description = attribute(settings,"#{banner}_description") %}
    {% set has_product_informative_banner =  product_banner_show and (product_informative_banner_title or product_informative_banner_description) %}
    {% if has_product_informative_banner %}
        <div class="grid grid-auto-1 mb-3">
            {% if product_informative_banner_icon != 'none' %}
                <div class="icon-banner">
                    {% if product_informative_banner_icon == 'image' and product_informative_banner_image %}
                        {% set banner_image_alt = product_informative_banner_title ? product_informative_banner_title : 'Banner de' | translate ~ ' ' ~ store.name %}
                        {{ component(
                            'image',{
                                image_name: "#{banner}.jpg",
                                image_classes: 'product-banner-service-image',
                                image_alt: banner_image_alt,
                            })
                        }}
                    {% else %}
                        {% set product_informative_banner_svg = 
                            product_informative_banner_icon == 'delivery' ? 'truck' :
                            product_informative_banner_icon == 'whatsapp' ? 'whatsapp-line' :
                            product_informative_banner_icon == 'credit_card' ? 'credit-card' : product_informative_banner_icon
                        %}
                        <svg class="icon-inline icon-lg svg-icon-text"><use xlink:href="#{{ product_informative_banner_svg }}"/></svg>
                    {% endif %}
                </div>
            {% endif %}
            <div class="icon-text font-medium">
                {% if product_informative_banner_title %}
                    <div class="mb-1 font-weight-bold">{{ product_informative_banner_title }}</div>
                {% endif %}
                {% if product_informative_banner_description %}
                    <div>{{ product_informative_banner_description }}</div> 
                {% endif %}
            </div>
        </div>
    {% endif %}
{% endfor %}