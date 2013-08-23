Transit.Views.MapView = Backbone.View.extend
	
	className: 'map'
	currentPost: 0

	initialize: -> 
		_.bindAll @
		@posts = new Backbone.Collection()
		@map = new L.Map "map", 
			center: new L.LatLng(0,0)
			zoom: 16
		@map.addLayer new L.StamenTileLayer("toner")
		# L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
		#     attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
		# }).addTo(@map);
		$('#left').on 'scroll', @checkPosition
		@updateHeightsInt = setInterval @updatePostHeights, 2000

	addMarker: (postModel) ->
		@posts.add postModel
		icon = new L.divIcon
			className: 'marker'
			iconSize: L.Point(60, 60)
			html: postModel.markerHTML()
		options =
			icon: icon
		marker = L.marker([postModel.get('position').latitude, postModel.get('position').longitude], options)
		marker.addTo @map

		postModel.on 'rendered', @updatePostHeights()
		
		if @posts.length == 1
			_.defer () =>
				@updatePostHeights()
				post = @posts.at 0
				position = new L.LatLng post.get('position').latitude, post.get('position').longitude
				@map.panTo position
				@map.setZoom post.get('position').zoom

	showPost: (index) ->
		@currentPost = index
		post = @posts.at index
		position = new L.LatLng post.get('position').latitude, post.get('position').longitude
		@map.setZoom 12
		clearTimeout @zoomTimeout if @zoomTimeout?
		clearTimeout @panTimeout if @panTimeout
		@zoomTimeout = setTimeout () =>
			@map.panTo position
		, 500
		@panTimeout = setTimeout () =>
			@map.setZoom post.get('position').zoom
		, 1000		

	updatePostHeights: ->
		@postHeights = []
		y = 0;
		_.each $('.post'), (el) =>
			$el = $(el)
			@postHeights.push $el.height() + y + 140
			y += $el.height() + 140

	checkPosition: (e) ->
		y = $('#left').scrollTop() + 300
		index = _.find @postHeights, (value) =>
			return y <= value
		index = @postHeights.indexOf index
		if @currentPost != index
			@showPost index

