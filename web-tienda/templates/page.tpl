<div class="container">
	{% embed "snipplets/page-header.tpl" %}
		{% block page_header_text %}{{ page.name }}{% endblock page_header_text %}
	{% endembed %}
	<div class="user-content pb-5">
		{{ page.content }}
	</div>
</div>