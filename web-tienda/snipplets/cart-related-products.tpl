{# Set related products classes #}

{% set container_class = 'position-relative mt-4 mb-2 pt-2' %}
{% set products_container_class = 'position-relative px-md-5' %}
{% set title_conainer_class = 'text-center' %}
{% set title_class = 'font-big mb-3' %}
{% set slider_container_class = 'swiper-container' %}
{% set swiper_wrapper_class = 'swiper-wrapper ' %}
{% set slider_control_pagination_class = 'swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100 d-md-none' %}
{% set slider_control_class = 'icon-inline icon-2x' %}
{% set slider_controls_container_class = 'svg-icon-text swiper-button-outside-edge d-none d-md-block' %}
{% set slider_control_prev_class = 'swiper-button-prev ' ~ slider_controls_container_class %}
{% set slider_control_next_class = 'swiper-button-next ' ~ slider_controls_container_class %}
{% set control_next_svg_id = 'arrow-long' %}
{% set control_prev_svg_id = 'arrow-long' %}

{# Related cart products #}

{% set related_section_id = 'related-products-notification' %}

{% set related_products = related_products_list | length > 0 %}

{% if related_products %}
    {{ component(
        'products-section',{
            title: 'Sumá a tu compra' | translate,
            id: related_section_id,
            data_component: related_section_id,
            products_amount: related_products_list | length,
            products_array: related_products_list,
            product_template_path: 'snipplets/product-item.tpl',
            product_template_params: {'slide_item': true, 'reduced_item': true},
            slider_controls_position: 'bottom',
            slider_pagination: true,
            section_classes: {
                section: 'js-related-products-notification',
                container: container_class,
                title_container: title_conainer_class,
                title: title_class,
                products_container: products_container_class,
                slider_container: 'js-swiper-related-products-notification ' ~ slider_container_class,
                slider_wrapper: swiper_wrapper_class,
                slider_control: slider_control_class,
                slider_control_pagination: 'js-swiper-related-notification-pagination ' ~ slider_control_pagination_class,
                slider_control_prev_container: 'js-swiper-related-products-notification-prev ' ~ slider_control_prev_class,
                slider_control_prev: 'icon-flip-horizontal',
                slider_control_next_container: 'js-swiper-related-products-notification-next ' ~ slider_control_next_class,
            },
            control_next_svg_id: control_next_svg_id,
            control_prev_svg_id: control_prev_svg_id,
        })
    }}
{% endif %}
