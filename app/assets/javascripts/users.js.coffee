root = exports ? this

root.setCreateUserForm = ->
  selectPasswordCreationMode()


selectPasswordCreationMode = ->
  $(document).on 'change', '#select-password-creation-mode input:radio', ->
    value = $("#select-password-creation-mode input[type='radio']:checked").val()
    if (value == 'manual')
      $('#password-manual-creation').show()
    else
      $('#password-manual-creation').hide()
