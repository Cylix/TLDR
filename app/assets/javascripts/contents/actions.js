$(document).on('turbolinks:load', function () {

  var display_alert = function (msg, color) {
    $('#flash_messages').append("\
            <div class='alert alert-" + color + "' role='alert'>\
              <button class='close' type='button' data-dismiss='alert' aria-label='Close'>\
                <span aria-hidden='true'>&times;</span>\
              </button>\
              " + msg + "\
            </div>");
  };

  var get_content_card = function(inner_elem) {
    return inner_elem.parents('.card');
  };

  $('.pin_btn')
    .bind('ajax:success', function(evt, data, status, xhr) {
      var card = get_content_card($(this));
      card.find('.pin_btn i').toggleClass('text-info', data.content.is_pinned);

      if (data.content.is_pinned)
        $(this).attr('href', $(this).attr('href').replace(/true/g, 'false'));
      else
        $(this).attr('href', $(this).attr('href').replace(/false/g, 'true'));

      card.toggleClass('pinned', data.content.is_pinned);
    })
    .bind('ajax:error', function(evt, data, status, xhr) {
    });

  $('.done_btn')
    .bind('ajax:success', function(evt, data, status, xhr) {
      var card = get_content_card($(this));
      card.find('.done_btn i').toggleClass('text-success', data.content.status == 'done');
      card.find('.snooze_btn i').toggleClass('text-warning', data.content.status == 'snoozed');
      card.find('.trashed_btn i').toggleClass('text-danger', data.content.status == 'trashed');
      card.fadeOut(800, function() { card.remove() });
    })
    .bind('ajax:error', function(evt, data, status, xhr) {
    });

  $('.trashed_btn')
    .bind('ajax:success', function(evt, data, status, xhr) {
      var card = get_content_card($(this));
      card.find('.done_btn i').toggleClass('text-success', data.content.status == 'done');
      card.find('.snooze_btn i').toggleClass('text-warning', data.content.status == 'snoozed');
      card.find('.trashed_btn i').toggleClass('text-danger', data.content.status == 'trashed');
      card.fadeOut(800, function() { card.remove() });
    })
    .bind('ajax:error', function(evt, data, status, xhr) {
    });

  $('.categorize_btn')
    .bind('ajax:success', function(evt, data, status, xhr) {
      $(this).parents('.dropdown.show').removeClass('show');
      $(this).parents('.dropdown').find('i').addClass('text-success');
      $(this).parents('.dropdown').find('.category_name').text(data.category.name);
      $(this).parents('.card').find('.category_link').html("\
        <i class='fa fa-fw fa-tag'></i>\
        <a class='text-muted' href='/categories/" + data.category.id + "/contents'>\
          " + data.category.name + "\
        </a>\
      ");
    })
    .bind('ajax:error', function(evt, data, status, xhr) {
      for (i = 0; i < data.responseJSON['message'].length; i += 1) {
        display_alert(data.responseJSON['message'][i], 'danger');
      }
    });

  var togglePinContents = function (showOnlyPin) {
    $('.card.content').not('.pinned').toggle(!showOnlyPin);
  }

  $('.switch input').on('change', function () {
    togglePinContents($(this).is(':checked'))
  })

});
