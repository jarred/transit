// Generated by CoffeeScript 1.6.2
(function() {
  var TagApp;

  TagApp = window.TagApp || (window.TagApp = {});

  TagApp.Data = {
    gMapsAPIKey: "AIzaSyBcdQ0fjR_fbOMEirWzvwMyY2SMVByKHlo"
  };

  TagApp.Main = {
    init: function() {
      var _this = this;

      _.bindAll(this);
      $('.js-get-location').on('click', this.getLocation);
      this.geocoder = new google.maps.Geocoder();
      return $(".js-search-for-address").autocomplete({
        appendTo: '.js-address',
        source: function(request, response) {
          return _this.geocoder.geocode({
            address: request.term
          }, function(results, status) {
            return response($.map(results, function(item) {
              return {
                label: item.formatted_address,
                value: item.formatted_address,
                latitude: item.geometry.location.lat(),
                longitude: item.geometry.location.lng()
              };
            }));
          });
        },
        select: function(event, ui) {
          var position;

          position = {
            coords: {
              latitude: ui.item.latitude,
              longitude: ui.item.longitude
            }
          };
          return _this.showResult(position);
        }
      });
    },
    getLocation: function(e) {
      e.preventDefault();
      return navigator.geolocation.getCurrentPosition(this.haveLocation);
    },
    haveLocation: function(position) {
      return this.showResult(position);
    },
    resultView: Backbone.View.extend({
      className: 'result',
      events: {
        'change input.zoom': 'updateZoom'
      },
      initialize: function() {
        _.bindAll(this);
        this.model.on('change', this.updateTag);
        return this.render();
      },
      template: _.template("<div class=\"map\">\n	<img src=\"<%= image_src %>\" />\n</div>\n<div class=\"zoom\">\n	<h4>Zoom</h4>\n	<span class=\"label\">City</span>\n	<input type=\"range\" name=\"points\" class=\"zoom\" min=\"8\" value=\"14\" max=\"16\">\n	<span class=\"label\">Street</span>\n</div>\n<div class=\"tag\">\n	<h4>Tag:</h4>\n	<input type=\"text\" class=\"js-tag\" value=\"<%= tag %>\"></input>\n	<p>Paste this into the tags for your tumblr post.</p>\n</div>"),
      updateTag: function() {
        var tag;

        tag = "#lat/long/zoom:" + (this.model.get('coords').latitude) + "/" + (this.model.get('coords').longitude) + "/" + (this.model.get('zoom'));
        this.model.set('tag', tag);
        return this.$('.js-tag').val(this.model.get('tag'));
      },
      makeImage: function() {
        var data, src;

        data = {
          center: this.model.get('coords').latitude + "," + this.model.get('coords').longitude,
          zoom: this.model.get('zoom'),
          size: "320x160",
          sensor: false,
          maptype: 'roadmap',
          visual_refresh: true,
          key: TagApp.Data.gMapsAPIKey
        };
        src = "http://maps.googleapis.com/maps/api/staticmap?" + ($.param(data));
        return src;
      },
      render: function() {
        var _this = this;

        this.model.set("zoom", 14);
        this.model.set("image_src", this.makeImage());
        this.$el.html(this.template(this.model.toJSON()));
        return _.defer(function() {
          return _this.$('.js-tag').focus();
        });
      },
      updateZoom: function(e) {
        var val,
          _this = this;

        val = $(e.target).val();
        this.model.set('zoom', val);
        this.$('.map').html("<img src=\"" + (this.makeImage()) + "\" />");
        return _.defer(function() {
          return _this.$('.js-tag').focus();
        });
      }
    }),
    showResult: function(position) {
      var view;

      $('.js-intro').addClass('hide');
      view = new this.resultView({
        model: new Backbone.Model(position)
      });
      return $('#app').append(view.el);
    }
  };

}).call(this);
