{% if products and has_filters_available %}
  <div class="visible-when-content-ready">
    {% if has_applied_filters %}
      {{ component(
        'filters/remove-filters',{
          container_classes: {
            filters_container: "mb-md-4 pb-md-2",
          },
          filter_classes: {
            applied_filters_label: "h6 font-weight-bold mb-2 d-none d-md-block ",
            remove: "chip",
            remove_icon: "chip-remove-icon",
            remove_all: "btn-link d-inline-block mt-1 mt-md-0 font-small",
          },
          remove_filter_svg_id: 'times',
        }) 
      }}
    {% else %}
      <h2 class="h6 mb-4 d-none d-md-block ">{{ 'Filtrar por' | t }}</h2>
    {% endif %}
    <div class="d-none d-md-block ">
      {{ component(
        'filters/filters',{
          container_classes: {
            filters_container: "visible-when-content-ready",
          },
          filter_classes: {
            parent_category_link: "d-block",
            parent_category_link_icon: "icon-inline icon-flip-horizontal mr-2 svg-icon-text",
            list: "mb-4 pb-4 list-unstyled bottom-line",
            list_item: "mb-2",
            list_link: "font-small",
            list_title: "font-small font-family-body text-uppercase mb-3",
            show_more_link: "d-inline-block btn-link font-small mt-1",
            checkbox_last: "m-0",
            price_group: 'price-filter-container filter-accordion mb-4 pb-2',
            price_title: 'font-weight-bold mb-4 font-body',
            price_submit: 'btn btn-default d-inline-block',
            price_group: 'price-filter-container mb-4 pb-2',
            price_title: 'font-small font-family-body text-uppercase mb-3',
            price_submit: 'btn btn-inline price-filter-btn svg-icon-mask'
          },
        }) 
      }}
    </div>
  </div>
{% endif %}