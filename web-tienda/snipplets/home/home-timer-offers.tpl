{% set theme_editor = params.preview %}

{# Set store timezone based on country main cities #}
{% set store_timezone = 
    store.country == 'AR' ? 'America/Argentina/Buenos_Aires' :
    store.country == 'BR' ? 'America/Sao_Paulo' :
    store.country == 'MX' ? 'America/Mexico_City' :
    store.country == 'CO' ? 'America/Bogota' :
    store.country == 'CL' ? 'America/Santiago' : 'UTC'
%}

{# Merchant's dates in 'DD/MM/YYYY HH:MM:SS' format cleaned for timestamp  #}
{% set start_date = settings.timer_offers_start_datetime|replace('/', '-')|replace(' ', '') %}
{% set end_date = settings.timer_offers_end_datetime|replace('/', '-')|replace(' ', '') %}

{# Define a regex pattern for the expected date format 'DD-MM-YYYY HH:MM:SS' or 'DD-MM-YYYY HH:MM' #}
{% set date_pattern = '/^\\d{2}-\\d{2}-\\d{4}(\\d{2}:\\d{2}(?::\\d{2})?)?$/' %}

{# Validate date formats #}
{% set start_date_valid = start_date matches date_pattern %}
{% set end_date_valid = end_date matches date_pattern %}


{# Set timestamps to null if date formats are not valid #}

{% set valid_offer_date = false %}

{% if start_date_valid and end_date_valid %}
    
    {# Get dates timestamp (start, end and current based on timezone) by using Unix timestamp for comparison #}

    {% set start_timestamp = start_date|date('U') %}
    {% set end_timestamp = end_date|date('U') %}
    {% set valid_offer_date = (start_timestamp and end_timestamp) and (end_timestamp > start_timestamp)  %}
{% endif %}

{% set timer_offers = theme_editor or (not theme_editor and valid_offer_date) %}

{# Show timer offers if there is start/end dates or is theme editor context #}

{% if timer_offers %}
    
    {# Content #}

    {% set timer_offers_title = settings.timer_offers_title %}
    {% set timer_offers_text = settings.timer_offers_text %}
    {% set timer_offers_button_text = settings.timer_offers_button %}
    {% set timer_offers_url = settings.timer_offers_url %}
    {% set timer_offers_button = timer_offers_button_text and timer_offers_button_url %}
    {% set timer_offers_image = "timer_offers_image.jpg" | has_custom_image %}
    {% set timer_offers_mobile_image = "timer_offers_image_mobile.jpg" | has_custom_image %}
    {% set section_products = sections.timer_offers.products and settings.timer_offers_products_show %}

    {# Classes #}

    {% set timer_offers_text_align_classes = settings.timer_offers_align == 'center' ? 'text-center' : 'text-left' %}
    {% set timer_offers_button_align_classes = settings.timer_offers_align == 'left' ? 'align-self-start' : 'align-self-center' %} 
    {% set timer_offers_align_cards_classes = settings.timer_offers_align == 'center' ? 'align-self-center' %}
    {% set timer_offers_info_color_classes = settings.timer_offers_colors ? 'section-timer-offers-colors ' %}
    {% set timer_offers_info_margin_classes = section_products ? 'mr-md-2' %}
    {% set timer_offers_info_classes = 'js-timer-offers-info position-relative home-background-container d-flex align-items-center justify-content-center ' ~ timer_offers_info_color_classes ~ timer_offers_info_margin_classes %}

    <div class="js-timer-offers-container py-4 {% if not settings.timer_offers_full %} container{% endif %} {% if section_products and theme_editor %}d-grid grid-md-2{% endif %} align-items-center" data-start-timestamp="{{ start_timestamp }}" data-end-timestamp="{{ end_timestamp }}" data-timezone="{{ store_timezone }}" data-products="{{ sections.timer_offers.products ? 'true' : 'false' }}" {% if not theme_editor %}style="display: none;"{% endif %}>
        {% if timer_offers_url %}
            <a href="{{ timer_offers_url }}" class="{{ timer_offers_info_classes }}">
        {% else %}
            <div class="{{ timer_offers_info_classes }}">
        {% endif %}
                {% if theme_editor or (not theme_editor and (timer_offers_image or timer_offers_mobile_image)) %}
                    <img {% if timer_offers_image %}src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-srcset='{{ "timer_offers_image.jpg" | static_url | settings_image_url('large') }} 480w, {{ "timer_offers_image.jpg" | static_url | settings_image_url('huge') }} 640w, {{ "timer_offers_image.jpg" | static_url | settings_image_url('original') }} 1024w, {{ "timer_offers_image.jpg" | static_url | settings_image_url('1080p') }} 1920w'{% endif %} class='js-timer-offers-image lazyload img-absolute-centered-vertically fade-in {% if timer_offers_mobile_image %}d-none d-md-block{% endif %}'{% if not timer_offers_image %} style="display: none;"{% endif %}/>
                    <img {% if timer_offers_mobile_image %}src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-srcset='{{ "timer_offers_image_mobile.jpg" | static_url | settings_image_url('large') }} 480w, {{ "timer_offers_image_mobile.jpg" | static_url | settings_image_url('huge') }} 640w, {{ "timer_offers_image_mobile.jpg" | static_url | settings_image_url('original') }} 1024w'{% endif %} class="js-timer-offers-image-mobile lazyload img-absolute-centered-vertically fade-in {% if timer_offers_image %}d-block d-md-none{% endif %}"{% if not timer_offers_mobile_image %} style="display: none;"{% endif %}/>
                {% endif %}
                <div class="js-timer-offers-content timer-offers-content {% if section_products %}with-products{% endif %} py-5 px-4 py-md-4 m-md-5 w-100 {{ timer_offers_text_align_classes }} justify-content-center">
                    <h2 class="js-timer-offers-title h2 h1-md mb-3"{% if not timer_offers_title %} style="display: none"{% endif %}>{{ timer_offers_title }}</h2>
                    <p class="js-timer-offers-text mb-0"{% if not timer_offers_text %} style="display: none"{% endif %}>{{ timer_offers_text }}</p>
                    <div class="js-timer-offers-cards my-3 py-2 timer-offers-cards d-grid {{ timer_offers_align_cards_classes }}">
                        {% set offer_card_classes = 'card px-2 py-3 px-md-3 text-center' %}
                        {% set offer_card_title_classes = 'h4 h2-md mb-2 mb-md-3 timer-offer-number' %}
                        {% set offer_card_text_classes = 'text-uppercase timer-offer-text' %}
                        <div class="{{ offer_card_classes }}">
                            <div class="{% if not theme_editor %}js-timer-offers-hour{% endif %} {{ offer_card_title_classes }}">00</div>
                            <div class="{{ offer_card_text_classes }}">{{ 'Horas' | translate }}</div>
                        </div>
                        <div class="{{ offer_card_classes }}">
                            <div class="{% if  not theme_editor %}js-timer-offers-minutes{% endif %} {{ offer_card_title_classes }}">00</div>
                            <div class="{{ offer_card_text_classes }}">{{ 'Minutos' | translate }}</div>
                        </div>
                        <div class="{{ offer_card_classes }}">
                            <div class="{% if not theme_editor %}js-timer-offers-seconds{% endif %} {{ offer_card_title_classes }}">00</div>
                            <div class="{{ offer_card_text_classes }}">{{ 'Segundos' | translate }}</div>
                        </div>
                    </div>
                    <span class="js-timer-offers-button btn btn-primary mb-3 {{ timer_offers_button_align_classes }}"{% if not (timer_offers_url and timer_offers_button_text) %} style="display:none;"{% endif %}>{{ timer_offers_button_text }}</span>
                </div>
        {% if timer_offers_url %}
            </a>
        {% else %}
            </div>
        {% endif %}
        {% if (not theme_editor and sections.timer_offers.products and settings.timer_offers_products_show) or (theme_editor and sections.timer_offers.products) %}

            {% set products_section_spacing_class = settings.timer_offers_full ? 'mr-md-4' : 'mx-md-0' %}
            {% set products_visibility_class = not settings.timer_offers_products_show ? 'd-none' %}

            {{ component(
                'products-section',{
                    products_array: sections.timer_offers.products,
                    product_template_path: 'snipplets/product-item.tpl',
                    product_template_params: {'slide_item': true},
                    slider_controls_position: 'with-section-title',
                    slider_pagination: true,
                    section_classes: {
                        section: 'js-timer-offers-products timer-offers-products position-relative ml-3 mr-0 mt-md-0 ml-md-2 overflow-none ' ~ products_section_spacing_class ,
                        container: 'pt-md-4',
                        slider_container: 'js-swiper-timer-offers swiper-container swiper-container-horizontal mb-4 pb-1',
                        slider_wrapper: 'swiper-wrapper swiper-products-slider',
                        slider_control: 'icon-inline icon-2x',
                        slider_control_pagination: 'js-swiper-timer-offers-pagination swiper-pagination swiper-pagination-bullets w-100',
                        slider_control_prev: 'icon-flip-horizontal',
                        slider_control_prev_container: 'js-swiper-timer-offers-prev position-relative swiper-button-prev svg-icon-text d-none d-md-inline-block',
                        slider_control_next_container: 'js-swiper-timer-offers-next position-relative swiper-button-next svg-icon-text d-none d-md-inline-block',
                    },
                    control_next_svg_id: 'arrow-long',
                    control_prev_svg_id: 'arrow-long',
                }) 
            }}
        {% endif %}
    </div>
{% endif %}
