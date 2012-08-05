// process.env.DYLD_LIBRARY_PATH = __dirname+"../gir";
// process.env.LD_LIBRARY_PATH = __dirname+"../gir";
// process.env.GI_TYPELIB_PATH = __dirname+"../gir";

var Gir = require('gir');
Gir.init();
var Hmwd = module.exports = Gir.load('Hmwd');
//console.log(Hmwd);

Hmwd.TEXTUREFACTORY = new Hmwd.GdkTextureFactory();
Hmwd.TILESETMANAGER = new Hmwd.TileSetManager({folder:"./data/tileset/"});
Hmwd.MAPMANAGER = new Hmwd.MapManager({folder:"./data/map/"});
Hmwd.SPRITESETMANAGER = new Hmwd.SpriteSetManager({folder:"./data/spriteset/"});
// Hmwd.init();

//SPRITESETMANAGER.SpriteSetManager();
//Hmwd.Main.init();
//SPRITESETMANAGER.printAll();
//	console.log(Hmwd.Animation);
