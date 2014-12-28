MouseState =
  RELEASED: 0
  PRESSED: 1
  AREA_PRESSED: 2

class Fdbk
  element: null
  cover: null
  area: null
  target: null

  mouseState: MouseState.RELEASED
  mouseX: 0
  mouseY: 0
  areaLocation: []

  constructor: (tag, target) ->
    base_url = 'http://localhost:3001/feedbacks/new'
    query = '?v=part' + '&u=' + location.href + if tag? then '&t=' + tag else ''

    iframe = document.createElement 'iframe'
    iframe.src = base_url + query

    @element = document.createElement 'pocket-4d'
    @element.append iframe
    document.body.appendChild @element

    window.addEventListener 'message', @onMessageReceive.bind(@)

    @onMouseDown = @onMouseDown.bind(@)
    @onMouseMove = @onMouseMove.bind(@)
    @onMouseUp = @onMouseUp.bind(@)

    @target = target

  open: ->
    @element.open()
    @element.focus()

    @target?.classList.add 'fdbk-hidden'

  close: ->
    @element.close()
    @element.blur()

    @target?.classList.remove 'fdbk-hidden'

  selectArea: (srcWin) ->
    @close()

    self = @
    button = document.createElement 'button'
    button.id = 'fdbk-capture-button'
    button.innerText = 'Capture'
    button.addEventListener 'click', (event) ->
      self.capture srcWin, ->
        self.cover.remove()
        self.open()

    button_c = document.createElement 'button'
    button_c.id = 'fdbk-cancel-button'
    button_c.innerText = 'Cancel'
    button_c.addEventListener 'click', ->
      self.cover.remove()
      self.open()

    buttons = document.createElement 'div'
    buttons.id = 'fdbk-capture-buttons'
    buttons.appendChild button
    buttons.appendChild button_c

    @area = document.createElement 'div'
    @area.id = 'fdbk-capture-area'

    @cover = document.createElement 'div'
    @cover.id = 'fdbk-cover'
    @cover.style.height = document.body.scrollHeight + 'px'
    @cover.addEventListener 'mousedown', @onMouseDown
    @cover.addEventListener 'mousemove', @onMouseMove
    @cover.addEventListener 'mouseup', @onMouseUp
    @cover.appendChild @area
    @cover.appendChild buttons
    document.body.appendChild @cover

  onMouseDown: (event) ->
    # If button is pressed, skip this method
    if event.target.id.indexOf('button') isnt -1
      return

    @mouseX = event.clientX
    @mouseY = event.clientY + document.body.scrollTop

    if event.target isnt @area
      @mouseState = MouseState.PRESSED
      @moveArea @mouseX, @mouseY, @mouseX, @mouseY
    else
      @mouseState = MouseState.AREA_PRESSED

  onMouseMove: (event) ->
    if @mouseState is MouseState.PRESSED
      x = event.clientX
      y = event.clientY + document.body.scrollTop
      [x0, x1] = if @mouseX < x then [@mouseX, x] else [x, @mouseX]
      [y0, y1] = if @mouseY < y then [@mouseY, y] else [y, @mouseY]

      @moveArea x0, y0, x1, y1

      @areaLocation = [x0, y0, x1, y1]

    else if @mouseState is MouseState.AREA_PRESSED
      dx = event.clientX - @mouseX
      dy = event.clientY - @mouseY + document.body.scrollTop

      [x0, y0, x1, y1] = @areaLocation
      x0 += dx
      x1 += dx
      y0 += dy
      y1 += dy

      @moveArea x0, y0, x1, y1

  onMouseUp: (event) ->
    if @mouseState is MouseState.AREA_PRESSED
      dx = event.clientX - @mouseX
      dy = event.clientY - @mouseY + document.body.scrollTop

      @areaLocation[0] += dx
      @areaLocation[1] += dy
      @areaLocation[2] += dx
      @areaLocation[3] += dy

    @mouseState = MouseState.RELEASED

  moveArea: (x0, y0, x1, y1) ->
    @area.style.left = x0 + 'px'
    @area.style.top = y0 + 'px'
    @area.style.width = (x1 - x0) + 'px'
    @area.style.height = (y1 - y0) + 'px'

  capture: (src, callback) ->
    html2canvas(document.body).then (canvas) ->
      x = document.body.scrollLeft
      y = document.body.scrollTop
      w = window.innerWidth
      h = window.innerHeight

      dstCanvas = document.createElement 'canvas'
      dstCanvas.width = w
      dstCanvas.height = h

      context = dstCanvas.getContext '2d'
      context.drawImage canvas, x, y, w, h, 0, 0, w, h

      image = dstCanvas.toDataURL 'image/png'
      src.postMessage image, '*'

      if callback?
        callback()

  onMessageReceive: (event) ->
    switch event.data
      when 'capture' then @selectArea event.source
      when 'close'   then @close()


window.Fdbk = Fdbk
