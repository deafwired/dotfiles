{ config, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;

      userContent = ''
        @-moz-document url(about:newtab), url(about:home) {
          body {
            background-color: ${config.lib.stylix.colors.withHashtag.base00} !important;
          }

          /* Hide everything — search bar, logo, top sites, highlights, weather */
          .logo-and-wordmark,
          .search-wrapper,
          .search-handoff-button,
          .top-sites,
          .sections-list,
          .collapsible-section,
          .non-collapsible-section,
          .newtab-weather-wrapper,
          .weather-widget {
            display: none !important;
          }
        }
      '';

      settings = {
        # Required for userContent.css / userChrome.css to load
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Privacy & tracking protection (strict mode)
        "browser.contentblocking.category" = "strict";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;
        "privacy.bounceTrackingProtection.mode" = 1;
        "privacy.donottrackheader.enabled" = true;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        # Network hardening
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;
        "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
        "network.lna.blocking" = true;

        # New tab / home
        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 2;

        # Urlbar
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;

        # Downloads — ask where to save each time
        "browser.download.useDownloadDir" = false;

        # Passwords — don't save
        "signon.rememberSignons" = false;

        # UI
        "accessibility.typeaheadfind.flashBar" = 0;
        "browser.toolbars.bookmarks.visibility" = "always";
        "general.autoScroll" = true;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "svg.context-properties.content.enabled" = true;

        # Media
        "media.eme.enabled" = true;

        # PDF viewer
        "pdfjs.defaultZoomValue" = "page-width";

        # Reader mode (color_scheme comes from stylix)
        "reader.content_width" = 5;

        # AI chat — set to Claude
        "browser.ml.chat.provider" = "https://claude.ai/new";

        # Firefox IP protection
        "browser.ipProtection.enabled" = true;

        # Allow popups from scripts
        "dom.disable_open_during_load" = false;
      };
    };
  };
}
