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

	public class Data : Object {
		public Hmwd.TileSetManager tilesetmanager { get; set; }
		public Hmwd.MapManager mapmanager { get; set; }
		public Hmwd.SpriteSetManager spritesetmanager { get; set; }

		public Data() {
			Object();
		}

		construct{

		}

		public void loadTileSetManager(string folder) {
			tilesetmanager = new Hmwd.TileSetManager(folder);
		}

		public void loadMapManager(string folder) {
			if(tilesetmanager != null)
				mapmanager = new Hmwd.MapManager(folder, tilesetmanager);
			else {
				printerr("MapManager: You must load tilesetmanager first!\n");
			}
		}

		public void loadSpriteSetManager(string folder) {
			spritesetmanager = new Hmwd.SpriteSetManager(folder);
		}

		public void printAll() {
			tilesetmanager.printAll();
			mapmanager.printAll();
			spritesetmanager.printAll();
		}

		// public static void load() {

		// 	public Hmwd.Data DATA = new Hmwd.Data();
		// 	public Hmwd.TileSetManager DATA.TILESETMANAGER = new Hmwd.TileSetManager("./data/tileset/");
		// 	public Hmwd.MapManager DATA.MAPMANAGER = new Hmwd.MapManager("./data/map/");
		// 	public Hmwd.SpriteSetManager DATA.SPRITESETMANAGER = new Hmwd.SpriteSetManager();
		// 	DATA.SPRITESETMANAGER.loadAllFromFolder("./data/spriteset/"); // WORKAROUND

		// 	// Hmwd.SPRITESETMANAGER = new Hmwd.SpriteSetManager();
		// 	// SPRITESETMANAGER.loadAllFromFolder("./data/spriteset/"); // WORKAROUND
		// 	//Gee.List<Player> PLAYERS = new Gee.ArrayList<Player>();
		// 	//PLAYERS.add (new Player("Hero", SPRITESETMANAGER.getFromName("Hero")));
		// 	//MAPMANAGER.printAll();
		// 	//this.SPRITESETMANAGER.printAll();
		// 	//PLAYERS[0].printAll();
		// 	//this.CURRENT_MAP = MAPMANAGER.getFromFilename("testmap.tmx");
		// }
	}
}
