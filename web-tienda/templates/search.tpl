{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{% if settings.pagination == 'infinite' %}
	{% paginate by 12 %}
{% else %}
	{% paginate by 60 %}
{% endif %}

{% include 'snipplets/miami-page-header.tpl' %}
<section class="category-body">
	<div class="container{% if has_filters_available or has_applied_filters %} py-4{% endif %}">
		<div class="{% if has_filters_available or has_applied_filters %}grid grid-md-auto mb-md-4 align-items-end {% endif %}py-4">
			<div class="mb-1">
				<h1 class="h4 mb-2 mb-md-0 miami-category-title">
					{% if products or has_applied_filters %}
						{{ "Resultados de búsqueda" | translate }}
					{% else %}
						{{ "No encontramos nada para" | translate }}<span class="ml-2">"{{ query }}"</span>
					{% endif %}
				</h1>
			</div>
			{% if products %}
				<div class="d-none d-md-block">
					{{ component(
						'sort-by',{
							sort_by_classes: {
								container: 'mb-1',
								select_group: "d-inline-block w-auto mb-0",
								select_label: "font-small d-block mb-1",
								select: "form-select-small",
								select_svg: "icon-inline icon-xs icon-w-14 svg-icon-text",
							},
							select_svg_id: 'chevron-down'
						}) 
					}}
				</div>
			{% endif %}
		</div>
		{% if products %}
			<h2 class="font-body font-family-body mb-4 pb-2 font-weight-normal">
				{{ "Mostrando" | translate }} <strong>{{ products_count }}</strong>
				{% if products | length > 1 %}
					{{ "resultados para" | translate }}
				{% else %}
					{{ "resultado para" | translate }}
				{% endif %}
				<span class="font-weight-bold">"{{ query }}"</span>
			</h2>
		{% endif %}
    {% include 'snipplets/grid/filters-modals.tpl' %}
		{% if products %}
			<div class="grid{% if products and has_filters_available %} grid-md-auto-4{% endif %}">
		{% endif %}
				{% include 'snipplets/grid/filters-controls.tpl' %}
				{% include 'snipplets/grid/products-list.tpl' %}
		{% if products %}
			</div>
		{% endif %}
	</div>
</section>
