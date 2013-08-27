Transit.Views.MapView = Backbone.View.extend
	
	className: 'map'
	currentPost: 0

	initialize: -> 
		_.bindAll @
		@paginationModel = new Backbone.Model $('.page').data()
		@posts = new Backbone.Collection()
		@map = new L.Map "map", 
			center: new L.LatLng(0,0)
			zoom: 16
		@map.addLayer new L.StamenTileLayer("toner")
		# L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
		#     attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
		# }).addTo(@map);
		$(window).on 'resize', @resize
		@resize()
		$('#left').on 'scroll', @checkPosition
		@updateHeightsInt = setInterval @updatePostHeights, 2000

	addPost: (postModel) ->
		@posts.add postModel
		postModel.on 'rendered', @updatePostHeights()

		return if postModel.get('position') is null

		icon = new L.divIcon
			className: 'marker'
			iconSize: L.Point(60, 60)
			html: postModel.markerHTML()
		options =
			icon: icon
		marker = L.marker([postModel.get('position').latitude, postModel.get('position').longitude], options)
		marker.addTo @map
		
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
		return if post.get('position') is null
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
		@resize()
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

		if @paginationModel.get('page') < @paginationModel.get('total') && (y / @pagesHeight) > .7
			@loadNextPage()

	resize: ->
		@windowHeight = $(window).height()
		@pagesHeight = $('#left .pages').height()

	loadNextPage: ->
		$('#left').unbind 'scroll', @checkPosition
		$('#left .pages').append "<div class=\"js-new-page\"></div>"
		$('.js-new-page').load "#{@paginationModel.get('next')} .pages", @newPageAdded

	newPageAdded: ->
		@$('.js-new-page').attr 'class', ''
		$newPage = $(".page[data-page=#{@paginationModel.get('page') + 1}]")
		@paginationModel.set $newPage.data()
		Transit.Main.extendViews()
		@updatePostHeights()
		@resize()
		$('#left').on 'scroll', @checkPosition