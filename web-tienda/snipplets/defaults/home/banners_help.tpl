{# Categories banners that work as examples #}

{% set slide_view_box = '0 0 1440 770' %}

<div class="js-{{ banner_name }}-banner-placeholder container">
	<div class="grid grid-md-3">
		<div class="textbanner">
			<div class="textbanner-image overlay textbanner-image-empty">
				<svg class="textbanner-image-empty-svg" viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
			</div>
			<div class="textbanner-text textbanner-text-above">
				<div class="h3 mb-1">{{ banner_title }}</div>
			</div>
			<div class="placeholder-overlay transition-soft">
				<div class="placeholder-info">
					<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
					<div class="placeholder-description font-small-xs">
						{{ help_text }} <strong>"{{ section_name }}"</strong>
					</div>
					{% if not params.preview %}
						<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
					{% endif %}
				</div>
			</div>
		</div>
		<div class="textbanner">
			<div class="textbanner-image overlay textbanner-image-empty">
				<svg class="textbanner-image-empty-svg" viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
			</div>
			<div class="textbanner-text textbanner-text-above">
				<div class="h3 mb-1">{{ banner_title }}</div>
			</div>
			<div class="placeholder-overlay transition-soft">
				<div class="placeholder-info">
					<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
					<div class="placeholder-description font-small-xs">
						{{ help_text }} <strong>"{{ section_name }}"</strong>
					</div>
					{% if not params.preview %}
						<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
					{% endif %}
				</div>
			</div>
		</div>
		<div class="textbanner">
			<div class="textbanner-image overlay textbanner-image-empty">
				<svg class="textbanner-image-empty-svg" viewBox='{{ slide_view_box }}'><use xlink:href="#slider-slide-placeholder"/></svg>
			</div>
			<div class="textbanner-text textbanner-text-above">
				<div class="h3 mb-1">{{ banner_title }}</div>
			</div>
			<div class="placeholder-overlay transition-soft">
				<div class="placeholder-info">
					<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
					<div class="placeholder-description font-small-xs">
						{{ help_text }} <strong>"{{ section_name }}"</strong>
					</div>
					{% if not params.preview %}
						<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-primary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
					{% endif %}
				</div>
			</div>
		</div>
	</div>
</div>

{# Skeleton of "true" section accessed from instatheme.js #}
<div class="js-{{ banner_name }}-banner-top" style="display:none">
	{% if banner_name == 'category' %}
		{% include 'snipplets/home/home-banners.tpl' with {'has_banner': true} %}
	{% endif %}
	{% if banner_name == 'promotional' %}
		{% include 'snipplets/home/home-banners.tpl' with {'has_banner_promotional': true} %}
	{% endif %}
	{% if banner_name == 'news' %}
		{% include 'snipplets/home/home-banners.tpl' with {'has_banner_news': true} %}
	{% endif %}
</div>
