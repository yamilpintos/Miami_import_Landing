<div class="{% if product_detail %}js-product-branches-container{% endif %} js-accordion-private-container {% if store.branches|length > 1 %}js-toggle-branches{% endif %}" data-store="branches">
    <div class="d-grid grid-1-auto align-items-center mb-3">
        <div class="form-label d-flex align-items-center mb-1">
            <svg class="icon-inline svg-icon-text icon-lg icon-w mr-2"><use xlink:href="#store"/></svg>
            {% if store.branches|length > 1 %}
                {{ 'Nuestros locales' | translate }}
            {% else %}
                {{ 'Nuestro local' | translate }}
            {% endif %}
        </div>
        {% if store.branches|length > 1 %}
            <button class="js-accordion-private-toggle btn btn-link font-small">
                <span class="js-accordion-private-toggle-active">
                    {{ 'Ver opciones' | translate }}
                    <svg class="icon-inline icon-md ml-1"><use xlink:href="#chevron-down"/></svg>
                </span>
                <span class="js-accordion-private-toggle-inactive" style="display: none;">
                    {{ 'Ocultar opciones' | translate }}
                    <svg class="icon-inline icon-md icon-flip-vertical ml-1"><use xlink:href="#chevron-down"/></svg>
                </span>
            </button>
        {% endif %}
    </div>

    {# Store branches #}

    <div class="js-accordion-private-content" {% if store.branches|length > 1 %}style="display: none;"{% endif %}>
        {% if not product_detail %}
            <div class="radio-buttons-group">
        {% endif %}
                <ul class="list-unstyled radio-button-container">

                    {% for branch in store.branches %}
                        <li class="{% if product_detail %}list-item box font-small{% else %}radio-button-item{% endif %} mb-2" data-store="branch-item-{{ branch.code }}">

                            {# If cart use radiobutton #}

                            {% if not product_detail %}
                                <label class="js-shipping-radio js-branch-radio radio-button box d-block {% if cart.shipping_data.code == branch.code %}selected{% endif %}" data-loop="branch-radio-{{loop.index}}">
                            
                                    <input 
                                    class="js-branch-method {% if cart.shipping_data.code == branch.code %} js-selected-shipping-method {% endif %} shipping-method" 
                                    data-price="0" 
                                    {% if cart.shipping_data.code == branch.code %}checked{% endif %} type="radio" 
                                    value="{{branch.code}}" 
                                    data-name="{{ branch.name }} - {{ branch.extra }}"
                                    data-code="{{branch.code}}" 
                                    data-cost="{{ 'Gratis' | translate }}"
                                    name="option" 
                                    style="display:none">
                                    <div class="radio-button-content">
                                       <div class="radio-button-icons-container">
                                            <span class="radio-button-icons">
                                                <span class="radio-button-icon unchecked"></span>
                                                <span class="radio-button-icon checked"></span>
                                            </span>
                                        </div>
                            {% endif %}
                                        <div class="{% if product_detail %}list-item-content{% else %}radio-button-label{% endif %}">
                                            <div class="d-grid grid-auto-1"> 
                                                <div class="mr-4">
                                                    {{ branch.name }} - {{ branch.extra }}
                                                </div>
                                                <div class="text-right font-small text-accent text-uppercase">
                                                    {{ 'Gratis' | translate }}
                                                </div>
                                            </div>
                                        </div>
                            {% if not product_detail %}
                                    </div>
                                </label>
                            {% endif %}
                        </li>
                    {% endfor %}
                </ul>
        {% if not product_detail %}
            </div>
        {% endif %}
    </div>
</div>