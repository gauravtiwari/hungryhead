jQuery(document).ready ->
  $(document).on 'click', '#trigger-file-upload', (e) ->
    e.preventDefault()
    $('input[id=profile_photo]')[0].click()
    $('input[id=profile_photo]').on 'change', (e) ->
      e.preventDefault()
      $('.upload_icon').html("<i class='fa fa-spinner fa-spin text-white'></i>")
      reader = new FileReader
      file = e.target.files[0]
      reader.onload = ((upload) ->
        $('#profile_photo_preview').removeAttr('data-src')
        $('#profile_photo_preview').removeAttr('data-src-retina')
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

