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
namespace Hmwd {

	public class ResourceManager : Object {
		public Hmwd.TilesetManager tilesetmanager { get; set; }
		public Hmwd.MapManager mapmanager { get; set; }
		public Hmwd.SpritesetManager spritesetmanager { get; set; }

		public void load_tileset_manager(string folder) {
			tilesetmanager = new Hmwd.TilesetManager(folder);
		}

		public void load_map_manager(string folder) {
			mapmanager = new Hmwd.MapManager(folder, tilesetmanager);
		}

		public void load_spriteset_manager(string folder) {
			spritesetmanager = new Hmwd.SpritesetManager(folder);
		}

		public void print_all() {
			tilesetmanager.print_all();
			mapmanager.print_all();
			spritesetmanager.print_all();
		}
	}
}
