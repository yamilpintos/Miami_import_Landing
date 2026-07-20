{% set has_home_institutional = false %}
{% set num_institutional = 0 %}
{% for institutional in ['institutional_01', 'institutional_02', 'institutional_03'] %}
	{% set institutional_title = attribute(settings,"#{institutional}_title") %}
	{% set institutional_description = attribute(settings,"#{institutional}_description") %}
	{% set institutional_button = attribute(settings,"#{institutional}_button") %}
	{% set has_institutional = institutional_title or institutional_description or institutional_button  %}
	{% if has_institutional %}
		{% set has_home_institutional = true %}
		{% set num_institutional = num_institutional + 1 %}
	{% endif %}
{% endfor %}

{% if has_home_institutional %}
	<div class="js-section-institutional-home section-home section-institutional-home overflow-none {% if settings.home_institutional_colors %}section-institutional-home-colors py-5{% else %}py-4{% endif %}">
		<div class="js-institutional-container container position-relative text-center">
			<div class="d-md-flex justify-content-center">
				<div class="institutional-container">
					<div class="js-swiper-institutional swiper-institutional swiper-container mb-3">
						<div class="swiper-wrapper">
							{% for institutional in ['institutional_01', 'institutional_02', 'institutional_03'] %}
								{% set institutional_title = attribute(settings,"#{institutional}_title") %}
								{% set institutional_description = attribute(settings,"#{institutional}_description") %}
								{% set institutional_button = attribute(settings,"#{institutional}_button") %}
								{% set institutional_link = attribute(settings,"#{institutional}_url") %}
								{% set has_institutional = institutional_title or institutional_description or institutional_button %}
								<div class="js-institutional-slide swiper-slide" {% if not has_institutional %}style="display: none;"{% endif %}>
									<h3 class="js-institutional-title js-institutional-title-{{ loop.index }} mb-2"{% if not institutional_title %} style="display:none"{% endif %}>{{ institutional_title }}</h3>
									<p class="js-institutional-description js-institutional-description-{{ loop.index }} mb-3"{% if not institutional_description %} style="display:none"{% endif %}>{{ institutional_description }}</p>
									<a href="{% if institutional_link %}{{ institutional_link }}{% else %}#{% endif %}" class="js-institutional-link js-institutional-button-{{ loop.index }} btn btn-link"{% if not institutional_button %} style="display:none"{% endif %}>{{ institutional_button }}</a>
								</div>
							{% endfor %}
						</div>
					</div>
				</div>
			</div>
			<div class="js-swiper-institutional-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100"{% if num_institutional == 1 %} style="display: none;"{% endif %}></div>
			<div class="js-swiper-institutional-prev swiper-button-prev svg-icon-text swiper-button-outside d-none d-md-block">
				<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
			</div>
			<div class="js-swiper-institutional-next swiper-button-next svg-icon-text swiper-button-outside d-none d-md-block">
				<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
			</div>
		</div>
	</div>
{% endif %}