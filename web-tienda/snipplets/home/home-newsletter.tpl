{% set newsletter_contact_error = contact.type == 'newsletter' and not contact.success %}
{% set newsletter_title = settings.home_news_title %}
{% set newsletter_text = settings.home_news_text %}
{% set newsletter_image = "home_news_image.jpg" | has_custom_image %}
{% set newsletter_mobile_image = "home_news_image_mobile.jpg" | has_custom_image %}

<section class="section-newsletter-home py-4" data-store="home-newsletter">

	{{ component('nubesdk-slot', { type: 'before_section_newsletter' }) }}

	<div class="js-home-newsletter {% if not settings.news_full %} container{% endif %}">
		<div class="js-home-newsletter-container home-background-container{% if not (newsletter_image or newsletter_mobile_image) %} home-background-container-center{% endif %} {% if settings.home_news_colors %}section-newsletter-home-colors{% endif %}">
			<div class="js-home-newsletter-image-container position-relative order-md-last"{% if not (newsletter_image or newsletter_mobile_image) %} style="display:none;"{% endif %}>
				<img {% if newsletter_image %}src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-srcset='{{ "home_news_image.jpg" | static_url | settings_image_url('large') }} 480w, {{ "home_news_image.jpg" | static_url | settings_image_url('huge') }} 640w, {{ "home_news_image.jpg" | static_url | settings_image_url('original') }} 1024w, {{ "home_news_image.jpg" | static_url | settings_image_url('1080p') }} 1920w'{% endif %} class='js-home-newsletter-image lazyload img-fluid w-100 fade-in {% if newsletter_mobile_image %}d-none d-md-block{% endif %}'{% if not newsletter_image %} style="display: none;"{% endif %}/>
				<img {% if newsletter_mobile_image %}src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-srcset='{{ "home_news_image_mobile.jpg" | static_url | settings_image_url('large') }} 480w, {{ "home_news_image_mobile.jpg" | static_url | settings_image_url('huge') }} 640w, {{ "home_news_image_mobile.jpg" | static_url | settings_image_url('original') }} 1024w'{% endif %} class="js-home-newsletter-image-mobile lazyload img-fluid w-100 fade-in {% if newsletter_image %}d-block d-md-none{% endif %}"{% if not newsletter_mobile_image %} style="display: none;"{% endif %}/>
				<div class="placeholder placeholder-fade"></div>
			</div>
			<div class="js-newsletter newsletter p-4 p-md-5 mx-md-5">
				<h2 class="js-home-newsletter-title h4 mb-2"{% if not newsletter_title %} style="display: none"{% endif %}>{{ newsletter_title }}</h2>
				<p class="js-home-newsletter-text my-2"{% if not newsletter_text %} style="display: none"{% endif %}>{{ newsletter_text }}</p>

				{% include "snipplets/forms/newsletter.tpl" with {
					form_classes: 'my-4',
					form_empty_action_js: true,
					form_data_store: 'home-newsletter-form',
				} %}
			</div>
		</div>
	</div>

	{{ component('nubesdk-slot', { type: 'after_section_newsletter' }) }}
	
</section>
