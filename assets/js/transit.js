// Generated by CoffeeScript 1.6.2
(function() {
  var Transit;

  Transit = window.TransitTheme || (window.TransitTheme = {});

  Transit.Views = {};

  Transit.Models = {};

  Transit.Main = {
    init: function() {
      this.mapView = new Transit.Views.MapView({
        el: $('#map')
      });
      return this.extendViews();
    },
    extendViews: function() {
      var _this = this;

      return _.each($('.js-extend-view'), function(el) {
        var $el, v, view, viewName;

        $el = $(el);
        viewName = $el.data('view');
        if (viewName === null || viewName === void 0) {
          return;
        }
        view = Transit.Views[viewName];
        v = new view({
          el: el,
          mapView: _this.mapView
        });
        return $el.removeClass('js-extend-view');
      });
    }
  };

  Transit.Models.PostModel = Backbone.Model.extend({
    initialize: function() {
      return _.bindAll(this);
    },
    cleanUp: function() {
      var photos;

      this.set('tags', _.compact(this.get('tags')));
      if (this.get('type') === 'photoset') {
        photos = _.compact(this.get('photos'));
        this.set('photos', photos);
      }
      return this.set('date', new Date(this.get('date')));
    },
    markerHTML: function() {
      var html;

      html = "";
      switch (this.get('type')) {
        case "photo":
          html = "<div class=\"photo\" style=\"background-image: url('" + (this.get('photos')[0].src) + "');\"></div>";
          break;
        case "photoset":
          html = "<div class=\"photo\" style=\"background-image: url('" + (this.get('photos')[0].src) + "');\"></div><span class=\"count\">" + (this.get('photos').length) + "</span>";
          break;
        case "text":
          html = "<div class=\"icon-shell\"><i class=\"icon-flight icon\"></i></div>";
      }
      return html;
    }
  });

  Transit.Views.MapView = Backbone.View.extend({
    className: 'map',
    currentPost: 0,
    initialize: function() {
      _.bindAll(this);
      this.paginationModel = new Backbone.Model($('.page').data());
      this.posts = new Backbone.Collection();
      this.map = new L.Map("leaflet", {
        center: new L.LatLng(0, 0),
        zoom: 16,
        scrollWheelZoom: false
      });
      this.map.addLayer(new L.StamenTileLayer("toner"));
      $(window).bind('resize', this.resize);
      this.resize();
      $(document).bind('scroll', this.checkPosition);
      return this.updateHeightsInt = setInterval(this.updatePostHeights, 2000);
    },
    addPost: function(postModel) {
      var icon, marker, options,
        _this = this;

      this.posts.add(postModel);
      postModel.on('rendered', this.updatePostHeights());
      if (postModel.get('position') === null) {
        return;
      }
      icon = new L.divIcon({
        className: 'marker',
        iconSize: L.Point(60, 60),
        html: postModel.markerHTML()
      });
      options = {
        icon: icon
      };
      marker = L.marker([postModel.get('position').latitude, postModel.get('position').longitude], options);
      marker.addTo(this.map);
      if (this.posts.length === 1) {
        return _.defer(function() {
          var position, post;

          _this.updatePostHeights();
          post = _this.posts.at(0);
          position = new L.LatLng(post.get('position').latitude, post.get('position').longitude);
          _this.map.panTo(position);
          return _this.map.setZoom(post.get('position').zoom);
        });
      }
    },
    showPost: function(index) {
      var position, post,
        _this = this;

      this.currentPost = index;
      post = this.posts.at(index);
      if (post === null || void 0) {
        return;
      }
      if (!post.get('position') === null) {
        return;
      }
      position = new L.LatLng(post.get('position').latitude, post.get('position').longitude);
      this.map.setZoom(12);
      if (this.zoomTimeout != null) {
        clearTimeout(this.zoomTimeout);
      }
      if (this.panTimeout) {
        clearTimeout(this.panTimeout);
      }
      this.zoomTimeout = setTimeout(function() {
        return _this.map.panTo(position);
      }, 500);
      return this.panTimeout = setTimeout(function() {
        return _this.map.setZoom(post.get('position').zoom);
      }, 1000);
    },
    updatePostHeights: function() {
      var y,
        _this = this;

      this.resize();
      this.postHeights = [];
      y = 0;
      return _.each($('.post'), function(el) {
        var $el;

        $el = $(el);
        _this.postHeights.push($el.height() + y + 41);
        return y += $el.height() + 41;
      });
    },
    checkPosition: function(e) {
      var index, y,
        _this = this;

      y = $(document).scrollTop() + 0;
      index = _.find(this.postHeights, function(value) {
        return y <= value;
      });
      index = this.postHeights.indexOf(index);
      if (this.currentPost !== index) {
        this.showPost(index);
      }
      if (((y / this.pagesHeight) > .7) && (this.paginationModel.get('page') < this.paginationModel.get('total'))) {
        $(document).unbind('scroll', this.checkPosition);
        return this.loadNextPage();
      }
    },
    resize: function() {
      this.windowHeight = $(window).height();
      return this.pagesHeight = $('.js-posts .pages').height();
    },
    loadNextPage: function() {
      if (this.paginationModel.get('page') >= this.paginationModel.get('total')) {
        return;
      }
      if (this.paginationModel.get("next") === "") {
        return;
      }
      this.$newPage = $("<div class=\"js-new-pages\"></div>");
      return this.$newPage.load("" + (this.paginationModel.get('next')) + " .pages .page", this.newPageAdded);
    },
    newPageAdded: function() {
      var $newPage,
        _this = this;

      $('.js-posts .pages').append(this.$newPage.html());
      $newPage = $(".page[data-page=" + (this.paginationModel.get('page') + 1) + "]");
      this.paginationModel.set($newPage.data());
      Transit.Main.extendViews();
      return _.defer(function() {
        _this.updatePostHeights();
        _this.resize();
        return $(document).bind('scroll', _this.checkPosition);
      });
    }
  });

  Transit.Views.PhotoView = Backbone.View.extend({
    initialize: function() {
      _.bindAll(this);
      if (this.model.get('photos')[0].width < this.model.get('photos')[0].height) {
        this.$el.addClass('landscape');
        return this.$('.image_hold').attr('class', 'image_hold grid_col_4');
      }
    }
  });

  Transit.Views.PhotosetView = Backbone.View.extend({
    initialize: function() {
      _.bindAll(this);
      return this.render();
    },
    photoTemplate: _.template("<div class=\"cell\">\n	<% if(highRes){ %>\n		<div class=\"image\"><img src=\"<%= highRes %>\" /></div>\n	<% }else{ %>\n		<div class=\"image\"><img src=\"<%= src %>\" /></div>\n	<% } %>\n</div>"),
    render: function() {
      var photoset, row, rowCount,
        _this = this;

      photoset = "";
      rowCount = 0;
      row = 0;
      photoset += "<div class=\"row row_size_" + (this.model.get('layout')[0]) + "\">";
      _.each(this.model.get('photos'), function(photo, index, all) {
        photoset += _this.photoTemplate(photo);
        rowCount++;
        if (rowCount >= Number(_this.model.get('layout')[row])) {
          row++;
          rowCount = 0;
          if (index < all.length - 1) {
            return photoset += "<div class=\"clearfix\"></div></div><div class=\"row row_size_" + (_this.model.get('layout')[row]) + "\">";
          }
        }
      });
      photoset += "<div class=\"clearfix\"></div></div>";
      this.$el.html(photoset);
      return _.defer(function() {
        return _this.model.trigger('rendered');
      });
    }
  });

  Transit.Views.PostView = Backbone.View.extend({
    initialize: function() {
      var mapTag,
        _this = this;

      this.model = new Transit.Models.PostModel(this.$el.data());
      _.each(this.$('pre.json'), function(dataEl) {
        return _this.model.set(JSON.parse($(dataEl).html()));
      });
      this.model.cleanUp();
      mapTag = _.find(this.model.get('tags'), function(tag) {
        return tag.name.indexOf("lat/long/zoom") === 0;
      });
      if (mapTag != null) {
        this.addMarker(mapTag);
      }
      this.$("a[data-tag='" + mapTag.name + "']").remove();
      this.options.mapView.addPost(this.model);
      switch (this.model.get('type')) {
        case 'photoset':
          this.photosetView = new Transit.Views.PhotosetView({
            el: this.$('.photoset'),
            model: this.model
          });
          break;
        case 'text':
          this.textView = new Transit.Views.TextView({
            el: this.$el,
            model: this.model
          });
          break;
        case 'photo':
          this.photoView = new Transit.Views.PhotoView({
            el: this.$el,
            model: this.model
          });
      }
      return _.defer(function() {
        return _this.model.trigger('rendered');
      });
    },
    addMarker: function(tag) {
      var position;

      tag = tag.name.split(":");
      tag = tag[1].split("/");
      position = {
        latitude: tag[0],
        longitude: tag[1],
        zoom: tag[2]
      };
      return this.model.set('position', position);
    }
  });

  Transit.Views.TextView = Backbone.View.extend({
    initialize: function() {
      var flight;

      _.bindAll(this);
      flight = _.find(this.model.get('tags'), function(tag) {
        return tag.name.toLowerCase() === 'flight';
      });
      if (flight != null) {
        return this.setupFlight();
      }
    },
    setupFlight: function() {
      var airportCode, text,
        _this = this;

      text = this.$('h1').text();
      airportCode = /[A-Z]{3}/g;
      text = text.replace("-", "<i class=\"icon icon-flight\"></i>");
      text = text.replace(airportCode, function(code) {
        var el;

        el = "<span class=\"airport-code\">";
        _.each(code.split(""), function(letter) {
          return el += "<span class=\"letter\">" + letter + "<span class=\"shadow\"></span></span>";
        });
        el += "</span>";
        return el;
      });
      this.$('h1').html(text);
    }
  });

}).call(this);
