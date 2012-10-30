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
	 * Klasse fuer Subtiles, ein Tile kann auch aus mehreren Subtiles bestehen.
	 * Sie wird fuer zusammengesetzte Tiles verwendet um beispielsweise Wegkanten
	 * darzustellen.
	 */
	public class SubTile : Object {
	 	public EdgeShape edge { get; construct set; }
	 	/**
	 	 * Konstruktor, erzeugt ein leeres SubTile vom Typ EdgeShape.FULL.
	 	 * @see EdgeShape.FULL
	 	 */
	 	public SubTile () {
	 		Object(edge: EdgeShape.FULL);
	 	}
	 	/**
		 * Aehnlich wie: 
		 * {@link rpg.Tile.calc_edges}
		 */
	 	public void calc_edges (TileType [] neighbours, TileType type, uint location) {
	 		assert (neighbours.length == 3);
	 		if (neighbours[0] == type && neighbours[1] == type && neighbours[2] == type)
	 			edge = EdgeShape.FULL;
	 		else if (neighbours[0] == type && neighbours[1] != type && neighbours[2] == type)
	 			edge = EdgeShape.INNER_CORNER;
	 		else if (neighbours[0] != type && neighbours[2] != type)
	 			edge = EdgeShape.OUTER_CORNER;
	 		else if (neighbours[0] == type && neighbours[1] == type && neighbours[2] != type)
	 			edge = (location % 2 == 0) ? EdgeShape.V_LINE : EdgeShape.H_LINE;
	 		else if (neighbours[0] != type && neighbours[1] == type && neighbours[2] == type)
	 			edge = (location % 2 == 0) ? EdgeShape.H_LINE : EdgeShape.V_LINE;
	 	}
	}
}