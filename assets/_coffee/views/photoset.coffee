Transit.Views.PhotosetView = Backbone.View.extend
	
	initialize: ->
		_.bindAll @
		@render()

	photoTemplate: _.template """
	<div class="block photo <% if(width > height){ %>landscape<% }else{ %>portrait<% } %>">
		<% if(caption){ %>
			<span class="caption-index">0<%= index %></span>
		<% } %>
		<% if(highRes){ %>
			<div class="image"><img src="<%= highRes %>" /></div>
		<% }else{ %>
			<div class="image"><img src="<%= src %>" /></div>
		<% } %>
	</div>
	"""

	render: ->
		photoset = ""
		rowCount = 0
		row = 0
		photoset += "<div class=\"row row_size_#{@model.get('layout')[0]}\">"
		_.each @model.get('photos'), (photo, index, all) =>
			photo.index = index + 1
			photoset += @photoTemplate photo
			rowCount++
			if rowCount >= Number(@model.get('layout')[row])
				row++
				rowCount = 0
				if index < all.length - 1
					photoset += "</div><div class=\"row row_size_#{@model.get('layout')[row]}\">"
		photoset += "</div>"

		@$el.append photoset

		_.each @model.get('photos'), (photo, index) =>
			if photo.caption != ""
				@$el.append "<div class=\"block image-caption\"><p><span class=\"number\">#{index + 1} &mdash; </span>#{photo.caption}</p></div>"

		_.each @$('.row_size_2'), (el, index) =>
			$(el).addClass "numero_#{index}"
		_.each @$('.row_size_3'), (el, index) =>
			$(el).addClass "numero_#{index}"
		_.defer () =>
			@model.trigger 'rendered'

		@$el.append "<div class=\"clearfix\"></div>"