Transit.Views.TextView = Backbone.View.extend

	initialize: ->
		_.bindAll @
		flight = _.find @model.get('meta').tags, (tag) ->
			return tag.name.toLowerCase() == 'flight'
		@setupFlight() if flight?

	setupFlight: ->
		text = @$('h1').text()
		airportCode = /[A-Z]{3}/g
		text = text.replace "-", "<i class=\"icon icon-flight\"></i>"
		text = text.replace airportCode, (code) =>
			el = "<span class=\"airport-code\">"
			_.each code.split(""), (letter) =>
				el += "<span class=\"letter\">#{letter}<span class=\"shadow\"></span></span>"
			el += "</span>"
			return el

		@$('h1').html text
		return