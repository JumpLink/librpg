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
using Gdk;
namespace Hmwd {
	/**
	 * Allgemeine Klasse fuer Tiles
	 */
	public abstract class Tile : Object {
		/**
		 * Tiletextur, die Pixel des Tiles
		 */
		public GdkTexture tex { get; construct set; }

		public int gid { get; set; }
		/**
		 * Gibt die Breite eines Tiles zurueck.
		 */
		public int width {
			get { if (tile_type != TileType.NO_TILE) return tex.width; else return 0; }
		}
		/**
		 * Gibt die Hoehe eines Tiles zurueck.
		 */
		public int height {
			get { if (tile_type != TileType.NO_TILE) return tex.height; else return 0; }
		}
		/**
		 * Tiletyp
		 */
		public TileType tile_type { get; construct set; }
		/**
		 * Konstruktor erzeugt ein leeres Tile vom Typ TileType.NO_TILE
		 * @see TileType.NO_TILE
		 */
		public Tile() {
			Object(tile_type: TileType.NO_TILE);
		}
		construct {

    	}
		/**
		 * Speichert das Tile mit dem Dateiname filename als Datei
		 * @param filename Zu verwendender Dateiname
		 */
		public virtual void save (string filename) {
			//if(tile_type != TileType.NO_TILE && tile_type != TileType.EMPTY_TILE) {
				//print("Tile save\n");
				tex.save(filename);
			//}
		}
		/**
		 * Zeichnet das Tile an einer Bildschirmposition.
		 * @param x linke x-Koordinate
		 * @param y untere y-Koordinate
		 * @param zoff Angabe der hoehe des Tiles Z.B unter, ueber, gleich, .. dem Held.
		 */
		//public abstract void draw (double x, double y, double zoff);
		/**
		 * Gibt alle Werte eines Tiles auf der Konsole aus.
		 */
		public abstract void print_values ();
		/**
		 * Berechnet anhand der Nachbartiles das aussehen dieses Tiles,
		 * dies findet beispielsweise bei Wegen, Strassen, Sand oder Grass verwendung.
		 * TODO an Ole, ueberpruefe diese Beschreibung!
		 */
		public abstract void calcEdges (TileType[] neighbours);
	}
}