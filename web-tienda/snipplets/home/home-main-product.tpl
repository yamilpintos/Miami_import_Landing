{% if sections.featured.products %}
	{% if settings.main_product_type == 'random' %}
		{% set product_type = sections.featured.products | shuffle | take(1) %}
	{% else %}
		{% set product_type = sections.featured.products | take(1) %}
	{% endif %}

	{% for product in product_type %}
		<section id="single-product" class="js-product-container section-home" data-variants="{{product.variants_object | json_encode }}" data-store="home-product-main">
			<div class="container mt-3 py-4">
				<div class="product-columns mb-4">
					<div class="product-images mb-4 mb-md-0" data-store="product-image-{{ product.id }}">
						{% include 'snipplets/product/product-image.tpl' with { home_main_product: true } %}
					</div>
					<div class="product-info" data-store="product-info-{{ product.id }}">
						{% include 'snipplets/product/product-form.tpl' with { home_main_product: true } %}
						{% if product.description is not empty %}
							<div class="mt-2">
								{# Product description #}
								<div class="js-product-description product-description user-content font-small">
									{{ product.description }}
								</div>
								<div class="js-view-description" style="display: none;">
									<div class="btn-link mt-3">
										<span class="js-view-more">
											{{ "Ver más" | translate }}
										</span>
										<span class="js-view-less" style="display: none;">
											{{ "Ver menos" | translate }}
										</span>
									</div>
								</div>
							</div>
						{% endif %}
					</div>
				</div>
			</div>
		</section>
	{% endfor %}
{% endif %}
