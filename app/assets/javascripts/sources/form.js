$(function () {

  'use strict';

  var previous_type = $('#source_type').val();

  var toggle_type_specific_fields = function () {
    //! hide fields corresponding to previous type
    window.fields_by_source_type[previous_type].forEach(function (field) {
      $('#source_' + field).parents('.form-group').hide();
    });

    //! display fields corresponding to new type
    var current_type = $('#source_type').val();
    window.fields_by_source_type[current_type].forEach(function (field) {
      $('#source_' + field).parents('.form-group').show();
    });

    //! update value of previous_type variable for next call
    previous_type = current_type;
  }

  //! bind source_type select tag 'on change' event to the toggle function
  $('#source_type').on('change', toggle_type_specific_fields);

  //! toggle fields for initial state
  toggle_type_specific_fields();

});
