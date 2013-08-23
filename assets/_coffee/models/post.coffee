Transit.Models.PostModel = Backbone.Model.extend

	markerHTML: ->
		html = ""
		console.log @toJSON()
		switch @get('type')
			when "photo"
				html = "<div class=\"photo\" style=\"background-image: url('#{@get('photos')[0].src}');\"></div>"
			when "photoset"
				html = "<div class=\"photo\" style=\"background-image: url('#{@get('photos')[0].src}');\"></div><span class=\"count\">#{@get('photos').length}</span>"
			when "text"
				html = "<div class=\"icon-shell\"><i class=\"icon-flight icon\"></i></div>"
		return html

