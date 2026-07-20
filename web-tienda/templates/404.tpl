{# Only remove this if you want to take away the theme onboarding advices #}
{% set show_help = not has_products %}

{# Here we will add an example as a help, you can delete this after you upload your products #}

{% if show_help %}
	<div id="product-example">
		{# Product placeholder #}
		{% snipplet 'defaults/show_help_product.tpl' %}
	</div>
{% else %}
	<div id="page-error" class="container mb-4">
		{% embed "snipplets/page-header.tpl" %}
			{% block page_header_text %}{{ "Error" | translate }} - 404{% endblock page_header_text %}
		{% endembed %}
		<h2 class="h5 mb-3 mb-md-2">{{ "La página que estás buscando no existe." | translate }}</h2>
		{% set featured_products = sections.primary.products %}
		{% if featured_products | length > 1 %}
			<div class="my-2">{{ "Quizás te interesen los siguientes productos." | translate }}</div>
			<div class="position-relative py-4">
				<div class="js-swiper-featured swiper-container">
					<div class="js-products-featured-grid swiper-wrapper">
						{% for product in featured_products %}
							{% include 'snipplets/product-item.tpl' with {'slide_item': true, 'section_name': section_name } %}
						{% endfor %}
					</div>
				</div>
				<div class="js-swiper-featured-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100"></div>
				<div class="js-swiper-featured-prev swiper-button-prev svg-icon-text swiper-button-outside d-none d-md-block">
					<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
				</div>
				<div class="js-swiper-featured-next swiper-button-next svg-icon-text swiper-button-outside d-none d-md-block">
					<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
				</div>
			</div>
		{% endif %}
	</div>
{% endif %}