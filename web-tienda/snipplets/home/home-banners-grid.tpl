{% set banner = banner | default(false) %}
{% set banner_promotional = banner_promotional | default(false) %}
{% set banner_news = banner_news | default(false) %}
{% set module = module | default(false) %}

{% if banner %}
    {% set has_banners = settings.banner and settings.banner is not empty %}
    {% set has_mobile_banners = settings.toggle_banner_mobile and settings.banner_mobile and settings.banner_mobile is not empty %}
    {% set section_banner = mobile ? settings.banner_mobile : settings.banner %}
    {% set section_slider = settings.banner_format_mobile == 'slider' or settings.banner_format_desktop == 'slider' %}
    {% set section_slider_toggle_mobile = settings.toggle_banner_mobile %}
    {% set section_slider_both = settings.banner_format_mobile == 'slider' and settings.banner_format_desktop == 'slider' %}
    {% set section_slider_mobile = settings.banner_format_mobile == 'slider' %}
    {% set section_slider_mobile_only = settings.banner_format_mobile == 'slider' and settings.banner_format_desktop == 'grid' %}
    {% set section_slider_desktop_only = settings.banner_format_desktop == 'slider' and settings.banner_format_mobile == 'grid' %}
    {% set section_id = mobile ? 'banner-mobile' : 'banner' %}
    {% set section_first = settings.home_order_position_1 == 'categories' %}
    {% set section_columns_desktop_4 = settings.banner_columns_desktop == 4 %}
    {% set section_columns_desktop_3 = settings.banner_columns_desktop == 3 %}
    {% set section_columns_desktop_2 = settings.banner_columns_desktop == 2 %}
    {% set section_columns_desktop_1 = settings.banner_columns_desktop == 1 %}
    {% set section_align_text = settings.banner_align == 'center' ? 'text-center textbanner-text-center ' %}
    {% set section_without_margins = settings.banner_without_margins %}
    {% set section_text_outside = settings.banner_text_outside %}
    {% set section_text_above_class = not section_text_outside ? 'textbanner-text-above' : 'textbanner-text-background' %}
    {% set section_button_outside_class = not section_without_margins ? 'swiper-button-outside svg-icon-text' : 'svg-icon-invert' %}
    {% set section_without_margin_class = section_without_margins ? 'm-0' %}
{% endif %}
{% if banner_promotional %}
    {% set has_banners = settings.banner_promotional and settings.banner_promotional is not empty %}
    {% set has_mobile_banners = settings.toggle_banner_promotional_mobile and settings.banner_promotional_mobile and settings.banner_promotional_mobile is not empty %}
    {% set section_banner = mobile ? settings.banner_promotional_mobile : settings.banner_promotional %}
    {% set section_slider = settings.banner_promotional_format_mobile == 'slider' or settings.banner_promotional_format_desktop == 'slider' %}
    {% set section_slider_toggle_mobile = settings.toggle_banner_promotional_mobile %}
    {% set section_slider_both = settings.banner_promotional_format_mobile == 'slider' and settings.banner_promotional_format_desktop == 'slider' %}
    {% set section_slider_mobile = settings.banner_promotional_format_mobile == 'slider' %}
    {% set section_slider_mobile_only = settings.banner_promotional_format_mobile == 'slider' and settings.banner_promotional_format_desktop == 'grid' %}
    {% set section_slider_desktop_only = settings.banner_promotional_format_desktop == 'slider' and settings.banner_promotional_format_mobile == 'grid' %}
    {% set section_id = mobile ? 'banner-promotional-mobile' : 'banner-promotional' %}
    {% set section_first = settings.home_order_position_1 == 'promotional' %}
    {% set section_columns_desktop_4 = settings.banner_promotional_columns_desktop == 4 %}
    {% set section_columns_desktop_3 = settings.banner_promotional_columns_desktop == 3 %}
    {% set section_columns_desktop_2 = settings.banner_promotional_columns_desktop == 2 %}
    {% set section_columns_desktop_1 = settings.banner_promotional_columns_desktop == 1 %}
    {% set section_align_text = settings.banner_promotional_align == 'center' ? 'text-center textbanner-text-center ' %}
    {% set section_without_margins = settings.banner_promotional_without_margins %}
    {% set section_text_outside = settings.banner_promotional_text_outside %}
    {% set section_text_above_class = not section_text_outside ? 'textbanner-text-above' : 'textbanner-text-background' %}
    {% set section_button_outside_class = not section_without_margins ? 'swiper-button-outside svg-icon-text' : 'svg-icon-invert' %}
    {% set section_without_margin_class = section_without_margins ? 'm-0' %}
{% endif %}
{% if banner_news %}
    {% set has_banners = settings.banner_news and settings.banner_news is not empty %}
    {% set has_mobile_banners = settings.toggle_banner_news_mobile and settings.banner_news_mobile and settings.banner_news_mobile is not empty %}
    {% set section_banner = mobile ? settings.banner_news_mobile : settings.banner_news %}
    {% set section_slider = settings.banner_news_format_mobile == 'slider' or settings.banner_news_format_desktop == 'slider' %}
    {% set section_slider_toggle_mobile = settings.toggle_banner_news_mobile %}
    {% set section_slider_both = settings.banner_news_format_mobile == 'slider' and settings.banner_news_format_desktop == 'slider' %}
    {% set section_slider_mobile = settings.banner_news_format_mobile == 'slider' %}
    {% set section_slider_mobile_only = settings.banner_news_format_mobile == 'slider' and settings.banner_news_format_desktop == 'grid' %}
    {% set section_slider_desktop_only = settings.banner_news_format_desktop == 'slider' and settings.banner_news_format_mobile == 'grid' %}
    {% set section_id = mobile ? 'banner-news-mobile' : 'banner-news' %}
    {% set section_first = settings.home_order_position_1 == 'news_banners' %}
    {% set section_columns_desktop_4 = settings.banner_news_columns_desktop == 4 %}
    {% set section_columns_desktop_3 = settings.banner_news_columns_desktop == 3 %}
    {% set section_columns_desktop_2 = settings.banner_news_columns_desktop == 2 %}
    {% set section_columns_desktop_1 = settings.banner_news_columns_desktop == 1 %}
    {% set section_align_text = settings.banner_news_align == 'center' ? 'text-center textbanner-text-center ' %}
    {% set section_without_margins = settings.banner_news_without_margins %}
    {% set section_text_outside = settings.banner_news_text_outside %}
    {% set section_text_above_class = not section_text_outside ? 'textbanner-text-above' : 'textbanner-text-background' %}
    {% set section_button_outside_class = not section_without_margins ? 'swiper-button-outside svg-icon-text' : 'svg-icon-invert' %}
    {% set section_without_margin_class = section_without_margins ? 'm-0' %}
{% endif %}
{% if module %}
    {% set section_banner = settings.module %}
    {% set section_slider = settings.module_slider %}
    {% set section_id = 'module' %}
    {% set section_without_margins = false %}
    {% set section_text_outside = true %}
    {% set section_first = settings.home_order_position_1 == 'modules' %}
    {% set section_text_above_class = 'textbanner-text-background textbanner-text-centered-content h-100 p-3 p-md-4 text-center' %}
    {% set section_grid_classes = 'grid grid-md-2 grid-no-gap align-items-center mb-md-5 overflow-none' %}
    {% set section_button_outside_class = 'swiper-button-outside svg-icon-text' %}
{% endif %}

