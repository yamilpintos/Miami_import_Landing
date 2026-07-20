{% if params.preview %}

	{# If page is loaded from customization page on the admin, load all fonts #}

	{% set font_css_url = 'https://fonts.googleapis.com/css?family=Montserrat:400,700%7CMuli:400,700%7CLato:400,700%7CNunito:400,700%7CPlus+Jakarta+Sans:400,700%7COutfit:400,700%7CSora:400,700%7CLexend:400,700%7CRed+Hat+Display:400,700%7CManrope:400,700%7CWork+Sans:400,700%7CInter:400,700%7CPublic+Sans:400,700%7CKanit:400,700%7CBraah+One:400,700%7CKarla:400,700%7CRoboto+Mono:400,700%7CPlayfair+Display:400,700%7CUltra%7CMarcellus%7CFraunces:400,700%7CLiterata:400,700%7CZilla+Slab:400,700%7COooh+Baby%7CHandlee%7CDomine:400,700%7CCorben:400,700%7CTenor+Sans%7CPoppins:400,700%7CChivo:400,700%7CArchivo+Black:400,700%7CSpace+Grotesk:400,700%7CInstrument+Sans:400,700%7CRubik:400,700%7COnest:400,700%7CChakra+Petch:400,700%7CGabarito:400,700%7CAlmarai:400,700%7CPrata:400,700%7CNeuton:400,700' %}
{% else %}

	{# If page is NOT loaded from customization only load saved fonts #}

	{# Get only the saved fonts on settings #}

	{% set font_css_url = [settings.font_headings, settings.font_rest] | google_fonts_url('400, 700') | raw %}

{% endif %}

<link rel="stylesheet" href="{{ font_css_url }}" media="print" onload="this.media='all'">