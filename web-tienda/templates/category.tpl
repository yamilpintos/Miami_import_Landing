{% set has_filters_available = products and has_filters_enabled and (filter_categories is not empty or product_filters is not empty) %}

{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}

{% if settings.pagination == 'infinite' %}
	{% paginate by 12 %}
{% else %}
	{% paginate by 60 %}
{% endif %}

{% set category_banner = (category.images is not empty) or ("banner-products.jpg" | has_custom_image) %}

{% if not show_help %}
	{% include 'snipplets/miami-page-header.tpl' %}
	<section class="category-body" data-store="category-grid-{{ category.id }}">
		<div class="container py-4">
			{% if category_banner %}
				{% include 'snipplets/category-banner.tpl' %}
			{% endif %}
			<div class="grid grid-md-auto mb-md-4 align-items-end">
				<div class="mb-1">
					<h1 class="h4 mb-0 miami-category-title">{{ category.name }}</h1>
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
			{% include 'snipplets/grid/filters-modals.tpl' %}
			<div class="grid{% if products and has_filters_available %} grid-md-auto-4{% endif %}">
				{% include 'snipplets/grid/filters-controls.tpl' %}
				{% include 'snipplets/grid/products-list.tpl' %}
		</div>
	</section>
{% elseif show_help %}
	{# Category placeholder #}
	{% include 'snipplets/defaults/show_help_category.tpl' %}
{% endif %}
