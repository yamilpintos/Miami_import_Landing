{# Testimonials that work as examples #}

{% set slide_view_box = '0 0 1440 770' %}
<div class="js-testimonials-placeholder section-testimonials-home overflow-none py-4">
	<div class="container position-relative text-md-center pr-0 px-md-3">

		<h2 class="h4 mb-4">{{ 'Testimonios' | translate }}</h2>
		<div class="py-3">
			<div class="js-swiper-empty-testimonials swiper-testimonials swiper-container mb-3">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<div class="d-inline-block mb-3">
							<div class="testimonial-user text-left">
								<div class="testimonial-image position-relative overflow-none">
									<div class="textbanner-image-empty">
										<svg class="textbanner-image-empty-svg" viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
									</div>
								</div>
								<div>
									<div>{{ 'Nombre' | translate }}</div>
									<div class="testimonial-stars-5">
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
									</div>
								</div>
							</div>
						</div>
						<h3 class="h6 mb-2">{{ 'Testimonio' | translate }}</h3>
						<p class="font-small mb-2">{{ 'Descripción del testimonio' | translate }}</p>
					</div>
					<div class="swiper-slide">
						<div class="d-inline-block mb-3">
							<div class="testimonial-user text-left">
								<div class="testimonial-image position-relative overflow-none">
									<div class="textbanner-image-empty">
										<svg class="textbanner-image-empty-svg" viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
									</div>
								</div>
								<div>
									<div>{{ 'Nombre' | translate }}</div>
									<div class="testimonial-stars-5">
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
									</div>
								</div>
							</div>
						</div>
						<h3 class="h6 mb-2">{{ 'Testimonio' | translate }}</h3>
						<p class="font-small mb-2">{{ 'Descripción del testimonio' | translate }}</p>
					</div>
					<div class="swiper-slide">
						<div class="d-inline-block mb-3">
							<div class="testimonial-user text-left">
								<div class="testimonial-image position-relative overflow-none">
									<div class="textbanner-image-empty">
										<svg class="textbanner-image-empty-svg" viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
									</div>
								</div>
								<div>
									<div>{{ 'Nombre' | translate }}</div>
									<div class="testimonial-stars-5">
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
									</div>
								</div>
							</div>
						</div>
						<h3 class="h6 mb-2">{{ 'Testimonio' | translate }}</h3>
						<p class="font-small mb-2">{{ 'Descripción del testimonio' | translate }}</p>
					</div>
					<div class="swiper-slide">
						<div class="d-inline-block mb-3">
							<div class="testimonial-user text-left">
								<div class="testimonial-image position-relative overflow-none">
									<div class="textbanner-image-empty">
										<svg class="textbanner-image-empty-svg" viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
									</div>
								</div>
								<div>
									<div>{{ 'Nombre' | translate }}</div>
									<div class="testimonial-stars-5">
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
										<svg class="icon-inline icon-xs"><use xlink:href="#star"/></svg>
									</div>
								</div>
							</div>
						</div>
						<h3 class="h6 mb-2">{{ 'Testimonio' | translate }}</h3>
						<p class="font-small mb-2">{{ 'Descripción del testimonio' | translate }}</p>
					</div>
				</div>
			</div>
		</div>
		<div class="js-swiper-empty-testimonials-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100"></div>
		<div class="js-swiper-empty-testimonials-prev swiper-button-prev svg-icon-text swiper-button-outside d-none d-md-block">
			<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
		</div>
		<div class="js-swiper-empty-testimonials-next swiper-button-next svg-icon-text swiper-button-outside d-none d-md-block">
			<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
		</div>
	</div>
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-testimonials-top" style="display:none">    
    {% include 'snipplets/home/home-testimonials.tpl' %}
</div>