jQuery(document).ready ->
  $('#trigger-file-upload').on 'click', (e) ->
    e.preventDefault()
    $('input[id=profile_photo]').click()
    return

  $form = $('#profile_photo_form :input')
  $form.on 'change input', (e) ->
    e.preventDefault()
    reader = new FileReader
    file = e.target.files[0]
    reader.onload = ((upload) ->
      $('#userpic_preview').attr 'src', upload.target.result
      $('#user_pic_mini').attr 'src', upload.target.result
      $('#user_pic_menu').attr 'src', upload.target.result
      return
    ).bind(this)
    reader.readAsDataURL file
    $('#profile_photo_form').ajaxSubmit
      'type': 'PUT'
      beforeSubmit: (a, f, o) ->
        o.dataType = 'json'
        return
      complete: (XMLHttpRequest, textStatus) ->
        response = JSON.parse(XMLHttpRequest.responseText)
        $('#user_pic_mini').attr 'src', response.user.avatar.url
        $('#user_pic_menu').attr 'src', response.user.avatar.url
        $('#userpic_preview').attr 'src', response.user.avatar.url
        return
    return
