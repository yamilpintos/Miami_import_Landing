{# /*============================================================================
  #Page header
==============================================================================*/

#Properties

#Title

#Breadcrumbs

#}

<section class="page-header my-4 {{ page_header_class }}" data-store="page-title">
	{% include 'snipplets/breadcrumbs.tpl' %}
	<h1 class="h4 h2-md {{ page_header_title_class }}">
		{% block page_header_text %}{% endblock %}
	</h1>
</section>

