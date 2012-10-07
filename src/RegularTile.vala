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
using Gdk;
using Hmwd;
namespace Hmwd {
	/**
	 * Klasse fuer nicht unterteilte Tiles
	 */
		public class RegularTile : Tile {
			/**
			 * Konstruktor erzeugt standardmaessig ein Tile vom Typ Hmwd.TileType.NO_TILE
			 * mit einer leeren Textur
			 * @see Hmwd.TileType.EMPTY_TILE
			 */
			public RegularTile () {
				Object(tex:new GdkTexture(), tile_type:Hmwd.TileType.NO_TILE);
			}

			/**
			 * Konstruktor mit uebergabe eines bereits existierenden und zu verwendenen Pixbuf.
			 * @param pixbuf Pixelbufer der in das Tile uebernommen werden soll.
			 */
			public RegularTile.fromPixbuf (Pixbuf pixbuf) {
				Object(tex:new GdkTexture.fromPixbuf(pixbuf), tile_type:Hmwd.TileType.EMPTY_TILE);
			}
			construct {
				
			}
			/**
			 * {@inheritDoc}
			 * @see Hmwd.Tile.print_values
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
			 * @see Hmwd.Tile.calcEdges
			 */
			public override void calcEdges (TileType[] neighbours) {
				//nichts
			}
	}
}