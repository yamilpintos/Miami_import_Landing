{% if settings.quick_shop %}
	{% set modal_body_content %}
		<div class="js-quickshop-spinner text-center py-5 my-5" style="display: none;">
			<svg class="icon-inline icon-30px svg-icon-text icon-spin"><use xlink:href="#spinner-third"/></svg>
		</div>
		<div class="js-product-item-private js-item-product js-product-container js-quickshop-container" data-product-id="" data-variants="" data-quickshop-id="">
			<div class="grid grid-md-2">
				<div class="quickshop-image-container">
					<div class="js-quickshop-image-padding">
						<img srcset="" class="js-product-item-image-private js-quickshop-img img-fluid w-100"/>
					</div>
				</div>
				<div class="js-item-variants pt-3">
					<div class="js-item-name h4 mb-3" data-store="product-item-title-{{ product.id }}"></div>
					<div class="price-container mb-3" data-store="product-item-price-{{ product.id }}">
						<span class="js-compare-price-display price-compare font-medium"></span>
						<div class="d-flex align-items-center">
							<span class="js-price-display h3 font-family-body"></span>
						</div>
						{{ component('payment-discount-price', {
								visibility_condition: settings.payment_discount_price,
								location: 'product',
								container_classes: "mt-1 mb-3 font-big text-accent",
								text_classes: {
									price: 'h5 font-family-body'
								}
							})
						}}
					</div>						
					<div id="quickshop-form" class="mr-md-1"></div>
				</div>
			</div>
		</div>
	{% endset %}
	{{ component(
		'modal',{
			modal_id: 'quickshop-modal',
			data_component: 'quickshop-modal',
			position: {
				appear_from: 'bottom',
			},
			layout: {
				width_desktop: 'large',
			},
			content: {
				body: modal_body_content,
			},
			icons: {
				close_icon_id: 'times',
			},
			modal_classes: {
				header: 'modal-header-close-only',
				close_icon: 'icon-inline icon-2x',
			}
		}) 
	}}
{% endif %}
