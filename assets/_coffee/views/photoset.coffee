Transit.Views.PhotosetView = Backbone.View.extend
	
	initialize: ->
		_.bindAll @
		@render()

	render: ->
		photoset = ""
		console.log @model.get('layout')
		rowCount = 0
		row = 0
		photoset += "<div class=\"row\">"
		_.each @model.get('photos'), (photo) =>
			photoset += """
			<div class="photo">
				<img src="#{photo.src}" />
			</div>
			"""
			console.log 'rowCount', rowCount
			console.log 'row', row
			console.log Number(@model.get('layout')[row])
			if rowCount >= Number(@model.get('layout')[row])
				photoset += "</div><div class=\"row\">"
				rowCount = 0
				row += 1
			else
				rowCount++
			console.log rowCount
		photoset += "</div>"
		console.log photoset
		@$('.photoset').html photoset