{% for category in categories %}
	<li class="js-desktop-nav-item js-item-subitems-desktop nav-item nav-item-desktop">
		<a class="nav-list-link" href="{{ category.url }}">
			{{ category.name }}
		</a>
		{% set subcategories = category.subcategories(false) %}
		{% if subcategories %}
			<ul class="list-subitems">
				{% snipplet "navigation/navigation-categories-list-desktop.tpl" with categories = subcategories %}
			</ul>
		{% endif %}
	</li>
{% endfor %}