{# Instagram feed that work as examples #}

<section class="section-instafeed-home" data-store="home-instagram-feed">
	<div class="container text-center">
		<div class="position-relative py-4">
			<div class="instafeed-title mb-3">
				<svg class="icon-inline icon-2x svg-icon-text mr-3"><use xlink:href="#instagram"/></svg>
				<h2 class="h4 instafeed-user mb-0">{{ 'Instagram' | translate }}</h2>
			</div>
			<div class="instafeed-grid">
				{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true} %}
				{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true, 'help_item_class': 'd-none d-md-block'} %}
				{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_1': true, 'help_item_class': 'd-none d-md-block'} %}
				{% include 'snipplets/defaults/help_instagram.tpl' with {'help_item_2': true, 'help_item_class': 'd-none d-md-block'} %}
			</div>
			<div class="placeholder-overlay transition-soft">
				<div class="placeholder-info">
					<svg class="icon-inline icon-3x"><use xlink:href="#edit"/></svg>
					<div class="placeholder-description font-small-xs">
						{{ "Podés mostrar tus últimas novedades desde" | translate }} <strong>"{{ "Publicaciones de Instagram" | translate }}"</strong>
					</div>
					{% if not params.preview %}
						<a href="{{ admin_link }}#instatheme=pagina-de-inicio" class="btn-secondary btn btn-small placeholder-button">{{ "Editar" | translate }}</a>
					{% endif %}
				</div>
			</div>
		</div>
	</div>
</section>
