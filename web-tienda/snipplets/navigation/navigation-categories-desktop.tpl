<div class="js-desktop-nav-item js-nav-main-item js-item-subitems-desktop nav-dropdown nav-main-item nav-item item-with-subitems pl-0">
	<div class="nav-item-container mr-2"> 
		<a href="{{ store.products_url }}" class="nav-list-link text-underline d-flex align-items-center">    		
			{{ 'Categorías' | translate }}
			<svg class="icon-inline icon-lg icon-rotate-90 ml-1"><use xlink:href="#chevron"/></svg>
		</a>
	</div>
	<div class="js-desktop-dropdown nav-dropdown-content desktop-dropdown">
		<div class="container desktop-dropdown-container">
			<ul class="desktop-list-subitems list-subitems">
				{% snipplet "navigation/navigation-categories-list-desktop.tpl" %}
			</ul>
			{% include 'snipplets/navigation/navigation-banners.tpl' with { 'desktop' : true } %}
		</div>
	</div>
</div>