$(document).on('turbolinks:load', function () {

  var toggle_type_specific_fields = function () {
    //! hide all type specific fields
    $('.type_specific_field').hide();

    //! display fields corresponding to new type
    var type = $('#source_type').val();
    window.fields_by_source_type[type].forEach(function (field) {
      $('#source_' + field).parents('.form-group').show();
    });
  }

  if ($('#source_type').length) {
    //! bind source_type select tag 'on change' event to the toggle function
    $('#source_type').on('change', toggle_type_specific_fields);

    //! toggle fields for initial state
    toggle_type_specific_fields();
  }

});
