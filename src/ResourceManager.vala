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
namespace rpg {

	public class ResourceManager : Object {
		public rpg.TilesetManager tilesetmanager { get; set; }
		public rpg.MapManager mapmanager { get; set; }
		public rpg.SpritesetManager spritesetmanager { get; set; }

		public void load_tileset_manager(string folder) {
			tilesetmanager = new rpg.TilesetManager(folder);
		}

		public void load_map_manager(string folder) {
			mapmanager = new rpg.MapManager(folder, tilesetmanager);
		}

		public void load_spriteset_manager(string folder) {
			spritesetmanager = new rpg.SpritesetManager(folder);
		}
	}
}
