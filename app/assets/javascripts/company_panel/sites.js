$(function() {
  $('#site_yandex_metrics_number').mask('99999?99999');
  $('#site_google_analytics_number').mask('UA-99999999-9');
  $('#site_google_webmaster_code').mask('99999?99999');

  $('#copy_sitemap').zclip({
    path: "/ZeroClipboard.swf",
    copy: function(){
      return $('#sitemap').text();
    }
  });
});
