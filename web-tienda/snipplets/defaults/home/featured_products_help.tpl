{# Featured products that work as examples #}

<section class="section-featured-home" data-store="{{ data_store }}">
	<div class="container py-4">
		<h2 class="h4 mb-3">{{ products_title }}</h2>
		<div class="grid grid-1 grid-md-5">
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_1': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_2': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_3': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_4': true} %}
			{% include 'snipplets/defaults/help_item.tpl' with {'help_item_5': true} %}
		</div>
	</div>
</section>