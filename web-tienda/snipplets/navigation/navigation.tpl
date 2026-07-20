{% set has_featured_link = settings.featured_link_url is not empty %}
{% if has_featured_link %}
    {% set featured_link_url = settings.featured_link_url | split('://') | last | split('/') | slice(1) | join('/') | trim('/') %}
{% endif %}

<div class="js-nav-desktop nav-desktop" data-featured-link="{{ has_featured_link ? 'true' : false }}" data-featured-link-url="{{ featured_link_url }}" data-featured-link-color="{{ settings.featured_link_color ? 'true' : 'false' }}">
    <ul class="js-nav-desktop-list nav-desktop-list" data-store="navigation" data-component="menu">
        <span class="js-nav-desktop-list-arrow js-nav-desktop-list-arrow-left nav-desktop-list-arrow nav-desktop-list-arrow-left disable" style="display: none">
            <svg class="icon-inline icon-flip-horizontal"><use xlink:href="#chevron"/></svg>
        </span>
            {% include 'snipplets/navigation/navigation-list-megamenu.tpl' %}
        <span class="js-nav-desktop-list-arrow js-nav-desktop-list-arrow-right nav-desktop-list-arrow nav-desktop-list-arrow-right" style="display: none">
            <svg class="icon-inline"><use xlink:href="#chevron"/></svg>
        </span>
    </ul>
</div>