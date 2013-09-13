Transit.Views.MapView = Backbone.View.extend
	
	className: 'map'
	currentPost: 0

	initialize: -> 
		_.bindAll @
		@paginationModel = new Backbone.Model $('.page').data()
		@posts = new Backbone.Collection()
		@map = new L.Map "leaflet", 
			center: new L.LatLng(0,0)
			zoom: 16
			scrollWheelZoom: false

		switch Transit.Config.map
			when "toner"
				@map.addLayer new L.StamenTileLayer("toner")
			when "roadmap"
				@map.addLayer new L.Google("ROADMAP")
			when "satellite"
				@map.addLayer new L.Google("SATELLITE")
			when "OpenStreetMap"
				L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
				    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
				}).addTo(@map);
				
		$(window).bind 'resize', @resize
		@resize()
		$(document).bind 'scroll', @checkPosition
		@updateHeightsInt = setInterval @updatePostHeights, 2000

	markerTemplate: _.template """
	<div class="ref" data-id="<%= id %>"></div>
	<div class="pin <%= type %>">
		<div class="ball"></div>
	</div>
	<% if(type == "photo" || type == "photoset"){ %>
		<div class="open" style="background-image: url('<%= photos[0].thumb %>');"></div>
	<% } %>
	"""

	addPost: (postModel) ->
		@posts.add postModel
		postModel.on 'rendered', @updatePostHeights()

		return if postModel.get('position') is null

		icon = new L.divIcon
			className: 'marker'
			iconSize: L.Point(60, 60)
			html: @markerTemplate postModel.toJSON()
		options =
			icon: icon

		marker = L.marker([postModel.get('position').latitude, postModel.get('position').longitude], options)
		marker.addTo @map
		
		if @posts.length == 1
			_.defer () =>
				@updatePostHeights()
				post = @posts.at 0
				position = new L.LatLng post.get('position').latitude, post.get('position').longitude
				@map.panTo position, 
					animate: false
				@map.setZoom post.get('position').zoom, 
					animate: false
				@showPost(0)

	showPost: (index) ->
		@currentPost = index
		post = @posts.at index
		return if post is null or undefined
		return if !post.get('position') is null
		position = new L.LatLng post.get('position').latitude, post.get('position').longitude
		@$('.marker').removeClass 'active'
		$marker = $(".marker .ref[data-id=#{post.get('id')}]").parents('.marker')
		@map.setZoom 12
		clearTimeout @zoomTimeout if @zoomTimeout?
		clearTimeout @panTimeout if @panTimeout?
		clearTimeout @markerTimeout if @markerTimeout?
		@zoomTimeout = setTimeout () =>
			@map.panTo position, 
				easeLinearity: .02
		, 350
		@panTimeout = setTimeout () =>
			@map.setZoom post.get('position').zoom
		, 700
		@markerTimeout = setTimeout () =>
			$marker.addClass 'active'
		, 1000

	updatePostHeights: ->
		@resize()
		@postHeights = []
		y = 0;
		_.each $('.post'), (el) =>
			$el = $(el)
			@postHeights.push $el.height() + y + 41
			y += $el.height() + 41

	checkPosition: (e) ->
		y = $(document).scrollTop() + 0
		index = _.find @postHeights, (value) =>
			return y <= value
		index = @postHeights.indexOf index
		if @currentPost != index
			@showPost index

		if ((y / @pagesHeight) > .7) && (@paginationModel.get('page') < @paginationModel.get('total'))
			$(document).unbind 'scroll', @checkPosition
			@loadNextPage()

	resize: ->
		@windowHeight = $(window).height()
		@pagesHeight = $('.js-posts .pages').height()

	loadNextPage: ->
		return if @paginationModel.get('page') >= @paginationModel.get('total')
		return if @paginationModel.get("next") == ""
		@$newPage = $("<div class=\"js-new-pages\"></div>")
		@$newPage.load "#{@paginationModel.get('next')} .pages .page", @newPageAdded

	newPageAdded: ->
		$('.js-posts .pages').append @$newPage.html()
		$newPage = $(".page[data-page=#{@paginationModel.get('page') + 1}]")
		@paginationModel.set $newPage.data()
		Transit.Main.extendViews()
		_.defer () =>
			@updatePostHeights()
			@resize()
			$(document).bind 'scroll', @checkPosition