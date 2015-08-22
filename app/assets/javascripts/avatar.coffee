jQuery(document).ready ->
  $('#trigger-file-upload').click (e) ->
    e.preventDefault()
    $(this).attr 'disabled', 'true'
    $('input[id=profile_photo]')[0].click()
    $('input[id=profile_photo]').on 'change', (e) ->
      e.preventDefault()
      $('.school-logo.placeholder-logo').addClass('absolute')
      $('.upload_icon').html("<i class='fa fa-spinner fa-spin text-master'></i>")
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

