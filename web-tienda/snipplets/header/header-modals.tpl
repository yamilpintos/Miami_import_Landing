{# Modal Hamburger #}

{{ component(
	'modal',{
		modal_id: 'nav-hamburger',
		data_component: 'nav-hamburger',
		position: {
			appear_from: 'left',
		},
		content: {
			body: include('snipplets/navigation/navigation-panel.tpl', {primary_links: true}),
			footer: include('snipplets/navigation/navigation-panel.tpl'),
		},
		icons: {
			close_icon_id: 'times',
		},
		modal_classes: {
			modal: 'modal-nav-hamburger modal-nav-main',
			header: 'no-title',
			close_icon: 'icon-inline icon-lg',
		}
	}) 
}}

{# Languages modal #}
{% if languages | length > 1 %}
	{{ component(
		'modal',{
			modal_id: 'modal-languages',
			data_component: 'modal-languages',
			layout: {
				width_mobile: 'small',
				width_desktop: 'small',
			},
			content: {
				title: 'Idiomas y monedas' | translate,
				body: include('snipplets/navigation/navigation-languages.tpl'),
			},
			icons: {
				close_icon_id: 'times',
			},
			modal_classes: {
				close_icon: 'icon-inline',
			}
		})
	}}
{% endif %}
{% if not store.is_catalog and settings.ajax_cart and template != 'cart' %} 
	
	{# Cart modal #}

	{{ component(
		'modal',{
			modal_id: 'modal-cart',
			data_component: 'cart',
			custom_data_attribute: 'cart-open-type',
			custom_data_attribute_value: settings.cart_open_type,
			form: true,
			form_action: store.cart_url,
			form_data_store: 'cart-form',
			position: {
				dock_desktop: true,
				appear_from: 'right',
			},
			layout: {
				width_desktop: 'small',
			},
			content: {
				title: "Carrito de compras" | translate,
				body: include('snipplets/cart/cart-panel.tpl'),
			},
			icons: {
				close_icon_id: 'times',
			},
			modal_classes: {
				modal: '',
				close_icon: 'icon-inline icon-2x',
			}
		}) 
	}}

	{% if settings.add_to_cart_recommendations %}

		{# Recommended products on add to cart #}

		{% set recommendations_content %}
			
			{# Product added info #}

			{{ component(
				'notification',{
					type: 'add_to_cart',
					related_products: true,
					modal_dismiss_target: 'related-products-notification',
					notification_classes: {
						notification_cart_container: 'd-md-grid grid-1-auto',
						notification: 'p-0 mb-3',
						cart_item_image_container: 'mr-3',
						cart_item_image: 'img-absolute-centered-vertically',
						cart_item_name: 'mb-1',
						cart_item: 'd-grid grid-auto-1',
						cart_item_info_container: 'font-medium font-md-small',
						cart_item_price_container: 'mb-1',
						notification_cart_products_amount: 'pr-3',
						notification_cart_totals_container: 'd-grid grid-1-auto mb-2 pb-1',
						notification_cart_total: 'js-cart-widget-total',
						notification_cart_button: 'js-open-cart-modal btn btn-primary btn-block',
					}
				}) 
			}}
			
			{# Product added recommendations #}

			<div class="js-related-products-notification-container" style="display: none"></div>
		{% endset %}


		{{ component(
			'modal',{
				modal_id: 'related-products-notification',
				layout: {
					width_desktop: '600px',
				},
				content: {
					title: "¡Agregado al carrito!" | translate,
					body: recommendations_content,
				},
				icons: {
					close_icon_id: 'times',
				},
				modal_classes: {
					modal: 'h-auto',
					close_icon: 'icon-inline icon-2x',
				}
			}) 
		}}
	{% endif %}

	{# Cross selling promotion notification on add to cart #}

	{{ component(
		'modal',{
			modal_id: 'js-cross-selling-modal',
			position: {
				appear_from: 'bottom',
			},
			content: {
				title: '¡Descuento exclusivo!' | translate,
				body: '<div class="js-cross-selling-modal-body" style="display: none"></div>'
			},
			icons: {
				close_icon_id: 'times',
			},
			layout: {
				width_desktop: 'small'
			},
			modal_classes: {
				modal: 'modal-nav-main bottom modal-bottom-sheet h-auto overflow-none modal-body-scrollable-auto modal-max-98vh',
				header: 'p-quarter full-width',
				close_icon: 'icon-inline icon-lg',
			}
		}) 
	}}
{% endif %}
