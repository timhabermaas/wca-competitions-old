jQuery ->
  $("#registration_participant_attributes_wca_id").autocomplete(
    minLength: 4
    source: (request, response) ->
      $.ajax(
        url: "http://localhost:9292/persons/" # TODO move url
        dataType: "jsonp"
        data:
          search: request.term
        success: (data, textStatus, muh) ->
          result = ({label: "#{entry.person.id} (#{entry.person.name}, #{entry.person.countryId})", value: entry.person.id, name: entry.person.name, country: entry.person.countryId, gender: entry.person.gender} for entry in data)
          response(result)
      )
    select: (event, ui) ->
      names = ui.item.name.split(" ")
      first_name = names[0]
      last_name = names.slice(1, names.length).join(" ") # TODO handle chinese characters
      $("#registration_participant_attributes_first_name").val(first_name)
      $("#registration_participant_attributes_last_name").val(last_name)
      $("#registration_participant_attributes_country").val(ui.item.country)
      $("#registration_participant_attributes_gender_#{ui.item.gender}").attr("checked", true)
  )
  # TODO http://jqueryui.com/demos/autocomplete/#custom-data to support html as label
  #.data("autocomplete")._renderItem = (ul, item) ->
  #  $("<li>#{item.value} (<strong>#{item.name}</strong>, #{item.country})</li>").appendTo(ul)