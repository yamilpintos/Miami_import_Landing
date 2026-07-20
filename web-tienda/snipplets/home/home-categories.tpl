{% if settings.slider_categories and settings.slider_categories is not empty %}
	<div class="section-home section-categories-home overflow-none py-4">
		<div class="container position-relative text-center pr-0 px-md-3">
			<div class="js-swiper-categories swiper-container w-auto">
				<div class="swiper-wrapper">
					{% for slide in settings.slider_categories %}
						<div class="swiper-slide w-auto mr-4">
							{% if slide.link %}
								<a href="{{ slide.link | setting_url }}" class="js-home-category" aria-label="{{ 'Categoría' | translate }} {{ loop.index }}" data-url="{{ slide.link | setting_url }}">
							{% endif %}
								<div class="home-category">
									<div class="js-home-category-image home-category-image{% if settings.main_categories_border %} home-category-image-border{% endif %}">
										{{ component(
											'image',{
												image_name: slide.image,
												image_classes: 'd-block img-fluid fade-in',
												image_width: slide.width,
												image_height: slide.height,
												image_lazy: true,
												image_lazy_js: true,
												custom_content: '<div class="placeholder placeholder-fade"></div>',
												image_alt: 'Categoría' | translate ~ ' ' ~ loop.index,
											})
										}}
										<div class="placeholder placeholder-fade"></div>
									</div>
							{% if slide.link %}
										{% set category_handle = slide.link | trim('/') | split('/') | last %}
										{% include 'snipplets/home/home-categories-name.tpl' %}
									</div>
								</a>
							{% else %}
								</div>
							{% endif %}
						</div>
					{% endfor %}
				</div>
			</div>
			<div class="js-swiper-categories-prev swiper-button-prev swiper-button-outside svg-icon-text d-none d-md-block">
				<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
			</div>
			<div class="js-swiper-categories-next swiper-button-next swiper-button-outside svg-icon-text d-none d-md-block">
				<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
			</div>
		</div>
	</div>
{% endif %}
