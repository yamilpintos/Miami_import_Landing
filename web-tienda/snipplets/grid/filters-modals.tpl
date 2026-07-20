{% set sort_text = {
	'score-descending': 'our_components.sort_by.options.relevance' | tt,
	'user': 'our_components.sort_by.options.custom' | tt,
	'price-ascending': 'our_components.sort_by.options.price_ascending' | tt,
	'price-descending': 'our_components.sort_by.options.price_descending' | tt,
	'alpha-ascending': 'our_components.sort_by.options.alpha_ascending' | tt,
	'alpha-descending': 'our_components.sort_by.options.alpha_descending' | tt,
	'created-ascending': 'our_components.sort_by.options.created_ascending' | tt,
	'created-descending': 'our_components.sort_by.options.created_descending' | tt,
	'best-selling': 'our_components.sort_by.options.best_selling' | tt,
} %}

{% if products %}
	<div class="js-category-controls category-controls d-md-none grid{% if products and has_filters_available %} grid-no-gap grid-2{% endif %} mx-neg-3 my-3 top-line bottom-line">
		{% if has_filters_available %}
			<button class="js-modal-open-private py-2 right-line" data-target="#modal-filters" data-component="filter-button">
				<svg class="icon-inline svg-icon-text mr-2"><use xlink:href="#filter"/></svg>
				<span class="d-inline-block my-1">{{ 'Filtrar' | t }}</span>
			</button>
		{% endif %}
		<button class="js-modal-open-private py-2 grid grid-auto grid-no-gap align-items-center justify-content-center" data-target="#modal-sort-by">
			<svg class="icon-inline svg-icon-text mr-2"><use xlink:href="#sort-by"/></svg>
			<div class="text-left ml-1">
				<span class="d-inline-block my-1">{{ 'Ordenar por' | t }}:</span>
				{% for sort_method in sort_methods %}
					{% if sort_by == sort_method %}
						<div class="font-smallest font-weight-bold">
							{{ sort_text[sort_method] | t }}
						</div>
					{% endif %}
				{% endfor %}
			</div>
		</button>
	</div>
	<div class="js-category-controls-prev category-controls-sticky-detector"></div>
		{% if has_filters_available %}
			{{ component(
				'modal',{
					modal_id: 'modal-filters',
					data_component: 'modal-filters',
					position: {
						appear_from: 'left',
					},
					layout: {
						width_desktop: 'large',
					},
					content: {
						title: 'Filtrar por' | t,
						body: component(
						'filters/filters',{
							accordion: true,
							parent_category_link: false,
							applied_filters_badge: true,
							container_classes: {
								filters_container: "visible-when-content-ready",
							},
							accordion_classes: {
								title_container: "accordion-toggle align-items-center",
								title_col: "my-1 pr-3 d-flex align-items-center",
								title: "mb-0",
								actions_col: "my-1",
								title_icon: "icon-inline svg-icon-text"
							},
							filter_classes: {
								list: "list-unstyled my-3",
								list_item: "mb-2",
								list_link: "font-small",
								badge: "h1 ml-1",
								show_more_link: "d-inline-block btn-link font-small mt-1",
								checkbox_last: "m-0",
								price_group: 'price-filter-container filter-accordion',
								price_title: 'mb-3',
								price_submit: 'btn btn-inline price-filter-btn',
								applying_feedback_message: 'font-big mr-2',
								applying_feedback_icon: 'icon-inline font-big icon-spin svg-icon-text'
							},
							accordion_show_svg_id: 'chevron',
							accordion_hide_svg_id: 'chevron-down',
							applying_feedback_svg_id: 'spinner-third'
						}),
					},
					icons: {
						back_icon_id: 'chevron',
						close_icon_id: 'times',
					},
					modal_classes: {
						body: 'p-0',
						close_icon: 'icon-inline icon-2x',
					}
				}) 
			}}

		{% endif %}

		{{ component(
			'modal',{
				modal_id: 'modal-sort-by',
				data_component: 'modal-sort-by',
				position: {
					appear_from: 'bottom',
				},
				layout: {
					width_desktop: 'large',
				},
				content: {
					title: 'Ordenar por' | t,
					body: component(
					'sort-by',{
						list: true,
						sort_by_classes: {
							list_title: 'd-none',
							list: 'radio-button-container list-unstyled mb-3',
							list_item: 'radio-button-item',
							radio_button: "radio-button",
							radio_button_content: "radio-button-content",
							radio_button_icons_container: "radio-button-icons-container",
							radio_button_icon: "radio-button-icon",
							radio_button_label: "radio-button-label",
							applying_feedback_message: 'font-big mr-2',
							applying_feedback_icon: 'icon-inline font-big icon-spin svg-icon-text',
						},
						applying_feedback_svg_id: 'spinner-third',
					}),
				},
				icons: {
					back_icon_id: 'chevron',
					close_icon_id: 'times',
				},
				modal_classes: {
					modal: 'h-auto',
					close_icon: 'icon-inline icon-2x',
				}
			}) 
		}}
{% endif %}