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
	/**
	 * Klasse zur Speicherung einer Tileset Referenz.
	 * Jede Map hat eine oder mehrere Tiles die aber vom TileManager verwaltet werden.
	 * Daher dient diese Klasse fuer Maps zur Speicherung der Referenzdaten und Zusatzinformatioen.
	 * @see rpg.Map
	 * @see rpg.Tileset
	 * @see rpg.TilesetManager
	 */
	public class TilesetReference : GLib.Object {
		/**
		 * Quelle des Tilesets.
		 */
		public rpg.Tileset source { get; construct set; }
		/**
		 * The first global tile ID of this tileset (this global ID maps to the first tile in this tileset).
		 */
		public int firstgid { get; construct set; }
		/**
		 * Konstrukter
		 * @param firstgid Die erste gid die von diesem diesem Tileset verwendet wird
		 * @param source Tileset-Quelle als Referenzangabe.
		 */
		public TilesetReference(int firstgid, rpg.Tileset source) {
			GLib.Object(firstgid:firstgid, source:source);
		}
		construct {
			
		}
		/**
		 * Gibt alle Werte des Tilesets und der Reference auf der Konsole aus
		 */
		public void print_values() {
			print("==TilesetReference==\n");
			print("firstgid: %u\n", firstgid);
			source.print_values();
		}
	}
}
