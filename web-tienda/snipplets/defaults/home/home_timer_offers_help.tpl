{# Timer offers that work as examples #}

<div class="js-timer-offers-placeholder py-4 container">
    <div class="d-grid grid-md-2 align-items-center">
        <div class="position-relative home-background-container d-flex align-items-center justify-content-center mr-md-2">
            <div class="timer-offers-content timer-offers-content-placeholder with-products pb-5 px-4 py-md-4 m-md-5 w-100 justify-content-start text-left">
                <h2 class="h2 h1-md mb-3">{{ "Ofertas con temporizador" | translate }}</h2>
                <p class="mb-0">{{ "Usá este espacio para mostrar ofertas que duren un tiempo determinado" | t }}</p>
                <div class="my-3 py-2 timer-offers-cards d-grid">
                    {% set offer_card_classes = 'card px-2 py-3 px-md-3 text-center' %}
                    {% set offer_card_title_classes = 'h4 h2-md mb-2 mb-md-3 timer-offer-number' %}
                    {% set offer_card_text_classes = 'text-uppercase font-small font-md-body' %}
                    <div class="{{ offer_card_classes }}">
                        <div class="{{ offer_card_title_classes }}">24</div>
                        <div class="{{ offer_card_text_classes }}">{{ 'Horas' | translate }}</div>
                    </div>
                    <div class="{{ offer_card_classes }}">
                        <div class="h1 {{ offer_card_title_classes }}">60</div>
                        <div class="{{ offer_card_text_classes }}">{{ 'Minutos' | translate }}</div>
                    </div>
                    <div class="{{ offer_card_classes }}">
                        <div class="h1 {{ offer_card_title_classes }}">30</div>
                        <div class="{{ offer_card_text_classes }}">{{ 'Segundos' | translate }}</div>
                    </div>
                </div>
                <div class="placeholder-overlay transition-soft">
					<div class="placeholder-info">
						<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
						<div class="placeholder-description font-small-xs">
							{{ 'Podés mostrar ofertas con un tiempo limitado desde' | translate }} <strong>"{{ 'Ofertas con temporizador' | translate }}"</strong>
						</div>
						{% if not params.preview %}
							<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
						{% endif %}
					</div>
				</div>
            </div>
        </div>
        <section class="products-section timer-offers-products position-relative ml-3 mr-0 ml-md-2 overflow-none mx-md-0">
			<div class="pt-md-4">
				<div class="">
					<div class="js-swiper-timer-offers-empty-prev position-relative swiper-button-prev svg-icon-text d-none d-md-inline-block">
						<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
					</div>
					<div class="js-swiper-timer-offers-empty-next position-relative swiper-button-next svg-icon-text d-none d-md-inline-block">
						<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
					</div>
					<div class="js-swiper-timer-offers-empty-pagination swiper-pagination swiper-pagination-bullets w-100"></div>
				</div>
				<div class="js-swiper-timer-offers-empty swiper-container swiper-container-horizontal mb-5">
					<div class="swiper-wrapper swiper-products-slider">
						{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_1': true}  %}
						{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_2': true}  %}
						{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_4': true}  %}
						{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_6': true}  %}
						{% include 'snipplets/defaults/help_item.tpl' with {'slide_item': true, 'help_item_7': true}  %}
					</div>
				</div>
			</div>
		</section>
    </div>            
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-timer-offers-top" style="display:none">    
	{% include 'snipplets/home/home-timer-offers.tpl' %}
</div>