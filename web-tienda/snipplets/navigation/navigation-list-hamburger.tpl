{% set subitem = subitem | default(false) %}

{% for item in navigation %}
	
	{% set nav_panel_id = 'nav-panel-id-' ~ random() %}

	{% if item.subitems %}
		<div class="nav-item item-with-subitems" data-component="menu.item">
			<button class="js-modal-open-private nav-list-link {{ item.current ? 'selected' : '' }}" data-target="#{{ nav_panel_id }}" data-modal-url="#{{ nav_panel_id }}">
				{{ item.name }}
				<span class="nav-list-arrow">
					<svg class="icon-inline icon-lg"><use xlink:href="#chevron"/></svg>
				</span>
			</button>

			{% set navigation_panel %}
				{% if item.isCategory %}
					<div class="nav-item">
						<a class="nav-list-link {{ item.current ? 'selected' : '' }}" href="{{ item.url }}">
							{% if item.isRootCategory %}
								{{ 'Ver todos los productos' | translate }}
							{% else %}
								{{ 'Ver todo en' | translate }} {{ item.name }}
							{% endif %}
						</a>
					</div>
				{% endif %}
				{% include 'snipplets/navigation/navigation-list-hamburger.tpl' with { 'navigation' : item.subitems, 'subitem' : true } %}
			{% endset %}

			{{ component(
				'modal',{
					modal_id: nav_panel_id,
					data_component: 'nav-hamburger',
					dismiss_all_modals_on_close: 'true',
					position: {
						appear_from: 'right',
					},
					layout: {
						overlay: false,
					},
					content: {
						back_button: true,
						title: item.name,
						body: navigation_panel,
					},
					icons: {
						back_icon_id: 'chevron',
						close_icon_id: 'times',
					},
					modal_classes: {
						modal: 'modal-nav-hamburger',
						body: 'p-0',
						close_button: 'js-close-all-nav-modals',
						close_icon: 'icon-inline',
						back_icon: 'icon-flip-horizontal',
					}
				}) 
			}}							

						
		</div>
	{% else %}
		<div class="nav-item" data-component="menu.item">
			<a class="nav-list-link {{ item.current ? 'selected' : '' }}" href="{% if item.url %}{{ item.url | setting_url }}{% else %}#{% endif %}">{{ item.name }}</a>
		</div>
	{% endif %}
{% endfor %}