# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:load", ->
  enableMarkdownPreview()
  enableEventListener()

enableMarkdownPreview = ->
  $('a[href=#preview]').on 'shown.bs.tab', ->
    data = {
      content: $('#write textarea').val()
    }

    $.post('/api/v1/markdown', data).done (html) ->
      $('#markdown').html html

enableEventListener = ->
  if location.search.indexOf('v=part') isnt -1
    document.addEventListener 'keydown', onKeyDown, true

  document.querySelector('#partCapture')?.addEventListener 'click', ->
    sendMessage 'capture'
  document.querySelector('#partCancel')?.addEventListener 'click', ->
    sendMessage 'close'

  window.addEventListener 'message', onMessageReceive

onKeyDown = (event) ->
  if event.keyCode is 27
    sendMessage 'close'

sendMessage = (message) ->
  window.parent.postMessage message, '*'

onMessageReceive = (event) ->
  image = document.createElement 'img'
  image.src = event.data
  image.classList.add 'screen-capture'

  document.querySelector('#image-upload').appendChild image
