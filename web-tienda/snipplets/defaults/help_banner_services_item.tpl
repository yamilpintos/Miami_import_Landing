<div class="swiper-slide text-center">
	{% if help_item_1 %}
		<div class="mb-3">
			<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#truck"/></svg>
		</div>
		<h3 class="h6 mb-2">{{ "Información de envíos" | translate }}</h3>
	{% elseif help_item_2 %}
		<div class="mb-3">
			<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#credit-card"/></svg>
		</div>
		<h3 class="h6 mb-2">{{ "Información de pagos" | translate }}</h3>
	{% elseif help_item_3 %}
		<div class="mb-3">
			<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#security"/></svg>
		</div>
		<h3 class="h6 mb-2">{{ "Información de compra" | translate }}</h3>
	{% elseif help_item_4 %}
		<div class="mb-3">
			<svg class="icon-inline icon-2x svg-icon-text"><use xlink:href="#returns"/></svg>
		</div>
		<h3 class="h6 mb-2">{{ "Información de cambios" | translate }}</h3>
	{% endif %}
</div>
