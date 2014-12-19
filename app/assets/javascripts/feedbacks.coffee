# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "ready page:load", ->
  enableMarkdownPreview()
  enableEscKeyToCancel()

enableMarkdownPreview = ->
  $('a[href=#preview]').on 'shown.bs.tab', ->
    data = {
      content: $('#write textarea').val()
    }

    $.post('/api/v1/markdown', data).done (html) ->
      $('#markdown').html html

enableEscKeyToCancel = ->
  if location.search.indexOf('v=part') isnt -1
    document.addEventListener 'keydown', onKeyDown, true

onKeyDown = (event) ->
  if event.keyCode is 27
    window.parent.postMessage 'close', '*'
