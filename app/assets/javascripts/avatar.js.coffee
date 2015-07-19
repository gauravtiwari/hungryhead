jQuery(document).ready ->
  $('#trigger-file-upload').on 'click', (e) ->
    e.preventDefault()
    $('input[id=profile_photo]')[0].click()
    $('input[id=profile_photo]').on 'change', (e) ->
      e.preventDefault()
      reader = new FileReader
      file = e.target.files[0]
      reader.onload = ((upload) ->
        $('#profile_photo_preview').attr 'src', upload.target.result
        return
      ).bind(this)
      reader.readAsDataURL file
      $('#profile_photo_form').ajaxSubmit
        'type': 'PUT'
        beforeSubmit: (a, f, o) ->
          o.dataType = 'script'
          return
      return
    return

