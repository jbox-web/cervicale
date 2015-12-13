# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require_tree .

loadSbadmin2Menu = ->
  $('#side-menu').metisMenu()
  $("#sidebar-search").prependTo("#side-menu")
  $('.destroy-me').remove()


resizeSbadmin2Page = ->
  topOffset = 50
  if window.innerWidth > 0
    width = window.innerWidth
  else
    width = this.screen.width

  if width < 768
    $('div.navbar-collapse').addClass('collapse')
    topOffset = 100
  else
    $('div.navbar-collapse').removeClass('collapse')

  if window.innerHeight > 0
    height = window.innerHeight - 1
  else
    height = this.screen.height - 1

  height = height - topOffset
  if height < 1
    height = 1

  if height > topOffset
    $('#page-wrapper').css('min-height', height + 'px')

  $('.navbar-default.sidebar').each ->
    $('#page-wrapper').css('margin-left', '0px') if $(this).children().length == 0


$(document).on('ready page:change', loadSbadmin2Menu)
$(document).on('page:change resize', resizeSbadmin2Page)
