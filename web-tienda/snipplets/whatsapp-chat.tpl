{% if store.whatsapp %}
    <a href="{{ store.whatsapp }}" target="_blank" class="btn-whatsapp" aria-label="{{ 'Comunicate por WhatsApp' | translate }}">
        <svg class="icon-inline"><use xlink:href="#whatsapp"/></svg>
    </a>
{% endif %}
