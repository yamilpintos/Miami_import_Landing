{% set has_home_testimonials = false %}
{% set num_testimonials = 0 %}
{% for testimonial in ['testimonial_01', 'testimonial_02', 'testimonial_03', 'testimonial_04', 'testimonial_05'] %}
	{% set testimonial_image = "#{testimonial}.jpg" | has_custom_image %}
	{% set testimonial_name = attribute(settings,"#{testimonial}_name") %}
	{% set testimonial_title = attribute(settings,"#{testimonial}_title") %}
	{% set testimonial_description = attribute(settings,"#{testimonial}_description") %}
	{% set has_testimonial = testimonial_name or testimonial_title or testimonial_description or testimonial_image %}
	{% if has_testimonial %}
		{% set has_home_testimonials = true %}
		{% set num_testimonials = num_testimonials + 1 %}
	{% endif %}
{% endfor %}

{% if has_home_testimonials %}
	<div class="js-section-testimonials section-testimonials-home overflow-none py-4">
		<div class="container position-relative text-md-center pr-0 px-md-3">
			<div class="js-testimonial-title-container" {% if not settings.testimonials_title %}style="display: none"{% endif %}>
				<h2 class="js-testimonial-main-title h4 mb-4">{{ settings.testimonials_title }}</h2>
			</div>
			<div class="js-testimonial-container py-3">
				<div class="js-swiper-testimonials swiper-testimonials swiper-container mb-3">
					<div class="swiper-wrapper">
						{% for testimonial in ['testimonial_01', 'testimonial_02', 'testimonial_03', 'testimonial_04', 'testimonial_05'] %}
							{% set testimonial_image = "#{testimonial}.jpg" | has_custom_image %}
							{% set testimonial_name = attribute(settings,"#{testimonial}_name") %}
							{% set testimonial_stars = attribute(settings,"#{testimonial}_stars") %}
							{% set testimonial_title = attribute(settings,"#{testimonial}_title") %}
							{% set testimonial_description = attribute(settings,"#{testimonial}_description") %}
							{% set has_testimonial = testimonial_name or testimonial_title or testimonial_description or testimonial_image %}
							
							<div class="js-testimonial-slide {% if loop.last %}js-last-testimonial-slide mr-md-0{% endif %} swiper-slide" {% if not has_testimonial %}style="display: none;"{% endif %}>
								<div class="d-inline-block mb-3"{% if not testimonial_image or not testimonial_name %}style="display: none"{% endif %}>
									<div class="testimonial-user text-left">
										<div class="js-testimonial-img-container position-relative" {% if not testimonial_image %}style="display: none"{% endif %}>
											{{ component(
												'image',{
													image_name: "#{testimonial}.jpg",
													image_classes: 'js-testimonial-img js-testimonial-img-' ~ loop.index ~ ' testimonial-image fade-in',
													image_width: slide.width,
													image_height: slide.height,
													image_lazy: true,
													image_lazy_js: true,
													custom_content: '<div class="placeholder placeholder-fade"></div>',
													image_alt: testimonial_name ? testimonial_name : 'Testimonio de' | translate ~ ' ' ~ store.name,
												})
											}}
											<div class="placeholder placeholder-fade"></div>
										</div>
										<div>
											<div class="js-testimonial-name js-testimonial-name-{{ loop.index }}" {% if not testimonial_name %}style="display: none"{% endif %}>{{ testimonial_name }}</div>
											<div class="js-testimonial-stars js-testimonial-stars-{{ loop.index }} testimonial-stars-{{ testimonial_stars }}" {% if testimonial_stars == 'none' %}style="display: none"{% endif %} data-stars="{{ testimonial_stars }}">
												<svg class="icon-inline icon-xs svg-icon-text"><use xlink:href="#star"/></svg>
												<svg class="icon-inline icon-xs svg-icon-text"><use xlink:href="#star"/></svg>
												<svg class="icon-inline icon-xs svg-icon-text"><use xlink:href="#star"/></svg>
												<svg class="icon-inline icon-xs svg-icon-text"><use xlink:href="#star"/></svg>
												<svg class="icon-inline icon-xs svg-icon-text"><use xlink:href="#star"/></svg>
											</div>
										</div>
									</div>
								</div>
								<h3 class="js-testimonial-title js-testimonial-title-{{ loop.index }} h6 mb-2" {% if not testimonial_title %}style="display: none"{% endif %}>{{ testimonial_title }}</h3>
								<p class="js-testimonial-description js-testimonial-description-{{ loop.index }} font-small mb-2" {% if not testimonial_description %}style="display: none"{% endif %}>{{ testimonial_description }}</p>
							</div>
						{% endfor %}
					</div>
				</div>
				<div class="js-swiper-testimonials-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100"{% if num_testimonials < 4 %} style="display: none;"{% endif %}></div>
				<div class="js-swiper-testimonials-prev swiper-button-prev svg-icon-text swiper-button-outside d-none d-md-block">
					<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
				</div>
				<div class="js-swiper-testimonials-next swiper-button-next svg-icon-text swiper-button-outside d-none d-md-block">
					<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
				</div>
			</div>
		</div>
	</div>
{% endif %}