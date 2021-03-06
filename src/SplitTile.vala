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
	 * Klasse fuer unterteilte Tiles
	 */
		public class SplitTile : Tile {
			/**
			 * Einzelteile
			 */
			public SubTile[] subTiles;

			/**
			 * Konstruktor 
			 */
			public SplitTile () {
				subTiles = new SubTile [4];
				foreach (SubTile s in subTiles)
					s = new SubTile ();
			}
			/**
			 * {@inheritDoc}
			 * @see rpg.Tile.print_values
			 */
			public override void print_values (){
				print("ich bin ein reftile: ");
				print("type: %u\n",tile_type);
			}
			/**
			 * {@inheritDoc}
			 * @see rpg.Tile.calc_edges
			 */
			public override void calc_edges (TileType[] neighbours) {
				assert (neighbours.length == 8);
				TileType[] n = new TileType[3];
				for (uint s = 0; s < 4; ++s) {
					for (uint t = 0; t < 3; ++t)
						n[t] = neighbours[(2 * s + t) % 8];
					subTiles[s].calc_edges (n, tile_type, s);
				}
			}
	}
}