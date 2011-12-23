jQuery ->
  $("#new_registration fieldset.guest :checkbox").on "change", (e)->
    if $(this).is(":checked")
      $(this).parents("fieldset.day").find("fieldset.events :checkbox").each (index, element)->
        $(element).prop("checked", false)

  $("#new_registration fieldset.events :checkbox").on "change", (e)->
    if $(this).is(":checked")
      $(this).parents("fieldset.day").find("fieldset.guest :checkbox").each (index, element)->
        $(element).prop("checked", false)

  # add header after each 15 rows
  header = $("#competitors thead").html()
  $("#competitors tbody tr:nth-child(15n)").after(header)