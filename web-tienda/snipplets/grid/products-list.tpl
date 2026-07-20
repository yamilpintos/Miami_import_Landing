{% set list_data_store = template == 'category' ? 'category-grid-' ~ category.id : 'search-grid' %}
{% set noFilterResult = "No tenemos resultados para tu búsqueda. Por favor, intentá con otros filtros." %}

{% set columns_mobile = settings.grid_columns_mobile %}
{% set columns_desktop = settings.grid_columns_desktop %}

{% set grid_mobile_class = 
	columns_mobile == 2 ? 'grid-2' :
	columns_mobile == 1 ? 'grid-1'
%}

{% set grid_desktop_class = 
	columns_desktop == 6 ? 'grid-md-6' : 
	columns_desktop == 5 ? 'grid-md-5' : 
	columns_desktop == 4 ? 'grid-md-4'
%}

<div data-store="{{ list_data_store }}">
  {% if products %}
    <div class="js-product-table grid {{ grid_mobile_class }} {{ grid_desktop_class }}">
      {% include 'snipplets/product_grid.tpl' %}
    </div>
    {% if settings.pagination == 'infinite' %}
      {% set pagination_type_val = true %}
    {% else %}
      {% set pagination_type_val = false %}
    {% endif %}

    {% include "snipplets/grid/pagination.tpl" with {infinite_scroll: pagination_type_val} %}
  {% else %}
    {% if template == 'category' or has_applied_filters %}
      <div class="font-big py-5 text-center" data-component="filter.message">
        {{(has_filters_enabled ? noFilterResult : "Próximamente") | translate}}
      </div>
    {% elseif template == 'search' %}
        {% set featured_products = sections.primary.products %}
        {% set empty_message_class = featured_products ? 'mb-2' : 'mb-4' %}
        <div class="{{ empty_message_class }}">
          {{ ( "Escribilo de otra forma y volvé a intentar.") | translate }}
        </div>
        {% if featured_products | length > 1 %}
          <div class="mb-2">{{ "O quizás te interesen los siguientes productos." | translate }}</div>
          <div class="position-relative py-4">
            <div class="js-swiper-featured swiper-container">
              <div class="js-products-featured-grid swiper-wrapper">
                {% for product in featured_products %}
                  {% include 'snipplets/product-item.tpl' with {'slide_item': true, 'section_name': section_name } %}
                {% endfor %}
              </div>
            </div>
            <div class="js-swiper-featured-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100"></div>
            <div class="js-swiper-featured-prev swiper-button-prev svg-icon-text swiper-button-outside d-none d-md-block">
              <svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
            </div>
            <div class="js-swiper-featured-next swiper-button-next svg-icon-text swiper-button-outside d-none d-md-block">
              <svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
            </div>
          </div>
        {% endif %}
    {% endif %}
  {% endif %}
</div>