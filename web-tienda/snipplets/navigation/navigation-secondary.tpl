<ul class="list-unstyled">
	{% for item in menus[settings.head_secondary_menu] %}
		<li class="secondary-menu-item {% if loop.last %}mr-0{% endif %}">
			<a class="secondary-menu-link" href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %}>{{ item.name }}</a>
		</li>
	{% endfor %}
</ul>