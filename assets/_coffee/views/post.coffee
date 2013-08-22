Transit.Views.PostView = Backbone.View.extend

	initialize: ->
		# populate the model...
		@model = new Transit.Models.PostModel @$el.data()
		_.each @$('pre.json'), (dataEl) =>
			@model.set JSON.parse $(dataEl).html()

		# check for geotags
		mapTag = _.find @model.get('meta').tags, (tag) ->
			return tag.name.indexOf("lat/long/zoom") == 0
		@addMarker(mapTag) if mapTag?

		# initiate the different post types
		switch @model.get('type')
			when 'photoset'
				@photosetView = new Transit.Views.PhotosetView
					el: @$('.photoset')
					model: @model

	addMarker: (tag) ->
		tag = tag.name.split(":")
		tag = tag[1].split("/")
		position =
			latitude: tag[0]
			longitude: tag[1]
			zoom: tag[2]
		@model.set 'position', position
		@options.mapView.addMarker @model