Transit.Models.PostModel = Backbone.Model.extend

	initialize: ->
		_.bindAll @

	cleanUp: ->
		tags = _.compact @get('meta').tags
		@get('meta').tags = tags
		
		if @get('type') == 'photoset'
			photos = _.compact @get('photos')
			@set 'photos', photos

		@set 'date', new Date(@get('date'))

	markerHTML: ->
		html = ""
		switch @get('type')
			when "photo"
				html = "<div class=\"photo\" style=\"background-image: url('#{@get('photos')[0].src}');\"></div>"
			when "photoset"
				html = "<div class=\"photo\" style=\"background-image: url('#{@get('photos')[0].src}');\"></div><span class=\"count\">#{@get('photos').length}</span>"
			when "text"
				html = "<div class=\"icon-shell\"><i class=\"icon-flight icon\"></i></div>"
		return html

