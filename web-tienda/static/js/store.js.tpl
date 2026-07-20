{#/*============================================================================
    #Specific store JS functions: product variants, cart, shipping, etc
==============================================================================*/#}

{#/*============================================================================

    Table of Contents
    
    #Transitions
    #Forms
    #Header and nav
        // Cart favicon
        // Inactive tab message
        // Adbars
        // Mobile main panel
        // Nav
        // Slim header on scroll
    #Home
        // Sliders
        // Home slider
        // Banners slider
        // Institutional slider
        // Main categories
        // Brands slider
        // Testimonials slider
        // Instafeed slider
        // Products slider
        // Banner services slider
        // Home popup and newsletter popup
        // Main product description toggle
        // Youtube video
    #Product grid
        // Button variations
        // Color and size variations
        // Fixed category controls
        // Product item slider
        // Infinite scroll
        // Quickshop
    #Product detail
        // Installments
        // Change variant
        // Trigger change variant
        // Submit to contact
        // Product slider
        // Product quantity
        // Add to cart
        // Add to cart notification
        // Product Related
    #Cart
        // Free shipping bar
        // Position of cart page summary
        // Cart quantitiy changes
        // Go to checkout
    #Shipping calculator
        // Select and save shipping function
        // Calculate shipping function
        // Calculate shipping by submit
        // Shipping and branch click
        // Select shipping first option on results
        // Toggle more shipping options
        // Calculate shipping on page load
        // Shipping provinces
        // Change store country
    #Empty screens
        // Home
        // 404 & Search without results

==============================================================================*/#}

// Move to our_content
window.urls = {
    "shippingUrl": "{{ store.shipping_calculator_url | escape('js') }}"
}

{#/*============================================================================
  #Lazy load
==============================================================================*/ #}

document.addEventListener('lazybeforeunveil', function(e){
    if ((e.target.parentElement) && (e.target.nextElementSibling)) {
        var parent = e.target.parentElement;
        var sibling = e.target.nextElementSibling;
        if (sibling.classList.contains('js-lazy-loading-preloader')) {
            sibling.style.display = 'none';
            parent.style.display = 'block';
        }
    }
});


window.lazySizesConfig = window.lazySizesConfig || {};
lazySizesConfig.hFac = 0.4;

DOMContentLoaded.addEventOrExecute(() => {

    {#/*============================================================================
      #Transitions
    ==============================================================================*/ #}

    applyMarqueeAnimation = function(marqueeSelector, textSelector){

        {# Reference speed values #}

        const defaultDelay = 5;
        const defaultWidth = 300;

        {# New speed values based on dynamic content #}
        const animatedWidth = jQueryNuvem(textSelector).first(el => el.offsetWidth);
        let newDelay;
        newDelay = defaultDelay*(animatedWidth/defaultWidth)*1.5;

        if((window.innerWidth > 768) && (newDelay < 50)){

            {# If content is too short, set a minimum speed #}
            newDelay = newDelay + 20;
        }

        jQueryNuvem(marqueeSelector).css("animation", "marquee " + newDelay + "s linear infinite");
    };

    {# /* Enable modal handler to open modals without clicking a trigger */ #}

    const modalHandler = new ModalHandler();

    {#/*============================================================================
      #Forms
    ==============================================================================*/ #}

    {# IOS form CSS to avoid autozoom on focus #}

    var isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream;
    if (isIOS) {
        var ios_input_fields = jQueryNuvem("input[type='text'], input[type='number'], input[type='password'], input[type='tel'], textarea, input[type='search'], input[type='hidden'], input[type='email']");
        ios_input_fields.addClass("form-control-ios");
        // jQueryNuvem(".js-quantity").addClass("form-group-quantity-ios");
        // jQueryNuvem(".js-cart-quantity-container").addClass("cart-quantity-container-ios");
        jQueryNuvem(".js-search-form").toggleClass("search-form-ios");
        // jQueryNuvem(".js-price-filter-btn").addClass("price-btn-ios");
        // jQueryNuvem(".js-price-filter-empty").addClass("input-clear-content-ios");
    }
    
    {#/*============================================================================
        # Header and nav
    ==============================================================================*/ #}

    {# /* // Cart favicon */ #}

    {% if "cart-favicon.jpg" | has_custom_image %}
        
        {# Original favicon url #}
        const originalFavicon = jQueryNuvem(".js-favicon").attr("href");

        {# Updates favicon on initial load #}
        {% if cart.items_count > 0 %}
            jQueryNuvem(".js-favicon").attr("href", "{{ 'cart-favicon.jpg' | static_url }}");
        {% endif %}

        {# Updates favicon on cart changes #}
        document.addEventListener( 'cart.updated', () => {
            setTimeout(function(){
                if(jQueryNuvem(".js-cart-item").length){
                    jQueryNuvem(".js-favicon").attr("href", "{{ 'cart-favicon.jpg' | static_url }}");
                } else {
                    jQueryNuvem(".js-favicon").attr("href", originalFavicon);
                }
            },900);
        });

    {% endif %}

    {# /* // Inactive tab message */ #}

    {% if settings.inactive_tab_message and (settings.inactive_tab_message_01 or settings.inactive_tab_message_02) %}
        
        {# Identifies available messages and discards nulls from the array #}
        var messages = [
            {% if settings.inactive_tab_message_01 %}'{{ settings.inactive_tab_message_01 }}',{% endif %}
            {% if settings.inactive_tab_message_02 %}'{{ settings.inactive_tab_message_02 }}'{% endif %}
        ].filter(Boolean);

        {# Variable used for interval identifier in tab visibility #}
        var intervalID;

        function changeTitle() {
            if (messages.length > 0) {
                document.title = messages.shift();
                messages.push(document.title);
            }
        }

        document.addEventListener("visibilitychange", function() {
            if (document.hidden && messages.length > 0) {
                intervalID = setInterval(changeTitle, 1000);
            } else {
                clearInterval(intervalID);
                document.title = '{{ page_title }}';
            }
        });
    {% endif %}

    {# /* // Adbars */ #}

    {# Main #}

    {% set adbarMessage01 = settings.adbar_primary_01_text %}
    {% set adbarMessage02 = settings.adbar_primary_02_text %}
    {% set adbarMessage03 = settings.adbar_primary_03_text %}
    {% set adbarMultipleMessages = (adbarMessage01 and adbarMessage02) or (adbarMessage01 and adbarMessage03) or (adbarMessage02 and adbarMessage03) %}
    {% set adbarMessages = adbarMessage01 or adbarMessage02 or adbarMessage03 %}
    {% set hasAdbar = settings.adbar_primary and (adbarMessages or 'adbar_primary_img_mobile.jpg' | has_custom_image or 'adbar_primary_img_desktop.jpg' | has_custom_image) %}

    {% if settings.adbar_primary %}

        {% if settings.adbar_primary_animate %}

            {# /* // Animated adbar */ #}

            applyMarqueeAnimation(".js-adbar-primary .js-adbar-content" , ".js-adbar-primary .js-adbar-messages-container");

        {% elseif adbarMultipleMessages %}

            createSwiper('.js-swiper-adbar-primary', {
                loop: true,
                slidesPerView: 1,
                watchOverflow: true,
                navigation: {
                    nextEl: '.js-swiper-adbar-primary-next',
                    prevEl: '.js-swiper-adbar-primary-prev',
                },
            },
            function(swiperInstance) {
                window.adbarPrimarySwiper = swiperInstance;
            });

        {% endif %}

    {% endif %}

    {# Secondary #}
    
    {% set adbarMessage01 = settings.adbar_secondary_01_text %}
    {% set adbarMessage02 = settings.adbar_secondary_02_text %}
    {% set adbarMessage03 = settings.adbar_secondary_03_text %}
    {% set adbarMultipleMessages = (adbarMessage01 and adbarMessage02) or (adbarMessage01 and adbarMessage03) or (adbarMessage02 and adbarMessage03) %}
    {% set adbarMessages = adbarMessage01 or adbarMessage02 or adbarMessage03 %}
    {% set hasAdbar = settings.adbar_secondary and (adbarMessages or 'adbar_secondary_img_mobile.jpg' | has_custom_image or 'adbar_secondary_img_desktop.jpg' | has_custom_image) %}

    {% if settings.adbar_secondary %}

        {% if settings.adbar_secondary_animate %}

            {# /* // Animated adbar */ #}

            applyMarqueeAnimation(".js-adbar-secondary .js-adbar-content" , ".js-adbar-secondary .js-adbar-messages-container");

        {% elseif adbarMultipleMessages %}

            createSwiper('.js-swiper-adbar-secondary', {
                loop: true,
                slidesPerView: 1,
                watchOverflow: true,
                navigation: {
                    nextEl: '.js-swiper-adbar-secondary-next',
                    prevEl: '.js-swiper-adbar-secondary-prev',
                },
            },
            function(swiperInstance) {
                window.adbarSecondarySwiper = swiperInstance;
            });

        {% endif %}

    {% endif %}

    {# /* // Mobile main panel */ #}

    jQueryNuvem(".js-close-all-nav-modals").click(function () {
        jQueryNuvem("#nav-hamburger").addClass("modal-transition-fast");        
         setTimeout(function(){
            jQueryNuvem("#nav-hamburger").removeClass("modal-transition-fast");
        },1000);
    });

    {# /* // Nav */ #}

    {# Nav subitems desktop #}

    const win_height = window.innerHeight;
    const head_height = jQueryNuvem(".js-head-main").outerHeight();

    jQueryNuvem(".js-desktop-dropdown").css('maxHeight', (win_height - head_height - 50).toString() + 'px');

    jQueryNuvem(".js-item-subitems-desktop").on("mouseenter", function (e) {
        jQueryNuvem(e.currentTarget).addClass("active");
    }).on("mouseleave", function(e) {
        jQueryNuvem(e.currentTarget).removeClass("active");
    });

    jQueryNuvem(".js-nav-main-item").on("mouseenter", function (e) {
        jQueryNuvem('.js-nav-desktop-list').children(".selected").removeClass("selected");
        jQueryNuvem(e.currentTarget).addClass("selected");
    }).on("mouseleave", function(e) {
        const self = jQueryNuvem(this);
        setTimeout(function(){
            self.removeClass("selected");
        },500);
    });

    jQueryNuvem(".js-nav-desktop-list-arrow").on("mouseenter", function (e) {
        jQueryNuvem('.js-desktop-nav-item').removeClass("selected");
    });

    {# Load desktop nav banner when header is hovered #}
     
    {% if 'menu_banner_desktop.jpg' %}
        jQueryNuvem(".js-head-main").on("mouseenter", function (e) {
            jQueryNuvem(e.currentTarget).addClass("hover");
        }).on("mouseleave", function(e) {
            const self = jQueryNuvem(this);
            setTimeout(function(){
                self.removeClass("hover");
            },500);
        });
    {% endif %}

    {# Nav desktop scroller #}

    {# Set widths of all nav components #}

    const mainNavContainerWidth = jQueryNuvem('.js-nav-desktop-container').first(el => el.offsetWidth);
    const menuNavListWidth = jQueryNuvem('.js-nav-desktop-list').first(el => el.offsetWidth);
    let mainCategoriesContainerWidth = 0;
    let secondaryNavContainerWidth = 0;

    {% set has_languages = languages | length > 1 %}
    {% set utilities_languages_secondary_nav = has_languages and settings.utilities_type_desktop == 'icons_text' %}
    {% set nav_secondary_col = settings.head_secondary_menu_show or utilities_languages_secondary_nav %}
    {% set navigation_has_siblings = settings.category_item or nav_secondary_col %}

    {% if settings.category_item %}
        mainCategoriesContainerWidth = jQueryNuvem('.js-desktop-main-categories-col').first(el => el.offsetWidth);
    {% endif %}
    {% if nav_secondary_col %}
        secondaryNavContainerWidth = jQueryNuvem('.js-desktop-secondary-nav-col').first(el => el.offsetWidth);
    {% endif %}

    const totalColsWidth = mainCategoriesContainerWidth + secondaryNavContainerWidth;

    {# Calculate width to substract to main horizontal scroller nav #}

    {% if navigation_has_siblings %}
        const menuColWidth = mainNavContainerWidth - totalColsWidth;
    {% endif %}

    let menuItemsWidth = 0;

    {# Calculate width of all main nav items #}

    jQueryNuvem('.js-nav-desktop-list > .js-desktop-nav-item').each(function(el) {
        menuItemsWidth +=  jQueryNuvem(el).first(el => el.offsetWidth);
    });

    {% if navigation_has_siblings %}

        {# Recalculate items width including first and last element different paddings #}

        menuItemsWidth = menuItemsWidth;
        
    {% endif %}

    {# If summatory of nav items is wider than  width of all main nav items #}

    if (menuNavListWidth < menuItemsWidth) {
        jQueryNuvem('.js-nav-desktop-list').addClass('nav-desktop-with-scroll');
        jQueryNuvem('.js-nav-desktop-list-arrow').css("display" , "flex");
        {% if navigation_has_siblings %}
            jQueryNuvem(".js-desktop-nav-col").css("width" , menuColWidth.toString() + 'px');
        {% endif %}
    }

    jQueryNuvem(".js-nav-desktop-list").css("whiteSpace" , "nowrap");

    {# Show nav row once columns layout are ready #}

    jQueryNuvem(".js-nav-desktop-container").css("visibility", "visible").css("height", "auto");

    {# Scroller controls #}

    jQueryNuvem(".js-nav-desktop-list").on("scroll", function() {
        var position = jQueryNuvem('.js-nav-desktop-list').prop("scrollLeft");
        if(position == 0) {
            jQueryNuvem(".js-nav-desktop-list-arrow-left").addClass('disable');
        } else {
            jQueryNuvem(".js-nav-desktop-list-arrow-left").removeClass('disable');
        }
        if(position == ( menuItemsWidth - menuNavListWidth )) {
            jQueryNuvem(".js-nav-desktop-list-arrow-right").addClass('disable');
        } else {
            jQueryNuvem(".js-nav-desktop-list-arrow-right").removeClass('disable');
        }
    });

    jQueryNuvem('.js-nav-desktop-list-arrow-right').on("click", function() {
        var posL = jQueryNuvem('.js-nav-desktop-list').prop("scrollLeft") + 400;
        jQueryNuvem('.js-nav-desktop-list').each((el) => el.scroll({ left: posL, behavior: 'smooth' }));
    });
    jQueryNuvem('.js-nav-desktop-list-arrow-left').on("click", function() {
        var posR = jQueryNuvem('.js-nav-desktop-list').prop("scrollLeft") - 400;
        jQueryNuvem('.js-nav-desktop-list').each((el) => el.scroll({ left: posR, behavior: 'smooth' }));
    });

    {# Avoid megamenu dropdown flickering when mouse leave #}

    jQueryNuvem(".js-desktop-dropdown").on("mouseleave", function (e) {
        const self = jQueryNuvem(this);
        self.css("pointer-events" , "none");
        setTimeout(function(){
            self.css("pointer-events" , "initial");
        },1000);
    });

    let adBarsHeight = 0;
    const mainAdBarHeight = jQueryNuvem(".js-adbar-primary").outerHeight();
    const secondaryAdBarHeight = jQueryNuvem(".js-adbar-secondary").outerHeight();
    adBarsHeight = mainAdBarHeight + secondaryAdBarHeight;

    {% set has_only_mobile_with_fixed_nav =  not settings.head_fix_desktop %}

    {% if has_only_mobile_with_fixed_nav %}
    if (window.innerWidth < 768) {
    {% endif %}

    {# /* // Slim header on scroll */ #}

    window.addEventListener("scroll", function() {

        const scrolledPosition = window.pageYOffset;
        const header = jQueryNuvem(".js-head-main");
        const navbarHeight = header.outerHeight();

        if (scrolledPosition > navbarHeight) {
            header.addClass('compress').css('top', -adBarsHeight + 'px' );
            {% if template == 'category' or template == 'search' %}
                if (window.innerWidth < 768) {
                    setTimeout(function(){
                        offsetCategories();
                    },300);
                }
            {% endif %}
        } else {
            header.removeClass('compress').css("top", "0px");
            {% if template == 'category' or template == 'search' %}
                if (window.innerWidth < 768) {
                    setTimeout(function(){
                        offsetCategories();
                    },300);
                }
            {% endif %}
        }
    });

    {% if has_only_mobile_with_fixed_nav %}
    }
    {% endif %}

    {# Set logo col fixed width to avoid searchbar changing position on slim header #}

    {% if settings.head_fix_desktop and settings.logo_position_desktop == 'left' and has_logo %}

        if (window.innerWidth > 768) {
            const logoColWidth = jQueryNuvem(".js-logo-container").first(el => el.offsetWidth);
            if(logoColWidth != 0){
                jQueryNuvem(".js-logo-container").css("width" , logoColWidth.toString() + 'px');;
            }
        }

    {% endif %}

    {#/*============================================================================
      #Home
    ==============================================================================*/ #}

    {# /* // Sliders */ #}

    var itemSwiperSpaceBetween = 16;

    {# Hide arrow controls when swiper is not swipable #}

    hideSwiperControls = function(elemPrev, elemNext) {
        if((jQueryNuvem(elemPrev).hasClass("swiper-button-disabled") && jQueryNuvem(elemNext).hasClass("swiper-button-disabled"))){
            jQueryNuvem(elemPrev).remove();
            jQueryNuvem(elemNext).remove();
        }
    };

    var preloadImagesValue = false;
    var lazyValue = true;
    var loopValue = true;
    var paginationClickableValue = true;
    var watchOverflowVal = true;
    var centerInsufficientSlidesVal = true;

    {% if template == 'home' %}

        {# /* // Home slider */ #}

        var width = window.innerWidth;
        if (width > 767) {
            var slider_autoplay = {delay: 6000,};
        } else {
            var slider_autoplay = false;
        }

        {% set has_slider_full_width = settings.slider_full %}

        {% if has_slider_full_width %}
            function arrowsColor() {
                if(jQueryNuvem(".js-home-main-slider").find('.swiper-slide-active').hasClass("swiper-light")){
                    jQueryNuvem(".js-home-main-slider-visibility").addClass("swiper-arrows-light");
                } else {
                    jQueryNuvem(".js-home-main-slider-visibility").removeClass("swiper-arrows-light");
                }
            }
        {% endif %}

        createSwiper(
            '.js-home-main-slider', {
                preloadImages: preloadImagesValue,
                lazy: lazyValue,
                {% if settings.slider | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                pagination: {
                    el: '.js-swiper-home-pagination',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-home-next',
                    prevEl: '.js-swiper-home-prev',
                },
                {% if has_slider_full_width %}
                    on: {
                      init: arrowsColor,
                      slideChangeTransitionEnd: arrowsColor,
                    },
                {% endif %}
            },
            function(swiperInstance) {
                window.homeSwiper = swiperInstance;
            }
        );

        createSwiper(
            '.js-home-mobile-slider', {
                preloadImages: preloadImagesValue,
                lazy: lazyValue,
                {% if settings.slider_mobile | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                pagination: {
                    el: '.js-swiper-home-pagination-mobile',
                    clickable: paginationClickableValue,
                },
            },
            function(swiperInstance) {
                window.homeMobileSwiper = swiperInstance;
            }
        );

        {# /* // Banners slider */ #}

        {% if settings.banner_format_mobile == 'slider' or settings.banner_format_desktop == 'slider' and (settings.banner and settings.banner is not empty) or theme_editor %}

            {% set banner_desktop_slider = settings.banner_format_desktop == 'slider' %}
            {% set banner_only_mobile_slider = settings.banner_format_mobile == 'slider' and settings.banner_format_desktop != 'slider' %}
            {% set banner_only_desktop_slider = settings.banner_format_desktop == 'slider' and settings.banner_format_mobile != 'slider' %}
            {% set banner_columns_desktop = settings.banner_columns_desktop %}

            var bannersPerViewDesktopVal = {% if banner_columns_desktop == 4 %}4{% elseif banner_columns_desktop == 3 %}3{% elseif banner_columns_desktop == 2 %}2{% else %}1{% endif %};
            var bannersPerViewMobileVal = 1.15;
            var bannersSpaceBetween = {% if settings.banner_without_margins %}0{% else %}itemSwiperSpaceBetween{% endif %};

            {% if banner_only_mobile_slider %}
                if (window.innerWidth < 768) {
            {% elseif banner_only_desktop_slider %}
                if (window.innerWidth > 768) {
            {% endif %}

                {# General banners #}

                {% if (settings.banner and settings.banner is not empty) or theme_editor %}
                    createSwiper('.js-swiper-banner', {
                        lazy: true,
                        watchOverflow: true,
                        threshold: 5,
                        watchSlideProgress: true,
                        watchSlidesVisibility: true,
                        slideVisibleClass: 'js-swiper-slide-visible',
                        spaceBetween: bannersSpaceBetween,
                        pagination: {
                            el: '.js-swiper-banner-pagination',
                            clickable: paginationClickableValue,
                        },
                        navigation: {
                            nextEl: '.js-swiper-banner-next',
                            prevEl: '.js-swiper-banner-prev',
                        },
                        slidesPerView: bannersPerViewMobileVal,
                        on: {
                            afterInit: function () {
                                hideSwiperControls(".js-swiper-banner-prev", ".js-swiper-banner-next");
                            },
                        },
                        breakpoints: {
                            768: {
                                slidesPerView: bannersPerViewDesktopVal,
                            }
                        }
                    },function(swiperInstance) {
                        window.homeBannerSwiper = swiperInstance;
                    });
                {% endif %}

                {# Mobile banners #}

                {% if (settings.toggle_banner_mobile and settings.banner_mobile and settings.banner_mobile is not empty) or theme_editor %}
                    createSwiper('.js-swiper-banner-mobile', {
                        lazy: true,
                        watchOverflow: true,
                        threshold: 5,
                        watchSlideProgress: true,
                        watchSlidesVisibility: true,
                        slideVisibleClass: 'js-swiper-slide-visible',
                        spaceBetween: bannersSpaceBetween,
                        pagination: {
                            el: '.js-swiper-banner-mobile-pagination',
                            clickable: paginationClickableValue,
                        },
                        slidesPerView: bannersPerViewMobileVal,
                        navigation: {
                            nextEl: '.js-swiper-banner-mobile-next',
                            prevEl: '.js-swiper-banner-mobile-prev',
                        },
                        on: {
                            afterInit: function () {
                                hideSwiperControls(".js-swiper-banner-mobile-prev", ".js-swiper-banner-mobile-next");
                            },
                        },
                        breakpoints: {
                            768: {
                                slidesPerView: bannersPerViewDesktopVal,
                            }
                        }
                    },function(swiperInstance) {
                        window.homeBannerMobileSwiper = swiperInstance;
                    });
                {% endif %}

            {% if banner_only_mobile_slider or banner_only_desktop_slider %}
                }
            {% endif %}

        {% endif %}

        {% if settings.banner_promotional_format_mobile == 'slider' or settings.banner_promotional_format_desktop == 'slider' and (settings.banner_promotional and settings.banner_promotional is not empty) or theme_editor %}

            {% set banner_promotional_desktop_slider = settings.banner_promotional_format_desktop == 'slider' %}
            {% set banner_promotional_only_mobile_slider = settings.banner_promotional_format_mobile == 'slider' and settings.banner_promotional_format_desktop != 'slider' %}
            {% set banner_promotional_only_desktop_slider = settings.banner_promotional_format_desktop == 'slider' and settings.banner_promotional_format_mobile != 'slider' %}
            {% set banner_promotional_columns_desktop = settings.banner_promotional_columns_desktop %}

            var bannersPromotionalPerViewDesktopVal = {% if banner_promotional_columns_desktop == 4 %}4{% elseif banner_promotional_columns_desktop == 3 %}3{% elseif banner_promotional_columns_desktop == 2 %}2{% else %}1{% endif %};
            var bannersPromotionalPerViewMobileVal = 1.15;
            var bannersPromotionalSpaceBetween = {% if settings.banner_promotional_without_margins %}0{% else %}itemSwiperSpaceBetween{% endif %};

            {% if banner_promotional_only_mobile_slider %}
                if (window.innerWidth < 768) {
            {% elseif banner_promotional_only_desktop_slider %}
                if (window.innerWidth > 768) {
            {% endif %}

                {# General banners #}

                {% if (settings.banner_promotional and settings.banner_promotional is not empty) or theme_editor %}
                    createSwiper('.js-swiper-banner-promotional', {
                        lazy: true,
                        watchOverflow: true,
                        threshold: 5,
                        watchSlideProgress: true,
                        watchSlidesVisibility: true,
                        slideVisibleClass: 'js-swiper-slide-visible',
                        spaceBetween: bannersPromotionalSpaceBetween,
                        pagination: {
                            el: '.js-swiper-banner-promotional-pagination',
                            clickable: paginationClickableValue,
                        },
                        navigation: {
                            nextEl: '.js-swiper-banner-promotional-next',
                            prevEl: '.js-swiper-banner-promotional-prev',
                        },
                        on: {
                            afterInit: function () {
                                hideSwiperControls(".js-swiper-banner-promotional-prev", ".js-swiper-banner-promotional-next");
                            },
                        },
                        slidesPerView: bannersPromotionalPerViewMobileVal,
                        breakpoints: {
                            768: {
                                slidesPerView: bannersPromotionalPerViewDesktopVal,
                            }
                        }
                    },function(swiperInstance) {
                        window.homeBannerPromotionalSwiper = swiperInstance;
                    });
                {% endif %}

                {# Mobile banners #}

                {% if (settings.toggle_banner_promotional_mobile and settings.banner_promotional_mobile and settings.banner_promotional_mobile is not empty) or theme_editor %}
                    createSwiper('.js-swiper-banner-promotional-mobile', {
                        lazy: true,
                        watchOverflow: true,
                        threshold: 5,
                        watchSlideProgress: true,
                        watchSlidesVisibility: true,
                        slideVisibleClass: 'js-swiper-slide-visible',
                        spaceBetween: bannersPromotionalSpaceBetween,
                        pagination: {
                            el: '.js-swiper-banner-promotional-mobile-pagination',
                            clickable: paginationClickableValue,
                        },
                        slidesPerView: bannersPromotionalPerViewMobileVal,
                        navigation: {
                            nextEl: '.js-swiper-banner-promotional-mobile-next',
                            prevEl: '.js-swiper-banner-promotional-mobile-prev',
                        },
                        on: {
                            afterInit: function () {
                                hideSwiperControls(".js-swiper-banner-promotional-mobile-prev", ".js-swiper-banner-promotional-mobile-next");
                            },
                        },
                        breakpoints: {
                            768: {
                                slidesPerView: bannersPromotionalPerViewDesktopVal,
                            }
                        }
                    },function(swiperInstance) {
                        window.homeBannerPromotionalMobileSwiper = swiperInstance;
                    });
                {% endif %}
            {% if banner_promotional_only_mobile_slider or banner_promotional_only_desktop_slider %}
                }
            {% endif %}

        {% endif %}

        {% if settings.banner_news_format_mobile == 'slider' or settings.banner_news_format_desktop == 'slider' and (settings.banner_news and settings.banner_news is not empty) or theme_editor %}

            {% set banner_news_desktop_slider = settings.banner_news_format_desktop == 'slider' %}
            {% set banner_news_only_mobile_slider = settings.banner_news_format_mobile == 'slider' and settings.banner_news_format_desktop != 'slider' %}
            {% set banner_news_only_desktop_slider = settings.banner_news_format_desktop == 'slider' and settings.banner_news_format_mobile != 'slider' %}
            {% set banner_news_columns_desktop = settings.banner_news_columns_desktop %}

            var bannersNewsPerViewDesktopVal = {% if banner_news_columns_desktop == 4 %}4{% elseif banner_news_columns_desktop == 3 %}3{% elseif banner_news_columns_desktop == 2 %}2{% else %}1{% endif %};
            var bannersNewsPerViewMobileVal = 1.15;
            var bannersNewsSpaceBetween = {% if settings.banner_news_without_margins %}0{% else %}itemSwiperSpaceBetween{% endif %};

            {% if banner_news_only_mobile_slider %}
                if (window.innerWidth < 768) {
            {% elseif banner_news_only_desktop_slider %}
                if (window.innerWidth > 768) {
            {% endif %}

                {# General banners #}

                {% if (settings.banner_news and settings.banner_news is not empty) or theme_editor %}
                    createSwiper('.js-swiper-banner-news', {
                        lazy: true,
                        watchOverflow: true,
                        threshold: 5,
                        watchSlideProgress: true,
                        watchSlidesVisibility: true,
                        slideVisibleClass: 'js-swiper-slide-visible',
                        spaceBetween: bannersNewsSpaceBetween,
                        pagination: {
                            el: '.js-swiper-banner-news-pagination',
                            clickable: paginationClickableValue,
                        },
                        navigation: {
                            nextEl: '.js-swiper-banner-news-next',
                            prevEl: '.js-swiper-banner-news-prev',
                        },
                        on: {
                            afterInit: function () {
                                hideSwiperControls(".js-swiper-banner-news-prev", ".js-swiper-banner-news-next");
                            },
                        },
                        slidesPerView: bannersNewsPerViewMobileVal,
                        breakpoints: {
                            768: {
                                slidesPerView: bannersNewsPerViewDesktopVal,
                            }
                        }
                    },function(swiperInstance) {
                        window.homeBannerNewsSwiper = swiperInstance;
                    });
                {% endif %}

                {# Mobile banners #}

                {% if (settings.toggle_banner_news_mobile and settings.banner_news_mobile and settings.banner_news_mobile is not empty) or theme_editor %}
                    createSwiper('.js-swiper-banner-news-mobile', {
                        lazy: true,
                        watchOverflow: true,
                        threshold: 5,
                        watchSlideProgress: true,
                        watchSlidesVisibility: true,
                        slideVisibleClass: 'js-swiper-slide-visible',
                        spaceBetween: bannersNewsSpaceBetween,
                        pagination: {
                            el: '.js-swiper-banner-news-mobile-pagination',
                            clickable: paginationClickableValue,
                        },
                        slidesPerView: bannersNewsPerViewMobileVal,
                        navigation: {
                            nextEl: '.js-swiper-banner-mobile-news-next',
                            prevEl: '.js-swiper-banner-mobile-news-prev',
                        },
                        on: {
                            afterInit: function () {
                                hideSwiperControls(".js-swiper-banner-news-mobile-prev", ".js-swiper-banner-news-mobile-next");
                            },
                        },
                        breakpoints: {
                            768: {
                                slidesPerView: bannersNewsPerViewDesktopVal,
                            }
                        }
                    },function(swiperInstance) {
                        window.homeBannerNewsMobileSwiper = swiperInstance;
                    });
                {% endif %}

            {% if banner_news_only_mobile_slider or banner_news_only_desktop_slider %}
                }
            {% endif %}

        {% endif %}

        {# Image and text modules #}

        {% if (settings.module_slider or theme_editor and (settings.module and settings.module is not empty)) or theme_editor %}

            createSwiper('.js-swiper-module', {
                lazy: true,
                watchOverflow: true,
                threshold: 5,
                watchSlideProgress: true,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                spaceBetween: itemSwiperSpaceBetween,
                pagination: {
                    el: '.js-swiper-module-pagination',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-module-next',
                    prevEl: '.js-swiper-module-prev',
                },
                slidesPerView: 1.15,
                breakpoints: {
                    768: {
                        slidesPerView: 1,
                    }
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-module-prev", ".js-swiper-module-next");
                    },
                },
            },
            function(swiperInstance) {
                window.homeModuleSwiper = swiperInstance;
            });

        {% endif %}

        {# /* // Institutional slider */ #}

        createSwiper('.js-swiper-institutional', {
            slidesPerView: 1,
            threshold: 5,
            pagination: {
                el: '.js-swiper-institutional-pagination',
                clickable: paginationClickableValue,
            },
            navigation: {
                nextEl: '.js-swiper-institutional-next',
                prevEl: '.js-swiper-institutional-prev',
            },
        },function(swiperInstance) {
            window.institutionalSwiper = swiperInstance;
        });

        {# /* // Main categories */ #}

        createSwiper('.js-swiper-categories', {
            lazy: true,
            preloadImages : false,
            watchOverflow: true,
            watchSlidesVisibility : true,
            slidesPerView: 'auto',
            navigation: {
                nextEl: '.js-swiper-categories-next',
                prevEl: '.js-swiper-categories-prev',
            },
            on: {
                afterInit: function () {
                    hideSwiperControls(".js-swiper-categories-prev", ".js-swiper-categories-next");
                },
            },
        },function(swiperInstance) {
            window.mainCategoriesSwiper = swiperInstance;
        });

        {# Demo main categories #}

        window.swiperLoader('.js-swiper-categories-demo', {
             lazy: true,
            preloadImages : false,
            watchOverflow: true,
            watchSlidesVisibility : true,
            slidesPerView: 'auto',
            navigation: {
                nextEl: '.js-swiper-categories-demo-next',
                prevEl: '.js-swiper-categories-demo-prev',
            },
        });

        {# /* // Timer offers */ #}

        // Timer clock

        {% set start_date = settings.timer_offers_start_datetime %}
        {% set end_date = settings.timer_offers_end_datetime %}
        {% set theme_editor = params.preview %}

        {% if not theme_editor and start_date and end_date %}
            
            const $timerOffersContainer = jQueryNuvem('.js-timer-offers-container');
            if ($timerOffersContainer.length) {

                // Convert data attributes to numbers
                let startTimestamp = parseInt($timerOffersContainer.attr('data-start-timestamp'), 10);
                let endTimestamp = parseInt($timerOffersContainer.attr('data-end-timestamp'), 10);

                // Get timezone offset from data attribute
                const timezone = $timerOffersContainer.attr('data-timezone');
                const timezoneOffsets = {
                    'America/Argentina/Buenos_Aires': -3 * 3600,
                    'America/Sao_Paulo': -3 * 3600,
                    'America/Mexico_City': -6 * 3600,
                    'America/Bogota': -5 * 3600,
                    'America/Santiago': -4 * 3600,
                    'UTC': 0
                };
                const timezoneOffset = timezoneOffsets[timezone] || 0;

                // Function to get the current timestamp adjusted by timezone offset
                function getCurrentTimestamp() {
                    // Get current time in seconds and adjust by timezone offset
                    return Math.floor(Date.now() / 1000) + timezoneOffset;
                }

                // Flag to check if the container has been shown
                let sectionVisible = false;

                // Function to update the countdown
                let countdownInterval;

                function updateCountdown() {
                    // Get the current timestamp with timezone adjustment
                    const currentTimestamp = getCurrentTimestamp();

                    let timeLeft = endTimestamp - currentTimestamp;

                    if (timeLeft <= 0) {
                        // If time has expired, remove the section
                        $timerOffersContainer.remove();
                        clearInterval(countdownInterval);
                        return;
                    } else {
                        // Show the container if it hasn't been shown yet
                        if (!sectionVisible) {
                            $timerOffersContainer.show();
                            {% if sections.timer_offers.products and settings.timer_offers_products_show %}
                                $timerOffersContainer.addClass("d-grid grid-md-2");
                            {% endif %}
                            sectionVisible = true;
                        }
                    }

                    // Calculate remaining hours, minutes, and seconds
                    const hours = Math.floor(timeLeft / 3600);
                    const minutes = Math.floor((timeLeft % 3600) / 60);
                    const seconds = Math.floor(timeLeft % 60);

                    // Update the countdown display
                    jQueryNuvem('.js-timer-offers-hour').text(hours.toString().padStart(2, '0'));
                    jQueryNuvem('.js-timer-offers-minutes').text(minutes.toString().padStart(2, '0'));
                    jQueryNuvem('.js-timer-offers-seconds').text(seconds.toString().padStart(2, '0'));
                }

                // Start the countdown
                countdownInterval = setInterval(updateCountdown, 1000);

                // Initial check to ensure container visibility
                updateCountdown();
            }


        {% endif %}

        // Timer products

        {% if (not theme_editor and sections.timer_offers.products and settings.timer_offers_products_show) or (theme_editor and sections.timer_offers.products) %}

            createSwiper('.js-swiper-timer-offers', {
                lazy: lazyValue,
                watchOverflow: watchOverflowVal,
                centerInsufficientSlides: centerInsufficientSlidesVal,
                threshold: 5,
                watchSlideProgress: true,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                spaceBetween: itemSwiperSpaceBetween,
            {% if sections.timer_offers.products | length > 4 %}
                loop: true,
            {% endif %}
                navigation: {
                    nextEl: '.js-swiper-timer-offers-next',
                    prevEl: '.js-swiper-timer-offers-prev',
                },
                pagination: {
                    el: '.js-swiper-timer-offers-pagination',
                    clickable: true,
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-timer-offers-prev", ".js-swiper-timer-offers-next");
                    },
                },
                slidesPerView: 1.75,
                breakpoints: {
                    768: {
                        slidesPerView: 3,
                        slidesPerGroup: 3,
                    }
                },
            },
            function(swiperInstance) {
                window.productsTimerSwiper = swiperInstance;
            });

        {% endif %}

        createSwiper('.js-swiper-timer-offers-empty', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            spaceBetween: itemSwiperSpaceBetween,
            slideVisibleClass: 'js-swiper-slide-visible',
            slidesPerView: 1.75,
            navigation: {
                nextEl: '.js-swiper-timer-offers-empty-next',
                prevEl: '.js-swiper-timer-offers-empty-prev',
            },
            pagination: {
                el: '.js-swiper-timer-offers-empty-pagination',
                clickable: true,
            },
            breakpoints: {
                768: {
                    slidesPerView: 3,
                    slidesPerGroup: 3,
                }
            }
        });


        {# /* // Brands slider */ #}

        createSwiper('.js-swiper-brands', {
            lazy: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            threshold: 5,
            slidesPerView: 3.5,
            spaceBetween: 24,
            navigation: {
                nextEl: '.js-swiper-brands-next',
                prevEl: '.js-swiper-brands-prev',
            },
            on: {
                afterInit: function () {
                    hideSwiperControls(".js-swiper-brands-prev", ".js-swiper-brands-next");
                },
                {% if settings.brands | length > 3 and settings.brands | length < 6  %}
                    beforeInit: function () {
                        if (window.innerWidth > 768) {
                            jQueryNuvem(".js-swiper-brands-wrapper").addClass("justify-content-center");
                        }
                    },
                {% endif %}
            },
            breakpoints: {
                768: {
                    slidesPerView: 10,
                }
            },
        },function(swiperInstance) {
            window.brandsSwiper = swiperInstance;
        });

        {# /* // Testimonials slider */ #}

        {% set has_testimonial_01 = settings.testimonial_01_title or settings.testimonial_01_description or settings.testimonial_01_name or "testimonial_01.jpg" | has_custom_image %}
        {% set has_testimonial_02 = settings.testimonial_02_title or settings.testimonial_02_description or settings.testimonial_02_name or "testimonial_02.jpg" | has_custom_image %}
        {% set has_testimonial_03 = settings.testimonial_03_title or settings.testimonial_03_description or settings.testimonial_03_name or "testimonial_03.jpg" | has_custom_image %}
        {% set has_testimonial_04 = settings.testimonial_04_title or settings.testimonial_04_description or settings.testimonial_04_name or "testimonial_04.jpg" | has_custom_image %}
        {% set has_testimonial_05 = settings.testimonial_05_title or settings.testimonial_05_description or settings.testimonial_05_name or "testimonial_05.jpg" | has_custom_image %}
        {% set has_testimonials = (has_testimonial_01 and has_testimonial_02) or (has_testimonial_01 and has_testimonial_03) or (has_testimonial_01 and has_testimonial_04) or (has_testimonial_02 and has_testimonial_03) or (has_testimonial_02 and has_testimonial_04) or (has_testimonial_03 and has_testimonial_04) %}

        createSwiper('.js-swiper-testimonials', {
            lazy: true,
            centerInsufficientSlides: true,
            {% if has_testimonials %}
                slidesPerView: 1.15,
            {% endif %}
            watchOverflow: true,
            threshold: 5,
            spaceBetween: itemSwiperSpaceBetween,
            navigation: {
                nextEl: '.js-swiper-testimonials-next',
                prevEl: '.js-swiper-testimonials-prev',
            },
            pagination: {
                el: '.js-swiper-testimonials-pagination',
                clickable: true,
            },
            breakpoints: {
                768: {
                    slidesPerView: 3,
                    spaceBetween: 48,
                }
            }
        },
        function(swiperInstance) {
            window.testimonialsSwiper = swiperInstance;
        });

        {# /* // Instafeed slider */ #}

        createSwiper('.js-swiper-instafeed', {
            lazy: true,
            watchOverflow: true,
            spaceBetween: itemSwiperSpaceBetween,
            slidesPerView: 1,
            observer: true,
            pagination: {
                el: '.js-swiper-instafeed-pagination',
                clickable: true,
            },
            breakpoints: {
                768: {
                    slidesPerView: 4,
                }
            }
        });

        {# /* // Products slider */ #}

        {% set has_featured_products_slider = sections.primary.products and (settings.featured_products_format_mobile == 'slider' or settings.featured_products_format_desktop == 'slider') %}
        {% set has_new_products_slider = sections.new.products and (settings.new_products_format_mobile == 'slider' or settings.new_products_format_desktop == 'slider') %}
        {% set has_sale_products_slider = sections.sale.products and (settings.sale_products_format_mobile == 'slider' or settings.sale_products_format_desktop == 'slider') %}

        {# /* Featured products */ #}

        {% set featured_desktop_slider = settings.featured_products_format_desktop == 'slider' %}
        {% set featured_only_mobile_slider = settings.featured_products_format_mobile == 'slider' and settings.featured_products_format_desktop != 'slider' %}
        {% set featured_only_desktop_slider = settings.featured_products_format_desktop == 'slider' and settings.featured_products_format_mobile != 'slider' %}
        {% set featured_columns_desktop = settings.featured_products_desktop %}
        {% set featured_columns_mobile = settings.featured_products_mobile %}
        var slidesPerViewFeaturedDesktopVal = {% if featured_columns_desktop == 4 %}4{% elseif featured_columns_desktop == 5 %}5{% else %}6{% endif %};
        var slidesPerViewFeaturedMobileVal = {% if featured_columns_mobile == 1 %}1{% else %}2{% endif %};

        {% if featured_only_mobile_slider %}
            if (window.innerWidth < 768) {
        {% elseif featured_only_desktop_slider %}
            if (window.innerWidth > 768) {
        {% endif %}
            createSwiper('.js-swiper-featured', {
                lazy: lazyValue,
                watchOverflow: watchOverflowVal,
                centerInsufficientSlides: centerInsufficientSlidesVal,
                threshold: 5,
                watchSlideProgress: true,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                spaceBetween: itemSwiperSpaceBetween,
            {% if sections.primary.products | length > 4 %}
                loop: true,
            {% endif %}
                navigation: {
                    nextEl: '.js-swiper-featured-next',
                    prevEl: '.js-swiper-featured-prev',
                },
                pagination: {
                    el: '.js-swiper-featured-pagination',
                    clickable: true,
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-featured-prev", ".js-swiper-featured-next");
                    },
                },
                slidesPerView: slidesPerViewFeaturedMobileVal,
            {% if featured_desktop_slider %}
                breakpoints: {
                    768: {
                        slidesPerView: slidesPerViewFeaturedDesktopVal,
                        slidesPerGroup: slidesPerViewFeaturedDesktopVal,
                    }
                },
            {% endif %}
            },
            function(swiperInstance) {
                window.productsFeaturedSwiper = swiperInstance;
            });
        {% if featured_only_mobile_slider or featured_only_desktop_slider %}
            }
        {% endif %}

        {# /* New products */ #}

        {% set new_desktop_slider = settings.new_products_format_desktop == 'slider' %}
        {% set new_only_mobile_slider = settings.new_products_format_mobile == 'slider' and settings.new_products_format_desktop != 'slider' %}
        {% set new_only_desktop_slider = settings.new_products_format_desktop == 'slider' and settings.new_products_format_mobile != 'slider' %}
        {% set new_columns_desktop = settings.new_products_desktop %}
        {% set new_columns_mobile = settings.new_products_mobile %}
        var slidesPerViewNewDesktopVal = {% if new_columns_desktop == 4 %}4{% elseif new_columns_desktop == 5 %}5{% else %}6{% endif %};
        var slidesPerViewNewMobileVal = {% if new_columns_mobile == 1 %}1{% else %}2{% endif %};

        {% if new_only_mobile_slider %}
            if (window.innerWidth < 768) {
        {% elseif new_only_desktop_slider %}
            if (window.innerWidth > 768) {
        {% endif %}
            createSwiper('.js-swiper-new', {
                lazy: lazyValue,
                watchOverflow: watchOverflowVal,
                centerInsufficientSlides: centerInsufficientSlidesVal,
                threshold: 5,
                watchSlideProgress: true,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                spaceBetween: itemSwiperSpaceBetween,
            {% if sections.new.products | length > 4 %}
                loop: true,
            {% endif %}
                navigation: {
                    nextEl: '.js-swiper-new-next',
                    prevEl: '.js-swiper-new-prev',
                },
                pagination: {
                    el: '.js-swiper-new-pagination',
                    clickable: true,
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-new-prev", ".js-swiper-new-next");
                    },
                },
                slidesPerView: slidesPerViewNewMobileVal,
            {% if new_desktop_slider %}
                breakpoints: {
                    768: {
                        slidesPerView: slidesPerViewNewDesktopVal,
                        slidesPerGroup: slidesPerViewNewDesktopVal,
                    }
                },
            {% endif %}
            },
            function(swiperInstance) {
                window.productsNewSwiper = swiperInstance;
            });
        {% if new_only_mobile_slider or new_only_desktop_slider %}
            }
        {% endif %}

        {# /* Sale products */ #}

        {% set sale_desktop_slider = settings.sale_products_format_desktop == 'slider' %}
        {% set sale_only_mobile_slider = settings.sale_products_format_mobile == 'slider' and settings.sale_products_format_desktop != 'slider' %}
        {% set sale_only_desktop_slider = settings.sale_products_format_desktop == 'slider' and settings.sale_products_format_mobile != 'slider' %}
        {% set sale_columns_desktop = settings.sale_products_desktop %}
        {% set sale_columns_mobile = settings.sale_products_mobile %}
        var slidesPerViewSaleDesktopVal = {% if sale_columns_desktop == 4 %}4{% elseif sale_columns_desktop == 5 %}5{% else %}6{% endif %};
        var slidesPerViewSaleMobileVal = {% if sale_columns_mobile == 1 %}1{% else %}2{% endif %};

        {% if sale_only_mobile_slider %}
            if (window.innerWidth < 768) {
        {% elseif sale_only_desktop_slider %}
            if (window.innerWidth > 768) {
        {% endif %}
            createSwiper('.js-swiper-sale', {
                lazy: lazyValue,
                watchOverflow: watchOverflowVal,
                centerInsufficientSlides: centerInsufficientSlidesVal,
                threshold: 5,
                watchSlideProgress: true,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                spaceBetween: itemSwiperSpaceBetween,
            {% if sections.sale.products | length > 4 %}
                loop: true,
            {% endif %}
                navigation: {
                    nextEl: '.js-swiper-sale-next',
                    prevEl: '.js-swiper-sale-prev',
                },
                pagination: {
                    el: '.js-swiper-sale-pagination',
                    clickable: true,
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-sale-prev", ".js-swiper-sale-next");
                    },
                },
                slidesPerView: slidesPerViewSaleMobileVal,
            {% if sale_desktop_slider %}
                breakpoints: {
                    768: {
                        slidesPerView: slidesPerViewSaleDesktopVal,
                        slidesPerGroup: slidesPerViewSaleDesktopVal,
                    }
                },
            {% endif %}
            },
            function(swiperInstance) {
                window.productsSaleSwiper = swiperInstance;
            });
        {% if sale_only_mobile_slider or sale_only_desktop_slider %}
            }
        {% endif %}

        {# /* // Banner services slider */ #}

        {% set has_banner_services_01 = settings.banner_services_01_title or settings.banner_services_01_description %}
        {% set has_banner_services_02 = settings.banner_services_02_title or settings.banner_services_02_description %}
        {% set has_banner_services_03 = settings.banner_services_03_title or settings.banner_services_03_description %}
        {% set has_banner_services_04 = settings.banner_services_04_title or settings.banner_services_04_description %}
        {% set has_banner_services = (has_banner_services_01 or has_banner_services_02 or has_banner_services_03 or has_banner_services_04) %}

        {% if has_banner_services or params.preview %}
            createSwiper('.js-informative-banners', {
                centerInsufficientSlides: true,
                watchOverflow: true,
                threshold: 5,
                spaceBetween: itemSwiperSpaceBetween,
                pagination: {
                    el: '.js-informative-banners-pagination',
                    clickable: true,
                },
                breakpoints: {
                    768: {
                        slidesPerView: 4,
                    }
                }
            },
            function(swiperInstance) {
                window.informativeBannersSwiper = swiperInstance;
            });
        {% endif %}

        {% if settings.home_promotional_popup %}

            {# /* // Home popup and newsletter popup */ #}

            jQueryNuvem('#news-popup-form').on("submit", function () {
                jQueryNuvem(".js-news-spinner").show();
                jQueryNuvem(".js-news-popup-submit").prop("disabled", true);
            });

            LS.newsletter('#news-popup-form-container', '#home-modal', '{{ store.contact_url | escape('js') }}', function (response) {
                jQueryNuvem(".js-news-spinner").hide();
                jQueryNuvem(".js-news-popup-submit").show();
                var selector_to_use = response.success ? '.js-news-success' : '.js-news-failed';
                let newPopupAlert = jQueryNuvem(this).find(selector_to_use).fadeIn(100);
                setTimeout(() => newPopupAlert.fadeOut(500), 4000);
                if (jQueryNuvem(".js-news-success").css("display") == "block") {
                    setTimeout(function () {
                        jQueryNuvem('[data-modal-id="#home-modal"]').fadeOut(500);
                        let homeModal = jQueryNuvem("#home-modal").removeClass("modal-visible");
                        setTimeout(() => homeModal.hide(), 500);
                        let homeModalOverlay = jQueryNuvem('.js-modal-overlay-private[data-modal-url="home-modal"]');
                        setTimeout(() => homeModalOverlay.hide(), 500);
                    }, 2500);
                }
                jQueryNuvem(".js-news-popup-submit").prop("disabled", false);
            });

            var callback_show = function(){
                {% if store.whatsapp %}
                    jQueryNuvem('.js-btn-fixed-bottom').fadeOut(500);
                {% endif %}
                jQueryNuvem("#home-modal").detach().appendTo("body").show().addClass("modal-visible");
                jQueryNuvem('.js-modal-overlay-private[data-modal-url="home-modal"]').show();
            }
            var callback_hide = function(){
                let homeModal = jQueryNuvem("#home-modal").removeClass("modal-visible");
                setTimeout(() => homeModal.hide(), 500);

                let homeModalOverlay = jQueryNuvem('.js-modal-overlay-private[data-modal-url="home-modal"]');
                setTimeout(() => homeModalOverlay.hide(), 500);
            }

            {% if store.whatsapp %}
                jQueryNuvem("#home-modal .js-modal-close").on("click", function (e) {
                    e.preventDefault();
                    jQueryNuvem('.js-btn-fixed-bottom').fadeIn(500);
                });
            {% endif %}

            LS.homePopup({
                selector: "#home-modal",
                mobile_max_pixels: 0,
                timeout: 10000
            }, callback_hide, callback_show);

        {% endif %}

        {# /* // Main product description toggle */ #}

        {% if sections.featured.products %}
            if (jQueryNuvem('.js-product-description').height() < jQueryNuvem('.js-product-description').prop("scrollHeight")){
                jQueryNuvem(".js-view-description").show();
            }

            jQueryNuvem(document).on("click", ".js-view-description", function(e) {
                e.preventDefault();
                jQueryNuvem(this).prev(".js-product-description").toggleClass("product-description-full");
                jQueryNuvem(".js-view-more, .js-view-less").toggle();
            });
        {% endif %}

    {% endif %}

    {# /* // Youtube video */ #}

    {% if template == 'home' and settings.video_embed %}
        {% set video_url = settings.video_embed %}
        {% set video_format = 
            '/watch?v=' in video_url ? '/watch?v=' :
            '/youtu.be/' in video_url ? '/youtu.be/' :
            '/shorts/' in video_url ? '/shorts/'
        %}
        {% set video_id = video_url|split(video_format)|last %}

        function loadVideoFrame() {
            window.youtubeIframeService.executeOnReady(() => { 
                new YT.Player('player', {
                        width: '100%',
                        videoId: '{{video_id}}',
                        playerVars: { 'autoplay': 1, 'playsinline': 1, 'rel': 0, 'loop': 1, 'autopause': 0, 'controls': 0, 'showinfo': 0, 'modestbranding': 1, 'branding': 0, 'fs': 0, 'iv_load_policy': 3 },
                        events: {
                            'onReady': onPlayerReady,
                            'onStateChange':onPlayerStateChange
                        }
                    }
                );
            });
        };

        {% if settings.home_order_position_1 == 'video' and settings.video_type == 'autoplay' %}
            if (window.innerWidth < 768) {
                window.addEventListener("pointerdown", () => {
                    loadVideoFrame();
                }, { once: true });
            } else {
                loadVideoFrame();
            }
        {% else %}
            {% if settings.video_type == 'autoplay' %}
                jQueryNuvem('.js-home-video').on('lazyloaded', function(e){
                    loadVideoFrame();
                });
            {% else %}
                jQueryNuvem('.js-play-button').on("click", function(e){
                    e.preventDefault();
                    jQueryNuvem(this).hide();
                    jQueryNuvem(".js-home-video-image").hide();
                    loadVideoFrame();
                });
            {% endif %}
        {% endif %}
        

        function onPlayerReady(event) {
            {% if settings.video_type == 'autoplay' %}
                event.target.mute();
            {% endif %}
            event.target.playVideo();
        }

        function onPlayerStateChange(event) {
            {% if settings.home_order_position_1 == 'video' %}
                if (event.data == YT.PlayerState.PLAYING) {
                    jQueryNuvem(".js-home-video-image").addClass("fade-in");
                }
            {% endif %}
            if (event.data == YT.PlayerState.ENDED) {
                event.target.seekTo(0);
                event.target.playVideo();
            }
        }

    {% endif %}

    {% if template == 'product' and product.video_url %}
        {% set video_url = product.video_url %}
        {# /* // Youtube video for product detail */ #}
        LS.loadVideo('{{ video_url }}');
    {% endif %}

    {#/*============================================================================
      #Product grid
    ==============================================================================*/ #}

    {# /* // Button variations */ #}

    {% if settings.bullet_variants or settings.product_color_variants or settings.image_color_variants %}
        changeVariantButton = function(selector, parentSelector) {
            selector.siblings().removeClass("selected");
            selector.addClass("selected");
            var option_id = selector.attr('data-option');
            var parent = selector.closest(parentSelector);
            var selected_option = parent.find('.js-variation-option option').filter(function (el) {
                return el.value == option_id;
            });
            selected_option.prop('selected', true).trigger('change');
            parent.find('.js-insta-variation-label').html(option_id);
        }

        {% if settings.bullet_variants or settings.image_color_variants %}
            
            {# /* // Color and size variations */ #}

            jQueryNuvem(document).on("click", ".js-insta-variant", function (e) {
                e.preventDefault();
                $this = jQueryNuvem(this);
                changeVariantButton($this, '.js-product-variants-group');
            });

        {% endif %}

        {% if settings.product_color_variants %}
            {# Product color variations #}
            if (window.innerWidth > 767) {
                jQueryNuvem(document).on("click", ".js-color-variant", function(e) {
                    e.preventDefault();
                    $this = jQueryNuvem(this);
                    changeVariantButton($this, '.js-product-item-private');
                });
            }
        {% endif %}

    {% endif %}

    {% set has_item_slider = settings.product_item_slider %}

    {% if settings.quick_shop or settings.product_color_variants %}
        LS.registerOnChangeVariant(function(variant){
            {# Show product image on color change #}
            const productContainer = jQueryNuvem('.js-product-item-private[data-product-id="'+variant.product_id+'"]');
            const current_image = productContainer.find('.js-product-item-image-private');
            current_image.attr('srcset', variant.image_url);

            {% if has_item_slider %}

                {# Remove slider when variant changes #}

                const swiperElement = productContainer.find('.js-product-item-slider-container-private.swiper-container-initialized');

                if(swiperElement.length){
                    productContainer.find('.js-product-item-slider-slide-private').removeClass('product-item-slider-slide');
                    setTimeout(function(){
                        const productImageLink = productContainer.find('.js-product-item-image-link-private');
                        const imageToKeep = productContainer.find('.js-swiper-slide-visible img').clone();
                        
                        // Destroy the Swiper instance
                        if (itemProductSliders[variant.product_id]) {
                            itemProductSliders[variant.product_id].destroy(true, true);
                            delete itemProductSliders[variant.product_id];
                        }
                         // Remove the Swiper elements
                         swiperElement.remove();
                         productContainer.find('.js-product-item-slider-pagination-container').remove();

                        // Insert the cloned image into the link
                        productImageLink.append(imageToKeep);

                    },300);
                }
            {% endif %}

            {% if settings.product_hover %}
                {# Remove secondary feature on image updated from changeVariant #}
                productContainer.find(".js-product-item-private-with-secondary-images").addClass("product-item-secondary-images-disabled");
            {% endif %}

        });
    {% endif %}

    const nav_height = jQueryNuvem(".js-head-main").innerHeight();
    const $category_controls = jQueryNuvem(".js-category-controls");

    {% if template == 'category' %}

        {# /* // Fixed category controls */ #}

        if (window.innerWidth < 768) {

            $category_controls.css("top" , nav_height.toString() + 'px');

            {# Detect if category controls are sticky #}

            var observer = new IntersectionObserver(function(entries) {
                $category_controls
                }, { threshold: [0,1]
            });
            observer.observe(document.querySelector(".js-category-controls-prev"));

            offsetCategories = function() {
                var $sticky_category_controls = jQueryNuvem(".js-category-controls");

                var categoriesOffset = jQueryNuvem(".js-head-main").outerHeight();

                if(jQueryNuvem(".js-head-main").hasClass("compress")){
                    var categoriesOffset = categoriesOffset - adBarsHeight - 1;
                }

                $sticky_category_controls.css('top', (categoriesOffset).toString() + 'px' );
            };

            offsetCategories();

            document.addEventListener("scroll", function(){
                offsetCategories();
            });

        }     

    {% endif %}
    
    {% if template == 'category' or template == 'search' %}

        {# /* // Product item slider */ #}

        {% if has_item_slider %}

            LS.productItemSlider({ 
                pagination_type: 'fraction',
            });

        {% endif %}
        
        {% if settings.pagination == 'infinite' %}

            !function() {

                {# /* // Infinite scroll */ #}

                {% if pages.current == 1 and not pages.is_last %}
                    LS.hybridScroll({
                        productGridSelector: '.js-product-table',
                        spinnerSelector: '#js-infinite-scroll-spinner',
                        loadMoreButtonSelector: '.js-load-more',
                        hideWhileScrollingSelector: ".js-hide-footer-while-scrolling",
                        productsBeforeLoadMoreButton: 60,
                        productsPerPage: 12,
                        {% if has_item_slider %}
                            afterLoaded: function(){ 
                                LS.productItemSlider({ 
                                    pagination_type: 'fraction',
                                });
                            }
                        {% endif %}
                    });
                {% endif %}
            }();

        {% endif %}
    {% endif %}

    {# /* // Variants without stock */ #}

    {% set is_button_variant = settings.bullet_variants or settings.image_color_variants %}

    {% if is_button_variant %}
        const noStockVariants = (container = null) => {

            {# Configuration for variant elements #}
            const config = {
                variantsGroup: ".js-product-variants-group",
                variantButton: ".js-insta-variant",
                noStockClass: "btn-variant-no-stock",
                dataVariationId: "data-variation-id",
                dataOption: "data-option"
            };

            {# Product container wrapper #}
            const wrapper = container ? container : jQueryNuvem('#single-product');
            if (!wrapper) return;

            {# Fetch the variants data from the container #}
            const dataVariants = wrapper.data('variants');
            const variantsLength = wrapper.find(config.variantsGroup).length;

            {# Get selected options from product variations #}
            const getOptions = (productVariationId, variantOption) => {
                if (productVariationId === 2) {
                    return {
                        option0: String(wrapper.find(`${config.variantsGroup}[${config.dataVariationId}="0"] select`).val()),
                        option1: String(wrapper.find(`${config.variantsGroup}[${config.dataVariationId}="1"] select`).val()),
                        option2: String(jQueryNuvem(variantOption).attr('data-option')),
                    };
                } else if (productVariationId === 1) {
                    return {
                        option0: String(wrapper.find(`${config.variantsGroup}[${config.dataVariationId}="0"] select`).val()),
                        option1: String(jQueryNuvem(variantOption).attr('data-option')),
                    };
                } else {
                    return {
                        option0: String(jQueryNuvem(variantOption).attr('data-option')),
                    };
                }
            };

            {# Filter available variants based on selected options #}
            const filterVariants = (options) => {
                return dataVariants.filter(variant => {
                    return Object.keys(options).every(optionKey => variant[optionKey] === options[optionKey]) && variant.available;
                });
            };

            {# Update stock status for variant buttons #}
            const updateStockStatus = (productVariationId) => {
                const variationGroup = wrapper.find(`${config.variantsGroup}[${config.dataVariationId}="${productVariationId}"]`);
                variationGroup.find(`${config.variantButton}.${config.noStockClass}`).removeClass(config.noStockClass);

                variationGroup.find(config.variantButton).each((variantOption, item) => {
                    const options = getOptions(productVariationId, variantOption);
                    const itemsAvailable = filterVariants(options);
                    const button = wrapper.find(`${config.variantsGroup}[${config.dataVariationId}="${productVariationId}"] ${config.variantButton}[${config.dataOption}="${options[`option${productVariationId}`].replace(/"/g, '\\"')}"]`);
                    
                    if (!itemsAvailable.length) {
                        button.addClass(config.noStockClass);
                    }
                });
            };

            {# Iterate through all variant and update stock status #}
            for (let productVariationId = variantsLength - 1; productVariationId >= 0; productVariationId--) {
                updateStockStatus(productVariationId);
            }
        };

        noStockVariants();

    {% endif %}

    {% if settings.quick_shop %}

        {# /* // Quickshop */ #}

        restoreQuickshopForm = function(){

            {# Restore form to item when quickshop closes #}

            {# Clean quickshop modal #}

            jQueryNuvem("#quickshop-modal .js-product-item-private").removeClass("js-swiper-slide-visible js-item-slide");
            jQueryNuvem("#quickshop-modal .js-quickshop-container").attr( { 'data-variants' : '' , 'data-quickshop-id': '' } );
            jQueryNuvem("#quickshop-modal .js-product-item-private").attr('data-product-id', '');

            {# Wait for modal to become invisible before removing form #}
            
            setTimeout(function(){
                var $quickshop_form = jQueryNuvem("#quickshop-form").find('.js-product-form');
                var $item_form_container = jQueryNuvem(".js-quickshop-opened").find(".js-item-variants");
                
                $quickshop_form.detach().appendTo($item_form_container);
                jQueryNuvem(".js-quickshop-opened").removeClass("js-quickshop-opened");
                jQueryNuvem("#quickshop-modal .js-quickshop-img").attr('srcset', '');
                jQueryNuvem("#quickshop-form").removeAttr("style");
            },350);

        };

        jQueryNuvem(document).on("click", ".js-quickshop-modal-open", function (e) {
            e.preventDefault();
            var $this = jQueryNuvem(this);
            if($this.hasClass("js-quickshop-slide")){
                jQueryNuvem("#quickshop-modal .js-product-item-private").addClass("js-swiper-slide-visible js-item-slide");
            }

            {% if is_button_variant %}
                {# Updates variants without stock #}
                let container = jQueryNuvem(this).closest('.js-product-item-private');
                if (!container.length) return;
                noStockVariants(container);
            {% endif %}

            LS.fillQuickshop($this);
        });

        jQueryNuvem(document).on("click", ".js-modal-close-private", function (e) {
            e.preventDefault();
            restoreQuickshopForm();
        });

    {% endif %}

    {#/*============================================================================
      #Product detail
    ==============================================================================*/ #}

    {# /* // Installments */ #}

    {# Installments without interest #}

    function get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests) {
        if (parseInt(number_of_installment) > parseInt(max_installments_without_interests[0])) {
            if (installment_data.without_interests) {
                return [number_of_installment, installment_data.installment_value.toFixed(2)];
            }
        }
        return max_installments_without_interests;
    }

    {# Installments with interest #}

    function get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests) {
        if (parseInt(number_of_installment) > parseInt(max_installments_with_interests[0])) {
            if (installment_data.without_interests == false) {
                return [number_of_installment, installment_data.installment_value.toFixed(2)];
            }
        }
        return max_installments_with_interests;
    }

    {# Updates installments on payment popup for native integrations #}

    function refreshInstallmentv2(price){
        jQueryNuvem(".js-modal-installment-price" ).each(function( el ) {
            const installment = Number(jQueryNuvem(el).data('installment'));
            jQueryNuvem(el).text(LS.currency.display_short + (price/installment).toLocaleString('de-DE', {maximumFractionDigits: 2, minimumFractionDigits: 2}));
        });
    }

    {# /* // Change variant */ #}

    {# Updates price, installments, labels and CTA on variant change #}

    function changeVariant(variant) {
        jQueryNuvem(".js-product-detail .js-shipping-calculator-response").hide();
        jQueryNuvem("#shipping-variant-id").val(variant.id);

        var parent = jQueryNuvem("body");
        if (variant.element) {
            parent = jQueryNuvem(variant.element);
            if(parent.hasClass("js-product-item-private")){
                var quick_id = parent.attr("data-quickshop-id");
                var parent = jQueryNuvem('.js-product-item-private[data-quickshop-id="'+quick_id+'"]');
            }
        }

        {% if is_button_variant %}
            {# Updates variants without stock #}
            if(parent.hasClass("js-product-item-private")){
                if(parent.hasClass("js-item-slide")){
                    var parent = jQueryNuvem('.js-swiper-slide-visible.js-product-item-private[data-quickshop-id="'+quick_id+'"]');
                }
                noStockVariants(parent);
            } else {
                noStockVariants();
            }
        {% endif %}

        var sku = parent.find('.js-product-sku');
        if(sku.length) {
            sku.text(variant.sku).show();
        }

        {% if settings.product_stock or settings.latest_products_available %}
            var stock = parent.find('.js-product-stock');
            stock.text(variant.stock).show();
        {% endif %}

        {# Updates installments on list item and inside payment popup for Payments Apps #}
        
        var installment_helper = function($element, amount, price){
            $element.find('.js-installment-amount').text(amount);
            $element.find('.js-installment-price').attr("data-value", price);
            $element.find('.js-installment-price').text(LS.currency.display_short + parseFloat(price).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
            if(variant.price_short && Math.abs(variant.price_number - price * amount) < 1) {
                $element.find('.js-installment-total-price').text((variant.price_short).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
            } else {
                $element.find('.js-installment-total-price').text(LS.currency.display_short + (price * amount).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
            }
        };

        var $payments_module = jQueryNuvem(variant.element + ' .js-product-payments-container');

        if (variant.installments_data) {
            var variant_installments = JSON.parse(variant.installments_data);
            var max_installments_without_interests = [0,0];
            var max_installments_with_interests = [0,0];

            {# Hide all installments rows on payments modal #}
            jQueryNuvem('.js-payment-provider-installments-row').hide();

            for (let payment_method in variant_installments) {

                {# Identifies the minimum installment value #}
                var paymentMethodId = '#installment_' + payment_method.replace(" ", "_") + '_1';
                var minimumInstallmentValue = jQueryNuvem(paymentMethodId).closest('.js-info-payment-method').attr("data-minimum-installment-value");

                let installments = variant_installments[payment_method];
                for (let number_of_installment in installments) {
                    let installment_data = installments[number_of_installment];
                    max_installments_without_interests = get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests);
                    max_installments_with_interests = get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests);
                    var installment_container_selector = '#installment_' + payment_method.replace(" ", "_") + '_' + number_of_installment;

                    {# Shows installments rows on payments modal according to the minimum value #}
                    if(minimumInstallmentValue <= installment_data.installment_value) {
                        jQueryNuvem(installment_container_selector).show();
                    }

                    if(!parent.hasClass("js-product-item-private")){
                        installment_helper(jQueryNuvem(installment_container_selector), number_of_installment, installment_data.installment_value.toFixed(2));
                    }
                }
            }
            var $installments_container = jQueryNuvem(variant.element + ' .js-max-installments-container .js-max-installments');
            var $installments_modal_link = jQueryNuvem(variant.element + ' #btn-installments');
            var $installmens_card_icon = jQueryNuvem(variant.element + ' .js-installments-credit-card-icon');

            {% if product.has_direct_payment_only %}
            var installments_to_use = max_installments_without_interests[0] >= 1 ? max_installments_without_interests : max_installments_with_interests;

            if(installments_to_use[0] <= 0 ) {
            {%  else %}
            var installments_to_use = max_installments_without_interests[0] > 1 ? max_installments_without_interests : max_installments_with_interests;

            if(installments_to_use[0] <= 1 ) {
            {% endif %}
                $installments_container.hide();
                $installments_modal_link.hide();
                $payments_module.hide();
                $installmens_card_icon.hide();
            } else {
                $installments_container.show();
                $installments_modal_link.show();
                $payments_module.show();
                $installmens_card_icon.show();
                installment_helper($installments_container, installments_to_use[0], installments_to_use[1]);
            }
        }

        if (variant.contact) {
            $payments_module.hide();
        }

        if(!parent.hasClass("js-quickshop-container")){
            jQueryNuvem('#installments-modal .js-installments-one-payment').text(variant.price_short).attr("data-value", variant.price_number);
        }

        if (variant.price_short){

            var variant_price_clean = variant.price_short.replace('$', '').replace('R', '').replace(',', '').replace('.', '');
            var variant_price_raw = parseInt(variant_price_clean, 10);

            parent.find('.js-price-display').text(variant.price_short).show();
            parent.find('.js-price-display').attr("content", variant.price_number).data('productPrice', variant_price_raw);

            parent.find('.js-price-without-taxes').text(variant.price_without_taxes);
            parent.find('.js-price-without-taxes-container').show();
        } else {
            parent.find('.js-price-display, .js-price-without-taxes-container').hide();
        }

        if ((variant.compare_at_price_short) && !(parent.find(".js-price-display").css("display") == "none")) {
            parent.find('.js-compare-price-display').text(variant.compare_at_price_short).show();

            if(variant.compare_at_price_number > variant.price_number){
                const saved_compare_price_money = variant.compare_at_price_number - variant.price_number;
                parent.find('.js-offer-saved-money').text(LS.formatToCurrency(saved_compare_price_money));
                parent.find(".js-saved-money-message").show();
            }else {
                parent.find(".js-saved-money-message").hide();
            }
        } else {
            parent.find('.js-compare-price-display, .js-saved-money-message').hide();
        }

        var button = parent.find('.js-addtocart');
        const quickshopButtonWording = parent.find('.js-open-quickshop-wording');
        const quickshopButtonIcon = parent.find('.js-open-quickshop-icon');
        button.removeClass('cart').removeClass('contact').removeClass('nostock');
        var $product_shipping_calculator = parent.find("#product-shipping-container");

        {# Update CTA wording and status #}

        {% if not store.is_catalog %}
            if (!variant.available){
                button.val('{{ "Sin stock" | translate }}');
                button.addClass('nostock');
                button.attr('disabled', 'disabled');
                quickshopButtonWording.text('{{ "Sin stock" | translate }}');
                quickshopButtonIcon.addClass("d-none").removeClass("d-md-inline");
                $product_shipping_calculator.hide();
            } else if (variant.contact) {
                button.val('{{ "Consultar precio" | translate }}');
                button.addClass('contact');
                button.removeAttr('disabled');
                quickshopButtonWording.text('{{ "Consultar precio" | translate }}');
                quickshopButtonIcon.addClass("d-none").removeClass("d-md-inline");
                $product_shipping_calculator.hide();
            } else {
                button.val('{{ "Agregar al carrito" | translate }}');
                button.addClass('cart');
                button.removeAttr('disabled');
                quickshopButtonWording.text('{{ "Comprar" | translate }}');
                quickshopButtonIcon.addClass("d-md-inline");
                $product_shipping_calculator.show();
            }

        {% endif %}

        {% if template == 'product' %}
            const base_price = Number(jQueryNuvem("#price_display").attr("content"));
            refreshInstallmentv2(base_price);
        {% endif %}

        {% if settings.last_product or settings.last_product_category %}
            if(variant.stock == 1) {
                parent.find('.js-last-product').show();
            } else {
                parent.find('.js-last-product').hide();
            }
            {% if settings.latest_products_available %}
                const stock_limit = jQueryNuvem(".js-latest-products-available").attr("data-limit");
                if(variant.stock < stock_limit && variant.stock != null && variant.stock != 1 && variant.stock != 0) {
                    parent.find('.js-latest-products-available').show();
                } else {
                    parent.find('.js-latest-products-available').hide();
                }
            {% endif %}
        {% endif %}

        {# Update shipping on variant change #}

        LS.updateShippingProduct();

        zipcode_on_changevariant = jQueryNuvem("#product-shipping-container .js-shipping-input").val();
        jQueryNuvem("#product-shipping-container .js-shipping-calculator-current-zip").text(zipcode_on_changevariant);

        {% if cart.free_shipping.min_price_free_shipping.min_price %}
            {# Updates free shipping bar #}
            
            LS.freeShippingProgress(true, parent);

        {% endif %}

        LS.subscriptionChangeVariant(variant);

    }

    {# /* // Trigger change variant */ #}

    jQueryNuvem(document).on("change", ".js-variation-option", function(e) {
        var $parent = jQueryNuvem(this).closest(".js-product-variants");
        var $variants_group = jQueryNuvem(this).closest(".js-product-variants-group");
        var $quickshop_parent_wrapper = jQueryNuvem(this).closest(".js-product-item-private");

        {# If quickshop is used from modal, use quickshop-id from the item that opened it #}

        var quick_id = $quickshop_parent_wrapper.attr("data-quickshop-id");

        if($parent.hasClass("js-product-quickshop-variants")){

            var $quickshop_parent = jQueryNuvem(this).closest(".js-item-product");

            {# Target visible slider item if necessary #}
            
            if($quickshop_parent.hasClass("js-item-slide")){
                var $quickshop_variant_selector = '.js-swiper-slide-visible.js-product-item-private[data-quickshop-id="'+quick_id+'"]';
            }else{
                var $quickshop_variant_selector = '.js-product-item-private[data-quickshop-id="'+quick_id+'"]';
            }

            LS.changeVariant(changeVariant, $quickshop_variant_selector);

            {% if settings.product_color_variants or settings.bullet_variants or settings.image_color_variants %}
                {# Match selected color variant with selected quickshop variant #}

                var selected_option_id = jQueryNuvem(this).val();
                var $color_parent_to_update = jQueryNuvem('.js-product-item-private[data-quickshop-id="'+quick_id+'"]');

                {# Update all color buttons on several places (quickshop, item, product detail) #}
                $color_parent_to_update.find('.js-color-variant[data-option="'+selected_option_id+'"]').addClass("selected").siblings().removeClass("selected");
                {# Update this specific variant button #}
                $variants_group.find('.js-insta-variant[data-option="'+selected_option_id+'"]').addClass("selected").siblings().removeClass("selected");
            {% endif %}

        } else {
            LS.changeVariant(changeVariant, '#single-product');
        }

        {# Offer and discount labels update #}

        var $this_product_container = jQueryNuvem(this).closest(".js-product-container");

        if($this_product_container.hasClass("js-product-item-private")){
            var this_quickshop_id = $this_product_container.attr("data-quickshop-id");
            var $this_product_container = jQueryNuvem('.js-product-item-private[data-quickshop-id="'+this_quickshop_id+'"]');
        }
        var $this_compare_price = $this_product_container.find(".js-compare-price-display");
        var $this_price = $this_product_container.find(".js-price-display");
        var $installment_container = $this_product_container.find(".js-product-payments-container");
        var $installment_text = $this_product_container.find(".js-max-installments-container");
        var $this_add_to_cart = $this_product_container.find(".js-prod-submit-form");

        // Get the current product discount percentage value
        var current_percentage_value = $this_product_container.find(".js-offer-percentage");

        // Get the current product price and promotional price
        var compare_price_value = $this_compare_price.html();
        var price_value = $this_price.html();

        // Calculate new discount percentage based on difference between filtered old and new prices
        const percentageDifference = window.moneyDifferenceCalculator.percentageDifferenceFromString(compare_price_value, price_value);
        if(percentageDifference){
            $this_product_container.find(".js-offer-percentage").text(percentageDifference);
            $this_product_container.find(".js-offer-label").css("display" , "table");
        }

        if ($this_compare_price.css("display") == "none" || !percentageDifference) {
            $this_product_container.find(".js-offer-label").hide();
        }
        if ($this_add_to_cart.hasClass("nostock")) {
            var $stockLabel = $this_product_container.find(".js-stock-label-private");
            if (!$stockLabel.text().trim()) {
                $stockLabel.text($stockLabel.data('label'));
            }
            $stockLabel.show();
            $this_product_container.find(".js-offer-label").hide();
        }
        else {
            $this_product_container.find(".js-stock-label-private").hide();
        }
        if ($this_price.css('display') == 'none'){
            $installment_container.hide();
            $installment_text.hide();
        }else{
            $installment_text.show();
        }
    });

    {# /* // Submit to contact */ #}

    {# Submit to contact form when product has no price #}

    jQueryNuvem(".js-product-form").on("submit", function (e) {
        var button = jQueryNuvem(e.currentTarget).find('[type="submit"]');
        button.attr('disabled', 'disabled');
        if ((button.hasClass('contact')) || (button.hasClass('catalog'))) {
            e.preventDefault();
            var product_id = jQueryNuvem(e.currentTarget).find("input[name='add_to_cart']").val();
            window.location = "{{ store.contact_url | escape('js') }}?product=" + product_id;
        } else if (button.hasClass('cart')) {
            button.val('{{ "Agregando..." | translate }}');
        }
    });

    {% set home_product_main = template == 'home' and sections.featured.products %}

    {% set native_videos_enabled = false %}
    {% if template == 'product' and product.hasNativeVideos %}
        {% set native_videos_enabled = true %}
    {% endif %}
    {% if home_product_main %}
        {% for product in sections.featured.products %}
            {% if product.hasNativeVideos %}
                {% set native_videos_enabled = true %}
            {% endif %}
        {% endfor %}
    {% endif %}

    {% if template == 'product' or home_product_main %}

        {% if native_videos_enabled %}
            var stream_videos = [];
            function initAllVideos(){
                jQueryNuvem(".js-external-video-iframe").each(function($el){
                    const player = Stream(document.getElementById($el.id));
                    stream_videos.push(player);
                });
            }
            initAllVideos();
            function pauseAllVideos(){
                stream_videos.forEach(function(player){
                    player.pause();
                });
            }
            jQueryNuvem(".js-play-native-button").on("click", function($el){
                pauseAllVideos();
                const link = jQueryNuvem(this);
                const id = jQueryNuvem(this).data("video_uid");
                const iframe = jQueryNuvem("#video-" + id);
                const image = jQueryNuvem("img[data-video_uid='" + id + "']");
                const parent = jQueryNuvem(this).parent(".embed-responsive-16by9");
                const container = jQueryNuvem("div[data-video_uid='" + id + "']");
                iframe.attr("src", iframe.data("src"));
                container.show();
                image.hide();
                link.hide().removeClass("d-md-block");
                parent.removeClass("embed-responsive-16by9");
                let allowAttr = iframe.attr("allow");

                if (allowAttr) {
                    allowAttr = allowAttr
                        .split(";")
                        .map(item => item.trim())
                        .filter(item => item && item !== "autoplay")
                        .join("; ");

                    iframe.attr("allow", allowAttr + ";");
                }
            });
        {% endif %}

        var has_multiple_slides = false;

        {% if template == 'product' and (product.media_count > 1 or video_url) %}
            var has_multiple_slides = true;
        {% else %}
            var product_images_amount = jQueryNuvem(".js-swiper-product").attr("data-product-images-amount");
            if(product_images_amount > 1) {
                var has_multiple_slides = true;
            }
        {% endif %}

        {# /* // Product slider */ #}

        {% if template == 'product' %}

            {% block product_fancybox %}
                Fancybox.bind('[data-fancybox="product-gallery"]', {
                    Toolbar: {
                        items: {
                            close: {
                                html: '<svg class="icon-inline icon-lg svg-icon-text"><use xlink:href="#times"/></svg>',
                            },
                            counter: {
                                class: 'pt-2 mt-1',
                                type: 'div',
                                html: '<span data-fancybox-index=""></span>&nbsp;/&nbsp;<span data-fancybox-count=""></span>',
                                position: 'center',
                            },
                        },
                    },
                    Carousel: {
                        Navigation: {
                            classNames: {
                                button: 'btn',
                                next: 'swiper-button-next',
                                prev: 'swiper-button-prev',
                            },
                            prevTpl: '<svg class="icon-inline icon-2x svg-icon-invert icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>',
                            nextTpl: '<svg class="icon-inline icon-2x svg-icon-invert"><use xlink:href="#arrow-long"/></svg>',
                        },
                    },
                    Thumbs: { autoStart: false },
                    on: {
                        shouldClose: (fancybox, slide) => {
                            {# Update position of the slider #}
                            productSwiper.slideTo( fancybox.getSlide().index, 0 );
                            jQueryNuvem(".js-product-thumb").removeClass("selected");
                            var $product_thumbnail = jQueryNuvem(".js-product-thumb[data-thumb-loop='"+fancybox.getSlide().index+"']").addClass("selected");
                            if($product_thumbnail.length){
                                $product_thumbnail.addClass("selected");
                            }else{
                                jQueryNuvem(".js-product-thumb[data-thumb-loop='4']").addClass("selected");
                            }
                        },
                        {% if native_videos_enabled %}
                            "Carousel.change": (fancybox) => {
                                pauseAllVideos();
                            },
                        {% endif %}
                    },
                });
            {% endblock %}
        {% endif %}

        function productSliderNav(){

            var width = window.innerWidth;

            var productSwiper = null;
            createSwiper(
                '.js-swiper-product', {
                    lazy: true,
                    slidesPerView: 1,
                    threshold: 5,
                    centerInsufficientSlides: true,
                    watchOverflow: true,
                    pagination: {
                        el: '.js-swiper-product-pagination',
                        type: 'fraction',
                    },
                    on: {
                        init: function () {
                            jQueryNuvem(".js-product-slider-placeholder").hide();
                            jQueryNuvem(".js-swiper-product").css("visibility", "visible").css("height", "auto");
                            {% if product.video_url and template == 'product' %}
                                if (window.innerWidth < 768) {
                                    productSwiperHeight = jQueryNuvem(".js-swiper-product").height();
                                    jQueryNuvem(".js-product-video-slide").height(productSwiperHeight);
                                }
                            {% endif %}
                        },
                        {% if product.video_url and template == 'product' %}
                            slideChangeTransitionEnd: function () {
                                jQueryNuvem('.js-video').show();
                                jQueryNuvem('.js-video-iframe').hide().find("iframe").remove();
                            },
                        {% endif %}
                        {% if native_videos_enabled %}
                            slideChange : function () {
                                pauseAllVideos();
                            },
                        {% endif %}
                    },
                },
                function(swiperInstance) {
                    productSwiper = swiperInstance;
                }
            );

            {% if template == 'product' %}
                {{ block ('product_fancybox') }}
            {% endif %}

            if(has_multiple_slides){
                LS.registerOnChangeVariant(function(variant){
                    var liImage = jQueryNuvem('.js-swiper-product').find("[data-image='"+variant.image+"']");
                    var selectedPosition = liImage.data('imagePosition');
                    var slideToGo = parseInt(selectedPosition);
                    productSwiper.slideTo(slideToGo);
                    jQueryNuvem(".js-product-slide-img").removeClass("js-active-variant");
                    liImage.find(".js-product-slide-img").addClass("js-active-variant");
                });

                jQueryNuvem(".js-product-thumb").on("click", function(e){
                    e.preventDefault();
                    jQueryNuvem(".js-product-thumb").removeClass("selected");
                    jQueryNuvem(e.currentTarget).addClass("selected");
                    var thumbLoop = jQueryNuvem(e.currentTarget).data("thumbLoop");
                    var slideToGo = parseInt(thumbLoop);
                    productSwiper.slideTo(slideToGo);
                    if(jQueryNuvem(e.currentTarget).hasClass("js-product-thumb-modal")){
                        var video_id = jQueryNuvem(e.currentTarget).data("video_id");
                        if(video_id){
                            jQueryNuvem('#trigger-video-modal-' + video_id).trigger('click');
                            return;
                        }
                        jQueryNuvem('.js-swiper-product').find("[data-image-position='"+slideToGo+"'] .js-product-slide-link").trigger('click');
                    }
                });

            }
        }

        if (window.innerWidth > 767) {
            var directionVal = 'vertical';
        }else{
            var directionVal = 'horizontal';
        }

        createSwiper('.js-swiper-product-thumbs', {
            lazy: true,
            watchOverflow: true,
            threshold: 5,
            direction: directionVal,
            observer: true,
            navigation: {
                nextEl: '.js-swiper-product-thumbs-next',
                prevEl: '.js-swiper-product-thumbs-prev',
            },
            slidesPerView: 'auto',
            spaceBetween: 16,
            on: {
                afterInit: function () {
                    hideSwiperControls(".js-swiper-product-thumbs-prev", ".js-swiper-product-thumbs-next");
                },
            },
        });

        productSliderNav()

        {# /* // Pinterest sharing */ #}

        jQueryNuvem('.js-pinterest-share').on("click", function(e){
            e.preventDefault();
            window.open(jQueryNuvem(".js-pinterest-hidden a").attr("href"), "_blank");
        });

    {% endif %}

    {# /* // Product quantity */ #}

    jQueryNuvem(document).on("click", ".js-quantity .js-quantity-up", function (e) {
        $quantity_input = jQueryNuvem(this).closest(".js-quantity").find(".js-quantity-input");
        $quantity_input.val( parseInt($quantity_input.val(), 10) + 1);
    });

    jQueryNuvem(document).on("click", ".js-quantity .js-quantity-down", function (e) {
        $quantity_input = jQueryNuvem(this).closest(".js-quantity").find(".js-quantity-input");
        quantity_input_val = $quantity_input.val();
        if (quantity_input_val>1) {
            $quantity_input.val( parseInt($quantity_input.val(), 10) - 1);
        }
    });


    {# /* // Add to cart */ #}

    function getQuickShopImgSrc(element){
        const image = jQueryNuvem(element).closest('.js-product-item-private').find('img');
        return String(image.attr('srcset'));
    }

    jQueryNuvem(document).on("click", ".js-addtocart:not(.js-addtocart-placeholder)", function (e) {

        {# Button variables for transitions on add to cart #}

        const $productContainer = jQueryNuvem(this).closest('.js-product-container');
        const $productVariants = $productContainer.find(".js-variation-option");
        const $productButton = $productContainer.find("input[type='submit'].js-addtocart");
        const productButtonWidth = $productButton.first(el => el.offsetWidth);
        const productButtonHeight = $productButton.first(el => el.offsetHeight);

        {# Define if event comes from quickshop, product page or cross selling #}

        const isQuickShop = $productContainer.hasClass('js-product-item-private');
        var isCrossSelling = $productContainer.hasClass('js-cross-selling-container');
        const $productButtonContainer = $productButton.closest(".js-item-submit-container");
        const $productButtonPlaceholder = $productContainer.find(".js-addtocart-placeholder");
        const $productButtonText = $productButtonPlaceholder.find(".js-addtocart-text");
        const $productButtonAdding = $productButtonPlaceholder.find(".js-addtocart-adding");
        const $productButtonSuccess = $productButtonPlaceholder.find(".js-addtocart-success");

        {# Added item information for notification #}

        let imageSrc;
        const $activeVariantImg = $productContainer.find('.js-product-slide-img.js-active-variant');
        const $defaultImg = $productContainer.find('.js-product-slide-img');

        if($activeVariantImg.length) {
            imageSrc = $activeVariantImg.attr('srcset') || $activeVariantImg.data('srcset');
        } else {
            imageSrc = $defaultImg.attr('srcset') || $defaultImg.data('srcset');
        }

        imageSrc = imageSrc ? imageSrc.split(' ')[0] : '';

        let quantity = $productContainer.find('.js-quantity-input').val();
        let name = $productContainer.find('.js-product-name').text();
        let price = $productContainer.find('.js-price-display').text();
        let addedToCartCopy = "{{ 'Agregar al carrito' | translate }}";

        if (isCrossSelling) {
            imageSrc = $productContainer.find('.js-cross-selling-product-image').attr('src');
            quantity = $productContainer.data('quantity')
            name = $productContainer.find('.js-cross-selling-product-name').text();
            price = $productContainer.find('.js-cross-selling-promo-price').text();
            addedToCartCopy = $productContainer.data('add-to-cart-translation');
        } else if (isQuickShop) {
            imageSrc = getQuickShopImgSrc(this);
            quantity = 1;
            name = $productContainer.find('.js-item-name').text();
            price = $productContainer.find('.js-price-display').text().trim();
            addedToCartCopy = "{{ 'Comprar' | translate }}";
            if ($productContainer.hasClass("js-quickshop-has-variants")) {
                addedToCartCopy = "{{ 'Agregar al carrito' | translate }}";
            }else{
                addedToCartCopy = "{{ 'Comprar' | translate }}";
            }
        }

        if (!jQueryNuvem(this).hasClass('contact')) {

            {% if settings.ajax_cart %}
                e.preventDefault();
            {% endif %}

            {# Hide real button and show button placeholder during event #}

            $productButton.hide();
            if (isQuickShop) {
                $productButtonContainer.hide();
            }

            $productButtonPlaceholder.width(productButtonWidth+20).height(productButtonHeight).css('display' , 'block');
            $productButtonText.fadeOut();
            $productButtonAdding.addClass("active");

            {# Restore button state in case of error #}

            function restore_button_initial_state(){
                $productButtonAdding.removeClass("active");
                $productButtonText.fadeIn();
                $productButtonPlaceholder.removeAttr("style").hide();
                $productButton.show();
                if (isQuickShop) {
                    $productButtonContainer.show();
                }
            }

            {# Restore button state for subscriptions stock error #}

            var subscription_callback_error = function() {
                setTimeout(function() {
                    restore_button_initial_state();
                }, 500);
            };

            {# Handle subscribable product submit #}

            const subscriptionValidResult = LS.subscriptionSubmit($productContainer, subscription_callback_error, e);
            if (subscriptionValidResult && subscriptionValidResult.changeCartSubmit) {
                return;
            }

            {% if settings.ajax_cart %}

                var callback_add_to_cart = function(html_notification_related_products, html_notification_cross_selling) {

                    {# Fill notification info #}

                    jQueryNuvem('.js-cart-notification-item-image-private').attr('srcset', imageSrc);
                    jQueryNuvem('.js-cart-notification-item-name-private').text(name);
                    jQueryNuvem('.js-cart-notification-item-quantity-private').text(quantity);
                    jQueryNuvem('.js-cart-notification-item-price-private').text(price);

                    if($productVariants.length){
                        const output = [];

                        $productVariants.each( function(el){
                            const variants = jQueryNuvem(el);
                            output.push(variants.val());
                        });
                        jQueryNuvem(".js-cart-notification-item-variant-container-private").show();
                        jQueryNuvem(".js-cart-notification-item-variant-private").text(output.join(', '))
                    }else{
                        jQueryNuvem(".js-cart-notification-item-variant-container-private").hide();
                    }

                    {# Set products amount wording visibility #}

                    var cartItemsBadge = jQueryNuvem(".js-cart-widget-amount");
                    var cartItemsMoney = jQueryNuvem(".js-cart-widget-total");
                    var cartItemsAmount = cartItemsBadge.text();
                    
                    if (window.innerWidth > 768) {
                        cartItemsMoney.removeClass("d-none d-md-inline-block");
                    }

                    if(cartItemsAmount > 1){
                        jQueryNuvem(".js-cart-counts-plural-private").show();
                        jQueryNuvem(".js-cart-counts-singular-private").hide();
                    }else{
                        jQueryNuvem(".js-cart-counts-singular-private").show();
                        jQueryNuvem(".js-cart-counts-plural-private").hide();
                    }

                    let notificationWithRelatedProducts = false;

                    {% if settings.add_to_cart_recommendations %}

                        {# Show added to cart product related products #}

                        function recommendProductsOnAddToCart(){

                            jQueryNuvem('.js-related-products-notification-container').html("");

                            modalHandler.modalOpen("#related-products-notification");

                            jQueryNuvem('.js-related-products-notification-container').html(html_notification_related_products).show();

                            {# Recommendations swiper #}

                            // Set loop for recommended products

                            function calculateRelatedNotificationLoopVal(sectionSelector) {
                                let productsAmount = jQueryNuvem(sectionSelector).attr("data-related-amount");
                                let loopVal = false;
                                const applyLoop = (window.innerWidth < 768 && productsAmount > 3) || (window.innerWidth > 768 && productsAmount > 4);
                                
                                if (applyLoop) {
                                    loopVal = true;
                                }
                                
                                return loopVal;
                            }

                            let cartRelatedLoopVal = calculateRelatedNotificationLoopVal(".js-related-products-notification");

                            // Create new swiper on add to cart

                            setTimeout(function(){
                                createSwiper('.js-swiper-related-products-notification', {
                                    lazy: true,
                                    loop: cartRelatedLoopVal,
                                    watchOverflow: true,
                                    threshold: 5,
                                    watchSlideProgress: true,
                                    watchSlidesVisibility: true,
                                    spaceBetween: itemSwiperSpaceBetween,
                                    slideVisibleClass: 'js-swiper-slide-visible',
                                    slidesPerView: 3,
                                    slidesPerGroup: 3,
                                    navigation: {
                                        nextEl: '.js-swiper-related-products-notification-next',
                                        prevEl: '.js-swiper-related-products-notification-prev',
                                    },
                                    pagination: {
                                        el: '.js-swiper-related-notification-pagination',
                                        clickable: true,
                                    },
                                    on: {
                                        afterInit: function () {
                                            hideSwiperControls(".js-swiper-related-products-notification-prev", ".js-swiper-related-products-notification-next");
                                        },
                                    },
                                    breakpoints: {
                                        768: {
                                            slidesPerView: 4,
                                            slidesPerGroup: 4,
                                        }
                                    }
                                });  
                            },200);                          
                        }
                        
                        notificationWithRelatedProducts = html_notification_related_products != null;

                        if(notificationWithRelatedProducts){
                            if (isQuickShop) {
                                setTimeout(function(){
                                    recommendProductsOnAddToCart();
                                },300);
                            }else{
                                recommendProductsOnAddToCart();
                            }
                        }

                    {% endif %}

                    let shouldShowCrossSellingModal = html_notification_cross_selling != null;

                    if(!notificationWithRelatedProducts){

                        const cartOpenType = jQueryNuvem("#modal-cart").attr('data-cart-open-type');

                        if((cartOpenType === 'show_cart') && !shouldShowCrossSellingModal){

                            {# Open cart on add to cart #}

                            modalHandler.modalOpen('#modal-cart');

                        }else{

                            {# Show added to cart notification #}

                            setTimeout(function(){
                                jQueryNuvem(".js-alert-add-to-cart-private").show().addClass("notification-visible").removeClass("notification-hidden");
                            },500);

                            if (!cookieService.get('first_product_added_successfully')) {
                                cookieService.set('first_product_added_successfully', 1, 7 );
                            } else{
                                setTimeout(function(){
                                    jQueryNuvem(".js-alert-add-to-cart-private").removeClass("notification-visible").addClass("notification-hidden");
                                    setTimeout(function(){
                                        jQueryNuvem('.js-cart-notification-item-image-private').attr('src', '');
                                        jQueryNuvem(".js-alert-add-to-cart-private").hide();
                                    },2000);
                                },8000);
                            }
                        }
                    }

                    {# Display cross-selling promotion modal #}

                    if (html_notification_cross_selling != null) {
                        jQueryNuvem('.js-cross-selling-modal-body').html("");
                        modalHandler.modalOpen('#js-cross-selling-modal');
                        jQueryNuvem('.js-cross-selling-modal-body').html(html_notification_cross_selling).show();
                    }

                    {# Change prices on cross-selling promotion modal #}

                    const crossSellingContainer = document.querySelector('.js-cross-selling-container');

                    if (crossSellingContainer) {
                        LS.fillCrossSelling(crossSellingContainer);
                    }

                    {# Show button placeholder with transitions #}

                    $productButtonAdding.removeClass("active");
                    $productButtonSuccess.addClass("active");
                    setTimeout(function(){
                        $productButtonSuccess.removeClass("active");
                        $productButtonText.fadeIn();
                    },2000);
                    setTimeout(function(){
                        $productButtonPlaceholder.removeAttr("style").hide();
                        $productButton.show();
                        if (isQuickShop) {
                            $productButtonContainer.show();
                        }
                    },3000);

                    $productContainer.find(".js-added-to-cart-product-message").slideDown();

                    if (isQuickShop) {
                        jQueryNuvem("#quickshop-modal").removeClass('modal-visible');
                        jQueryNuvem(".js-modal-overlay-private[data-target='#quickshop-modal']").hide();
                        jQueryNuvem("body").removeClass("modal-open");
                        restoreQuickshopForm();
                    }

                    {# Automatically close the cross-selling modal by triggering its close button #}

                    if (isCrossSelling) {
                        jQueryNuvem('#js-cross-selling-modal .js-modal-close-private').trigger('click');
                    }
                }
                var callback_error = function(){
                    {# Restore real button visibility in case of error #}
                    restore_button_initial_state();
                }
                $prod_form = jQueryNuvem(this).closest("form");
                LS.addToCartEnhanced(
                    $prod_form,
                    addedToCartCopy,
                    '{{ "Agregando..." | translate }}',
                    '{{ "No hay más stock de este producto." | translate }}',
                    {{ store.editable_ajax_cart_enabled ? 'true' : 'false' }},
                        callback_add_to_cart,
                        callback_error
                );
            {% endif %}
        }
    });

    {# /* Open cart after add to cart recommendations dismiss */ #}

    jQueryNuvem(".js-open-cart-modal").on("click", function (e) {
        modalHandler.modalOpen("#modal-cart");
    });
    

    {# /* // Add to cart notification / Follow order notification on non fixed header */ #}

    {% if not settings.head_fix_desktop %}

        if (window.innerWidth > 768) {
            const logoBarHeight = jQueryNuvem(".js-head-row").outerHeight();
            const fixedCartNotificationPosition = adBarsHeight + logoBarHeight - 16; 
            const fixedOrderNotificationPosition = jQueryNuvem(".js-head-main").outerHeight(); 
            const $addedToCartNotification = jQueryNuvem(".js-alert-add-to-cart-private");
            const $topNotification = jQueryNuvem(".js-notification-status-page-private");

            $addedToCartNotification.css("top", fixedCartNotificationPosition.toString() + 'px');
            $topNotification.css("top", fixedOrderNotificationPosition.toString() + 'px');

            !function () {
                window.addEventListener("scroll", function (e) {
                    if (window.pageYOffset == 0) {
                        $addedToCartNotification.css("top" , fixedCartNotificationPosition.toString() + 'px');
                        $topNotification.css("top" , fixedOrderNotificationPosition.toString() + 'px');
                    } else {
                        $addedToCartNotification.css("top" , "24px");
                        $topNotification.css("top" , "0px");
                    }
                });
            }();
        }

    {% endif %}

    {% if template == 'product' %}

        {% set columns_desktop = settings.grid_columns_desktop %}
        {% set columns_mobile = settings.grid_columns_mobile %}
        var slidesPerViewDesktopVal = {% if columns_desktop == 6 %}6{% elseif columns_desktop == 5 %}5{% else %}4{% endif %};
        var slidesPerViewMobileVal = {% if columns_mobile == 1 %}1{% else %}2{% endif %};

        {# /* // Product Related */ #}

        // Set loop for related products products sliders

        function calculateRelatedLoopVal(sectionSelector) {
            let productsAmount = jQueryNuvem(sectionSelector).attr("data-related-amount");
            let loopVal = false;
            const applyLoop = (window.innerWidth < 768 && productsAmount > slidesPerViewMobileVal) || (window.innerWidth > 768 && productsAmount > slidesPerViewDesktopVal);
            
            if (applyLoop) {
                loopVal = true;
            }
            
            return loopVal;
        }

        let alternativeLoopVal = calculateRelatedLoopVal(".js-related-products");
        let complementaryLoopVal = calculateRelatedLoopVal(".js-complementary-products");

        {# Alternative products #}

        createSwiper('.js-swiper-related', {
            lazy: true,
            loop: alternativeLoopVal,
            watchOverflow: true,
            threshold: 5,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            spaceBetween: itemSwiperSpaceBetween,
            slideVisibleClass: 'js-swiper-slide-visible',
            slidesPerView: slidesPerViewMobileVal,
            slidesPerGroup: slidesPerViewMobileVal,
            navigation: {
                nextEl: '.js-swiper-related-next',
                prevEl: '.js-swiper-related-prev',
            },
            pagination: {
                el: '.js-swiper-related-pagination',
                clickable: true,
            },
            on: {
                afterInit: function () {
                    hideSwiperControls(".js-swiper-related-prev", ".js-swiper-related-next");
                },
            },
            breakpoints: {
                768: {
                    slidesPerView: slidesPerViewDesktopVal,
                    slidesPerGroup: slidesPerViewDesktopVal,
                }
            }
        });

        {# Complementary products #}

        createSwiper('.js-swiper-complementary', {
            lazy: true,
            loop: complementaryLoopVal,
            watchOverflow: true,
            threshold: 5,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            spaceBetween: itemSwiperSpaceBetween,
            slideVisibleClass: 'js-swiper-slide-visible',
            slidesPerView: slidesPerViewMobileVal,
            slidesPerGroup: slidesPerViewMobileVal,
            navigation: {
                nextEl: '.js-swiper-complementary-next',
                prevEl: '.js-swiper-complementary-prev',
            },
            pagination: {
                el: '.js-swiper-complementary-pagination',
                clickable: true,
            },
            on: {
                afterInit: function () {
                    hideSwiperControls(".js-swiper-complementary-prev", ".js-swiper-complementary-next");
                },
            },
            breakpoints: {
                768: {
                    slidesPerView: slidesPerViewDesktopVal,
                    slidesPerGroup: slidesPerViewDesktopVal,
                }
            }
        });

    {% endif %}

    {#/*============================================================================
      #Cart
    ==============================================================================*/ #}

    {# /* // Free shipping bar */ #}
    
    {% if cart.free_shipping.min_price_free_shipping.min_price %}

        {# Updates free progress on page load #}

        LS.freeShippingProgress(true);

    {% endif %}

    {# /* // Position of cart page summary */ #}

    if (window.innerWidth > 768) {
        {% if settings.head_fix_desktop %}
            setTimeout(function(){
                const cart_summary_offset = jQueryNuvem(".js-head-main").outerHeight();
                jQueryNuvem("#cart-sticky-summary").css("top" , (cart_summary_offset + 16).toString() + 'px');
            },200);
        {% else %}
            jQueryNuvem("#cart-sticky-summary").css("top" , "16px");
        {% endif %}
    }

    {# /* // Cart quantitiy changes */ #}

    jQueryNuvem(document).on("keypress", ".js-cart-quantity-input", function (e) {
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
            return false;
        }
    });

    jQueryNuvem(document).on("focusout", ".js-cart-quantity-input", function (e) {
        var itemID = jQueryNuvem(this).attr("data-item-id");
        var itemVAL = jQueryNuvem(this).val();
        if (itemVAL == 0) {
            var r = confirm("{{ '¿Seguro que quieres borrar este artículo?' | translate }}");
            if (r == true) {
                LS.removeItem(itemID, true);
            } else {
                jQueryNuvem(this).val(1);
            }
        } else {
            LS.changeQuantity(itemID, itemVAL, true);
        }
    });

    {# /* // Go to checkout */ #}

    {# Clear cart notification cookie after consumers continues to checkout #}

    jQueryNuvem('form[action="{{ store.cart_url | escape('js') }}"]').on("submit", function() {
        cookieService.remove('first_product_added_successfully');
    });

    {#/*============================================================================
      #Shipping calculator
    ==============================================================================*/ #}

    {# /* // Update calculated cost wording */ #}
    
    {% if settings.shipping_calculator_cart_page %}
        if (jQueryNuvem('.js-selected-shipping-method').length) {
            const shipping_cost = jQueryNuvem('.js-selected-shipping-method').data("cost");
            const $shippingCost = jQueryNuvem("#shipping-cost");
            $shippingCost.text(shipping_cost);
            $shippingCost.removeClass('opacity-40');
        }
    {% endif %}

    {# /* // Select and save shipping function */ #}

    selectShippingOption = function(elem, save_option) {
        jQueryNuvem(".js-shipping-method, .js-branch-method").removeClass('js-selected-shipping-method');
        jQueryNuvem(elem).addClass('js-selected-shipping-method');

        {% if settings.shipping_calculator_cart_page %}

            jQueryNuvem(".js-shipping-radio").removeClass("selected");
            jQueryNuvem(elem).closest(".js-shipping-radio").addClass("selected");

            let shipping_cost = jQueryNuvem(elem).data("cost");
            let shipping_price_clean = jQueryNuvem(elem).data("price");

            if(shipping_price_clean = 0.00){
                shipping_cost = '{{ Gratis | translate }}'
            }

            // Updates shipping (ship and pickup) cost on cart
            const $shippingCost = jQueryNuvem("#shipping-cost");
            $shippingCost.text(shipping_cost);
            $shippingCost.removeClass('opacity-40');
        
        {% endif %}

        if (save_option) {
            LS.saveCalculatedShipping(true);
        }
        if (jQueryNuvem(elem).hasClass("js-shipping-method-hidden")) {
            {# Toggle other options visibility depending if they are pickup or delivery for cart and product at the same time #}
            if (jQueryNuvem(elem).hasClass("js-pickup-option")) {
                jQueryNuvem(".js-other-pickup-options, .js-show-other-pickup-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-more").hide();
            } else {
                jQueryNuvem(".js-other-shipping-options, .js-show-more-shipping-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-more").hide()
            }
        }
    };

    {# Apply zipcode saved by cookie if there is no zipcode saved on cart from backend #}

    if (cookieService.get('calculator_zipcode')) {

        {# If there is a cookie saved based on previous calcualtion, add it to the shipping input to triggert automatic calculation #}

        const zipcode_from_cookie = cookieService.get('calculator_zipcode');

        {% if settings.ajax_cart %}

            {# If ajax cart is active, target only product input to avoid extra calulation on empty cart #}

            jQueryNuvem('#product-shipping-container .js-shipping-input').val(zipcode_from_cookie);

        {% else %}

            {# If ajax cart is inactive, target the only input present on screen #}

            jQueryNuvem('.js-shipping-input').val(zipcode_from_cookie);

        {% endif %}

        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_from_cookie);

        {# Hide the shipping calculator and show spinner  #}

        jQueryNuvem(".js-shipping-calculator-head").addClass("with-zip").removeClass("with-form");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").addClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-spinner").show();
    } else {

        {# If there is no cookie saved, show calcualtor #}

        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    }


    {# /* // Calculate shipping function */ #}


    jQueryNuvem(".js-calculate-shipping").on("click", function (e) {
        e.preventDefault();

        {# Take the Zip code to all shipping calculators on screen #}
        let shipping_input_val = jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-shipping-input").val();

        jQueryNuvem(".js-shipping-input").val(shipping_input_val);

        {# Calculate on page load for both calculators: Product and Cart #}

        if (jQueryNuvem(".js-cart-item").length) {
            LS.calculateShippingAjax(
            jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
            '{{store.shipping_calculator_url | escape('js')}}',
            jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
        }

        jQueryNuvem(".js-shipping-calculator-current-zip").html(shipping_input_val);
    });

    {# /* // Calculate shipping by submit */ #}

    jQueryNuvem(".js-shipping-input").on('keydown', function (e) {
        const key = e.which ? e.which : e.keyCode;
        const enterKey = 13;
        if (key === enterKey) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-calculate-shipping").trigger('click');
            if (window.innerWidth < 768) {
                jQueryNuvem(e.currentTarget).trigger('blur');
            }
        }
    });

    {# /* // Shipping and branch click */ #}

    jQueryNuvem(document).on("change", ".js-shipping-method, .js-branch-method", function (e) {
        selectShippingOption(this, true);
        jQueryNuvem(".js-shipping-method-unavailable").hide();
    });

    {# /* // Select shipping first option on results */ #}

    jQueryNuvem(document).on('shipping.options.checked', '.js-shipping-method', function (e) {
        let shippingPrice = jQueryNuvem(this).attr("data-price");
        LS.addToTotal(shippingPrice);

        let total = (LS.data.cart.total / 100) + parseFloat(shippingPrice);
        jQueryNuvem(".js-cart-widget-total").html(LS.formatToCurrency(total));

        selectShippingOption(this, false);
    });

    {# /* // Toggle more shipping options */ #}

    jQueryNuvem(document).on("click", ".js-toggle-more-shipping-options", function(e) {
        e.preventDefault();

        {# Toggle other options depending if they are pickup or delivery for cart and product at the same time #}

        if(jQueryNuvem(this).hasClass("js-show-other-pickup-options")){
            jQueryNuvem(".js-other-pickup-options").slideToggle(600);
            jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-less, .js-show-other-pickup-options .js-shipping-see-more").toggle();
        }else{
            jQueryNuvem(".js-other-shipping-options").slideToggle(600);
            jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-less, .js-show-more-shipping-options .js-shipping-see-more").toggle();
        }
    });

    {# /* // Calculate shipping on page load */ #}

    {# Only shipping input has value, cart has saved shipping and there is no branch selected #}

    calculateCartShippingOnLoad = function() {
        {# Triggers function when a zipcode input is filled #}
        if (jQueryNuvem("#cart-shipping-container .js-shipping-input").val()) {
            // If user already had calculated shipping: recalculate shipping
            setTimeout(function() {
                LS.calculateShippingAjax(
                    jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
                    '{{store.shipping_calculator_url | escape('js')}}',
                    jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
            }, 100);
        }
        {% if store.branches|length > 1 %}
            if (jQueryNuvem(".js-branch-method").hasClass('js-selected-shipping-method')) {
                window.toggleAccordionPrivate("#cart-shipping-container .js-toggle-branches");
            }
        {% endif %}
    };

    {% if cart.has_shippable_products %}
        calculateCartShippingOnLoad();
    {% endif %}

    {# /* // Change CP */ #}

    jQueryNuvem(document).on("click", ".js-shipping-calculator-change-zipcode", function(e) {
        e.preventDefault();
        jQueryNuvem(".js-shipping-calculator-response").fadeOut(100);
        jQueryNuvem(".js-shipping-calculator-head").addClass("with-form").removeClass("with-zip");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").removeClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    });

    {# /* // Shipping provinces */ #}

    {% if provinces_json %}
        jQueryNuvem('select[name="country"]').on("change", function (e) {
            const provinces = {{ provinces_json | default('{}') | raw }};
            LS.swapProvinces(provinces[jQueryNuvem(e.currentTarget).val()]);
        }).trigger('change');
    {% endif %}


    {# /* // Change store country: From invalid zipcode message */ #}

    changeLang = function(element) {
        const selected_country_url = element.find("option").filter((el) => el.selected).attr("data-country-url");
        location.href = selected_country_url;
    };

    jQueryNuvem(document).on("click", ".js-save-shipping-country", function(e) {

        e.preventDefault();

        {# Change shipping country #}

        lang_select_option = jQueryNuvem(this).closest(".js-modal-shipping-country");
        changeLang(lang_select_option);

        jQueryNuvem(this).text('{{ "Aplicando..." | translate }}').addClass("disabled");
    });

    {#/*============================================================================
      #Empty screens
    ==============================================================================*/ #}

    {% set show_help = not has_products %}

    {% if template == 'home' %}

        {# /* // Home */ #}

        {# Home slider #}

        var width = window.innerWidth;
        if (width > 767) {
            var slider_empty_autoplay = {delay: 6000,};
        } else {
            var slider_empty_autoplay = false;
        }

        window.homeEmptySlider = {
            getAutoRotation: function() {
                return slider_empty_autoplay;
            },
        };
        createSwiper('.js-home-empty-slider', {
            {% if not params.preview %}
            lazy: true,
            {% endif %}
            loop: true,
            autoplay: slider_empty_autoplay,
            pagination: {
                el: '.js-swiper-empty-home-pagination',
                clickable: true,
                renderBullet: function (index, className) {
                  return '<span class="' + className + '">' + (index + 1) + '</span>';
                },
            },
            navigation: {
                nextEl: '.js-swiper-empty-home-next',
                prevEl: '.js-swiper-empty-home-prev',
            },
            on: {
                init: function () {
                    jQueryNuvem(".js-home-empty-slider").css("visibility", "visible").css("height", "100%");
                },
            },
        });

        {# Brands slider #}

        createSwiper('.js-swiper-empty-brands', {
            lazy: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            threshold: 5,
            slidesPerView: 3.5,
            spaceBetween: 24,
            navigation: {
                nextEl: '.js-swiper-empty-brands-next',
                prevEl: '.js-swiper-empty-brands-prev',
            },
            on: {
                afterInit: function () {
                    hideSwiperControls(".js-swiper-brands-prev", ".js-swiper-brands-next");
                },
            },
            breakpoints: {
                768: {
                    slidesPerView: 10,
                }
            },
        });

        {# Testimonials slider #}

        createSwiper('.js-swiper-empty-testimonials', {
            lazy: true,
            centerInsufficientSlides: true,
            slidesPerView: 1.15,
            watchOverflow: true,
            threshold: 5,
            spaceBetween: itemSwiperSpaceBetween,
            navigation: {
                nextEl: '.js-swiper-empty-testimonials-next',
                prevEl: '.js-swiper-empty-testimonials-prev',
            },
            pagination: {
                el: '.js-swiper-empty-testimonials-pagination',
                clickable: true,
            },
            breakpoints: {
                768: {
                    slidesPerView: 3,
                    spaceBetween: 48,
                }
            },
        });

        {# Informatives slider #}

        createSwiper('.js-empty-informative-banners', {
            centerInsufficientSlides: true,
            watchOverflow: true,
            threshold: 5,
            spaceBetween: itemSwiperSpaceBetween,
            pagination: {
                el: '.js-empty-informative-banners-pagination',
                clickable: true,
            },
            breakpoints: {
                768: {
                    slidesPerView: 4,
                }
            }
        });

    {% endif %}

    {# /* // 404 & Search without results */ #}

    {% if template == '404' and show_help %}

        {# /* // Product Related */ #}

        createSwiper('.js-swiper-related-empty', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            spaceBetween: itemSwiperSpaceBetween,
            slideVisibleClass: 'js-swiper-slide-visible',
            slidesPerView: 2,
            slidesPerGroup: 2,
            navigation: {
                nextEl: '.js-swiper-related-empty-next',
                prevEl: '.js-swiper-related-empty-prev',
            },
            pagination: {
                el: '.js-swiper-related-empty-pagination',
                clickable: true,
            },
            breakpoints: {
                768: {
                    slidesPerView: 4,
                    slidesPerGroup: 4,
                }
            }
        });

        {# /* 404 handling to show the example product */ #}

        if (/\/product\/example\/?$/.test(window.location.pathname)) {
            document.title = "{{ "Producto de ejemplo" | translate | escape('js') }}";
            jQueryNuvem("#page-error").hide();
            jQueryNuvem("#product-example").show();
        } else {
            jQueryNuvem("#product-example").hide();
        }

    {% endif %}

    {% if template == '404' or (template == 'search' and not products) %}

        {% set featured_columns_desktop = settings.grid_columns_desktop %}
        {% set featured_columns_mobile = settings.grid_columns_mobile %}
        var slidesPerViewFeaturedDesktopVal = {% if featured_columns_desktop == 4 %}4{% elseif featured_columns_desktop == 5 %}5{% else %}6{% endif %};
        var slidesPerViewFeaturedMobileVal = {% if featured_columns_mobile == 1 %}1{% else %}2{% endif %};

        window.swiperLoader('.js-swiper-featured', {
            lazy: lazyValue,
            watchOverflow: watchOverflowVal,
            centerInsufficientSlides: centerInsufficientSlidesVal,
            threshold: 5,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            slideVisibleClass: 'js-swiper-slide-visible',
            spaceBetween: itemSwiperSpaceBetween,
        {% if sections.primary.products | length > 4 %}
            loop: true,
        {% endif %}
            navigation: {
                nextEl: '.js-swiper-featured-next',
                prevEl: '.js-swiper-featured-prev',
            },
            pagination: {
                el: '.js-swiper-featured-pagination',
                clickable: true,
            },
            on: {
                afterInit: function () {
                    hideSwiperControls(".js-swiper-featured-prev", ".js-swiper-featured-next");
                },
            },
            slidesPerView: slidesPerViewFeaturedMobileVal,
            breakpoints: {
                768: {
                    slidesPerView: slidesPerViewFeaturedDesktopVal,
                    slidesPerGroup: slidesPerViewFeaturedDesktopVal,
                }
            },
        });

    {% endif %}
});
