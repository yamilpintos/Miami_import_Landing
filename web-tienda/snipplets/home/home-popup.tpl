{% set modal_body_content %}
	{% if "home_popup_image.jpg" | has_custom_image %}
		{{ component(
			'image',{
				image_name: "home_popup_image.jpg",
				image_classes: 'img-fluid w-100 mb-3',
				image_alt: banner_image_alt,
			})
		}}
	{% endif %}

	{% if settings.home_popup_txt %}
		<p class="font-medium mb-3">{{ settings.home_popup_txt }}</p>
	{% endif %}

	{% if settings.home_news_box %}
		<div id="news-popup-form-container" class="newsletter">
			{% include "snipplets/forms/newsletter.tpl" with {
				ajax_submit: true,
				form_id: 'news-popup-form',
				form_classes: 'js-news-form d-block',
				form_data_store: 'newsletter-form-popup',
				input_custom_class: 'js-mandatory-field',
				submit_custom_class: 'js-news-popup-submit',
			} %}
		</div>
	{% elseif settings.home_popup_btn and settings.home_popup_url %}
		<div class="">
			<a href="{{ settings.home_popup_url }}" class="btn btn-primary btn-medium">{{ settings.home_popup_btn }}</a>
		</div>
	{% endif %}
{% endset %}

{{ component(
	'modal',{
		modal_id: 'home-modal',
		layout: {
			width_mobile: 'small',
			width_desktop: 'small',
		},
		content: {
			title: settings.home_popup_title,
			body: modal_body_content,
		},
		icons: {
			close_icon_id: 'times',
		},
		modal_classes: {
			close_icon: 'icon-inline',
		}
	}) 
}}
