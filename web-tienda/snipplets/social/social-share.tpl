<div class="social-share {% if product.description is empty %}mt-3{% endif %}">
	{# Whatsapp button #}

	{% set social_share_class = 'social-share-button svg-icon-text mr-2' %}

	<a class="{{ social_share_class }} d-md-none" data-network="whatsapp" target="_blank" href="whatsapp://send?text={{ product.social_url }}" title="{{ 'Compartir en WhatsApp' | translate }}" aria-label="{{ 'Compartir en WhatsApp' | translate }}">
		<svg class="icon-inline"><use xlink:href="#whatsapp"/></svg>
	</a>

	{# Facebook button #}
	<a class="{{ social_share_class }}" data-network="facebook" target="_blank" href="https://www.facebook.com/sharer/sharer.php?u={{ product.social_url }}" title="{{ 'Compartir en Facebook' | translate }}" aria-label="{{ 'Compartir en Facebook' | translate }}">
		<svg class="icon-inline"><use xlink:href="#facebook-f"/></svg>
	</a>

	{# Twitter button #}
	<a class="{{ social_share_class }}" data-network="twitter" target="_blank" href="https://twitter.com/share?url={{ product.social_url }}" title="{{ 'Compartir en Twitter' | translate }}" aria-label="{{ 'Compartir en Twitter' | translate }}">
		<svg class="icon-inline"><use xlink:href="#twitter"/></svg>
	</a>

	{# Pinterest button #}
	<a class="js-pinterest-share {{ social_share_class }}" data-network="pinterest" target="_blank" href="#" title="{{ 'Compartir en Pinterest' | translate }}" aria-label="{{ 'Compartir en Pinterest' | translate }}">
		<svg class="icon-inline"><use xlink:href="#pinterest"/></svg>
	</a>

	<div class="js-pinterest-hidden social-share-button" style="display: none;" data-network="pinterest">
		{{product.social_url | pin_it('https:' ~ product.featured_image | product_image_url('large'))}}
	</div>
</div>