$(function() {
  function set_cost_disabled() {
    if ($('#delivety_free').attr('checked')) {
      $('#delivety_cost').attr('disabled', 'disabled');
    } else {
      $('#delivety_cost').removeAttr('disabled');
    }
  }

  $('#delivety_free').change(function() {
    set_cost_disabled();
  });

  set_cost_disabled();
});
