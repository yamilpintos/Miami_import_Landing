{# Main categories item demo #}

{% set main_category_view_box = '0 0 1000 1000' %}

<div class="swiper-slide w-auto mr-4">
	<div class="home-category">
		<div class="home-category-image textbanner-image-empty overflow-none">
			{% set help_item_path =  help_item_1 ? 'main-category-1' : help_item_2 ? 'main-category-2' : 'main-category-3'  %}
			<svg class="textbanner-image-empty-svg" viewBox="{{ main_category_view_box }}"><use xlink:href="#{{ help_item_path }}"/></svg>
		</div>
		<div class="my-3 ml-md-2 font-medium font-md-body">
			{{ 'Categoría' | translate }}
		</div>
	</div>
</div>