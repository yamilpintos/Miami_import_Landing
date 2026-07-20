{% include 'snipplets/miami-page-header.tpl' %}
<div id="single-product" class="js-product-detail js-product-container js-has-new-shipping js-shipping-calculator-container" data-variants="{{product.variants_object | json_encode }}" data-store="product-detail">
	<div class="container pt-3 pt-md-4 pb-4">
		<div class="miami-product-cols">
			<div class="miami-product-cols__left">
				<div class="product-images mb-3 mb-md-0" data-store="product-image-{{ product.id }}">
					{% include 'snipplets/product/product-image.tpl' %}
				</div>
				<div class="miami-product-desc-inline">
					{% include 'snipplets/product/product-description.tpl' %}
				</div>
			</div>
			<div class="miami-product-cols__right">
				<div class="product-info" data-store="product-info-{{ product.id }}">
					{% include 'snipplets/product/product-form.tpl' %}
				</div>
			</div>
		</div>
	</div>
</div>

{# Related products #}
{% include 'snipplets/product/product-related.tpl' %}