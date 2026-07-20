{% if products and pages.is_last %}
	<div class="last-page" style="display:none;"></div>
{% endif %}
{% for product in products %}
	{% include 'snipplets/product-item.tpl' %}
{% endfor %}