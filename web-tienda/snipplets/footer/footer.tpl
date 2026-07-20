{# Content visibility conditions #}

{% set has_social_network = store.facebook or store.twitter or store.pinterest or store.instagram or store.tiktok or store.youtube %}
{% set has_footer_contact_info = (store.whatsapp or store.phone or store.email or store.address or store.blog) and settings.footer_contact_show %}
{% set has_footer_logo = "footer_logo.jpg" | has_custom_image %}
{% set has_footer_institutional_info = has_footer_logo or settings.footer_about_description %}
{% set has_footer_contact_or_institutional_info = has_social_network or has_footer_contact_info or has_footer_institutional_info %}
{% set has_footer_menu = settings.footer_menu and settings.footer_menu_show %}
{% set has_footer_menu_secondary = settings.footer_menu_secondary and settings.footer_menu_secondary_show %}
{% set has_menus = has_footer_menu or has_footer_menu_secondary %}
{% set theme_editor = params.preview %}
{% set password_page = template == 'password' %}

{# Footer classes #}

{% set footer_color_classes = settings.footer_colors ? 'footer-colors' %}
{% set footer_main_toggle_classes = settings.footer_menus_toggle ? 'footer-title-toggle' %}
{% set footer_social_spacing = has_menus ? 'mb-4' : 'mb-2' %}
{% set footer_grid_3_columns = 
	has_footer_contact_or_institutional_info 
	and (settings.news_show and ((has_footer_menu and not has_footer_menu_secondary) or 
	(not has_footer_menu and has_footer_menu_secondary)) 
	or (has_menus and not settings.news_show))
	? 'footer-main-info-md-3-columns' 
%}
{% set footer_mobile_toggle_title = has_menus and settings.footer_menus_toggle and (settings.footer_menu_title or settings.footer_menu_secondary_title)  %}
{% set footer_no_contact_info_classes = not has_footer_contact_or_institutional_info and footer_mobile_toggle_title ? 'pt-0 pt-md-4' %}
{% set footer_main_password_classes = password_page ? 'd-block text-md-center mb-5' %}
{% set footer_main_no_contact_info_classes = not has_footer_contact_or_institutional_info and footer_mobile_toggle_title ? 'mt-0 mt-md-3' %}
{% set footer_nav_no_contact_info_classes = not has_footer_contact_or_institutional_info ? 'mt-neg-1' %}

{{ component('nubesdk-slot', { type: "before_footer" }) }}

<footer class="js-footer js-hide-footer-while-scrolling {{ footer_color_classes }} {{ footer_no_contact_info_classes }} display-when-content-ready" data-store="footer">
	<div class="container footer-main-info {{ footer_main_password_classes }} {{ footer_main_toggle_classes }} {{ footer_grid_3_columns }} {{ footer_main_no_contact_info_classes }}">
		{% if has_footer_contact_or_institutional_info %}
			<div class="footer-contact-info-container {% if settings.footer_menus_toggle %}mb-3 mb-md-0{% endif %}">
				{% if has_footer_institutional_info %}
					<div class="pb-4">
				{% endif %}
						{% if has_footer_logo or theme_editor %}
							{% if theme_editor %}
								<div class="js-footer-logo-container" {% if not has_footer_logo %}style="display: none;"{% endif %}>
							{% endif %}
								{{ component(
									'image',{
										image_name: 'footer_logo.jpg',
										image_classes: 'js-footer-logo-img footer-logo-img mb-3',
										image_alt: store.name,
									})
								}}
							{% if theme_editor %}
								</div>
							{% endif %}
						{% endif %}
						{% if settings.footer_about_description or theme_editor %}
							<div class="js-footer-institutional mt-0 mb-3" {% if not settings.footer_about_description %}style="display: none;"{% endif %}>{{ settings.footer_about_description }}</div>
						{% endif %}
				{% if has_footer_institutional_info %}
					</div>
				{% endif %}
				{% if has_social_network %}
					<div class="{{ footer_social_spacing }}">
						{% include "snipplets/social/social-links.tpl" %}
					</div>
				{% endif %}
				{% if has_footer_contact_info and (has_menus and not password_page) %}
					{% include "snipplets/contact-links.tpl" %}
				{% endif %}
			</div>
		{% endif %}
		{% if not has_menus or password_page %}
			{% include "snipplets/contact-links.tpl" %}
		{% endif %}
		{% if not password_page %}
			{% if has_footer_menu %}
				<div class="footer-nav-container {{ footer_nav_no_contact_info_classes }}">
					{% include "snipplets/footer/footer-navigation.tpl" %}
				</div>
			{% endif %}
			{% if has_footer_menu_secondary %}
				<div class="footer-nav-container {{ footer_nav_no_contact_info_classes }}">
					{% include "snipplets/footer/footer-navigation.tpl" with {footer_menu_secondary: true} %}
				</div>
			{% endif %}
			{% if settings.news_show %}
				<div class="footer-newsletter-container {% if settings.footer_menus_toggle %}mt-4 mt-md-0 mb-3 mb-md-0{% endif %}">
					<div class="js-footer-news-title font-weight-bold" {% if not settings.news_title %}style="display: none;"{% endif %}>{{ settings.news_title }}</div>
					<div class="js-footer-news-description mt-4" {% if not settings.news_description %}style="display: none;"{% endif %}>{{ settings.news_description }}</div>
					{% include "snipplets/forms/newsletter.tpl" with {
						form_classes: 'mt-4',
						form_empty_action_js: true,
						form_data_store: 'newsletter-form',
					} %}
				</div>
			{% endif %}
		{% endif %}
	</div>
	{% include "snipplets/footer/footer-extra.tpl" %}
	<div class="container footer-secondary-info">
		{% include "snipplets/footer/footer-legal.tpl" %}
	</div>
</footer>