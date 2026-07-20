{% if product_modal %}

	{# Product video modal wrapper #}

	<div id="product-video-modal-{{ media.id }}" class="js-product-video-modal product-video-modal product-video" style="display: none;">
{% endif %}
		{% set is_external_video = not thumb and not product_native_video %}
		{% set is_standalone_video = product_video and not product_modal %}

		{% set is_native_video_home = product_native_video and home_main_product %}

		<div class="{% if is_external_video %}js-video{% endif %} {% if is_standalone_video %}js-video-product{% endif %} {% if not thumb %}embed-responsive embed-responsive-16by9 visible-when-content-ready{% endif %} position-relative {% if product_native_video %}product-native-video-container{% if is_native_video_home %} product-native-video-home{% endif %}{% endif %}">

			{% if thumb %}
				<div class="video-player">
			{% else %}
				{% if product_modal_trigger %}

					{# Open modal in mobile with product video inside #}

					<a id="trigger-video-modal-{{ media.id }}" href="#product-video-modal-{{ media.id }}" data-fancybox="product-gallery" class="js-play-button video-player {% if not home_main_product %}d-block d-md-none{% endif %} {% if home_main_product %}d-none{% endif %}">
						<div class="video-player-icon">
							<svg class="icon-inline svg-icon-text ml-1"><use xlink:href="#play"/></svg>
						</div>
					</a>
			{% endif %}
			{% set play_button_class = product_native_video ? 'js-play-native-button' : 'js-play-button' %}
			{% set play_visibility_class = (product_modal_trigger and not home_main_product) ? 'd-none d-md-block' : '' %}
			<a href="javascript:void(0)" {% if product_native_video %}data-video_uid="{{ media.next_video }}"{% endif %} class="{{ play_button_class }} video-player {{ play_visibility_class }}">
		{% endif %}
					<div class="video-player-icon {% if thumb %}video-player-icon-small{% endif %}">
						<svg class="icon-inline svg-icon-text {% if thumb %}icon-xs{% endif %} ml-1"><use xlink:href="#play"/></svg>
					</div>
			{% if thumb %}
				</div>
			{% else %}
				</a>
			{% endif %}

			{# Video thumbnail #}

			{% if product_native_video %}
				<div class="js-video-native-image w-100">
					<div data-video_uid="{{ media.uid }}" class="js-external-video-iframe-container embed-responsive" data-video-color="{{ settings.accent_color | trim('#') }}" style="display:none;">
						{{ media.render | raw }}
					</div>
					<img data-video_uid="{{ media.uid }}" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ media.thumbnail }}" class="video-image lazyload" alt="{{ 'Video de' | translate }} {% if template != 'product' %}{{ store.name }}{% else %}{{ product.name }}{% endif %}">
				</div>
			{% else %}
			<div class="js-video-image">
				<img src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-src="" class="lazyload {% if thumb %}video-image-thumb{% else %}video-image{% endif %} fade-in" alt="{{ 'Video de' | translate }} {% if template != 'product' %}{{ store.name }}{% else %}{{ product.name }}{% endif %}" style="display: none;">
					<div class="placeholder-fade">
					</div>
				</div>
			{% endif %}
	</div>

		{% if not thumb %}
			{% if not product_native_video %}
			{# Empty iframe component: will be filled with JS on play button click #}

				{% if product.video_url %}
				<div class="js-video-iframe embed-responsive embed-responsive-16by9" style="display: none;" data-video-color="{{ settings.accent_color | trim('#') }}" data-video-url="{{ product.video_url }}">
				</div>
				{% endif %}
			{% endif %}
		{% endif %}
{% if product_modal %}
	</div>
{% endif %}
