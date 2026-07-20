{% for category in categories %}
    {% if category.handle == category_handle %}
        {% set category_name = category.name %}
        <div class="my-3 ml-md-2 font-medium font-md-body">{{ category_name }}</div>
    {% endif %}
    {% include 'snipplets/home/home-categories-name.tpl' with { 'categories' : category.subcategories } %}
{% endfor %}