$(document).ready ->
  try
    $('.auto-select').each ->
      select = $(this)
      init_data = select.data('init')
      $(select).select2
        minimumInputLength: 2
        placeholder: select.data('placeholder')
        tags: true
        maximumSelectionSize: 3
        ajax:
          url: select.data('url')
          dataType: 'json'
          type: 'GET'
          cache: true
          quietMillis: 50
          data: (term) ->
            { term: term }
          results: (data) ->
            { results: $.map(data, (item) ->
              {
                text: item.label
                value: item.value
                id: item.id
              }
            ) }
        id: (object) ->
          object.text
        initSelection: (element, callback) ->
          data = init_data.map((tag) ->
            {
              id: Math.random()
              text: tag
            }
          )
          callback data
          return
  catch e


  try
    $('.auto-select-id').each ->
      select = $(this)
      init_data = select.data('init')
      $(select).select2
        minimumInputLength: 2
        placeholder: select.data('placeholder')
        ajax:
          url: select.data('url')
          dataType: 'json'
          type: 'GET'
          cache: true
          quietMillis: 50
          data: (term) ->
            { term: term }
          results: (data) ->
            { results: $.map(data, (item) ->
              {
                text: item.label
                value: item.value
                id: item.id
              }
            ) }
        id: (object) ->
          object.text
        initSelection: (element, callback) ->
          data = {
              id: Math.random()
              text: init_data
            }

          callback data
          return
  catch e