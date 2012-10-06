/* Copyright (C) 2012  Pascal Garber
 * Copyright (C) 2012  Ole Lorenzen
 * Copyright (C) 2012  Patrick König
 *
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
 * License as published by the Creative Commons organisation; either
 * version 3.0 of the License, or (at your option) any later version.
 * More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 
 *
 * Author:
 *	Pascal Garber <pascal.garber@gmail.com>
 *	Ole Lorenzen <ole.lorenzen@gmx.net>
 *	Patrick König <knuffi@gmail.com>
 */
using Hmwd;
class Main : Object {
	public static int main (string[] args) {
		var data = new Hmwd.Data();
		data.loadSpritesetManager("./data/spriteset/");
		data.loadTilesetManager("./data/tileset/");
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
