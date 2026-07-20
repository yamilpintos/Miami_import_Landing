{% set nav_text_class = settings.desktop_main_nav_uppercase ? 'text-uppercase' %}
<ul class="nav-categories-mobile list-unstyled list-horizontal {{ nav_text_class }}">
	{% for category in categories %}
		<li class="nav-item list-item {% if loop.first %}ml-2{% endif %}">
			<a class="nav-list-link" href="{{ category.url }}">{{ category.name }}</a>
		</li>
	{% endfor %}
</ul>