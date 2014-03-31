$(function() {
  // Дерево категорий
  $('table.treetable').treetable({ expandable: true });

  // Добавление категории
  $('.add-parent-category').live('click', function() {
    var category = $(this).closest('.category').clone().appendTo('#parent_categories');
    $(this).attr('class', 'del-parent-category').text('Удалить');
  });

  // Удаление категории
  $('.del-parent-category').live('click', function() {
    $(this).closest('.category').remove();
  });
});
