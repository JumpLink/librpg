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
using Gdk;
using rpg;
namespace rpg {
	/**
	 * Klasse fuer nicht unterteilte Tiles
	 */
		public class RegularTile : Tile {
			/**
			 * Konstruktor erzeugt standardmaessig ein Tile vom Typ rpg.TileType.NO_TILE
			 * mit einer leeren Textur
			 * @see rpg.TileType.EMPTY_TILE
			 */
			public RegularTile () {
				Object(tex:new GdkTexture(), tile_type:rpg.TileType.NO_TILE);
			}

			/**
			 * Konstruktor mit uebergabe eines bereits existierenden und zu verwendenen Pixbuf.
			 * @param pixbuf Pixelbufer der in das Tile uebernommen werden soll.
			 */
			public RegularTile.from_pixbuf (Pixbuf pixbuf) {
				Object(tex:new GdkTexture.from_pixbuf(pixbuf), tile_type:rpg.TileType.EMPTY_TILE);
			}
			construct {
				
			}
			/**
			 * {@inheritDoc}
			 * @see rpg.Tile.print_values
			 */
			public override void print_values (){
				print("ich bin ein RegularTile: ");
				//print("gid: %u",gid);
				print("type: %u\n",tile_type);
				if(tile_type != TileType.NO_TILE) {
					tex.print_values();
				}
			}
			/**
			 * {@inheritDoc}
			 * @see rpg.Tile.calc_edges
			 */
			public override void calc_edges (TileType[] neighbours) {
				//nichts
			}
	}
}