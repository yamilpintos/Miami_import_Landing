{# /* Style tokens */ #}

:root {
  
  {#/*============================================================================
    #Colors
  ==============================================================================*/#}

  {#### Colors settings #}

  {# Main colors #}

  {% set main_background = settings.background_color %}
  {% set main_foreground = settings.text_color %}

  {% set accent_color = settings.accent_color %}

  {% set button_background = settings.button_background_color %}
  {% set button_foreground = settings.button_foreground_color %}

  {% set label_background = settings.label_background_color %}
  {% set label_foreground = settings.label_foreground_color %}

  {% set label_shipping_background = settings.label_shipping_background_color %}
  {% set label_shipping_foreground = settings.label_shipping_foreground_color %}

  {% set banner_services_background = settings.banner_services_background_color %}
  {% set banner_services_foreground = settings.banner_services_foreground_color %}

  {% set stock_color = settings.stock_foreground_color %}

  --main-background: {{ main_background }};
  --main-foreground: {{ main_foreground }};

  --accent-color: {{ accent_color }};

  --button-background: {{ button_background }};
  --button-foreground: {{ button_foreground }};

  --label-background: {{ label_background }};
  --label-foreground: {{ label_foreground }};

  --label-shipping-background: {{ label_shipping_background }};
  --label-shipping-foreground: {{ label_shipping_foreground }};

  --stock-color: {{ stock_color }};

  {# Optional colors #}

  {% set header_background = settings.header_background_color  %}
  {% set header_foreground = settings.header_foreground_color %}

  {% set header_badge_background = settings.header_badge_background_color %}
  {% set header_badge_foreground = settings.header_badge_foreground_color %}

  {% set header_search_button_background = settings.search_button_background_color %}
  {% set header_search_button_foreground = settings.search_button_foreground_color %}

  {% set header_desktop_utilities_background = settings.header_desktop_utility_background_color %}
  {% set header_desktop_utilities_foreground = settings.header_desktop_utility_foreground_color %}

  {% set nav_desktop_background = settings.desktop_nav_background_color %}
  {% set nav_desktop_foreground = settings.desktop_nav_foreground_color %}

  {% set nav_desktop_featured_link_foreground = settings.featured_link_foreground_color %}

  {% set primary_adbar_background = settings.adbar_primary_background_color %}
  {% set primary_adbar_foreground = settings.adbar_primary_foreground_color %}
  {% set secondary_adbar_background = settings.adbar_secondary_background_color %}
  {% set secondary_adbar_foreground = settings.adbar_secondary_foreground_color %}

  {% set institutional_background = settings.home_institutional_colors ? settings.home_institutional_background_color %}
  {% set institutional_foreground = settings.home_institutional_colors ? settings.home_institutional_foreground_color %}

  {% set video_background = settings.home_video_colors ? settings.home_video_background_color %}
  {% set video_foreground = settings.home_video_colors ? settings.home_video_foreground_color %}

  {% set timer_offers_background = settings.timer_offers_colors ? settings.timer_offers_background_color %}
  {% set timer_offers_foreground = settings.timer_offers_colors ? settings.timer_offers_foreground_color %}
  {% set timer_offers_module_background = settings.timer_offers_colors ? settings.timer_offers_module_background_color %}
  {% set timer_offers_module_foreground = settings.timer_offers_colors ? settings.timer_offers_module_foreground_color %}
  
  {% set newsletter_background = settings.home_news_colors ? settings.home_news_background_color %}
  {% set newsletter_foreground = settings.home_news_colors ? settings.home_news_foreground_color %}

  {% set footer_background = settings.footer_background_color %}
  {% set footer_foreground = settings.footer_foreground_color %}
  
  --header-background: {{ header_background }};
  --header-foreground: {{ header_foreground }};

  --header-badge-background: {{ header_badge_background }};
  --header-badge-foreground: {{ header_badge_foreground }};

  --header-search-btn-background: {{ header_search_button_background }};
  --header-search-btn-foreground: {{ header_search_button_foreground }};

  --header-desktop-utilities-background: {{ header_desktop_utilities_background }};
  --header-desktop-utilities-foreground: {{ header_desktop_utilities_foreground }};

  --header-desktop-nav-background: {{ nav_desktop_background }};
  --header-desktop-nav-foreground: {{ nav_desktop_foreground }};
  
  --header-featured-link-foreground: {{ nav_desktop_featured_link_foreground }};

  --primary-adbar-background: {{ primary_adbar_background }};
  --primary-adbar-foreground: {{ primary_adbar_foreground }};
  --secondary-adbar-background: {{ secondary_adbar_background }};
  --secondary-adbar-foreground: {{ secondary_adbar_foreground }};

  --footer-background: {{ footer_background }};
  --footer-foreground: {{ footer_foreground }};
  
  --banner-services-background: {{ banner_services_background }};
  --banner-services-foreground: {{ banner_services_foreground }};

  --institutional-background: {{ institutional_background }};
  --institutional-foreground: {{ institutional_foreground }};

  --video-background: {{ video_background }};
  --video-foreground: {{ video_foreground }};

  --timer-offers-background: {{ timer_offers_background }};
  --timer-offers-foreground: {{ timer_offers_foreground }};
  --timer-offers-module-background: {{ timer_offers_module_background }};
  --timer-offers-module-foreground: {{ timer_offers_module_foreground }};

  --newsletter-background: {{ newsletter_background }};
  --newsletter-foreground: {{ newsletter_foreground }};

  {# Color shades #}

  {# Opacity hex levels #}

  {% set opacity_03 = '08' %}
  {% set opacity_05 = '0D' %}
  {% set opacity_08 = '14' %}
  {% set opacity_10 = '1A' %}
  {% set opacity_20 = '33' %}
  {% set opacity_30 = '4D' %}
  {% set opacity_40 = '66' %}
  {% set opacity_50 = '80' %}
  {% set opacity_60 = '99' %}
  {% set opacity_70 = 'B3' %}
  {% set opacity_80 = 'CC' %}
  {% set opacity_90 = 'E6' %}
  {% set opacity_95 = 'F2' %}

  --header-foreground-opacity-10: {{ header_foreground }}{{ opacity_10 }};
  --header-foreground-opacity-20: {{ header_foreground }}{{ opacity_20 }};
  --header-foreground-opacity-30: {{ header_foreground }}{{ opacity_30 }};
  --header-foreground-opacity-50: {{ header_foreground }}{{ opacity_50 }};

  --main-foreground-opacity-03: {{ main_foreground }}{{ opacity_03 }};
  --main-foreground-opacity-05: {{ main_foreground }}{{ opacity_05 }};
  --main-foreground-opacity-10: {{ main_foreground }}{{ opacity_10 }};
  --main-foreground-opacity-20: {{ main_foreground }}{{ opacity_20 }};
  --main-foreground-opacity-30: {{ main_foreground }}{{ opacity_30 }};
  --main-foreground-opacity-40: {{ main_foreground }}{{ opacity_40 }};
  --main-foreground-opacity-50: {{ main_foreground }}{{ opacity_50 }};
  --main-foreground-opacity-60: {{ main_foreground }}{{ opacity_60 }};

  --main-background-opacity-30: {{ main_background }}{{ opacity_30 }};
  --main-background-opacity-50: {{ main_background }}{{ opacity_50 }};
  --main-background-opacity-80: {{ main_background }}{{ opacity_80 }};

  --label-shipping-background-80: {{ label_shipping_background }}{{ opacity_80 }};

  --newsletter-foreground-opacity-50: {{ newsletter_foreground }}{{ opacity_50 }};

  --footer-foreground-opacity-40: {{ footer_foreground }}{{ opacity_40 }};
  --footer-foreground-opacity-60: {{ footer_foreground }}{{ opacity_60 }};

  {# Alert colors CSS #}

  --success: #4bb98c;
  --danger: #dd7774;
  --warning: #dc8f38;

  {#/*============================================================================
    #Fonts
  ==============================================================================*/#}

  {# Font families #}

  --heading-font: {{ settings.font_headings | raw }};
  --body-font: {{ settings.font_rest | raw }};

  {# Font sizes #}

  {% set font_base_size = settings.font_base_size %}

  --font-base: {{ font_base_size }}px;
  --font-base-default: 16px;

  {% set font_rest_size = settings.font_rest_size %}

  --font-huge: {{ font_rest_size + 5 }}px;
  --font-big: {{ font_rest_size + 4 }}px;
  --font-medium: {{ font_rest_size + 2 }}px;
  --font-small: {{ font_rest_size }}px;
  --font-smallest: {{ font_rest_size - 2 }}px;
  --font-extra-smallest: {{ font_rest_size - 3 }}px;

  {# Scales using 1.2 minor third scale #}

  {% set heading_size = settings.headings_size %}

  --h1: {{ heading_size }}px;
  --h2: {{ (heading_size * 0.833) | round }}px;
  --h3: {{ (heading_size * 0.6875) | round }}px;
  --h4: {{ (heading_size * 0.583) | round }}px;
  --h5: {{ (heading_size * 0.479) | round }}px;
  --h6: {{ (heading_size * 0.396) | round }}px;
  --h6-small: {{ (heading_size * 0.3333) | round }}px;

  {# Titles weight #}

  {% set title_weight = settings.headings_bold ? '700' : '400' %}

  --title-font-weight: {{ title_weight }};

  {#/*============================================================================
    #Layout
  ==============================================================================*/#}

  {# Spacing #}

  --spacing-base: 16px;
  --spacing-half: calc(var(--spacing-base) / 2);
  --spacing-quarter: calc(var(--spacing-base) / 4);

  --spacing-1: calc(var(--spacing-base) * 0.25);
  --spacing-2: calc(var(--spacing-base) * 0.5);
  --spacing-3: var(--spacing-base);
  --spacing-4: calc(var(--spacing-base) * 1.5);
  --spacing-5: calc(var(--spacing-base) * 3);

  {# Gutters #}

  --gutter: var(--spacing-base);
  --gutter-container: var(--gutter);
  --gutter-container-md: calc(var(--gutter) * 2);
  --gutter-negative: calc(var(--gutter) * -1);
  --gutter-half: calc(var(--gutter) / 2);
  --gutter-half-negative: calc(var(--gutter) * -1 / 2);
  --gutter-double: calc(var(--gutter) * 2);

  {#/*============================================================================
    #Misc
  ==============================================================================*/#}

  {# Transitions #}

  --transition-fast: all 0.05s ease;
  --transition-normal: all 0.3s ease;
  --transition-slow: all 1s ease;

  {# Shadows #}

  --drop-shadow: 0 0 8px 4px var(--main-foreground-opacity-05);

  {# Border radius #}

  --border-radius: 8px;
  --border-radius-medium: calc(var(--border-radius) / 1.3333);
  --border-radius-small: calc(var(--border-radius) / 2);
  --border-radius-smallest: calc(var(--border-radius) / 4);
  --border-radius-full: 100%;

  {# Border stroke #}

  --border-solid: 1px solid;

}