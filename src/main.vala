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
using HMP;
namespace HMP {
	public GdkTextureFactory TEXTUREFACTORY;
	public TileSetManager TILESETMANAGER;
	public MapManager MAPMANAGER;
	public SpriteSetManager SPRITESETMANAGER;
	class Game {
		public static int main (string[] args) {
			TEXTUREFACTORY = new GdkTextureFactory();
			TILESETMANAGER = new HMP.TileSetManager("./data/tileset/");
			MAPMANAGER = new HMP.MapManager("./data/map/");
			SPRITESETMANAGER = new HMP.SpriteSetManager();
			//Gee.List<Player> PLAYERS = new Gee.ArrayList<Player>();
			//PLAYERS.add (new Player("Hero", SPRITESETMANAGER.getFromName("Hero")));
			//MAPMANAGER.printAll();
			//this.SPRITESETMANAGER.printAll();
			//PLAYERS[0].printAll();
			//this.CURRENT_MAP = MAPMANAGER.getFromFilename("testmap.tmx");
			return 0;
		}
	}
}
