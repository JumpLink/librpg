// process.env.DYLD_LIBRARY_PATH = __dirname+"../gir";
// process.env.LD_LIBRARY_PATH = __dirname+"../gir";
// process.env.GI_TYPELIB_PATH = __dirname+"../gir";

var Gir = require('gir');
//Gir.init();
var Hmwd = module.exports = Gir.load('Hmwd');
var hexy = require('hexy');



//console.log(Hmwd);

// Hmwd.TileSetManager.init("./data/tileset/");
// Hmwd.MapManager.init("./data/map/");
// Hmwd.SpriteSetManager.init("./data/spriteset/");
// Hmwd.MAPMANAGER.printAll();
var data = new Hmwd.Data();
data.loadTileSetManager("./data/tileset/");
data.loadMapManager("./data/map/");
//data.loadSpriteSetManager("./data/spriteset/");
//var mapmanager = data.mapmanager;
// console.log(Hmwd.TileType.no_tile);
// console.log(Hmwd.TileType);
// var layer = data.mapmanager.getFromFilename("testmap.tmx").getLayerFromName("under hero 1");

// for (var y=0;y<layer.height;y++) {
// 	for (var x=0;x<layer.width;x++) {
// 		if(layer.getTileXY(x,y).tile_type != Hmwd.TileType.NO_TILE) {
// 			//print("x: %i y: %i\n", x,y);
// 			var tex = layer.getTileXY(x,y).tex;
// 			console.log(tex.width + " + " + tex.height);
// 			console.log(tex.save_to_buffer("png"));
// 			//tex.save("./test/"+x+"-"+y+".png");
// 			//drawTile(layer.tiles[x,y], shift_x + x * layer.tiles[x,y].width, shift_y + y * layer.tiles[x,y].height, layer.zoff);
// 		}
// 	}
// }
console.log();
console.log("pixbuf:");
console.log();
//var tex = data.mapmanager.getFromFilename("testmap.tmx").getLayerFromName("under hero 1").getTileXY(0,0).tex.save_to_buffer('png');
//data.mapmanager.getFromFilename("testmap.tmx").getLayerFromName("under hero 1").getTileXY(0,0).tex.printPngAsHex();
console.log();

var tex = data.mapmanager.getFromFilename("testmap.tmx").getLayerFromName("under hero 1").getTileXY(0,0).tex;

var png_buffer_nodejs = [tex.png_length];
console.log("png_length: "+tex.png_length);
for (var i = 0; i < tex.png_length; i++) {
	png_buffer_nodejs[i] = tex.get_pngbuffer_from_index(i);
};
var buf = new Buffer(png_buffer_nodejs);
console.log(hexy.hexy(buf));
//console.log(tile_png.toString('binary'));
//console.log(tile_png.toString('base64'));
//console.log(tile_png);
//console.log(tiletype);
//console.log(data.mapmanager.getFromFilename("testmap.tmx").getLayerFromName("under hero 1").getTileXY(0,0).type);
//console.log(Hmwd.Data);
//console.log(Hmwd.MapManager);
// Hmwd.MAPMANAGER
//console.log(data);
//data.printAll();
// SPRITESETMANAGER.SpriteSetManager();
// Hmwd.Main.init();
// SPRITESETMANAGER.printAll();
// console.log(Hmwd.Animation);
