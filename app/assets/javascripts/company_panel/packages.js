$(function(){
  $('.packet .activate').die().live('click', function(){
    var packet = $(this).parents('.packet');
    if (packet.find('.accept-conditions').attr('checked')) {
      if (confirm('Подключить ' + packet.find('.title').text() + '?')) {
        $(this).parents('form').submit();
      }
    } else {
      alert('Для подключения пакеты примите условия договора-оферты');
    }
  });

  $('.packet.active :checkbox.auto').live('change', function() {
    if ($(this).attr('checked')) {
      if (confirm('Включить автопродление пакета?')) {
        $.post('/company_panel/companies_packages/' + $(this).data('companies_package_id') + '/set_auto.js', {auto:1});
      }
    } else {
      if (confirm('Отключить автопродление пакета?')) {
        $.post('/company_panel/companies_packages/' + $(this).data('companies_package_id') + '/set_auto.js', {auto:0});
      }
    }
  });
});
