{% if section_select == 'slider' %}

    {#  **** Home slider ****  #}
    <section data-store="home-slider">
        {% if show_help or (show_component_help and not (has_main_slider or has_mobile_slider)) %}
            {% snipplet 'defaults/home/slider_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-slider.tpl' %}
            {% if has_mobile_slider %}
                {% include 'snipplets/home/home-slider.tpl' with {mobile: true} %}
            {% endif %}
        {% endif %}
    </section>

{% elseif section_select == 'categories' %}

    {#  **** Categories banners ****  #}

    {% set section_without_margins = settings.banner_without_margins ? 'p-0' : 'py-4' %}

    <section class="js-section-banner-home section-home section-banners-home position-relative overflow-none {{ section_without_margins }}" data-store="home-banner-categories">
        {% if show_help or (show_component_help and not has_banners) %}
            {% include 'snipplets/defaults/home/banners_help.tpl' with { banner_name: 'category', banner_title: 'Categoría' | translate, help_text: 'Podés destacar categorías de tu tienda desde' | translate, section_name: 'Banners de categorías' | translate }  %}
        {% else %}
            {% include 'snipplets/home/home-banners.tpl' with {'has_banner': true} %}
        {% endif %}
    </section>

{% elseif section_select == 'promotional' %}

    {#  **** Promotional banners ****  #}

    {% set section_without_margins = settings.banner_promotional_without_margins ? 'p-0' : 'py-4' %}

    <section class="js-section-banner-home section-home section-banners-home position-relative overflow-none {{ section_without_margins }}" data-store="home-banner-promotional">
        {% if show_help or (show_component_help and not has_promotional_banners) %}
            {% include 'snipplets/defaults/home/banners_help.tpl' with { banner_name: 'promotional', banner_title: 'Promoción' | translate, help_text: 'Podés mostrar tus promociones desde' | translate, section_name: 'Banners promocionales' | translate }  %}
        {% else %}
            {% include 'snipplets/home/home-banners.tpl' with {'has_banner_promotional': true} %}
        {% endif %}
    </section>

{% elseif section_select == 'news_banners' %}

    {#  **** News banners ****  #}

    {% set section_without_margins = settings.banner_news_without_margins ? 'p-0' : 'py-4' %}

    <section class="js-section-banner-home section-home section-banners-home position-relative overflow-none {{ section_without_margins }}" data-store="home-banner-news">
        {% if show_help or (show_component_help and not has_news_banners) %}
            {% include 'snipplets/defaults/home/banners_help.tpl' with { banner_name: 'news', banner_title: 'Novedad' | translate, help_text: 'Podés mostrar tus novedades desde' | translate, section_name: 'Banners de novedades' | translate }  %}
        {% else %}
            {% include 'snipplets/home/home-banners.tpl' with {'has_banner_news': true} %}
        {% endif %}
    </section>

{% elseif section_select == 'modules' %}

    {#  **** Modules ****  #}
    <section class="section-home section-banners-home position-relative py-4" data-store="home-image-text-module">
        {% if show_help or (show_component_help and not has_image_and_text_module) %}
            {% include 'snipplets/defaults/home/image_text_modules_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-banners.tpl' with {'has_module': true} %}
        {% endif %}
    </section>

{% elseif section_select == 'institutional' %}

    {#  **** Institutional message ****  #}
    <section data-store="home-institutional-message">
        {% if show_help or (show_component_help and not has_institutional) %}
            {% include 'snipplets/defaults/home/institutional_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-institutional-message.tpl' %}
        {% endif %}
    </section>

{% elseif section_select == 'main_categories' %}

    {#  **** Main categories ****  #}
    <section data-store="home-categories-featured">
        {% if show_help or (show_component_help and not has_main_categories) %}
            {% include 'snipplets/defaults/home/main_categories_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-categories.tpl' %}
        {% endif %}
    </section>

{% elseif section_select == 'timer_offers' %}

    {#  **** Timer offers ****  #}
    <section class="section-timer-offers" data-store="home-timer-offers">
        {% if show_help or (show_component_help and not has_timer_offers) %}
            {% include 'snipplets/defaults/home/home_timer_offers_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-timer-offers.tpl' %}
        {% endif %}
    </section>

{% elseif section_select == 'video' %}

    {#  **** Video embed ****  #}
    <section class="section-video-home" data-store="home-video">
        {% if show_help or (show_component_help and not has_video) %}
            {% snipplet 'defaults/home/video_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-video.tpl' %}
        {% endif %}
    </section>

{% elseif section_select == 'brands' %}

    {#  **** Brands ****  #}
    <section class="section-brands-home" data-store="home-brands">
        {% if show_help or (show_component_help and not has_brands) %}
            {% snipplet 'defaults/home/brands_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-brands.tpl' %}
        {% endif %}
    </section>

{% elseif section_select == 'testimonials' %}

    {#  **** Testimonials ****  #}
    <section class="section-testimonials-home" data-store="home-testimonials">
        {% if show_help or (show_component_help and not has_testimonials) %}
            {% snipplet 'defaults/home/testimonials_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-testimonials.tpl' %}
        {% endif %}
    </section>

{% elseif section_select == 'newsletter' %}

    {#  **** Newsletter ****  #}
    {% include 'snipplets/home/home-newsletter.tpl' %}

{% elseif section_select == 'instafeed' %}

    {#  **** Instafeed ****  #}
    {% if show_help or (show_component_help and not has_instafeed) %}
        {% snipplet 'defaults/home/instafeed_help.tpl' %}
    {% else %}
        {% include 'snipplets/home/home-instafeed.tpl' %}
    {% endif %}

{% elseif section_select == 'products' %}

    {#  **** Featured products ****  #}
    {% if show_help or (show_component_help and not has_products) %}
        {% include 'snipplets/defaults/home/featured_products_help.tpl' with { products_title: 'Destacados' | translate, data_store: 'home-products-featured' }  %}
    {% else %}
        {% include 'snipplets/home/home-featured-products.tpl' with {'has_featured': true} %}
    {% endif %}

{% elseif section_select == 'new' %}

    {#  **** New products ****  #}
    {% if show_help or (show_component_help and not has_products) %}
        {% include 'snipplets/defaults/home/featured_products_help.tpl' with { products_title: 'Novedades' | translate, data_store: 'home-products-new' }  %}
    {% else %}
        {% include 'snipplets/home/home-featured-products.tpl' with {'has_new': true} %}
    {% endif %}

{% elseif section_select == 'sale' %}

    {#  **** Sale products ****  #}
    {% if show_help or (show_component_help and not has_products) %}
        {% include 'snipplets/defaults/home/featured_products_help.tpl' with { products_title: 'Ofertas' | translate, data_store: 'home-products-sale' }  %}
    {% else %}
        {% include 'snipplets/home/home-featured-products.tpl' with {'has_sale': true} %}
    {% endif %}

{% elseif section_select == 'main_product' %}

    {#  **** Main product ****  #}
    {% if show_help or (show_component_help and not has_products) %}
        {% include 'snipplets/defaults/home/main_product_help.tpl' %}
    {% else %}
        {% include 'snipplets/home/home-main-product.tpl' %}
    {% endif %}

{% elseif section_select == 'informatives' %}
    
    {#  **** Informative banners ****  #}
    {% set informative_banners_color = settings.banner_services_colors ? 'section-informative-banners-color' %}
    <section class="js-section-informative-banners {{ informative_banners_color }}" data-store="banner-services">
        {% if show_help or (show_component_help and not has_informative_banners) %}
            {% snipplet 'defaults/home/informative_banners_help.tpl' %}
        {% else %}
            {% include 'snipplets/home/home-banners-services.tpl' %}
        {% endif %}
    </section>

{% endif %}