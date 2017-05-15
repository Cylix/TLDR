$(document).on('turbolinks:load', function () {

  var display_alert = function (msg, color) {
    $('#flash_messages').append("\
            <div class='alert alert-" + color + "' role='alert'>\
              <button class='close' type='button' data-dismiss='alert' aria-label='Close'>\
                <span aria-hidden='true'>&times;</span>\
                " + msg + "\
              </button>\
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
        $(this).attr('href', $(this).attr('href').replace(/true/g, 'false'))
      else
        $(this).attr('href', $(this).attr('href').replace(/false/g, 'true'))
    })
    .bind('ajax:error', function(evt, data, status, xhr) {
    });

  $('.done_btn')
    .bind('ajax:success', function(evt, data, status, xhr) {
      var card = get_content_card($(this));
      card.find('.done_btn i').toggleClass('text-success', data.content.category == 'done');
      card.find('.snooze_btn i').toggleClass('text-warning', data.content.category == 'snoozed');
      card.find('.trashed_btn i').toggleClass('text-danger', data.content.category == 'trashed');
      card.fadeOut(800, function() { card.remove() });
    })
    .bind('ajax:error', function(evt, data, status, xhr) {
    });

  $('.trashed_btn')
    .bind('ajax:success', function(evt, data, status, xhr) {
      var card = get_content_card($(this));
      card.find('.done_btn i').toggleClass('text-success', data.content.category == 'done');
      card.find('.snooze_btn i').toggleClass('text-warning', data.content.category == 'snoozed');
      card.find('.trashed_btn i').toggleClass('text-danger', data.content.category == 'trashed');
      card.fadeOut(800, function() { card.remove() });
    })
    .bind('ajax:error', function(evt, data, status, xhr) {
    });

});
