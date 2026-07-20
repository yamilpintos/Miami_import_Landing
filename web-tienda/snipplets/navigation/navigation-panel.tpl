{% if primary_links %}
    <div class="nav-list" data-store="navigation" data-component="menu">
        {% include 'snipplets/navigation/navigation-list-hamburger.tpl' %}
    </div>
    <div class="nav-secondary">
        {% if settings.head_secondary_menu_show %}
            {% include "snipplets/navigation/navigation-secondary.tpl" %}
        {% endif %}
    </div>
{% else %}
    <div class="d-flex"  data-store="account-links">
        <span class="mr-4">
            {% include "snipplets/header/utilities/account.tpl" with {mobile: true} %}
        </span>
        {% if languages | length > 1 %}
            {% include "snipplets/header/utilities/language.tpl" %}
        {% endif %}
    </div>
{% endif %}