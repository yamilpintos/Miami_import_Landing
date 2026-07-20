{# deprecated file. Not in use #}
<a href="#" class="js-product-thumb {% if loop.last and last_open_modal %}js-product-thumb-modal{% endif %} product-thumb d-block position-relative {% if loop.first %}selected{% endif %}" style="padding-bottom: {{ image.dimensions['height'] / image.dimensions['width'] * 100}}%;" data-thumb-loop="{{loop.index0}}">
	{{ component(
		'image', {
			image_name: image,
			image_width: image.dimensions.width,
			image_height: image.dimensions.height,
			image_classes: 'img-absolute img-absolute-centered',
			image_alt: image.alt,
			product_image: true,
			image_thumbs: ['thumb', 'small']
		})
	}}
</a>
