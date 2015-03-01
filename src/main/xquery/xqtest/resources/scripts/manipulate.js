var divIds = new Array();

$(document).ready( function () {
    $(".single-failure").each(
      function (index) {
        var id = $(this).parent().attr("id")
        if($.inArray(id, divIds) == -1) {
          divIds.push(id)
        }
      }
    );
    for(i = 0;i < divIds.length;i++) {
      $('#'.concat(divIds[i])).appendTo("#failed-tests")
    }
    if(divIds.length > 0) {
      $("#failed-tests").css("border", "solid 1px red")
    }
  }
)
