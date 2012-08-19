var Gir = require('gir');
var Hmwd = module.exports = Gir.load('Hmwd');
var data = new Hmwd.Data();

data.loadTileSetManager(__dirname+"/public/data/tileset/");
data.loadMapManager(__dirname+"/public/data/map/");
data.loadSpriteSetManager(__dirname+"/public/data/spriteset/");

var css = require('./css.js')(data);
css.generateTileCss();
css.generateTileSetCss();

function getMapTiles(map, area_l, area_x, area_y) {
	var layers = [];
	for(var l=area_l.from;l<area_l.to;l++) {
		var count = 0;
		var tiles = [];
		for(var y=area_y.from;y<area_y.to;y++) {
			for(var x=area_x.from;x<area_x.to;x++, count++) {
				tiles[count] = {
					t_id: map.getTileIDFromPosition(x,y,l),
					ts_id: map.getTileSetIndexFromPosition(x,y,l)
				}
			}
		}
		layers[l]=tiles;
	}
	return layers;
}

var map = data.mapmanager.getFromFilename(req.params.name);

res.render('map', {
	title: 'HMWorld - Map '+req.params.name,
	tiles : getMapTiles(map, {from: 0, to: map.all_layer_size}, {from: 0, to: map.width},  {from: 0, to: map.height}),
	width: map.width,
	height: map.height,
	tilewidth: map.tilewidth,
	tileheight: map.tileheight
}); 