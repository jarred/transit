Transit.Views.ZoomView = Backbone.View.extend

	className: 'zoom'

	events:
		'click .js-close': 'close'
		'click .js-to-image': 'toImage'

	initialize: ->
		_.bindAll @
		$(window).bind 'resize', @onResize()
		$('html').addClass 'zoom-open'
		TweenMax.to @$el, .4, 
			opacity: 1
			ease: Quint.easeOut
		_.delay () =>
			@showImage Number @model.get('current-image')
		, 1000

	onResize: ->
		@windowWidth = $(window).width()

	template: _.template """
	<a class="close js-close">&times;</a>
		<div class="photos">
			<table cellpadding="0" cellspacing="0">
				<tr>
				<td><div class="spacer" style="height: <%= height %>px;"></div></td>
				<% if(type == "photo"){ %>
					<td class="js-to-image" data-index="0">
						<div class="image"><img src="<%= photos[0]["high-res"] %>" height="<%= height %>"></div>
					</td>
				<% } %>
				<% if(type == "photoset"){ %>
					<% _.each(photos, function(photo, index){ %>
						<td class="js-to-image" data-index="<%= index %>">
							<div class="image"><img src="<%= photo["highRes"] %>"  height="<%= height %>"></div>
						</td>
					<% }) %>
				<% } %>
				<td><div class="spacer" style="height: <%= height %>px;"></div></td>
				</tr>
			</table>
		</div>
	"""

	render: ->
		@model.set 'height', $(window).height() - 100
		@$el.html @template @model.toJSON()

	close: (e) ->
		e?.preventDefault()
		TweenMax.to @$('.photos table .recent'), .4, 
			opacity: .1
			ease: Quint.easeOut
		TweenMax.to @$('.photos table'), .4, 
			left: "-60000px"
			ease: Expo.easeInOut
			delay: .4
		TweenMax.to @$el, .4, 
			opacity: 0
			ease: Quint.easeIn
			delay: .8
			onComplete: () =>
				$('html').removeClass 'zoom-open'
				@remove()

	toImage: (e) ->
		e?.preventDefault()
		$el = $(e.target)
		$el = $el.parents('.js-to-image') if !$el.hasClass 'js-to-image'
		index = Number $el.data('index')
		@showImage(index)

	showImage: (x) ->
		$el = @$(".image[data-index=#{x}]")
		xPos = 2000
		xPos -= @windowWidth / 2 
		_.each @$('.image'), (el, index) =>
			if index < x
				$el = $(el)
				xPos += $el.width() + 10
			if index == x
				$el = $(el)
				xPos += ($el.width() / 2)
		TweenMax.to @$('.photos table .recent'), .4, 
			opacity: .1
			ease: Quint.easeOut
			onComplete: () =>
				@$('.photos table .recent').removeClass 'recent'
		TweenMax.to @$('.photos table'), .4, 
			left: "#{0 - xPos}px"
			ease: Expo.easeInOut
			delay: .4
		TweenMax.to @$(".js-to-image[data-index=#{x}] .image"), .4,
			ease: Quint.easeOut
			opacity: 1
			delay: .8
			onComplete: () =>
				@$(".js-to-image[data-index=#{x}] .image").addClass 'recent'