{% set visibility_classes = 
    has_banners and has_mobile_banners ? (mobile ? 'd-md-none' : 'd-none d-md-block') 
    : not has_banners and has_mobile_banners and not mobile ? 'd-none' 
%}

{% set grid_desktop_class = 
    section_columns_desktop_4 ? 'grid-md-4' : 
    section_columns_desktop_3 ? 'grid-md-3' : 
    section_columns_desktop_2 ? 'grid-md-2'
%}

{% set banner_title_classes = module ? 'mb-2' : 'my-2' %}
{% set banner_button_classes = module ? 'mb-2' %}

<div class="js-{{ section_id }}{% if not module %} {{ visibility_classes }}{% endif %}">
    <div class="js-banner-container container{% if section_without_margins %}-fluid overflow-none p-0{% else %} {% if section_slider and (section_slider_mobile or module) %} pr-0{% endif %} px-md-3{% endif %} position-relative">

        {% if section_slider %}
            {% set section_slider_classes = section_slider_both ? 'swiper-products-slider flex-nowrap' : section_slider_mobile_only ? 'swiper-mobile-only flex-nowrap flex-md-wrap' : section_slider_desktop_only ? 'swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0' %}
            <div class="js-swiper-{{ section_id }} swiper-container">
        {% endif %}
        <div class="js-banner-grid {% if section_slider %}swiper-wrapper {{ section_slider_classes }} {% endif %} {% if not module and not section_slider_both %}grid {{ grid_desktop_class }}{% endif %} {% if section_without_margins %}grid-no-gap{% endif %}">

            {% for slide in section_banner %}

                {% set has_banner_text = slide.title or slide.description or slide.button %}
                {% set banner_img_alt = slide.title ? banner_title : 'Banner de ' | translate ~ store.name %}
                {% set banner_align_text = slide.title ? banner_title : 'Banner de ' | translate ~ store.name %}
                {% set banner_link_classes = module and slide.link ? section_grid_classes %}
                {% set banner_container_classes = module and not slide.link ? section_grid_classes %}
                {% if module %}
                    {% set section_align_text = not section_slider and loop.index is even ? 'order-md-first ' %}
                {% endif %}

                {% set image_priority_high_value = 
                    section_first 
                    and loop.first and (
                        (has_mobile_banners and mobile) or
                        (not has_mobile_banners and has_banners) or module
                    )
                %}

                <div class="js-banner-item {% if section_slider %}swiper-slide {% endif %}">
                    {% include 'our/components/gallery-item.tpl' with {
                        gallery_image_name: slide.image,
                        gallery_image_width: slide.width,
                        gallery_image_height: slide.height,
                        gallery_image_classes: 'textbanner-image transition-soft img-fluid d-block w-100',
                        gallery_image_lazy_classes: 'fade-in',
                        gallery_image_lazy: true,
                        gallery_image_lazy_js: true,
                        galley_image_aspect_ratio: true,
                        gallery_image_priority_high: image_priority_high_value,
                        gallery_image_alt: banner_img_alt,

                        container_classes: 'js-textbanner textbanner transition-soft ' ~ banner_container_classes ~ section_without_margin_class,
                        text_classes: {
                            container: 'js-textbanner-text textbanner-text ' ~ section_align_text ~ section_text_above_class,
                            title: 'h2 ' ~ banner_title_classes,
                            description: 'textbanner-paragraph mt-2',
                        },

                        custom_content: not image_priority_high_value ? '<div class="placeholder placeholder-fade"></div>',

                        link_classes: {
                            link: banner_link_classes,
                            button: 'btn btn-primary mt-3 ' ~ banner_button_classes,
                        },

                    } %}
                </div>
            {% endfor %}
        </div>
        {% if section_slider %}
            </div>
            {% if section_banner and section_banner is not empty %}
                {% set section_button_classes = section_slider_mobile_only ? 'd-none' : 'd-none d-md-block' %}
                <div class="js-swiper-{{ section_id }}-pagination swiper-pagination swiper-pagination-outside swiper-pagination-bullets d-block d-md-none"></div>
                <div class="js-swiper-{{ section_id }}-prev swiper-button-prev {{ section_button_classes }} {{ section_button_outside_class }}">
                    <svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
                </div>
                <div class="js-swiper-{{ section_id }}-next swiper-button-next {{ section_button_classes }} {{ section_button_outside_class }}">
                    <svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
                </div>
            {% endif %}
        {% endif %}
    </div>
</div>
