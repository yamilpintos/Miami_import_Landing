<div class="js-product-variants {% if quickshop %}js-product-quickshop-variants{% endif %} {% if not (settings.bullet_variants or settings.image_color_variants) %}grid grid-2 align-items-center{% endif %} mb-4">
	{% set has_size_variations = false %}
	{% if settings.bullet_variants %}
		{% set hidden_variant_select = ' d-none' %}
	{% else %}
		{% set hidden_variant_select = ' mb-0' %}
	{% endif %}
	{% for variation in product.variations %}
		{% if variation.name in ['Talle', 'Talla', 'Tamanho', 'Size'] %}
			{% set has_size_variations = true %}
		{% endif %}

		{% set is_hidden_select = false %}
		{% if settings.image_color_variants and not (settings.bullet_variants)  %}
			{% if variation.name in ['Color', 'Cor'] %}
				{% set hidden_variant_select = ' d-none' %}
				{% set is_hidden_select = true %}
			{% else %}
				{% set hidden_variant_select = ' d-block' %}
			{% endif %}
		{% endif %}

		{% set is_button_variant = settings.bullet_variants or (settings.image_color_variants and variation.name in ['Color', 'Cor']) %}

		<div class="js-product-variants-group {% if variation.name in ['Color', 'Cor'] %}js-color-variants-container{% endif %} {% if is_button_variant and show_size_guide and settings.size_guide_url and has_size_variations and loop.last %}mb-0{% endif %} {% if settings.bullet_variants %}mb-3{% endif %}" data-variation-id="{{ variation.id }}">
			{% if quickshop %}
				{% embed "snipplets/forms/form-select.tpl" with{select_label: true, select_label_name: '' ~ variation.name ~ '', select_for: 'variation_' ~ loop.index , select_id: 'variation_' ~ loop.index, select_name: 'variation' ~ '[' ~ variation.id ~ ']', select_group_custom_class: hidden_variant_select, select_custom_class: 'js-variation-option js-refresh-installment-data'} %}
					{% block select_options %}
						{% for option in variation.options %}
							<option value="{{ option.id }}" {% if product.default_options[variation.id] is same as(option.id) %}selected="selected"{% endif %}>{{ option.name }}</option>
						{% endfor %}
					{% endblock select_options%}
				{% endembed %}
			{% else %}
				{% embed "snipplets/forms/form-select.tpl" with{select_label: true, select_label_name: '' ~ variation.name ~ '', select_for: 'variation_' ~ loop.index , select_id: 'variation_' ~ loop.index, select_name: 'variation' ~ '[' ~ variation.id ~ ']', select_custom_class: 'js-variation-option js-refresh-installment-data', select_group_custom_class: hidden_variant_select} %}
					{% block select_options %}
						{% for option in variation.options %}
							<option value="{{ option.id }}" {% if product.default_options[variation.id] is same as(option.id) %}selected="selected"{% endif %} data-option="{{ option.id }}">{{ option.name }}</option>
						{% endfor %}
					{% endblock select_options%}
				{% endembed %}
			{% endif %}
			{% if is_button_variant %}
				<label class="form-label">{{ variation.name }}: <strong class="js-insta-variation-label">{{ product.default_options[variation.id] }}</strong></label>
				{% for option in variation.options %}
					<a data-option="{{ option.id }}" class="js-insta-variant btn btn-variant{% if product.default_options[variation.id] is same as(option.id) %} selected{% endif %}{% if variation.name in ['Color', 'Cor'] and (option.custom_data or settings.image_color_variants) %} btn-variant-color{% endif %}" title="{{ option.name }}" data-option="{{ option.id }}" data-variation-id="{{ variation.id }}">
						<span class="btn-variant-content {% if settings.image_color_variants and variation.name in ['Color', 'Cor'] %} btn-variant-content-square{% endif %}"{% if option.custom_data and variation.name in ['Color', 'Cor'] and (settings.bullet_variants and not settings.image_color_variants) %} style="background: {{ option.custom_data }}; border: 1px solid #eee"{% endif %} data-name="{{ option.name }}">
							{% if settings.image_color_variants and variation.name in ['Color', 'Cor'] %}
								{% if product.default_options[variation.id] is same as(option.id) %}
									<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-src="{{ product.featured_variant_image | product_image_url('thumb')}}" data-sizes="auto" class="lazyload img-absolute-centered-vertically" {% if image.alt %}alt="{{image.alt}}"{% endif %} />
								{% else %}
									{% for variant in product.variants if (variant.option1 == option.id) or (variant.option2 == option.id) or (variant.option3 == option.id) %}
										{% if loop.first %}
											<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-src="{{ variant.image | product_image_url('thumb') }}" data-sizes="auto" class="lazyload img-absolute-centered-vertically" />
										{% endif %}
									{% endfor %}
								{% endif %}
							{% endif %}
							{% if not(variation.name in ['Color', 'Cor']) or ((variation.name in ['Color', 'Cor']) and not option.custom_data and not settings.image_color_variants) %}
								{{ option.name }}
							{% endif %}
						</span>
					</a>
				{% endfor %}
			{% endif %}
		</div>
	{% endfor %}
	{% if show_size_guide and settings.size_guide_url and has_size_variations %}
		{% set has_size_guide_page_finded = false %}
		{% set size_guide_url_handle = settings.size_guide_url | trim('/') | split('/') | last %}

		{% for page in pages if page.handle == size_guide_url_handle and not has_size_guide_page_finded %}
			{% set has_size_guide_page_finded = true %}
			{% if has_size_guide_page_finded %}
				<a data-target="#size-guide-modal" data-modal-url="modal-fullscreen-size-guide" class="js-modal-open-private {% if settings.bullet_variants %}mt-1 mb-3{% else %}mt-3{% endif %}">
					<span class="btn-link font-small">{{ 'Guía de talles' | translate }}</span>
				</a>
				{{ component(
					'modal',{
						modal_id: 'size-guide-modal',
						position: {
							appear_from: 'bottom',
						},
						layout: {
							width_desktop: 'large',
						},
						content: {
							title: 'Guía de talles' | t,
							body: '<div class="user-content">' ~ page.content ~ '</div>',
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
		{% endfor %}
	{% endif %}
</div>