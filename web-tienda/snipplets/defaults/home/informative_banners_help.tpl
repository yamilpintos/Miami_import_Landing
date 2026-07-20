{# Informative banners that work as examples #}

<div class="js-informative-banners-placeholder section-informative-banners">
	<div class="container py-5">
		<div class="js-empty-informative-banners swiper-container my-3">
			<div class="swiper-wrapper">
				{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_1': true} %}
				{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_2': true} %}
				{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_3': true} %}
				{% include 'snipplets/defaults/help_banner_services_item.tpl' with {'help_item_4': true} %}
			</div>
			<div class="js-empty-informative-banners-pagination swiper-pagination d-md-none swiper-pagination-outside"></div>
		</div>
	</div>
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-informative-banners-top" style="display:none">
	{% include 'snipplets/home/home-banners-services.tpl' %}
</div>
