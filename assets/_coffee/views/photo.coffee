Transit.Views.PhotoView = Backbone.View.extend

	initialize: ->
		_.bindAll @
		if @model.get('photos')[0].width < @model.get('photos')[0].height
			@$el.addClass 'portrait'
			@$('.image').attr 'class', 'image grid_col_4'
			@$('.description').attr 'class', 'description grid_col_3'