# Transit tumblr theme

A tumblr theme designed specifically for travellers.

- geotag your tumblr posts
- supports all post types
- integrated map
- view posts chronologically

# Compile SCSS

`cd assets` then `compass watch`

# Compile & Minify Javascript libs.

for tagger:

`uglifyjs -o assets/js/libs.js assets/js/_libs/jquery.js assets/js/_libs/underscore.js assets/js/_libs/backbone.js assets/js/_libs/jquery-ui-1.10.3.custom.js`

for the theme:

`uglifyjs -o assets/js/libs.js assets/js/_libs/jquery.js assets/js/_libs/underscore.js assets/js/_libs/backbone.js`

# Coffeescript

for the tagger

`coffee --watch --join assets/js/tag.js --compile assets/_coffee/tag.coffee`