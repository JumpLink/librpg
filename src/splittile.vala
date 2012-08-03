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
			 * @see HMP.Tile.printValues
			 */
			public override void printValues (){
				print("ich bin ein reftile: ");
				print("type: %u\n",type);
			}
			/**
			 * {@inheritDoc}
			 * @see HMP.Tile.calcEdges
			 */
			public override void calcEdges (TileType[] neighbours) {
				assert (neighbours.length == 8);
				TileType[] n = new TileType[3];
				for (uint s = 0; s < 4; ++s) {
					for (uint t = 0; t < 3; ++t)
						n[t] = neighbours[(2 * s + t) % 8];
					subTiles[s].calcEdge (n, type, s);
				}
			}
	}
}