{# Main categories that work as examples #}

{% set slide_view_box = '0 0 1440 770' %}

<div class="js-main-categories-placeholder py-4">
	<div class="container position-relative text-center pr-0 px-md-3">
		<div class="js-swiper-categories-demo swiper-container w-auto">
			<div class="swiper-wrapper">
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_1': true}  %}
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_2': true}  %}
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_3': true}  %}
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_1': true}  %}
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_2': true}  %}
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_3': true}  %}
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_1': true}  %}
				{% include 'snipplets/defaults/home/main_category_item_help.tpl' with {'help_item_2': true}  %}
			</div>
		</div>
		<div class="js-swiper-categories-demo-prev swiper-button-prev swiper-button-outside svg-icon-text d-none d-md-block">
			<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
		</div>
		<div class="js-swiper-categories-demo-next swiper-button-next swiper-button-outside svg-icon-text d-none d-md-block">
			<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
		</div>
	</div>
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-main-categories-top" style="display:none">    
	{% include 'snipplets/home/home-categories.tpl' %}
</div>