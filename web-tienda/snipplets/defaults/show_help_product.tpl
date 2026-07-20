{# Product detail that work as example #}

{% include "snipplets/defaults/home/main_product_help.tpl" with {product_detail: true} %}

<section class="position-relative pb-4" data-store="related-products">
	<div class="container position-relative">
		<h2 class="h5 mt-3 mb-4">{{ "Productos relacionados" | translate }}</h2>
		<div class="js-swiper-related-empty swiper-container">
			<div class="swiper-wrapper swiper-products-slider">
				{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_1': true}  %}
				{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_2': true}  %}
				{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_4': true}  %}
				{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_6': true}  %}
				{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_7': true}  %}
			</div>
		</div>
		<div class="js-swiper-related-empty-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100 d-md-none"></div>
		<div class="js-swiper-related-empty-prev swiper-button-prev svg-icon-text swiper-button-outside d-none d-md-block">
			<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
		</div>
		<div class="js-swiper-related-empty-next swiper-button-next svg-icon-text swiper-button-outside d-none d-md-block">
			<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
		</div>
	</div>
</section>