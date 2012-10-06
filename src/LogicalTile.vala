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
namespace Hmwd {
	/**
	 * Klasse fuer logische Eigenschaften eines Tiles.
	 */
	public class LogicalTile : Object {

		/**
		 * Eigenschaften.
		 */
		public Hmwd.TileType tile_type { get; set; }

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