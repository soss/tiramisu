# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('a.vote').on 'click', (e) ->
    e.preventDefault()
    $t = $(this)
    $.ajax
      url: '/votes'
      type: 'post'
      data: { vote : { project_id : $t.data('project') } }
      dataType: 'json'
      success: ->
        $t.hide()

