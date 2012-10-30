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
	 * Klasse fuer logische Eigenschaften eines Tiles.
	 */
	public class LogicalTile : Object {

		/**
		 * Eigenschaften.
		 */
		public rpg.TileType tile_type { get; set; }

		/**
		 * Pflanze.
		 */
		public Plant plant { get; set; }

		/**
		 * Ereignis.
		 */
		//public EventLocation event;

		public LogicalTile () {
			Object(tile_type:TileType.EMPTY_TILE	);
		}
		construct {
			
		}
	}
}