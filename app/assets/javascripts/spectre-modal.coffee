initMemberModal = ->
	$('.member-modal-save').on('click', ->
		$('#case-save').click())

	$('.modal .member-close').on('click', ->
		$('.modal').removeClass('active'))

	$('.close-modal').on('click', ->
		$('.modal').removeClass('active'))

	$('.open-member-modal').each( (index) ->
		modal_id = "member-modal-" + index
		$(this).attr("data-target", "#" + modal_id)
		member_modal = $('.member-modal')[index]
		$(member_modal).attr("id", modal_id)
		console.log member_modal)

	$('.open-member-modal').on('click', (event) ->
		console.log('opening', $(event.target).data('target'))
		modal_id = $(event.target).data('target')
		console.log('modal id', modal_id)
		$(modal_id).addClass('active'))

$ ->
	initMemberModal()

$(document).on "fields_added.nested_form_fields", (event, param) ->
  initMemberModal()