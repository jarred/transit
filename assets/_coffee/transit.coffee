Transit = window.TransitTheme ||= {}
Transit.Views = {}
Transit.Models = {}
Transit.Main =
	init: (options) ->
		Transit.Config = options
		@mapView = new Transit.Views.MapView
			el: $('#map')
		@extendViews()

	extendViews: ->
		_.each $('.js-extend-view'), (el) =>
			$el = $(el)
			viewName = $el.data('view')
			return if viewName is null or viewName is undefined
			view = Transit.Views[viewName]
			v = new view
				el: el
				mapView: @mapView
			$el.removeClass 'js-extend-view'