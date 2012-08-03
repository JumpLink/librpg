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
public GdkTextureFactory TEXTUREFACTORY;
public Hmwd.TileSetManager TILESETMANAGER;
public Hmwd.MapManager MAPMANAGER;
public Hmwd.SpriteSetManager SPRITESETMANAGER;
class Main {
	public static void init() {
		TEXTUREFACTORY = new GdkTextureFactory();
		TILESETMANAGER = new Hmwd.TileSetManager("./data/tileset/");
		MAPMANAGER = new Hmwd.MapManager("./data/map/");
		SPRITESETMANAGER = new Hmwd.SpriteSetManager();
		//Gee.List<Player> PLAYERS = new Gee.ArrayList<Player>();
		//PLAYERS.add (new Player("Hero", SPRITESETMANAGER.getFromName("Hero")));
		//MAPMANAGER.printAll();
		//this.SPRITESETMANAGER.printAll();
		//PLAYERS[0].printAll();
		//this.CURRENT_MAP = MAPMANAGER.getFromFilename("testmap.tmx");
	}
	public static int main (string[] args) {
		Main.init();
		return 0;
	}
}
