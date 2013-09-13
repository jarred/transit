Transit.Views.PhotosetView = Backbone.View.extend
	
	initialize: ->
		_.bindAll @
		@render()

	photoTemplate: _.template """
	<div class="block photo <% if(width > height){ %>landscape<% }else{ %>portrait<% } %>" data-index="<%= index %>">
		<% if(highRes){ %>
			<div class="image"><img src="<%= highRes %>" /></div>
		<% }else{ %>
			<div class="image"><img src="<%= src %>" /></div>
		<% } %>
		<% if(caption != ""){ %>
		<div class="number"><%= index %>.</div>
		<% } %>
	</div>
	"""

	captionTemplate: _.template """
	<div class="caption"><span class="number"><%= index %>.</span><%= markdown.toHTML(caption) %></div>
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
					photoset += "<div class=\"captions\"></div><div class=\"clearfix\"></div></div><div class=\"row row_size_#{@model.get('layout')[row]}\">"
		photoset += "<div class=\"captions\"></div><div class=\"clearfix\"></div></div>"

		@$el.append photoset

		_.each @model.get('photos'), (photo, index) =>
			if photo.caption != ""
				$captionField = @$(".photo[data-index=#{index + 1}]").parents(".row").find(".captions")
				$captionField.append @captionTemplate photo

		_.each @$('.row_size_2'), (el, index) =>
			$(el).addClass "numero_#{index}"
		_.each @$('.row_size_3'), (el, index) =>
			$(el).addClass "numero_#{index}"
		_.defer () =>
			@model.trigger 'rendered'

		@$el.append "<div class=\"clearfix\"></div>"

		# preload thumbnail
		thumb = new Image()
		thumb.src = @model.get('photos')[0].thumb