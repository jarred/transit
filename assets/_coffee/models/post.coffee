Transit.Models.PostModel = Backbone.Model.extend

	markerHTML: ->
		html = ""
		console.log @toJSON()
		switch @get('type')
			when "photo", "photoset"
				html = "<div class=\"photo\" style=\"background-image: url('#{@get('photos')[0].src}');\"></div>"
		return html

