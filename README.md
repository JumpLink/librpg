librpg
=========

This Libary is used by [HMWworld](https://github.com/JumpLink/HMWorld) and [HMWorld-Website](https://github.com/JumpLink/HMWorld-Website) to handle the Game Data, but can also be used generally for orthogonally tiled based maps.
This library can also load tiled based tilesets and spritesets (in my own format).

If you want to use OpenGL you could use the OpenGL Extension [librpggl](https://github.com/JumpLink/librpggl).

Install
-------

First you need to install [Sxml](https://github.com/JumpLink/simple-xml-reader-vala).

Debian

        apt-get install libgirepository1.0-dev libgee-dev gobject-introspection libgtk2.0-dev gir1.2-glib-2.0
        make
        make install
        
Documentation
-------------

 * [librpg Reference Manual](http://doc.hmworld.eu)
        
Example
-------

```vala
using rpg;
class Main : Object {
	public static int main (string[] args) {
		var data = new rpg.ResourceManager();
		data.load_spriteset_manager("./data/spriteset/");
		data.load_tileset_manager("./data/tileset/");
		data.load_map_manager("./data/map/");
		var map = data.mapmanager.get_from_filename("testmap.tmx");
		var layer = map.get_layer_from_index(0);
		var tile = layer.tiles[0,0]; //get tile x y
		layer.merge(16,16);
		layer.tex.save("test.png");
		map.merge();

		print("layers_same(index:0) -> name:%s, width:%u, height:%u, zoff:%f\n", layer.name, layer.width, layer.height, layer.zoff);
		print("tile(x:0,y:0) -> gid:%i, width:%f, height:%f\n", tile.gid, tile.width, tile.height);
		print("textur: colorspace:%s\n", tile.tex.colorspace.to_string());
		
		return 0;
	}
}

```

Compile

	valac sample.vala --pkg rpg-0.3 --pkg gee-1.0 --pkg gio-2.0 --pkg gdk-pixbuf-2.0 --pkg Sxml-0.1
	./sample
