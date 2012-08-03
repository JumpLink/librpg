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
	/**
	 * Klasse zur Speicherung einer TileSet Referenz.
	 * Jede Map hat eine oder mehrere Tiles die aber vom TileManager verwaltet werden.
	 * Daher dient diese Klasse fuer Maps zur Speicherung der Referenzdaten und Zusatzinformatioen.
	 * @see HMP.Map
	 * @see HMP.TileSet
	 * @see HMP.TileSetManager
	 */
	public class TileSetReference {
		/**
		 * Quelle des TileSets.
		 */
		public HMP.TileSet source;
		/**
		 * The first global tile ID of this tileset (this global ID maps to the first tile in this tileset).
		 */
		public uint firstgid;
		/**
		 * Konstrukter
		 * @param firstgid Die erste gid die von diesem diesem TileSet verwendet wird
		 * @param source TileSet-Quelle als Referenzangabe.
		 */
		public TileSetReference(uint firstgid, HMP.TileSet source) {

			this.firstgid = firstgid;
			this.source = source;
		}
		/**
		 * Gibt alle Werte des TileSets und der Reference auf der Konsole aus
		 */
		public void printValues() {
			print("==TileSetReference==\n");
			print("firstgid: %u\n", firstgid);
			source.printValues();
		}
	}
}
