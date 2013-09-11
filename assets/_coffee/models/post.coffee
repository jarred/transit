Transit.Models.PostModel = Backbone.Model.extend

	initialize: ->
		_.bindAll @

	cleanUp: ->
		@set 'tags', _.compact @get('tags')
		
		if @get('type') == 'photoset'
			photos = _.compact @get('photos')
			@set 'photos', photos

		@set 'date', new Date(@get('date'))