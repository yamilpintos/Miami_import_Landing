{% set selected_option = loop.first or cart.shipping_option == option.name %}
<div class="js-shipping-suboption mt-2 {{suboptions.name}}">

    {% if suboptions.options %}

        {# Read only suboptions inside popup #}

        {% set modal_id_val = (suboptions.name | sanitize) ~ '-pickup-modal-' ~ random() %}

        <button data-target="#{{ modal_id_val }}" class="js-modal-open-private btn btn-link font-small">{{ 'Ver direcciones' | translate }}</button>

        {% set pickup_points_list %}
            <ul class="font-medium mb-4 pl-3 m-0">
                {% for option in suboptions.options %}
                    <li class="text-capitalize mb-2">{{ option.name | lower }}</li>
                {% endfor %}
            </ul>
            <div class="mt-3 font-medium">
                <span>{{ 'Cercanos al CP:'}}</span> <span class="font-weight-bold">{{cart.shipping_zipcode}}</span>
            </div>
            <div class="mt-2 pb-2 font-small">
                <svg class="icon-inline svg-icon-text"><use xlink:href="#info-circle"/></svg>
                <i>{{ "Vas a poder elegir estas opciones antes de finalizar tu compra" | translate }}</i>
            </div>
        {% endset %}

        {{ component(
            'modal',{
                modal_id: modal_id_val,
                data_component: modal_id_val,
                layout: {
                    width_mobile: 'small',
                    width_desktop: 'small',
                },
                content: {
                    title: 'Puntos de retiro' | translate,
                    body: pickup_points_list,
                },
                icons: {
                    close_icon_id: 'times',
                },
                modal_classes: {
                    close_icon: 'icon-inline',
                }
            }) 
        }}

    {% else %}
        <input type="hidden" name="{{suboptions.name}}"/>
        <div>{{ suboptions.no_options_message | translate }}</div>
    {% endif %}
</div>