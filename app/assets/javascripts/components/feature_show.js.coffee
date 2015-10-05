$ ->
  Vue.component 'featureShow',
    template: '#feature_show'
    inherit: true
    data: ->
      featureId: undefined
      feature: undefined
      featureEdit: undefined
      editMode: false
    watch:
      featureId: (val) -> @getFeature(val)
    methods:
      toggleEditMode: (e) ->
        e.preventDefault()
        @editMode = !@editMode
      back: (e) ->
        e.preventDefault()
        page 'featureList'
      submit: (e)->
        try
          e.preventDefault()
          submit = $('#feature_show_submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/features/#{@featureId}.json"
            type: 'PATCH'
            data:
              feature:
                title:  @featureEdit.title
                point:  @featureEdit.point
                status: @featureEdit.status
          .done (response) =>
            toastr.success('', response.message)
            # @dispatcher.trigger('features.get', {project_id: @projectId, id: response.id})
            @getFeature(response.id)
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
      getFeature: (featureId) ->
        $.ajax "/api/features/#{featureId}.json"
          .done (response) =>
            @feature = response
            @featureEdit = $.extend(true, {}, @feature)
          .fail (response) =>
            console.error response

