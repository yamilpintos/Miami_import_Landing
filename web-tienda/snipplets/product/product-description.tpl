{% set description_content = product.description is not empty or settings.show_product_fb_comment_box %}
<div class="w-md-60 mt-4 mb-2" data-store="product-description-{{ product.id }}">

	{# Product description #}

	{% if product.description is not empty %}
		<div class="font-weight-bold mb-3">{{ "Descripción" | translate }}</div>
		<div class="user-content mb-4">
			{{ product.description }}
		</div>
	{% endif %}

	{{ component('nubesdk-slot', { type: "after_product_description" }) }}

	{% if settings.show_product_fb_comment_box %}
		<div class="fb-comments section-fb-comments mb-3" data-href="{{ product.social_url }}" data-num-posts="5" data-width="100%"></div>
	{% endif %}
	<div id="reviewsapp"></div>

	{% include 'snipplets/social/social-share.tpl' %}

</div>
