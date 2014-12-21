class Fdbk
  element: null

  constructor: (tag) ->
    iframe = document.createElement 'iframe'
    iframe.src = 'http://localhost:3001/feedbacks/new?v=part' + if tag? then '&t=' + tag else ''

    @element = document.createElement 'pocket-4d'
    @element.append iframe
    document.body.appendChild @element

    window.addEventListener 'message', @onMessageReceive.bind(@)

  open: ->
    @element.open()
    @element.focus()

  close: ->
    @element.close()
    @element.blur()

  onMessageReceive: (event) ->
    if event.data is 'close'
      @close()


window.Fdbk = Fdbk
