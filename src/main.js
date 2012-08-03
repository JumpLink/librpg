// process.env.DYLD_LIBRARY_PATH = __dirname+"../gir";
// process.env.LD_LIBRARY_PATH = __dirname+"../gir";
// process.env.GI_TYPELIB_PATH = __dirname+"../gir";

var Gir = require('gir');
Gir.init();
var Hmwd = module.exports = Gir.load('Hmwd');
console.log(Hmwd);

//var TEXTUREFACTORY = new Hmwd.GdkTextureFactory();
// var TILESETMANAGER = new Hmwd.TileSetManager();
// var MAPMANAGER = new Hmwd.MapManager();
var SPRITESETMANAGER = new Hmwd.SpriteSetManager();

//SPRITESETMANAGER.SpriteSetManager();
//Hmwd.Main.init();
//SPRITESETMANAGER.printAll();
//console.log(Hmwd.SpriteSetManager);
