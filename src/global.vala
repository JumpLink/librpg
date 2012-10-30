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

/**
 * Library zur Verwaltung von Ressourcen eines 2D-Spiels basierend auf [[http://www.mapeditor.org/|Tiled]].
 */
namespace rpg {
	public static int Round(double num) {
		(num > 0) ? (num+= 0.5) : (num+= (-0.5));
		return (int)num;
	}
	public static bool toggle(bool b) {
		return b ? false : true;
	}
	/**
	 * Gibt eines der uebergebenen TilesetReference's zur gid passenden TilesetReference zurueck.
	 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
	 * aber groesser ist als alle anderen firstgids
	 * @param tilesetrefs Liste von TilesetReference's in der gesucht werden soll.
	 * @param gid Die zu der das passende Tileset gesucht werden soll.
	 * @return Das gefundene TilesetReference.
	 */
	public static TilesetReference get_tilesetref_from_gid(Gee.List<rpg.TilesetReference> tilesetrefs, uint gid) {	
		rpg.TilesetReference found = tilesetrefs[0];
		foreach (rpg.TilesetReference tsr in tilesetrefs) {
			if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
				found = tsr;
		}
		return found;
	}
}