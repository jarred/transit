Transit.Views.PostView = Backbone.View.extend

	events:
		'click .js-zoom': 'openZoom'

	initialize: ->
		# populate the model...
		@model = new Transit.Models.PostModel @$el.data()
		_.each @$('pre.json'), (dataEl) =>
			@model.set JSON.parse $(dataEl).html()
		@model.cleanUp()

		# check for geotags
		mapTag = _.find @model.get('tags'), (tag) ->
			return tag.name.indexOf("lat/long/zoom") == 0
		@addMarker mapTag if mapTag?
		@$("[data-tag='#{ mapTag.name }']").remove()
		@options.mapView.addPost @model

		# initiate the different post types
		switch @model.get('type')
			when 'photoset'
				@$el.removeClass 'photo'
				@$el.addClass 'photoset'
				@photosetView = new Transit.Views.PhotosetView
					el: @$('.photoset')
					model: @model
			when 'text'
				@textView = new Transit.Views.TextView
					el: @$el
					model: @model
			when 'photo'
				@photoView = new Transit.Views.PhotoView
					el: @$el
					model: @model

		_.defer () =>
			@model.trigger 'rendered'

	addMarker: (tag) ->
		tag = tag.name.split(":")
		tag = tag[1].split("/")
		position =
			latitude: tag[0]
			longitude: tag[1]
			zoom: tag[2]
		@model.set 'position', position

	openZoom: (e) ->
		$el = $(e.target)
		$el = $el.parents('.js-zoom') if !$el.hasClass 'js-zoom'
		@model.set 'current-image', Number($el.data('index')) - 1
		@model.trigger 'open-zoom', @model