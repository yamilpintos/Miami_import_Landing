{% set slide_item = slide_item | default(false) %}

{% set item_view_box = '0 0 1000 1000' %}

<div class="product-item{% if slide_item %} js-item-slide swiper-slide{% endif %}">
	<div class="product-item-image-container">
		<a href="{{ store.url }}/product/example" title="{{ 'Producto de ejemplo' | translate }}">
			{% if help_item_1 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-1"/></svg>
			{% elseif help_item_2 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-2"/></svg>
			{% elseif help_item_3 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-3"/></svg>
			{% elseif help_item_4 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-4"/></svg>
			{% elseif help_item_5 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-5"/></svg>
			{% elseif help_item_6 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-6"/></svg>
			{% elseif help_item_7 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-7"/></svg>
			{% elseif help_item_8 %}
				<svg viewBox="{{ item_view_box }}"><use xlink:href="#item-product-placeholder-8"/></svg>
			{% endif %}
		</a>
		{% if help_item_2 %}
			<div class="labels product-labels">
				<div class="label shipping-label"> {{ "Gratis" | translate }}</div>
			</div>
		{% endif %}
	</div>
	<div class="product-item-information py-2">
		<a href="{{ store.url }}/product/example" title="{{ 'Producto de ejemplo' | translate }}" class="item-link">
			{% if help_item_1 %}
				<div class="labels">
					<div class="label label-accent mb-2">{{ "20% OFF" | translate }}</div>
				</div>
			{% elseif help_item_3 %}
				<div class="labels">
					<div class="label label-accent mb-2">{{ "35% OFF" | translate }}</div>
				</div>
			{% elseif help_item_7 %}
				<div class="labels">
					<div class="label label-accent mb-2">{{ "20% OFF" | translate }}</div>
				</div>
			{% endif %}
			<div class="product-item-name mb-2">{{ 'Producto de ejemplo' | translate }}</div>
			<div class="product-item-price-container mb-2">
				{% if help_item_1 %}
					{% if store.country == 'BR' %}
						<span id="compare_price_display" class="js-compare-price-display product-item-price-compare">
							{{"120000" | money }}
						</span>
						<span id="price_display" class="js-price-display product-item-price">
							{{"9600" | money }}
						</span>
					{% else %}
						<span id="compare_price_display" class="js-compare-price-display product-item-price-compare">
							{{"1200000" | money }}
						</span>
						<span id="price_display" class="js-price-display product-item-price">
							{{"96000" | money }}
						</span>
					{% endif %}
				{% elseif help_item_2 %}
					{% if store.country == 'BR' %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"68000" | money }}
						</span>
					{% else %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"680000" | money }}
						</span>
					{% endif %}
				{% elseif help_item_3 %}
					{% if store.country == 'BR' %}
						<span id="compare_price_display" class="js-compare-price-display product-item-price-compare">
							{{"28000" | money }}
						</span>
						<span id="price_display" class="js-price-display product-item-price">
							{{"18200" | money }}
						</span>
					{% else %}
						<span id="compare_price_display" class="js-compare-price-display product-item-price-compare">
							{{"280000" | money }}
						</span>
						<span id="price_display" class="js-price-display product-item-price">
							{{"182000" | money }}
						</span>
					{% endif %}
				{% elseif help_item_4 %}
					{% if store.country == 'BR' %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"32000" | money }}
						</span>
					{% else %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"320000" | money }}
						</span>
					{% endif %}
				{% elseif help_item_5 %}
					{% if store.country == 'BR' %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"24900" | money }}
						</span>
					{% else %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"249000" | money }}
						</span>
					{% endif %}
				{% elseif help_item_6 %}
					{% if store.country == 'BR' %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"42000" | money }}
						</span>
					{% else %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"420000" | money }}
						</span>
					{% endif %}
				{% elseif help_item_7 %}
					{% if store.country == 'BR' %}
						<span id="compare_price_display" class="js-compare-price-display product-item-price-compare">
							{{"46000" | money }}
						</span>
						<span id="price_display" class="js-price-display product-item-price">
							{{"36800" | money }}
						</span>
					{% else %}
						<span id="compare_price_display" class="js-compare-price-display product-item-price-compare">
							{{"460000" | money }}
						</span>
						<span id="price_display" class="js-price-display product-item-price">
							{{"368000" | money }}
						</span>
					{% endif %}
				{% elseif help_item_8 %}
					{% if store.country == 'BR' %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"12200" | money }}
						</span>
					{% else %}
						<span id="price_display" class="js-price-display product-item-price">
							{{"122000" | money }}
						</span>
					{% endif %}
				{% endif %}
			</div>
		</a>
	</div>
</div>