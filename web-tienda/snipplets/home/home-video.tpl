{% set has_video_text = settings.video_title or settings.video_text or settings.video_button %}
{% set has_video_button = settings.video_button or settings.video_button_url %}
{% set has_video_full = settings.video_full %}
{% set video_url = settings.video_embed %}
{% set video_format = 
    '/watch?v=' in video_url ? '/watch?v=' :
    '/youtu.be/' in video_url ? '/youtu.be/' :
    '/shorts/' in video_url ? '/shorts/'
%}
{% set video_id = video_url|split(video_format)|last %}

<div class="js-home-video-section{% if not has_video_full %} container{% endif %} position-relative">
    <div class="js-home-video-container home-background-container{% if not has_video_text %} home-background-container-full{% endif %} {% if settings.home_video_colors %}section-video-home-colors{% endif %}" data-video="{{ video_id }}"{% if not video_url %} style="display: none"{% endif %}>
        <div class="js-home-video home-video lazyload embed-responsive embed-responsive-16by9{% if settings.video_vertical_mobile %} embed-responsive-1by1{% endif %} position-relative{% if settings.video_type == 'autoplay' %} home-video-autoplay{% endif %}">
            <a href="#" class="js-play-button video-player home-video-overlay"{% if settings.video_type == 'autoplay' %} style="display: none"{% endif %}>
                <div class="video-player-icon">
                    <svg class="icon-inline svg-icon-text ml-1"><use xlink:href="#play"/></svg>
                </div>
            </a>
            {% set has_video_first = settings.home_order_position_1 == 'video' %}
            <div class="js-home-video-image{% if has_video_first and settings.video_type == 'autoplay' %} d-block d-md-none{% endif %}"{% if not (has_video_first or settings.video_type == 'sound') %} style="display: none"{% endif %}>
                {% set custom_video_image = "video_image.jpg" | has_custom_image %}
                {% if custom_video_image %}
                    {% set video_image_static_url = "video_image.jpg" | static_url %}
                    {% set video_image_src = video_image_static_url | settings_image_url("large") %}
                {% else %}
                    {% set video_image_src = 'https://img.youtube.com/vi_webp/' ~ video_id ~ '/maxresdefault.webp' %}
                {% endif %}
                <img 
                    {% if has_video_first %}fetchpriority="high"{% endif %}
                    class="home-video-image{% if not has_video_first %} lazyload fade-in{% endif %}" 
                    {% if not has_video_first %}data-{% endif %}src='{{ video_image_src }}'
                    {% if custom_video_image %}
                        {% if not has_video_first %}data-{% endif %}srcset='{{ video_image_static_url | settings_image_url("original") }} 1024w, {{ video_image_static_url | settings_image_url("1080p") }} 1920w'
                    {% endif %} 
                    alt="{{ 'Video de' | translate }} {{ store.name }}" 
                />
                <div class="{% if settings.video_type == 'autoplay' %}js-video-placeholder placeholder-shine{% else %}placeholder-fade{% endif %} placeholder placeholder-shine-invert"></div>
            </div>
            <div class="js-home-video-iframe" id="player"></div>
            {% if settings.video_type == 'autoplay' %}
                <div class="home-video-hide-controls"></div>
            {% endif %}
        </div>
        <div class="js-home-video-text-container home-video-text order-md-first"{% if not has_video_text %} style="display:none;"{% endif %}>
            <h2 class="js-home-video-title my-2"{% if not settings.video_title %} style="display:none;"{% endif %}>{{ settings.video_title }}</h2>
            <p class="js-home-video-text mb-3"{% if not settings.video_text %} style="display:none;"{% endif %}>{{ settings.video_text }}</p>
            <a href="{% if settings.video_button_url %}{{ settings.video_button_url }}{% else %}#{% endif %}" class="js-home-video-button btn btn-primary mb-2"{% if not has_video_button %} style="display:none;"{% endif %}>{{ settings.video_button }}</a>
        </div>
    </div>
</div>
