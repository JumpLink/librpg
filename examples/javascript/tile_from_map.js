var Gir = require('gir');
var Hmwd = module.exports = Gir.load('Hmwd');
var data = new Hmwd.Data();

data.loadTileSetManager(__dirname+"/public/data/tileset/");
data.loadMapManager(__dirname+"/public/data/map/");
data.loadSpriteSetManager(__dirname+"/public/data/spriteset/");

var css = require('./css.js')(data);
css.generateTileCss();
css.generateTileSetCss();

var tex = data.mapmanager.getFromFilename("testmap.tmx").getLayerFromName("under hero 1").getTileXY(0,0).tex;
var png_buffer_nodejs = [tex.png_length];
for (var i = 0; i < tex.png_length; i++) {
	png_buffer_nodejs[i] = tex.get_pngbuffer_from_index(i);
};
var buf = new Buffer(png_buffer_nodejs);
res.type('png');
res.send(buf);