Transit.Views.PhotoView = Backbone.View.extend

	initialize: ->
		_.bindAll @
		if @model.get('photos')[0].width < @model.get('photos')[0].height
			@$el.addClass 'landscape'
			@$('.image_hold').attr 'class', 'image_hold grid_col_4'