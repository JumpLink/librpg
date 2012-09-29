HMWorld-Data
=========

This Libary is used by [HMWworld](https://github.com/JumpLink/HMWorld) and [HMWorld-Website](https://github.com/JumpLink/HMWorld-Website) to handle the Game Data.

First you need to install [Sxml](https://github.com/JumpLink/simple-xml-reader-vala).

Debian

        apt-get install libgirepository1.0-dev libgee-dev gobject-introspection libgtk2.0-dev gir1.2-glib-2.0
        make
        make install
        
Example

```vala
using Hmwd;
class Main : Object {
        public static int main (string[] args) {
		var data = new Hmwd.Data();
		data.loadTileSetManager("./data/tileset/");
		data.loadMapManager("./data/map/");
		var map = data.mapmanager.getFromFilename("testmap.tmx");
		var layer = map.getLayerFromIndex(0);
		//get tile x y
		var tile = layer.tiles[0,0];

		print("layers_same(index:0) -> name:%s, width:%u, height:%u, zoff:%f\n", layer.name, layer.width, layer.height, layer.zoff);
		print("tile(x:0,y:0) -> gid:%i, width:%f, height:%f\n", tile.gid, tile.width, tile.height);
		print("textur: colorspace:%s\n", tile.tex.colorspace.to_string());
		
		return 0;
	}
}
```

Compile

	valac sample.vala --pkg Hmwd-0.1 --pkg gee-1.0 --pkg gio-2.0 --pkg gdk-pixbuf-2.0
	./sample