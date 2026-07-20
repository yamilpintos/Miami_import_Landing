{% set theme_editor = params.preview %}

{% set has_banner = has_banner | default(false) %}
{% set has_mobile_banners = (settings.toggle_banner_mobile and settings.banner_mobile and settings.banner_mobile is not empty) or theme_editor %}

{% set has_banner_promotional = has_banner_promotional | default(false) %}
{% set has_mobile_banners_promotional = (settings.toggle_banner_promotional_mobile and settings.banner_promotional_mobile and settings.banner_promotional_mobile is not empty) or theme_editor %}

{% set has_banner_news = has_banner_news | default(false) %}
{% set has_mobile_banners_news = (settings.toggle_banner_news_mobile and settings.banner_news_mobile and settings.banner_news_mobile is not empty) or theme_editor %}

{% set has_module = has_module | default(false) %}

{% if has_banner %}
    {% set data_store_name = 'categories' %}
    {% set section_name = 'banner' %}
    {% set section_format_mobile = settings.banner_format_mobile %}
    {% set section_format_desktop = settings.banner_format_desktop %}
    {% set section_columns_desktop = settings.banner_columns_desktop %}
    {% set section_grid_classes = settings.banner_columns_desktop == 4 ? 'grid-md-4' : settings.banner_columns_desktop == 3 ? 'grid-md-3' : settings.banner_columns_desktop == 2 ? 'grid-md-2' : 'grid-md-1' %}
    {% set section_text_position = settings.banner_text_outside ? 'outside' : 'above' %}
    {% set section_margin = settings.banner_without_margins ? 'false' : 'true' %}
    {% set section_align = settings.banner_align %}
{% elseif has_banner_promotional %}
    {% set data_store_name = 'promotional' %}
    {% set section_name = 'banner-promotional' %}
    {% set section_format_mobile = settings.banner_promotional_format_mobile %}
    {% set section_format_desktop = settings.banner_promotional_format_desktop %}
    {% set section_columns_desktop = settings.banner_promotional_columns_desktop %}
    {% set section_grid_classes = settings.banner_promotional_columns_desktop == 4 ? 'grid-md-4' : settings.banner_promotional_columns_desktop == 3 ? 'grid-md-3' : settings.banner_promotional_columns_desktop == 2 ? 'grid-md-2' : 'grid-md-1' %}
    {% set section_text_position = settings.banner_promotional_text_outside ? 'outside' : 'above' %}
    {% set section_margin = settings.banner_promotional_without_margins ? 'false' : 'true' %}
    {% set section_align = settings.banner_promotional_align %}
{% elseif has_banner_news %}
    {% set data_store_name = 'news' %}
    {% set section_name = 'banner-news' %}
    {% set section_format_mobile = settings.banner_news_format_mobile %}
    {% set section_format_desktop = settings.banner_news_format_desktop %}
    {% set section_columns_desktop = settings.banner_news_columns_desktop %}
    {% set section_grid_classes = settings.banner_news_columns_desktop == 4 ? 'grid-md-4' : settings.banner_news_columns_desktop == 3 ? 'grid-md-3' : settings.banner_news_columns_desktop == 2 ? 'grid-md-2' : 'grid-md-1' %}
    {% set section_text_position = settings.banner_news_text_outside ? 'outside' : 'above' %}
    {% set section_margin = settings.banner_news_without_margins ? 'false' : 'true' %}
    {% set section_align = settings.banner_news_align %}
{% else %}
    {% set section_name = 'module' %}
    {% set section_format = settings.module_slider ? 'slider' : 'grid' %}
    {% set section_margin = 'true' %}
{% endif %}

{% if has_banner or has_banner_promotional or has_banner_news or has_module %}
    <div class="js-home-{{ section_name }}" {% if has_module %}data-format="{{ section_format }}"{% else %}data-mobile-format="{{ section_format_mobile }}" data-desktop-format="{{ section_format_desktop }}" data-desktop-columns="{{ section_columns_desktop }}" data-grid-classes="{{ section_grid_classes }}" data-text="{{ section_text_position }}" data-align="{{ section_align }}"{% endif %} data-margin="{{ section_margin }}">
        {% if has_banner %}
            {% include 'snipplets/home/home-banners-grid.tpl' with {'banner': true} %}
            {% if has_mobile_banners %}
                {% include 'snipplets/home/home-banners-grid.tpl' with {'banner': true, mobile: true} %}
            {% endif %}
        {% endif %}
        {% if has_banner_promotional %}
            {% include 'snipplets/home/home-banners-grid.tpl' with {'banner_promotional': true} %}
            {% if has_mobile_banners_promotional %}
                {% include 'snipplets/home/home-banners-grid.tpl' with {'banner_promotional': true, mobile: true} %}
            {% endif %}
        {% endif %}
        {% if has_banner_news %}
            {% include 'snipplets/home/home-banners-grid.tpl' with {'banner_news': true} %}
            {% if has_mobile_banners_news %}
                {% include 'snipplets/home/home-banners-grid.tpl' with {'banner_news': true, mobile: true} %}
            {% endif %}
        {% endif %}
        {% if has_module %}
            {% include 'snipplets/home/home-banners-grid.tpl' with {'module': true} %}
        {% endif %}
    </div>
{% endif %}
