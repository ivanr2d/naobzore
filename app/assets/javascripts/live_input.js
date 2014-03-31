// filter any list items by passed field
jQuery.fn.extend({
  live_filter: function(config) {
    $(this).live('keyup', function() {
      var input = $(this).val();
      $(config.list).find(config.item).each(function() {
        var current = $(this).find(config.field).text();
        if (!current || current.indexOf(input) != -1) {
          $(this).show();
        } else {
          $(this).hide();
        }
      });
    });
  },
  live_search: function(config) {
    var timeout_id;
    $(this).live('keyup', function() {
      if (timeout_id) { 
        clearTimeout(timeout_id);
      }
      var url = (config.url || $(this).data('url'));
      if (url.indexOf('?') > -1) {
        url += '&q=' + $(this).val();
      } else {
        url += '?q=' + $(this).val();
      }
      timeout_id = setTimeout(function() {
        $.get(url, function(data) {
          if (config.complete) {
            config.complete(data);
          }
        })
      }, config.delay || 500);
    });
  },
  live_mask: function(mask) {
    $(this).live('keypress', function(event) {
      if (!mask.test($(this).val() + String.fromCharCode(event.charCode))) {
        return false;
      }
    });
  }
});
