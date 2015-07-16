(($) ->
  'use strict'

  HHSelect2 = ->
    @pageScrollElement = 'html, body'
    @$body = $('body')
    return

  HHSelect2::autoSelect = ->
    try
      $('.auto-select').each ->
        select = $(this)
        init_data = select.data('init')
        tag_limit = select.data('tag-limit')
        $(select).select2
          minimumInputLength: 2
          placeholder: select.data('placeholder')
          tags: true
          maximumSelectionSize: tag_limit
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

  HHSelect2::autoSelectID = ->
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
                  value: item.id
                  id: item.id
                }
              ) }
          id: (object) ->
            object.id
          initSelection: (element, callback) ->
            data = {
                id: Math.random()
                text: init_data
              }

            callback data
            return
    catch e

  # Call initializers

  HHSelect2::init = ->
    # init layout
    @autoSelectID()
    @autoSelect()
    return

  $.HHSelect2 = new HHSelect2
  $.HHSelect2.Constructor = HHSelect2
  return
) window.jQuery

(($) ->
  'use strict'
  # Initialize layouts and plugins
  $.HHSelect2.init()
  return
) window.jQuery