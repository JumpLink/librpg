/* Copyright (C) 2012  Pascal Garber
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
 * License as published by the Creative Commons organisation; either
 * version 3.0 of the License, or (at your option) any later version.
 * More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 
 *
 * Author:
 *	Pascal Garber <pascal.garber@gmail.com>
 */
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

		print("layers_same(index:0) -> name:%s, width:%u, height:%u, zoff:%f\n", layer.name, layer.width, layer.height, layer.zoff);
		print("tile(x:0,y:0) -> gid:%i, width:%f, height:%f\n", tile.gid, tile.width, tile.height);
		print("textur: colorspace:%s\n", tile.tex.colorspace.to_string());
		
		return 0;
	}
}
