Transit.Views.PhotosetView = Backbone.View.extend
	
	initialize: ->
		_.bindAll @
		@render()

	photoTemplate: _.template """
	<div class="block photo">
		<% if(caption){ %>
			<span class="caption-index">0<%= index %>.</span>
		<% } %>
		<% if(highRes){ %>
			<div class="image"><img src="<%= highRes %>" /></div>
		<% }else{ %>
			<div class="image"><img src="<%= src %>" /></div>
		<% } %>
	</div>
	"""

	render: ->
		_.each @model.get('photos'), (photo, index) =>
			photo.index = index + 1
			$el = $(@photoTemplate(photo))
			if photo.width > photo.height
				$el.addClass 'landscape'
			else
				$el.addClass 'portrait'
			@$el.append $el
		_.each @model.get('photos'), (photo, index) =>
			if photo.caption != ""
				@$el.append "<div class=\"block image-caption\"><p><span class=\"number\">0#{index + 1}.</span><br />#{photo.caption}</p></div>"

		# photoset = ""
		# captions = "<ul class=\"image-captions\">"
		# rowCount = 0
		# row = 0
		# photoset += "<div class=\"row row_size_#{@model.get('layout')[0]}\">"
		# _.each @model.get('photos'), (photo, index, all) =>
		# 	photo.index = index + 1
		# 	photoset += @photoTemplate photo
		# 	rowCount++
		# 	if photo.caption
		# 		captions += "<li><span class=\"number\">#{photo.index}</span> #{photo.caption}</li>"
		# 	if rowCount >= Number(@model.get('layout')[row])
		# 		row++
		# 		rowCount = 0
		# 		if index < all.length - 1
		# 			photoset += "<div class=\"clearfix\"></div></div><div class=\"row row_size_#{@model.get('layout')[row]}\">"
		# photoset += "<div class=\"clearfix\"></div></div>"

		# captions += "</ul>"
		# @$el.parents('.post').find('.caption').append captions
		# @$el.html photoset

		# _.each @$('.row_size_2'), (el, index) =>
		# 	$(el).addClass "numero_#{index}"
		# _.each @$('.row_size_3'), (el, index) =>
		# 	$(el).addClass "numero_#{index}"
		# _.defer () =>
		# 	@model.trigger 'rendered'