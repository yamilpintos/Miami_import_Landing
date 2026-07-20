<a href="#" {% if media.isVideo %}data-video_id="{{ media.id }}"{% endif %} class="js-product-thumb {% if loop.last and last_open_modal %}js-product-thumb-modal{% endif %} product-thumb d-block position-relative {% if loop.first %}selected{% endif %}" style="padding-bottom: {{ media.dimensions['height'] / media.dimensions['width'] * 100}}%;" data-thumb-loop="{{loop.index0}}">
	{% if media.isImage %}
		{{ component(
			'image', {
				image_name: media,
				image_width: media.dimensions.width,
				image_height: media.dimensions.height,
				image_classes: 'img-absolute img-absolute-centered',
				image_alt: media.alt,
				product_image: true,
				image_thumbs: ['thumb', 'small']
			})
		}}
	{% else %}
		<div class="video-player-icon video-player-icon-small">
			<svg class="icon-inline icon-xs svg-icon-text"><use xlink:href="#play"/></svg>
		</div>
		<img alt="{{ 'Video de' | translate }} {{ product.name }}" data-sizes="auto" src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ media.thumbnail }}" class="img-absolute img-absolute-centered lazyautosizes lazyload"/>
	{% endif %}
</a>
