Transit.Views.MapView = Backbone.View.extend
	
	className: 'map'

	initialize: -> 
		@posts = new Backbone.Collection()
		@map = new L.Map "map", 
			center: new L.LatLng(45.5192092,-122.63661690000004)

			zoom: 16
		@map.addLayer new L.StamenTileLayer("toner")
		# L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
	    # attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
		# }).addTo(@map)
      # @map.addLayer new L.Google('ROADMAP')


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

	showPost: (index) ->
		post = @posts.get index
		@map.setView new L.LatLng(post.get('position').latitude, post.get('position').longitude), post.get('position').zoom
