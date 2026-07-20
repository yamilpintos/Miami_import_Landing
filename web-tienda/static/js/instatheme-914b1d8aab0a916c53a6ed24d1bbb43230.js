window.tiendaNubeInstaTheme = (function(jQueryNuvem) {
	return {
		waitFor: function() {
			return [];
		},
		placeholders: function() {
			return [
				{
					placeholder: '.js-home-slider-placeholder',
					content: '.js-home-slider-top',
					contentReady: function() {
						return $(this).find('img').length > 0;
					},
				},
				{
					placeholder: '.js-category-banner-placeholder',
					content: '.js-category-banner-top',
					contentReady: function() {
						return $(this).find('img').length > 0;
					},
				},
				{
					placeholder: '.js-promotional-banner-placeholder',
					content: '.js-promotional-banner-top',
					contentReady: function() {
						return $(this).find('img').length > 0;
					},
				},
				{
					placeholder: '.js-news-banner-placeholder',
					content: '.js-news-banner-top',
					contentReady: function() {
						return $(this).find('img').length > 0;
					},
				},
				{
					placeholder: '.js-module-banner-placeholder',
					content: '.js-module-banner-top',
					contentReady: function() {
						return $(this).find('img').length > 0;
					},
				},
				{
					placeholder: '.js-institutional-placeholder',
					content: '.js-institutional-top',
					contentReady: function() {
						// Show only if there are any titles defined
						return 	$(this).find('.js-institutional-container').text().trim();
					},
				},
				{
					placeholder: '.js-main-categories-placeholder',
					content: '.js-main-categories-top',
					contentReady: function() {
						return $(this).find('img').length > 0;
					},
				},
				{
					placeholder: '.js-home-video-placeholder',
					content: '.js-home-video-top',
					contentReady: function() {
						// Show only if the thumbnail is ready
						return $(this).find('.js-home-video-container').data('thumbnail-ready');
					},
				},
				{
					placeholder: '.js-brands-placeholder',
					content: '.js-brands-top',
					contentReady: function() {
						return $(this).find('img').length > 0;
					},
				},
				{
					placeholder: '.js-testimonials-placeholder',
					content: '.js-testimonials-top',
					contentReady: function() {
						// Show only if there are any titles or image defined
						return 	$(this).find('.js-testimonial-container').text().trim() ||
								$(this).find('.js-testimonial-img').map(function(){
									return $(this).attr("src");
								}).get().join('').trim();
						},
				},
				{
					placeholder: '.js-informative-banners-placeholder',
					content: '.js-informative-banners-top',
					contentReady: function() {
						// Show only if there are any text or image defined
						return 	$(this).find('.js-informative-banner-title').text().trim() || 
								$(this).find('.js-informative-banner-description').text().trim() || 
								$(this).find('.js-informative-banner-img').map(function(){
									return $(this).attr("src");
								}).get().join('').trim();
						},
				},
				{
					placeholder: '.js-timer-offers-placeholder',
					content: '.js-timer-offers-top',
					contentReady: function() {
						// Show only if there are any text or image defined
						return 	$(this).find('.js-timer-offers-title').text().trim() || 
								$(this).find('.js-timer-offers-text').text().trim() || 
								$(this).find('.js-timer-offers-button').text().trim() || 
								$(this).find('.js-timer-offers-image').map(function(){
									return $(this).attr("src");
								}).get().join('').trim() ||
								$(this).find('.js-timer-offers-image-mobile').map(function(){
									return $(this).attr("src");
								}).get().join('').trim(); 
						},
				},
			];
		},
		handlers: function(instaElements) {
			const handlers = {
				logo: new instaElements.Logo({
					$storeName: jQueryNuvem('#no-logo'),
					$logo: jQueryNuvem('#logo')
				}),
				// ----- Section order -----
				home_order_position: new instaElements.Sections({
					container: '.js-home-sections-container',
					data_store: {
						'slider': 'home-slider',
						'categories': 'home-banner-categories',
						'promotional': 'home-banner-promotional',
						'news_banners': 'home-banner-news',
						'institutional' : 'home-institutional-message',
						'main_categories' : 'home-categories-featured',
						'timer_offers': 'home-timer-offers',
						'video': 'home-video',
						'brands': 'home-brands',
						'testimonials': 'home-testimonials',
						'newsletter': 'home-newsletter',
						'instafeed': 'home-instagram-feed',
						'products': 'home-products-featured',
						'new': 'home-products-new',
						'sale': 'home-products-sale',
						'main_product' : 'home-product-main',
						'informatives': 'banner-services',
						'modules': 'home-image-text-module',
					}
				})
			};

			// ----------------------------------- Adbar -----------------------------------


			['adbar_primary', 'adbar_secondary'].forEach(setting => {

				const adBarName = setting.replace('_', '-');
				const $adBar = $(`.js-${adBarName}`);
				const $adBarContent = $adBar.find('.js-adbar-content');
				const $adBarMessageContainer = $adBar.find('.js-adbar-message-container');
				const $adBarImagesContainer = $adBar.find(".js-adbar-img-container");

				// Toggle adbar visibility
				handlers[`${setting}`] = new instaElements.Lambda(function(adbarVisible){
					const messagesAmount = $adBar.attr("data-messages");
					const adbarAnimated = $adBar.attr("data-animated");
					const hasDesktopImage = $adBar.attr("data-image-desktop");
					const hasMobileImage = $adBar.attr("data-image-mobile");
					const hasImages = hasDesktopImage && hasMobileImage;

					if(adbarVisible){
						$adBar.attr("data-active" , 'true');
						if(messagesAmount >= 1 || hasImages){
							$adBar.removeClass("d-block d-none d-md-block d-md-none");
						}else if (messagesAmount == 0){
							if((hasMobileImage == 'true') && (hasDesktopImage == 'false')){
								$adBar.removeClass("d-none d-md-block").addClass("d-block d-md-none");
							}else if((hasMobileImage == 'false') && (hasDesktopImage == 'true')){
								$adBar.removeClass("d-block d-md-none").addClass("d-none d-md-block");
							}
						}
						$adBar.show();
					}else{
						$adBar.hide().removeClass("d-block d-none d-md-block d-md-none");
						$adBar.attr("data-active" , 'false');
					}
				});

				// Toggle adbar colors
				handlers[`${setting}_colors`] = new instaElements.Lambda(function(adbarColors){
					if(adbarColors){
						$adBar.addClass("adbar-colors");
					}else{
						$adBar.removeClass("adbar-colors");
					}
				});

				if(setting == 'adbar_primary'){

					// Updates section desktop image
					handlers[`${setting}_img_desktop.jpg`] = new instaElements.Image({
						element: '.js-adbar-desktop-img',
						show: function() {
							const messagesAmount = $adBar.attr("data-messages");
							const adbarActive = $adBar.attr("data-active");
							const hasMobileImage = $adBar.attr("data-image-mobile");
							$(this).show();
							$(this).closest(".js-adbar-desktop-image-container").show();
							$adBar.addClass("adbar-with-image").attr("data-image-desktop" , "true");
							$adBarImagesContainer.addClass("adbar-img-container");

							// Update adbar device visibility classes if depending on messages presence
							if(messagesAmount >= 1){
								$adBarImagesContainer.addClass("adbar-with-messages");
								$adBar.removeClass("d-block d-none d-md-block d-md-none p-0");
							}else{
								$adBar.addClass("p-0").removeClass("adbar-with-messages");
								// Update adbar visibility if only images
								if(adbarActive == 'true'){
									$adBar.show();
									$adBarContent.hide();
									if(hasMobileImage == 'true'){
										$adBar.removeClass("d-block d-none d-md-block d-md-none");
									}else{
										$adBar.removeClass("d-block d-md-none").addClass("d-none d-md-block");
									}
								}
							}
						},
						hide: function() {
							const messagesAmount = $adBar.attr("data-messages");
							const adbarActive = $adBar.attr("data-active");
							const hasMobileImage = $adBar.attr("data-image-mobile");
							$(this).hide();
							$(this).closest(".js-adbar-desktop-image-container").hide();
							$adBar.attr("data-image-desktop" , "false");

							if(hasMobileImage == 'false'){
								$adBar.removeClass("adbar-with-image");
								$adBarImagesContainer.removeClass("adbar-img-container adbar-with-messages");
							}

							// Update adbar device visibility classes if depending on messages presence
							if(messagesAmount >= 1){
								$adBar.removeClass("d-block d-none d-md-block d-md-none p-0");
							}else{
								// Update adbar visibility if only images
								$adBar.removeClass("adbar-with-messages");
								if(adbarActive == 'true'){
									if(hasMobileImage == 'true'){
										$adBar.show().removeClass("d-none d-md-block").addClass("d-block d-md-none");
									}else{
										$adBar.hide().removeClass("d-block d-md-block").addClass("d-none d-md-none");
									}
								}
							}
						},
					});

					// Updates section mobile image
					handlers[`${setting}_img_mobile.jpg`] = new instaElements.Image({
						element: `.js-adbar-mobile-img`,
						show: function() {
							const messagesAmount = $adBar.attr("data-messages");
							const adbarActive = $adBar.attr("data-active");
							const hasDesktopImage = $adBar.attr("data-image-desktop");
							$(this).show();
							$(this).closest(".js-adbar-mobile-image-container").show();
							$adBar.addClass("adbar-with-image").attr("data-image-mobile" , "true");
							$adBarImagesContainer.addClass("adbar-img-container");

							if(hasDesktopImage == 'false'){
								$adBar.removeClass("adbar-with-image");
								$adBarImagesContainer.removeClass("adbar-with-messages");
							}

							// Update adbar device visibility classes if depending on messages presence
							if(messagesAmount >= 1){
								$adBarImagesContainer.addClass("adbar-img-container adbar-with-messages");
								$adBar.removeClass("d-block d-none d-md-block d-md-none p-0");
							}else{
								$adBar.addClass("p-0").removeClass("adbar-with-messages");
								// Update adbar visibility if only images
								if(adbarActive == 'true'){
									$adBar.show();
									$adBarContent.hide();
									if(hasDesktopImage == 'true'){
										$adBar.removeClass("d-block d-none d-md-block d-md-none");
									}else{
										$adBar.removeClass("d-none d-md-block").addClass("d-block d-md-none");
									}
								}
							}
						},
						hide: function() {
							const messagesAmount = $adBar.attr("data-messages");
							const adbarActive = $adBar.attr("data-active");
							const hasDesktopImage = $adBar.attr("data-image-desktop");
							$(this).hide();
							$(this).closest(".js-adbar-mobile-image-container").hide();
							$adBar.attr("data-image-mobile" , "false");
							
							if(hasDesktopImage == 'false'){
								$adBar.removeClass("adbar-with-image");
								$adBarImagesContainer.removeClass("adbar-img-container adbar-with-messages");
							}

							// Update adbar device visibility classes if depending on messages presence
							if(messagesAmount >= 1){
								$adBar.removeClass("d-block d-none d-md-block d-md-none p-0");
							}else{
								// Update adbar visibility if only images
								$adBar.removeClass("adbar-with-messages");
								if(adbarActive == 'true'){
									if(hasDesktopImage == 'true'){
										$adBar.show().removeClass("d-block d-md-none").addClass("d-none d-md-block");
									}else{
										$adBar.hide().removeClass("d-block d-md-block").addClass("d-none d-md-none");
									}
								}
							}
						},
					});
				}
			});

			// ----------------------------------- Header -----------------------------------

			// Set desktop nav width to trim or not nav

			setDesktopNavWidth = function(remainingSibling, remainingSiblingWidth) {

				if (window.innerWidth > 768) {

					// Reset wrapping of secondary nav to calculate widths
					$(".js-desktop-secondary-nav-col").css("white-space" , "nowrap");

					// Get width of every component on navigation row

					const mainNavContainerWidth = $('.js-nav-desktop-container').outerWidth();
					const menuNavListWidth = $('.js-nav-desktop-list').outerWidth();
					let mainCategoriesContainerWidth = $('.js-desktop-main-categories-col').is(":visible") ? $('.js-desktop-main-categories-col').outerWidth() : 0;
					let secondaryNavContainerWidth = $('.js-desktop-secondary-nav-col').is(":visible") ? $('.js-desktop-secondary-nav-col').outerWidth() : 0;
					const totalColsWidth = mainCategoriesContainerWidth + secondaryNavContainerWidth;

					// Set main nav fixed width
					const menuColWidth = mainNavContainerWidth - totalColsWidth;

					// Check if main nav has siblings 
					const navHasSiblings = $(".js-desktop-main-categories-col, .js-desktop-secondary-nav-col").is(":visible");

					// Get main nav items width
					let menuItemsWidth = 0;

					$('.js-nav-desktop-list > .js-desktop-nav-item').each(function() {
						menuItemsWidth += $(this).outerWidth();
					});

					if (navHasSiblings) {
						menuItemsWidth = menuItemsWidth;
					}

					// If main items widths summatory make main nav scrollable with arrow controls
					if (menuNavListWidth < menuItemsWidth) {
						$('.js-nav-desktop-list').addClass('nav-desktop-with-scroll');
						$('.js-nav-desktop-list-arrow').css("display", "flex");

						// Set main nav fixed width if there are any siblings components
						if (navHasSiblings) {

							$(".js-desktop-nav-col").width(menuColWidth);

							// Recalculate main nav width when siblings are hidden from instatheme but 1 remains visible
							if(remainingSibling){
								const menuColUpdatedWidth = mainNavContainerWidth - remainingSiblingWidth;
								const remainingSiblingUpdatedWidth = mainNavContainerWidth - menuColUpdatedWidth;
								$(".js-desktop-nav-col").width(menuColUpdatedWidth - 64);
								$(remainingSibling).width(remainingSiblingUpdatedWidth);
							}
						}else{

							// If no siblings remaining, set main nav width according to container
							$(".js-desktop-nav-col").width("100%");
						}
					}else{
						// If main nav width does not require cropping, hide arrows
						$('.js-nav-desktop-list').removeClass('nav-desktop-with-scroll');
						$('.js-nav-desktop-list-arrow').hide();
						$(".js-desktop-nav-col").width("100%");
					}

					// Set main nav to nowrap to prioritize spacing
					$(".js-nav-desktop-list").css("white-space" , "nowrap");
				}
			};

			// Set logo container width to avoid search moving on logo sizes
			setLogoDesktopWidth = function() {
				if (window.innerWidth > 768) {
					setTimeout(function(){
						const $logoContainer = $(".js-logo-container");
						const logoColWidth = $logoContainer.width();
						$logoContainer.css("width" , logoColWidth);
					},500);
				}
			};

			// Update logo size
			handlers.logo_size = new instaElements.Lambda(function(logoSize){
				const $logoImage = $('.js-logo-container').find('img');
				const $logoContainer = $(".js-logo-container");
				
				$logoContainer.removeAttr("style");

				if (logoSize == 'small') {
					$logoImage.removeClass('logo-big').addClass('logo-small');
				} else if (logoSize == 'big') {
					$logoImage.removeClass('logo-small').addClass('logo-big');
				} else {
					$logoImage.removeClass('logo-small logo-big')
				}

				setLogoDesktopWidth();
			});

			const $logoRow = $('.js-head-row');

			// Update logo position mobile
			handlers.logo_position_mobile = new instaElements.Lambda(function(logoMobile){
				if (logoMobile == 'left') {
					$logoRow.removeClass("logo-center").addClass("logo-left");
				} else {
					$logoRow.removeClass("logo-left").addClass("logo-center");
				}
			});

			// Update logo position desktop
			handlers.logo_position_desktop = new instaElements.Lambda(function(logoDesktop){
				const $logoImage = $('.js-logo-container').find('img');
				const $logoContainer = $(".js-logo-container");

				$logoContainer.removeAttr("style");

				if (logoDesktop == 'left') {
					$logoRow.removeClass("logo-md-center").addClass("logo-md-left");
					setLogoDesktopWidth();
				} else {
					$logoRow.removeClass("logo-md-left").addClass("logo-md-center");
				}
			});

			// Update head main colors
			handlers.header_colors = new instaElements.Lambda(function(headerColors){
				
				const $head = $('.js-head-main');

				if (headerColors) {
					$head.addClass("head-colors");
				} else {
					$head.removeClass("head-colors");
				}
			});

			// Update desktop nav colors
			handlers.desktop_nav_colors = new instaElements.Lambda(function(desktopNavColors){
				
				const $desktopNavColors = $('.js-nav-desktop-color-container');

				if (desktopNavColors) {
					$desktopNavColors.addClass("nav-desktop-colors");
				} else {
					$desktopNavColors.removeClass("nav-desktop-colors");
				}
			});

			// Update desktop featured nav link
			handlers.featured_link_url = new instaElements.Lambda(function(featuredLink){
				const featuredLinkUrlInstatheme = featuredLink.split('://').pop().split('/').slice(1).filter(segment => segment !== '').join('/');
				const featuredLinkColor = $('.js-nav-desktop').attr("data-featured-link-color");
				$('.js-nav-list-link').each(function() {
					const linkUrl = $(this).attr("data-url-cleaned");
					if ((featuredLink) && (linkUrl == featuredLinkUrlInstatheme)) {
						$(this).addClass("js-nav-list-link-featured nav-list-link-featured");
						if(featuredLinkColor == 'true'){
							$(this).addClass("nav-list-link-featured-color");
							$('.js-nav-desktop').attr("data-featured-link-color" , "true");
						}
					} else {
						$(this).removeClass("js-nav-list-link-featured nav-list-link-featured nav-list-link-featured-color");
						$('.js-nav-desktop').attr("data-featured-link" , "true");
					}
				});

				if($('.js-nav-list-link-featured').length){
					$('.js-nav-desktop').attr("data-featured-link" , "true").attr("data-featured-link" , "true").attr("data-featured-link-url" , featuredLinkUrlInstatheme);
				}else{
					$('.js-nav-desktop').attr("data-featured-link" , "false").attr("data-featured-link" , "false").attr("data-featured-link-url" , '');
				}
				
				
			});

			// Update desktop featured nav colors
			handlers.featured_link_color = new instaElements.Lambda(function(featuredLinkColor){
				const featuredLinkActive = $('.js-nav-desktop').attr("data-featured-link");
				const $featuredLink = $('.js-nav-list-link-featured');

				if ((featuredLinkColor) && (featuredLinkActive == 'true')) {
					$featuredLink.addClass("nav-list-link-featured-color");
				} else {
					$featuredLink.removeClass("nav-list-link-featured-color");
				}

				if (featuredLinkColor) {
					$('.js-nav-desktop').attr("data-featured-link-color" , "true");
				} else {
					$('.js-nav-desktop').attr("data-featured-link-color" , "false");
				}
			});

			// Update head desktop fixed
			handlers.head_fix_desktop = new instaElements.Lambda(function(headFix){
				const $head = $('.js-head-main');

				if (window.innerWidth > 768) {
					if (headFix) {
						$head.addClass('position-sticky-md').removeClass("position-relative-md");
						$head.attr("data-header-md-fixed", "true");
					} else {
						$head.removeClass('position-sticky-md').addClass("position-relative-md");
						$head.attr("data-header-md-fixed", "false");
					}
				}
			});

			// Update utilities desktop format
			handlers.utilities_type_desktop = new instaElements.Lambda(function(utilitiesTypeDesktop){
				
				const $utilityWithText = $('.js-header-utility-with-text');
				const $utilityIconOnly = $('.js-header-utility-icon-only');
				const $utilityIcon = $('.js-header-utility-icon');
				const $utilityText = $('.js-header-utility-text');
				const $utilityTextCart = $('.js-header-utility-text-cart');
				const $utilityLanguage = $(".js-head-row .js-utility-account-desktop");
				const $mainNavContainer = $('.js-nav-desktop-container');
				const $utilityLanguageSecondaryNavContainer = $(".js-desktop-secondary-nav-col");
				const $utilityLanguageSecondaryNav = $(".js-desktop-secondary-nav-col .js-utility-account-desktop");
				const secondaryNavContainerVisibility = $mainNavContainer.attr("data-desktop-nav-secondary-or-language");
				const secondaryNavVisibility = $mainNavContainer.attr("data-desktop-nav-secondary");
				const mainCategoriesVisibility = $mainNavContainer.attr("data-desktop-main-categories");

				if (utilitiesTypeDesktop == 'icons_text') {
					$utilityIcon.find(".js-cart-widget-amount").addClass("d-md-none");
					$utilityIconOnly.show().addClass("d-flex d-md-none");
					$utilityTextCart.show().addClass("d-md-grid");
					$utilityWithText.show().addClass("d-md-grid");
					$utilityLanguage.hide();
					$utilityLanguageSecondaryNav.show();
					$utilityLanguageSecondaryNavContainer.show();
					$mainNavContainer.addClass("nav-desktop-grid");
					$mainNavContainer.attr("data-desktop-nav-secondary-or-language" , "true");
					if(mainCategoriesVisibility == 'false'){
						$mainNavContainer.addClass("nav-desktop-grid-secondary-nav-only");
					}
					setDesktopNavWidth();
				} else {
					$utilityIconOnly.show().addClass("d-flex").removeClass("d-md-none");
					$utilityIcon.find(".js-cart-widget-amount").removeClass("d-md-none");
					$utilityTextCart.hide().removeClass("d-md-grid");
					$utilityWithText.hide().removeClass("d-md-grid");
					$utilityLanguage.show();
					$utilityLanguageSecondaryNav.hide();
					if(secondaryNavVisibility == 'false'){
						$utilityLanguageSecondaryNavContainer.hide();
						$mainNavContainer.attr("data-desktop-nav-secondary-or-language" , "false");
						$mainNavContainer.removeClass("nav-desktop-grid-secondary-nav-only");
					}else{
						$mainNavContainer.attr("data-desktop-nav-secondary-or-language" , "true");
						if(mainCategoriesVisibility == 'false'){
							$mainNavContainer.addClass("nav-desktop-grid-secondary-nav-only");
						}
					}
					if((secondaryNavVisibility == 'false') && (mainCategoriesVisibility == 'false')){
						$mainNavContainer.removeClass("nav-desktop-grid");
					}
					setDesktopNavWidth();
				}
			});

			// Update utilities desktop icon colors
			handlers.desktop_utility_colors = new instaElements.Lambda(function(utilitiesColorsDesktop){
				
				const $utilityIcon = $('.js-head-row .js-header-utility-icon');

				if (utilitiesColorsDesktop) {
					$utilityIcon.addClass("utility-icon-md-colors");
				} else {
					$utilityIcon.removeClass("utility-icon-md-colors");
				}
			});

			// Update cart utility icon
			handlers.utilities_cart_icon = new instaElements.Lambda(function(utilitiesCartIcon){
				
				const $utilityCartIcon = $('.js-utility-cart-icon');

				if (utilitiesCartIcon == 'bag') {
					$utilityCartIcon.find("use").attr("xlink:href", "#bag");
				} else {
					$utilityCartIcon.find("use").attr("xlink:href", "#cart");
				}
			});

			// Update main nav text style
			handlers.desktop_main_nav_uppercase = new instaElements.Lambda(function(navUppercase){
				
				const $navUppercaseTarget = $('.js-desktop-main-categories-col, .js-desktop-nav-col');

				if (navUppercase) {
					$navUppercaseTarget.addClass("nav-desktop-uppercase");
				} else {
					$navUppercaseTarget.removeClass("nav-desktop-uppercase");
				}
			});

			// Update main categories desktop visibility
			handlers.category_item = new instaElements.Lambda(function(mainCategoriesDesktop){
				const $mainCategoriesContainer = $('.js-desktop-main-categories-col');
				const $mainNavContainer = $('.js-nav-desktop-container');
				const $secondaryNavContainer = $(".js-desktop-secondary-nav-col");
				const secondaryNavVisibility = $mainNavContainer.attr("data-desktop-nav-secondary");
				const secondaryNavContainerVisibility = $mainNavContainer.attr("data-desktop-nav-secondary-or-language");

				if (window.innerWidth > 768) {
					if (mainCategoriesDesktop) {
						$mainNavContainer.addClass("nav-desktop-grid").removeClass("nav-desktop-grid-secondary-nav-only");
						$mainCategoriesContainer.show().css("display" , "inline-flex");
						$secondaryNavContainer.css("white-space" , '');
						setDesktopNavWidth();
						$mainNavContainer.attr("data-desktop-main-categories" , "true");
					} else {
						if(secondaryNavContainerVisibility == 'false'){
							$mainNavContainer.removeClass("nav-desktop-grid");
						}else{
							$mainNavContainer.addClass("nav-desktop-grid nav-desktop-grid-secondary-nav-only");
						}
						const mainCategoriesContainerWidth = $('.js-desktop-main-categories-col').outerWidth();
						const secondaryNavWidth = $(".js-desktop-secondary-nav-col").width();
						$mainCategoriesContainer.hide();
						setDesktopNavWidth(".js-desktop-secondary-nav-col" , secondaryNavWidth);
						$mainNavContainer.attr("data-desktop-main-categories" , "false");
					}
				}
			});

			// Update main categories mobile visibility
			handlers.head_main_categories = new instaElements.Lambda(function(mainCategoriesMobile){
				const $mainCategoriesContainer = $('.js-main-categories-container');
				const $head = $('.js-head-main');

				if (mainCategoriesMobile) {
					$mainCategoriesContainer.show();
					$head.addClass("head-with-mobile-categories");
				} else {
					$mainCategoriesContainer.hide();
					$head.removeClass("head-with-mobile-categories");
				}
			});

			// ----------------------------------- Footer -----------------------------------

			// Update footer colors
			handlers.footer_colors = new instaElements.Lambda(function(footerColors){
				const $footer = $('.js-footer');
				if (footerColors) {
					$footer.addClass("footer-colors");
				} else {
					$footer.removeClass("footer-colors");
				}
			});

			// Updates footer logo
			handlers['footer_logo.jpg'] = new instaElements.Image({
				element: '.js-footer-logo-img',
				show: function() {
					$(this).show();
					$(this).parent().show();
				},
				hide: function() {
					$(this).hide();
					$(this).parent().hide();
				},
			});

			// Updates footer institutional text
			handlers.footer_about_description = new instaElements.Text({
				element: '.js-footer-institutional',
				show: function(){
					$(this).show();
				},
				hide: function(){
					$(this).hide();
				},
			});

			// Updates menu titles
			handlers.footer_menu_title = new instaElements.Text({
				element: '.js-footer-menu-title',
				show: function(){
					$(this).show();
					$(this).closest(".js-footer-menu-title-container").show();
					$(this).closest(".js-accordion-private-toggle-mobile").show();
					if(window.innerWidth < 768){
						$(this).closest(".js-accordion-private-container").find(".js-accordion-private-content-mobile").hide();
					}
				},
				hide: function(){
					$(this).hide();
					$(this).closest(".js-footer-menu-title-container").hide();
					$(this).closest(".js-accordion-private-toggle-mobile").hide();
					$(this).closest(".js-accordion-private-container").find(".js-accordion-private-content-mobile").show();
				},
			});

			handlers.footer_menu_secondary_title = new instaElements.Text({
				element: '.js-footer-menu-secondary-title',
				show: function(){
					$(this).show();
					$(this).closest(".js-footer-menu-title-container").show();
					$(this).closest(".js-accordion-private-toggle-mobile").show();
					if(window.innerWidth < 768){
						$(this).closest(".js-accordion-private-container").find(".js-accordion-private-content-mobile").hide();
					}
				},
				hide: function(){
					$(this).hide();
					$(this).closest(".js-footer-menu-title-container").hide();
					$(this).closest(".js-accordion-private-toggle-mobile").hide();
					$(this).closest(".js-accordion-private-container").find(".js-accordion-private-content-mobile").show();
				},
			});

			// Newsletter menu title and text

			['title', 'description'].forEach(setting => {
				handlers[`news_${setting}`] = new instaElements.Text({
					element: `.js-footer-news-${setting}`,
					show: function(){
						$(this).show();
					},
					hide: function(){
						$(this).hide();
					},
				});
			});

			// ----------------------------------- Slider -----------------------------------

			// Build the html for a slide given the data from the settings editor
			function buildHomeSlideDom(aSlide, index, length, alignClasses) {
				return '<div class="swiper-slide">' +
						(aSlide.link ? '<a href="' + aSlide.link + '">' : '' ) +
							'<img src="' + aSlide.src + '" class="slider-image"/>' +
							(aSlide.description || aSlide.title ? '<div class="swiper-fractions">' + (index + 1) + '/' + length + '</div>' : '' ) +
							'<div class="swiper-text ' + alignClasses + '  text-' + aSlide.color + '">' +
								(aSlide.title ? '<div class="h1 my-2">' + aSlide.title + '</div>' : '' ) +
								(aSlide.description ? '<div class="mt-2 mb-3">' + aSlide.description + '</div>' : '' ) +
								(aSlide.button && aSlide.link ? '<div class="btn btn-primary">' + aSlide.button + '</div>' : '' ) +
							'</div>' +
						(aSlide.link ? '</a>' : '' ) +
					'</div>'
			}

			// Update main slider
			handlers.slider = new instaElements.Lambda(function(slides){
				if (!window.homeSwiper) {
					return;
				}

				// Update align classes
				const sliderAlign = $('.js-home-slider-container').attr('data-align');
				const alignClasses = sliderAlign == 'center' ? 'swiper-text-centered' : '';

				window.homeSwiper.removeAllSlides();
				slides.forEach(function(aSlide, index, array){
					window.homeSwiper.appendSlide(buildHomeSlideDom(aSlide, index, array.length, alignClasses));
				});
			});

			// Update mobile slider
			handlers.slider_mobile = new instaElements.Lambda(function(slides){
				// This slider is not included in the html if `toggle_slider_mobile` is not set.
				// The second condition could be removed if live preview for this checkbox is implemented but changing the viewport size forces a refresh, so it's not really necessary.
				if (!window.homeMobileSwiper || !window.homeMobileSwiper.slides) {
					return;
				}

				// Update align classes
				const sliderAlign = $('.js-home-slider-container').attr('data-align');
				const alignClasses = sliderAlign == 'center' ? 'swiper-text-centered' : '';

				window.homeMobileSwiper.removeAllSlides();
				slides.forEach(function(aSlide, index, array){
					window.homeMobileSwiper.appendSlide(buildHomeSlideDom(aSlide, index, array.length, alignClasses));
				});
			});

			// Update slider text align
			handlers.slider_align = new instaElements.Lambda(function(sliderAlign){
				const $swiperText = $('.js-home-slider-container').find('.swiper-text');
				const $homeSlider = $('.js-home-slider-container');

				if (sliderAlign == 'left') {
					$homeSlider.attr('data-align', 'left');
					$swiperText.removeClass('swiper-text-centered');
				} else {
					$homeSlider.attr('data-align', 'center');
					$swiperText.addClass('swiper-text-centered');
				}
			});

			// Update slider full
			handlers.slider_full = new instaElements.Lambda(function(sliderFull){
				const $swiperContainer = $('.js-home-slider-container');
				const $swiperArrows = $swiperContainer.find('.js-swiper-home-prev, .js-swiper-home-next');

				if (sliderFull) {
					$swiperContainer.removeClass('container').addClass('swiper-arrows-light');
					$swiperArrows.removeClass('swiper-button-outside');

					// Updates slider width to avoids swipes inconsistency
					window.homeSwiper.params.observer = true;
					window.homeSwiper.update();

				} else {
					$swiperContainer.removeClass('swiper-arrows-light').addClass('container');
					$swiperArrows.addClass('swiper-button-outside');

					// Updates slider width to avoids swipes inconsistency
					window.homeSwiper.params.observer = true;
					window.homeSwiper.update();
				}
			});

			// ----------------------------------- Main Banners -----------------------------------

			// Build the html for a slide given the data from the settings editor

			var slideCount = 0;

			function buildHomeBannerDom(aSlide, bannerClasses, textBannerClasses, textClasses, bannerModule) {
				slideCount++;
				var evenClass = slideCount % 2 === 0 ? 'js-banner-even order-md-first ' : '';
				return '<div class="js-banner-item ' + bannerClasses + '">' +
						'<div class="js-textbanner textbanner ' + (bannerModule && !aSlide.link ? ' js-module-grid grid grid-md-2 grid-no-gap align-items-center mb-md-5 overflow-none ' : ' ') + textBannerClasses + '">' +
							(aSlide.link ? '<a href="' + aSlide.link + '"' + 'class="' + (bannerModule && aSlide.link ? ' js-module-grid grid grid-md-2 grid-no-gap align-items-center mb-md-5 overflow-none ' : ' ') + '">' : '' ) +
								'<img src="' + aSlide.src + '" class="textbanner-image transition-soft img-fluid d-block w-100"/>' +
								'<div class="js-textbanner-text textbanner-text ' + (bannerModule ? 'textbanner-text-background textbanner-text-centered-content h-100 p-3 p-md-4 text-center ' + evenClass : ' ') + textClasses + ' text-' + aSlide.color + '">' +
									(aSlide.title ? '<div class="h2 my-2">' + aSlide.title + '</div>' : '' ) +
									(aSlide.description ? '<div class="textbanner-paragraph mt-2">' + aSlide.description + '</div>' : '' ) +
									(aSlide.button && aSlide.link ? '<div class="btn btn-primary mt-3">' + aSlide.button + '</div>' : '' ) +
								'</div>' +
							(aSlide.link ? '</a>' : '' ) +
						'</div>' +
					'</div>'
			}

			// Build swiper JS for Banners

			function initSwiperJS(bannerMainContainer, swiperId, swiperName, isModule){

				const bannerMargin = bannerMainContainer.attr('data-margin');
				const swiperDesktopColumns = isModule ? 1 : bannerMainContainer.attr('data-desktop-columns');

				createSwiper(`.js-swiper-${swiperId}`, {
					watchOverflow: true,
					threshold: 5,
					watchSlideProgress: true,
					watchSlidesVisibility: true,
					slideVisibleClass: 'js-swiper-slide-visible',
					spaceBetween: bannerMargin == 'false' ? 0 : 16,
					navigation: {
						nextEl: `.js-swiper-${swiperId}-next`,
						prevEl: `.js-swiper-${swiperId}-prev`
					},
					slidesPerView: 1.15,
					breakpoints: {
						768: {
							slidesPerView: swiperDesktopColumns,
						}
					}
				},
				function(swiperInstance) {
					window[swiperName] = swiperInstance;
				});
			}

			// Main banners: Banner content and order updates. General layout and format updates (for main and secondary banners)

			['banner', 'banner_promotional', 'banner_news', 'module'].forEach(setting => {

				const bannerName = 
					setting == 'banner' ? 'banner' : 
					setting == 'banner_promotional' ? 'banner-promotional' : 
					setting == 'banner_news' ? 'banner-news' : 
					setting == 'module' ? 'module' :
					null;

				const isModule = setting == 'module';
				const $generalBannersContainer = $(`.js-home-${bannerName}`);

				// Main banner
				const $mainBannersContainer = $generalBannersContainer.find(`.js-${bannerName}`);

				// Mobile banner
				const bannerMobileName = 
					setting == 'banner' ? 'banner-mobile' : 
					setting == 'banner_promotional' ? 'banner-promotional-mobile' : 
					setting == 'banner_news' ? 'banner-news-mobile' :
					null;
				const $mobileBannersContainer = $generalBannersContainer.find(`.js-${bannerMobileName}`);

				const bannerSwiper = 
					setting == 'banner' ? 'homeBannerSwiper' : 
					setting == 'banner_promotional' ? 'homeBannerPromotionalSwiper' : 
					setting == 'banner_news' ? 'homeBannerNewsSwiper' :
					setting == 'module' ? 'homeModuleSwiper' :
					null;

				// Used for specific mobile images swiper updates
				const bannerSwiperMobile = 
					setting == 'banner' ? 'homeBannerMobileSwiper' : 
					setting == 'banner_promotional' ? 'homeBannerPromotionalMobileSwiper' : 
					setting == 'banner_news' ? 'homeBannerNewsMobileSwiper' :
					null;

				const bannerModuleSetting = setting == 'module' ? true : false;
				const $bannerMainItem = $generalBannersContainer.find('.js-banner-item');
				
				const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
				const mobileFormat = $generalBannersContainer.attr('data-mobile-format');

				const desktopColumns = $generalBannersContainer.attr('data-desktop-columns');

				// Update banners content
				handlers[`${setting}`] = new instaElements.Lambda(function(slides){

					// Update text classes
					const textPosition = $generalBannersContainer.attr('data-text');
					const positionClasses = textPosition == 'above' ? 'textbanner-text-above' : 'textbanner-text-background';

					// Update margin classes
					const bannerMargin = $generalBannersContainer.attr('data-margin');
					const marginClasses = bannerMargin == 'false' ? 'm-0' : '';

					// Update align classes
					const bannerAlign = $generalBannersContainer.attr('data-align');
					const alignClasses = bannerAlign == 'center' ? 'text-center textbanner-text-center' : '';

					// Update textbanner classes
					const textBannerClasses = marginClasses;
					const textClasses = positionClasses + ' ' + alignClasses;

					// Update column classes
					const desktopColumnsClasses = $generalBannersContainer.attr('data-grid-classes');
					const columnClasses = desktopColumnsClasses;

					// Insta slider function
					function instaSlider() {
						// Update banner classes
						const bannerClasses = 'swiper-slide';

						if (!window[bannerSwiper]) {
							return;
						}

						// Try using already created swiper JS, if it fails initialize swipers again
						try{
							window[bannerSwiper].removeAllSlides();
							slides.forEach(function(aSlide){
								window[bannerSwiper].appendSlide(buildHomeBannerDom(aSlide, bannerClasses, textBannerClasses, textClasses, bannerModuleSetting));
							});
							window[bannerSwiper].update();
						}catch(e){
							initSwiperJS($generalBannersContainer, bannerName, bannerSwiper, isModule);

							setTimeout(function(){
								slides.forEach(function(aSlide){
									window[bannerSwiper].appendSlide(buildHomeBannerDom(aSlide, bannerClasses, textBannerClasses, textClasses, bannerModuleSetting));
								});	
							},500);
						}
					}

					// Insta grid function
					function instaGrid() {
						// Update banner classes
						const bannerClasses = '';

						$mainBannersContainer.find('.js-banner-item').remove();
						slides.forEach(function(aSlide){
							$mainBannersContainer.find('.js-banner-grid').append(buildHomeBannerDom(aSlide, bannerClasses, textBannerClasses, textClasses, bannerModuleSetting));
						});
					}

					if (isModule) {
						const bannerFormat = $generalBannersContainer.attr('data-format');

						if (bannerFormat == 'slider') {
							instaSlider();
						} else {
							instaGrid();
						}

					} else {
						const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
						const mobileFormat = $generalBannersContainer.attr('data-mobile-format');

						if (desktopFormat == 'slider' || mobileFormat == 'slider') {

							if (desktopFormat == 'slider' && mobileFormat == 'grid') {
								if (window.innerWidth > 768) {
									instaSlider();
								} else {
									instaGrid();
								}
							} else if (mobileFormat == 'slider' && desktopFormat == 'grid') {
								if (window.innerWidth < 768) {
									instaSlider();
								} else {
									instaGrid();
								}
							} else {
								instaSlider();
							}
						} else {
							instaGrid();
						}
					}
				});

				// Initialize swiper elements function
				function initSwiperElements(bannerRow, swiperId, swiperName, isModule) {
					const $bannerContainer = bannerRow.closest('.js-banner-container');
					const $bannerItem = $generalBannersContainer.find('.js-banner-item');

					// Update margin classes
					const bannerMargin = $generalBannersContainer.attr('data-margin');

					if (isModule) {
						const bannerFormat = $generalBannersContainer.attr('data-format');
					}

					const swiperDesktopColumns = $generalBannersContainer.attr('data-desktop-columns');
					const swiperArrowDisplayClasses = mobileFormat == 'slider' && desktopFormat == 'grid' ? 'd-none' : 'd-none d-md-block';
					const swiperArrowPostionClasses = bannerMargin == 'false' ? 'svg-icon-invert' : 'swiper-button-outside svg-icon-text';
					const swiperArrowClasses = swiperArrowDisplayClasses + ' ' + swiperArrowPostionClasses;

					// Row to swiper wrapper
					bannerRow.addClass('swiper-wrapper');

					// Wrap everything inside a swiper container
					bannerRow.wrapAll(`<div class="js-swiper-${swiperId} swiper-container"></div>`);

					// Replace each banner into a slide
					$bannerItem.addClass('swiper-slide');

					// Add previous and next controls
					$bannerContainer.append(`
						<div class="js-swiper-${swiperId}-prev swiper-button-prev ${swiperArrowClasses}">
							<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
						</div>
						<div class="js-swiper-${swiperId}-next swiper-button-next ${swiperArrowClasses}">
							<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
						</div>
					`);

					// Initialize swiper
					initSwiperJS($generalBannersContainer, swiperId, swiperName, isModule);

				}

				// Reset swiper function
				function resetSwiperElements(bannersGroupContainer, bannerRow, swiperId, isModule) {

					const $bannerItem = $generalBannersContainer.find('.js-banner-item');
					const $bannerText = $generalBannersContainer.find('.js-module-grid');
					const $bannerTextEven = $generalBannersContainer.find('.js-banner-even');
					const desktopColumnsClasses = $generalBannersContainer.attr('data-grid-classes');
					const gridClasses = isModule ? '' : 'grid ' + desktopColumnsClasses;

					if (isModule) {
						$bannerText.addClass('mb-md-5');
						$bannerTextEven.addClass('order-md-first');
					}

					// Remove duplicate slides and slider controls
					$mainBannersContainer.find(`.js-swiper-${swiperId}-pagination, .js-swiper-${swiperId}-prev, .js-swiper-${swiperId}-next, .swiper-slide-duplicate`).remove();

					// Swiper wrapper to row
					bannerRow.removeClass('swiper-wrapper').removeAttr('style');

					// Undo all slider wrappers and restore original classes
					bannerRow.unwrap().addClass(gridClasses);
					$bannerItem
						.removeClass('js-swiper-slide-visible swiper-slide-active swiper-slide-next swiper-slide-prev swiper-slide')
						.removeAttr('style');

				}

				// Toggle grid and slider modules

				handlers[`module_slider`] = new instaElements.Lambda(function(moduleSlider){

					// Main banners markup container
					const $bannerContainer = $generalBannersContainer.find('.js-banner-container');
					const $bannerGrid = $generalBannersContainer.find('.js-banner-grid');
					const $mainBanner = $generalBannersContainer.find('.js-module-grid');
					const $mainBannerText = $generalBannersContainer.find('.js-textbanner-text');

					if (moduleSlider) {
						$generalBannersContainer.attr('data-format', 'slider');
						$mainBanner.removeClass('mb-md-5');
						$mainBannerText.removeClass('order-md-first');
					} else {
						$generalBannersContainer.attr('data-format', 'grid');
					}

					const bannerFormat = $generalBannersContainer.attr('data-format');

					const toSlider = bannerFormat == "slider";

					if ($generalBannersContainer.data('format') == bannerFormat) {
						// Nothing to do
						return;
					}

					// From grid to slider
					if (toSlider) {
						if (window.innerWidth < 768) {
							$bannerContainer.addClass('pr-0');
						}
						initSwiperElements($bannerGrid, bannerName, bannerSwiper, isModule);
					
					// From slider to grid
					} else {
						if (window.innerWidth < 768) {
							$bannerContainer.removeClass('pr-0');
						}
						resetSwiperElements($generalBannersContainer, $bannerGrid, bannerName, isModule);

					}

					// Persist new format in data attribute
					$generalBannersContainer.data('format', bannerFormat);

				});

				if (!isModule) {
					// Remove grid classes on desktop and mobile slider
					if (desktopFormat == 'slider' && mobileFormat == 'slider') {
						const $bannerGrid = $generalBannersContainer.find('.js-banner-grid');
						$bannerGrid.removeClass('grid grid-md-4 grid-md-3 grid-md-2 grid-md-1');
					}

					// Hide swiper arrows on desktop grid
					if (desktopFormat == 'grid') {
						$mainBannersContainer.find(`.js-swiper-${bannerName}-prev`).removeClass('d-md-block');
						$mainBannersContainer.find(`.js-swiper-${bannerName}-next`).removeClass('d-md-block');

						$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-prev`).removeClass('d-md-block');
						$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-next`).removeClass('d-md-block');
					}

					// Toggle grid and slider mobile view
					handlers[`${setting}_format_mobile`] = new instaElements.Lambda(function(bannerFormat){

						const toSlider = bannerFormat == "slider";

						const $bannerContainer = $generalBannersContainer.find('.js-banner-container');
						const $bannerGrid = $generalBannersContainer.find('.js-banner-grid');
						const $mainBannerGrid = $mainBannersContainer.find('.js-banner-grid');
						const $bannerMobileGrid = $mobileBannersContainer.find('.js-banner-grid');

						const $bannerItem = $generalBannersContainer.find('.js-banner-item');

						const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
						const mobileFormat = $generalBannersContainer.attr('data-mobile-format');

						const desktopColumns = $generalBannersContainer.attr('data-desktop-columns');

						if ($generalBannersContainer.attr('data-mobile-format') == bannerFormat) {
							// Nothing to do
							return;
						}

						// From grid to slider
						if (toSlider) {
							$generalBannersContainer.attr('data-mobile-format', 'slider');

							if (window.innerWidth < 768) {
								$bannerContainer.addClass('pr-0');
							}

							// Convert grid to slider if it's not yet
							if ($generalBannersContainer.find('.swiper-slide').length < 1) {
								$generalBannersContainer.find(`.js-swiper-${bannerMobileName}-pagination`).removeClass('d-none').addClass('d-block');
								initSwiperElements($mainBannerGrid, bannerName, bannerSwiper);
								initSwiperElements($bannerMobileGrid, bannerMobileName, bannerSwiperMobile);
							}

							if (desktopFormat == 'grid') {
								$bannerGrid.addClass('swiper-mobile-only flex-nowrap flex-md-wrap');
								if (window.innerWidth > 768) {
									$bannerGrid.addClass('transform-none');
									$bannerItem.addClass('m-0 w-100');

									$mainBannersContainer.find(`.js-swiper-${bannerName}-prev`).removeClass('d-md-block');
									$mainBannersContainer.find(`.js-swiper-${bannerName}-next`).removeClass('d-md-block');

									$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-prev`).removeClass('d-md-block');
									$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-next`).removeClass('d-md-block');
								} else {
									$bannerGrid.removeClass('transform-none');
									$bannerMobileGrid.removeClass('grid');
									$bannerItem.removeClass('m-0 w-100');
								}
							} else {
								$bannerGrid.removeClass('swiper-mobile-only flex-md-wrap transform-none grid').addClass('swiper-products-slider flex-nowrap');
								if (window.innerWidth < 768) {
									$bannerItem.removeClass('m-0 w-100').addClass('swiper-slide');
									initSwiperJS($mainBannersContainer, bannerName, bannerSwiper);
									initSwiperJS($mobileBannersContainer, bannerMobileName, bannerSwiperMobile);
								}
							}

						// From slider to grid
						} else {
							$generalBannersContainer.attr('data-mobile-format', 'grid');
							$generalBannersContainer.find(`.js-swiper-${bannerMobileName}-pagination`).removeClass('d-block').addClass('d-none');
							if (window.innerWidth < 768) {
								$bannerContainer.removeClass('pr-0');
							}

							if (desktopFormat == 'slider') {
								// Mantain mobile slider
								$bannerGrid.removeClass('swiper-products-slider flex-nowrap').addClass('swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 grid');
								if (window.innerWidth < 768) {
									$bannerGrid.addClass('transform-none');
									$bannerItem.removeAttr('style');

									$mainBannersContainer.find(`.js-swiper-${bannerName}-pagination, .js-swiper-${bannerName}-prev, .js-swiper-${bannerName}-next`).remove();
									$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-pagination, .js-swiper-${bannerMobileName}-prev, .js-swiper-${bannerMobileName}-next`).remove();

									$bannerGrid.find('.swiper-slide-duplicate').remove();
								} else {
									$bannerGrid.removeClass('transform-none grid');
								}
							} else {

								// Reset swiper settings
								resetSwiperElements($mainBannersContainer, $mainBannerGrid, bannerName);
								resetSwiperElements($mobileBannersContainer, $bannerMobileGrid, bannerMobileName);

								// Restore grid settings
								$bannerGrid.removeClass('swiper-wrapper swiper-mobile-only flex-nowrap flex-md-wrap transform-none').removeAttr('style');
								if (desktopFormat == 'grid' && mobileFormat == 'grid') {
									$bannerGrid.removeClass('swiper-wrapper swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 transform-none');
								}
							}
						}

						// Persist new format in data attribute
						$generalBannersContainer.attr('data-mobile-format', bannerFormat);
					});

					// Toggle grid and slider desktop view
					handlers[`${setting}_format_desktop`] = new instaElements.Lambda(function(bannerFormat){

						const toSlider = bannerFormat == "slider";

						const $bannerGrid = $generalBannersContainer.find('.js-banner-grid');
						const $mainBannerGrid = $mainBannersContainer.find('.js-banner-grid');
						const $bannerMobileGrid = $mobileBannersContainer.find('.js-banner-grid');

						const $bannerItem = $generalBannersContainer.find('.js-banner-item');

						const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
						const mobileFormat = $generalBannersContainer.attr('data-mobile-format');

						const desktopColumns = $generalBannersContainer.attr('data-desktop-columns');

						if ($generalBannersContainer.attr('data-desktop-format') == bannerFormat) {
							// Nothing to do
							return;
						}

						// From grid to slider
						if (toSlider) {
							$generalBannersContainer.attr('data-desktop-format', 'slider');

							// Convert grid to slider if it's not yet
							if ($generalBannersContainer.find('.swiper-slide').length < 1) {
								initSwiperElements($mainBannerGrid, bannerName, bannerSwiper);
								initSwiperElements($bannerMobileGrid, bannerMobileName, bannerSwiperMobile);
							}

							if (mobileFormat == 'grid') {
								$bannerGrid.addClass('swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0');
								if (window.innerWidth < 768) {
									$bannerGrid.addClass('transform-none');
									$bannerItem.addClass('m-0 w-100');
								} else {
									$bannerGrid.removeClass('transform-none');
									$bannerItem.removeClass('m-0 w-100');
								}
							} else {
								$bannerGrid.removeClass('swiper-mobile-only flex-md-wrap transform-none grid').addClass('swiper-products-slider');

								$mainBannersContainer.find(`.js-swiper-${bannerName}-prev`).addClass('d-md-block');
								$mainBannersContainer.find(`.js-swiper-${bannerName}-next`).addClass('d-md-block');

								$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-prev`).addClass('d-md-block');
								$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-next`).addClass('d-md-block');
								if (window.innerWidth > 768) {
									$bannerItem.removeClass('m-0 w-100 w-auto').addClass('swiper-slide');
									initSwiperJS($generalBannersContainer, bannerName, bannerSwiper);
									initSwiperJS($mobileBannersContainer, bannerMobileName, bannerSwiperMobile);
								}
							}

						// From slider to grid
						} else {
							$generalBannersContainer.attr('data-desktop-format', 'grid');
							const desktopColumnsClasses = $generalBannersContainer.attr('data-grid-classes');

							if (mobileFormat == 'slider') {
								// Mantain mobile slider
								$bannerGrid.removeClass('swiper-products-slider').addClass('swiper-mobile-only flex-nowrap flex-md-wrap grid ' + desktopColumnsClasses);
								if (window.innerWidth > 768) {
									$bannerGrid.addClass('transform-none');
									$bannerItem.removeAttr('style');

									$mainBannersContainer.find(`.js-swiper-${bannerName}-prev`).removeClass('d-md-block');
									$mainBannersContainer.find(`.js-swiper-${bannerName}-next`).removeClass('d-md-block');

									$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-prev`).removeClass('d-md-block');
									$mobileBannersContainer.find(`.js-swiper-${bannerMobileName}-next`).removeClass('d-md-block');

									$bannerGrid.find('.swiper-slide-duplicate').remove();
								} else {
									$bannerGrid.removeClass('transform-none grid');
								}
							} else {

								// Reset swiper settings
								resetSwiperElements($mainBannersContainer, $mainBannerGrid, bannerName);
								resetSwiperElements($mobileBannersContainer, $bannerMobileGrid, bannerMobileName);

								// Restore grid settings
								$bannerGrid.removeClass('swiper-wrapper swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 transform-none').removeAttr('style');
								if (desktopFormat == 'grid' && mobileFormat == 'grid') {
									$bannerGrid.removeClass('swiper-wrapper swiper-mobile-only flex-nowrap flex-md-wrap transform-none');
								}
							}
						}

						// Persist new format in data attribute
						$generalBannersContainer.attr('data-desktop-format', bannerFormat);
					});

					// Update banner text position
					handlers[`${setting}_text_outside`] = new instaElements.Lambda(function(hasOutsideText){
						const $bannerText = $generalBannersContainer.find('.js-textbanner-text');

						if (hasOutsideText) {
							$generalBannersContainer.attr('data-text', 'outside');
							$bannerText.removeClass('textbanner-text-above').addClass('textbanner-text-background');
						} else {
							$generalBannersContainer.attr('data-text', 'above');
							$bannerText.removeClass('textbanner-text-background').addClass('textbanner-text-above');
						}
					});

					// Update banner text align
					handlers[`${setting}_align`] = new instaElements.Lambda(function(bannerAlign){
						const $bannerText = $generalBannersContainer.find('.js-textbanner-text');

						if (bannerAlign == 'left') {
							$generalBannersContainer.attr('data-align', 'left');
							$bannerText.removeClass('text-center textbanner-text-center');
						} else {
							$generalBannersContainer.attr('data-align', 'center');
							$bannerText.addClass('text-center textbanner-text-center');
						}
					});

					// Update banner margins
					handlers[`${setting}_without_margins`] = new instaElements.Lambda(function(bannerMargin){
						const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
						const mobileFormat = $generalBannersContainer.attr('data-mobile-format');
						const $bannerSection = $generalBannersContainer.closest('.js-section-banner-home');
						const $bannerContainer = $generalBannersContainer.find('.js-banner-container');
						const $bannerGrid = $bannerContainer.find('.js-banner-grid');
						const $bannerItem = $generalBannersContainer.find('.js-textbanner');
						const $bannerArrows = $(`.js-swiper-${bannerName}-prev, .js-swiper-${bannerName}-next`);

						if (bannerMargin) {
							$bannerSection.addClass("p-0").removeClass("py-4");
							$bannerContainer.removeClass('container px-md-3').addClass('container-fluid overflow-none p-0');
							$bannerGrid.addClass('grid-no-gap');
							$bannerItem.addClass('m-0');
							$bannerArrows.removeClass('swiper-button-outside svg-icon-text').addClass('svg-icon-invert');
							if ((desktopFormat == 'slider' && window.innerWidth > 768) || (mobileFormat == 'slider' && window.innerWidth < 768)) {
								window[bannerSwiper].params.spaceBetween = 0;
								window[bannerSwiper].update();
							}
						} else {
							$bannerSection.addClass("py-4").removeClass("p-0");
							$bannerContainer.removeClass('container-fluid overflow-none p-0').addClass('container px-md-3');
							$bannerGrid.removeClass('grid-no-gap');
							$bannerItem.removeClass('m-0');
							$bannerArrows.removeClass('svg-icon-invert').addClass('swiper-button-outside svg-icon-text');
							if ((desktopFormat == 'slider' && window.innerWidth > 768) || (mobileFormat == 'slider' && window.innerWidth < 768)) {
								window[bannerSwiper].params.spaceBetween = 16;
								window[bannerSwiper].update();
							}
						}

						// Updates slider width to avoids swipes inconsistency
						if ((desktopFormat == 'slider' && window.innerWidth > 768) || (mobileFormat == 'slider' && window.innerWidth < 768)) {
							window[bannerSwiper].params.observer = true;
							window[bannerSwiper].update();
						}
					});

					// Update quantity banners
					handlers[`${setting}_columns_desktop`] = new instaElements.Lambda(function(bannerQuantity){
						const $bannerGrid = $generalBannersContainer.find('.js-banner-grid');
						const desktopFormat = $generalBannersContainer.attr('data-desktop-format');

						$bannerGrid.removeClass('grid-md-4 grid-md-3 grid-md-2 grid-md-1');
						if (bannerQuantity == 4) {
							$generalBannersContainer.attr('data-desktop-columns', bannerQuantity);
							$generalBannersContainer.attr('data-grid-classes', 'grid-md-4');
							$bannerGrid.addClass('grid-md-4');

							if (desktopFormat == 'slider') {
								if (window.innerWidth > 768) {
									window[bannerSwiper].params.slidesPerView = 4;
									window[bannerSwiper].update();
								}
							}

						} else if (bannerQuantity == 3) {
							$generalBannersContainer.attr('data-desktop-columns', bannerQuantity);
							$generalBannersContainer.attr('data-grid-classes', 'grid-md-3');
							$bannerGrid.addClass('grid-md-3');

							if (desktopFormat == 'slider') {
								if (window.innerWidth > 768) {
									window[bannerSwiper].params.slidesPerView = 3;
									window[bannerSwiper].update();
								}
							}

						} else if (bannerQuantity == 2) {
							$generalBannersContainer.attr('data-desktop-columns', bannerQuantity);
							$generalBannersContainer.attr('data-grid-classes', 'grid-md-2');
							$bannerGrid.addClass('grid-md-2');

							if (desktopFormat == 'slider') {
								if (window.innerWidth > 768) {
									window[bannerSwiper].params.slidesPerView = 2;
									window[bannerSwiper].update();
								}
							}

						} else if (bannerQuantity == 1) {
							$generalBannersContainer.attr('data-desktop-columns', bannerQuantity);
							$generalBannersContainer.attr('data-grid-classes', 'grid-md-1');
							$bannerGrid.addClass('grid-md-1');

							if (desktopFormat == 'slider') {
								if (window.innerWidth > 768) {
									window[bannerSwiper].params.slidesPerView = 1;
									window[bannerSwiper].update();
								}
							}

						}
					});

					// Toggle mobile banners visibility

					handlers[`toggle_${setting}_mobile`] = new instaElements.Lambda(function(showMobileBanner){
						const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
						const mobileFormat = $generalBannersContainer.attr('data-mobile-format');

						$mainBannersContainer.removeClass("hidden d-md-none d-none d-md-block");
						$mobileBannersContainer.removeClass("hidden d-md-none d-none d-md-block");

						if (showMobileBanner) {
							// Each breakpoint shows on it's own device content
							$mainBannersContainer.addClass("d-none d-md-block");
							$mobileBannersContainer.addClass("d-md-none");
							$generalBannersContainer.attr('data-mobile-banners', '1');

							if (desktopFormat == 'slider' || mobileFormat == 'slider') {

								if (desktopFormat == 'slider' && mobileFormat == 'grid') {
									if (window.innerWidth > 768) {
										// Try using already created swiper JS, if it fails initialize swipers again
										try{
											window[bannerSwiperMobile].update();
										}catch(e){
											initSwiperJS($generalBannersContainer, bannerMobileName, bannerSwiperMobile);
										}
									}
								} else if (mobileFormat == 'slider' && desktopFormat == 'grid') {
									if (window.innerWidth < 768) {
										// Try using already created swiper JS, if it fails initialize swipers again
										try{
											window[bannerSwiperMobile].update();
										}catch(e){
											initSwiperJS($generalBannersContainer, bannerMobileName, bannerSwiperMobile);
										}
									}
								} else {
									// Try using already created swiper JS, if it fails initialize swipers again
									try{
										window[bannerSwiperMobile].update();
									}catch(e){
										initSwiperJS($generalBannersContainer, bannerMobileName, bannerSwiperMobile);
									}
								}
							}
						} else {
							// Hide mobile banners
							$mobileBannersContainer.addClass("d-none");
							$generalBannersContainer.attr('data-mobile-banners', '0');
							if (desktopFormat == 'slider' || mobileFormat == 'slider') {

								if (desktopFormat == 'slider' && mobileFormat == 'grid') {
									if (window.innerWidth > 768) {
										// Try using already created swiper JS, if it fails initialize swipers again
										try{
											window[bannerSwiperMobile].update();
										}catch(e){
											initSwiperJS($generalBannersContainer, bannerMobileName, bannerSwiperMobile);
										}
									}
								} else if (mobileFormat == 'slider' && desktopFormat == 'grid') {
									if (window.innerWidth < 768) {
										// Try using already created swiper JS, if it fails initialize swipers again
										try{
											window[bannerSwiperMobile].update();
										}catch(e){
											initSwiperJS($generalBannersContainer, bannerMobileName, bannerSwiperMobile);
										}
									}
								} else {
									// Try using already created swiper JS, if it fails initialize swipers again
									try{
										window[bannerSwiperMobile].update();
									}catch(e){
										initSwiperJS($generalBannersContainer, bannerMobileName, bannerSwiperMobile);
									}
								}
							}
						}
					});

				}

			});

			// Mobile banners: Banner content and order updates

			['banner_mobile', 'banner_promotional_mobile', 'banner_news_mobile'].forEach(setting => {

				const bannerName = setting.replace('_', '-').replace(/[-_]mobile$/, '');
				const bannerMobileName = 
					setting == 'banner_mobile' ? 'banner-mobile' : 
					setting == 'banner_promotional_mobile' ? 'banner-promotional-mobile' : 
					setting == 'banner_news_mobile' ? 'banner-news-mobile' :
					null;
				const $generalBannersContainer = $(`.js-home-${bannerName}`);

				// Target specific breakpoint to build correct slides on each device
				const $mobileBannersContainer = $generalBannersContainer.find(`.js-${bannerMobileName}`);

				const bannerSwiperMobile = 
					setting == 'banner_mobile' ? 'homeBannerMobileSwiper' : 
					setting == 'banner_promotional_mobile' ? 'homeBannerPromotionalMobileSwiper' : 
					setting == 'banner_news_mobile' ? 'homeBannerNewsMobileSwiper' :
					null;

				const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
				const mobileFormat = $generalBannersContainer.attr('data-mobile-format');

				const desktopColumns = $generalBannersContainer.attr('data-desktop-columns');

				const bannerModuleSetting = false;
				const isModule = false;

				// Update banners content
				handlers[`${setting}`] = new instaElements.Lambda(function(slides){

					// Update text classes
					const textPosition = $generalBannersContainer.attr('data-text');
					const positionClasses = textPosition == 'above' ? 'textbanner-text-above' : 'textbanner-text-background';

					// Update margin classes
					const bannerMargin = $generalBannersContainer.attr('data-margin');
					const marginClasses = bannerMargin == 'false' ? 'm-0' : '';

					// Update align classes
					const bannerAlign = $generalBannersContainer.attr('data-align');
					const alignClasses = bannerAlign == 'center' ? 'text-center textbanner-text-center' : '';

					// Update textbanner classes
					const textBannerClasses = marginClasses;
					const textClasses = positionClasses + ' ' + alignClasses;

					// Update column classes
					const desktopColumnsClasses = $generalBannersContainer.attr('data-grid-classes');
					const columnClasses = desktopColumnsClasses;

					// Insta slider function
					function instaSlider() {
						// Update banner classes
						const bannerClasses = 'swiper-slide';

						if (!window[bannerSwiperMobile]) {
							return;
						}

						// Try using already created swiper JS, if it fails initialize swipers again
						try{
							window[bannerSwiperMobile].removeAllSlides();
							slides.forEach(function(aSlide){
								window[bannerSwiperMobile].appendSlide(buildHomeBannerDom(aSlide, bannerClasses, textBannerClasses, textClasses, bannerModuleSetting));
							});
							window[bannerSwiperMobile].update();
						}catch(e){
							initSwiperJS($generalBannersContainer, bannerMobileName, bannerSwiperMobile, isModule);

							setTimeout(function(){
								slides.forEach(function(aSlide){
									window[bannerSwiperMobile].appendSlide(buildHomeBannerDom(aSlide, bannerClasses, textBannerClasses, textClasses, bannerModuleSetting));
								});	
							},500);
						}
					}

					// Insta grid function
					function instaGrid() {
						// Update banner classes
						const bannerClasses = '';

						$mobileBannersContainer.find('.js-banner-item').remove();
						slides.forEach(function(aSlide){
							$mobileBannersContainer.find('.js-banner-grid').append(buildHomeBannerDom(aSlide, bannerClasses, textBannerClasses, textClasses, bannerModuleSetting));
						});
					}

					const desktopFormat = $generalBannersContainer.attr('data-desktop-format');
					const mobileFormat = $generalBannersContainer.attr('data-mobile-format');

					if (desktopFormat == 'slider' || mobileFormat == 'slider') {

						if (desktopFormat == 'slider' && mobileFormat == 'grid') {
							if (window.innerWidth > 768) {
								instaSlider();
							} else {
								instaGrid();
							}
						} else if (mobileFormat == 'slider' && desktopFormat == 'grid') {
							if (window.innerWidth < 768) {
								instaSlider();
							} else {
								instaGrid();
							}
						} else {
							instaSlider();
						}
					} else {
						instaGrid();
					}
				});
			});

			// ----------------------------------- Institutional message -----------------------------------

			// Updates visibility of each institutional

			function institutionalContentVisibility(container){

				window.institutionalSwiper.params.observer = true;
				window.institutionalSwiper.update();

				const hasContent = $(container).find('.js-institutional-title').text().trim() || 
						$(container).find('.js-institutional-description').text().trim() || 
						$(container).find('.js-institutional-link').text().trim();
				if(hasContent){
					$(container).show();
				}else{
					$(container).hide();
				}
			}

			// Updates visibility of each institutional's content

			for (let i = 1; i <= 4; i++) {
				// Update title and description for each institutional message
				['title', 'description', 'button'].forEach(setting => {
					handlers[`institutional_0${i}_${setting}`] = new instaElements.Text({
						element: `.js-institutional-${setting}-${i}`,
						show: function(){
							$(this).show();
							institutionalContentVisibility($(this).closest('.js-institutional-slide'));
						},
						hide: function(){
							$(this).hide();
							institutionalContentVisibility($(this).closest('.js-institutional-slide'));
						},
					});
				});
			}

			// Institutional colors
			handlers.home_institutional_colors = new instaElements.Lambda(function(institutionalColors){
				
				const $container = $('.js-section-institutional-home');

				if (institutionalColors) {
					$container.addClass("section-institutional-home-colors py-5").removeClass("py-4");
				} else {
					$container.removeClass("section-institutional-home-colors py-5").addClass("py-4");
				}
			});

			// ----------------------------------- Main categories -----------------------------------

			// Build the html for a slide given the data from the settings editor
			function buildMainCategoriesSlideDom(aSlide) {
				return '<div class="js-main-category-slide swiper-slide w-auto mr-4">' +
					(aSlide.link ? '<a href="' + aSlide.link + '" class="js-home-category-live">' : '' ) +
					'<div class="home-category">' +
						'<div class="js-home-category-image home-category-image">' +
							'<img src="' + aSlide.src + '" class="swiper-lazy d-block img-fluid"/>' +
						'</div>' +
						'<div class="js-main-category-name-live my-3 ml-md-2 font-medium font-md-body"></div>' +
					'</div>' +
					(aSlide.link ? '</a>' : '' ) +
					'</div>'
			}

			// Update main categories carousel
			handlers.slider_categories = new instaElements.Lambda(function(slides){
				if (!window.mainCategoriesSwiper) {
					return;
				}

				window.mainCategoriesSwiper.removeAllSlides();
				slides.forEach(function(aSlide){
					window.mainCategoriesSwiper.appendSlide(buildMainCategoriesSlideDom(aSlide));
				});
			});

			// Update main categories image border
			handlers.main_categories_border = new instaElements.Lambda(function(borderImage){
				
				const $categoryImage = $('.js-home-category-image');

				if (borderImage) {
					$categoryImage.addClass("home-category-image-border");
				} else {
					$categoryImage.removeClass("home-category-image-border");
				}
			});

			// ----------------------------------- Video -----------------------------------

			// Update video thumbnail and iframe
			handlers.video_embed = new instaElements.Lambda(function(videoUrl){
				const $section = $('.js-home-video-section');
				const $container = $('.js-home-video');

				if (videoUrl) {
					$section.show();
				} else {
					$section.hide();
				}

				// Generate new html
				$container.html(`
						<a href="#" class="js-play-button video-player home-video-overlay" style="display:none;">
							<div class="video-player-icon">
								<svg class="icon-inline svg-icon-text ml-1"><use xlink:href="#play"/></svg>
							</div>
							<div class="js-video-image">
								<img src="" class="home-video-image lazyload">
								<div class="placeholder placeholder-shine placeholder-shine-invert"></div>
							</div>
						</a>
				`);

				LS.loadVideo(videoUrl);

				// The loadVideo function sets the data-src attribute for lazy loading, copy that value to src
				const $thumbnail = $container.find('.js-home-video-image img');
				$thumbnail.attr('src', $thumbnail.data('src'));
				$thumbnail.css('z-index', -1);

				// Show container for both video and text and signal thumbnail readiness to placeholder
				$container.closest('.js-home-video-container').data('thumbnail-ready', true).show();
			});

			// Update video type
			handlers.video_type = new instaElements.Lambda(function(videoType){
				const videoId = $('.js-home-video-container').data('video');
				const $videoIframe = $('.js-home-video-iframe');
				const $playButton = $('.js-play-button');
				const $videoImage = $('.js-home-video-image');

				$videoImage.css('opacity', 1).removeClass('d-md-none');
				$('.js-video-placeholder').hide();

				if (videoType == 'autoplay') {
					$playButton.hide();
					$videoImage.hide().removeClass('d-block');
					$videoIframe.html(`<iframe id="player" frameborder="0" allowfullscreen="" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" src="https://www.youtube.com/embed/${videoId}?autoplay=1&amp;playsinline=1&amp;rel=0&amp;loop=1&amp;autopause=0&amp;controls=0&amp;showinfo=0&amp;modestbranding=1&amp;branding=0&amp;fs=0&amp;iv_load_policy=3&amp;enablejsapi=1&ampwidgetid=1"></iframe>`);
				} else {
					$playButton.show();
					$videoImage.show();
					$videoIframe.html(`<div class="js-home-video-iframe" id="player"></div>`);
				}
			});

			// Video colors
			handlers.home_video_colors = new instaElements.Lambda(function(videoColors){
				const $container = $('.js-home-video-container');

				if (videoColors) {
					$container.addClass("section-video-home-colors");
				} else {
					$container.removeClass("section-video-home-colors");
				}
			});

			// Toggle full-width for video
			handlers.video_full = new instaElements.Lambda(function(isFullwidth){
				const $container = $('.js-home-video-section');
				if (isFullwidth) {
					$container.removeClass('container');
				} else {
					$container.addClass('container');
				}
			});

			// Toggle mobile vertical for video
			handlers.video_vertical_mobile = new instaElements.Lambda(function(isFullwidth){
				const $container = $('.js-home-video');
				if (isFullwidth) {
					$container.addClass('embed-responsive-1by1');
				} else {
					$container.removeClass('embed-responsive-1by1');
				}
			});

			// Update visibility of text column

			function videoContentVisibility(container){
				const hasContent = $(container).find('.js-home-video-title').text().trim() || 
						$(container).find('.js-home-video-text').text().trim() ||
						$(container).find('.js-home-video-button').text().trim();
				if(hasContent){
					$(container).show();
					$('.js-home-video-container').removeClass('home-background-container-full');
				}else{
					$(container).hide();
					$('.js-home-video-container').addClass('home-background-container-full');
				}
			}

			// Update title, description and button for video texts
			['title', 'text', 'button'].forEach(setting => {
				handlers[`video_${setting}`] = new instaElements.Text({
					element: `.js-home-video-${setting}`,
					show: function(){
						$(this).show();
						videoContentVisibility($(this).closest('.js-home-video-text-container'));
					},
					hide: function(){
						$(this).hide();
						videoContentVisibility($(this).closest('.js-home-video-text-container'));
					},
				});
			});

			// ----------------------------------- Brands Slider -----------------------------------

			// Build the html for a slide given the data from the settings editor
			function buildBrandsSlideDom(aSlide) {
				return '<div class="swiper-slide slide-container">' +
					(aSlide.link ? '<a href="' + aSlide.link + '">' : '' ) +
					'<img src="' + aSlide.src + '" class="brand-image"/>' +
					(aSlide.link ? '</a>' : '' ) +
					'</div>'
			}

			// Update brands title
			handlers.brands_title = new instaElements.Text({
				element: '.js-brands-title',
			});

			// Update brands carousel
			handlers.brands = new instaElements.Lambda(function(slides){
				if (!window.brandsSwiper) {
					return;
				}

				window.brandsSwiper.removeAllSlides();
				slides.forEach(function(aSlide){
					window.brandsSwiper.appendSlide(buildBrandsSlideDom(aSlide));
				});
			});

			// ----------------------------------- Testimonials -----------------------------------

			// Updates testimonials section title
			handlers.testimonials_title = new instaElements.Text({
				element: '.js-testimonial-main-title',
				show: function(){
					$(this).show();
				},
				hide: function(){
					$(this).hide();
				},
			});

			// Updates testimonials section title: Using Lambda instead of Text to target multiple titles (placeholder and final feature)
			handlers.testimonials_title = new instaElements.Lambda(function(testimonialsTitle){
				const $testimonialsTitle = $('.js-testimonial-main-title');
				const $testimonialsTitleContainer = $('.js-testimonial-main-title').parent();

				$testimonialsTitle.text(testimonialsTitle);

				if(testimonialsTitle){
					$testimonialsTitleContainer.show();
				}else{
					$testimonialsTitleContainer.hide();
				}
			});

			// Updates visibility of each testimonial

			function testimonialContentVisibility(container){
				const hasContent = $(container).find('.js-testimonial-description').text().trim() || 
						$(container).find('.js-testimonial-title').text().trim() ||
						$(container).find('.js-testimonial-name').text().trim() ||
						$(container).find('.js-testimonial-img').attr('src');
				if(hasContent){
					$(container).show();
				}else{
					$(container).hide();
				}

				window.testimonialsSwiper.params.observer = true;
				window.testimonialsSwiper.update();
			}

			// Updates visibility of each testimonial's content

			for (let i = 1; i <= 5; i++) {
				// Update image for each testimonial
				handlers[`testimonial_0${i}.jpg`] = new instaElements.Image({
					element: `.js-testimonial-img-${i}`,
					show: function() {
						$(this).parent(".js-testimonial-img-container").show();

						// Maybe show container now that there's content inside
						testimonialContentVisibility($(this).closest('.js-section-testimonials, .js-testimonial-slide'));
					},
					hide: function() {
						$(this).parent().hide();

						// Maybe hide if there's no content inside
						testimonialContentVisibility($(this).closest('.js-section-testimonials, .js-testimonial-slide'));
					},
				});

				// Updates name, title and description for each testimonial
				['name', 'title', 'description'].forEach(setting => {
					handlers[`testimonial_0${i}_${setting}`] = new instaElements.Text({
						element: `.js-testimonial-${setting}-${i}`,
						show: function(){
							$(this).show();
							testimonialContentVisibility($(this).closest('.js-testimonial-slide'));
						},
						hide: function(){
							$(this).hide();
							testimonialContentVisibility($(this).closest('.js-testimonial-slide'));
						},
					});
				});

				// Updates stars for each testimonial
				handlers[`testimonial_0${i}_stars`] = new instaElements.Lambda(function(testimonialStars){
					const $itemStars = $(`.js-testimonial-stars-${i}`);

					$itemStars.removeClass('testimonial-stars-1 testimonial-stars-2 testimonial-stars-3 testimonial-stars-4 testimonial-stars-5');

					if (testimonialStars == '5') {
						$itemStars.show();
						$itemStars.addClass('testimonial-stars-5');
					} else if (testimonialStars == '4') {
						$itemStars.show();
						$itemStars.addClass('testimonial-stars-4');
					} else if (testimonialStars == '3') {
						$itemStars.show();
						$itemStars.addClass('testimonial-stars-3');
					} else if (testimonialStars == '2') {
						$itemStars.show();
						$itemStars.addClass('testimonial-stars-2');
					} else if (testimonialStars == '1') {
						$itemStars.show();
						$itemStars.addClass('testimonial-stars-1');
					} else {
						$itemStars.hide();
					}
				});
			}

			// ----------------------------------- Newsletter -----------------------------------

			// Newsletter visibility
			function newsletterContentVisibility(container){
				const hasContent = $(container).find('.js-home-newsletter-title').text().trim() || 
						$(container).find('.js-home-newsletter-text').text().trim() ||
						$(container).find('.js-home-newsletter-image').attr('src') ||
						$(container).find('.js-home-newsletter-image-mobile').attr('src');
				if(hasContent){
					$(container).show();
					$('.js-home-newsletter-container').removeClass('home-background-container-center');
				}else{
					$(container).hide();
					$('.js-home-newsletter-container').addClass('home-background-container-center');
				}
			}

			// Updates title and text for newsletter form
			['title', 'text'].forEach(setting => {
				handlers[`home_news_${setting}`] = new instaElements.Text({
					element: `.js-home-newsletter-${setting}`
				});
			});

			// Updates newsletter images
			['image', 'image_mobile'].forEach(setting => {
				const imageName = setting.replace('_', '-');
				handlers[`home_news_${setting}.jpg`] = new instaElements.Image({
					element: `.js-home-newsletter-${imageName}`,
					show: function() {
						$(this).show();
						// Hides mobile image if has desktop image
						if ($('.js-home-newsletter-image').css('display') !== 'none') {
							$('.js-home-newsletter-image-mobile').addClass('d-block d-md-none');
						} else {
							$('.js-home-newsletter-image-mobile').removeClass('d-block d-md-none');
						}
						// Hides desktop image if has mobile image
						if ($('.js-home-newsletter-image-mobile').css('display') !== 'none') {
							$('.js-home-newsletter-image').addClass('d-none d-md-block');
						} else {
							$('.js-home-newsletter-image').removeClass('d-none d-md-block');
						}

						// Maybe show container now that there's content inside
						newsletterContentVisibility($(this).closest('.js-home-newsletter-image-container'));
					},
					hide: function() {
						$(this).hide();

						// Maybe show container now that there's content inside
						newsletterContentVisibility($(this).closest('.js-home-newsletter-image-container'));
					},
				});
			});

			// Toggle full-width for newsletter
			handlers.news_full = new instaElements.Lambda(function(isFullwidth){
				const $container = $('.js-home-newsletter');
				if (isFullwidth) {
					$container.removeClass('container');
				} else {
					$container.addClass('container');
				}
			});

			// Newsletter colors
			handlers.home_news_colors = new instaElements.Lambda(function(newsColors){
				
				const $container = $('.js-home-newsletter-container');

				if (newsColors) {
					$container.addClass("section-newsletter-home-colors");
				} else {
					$container.removeClass("section-newsletter-home-colors");
				}
			});

			// ----------------------------------- Timer offers -----------------------------------

			// Updates title, text and button for timer offers
			
			['title', 'text', 'button'].forEach(setting => {
				handlers[`timer_offers_${setting}`] = new instaElements.Text({
					element: `.js-timer-offers-${setting}`,
					show: function(){
						$(this).show();
					},
					hide: function(){
						$(this).hide();
					},
				});
			});

			// Updates timer offer images
			['image', 'image_mobile'].forEach(setting => {
				const imageName = setting.replace('_', '-');
				handlers[`timer_offers_${setting}.jpg`] = new instaElements.Image({
					element: `.js-timer-offers-${imageName}`,
					show: function() {
						$(this).show();
						// Hides mobile image if has desktop image
						if ($('.js-timer-offers-image').css('display') !== 'none') {
							$('.js-timer-offers-image-mobile').addClass('d-block d-md-none');
						} else {
							$('.js-timer-offers-image-mobile').removeClass('d-block d-md-none');
						}
						// Hides desktop image if has mobile image
						if ($('.js-timer-offers-image-mobile').css('display') !== 'none') {
							$('.js-timer-offers-image-image').addClass('d-none d-md-block');
						} else {
							$('.js-timer-offers-image-image').removeClass('d-none d-md-block');
						}
						$(".js-timer-offers-content").addClass("py-5").removeClass("py-3");
					},
					hide: function() {
						$(this).hide();
						// Reset breakpoints visibility for cross device fallback
						$('.js-timer-offers-image ,.js-timer-offers-image-mobile').removeClass("d-none d-block d-md-block d-md-none");
						if (($('.js-timer-offers-image').css('display') === 'none') && $('.js-timer-offers-image-mobile').css('display') === 'none') {
							$(".js-timer-offers-content").removeClass("py-5").addClass("py-3");
						}	
					},
				});
			});

			// Toggle full-width
			handlers.timer_offers_full = new instaElements.Lambda(function(isFullwidth){
				const $container = $('.js-timer-offers-container');
				const $productsContainer = $container.find(".js-timer-offers-products");
				if (isFullwidth) {
					$container.removeClass('container');
					$productsContainer.addClass("mr-md-4").removeClass("mx-md-0");
					window['productsTimerSwiper'].update();
				} else {
					$container.addClass('container');
					$productsContainer.addClass("mx-md-0").removeClass("mr-md-4");
					window['productsTimerSwiper'].update();
				}
			});

			// Change content alignment
			handlers.timer_offers_align = new instaElements.Lambda(function(alignContent){
				const $container = $('.js-timer-offers-content');
				const $cardsContainer = $container.find('.js-timer-offers-cards');
				const $button = $container.find('.js-timer-offers-button');
				if (alignContent == 'center') {
					$container.addClass('text-center').removeClass('text-left');
					$cardsContainer.addClass('align-self-center');
					$button.addClass('align-self-center').removeClass('align-self-start');
				} else {
					$container.addClass('text-left').removeClass('text-center');
					$cardsContainer.removeClass('align-self-center');
					$button.addClass('align-self-start').removeClass('align-self-center');
				}
			});

			// Timer offer colors
			handlers.timer_offers_colors = new instaElements.Lambda(function(timerOffersColors){
				
				const $container = $('.js-timer-offers-info');

				if (timerOffersColors) {
					$container.addClass("section-timer-offers-colors");
				} else {
					$container.removeClass("section-timer-offers-colors");
				}
			});

			// Show or hide products
			handlers.timer_offers_products_show = new instaElements.Lambda(function(showOfferProducts){
				
				const $container = $(".js-timer-offers-container");
				const $info = $('.js-timer-offers-info');
				const $content = $('.js-timer-offers-content');
				const $products = $('.js-timer-offers-products');

				const hasOfferProducts = $container.attr("data-products");

				if(hasOfferProducts == 'true'){
					if (showOfferProducts) {
						$container.addClass("d-grid grid-md-2");
						$info.addClass("mr-md-2");
						$content.addClass("with-products");
						$products.removeClass("d-none");
						window['productsTimerSwiper'].update();
					} else {
						$container.removeClass("d-grid grid-md-2");
						$info.removeClass("mr-md-2");
						$content.removeClass("with-products");
						$products.addClass("d-none");
					}
				}
			});

			// ----------------------------------- Instagram Feed -----------------------------------

			// Toggle feed visibility
			handlers.show_instafeed = new instaElements.Lambda(function (isVisible) {
				const $container = $('.js-instagram-feed');

				if (isVisible) {
					$container.show();
				} else {
					$container.hide();
				}
			});

			// ----------------------------------- Highlighted Products -----------------------------------

			// Same logic applies to all 3 types of highlighted products
			['featured', 'sale', 'new'].forEach(setting => {

				const $productContainer = $(`.js-products-${setting}-container`);
				const $productGrid = $(`.js-products-${setting}-grid`);
				const productSwiper = setting == 'featured' ? 'productsFeaturedSwiper' : 
					setting == 'new' ? 'productsNewSwiper' : 
					setting == 'sale' ? 'productsSaleSwiper' :
					null;

				const $productItem = $productGrid.find(`.js-product-item-private`);

				// Updates title text
				handlers[`${setting}_products_title`] = new instaElements.Text({
					element: `.js-products-${setting}-title`,
					show: function() {
						$(this).show();
					},
					hide: function() {
						$(this).hide();
					}
				})

				// Updates quantity products desktop
				handlers[`${setting}_products_desktop`] = new instaElements.Lambda(function(desktopProductQuantity){
					const desktopFormat = $productGrid.attr('data-desktop-format');

					$productGrid.removeClass('grid-md-4 grid-md-5 grid-md-6');
					if (window.innerWidth > 768) {
						if (desktopProductQuantity == 4) {
							$productGrid.attr('data-desktop-columns', desktopProductQuantity);

							if (desktopFormat == 'grid') {
								$productGrid.addClass('grid-md-4');
							} else {
								window[productSwiper].params.slidesPerView = 4;
								window[productSwiper].params.slidesPerGroup = 4;
								window[productSwiper].update();
							}

						} else if (desktopProductQuantity == 5) {
							$productGrid.attr('data-desktop-columns', desktopProductQuantity);

							if (desktopFormat == 'grid') {
								$productGrid.addClass('grid-md-5');
							} else {
								window[productSwiper].params.slidesPerView = 5;
								window[productSwiper].params.slidesPerGroup = 5;
								window[productSwiper].update();
							}

						} else if (desktopProductQuantity == 6) {
							$productGrid.attr('data-desktop-columns', desktopProductQuantity);

							if (desktopFormat == 'grid') {
								$productGrid.addClass('grid-md-6');
							} else {
								window[productSwiper].params.slidesPerView = 6;
								window[productSwiper].params.slidesPerGroup = 6;
								window[productSwiper].update();
							}
						}
					}
				});

				// Updates quantity products mobile
				handlers[`${setting}_products_mobile`] = new instaElements.Lambda(function(mobileProductQuantity){
					const mobileFormat = $productGrid.attr('data-mobile-format');

					$productGrid.removeClass('grid-1 grid-2');
					if (window.innerWidth < 768) {
						if (mobileProductQuantity == 1) {
							$productGrid.attr('data-mobile-columns', mobileProductQuantity);

							$productGrid.addClass('grid-1');
							if (mobileFormat == 'slider') {
								window[productSwiper].params.slidesPerView = 1;
								window[productSwiper].params.slidesPerGroup = 1;
								window[productSwiper].update();
							}

						} else if (mobileProductQuantity == 2) {
							$productGrid.attr('data-mobile-columns', mobileProductQuantity);

							if (mobileFormat == 'grid') {
								$productGrid.addClass('grid-2');
							} else {
								window[productSwiper].params.slidesPerView = 2;
								window[productSwiper].params.slidesPerGroup = 2;
								window[productSwiper].update();
							}

						}
					}
				});

				// Initialize swiper function
				function initSwiper() {

					createSwiper(`.js-swiper-${setting}`, {
						watchOverflow: true,
						centerInsufficientSlides: true,
						threshold: 5,
						watchSlideProgress: true,
						watchSlidesVisibility: true,
						slideVisibleClass: 'js-swiper-slide-visible',
						spaceBetween: 16,
						loop: $productItem.length > 3,
						navigation: {
							nextEl: `.js-swiper-${setting}-next`,
							prevEl: `.js-swiper-${setting}-prev`
						},
						pagination: {
							el: `.js-swiper-${setting}-pagination`,
							clickable: true,
						},
						slidesPerView: $productGrid.data('mobile-columns'),
						slidesPerGroup: $productGrid.data('mobile-columns'),
						breakpoints: {
							768: {
								slidesPerView: $productGrid.data('desktop-columns'),
								slidesPerGroup: $productGrid.data('desktop-columns'),
							}
						},
					},
					function(swiperInstance) {
						window[productSwiper] = swiperInstance;
					});
				}

				// Initialize swiper elements function
				function initSwiperElements() {

					$productGrid.addClass('swiper-wrapper');

					// Wrap everything inside a swiper container
					$productGrid.wrapAll(`<div class="js-swiper-${setting} swiper-container"></div>`)

					// Wrap each product into a slide
					$productItem.wrap(`<div class="swiper-slide"></div>`);

					// Add previous and next controls
					$productContainer.append(`
						<div class="js-swiper-${setting}-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100 mt-3 d-md-none"></div>
						<div class="js-swiper-${setting}-prev swiper-button-prev d-none d-md-block svg-icon-text swiper-button-outside">
							<svg class="icon-inline icon-2x icon-flip-horizontal"><use xlink:href="#arrow-long"/></svg>
						</div>
						<div class="js-swiper-${setting}-next swiper-button-next d-none d-md-block svg-icon-text swiper-button-outside">
							<svg class="icon-inline icon-2x"><use xlink:href="#arrow-long"/></svg>
						</div>
					`);

					// Initialize swiper
					initSwiper();
				}

				// Reset swiper function
				function resetSwiperElements() {
					const desktopProductQuantity = $productGrid.attr('data-desktop-columns');
					const mobileProductQuantity = $productGrid.attr('data-mobile-columns');

					const desktopColumnsClasses = desktopProductQuantity == '4' ? 'grid-md-4' : desktopProductQuantity == '5' ? 'grid-md-5' : 'grid-md-6';
					const mobileColumnsClasses = mobileProductQuantity == '2' ? 'grid-2' : 'grid-1';
					const columnClasses = desktopColumnsClasses + ' ' + mobileColumnsClasses;

					// Remove duplicate slides and slider controls
					$productContainer.find(`.js-swiper-${setting}-pagination`).remove();
					$productContainer.find(`.js-swiper-${setting}-prev`).remove();
					$productContainer.find(`.js-swiper-${setting}-next`).remove();
					$productGrid.find('.swiper-slide-duplicate').remove();
					$productGrid.addClass('grid ' + columnClasses);

					// Undo all slider wrappers and restore original classes
					if ($productItem.hasClass("js-item-slide")) {
						$productGrid.unwrap();
						$productItem.removeClass('js-item-slide swiper-slide').removeAttr('style');
					} else {
						$productGrid.unwrap();
						$productItem.unwrap();
					}
				}

				// Toggle grid and slider mobile view
				handlers[`${setting}_products_format_mobile`] = new instaElements.Lambda(function(format){
					const toSlider = format == "slider";

					const mobileFormat = $productGrid.attr('data-mobile-format');
					const desktopFormat = $productGrid.attr('data-desktop-format');

					const desktopColumns = $productGrid.data('desktop-columns');
					const mobileColumns = $productGrid.data('mobile-columns');

					if ($productGrid.data('mobile-format') == format) {
						// Nothing to do
						return;
					}

					// From grid to slider
					if (toSlider) {

						$productGrid.attr('data-mobile-format', 'slider');

						// Convert grid to slider if it's not yet
						if ($productContainer.find('.swiper-slide').length < 1) {
							initSwiperElements();
						}

						if (desktopFormat == 'grid') {
							$productGrid.addClass('swiper-mobile-only flex-nowrap flex-md-wrap');
							if (window.innerWidth > 768) {
								$productGrid.addClass('transform-none');
							} else {
								$productGrid.removeClass('transform-none');
							}
						}

						if (desktopFormat == 'slider') {
							$productGrid.removeClass('swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 swiper-mobile-only flex-nowrap flex-md-wrap transform-none grid');
							$productContainer.find(`.js-swiper-${setting}-pagination`).removeClass('d-none');
							if (window.innerWidth < 768) {
								initSwiper();
							}
						}

					// From slider to grid
					} else {
						$productGrid.attr('data-mobile-format', 'grid');
						if (desktopFormat == 'slider') {
							// Mantain desktop slider
							$productGrid.removeClass('swiper-products-slider').addClass(`swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 grid grid-${mobileColumns} grid-md-${desktopColumns}`);
							if (window.innerWidth < 768) {
								$productGrid.addClass('transform-none');
								$productContainer.find(`.js-swiper-${setting}-pagination`).hide();
								$productContainer.find(`.js-swiper-${setting}-prev, .js-swiper-${setting}-next`).addClass('d-none');
								$productGrid.find('.swiper-slide-duplicate').remove();
								$productItem.removeAttr('style');
							} else {
								$productGrid.removeClass('transform-none');
							}
						} else {
							// Reset swiper settings
							resetSwiperElements();

							// Restore grid settings
							$productGrid.removeClass('swiper-wrapper swiper-mobile-only flex-nowrap flex-md-wrap transform-none').removeAttr('style');
							if (desktopFormat == 'grid' && mobileFormat == 'grid') {
								$productGrid.removeClass('swiper-wrapper swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 transform-none');
							}
						}
					}

					// Persist new format in data attribute
					$productGrid.data('mobile-format', format);
				});

				// Toggle grid and slider desktop view
				handlers[`${setting}_products_format_desktop`] = new instaElements.Lambda(function(format){
					const toSlider = format == "slider";

					const mobileFormat = $productGrid.attr('data-mobile-format');
					const desktopFormat = $productGrid.attr('data-desktop-format');

					const desktopColumns = $productGrid.data('desktop-columns');
					const mobileColumns = $productGrid.data('mobile-columns');

					if ($productGrid.data('desktop-format') == format) {
						// Nothing to do
						return;
					}

					// From grid to slider
					if (toSlider) {

						$productGrid.attr('data-desktop-format', 'slider');
						$productContainer.find(`.js-swiper-${setting}-prev, .js-swiper-${setting}-next`).removeClass('d-md-none');

						// Convert grid to slider if it's not yet
						if ($productContainer.find('.swiper-slide').length < 1) {
							initSwiperElements();
						}

						if (mobileFormat == 'grid') {
							$productGrid.addClass('swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0');
							if (window.innerWidth < 768) {
								$productGrid.addClass('transform-none');
								$productContainer.find(`.js-swiper-${setting}-pagination`).addClass('d-none');
							} else {
								$productGrid.removeClass('transform-none');
							}
						}

						if (mobileFormat == 'slider') {
							$productGrid.removeClass('swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 swiper-mobile-only flex-nowrap flex-md-wrap transform-none grid');
							if (window.innerWidth > 768) {
								$productContainer.find(`.js-swiper-${setting}-prev, .js-swiper-${setting}-next`).removeClass('d-none');
								$productContainer.find(`.js-swiper-${setting}-pagination`).removeClass('d-md-none');
								initSwiper();
							}
						}

					// From slider to grid
					} else {
						$productGrid.attr('data-desktop-format', 'grid');
						$productContainer.find(`.js-swiper-${setting}-prev, .js-swiper-${setting}-next`).addClass('d-md-none');
						if (mobileFormat == 'slider') {
							// Mantain mobile slider
							$productGrid.removeClass('swiper-products-slider').addClass(`swiper-mobile-only flex-nowrap flex-md-wrap grid grid-${mobileColumns} grid-md-${desktopColumns}`);
							if (window.innerWidth > 768) {
								$productGrid.addClass('transform-none');
								$productContainer.find(`.js-swiper-${setting}-pagination`).hide();
								$productContainer.find(`.js-swiper-${setting}-prev, .js-swiper-${setting}-next`).removeClass('d-md-block');
								$productGrid.find('.swiper-slide-duplicate').remove();
								$productItem.removeAttr('style');
							} else {
								$productGrid.removeClass('transform-none');
							}
						} else {
							// Reset swiper settings
							resetSwiperElements();

							// Restore grid settings
							$productGrid.removeClass('swiper-wrapper swiper-desktop-only flex-wrap flex-md-nowrap ml-md-0 transform-none').removeAttr('style');
							if (desktopFormat == 'grid' && mobileFormat == 'grid') {
								$productGrid.removeClass('swiper-wrapper swiper-mobile-only flex-nowrap flex-md-wrap transform-none');
							}
						}
					}

					// Persist new format in data attribute
					$productGrid.data('desktop-format', format);
				});
			});

			// ----------------------------------- Informative Banners -----------------------------------

			// Informative banners visibility
			function informativeContentVisibility(container){
				const hasContent = $(container).find('.js-informative-banner-title').text().trim() || 
						$(container).find('.js-informative-banner-description').text().trim();
				if(hasContent){
					$(container).show();
					$('.js-informative-banners-container').show();
				}else{
					$(container).hide();
				}
			}

			// Update section colors
			handlers.banner_services_colors = new instaElements.Lambda(function(sectionColor){
				const $container = $('.js-section-informative-banners');

				if (sectionColor) {
					$container.addClass('section-informative-banners-color');
				} else {
					$container.removeClass('section-informative-banners-color');
				}
			});

			// Map of icon code => icon svg
			var informativeBannersIconMap = {
				image: "image",
				shipping: "#truck",
				card: "#credit-card",
				security: "#security",
				returns: "#returns",
				whatsapp: "#whatsapp-line",
				promotions: "#promotions",
				cash: "#cash",
			};

			for (let i = 1; i <= 4; i++) {

				// Add html for image
				$(`.js-informative-banner-icon-${i}`).closest('.js-informative-banner-container').prepend(`<img class="js-informative-banner-img js-informative-banner-img-${i} service-item-image mb-3" style="display:none;"></img>`);

				// Add html for icon
				if ($(`.js-informative-banner-img-${i}`).attr('src')) {
					$(`.js-informative-banner-img-${i}`).closest('.js-informative-banner-container').prepend(`<div class="js-informative-banner-icon-${i} mb-3" style="display:none;"><svg class="icon-inline icon-2x svg-icon-text"><use xlink:href=""/></svg></div>`);
				}

				// Update icon for each informative banner
				handlers[`banner_services_0${i}_icon`] = new instaElements.Lambda(function(iconCode){
					if (!informativeBannersIconMap[iconCode]) {
						return;
					}
					if (informativeBannersIconMap[iconCode] == 'image') {
						$(`.js-informative-banner-icon-${i}`).hide();
						if ($(`.js-informative-banner-img-${i}`).attr('src')) {
							$(`.js-informative-banner-img-${i}`).show();
						}
					} else {
						$(`.js-informative-banner-icon-${i}`).show();
						$(`.js-informative-banner-img-${i}`).hide();
					}

					$(`.js-informative-banner-icon-${i} svg use`).attr('xlink:href', informativeBannersIconMap[iconCode]);
				});

				// Update image for each informative banner
				handlers[`banner_services_0${i}.jpg`] = new instaElements.Image({
					element: `.js-informative-banner-img-${i}`,
					show: function() {
						if ($(`.js-informative-banner-icon-${i}`).css('display') === 'none') {
							$(`.js-informative-banner-img-${i}`).show();
							$(`.js-informative-banner-icon-${i}`).hide();
						}
					},
					hide: function() {
						$(`.js-informative-banner-img-${i}`).hide();
					},
				});

				// Update title and description for each informative banner
				['title', 'description'].forEach(setting => {
					handlers[`banner_services_0${i}_${setting}`] = new instaElements.Text({
						element: `.js-informative-banner-${setting}-${i}`,
						show: function(){
							$(this).closest('.js-informative-banner-container').show();
							$(`.js-informative-banner-${setting}-${i}`).show();

							// Maybe show container now that there's content inside
							informativeContentVisibility($(this).closest('.js-informative-banner-container'));

							window.informativeBannersSwiper.params.observer = true;
							window.informativeBannersSwiper.update();
						},
						hide: function(){
							$(this).closest('.js-informative-banner-container');
							$(`.js-informative-banner-${setting}-${i}`).hide();

							// Maybe show container now that there's content inside
							informativeContentVisibility($(this).closest('.js-informative-banner-container'));

							window.informativeBannersSwiper.params.observer = true;
							window.informativeBannersSwiper.update();
						},
						
					});
				});

			}

			return handlers;
		}
	};
})(jQueryNuvem, LS.country);