initRadioButtons = (delegateFor) ->
  delegateFor.delegate ".status-buttons .radio input,.buttons .radio input", "change", () ->
    buttons = $(this).parents('.status-buttons,.buttons').first()
    buttons.find('.btn').removeClass('checked')
    $(this).parents('.btn:first').addClass('checked')

uniformify = (node) ->
  $("input:checkbox, input:radio, input:file, input:text, textarea, submit", node).uniform()

initOrganPage = (delegateFor) ->
  initToggleArchived = () ->
    toggleArchived = (visible) ->
      $('.archived-call-for-applications').toggle visible
      $('.hide-archived').toggle visible
      $('.show-archived').toggle not visible

    delegateFor.delegate ".show-archived", "click", () ->
      toggleArchived true
      return false

    delegateFor.delegate ".hide-archived", "click", () ->
      toggleArchived false
      return false

  initCallSelectionDragNDrops = () ->
    onSameCall = (elem1, elem2) ->
      getCallFormId = (elem) ->
        elem.parents('.call-for-application:first').find('form.edit_call').attr('id')
      getCallFormId(elem1) == getCallFormId(elem2)

    saveSelection = (droppable, draggable) ->
      form = draggable.find('form')
      member = form.find('#position_application_member')
      deputy = form.find('#position_application_deputy')
      member.val ''
      deputy.val ''
      if droppable.hasClass 'deputy'
        member.val droppable.prevAll('.member:first').find('.member-card').data('id')
      else if droppable.hasClass 'member'
        deputy.val droppable.nextAll('.deputy:first').find('.member-card').data('id')
      form.find('#position_application_position').val droppable.data('name')
      superagent.post(form.attr 'action').
        type('form-data').
        send(form.serialize()).
        end()

    alignApplicants = (droppable) ->
      applicants = droppable.parents('.call-for-application').find('.applicants')
      applicants.find('.member-card:even').removeClass('no-margin')
      applicants.find('.member-card:odd').addClass('no-margin')

    $('.call-for-application.open .member-card').draggable
      revert: 'invalid'

    $('.call-for-application.open .applicants').droppable
      activeClass: 'highlight-return-area'
      drop: (event, ui) ->
        droppable = $(@)
        $(@).append(ui.draggable.removeAttr('style'))
        alignApplicants(droppable)
        saveSelection(droppable, ui.draggable)
      accept: (draggable) ->
        return false unless draggable.hasClass 'member-card'
        onSameCall $(@), draggable

    $('.call-for-application.open .member-card-empty').droppable
      activeClass: 'highlight-drop-area'
      accept: (draggable) ->
        return false unless draggable.hasClass 'member-card'
        return false if $(@).find('.member-card').length > 0
        return false if $(@).hasClass('no-deputy')
        onSameCall $(@), draggable
      drop: (event, ui) ->
        droppable = $(@)
        droppable.prepend(ui.draggable)
        ui.draggable.position
          my: "top left"
          at: "top left"
          of: droppable
        saveSelection(droppable, ui.draggable)
        alignApplicants(droppable)

  initToggleArchived()
  initCallSelectionDragNDrops()


initPopups = (delegateFor) ->
  delegateFor.delegate "a.popup", "click", () ->
    window.open $(this).prop 'href'
    return false

window.initDom = (selector) ->
  node = $(selector)
  uniformify node
  initRadioButtons node
  initOrganPage node
  initPopups node
  return node

