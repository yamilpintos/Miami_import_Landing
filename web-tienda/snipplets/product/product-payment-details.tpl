{# Product payments details #}

{% if product.installments_info_from_any_variant %}

    {{ component(
        'modal',{
            modal_id: 'installments-modal',
            position: {
                appear_from: 'bottom',
            },
            layout: {
                width_desktop: 'large',
            },
            content: {
                title: 'Medios de pago' | t,
                body: 
                    component('payments/payments-details',
                    {
                        text_classes: {
                            text_accent: "text-accent",
                            subtitles: "h6 font-big mb-3",
                            text_big: "font-big",
                            text_small: "font-small",
                            align_right: "text-right",
                            opacity: "opacity-60"
                        },
                        spacing_classes: {
                            top_1x: "mt-1",
                            top_2x: "mt-2",
                            top_3x: "mt-3",
                            right_1x: "mr-1",
                            right_2x: "mr-2",
                            right_3x: "mr-3",
                            bottom_1x: "mb-1",
                            bottom_2x: "mb-2",
                            bottom_3x: "mb-3",
                            left_3x: "ml-3",
                        },
                        container_classes : {
                            payment_method: "card p-3 mb-3"
                        },
                        discounts_conditional_visibility: true
                    }),
                footer: '<span class="js-modal-close-private btn-link" data-target="#installments-modal">' ~ 'Volver al producto' | translate ~ '</span>',
            },
            icons: {
                close_icon_id: 'times',
            },
            modal_classes: {
                close_icon: 'icon-inline icon-2x',
            }
        }) 
    }}

{% endif %}
