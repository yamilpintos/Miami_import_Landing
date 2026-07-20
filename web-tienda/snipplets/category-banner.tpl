{% set has_category_images = category.images is not empty %}
{% set category_image = has_category_images ? true : false %}
{% set category_image_name = has_category_images ? category.images | first : 'banner-products.jpg' %}

<div class="category-banner" data-store="category-banner">
	{{ component(
		'image',{
			image_priority_high: true,
			image_name: category_image_name,
			image_classes: 'img-fluid w-100 mb-4',
			image_alt: 'Banner de la categoría' | t ~ ' ' ~ category.name,
			category_image: category_image,
		})
	}}
</div>