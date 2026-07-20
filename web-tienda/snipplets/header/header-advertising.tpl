{# Set adbar info based on type #}

{% set theme_editor = params.preview %}

{% set adbar_type = adbar_primary ? 'primary' : adbar_secondary ? 'secondary' %}

{% set has_advertising_bar = false %}
{% set num_messages = 0 %}

{# Check for adbar messages #}
{% for i in 1..3 %}
    {% set adbar = 'adbar_' ~ adbar_type ~ '_0' ~ i %}
    {% set advertising_text = attribute(settings, adbar ~ '_text') %}
    {% if advertising_text %}
        {% set num_messages = num_messages + 1 %}
    {% endif %}
{% endfor %}

{# Adbar JS classes #}
{% set adbar_classes = 'js-adbar js-adbar-' ~ adbar_type ~ ' adbar-' ~ adbar_type %}

{% if adbar_primary %}
    {# Check for adbar images #}
    {% set adbar_mobile_image = ('adbar_' ~ adbar_type ~ '_img_mobile.jpg') | has_custom_image %}
    {% set adbar_desktop_image = ('adbar_' ~ adbar_type ~ '_img_desktop.jpg') | has_custom_image %}
    {% set adbar_mobile_image_url = attribute(settings, 'adbar_' ~ adbar_type ~ '_img_mobile_url') %}
    {% set adbar_desktop_image_url = attribute(settings, 'adbar_' ~ adbar_type ~ '_img_desktop_url') %}
    {% set adbar_mobile_image_name = 'adbar_' ~ adbar_type ~ '_img_mobile.jpg' %}
    {% set adbar_desktop_image_name = 'adbar_' ~ adbar_type ~ '_img_desktop.jpg' %}

    {# Adbar images devices visibility classes #}
    {% set show_adbar_only_mobile = adbar_mobile_image and not adbar_desktop_image and not num_messages %}
    {% set show_adbar_only_desktop = adbar_desktop_image and not adbar_mobile_image and not num_messages %}
    {% set adbar_images = adbar_mobile_image or adbar_desktop_image %}
    {% set both_images_without_messages = adbar_mobile_image and adbar_desktop_image and not num_messages %}
    {% set adbar_with_image_classes = adbar_images ? 'adbar-with-image' %}
    {% set adbar_images_and_messages = num_messages and adbar_images %}
{% endif %}

{# Adbar colors classes #}
{% set adbar_colors_classes = attribute(settings, 'adbar_' ~ adbar_type ~ '_colors') ? 'adbar-colors' %}

{# Adbar messages classes #}
{% set adbar_messages_classes = num_messages ? 'adbar-with-messages' %}
{% set adbar_multiple_messages_classes = num_messages > 1 ? 'adbar-with-multiple-messages' %}
{% set adbar_no_text_classes = not num_messages ? 'p-0' %}

{# Adbar devices visibility classes #}
{% set adbar_visibility_classes = show_adbar_only_mobile ? 'd-md-none' : (show_adbar_only_desktop ? 'd-none d-md-block') %}

{# Adbar animation classes #}
{% set adbar_animated = attribute(settings, 'adbar_' ~ adbar_type ~ '_animate') %}
{% set adbar_animated_classes = adbar_animated ? 'adbar-animated' %}
{% set adbar_animated_container_classes = adbar_animated ? 'adbar-content-animated' : 'swiper-container text-center container' %}
{% set adbar_animated_text_classes = adbar_animated ? 'mr-4' : 'swiper-slide slide-container' %}

{# Adbar swiper classes #}
{% set swiper_prev_class = 'js-swiper-adbar-' ~ adbar_type ~ '-prev' %}
{% set swiper_next_class = 'js-swiper-adbar-' ~ adbar_type ~ '-next' %}

{# Adbar visibility #}
{% set adbar_active = attribute(settings, 'adbar_' ~ adbar_type) %}
{% set show_adbar = adbar_active and (num_messages or adbar_images) %}

{% if show_adbar %}
    <div class="{{ adbar_classes }} adbar {{ adbar_animated_classes }} {{ adbar_colors_classes }} {{ adbar_messages_classes }} {{ adbar_multiple_messages_classes }} {{ adbar_visibility_classes }} {{ adbar_no_text_classes }} {{ adbar_with_image_classes }}" data-active="{{ adbar_active ? 'true' : 'false' }}" data-messages="{{ num_messages }}" data-animated="{{ adbar_animated ? 'true' : 'false' }}" data-image-desktop="{{ adbar_desktop_image ? 'true' : 'false' }}" data-image-mobile="{{ adbar_mobile_image ? 'true' : 'false' }}">
        <div class="js-adbar-content js-swiper-adbar-{{ adbar_type }} {{ adbar_animated_container_classes }}" {% if not num_messages %}style="display: none;"{% endif %}>
            <div class="js-adbar-messages-container js-adbar-{{ adbar_type }}-messages-container swiper-wrapper adbar-text-container align-items-center">
                {% set repeat_number = adbar_animated ? (num_messages == 1 ? 16 : (num_messages == 2 ? 8 : 5)) : 1 %}
                {% for i in 1..repeat_number %}
                    {% for j in 1..3 %}
                        {% set adbar = 'adbar_' ~ adbar_type ~ '_0' ~ j %}
                        {% set advertising_text = attribute(settings, adbar ~ '_text') %}
                        {% set advertising_url = attribute(settings, adbar ~ '_url') %}
                        {% if advertising_text %}
                            {% set adbar_animated_text_classes = adbar_animated ? 'mr-4' : 'swiper-slide slide-container' %}
                            <span class="js-adbar-message-container js-adbar-{{ adbar_type }}-message-container adbar-message {{ adbar_animated_text_classes }} {% if num_messages > 1 and not adbar_animated %}px-4{% endif %}" data-message-id="{{ loop.index }}">
                                {% if advertising_url %}
                                    <a href="{{ advertising_url }}" {% if not adbar_animated %}class="d-block w-100"{% endif %}>
                                {% endif %}
                                        {{ advertising_text }}
                                {% if advertising_url %}
                                    </a>
                                {% endif %}
                            </span>
                        {% endif %}
                    {% endfor %}
                {% endfor %}
            </div>
            {% if num_messages > 1 and not adbar_animated %}
                <div class="{{ swiper_prev_class }} swiper-button-absolute swiper-button-prev svg-icon-text">
                    <svg class="icon-inline icon-lg icon-flip-horizontal"><use xlink:href="#chevron"/></svg>
                </div>
                <div class="{{ swiper_next_class }} swiper-button-absolute swiper-button-next svg-icon-text">
                    <svg class="icon-inline icon-lg"><use xlink:href="#chevron"/></svg>
                </div>
            {% endif %}
        </div>
        {% if adbar_type == 'primary' %}
            {% if adbar_images_and_messages or theme_editor %}
                <div class="js-adbar-img-container {% if adbar_images_and_messages %}adbar-img-container {% if num_messages %}adbar-with-messages{% endif %}{% endif %}" >
            {% endif %}

            {% if adbar_desktop_image or adbar_mobile_image or theme_editor %}
                {% if adbar_mobile_image or theme_editor %}
                    {% if theme_editor %}
                        <div class="js-adbar-mobile-image-container" {% if not adbar_mobile_image %}style="display: none;"{% endif %}>
                    {% endif %}
                        {% if adbar_mobile_image_url and not num_messages %}
                            <a href="{{ adbar_mobile_image_url }}" class="w-100 d-block d-md-none">
                        {% endif %}
                                {{ component(
                                    'image',{
                                        image_name: adbar_mobile_image_name,
                                        image_classes: 'js-adbar-mobile-img adbar-img d-block d-md-none'  ,
                                    })
                                }}
                        {% if adbar_mobile_image_url and not num_messages %}
                            </a>
                        {% endif %}
                     {% if theme_editor %}
                        </div>
                    {% endif %}
                {% endif %}


                {% if adbar_desktop_image or theme_editor %}
                    {% if theme_editor %}
                        <div class="js-adbar-desktop-image-container" {% if not adbar_desktop_image %}style="display: none;"{% endif %}>
                    {% endif %}
                        {% if adbar_desktop_image_url and not num_messages %}
                            <a href="{{ adbar_desktop_image_url }}" class="w-100 d-none d-md-block">
                        {% endif %}
                                {{ component(
                                    'image',{
                                        image_name: adbar_desktop_image_name,
                                        image_classes: 'js-adbar-desktop-img adbar-img d-none d-md-block',
                                    })
                                }}
                        {% if adbar_desktop_image_url and not num_messages %}
                            </a>
                        {% endif %}
                    {% if theme_editor %}
                        </div>
                    {% endif %}
                {% endif %}
            {% endif %}
            {% if adbar_images_and_messages or theme_editor %}
                </div>
            {% endif %}
        {% endif %}
    </div>
{% endif %}
