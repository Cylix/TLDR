$(document).on('turbolinks:load', function () {

  var display_alert = function (msg, color) {
    $('#categories_form_modal .modal-body').prepend("\
            <div class='alert alert-" + color + "' role='alert'>\
              <button class='close' type='button' data-dismiss='alert' aria-label='Close'>\
                <span aria-hidden='true'>&times;</span>\
              </button>\
              " + msg + "\
            </div>");
  };

  var get_category_html_item = function (category) {
    return "\
      <li class='nav-item'>\
        <a class='nav-link' href='/categories/" + category.id + "'>" +
          "<i class='fa fa-tag'></i>" +
          category.name +
          "</a>\
      </li>\
    ";
  }

  var display_category = function (category) {
    //! remove empty category message
    $('#empty_category').remove();

    //! fetch categories
    var categories_div = $('#categories');
    var categories     = $('#categories li');
    var insertAfter    = null;

    for (i = 0; i < categories.length; i += 1) {
      if ($(categories[i]).text() < category.name) {
        insertAfter = categories[i];
      }
      else {
        break;
      }
    }

    //! handle no categories or category has first position
    if (insertAfter == null) {
      categories_div.prepend(get_category_html_item(category));
    }
    //! otherwise, insertAfter
    else {
      $(get_category_html_item(category)).insertAfter($(insertAfter));
    }
  }

  //! success
  $('#new_category').on('ajax:success', function (e, data, status, xhr) {
    display_category(data.category);
    $('#categories_form_modal').modal('hide')
  });

  //! failure
  $('#new_category').on('ajax:error', function (e, data, status, xhr) {
    for (i = 0; i < data.responseJSON['message'].length; i += 1) {
      //! skip user is invalid error
      if (data.responseJSON['message'][i].indexOf("invalid") != -1) {
        continue ;
      }

      display_alert(data.responseJSON['message'][i], 'danger');
    }
  });

  //! on modal opened
  $('#categories_form_modal').on('show.bs.modal', function (e) {
    $('#category_name').val('');
    $('#categories_form_modal .alert').remove();
  });

});
