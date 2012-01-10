jQuery ->
  # add header after each 15 rows
  header = $("#competitors thead").html()
  $("#competitors tbody tr:nth-child(15n)").after(header)

  # redirect to selected event
  $("#compare #event_id").on "change", (e) ->
    window.location.href = e.target.value