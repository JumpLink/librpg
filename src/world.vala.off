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
using Gee;
using HMP;
namespace HMP {
	/**
	 * Klasse fuer die gesamte Welt
	 */
	public class World {
		/**
		 * Globaler TileSetManager fuer zugriff auf alle TileSets von ueberall aus.
		 */
		public TileSetManager TILESETMANAGER;
		/**
		 * Globaler MapManager fuer zugriff auf alle Maps von ueberall aus.
		 */
		public MapManager MAPMANAGER;
		/**
		 * Globale Map fuer die gerade aktive Map
		 */
		public Map CURRENT_MAP;
		/**
		 * 
		 */
		public SpriteSetManager SPRITESETMANAGER;
		/**
		 * Entitaeten in der Welt
		 */
		public Gee.List<Player> PLAYERS = new Gee.ArrayList<Player>();
		/**
		 * Datum und Uhrzeit.
		 */
		public Date date = new Date();
		/* TODO Wetter, ... */

		/**
		 * Konstruktor
		 */
		public World() {
		}

		public void init() {
			/* Globalen TileSetManager erzeugen */
			this.TILESETMANAGER = new HMP.TileSetManager("./data/tileset/");
			/* Globalen Mapmanager erzeugen */
			this.MAPMANAGER = new HMP.MapManager("./data/map/");
			this.MAPMANAGER.printAll();
			/* Globalen SpriteSetManager erzeugen */
			this.SPRITESETMANAGER = new HMP.SpriteSetManager();
			//this.SPRITESETMANAGER.printAll();
			PLAYERS.add (new Player("Hero", SPRITESETMANAGER.getFromName("Hero")));
			PLAYERS[0].printAll();
			/* Globle Startmap auswaehlen */
			this.CURRENT_MAP = MAPMANAGER.getFromFilename("testmap.tmx");
			foreach (Player p in PLAYERS) {
				CURRENT_MAP.entities.add(p);
			}
			CURRENT_MAP.entities.add (new NPC(new Coord.nondefault (27.0, 27.0), SPRITESETMANAGER.getFromName("hase")));
			CURRENT_MAP.entities.add (new ToolEntity(new Coord.nondefault (100.0, 50.0), 
				SPRITESETMANAGER.getFromName("hase"), 
				new MultiHoe()));
		}

		public void timer ()
		requires (PLAYERS != null)
		{	
			foreach (Player p in PLAYERS)
				p.timer();
			date.time ();
		}

		/**
		 * Altert alles um einen Tag.
		 */
		public void age () {
			MAPMANAGER.age();
			date.age ();
		}
	}
}
