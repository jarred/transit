Transit.Views.PhotosetView = Backbone.View.extend
	
	initialize: ->
		_.bindAll @
		@render()

	photoTemplate: _.template """
	<div class="cell">
		<div class="image"><img src="<%= src %>" /></div>
	</div>
	"""

	render: ->
		photoset = ""
		console.log @model.get('layout')
		rowCount = 0
		row = 0
		photoset += "<div class=\"row row_size_#{@model.get('layout')[0]}\">"
		_.each @model.get('photos'), (photo, index, all) =>
			photoset += @photoTemplate photo
			rowCount++
			if rowCount >= Number(@model.get('layout')[row])
				row++
				rowCount = 0
				if index < all.length - 1
					photoset += "<div class=\"clearfix\"></div></div><div class=\"row row_size_#{@model.get('layout')[row]}\">"
		photoset += "<div class=\"clearfix\"></div></div>"
	
		@$el.html photoset