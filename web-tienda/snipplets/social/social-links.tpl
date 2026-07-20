{# MIAMI_IMPORT: 'instagram' removido del loop — ya se renderiza en contact-links.tpl con texto + link #}
{% for sn in ['facebook', 'youtube', 'tiktok', 'twitter', 'pinterest'] %}
    {% set sn_url = attribute(store,sn) %}
    {% if sn_url %}
        <a class="mr-4 mb-4 d-inline-block" href="{{ sn_url }}" target="_blank" aria-label="{{ sn }} {{ store.name }}">
            {% if sn == "facebook" %}
                {% set social_network = sn ~ '-f' %}
            {% else %}
                {% set social_network = sn %}
            {% endif %}
            <svg class="icon-inline"><use xlink:href="#{{ social_network }}"/></svg>
        </a>
    {% endif %}
{% endfor %}