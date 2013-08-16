TagApp = window.TagApp ||= {}

TagApp.Main =
	init: ->
		_.bindAll @
		$('.js-get-location').on 'click', @getLocation

	getLocation: (e) ->
		e.preventDefault()
		navigator.geolocation.getCurrentPosition @haveLocation

	haveLocation: (position) ->
		@showResult(position)
		return
		tag = "#geo:lat/long:#{position.coords.latitude}/#{position.coords.longitude}"
		console.log tag
		image = "http://maps.googleapis.com/maps/api/staticmap?center=#{position.coords.latitude},#{position.coords.longitude}&zoom=12&size=400x400&sensor=false&&maptype=roadmap&visual_refresh=true&style=feature:road|visibility:simplified&style=feature:landscape|visibility:on&style=feature:poi|visibility:off"
		$("body").append "<img src=\"#{image}\" />"

	resultView: Backbone.View.extend

		className: 'result'

		initialize: ->
			console.log @model.toJSON()
			@render()

		template: _.template """
			<div class="map" style="background-image: url('http://maps.googleapis.com/maps/api/staticmap?center=<%= coords.latitude %>,<%= coords.longitude %>&zoom=12&size=400x400&sensor=false&&maptype=roadmap&visual_refresh=true&style=feature:road|visibility:simplified&style=feature:landscape|visibility:on&style=feature:poi|visibility:off');">
			</div>
			<input type="text" class="js-tag" value="#lat/long/zoom:<%= coords.latitude %>/<%= coords.longitude %>"></input>
		"""

		render: ->
			@$el.html @template @model.toJSON()
			_.defer () =>
				@$('.js-tag').focus()


	showResult: (position) ->
		$('.js-intro').addClass 'hide'
		view = new @resultView
			model: new Backbone.Model position

		$('#app').append view.el