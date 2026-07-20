<ul class="list list-unstyled">
	{% for language in languages | escape %}
		<li class="list-item {% if language.active %} font-weight-bold{% endif %}">
			<a href="{{ language.url }}" class="btn-link">
				{{ language.country_name }}
			</a>
		</li>
	{% endfor %}
</ul>