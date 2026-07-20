<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml" xmlns:og="http://opengraphprotocol.org/schema/" lang="{% for language in languages %}{% if language.active %}{{ language.lang }}{% endif %}{% endfor %}">
	<head>

		{{ component('head-tags') }}

		<link rel="preconnect" href="https://fonts.googleapis.com" />
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
		
		<link rel="preload" as="style" href="{{ [settings.font_headings, settings.font_rest] | google_fonts_url('400,700') }}" />
		<link rel="preload" href="{{ 'css/style-critical.scss' | static_url }}" as="style" />
		<link rel="preload" href="{{ 'css/style-utilities.scss' | static_url }}" as="style" />
		<link rel="preload" href="{{ 'js/external-no-dependencies.js.tpl' | static_url }}" as="script" />

		{#/*============================================================================
			#CSS and fonts
		==============================================================================*/#}

		<style>
			{# Font families #}

			{{ component(
				'fonts',{
					font_weights: '400,700',
					font_settings: 'settings.font_headings, settings.font_rest'
				})
			}}

			{# General CSS Tokens #}

			{% include "static/css/style-tokens.tpl" %}
		</style>

		{# Critical CSS #}

		{{ 'css/style-critical.scss' | static_url | static_inline }}
		{{ 'css/style-utilities.scss' | static_url | static_inline }}

		{# Load async styling not mandatory for first meaningfull paint #}

		<link rel="stylesheet" href="{{ 'css/style-async.scss' | static_url }}" media="print" onload="this.media='all'">

		{# Loads custom CSS added from Advanced Settings on the admin´s theme customization screen #}

		<style>
			{{ settings.css_code | raw }}
		</style>

		{#/*============================================================================
			#Javascript: Needed before HTML loads
		==============================================================================*/#}

		{# Defines if async JS will be used by using script_tag(true) #}

		{% set async_js = true %}

		{# Defines the usage of jquery loaded below, if nojquery = true is deleted it will fallback to jquery 1.5 #}

		{% set nojquery = true %}

		{# Loads private Tiendanube JS #}

		{% head_content %}

		{# Structured data to provide information for Google about the page content #}

		{{ component('structured-data') }}

	</head>
	<body class="body-password">

		{# Theme icons #}

		{% include "snipplets/svg/icons.tpl" %}

		{# Back to admin bar #}

		{{back_to_admin}}

		{# Page content #}

		{% set header_colors_classes = settings.header_colors ? 'head-colors' %}

        <header class="head-main {{ header_colors_classes }} text-center py-3">
            {{ component('logos/logo', {
                logo_size: 'large',
                logo_img_classes: 'transition-soft', 
                logo_text_classes: 'h3 m-0'}) 
            }}
        </header>
        <div class="flex-grow-1 h-100 d-flex align-items-center">
            <div class="container py-5">
                <div class="d-flex justify-content-center">
                    <div class="w-md-40">
                        <h2 class="h4 mb-4 text-center">{{ message }}</h2>
                        {% embed "snipplets/forms/form.tpl" with{form_id: 'password-form', submit_text: 'Desbloquear' | translate, submit_custom_class: 'btn-block btn-big', form_custom_class: 'w-100' } %}
                            {% block form_body %}

                                {% embed "snipplets/forms/form-input.tpl" with{input_for: 'password', type_password: true, input_name: 'password', input_label_text: 'Contraseña de acceso' | translate, input_placeholder: 'ej.: tucontraseña' | translate } %}
                                    {% block input_form_alert %}
                                        {% if invalid_password == true %}
                                            <div class="alert alert-danger mt-3">{{ 'La contraseña es incorrecta.' | translate }}</div>
                                        {% endif %}
                                    {% endblock input_form_alert %}
                                {% endembed %}
                            {% endblock %}
                        {% endembed %}
                    </div>
                </div>
            </div>
        </div>

        {# Footer #}

        {% snipplet "footer/footer.tpl" %}

		{# Javascript needed to footer logos lazyload #}

		{{ 'js/external-no-dependencies.js.tpl' | static_url | script_tag }}

		{# Google survey JS for Tiendanube Survey #}

		{{ component('google-survey') }}

	</body>
</html>
