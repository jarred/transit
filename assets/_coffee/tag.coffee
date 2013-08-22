TagApp = window.TagApp ||= {}

TagApp.Data = 
	gMapsAPIKey: "AIzaSyBcdQ0fjR_fbOMEirWzvwMyY2SMVByKHlo"

TagApp.Main =
	init: ->
		_.bindAll @
		$('.js-get-location').on 'click', @getLocation
		# $('.js-search-for-address').on 'keyup', @lookForLocation
		@geocoder = new google.maps.Geocoder()
		$(".js-search-for-address").autocomplete
			appendTo: '.js-address'
			source: (request, response) =>
				@geocoder.geocode
					address: request.term
				, (results, status) =>
					response $.map results, (item) =>
						return{
							label: item.formatted_address
							value: item.formatted_address
							latitude: item.geometry.location.lat()
							longitude: item.geometry.location.lng()
						}
			select: (event, ui) =>
				position =
					coords:
						latitude: ui.item.latitude
						longitude: ui.item.longitude
				@showResult position
							

	getLocation: (e) ->
		e.preventDefault()
		navigator.geolocation.getCurrentPosition @haveLocation

	haveLocation: (position) ->
		@showResult(position)

	resultView: Backbone.View.extend
		className: 'result'

		events:
			'change input.zoom': 'updateZoom'

		initialize: ->
			_.bindAll @
			@model.on 'change', @updateTag
			@render()

		template: _.template """
			<div class="map">
				<img src="<%= image_src %>" />
			</div>
			<div class="zoom">
				<h4>Zoom</h4>
				<span class="label">City</span>
				<input type="range" name="points" class="zoom" min="8" value="14" max="16">
				<span class="label">Street</span>
			</div>
			<div class="tag">
				<h4>Tag:</h4>
				<input type="text" class="js-tag" value="<%= tag %>"></input>
				<p>Paste this into the tags for your tumblr post.</p>
			</div>
		"""

		updateTag: ->
			tag = "#lat/long/zoom:#{@model.get('coords').latitude}/#{@model.get('coords').longitude}/#{@model.get('zoom')}"
			@model.set 'tag', tag
			@$('.js-tag').val @model.get('tag')

		makeImage: ->
			data =
				center: @model.get('coords').latitude + "," + @model.get('coords').longitude
				zoom: @model.get('zoom')
				size: "320x160"
				sensor: false
				maptype: 'roadmap'
				visual_refresh: true
				key: TagApp.Data.gMapsAPIKey
			src = "http://maps.googleapis.com/maps/api/staticmap?#{$.param(data)}"
			return src

		render: ->
			@model.set "zoom", 14
			@model.set "image_src", @makeImage()
			@$el.html @template @model.toJSON()
			_.defer () =>
				@$('.js-tag').focus()

		updateZoom: (e) ->
			val = $(e.target).val()
			@model.set 'zoom', val
			@$('.map').html "<img src=\"#{@makeImage()}\" />"
			_.defer () =>
				@$('.js-tag').focus()

	showResult: (position) ->
		$('.js-intro').addClass 'hide'
		view = new @resultView
			model: new Backbone.Model position
		$('#app').append view.el