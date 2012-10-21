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
	 * Klasse fuer Maplayer.
	 */
	public class Layer : Object {
		/**
		 * Name des Layers
		 */
		public string name { get; set; }
		/**
		 * z-offset zum Zeichnen dieses Layers
		 */
		public double zoff { get; set; }
		/**
		 * Breite des Layers
		 */
		public int width { get; set; }
		/**
		 * Hoehe des Layers
		 */
		public int height { get; set; }
		/**
		 * Tiles des Layers
		 */
		public Hmwd.Tile[,] tiles { get; set; }
		/**
		 * Zur ueberpruefung ob dieser Layer Kollision erzeugt.
		 */
		public bool collision { get; set; }
		/**
		 * Layertextur, die Pixel der zusammen gesetzten Tiles für eine Layer
		 */
		public GdkTexture tex { get; construct set; }

		/**
		 * Konstruktor
		 */
		public Layer() {

		}
		/**
		 * Konstruktor mit Groessenangaben
		 */
		public Layer.sized(int width, int height) {
			Object(name:"new Layer", width:width, height:height, zoff:0);
		}
		/**
		 * Konstruktor mit allen Werten non-default
		 */
		public Layer.all(string name, double zoff, bool collision, int width, int height) {
			//this.tiles = tiles; //TODO make this work in node-gir
			Object(name:name, zoff:zoff, width:width, height:height, collision:collision);
		}
		public Hmwd.Tile get_tile_from_coordinate(uint x, uint y) {
			return tiles[x,y];
		}
		/**
		 * Ladet die Pixel fuer den Layer.
		 */
		public void merge(int tile_width, int tile_height) {
			tex = new GdkTexture.empty(width*tile_width, height*tile_height);

			for(int x=0; x<width; ++x) {
				for(int y=0; y<height; ++y) {
					if(tiles[x,y].tile_type != TileType.NO_TILE)
						tiles[x,y].tex.pixbuf.copy_area(0, 0, tile_width, tile_height, tex.pixbuf, x*tile_width, y*tile_height);
				}
			}

		}
		/**
		 * Gibt alle Werte des Layers (bis auf die Tiles) auf der Konsole aus
		 */
		public void print_values() {
			print("==Layer==\n");
			print("name: %s\n", name);
			print("zoff: %f\n", zoff);
			print("width: %u\n", width);
			print("height: %u\n", height);
			print("collision: %s\n", collision.to_string());
		}
		/**
		 * Gibt die Tiles des Layers auf der Konsole aus
		 */
		public void print_tiles() {
			print("==Tiles==\n");
			for (int y=0;y<height;y++) {
				for (int x=0;x<width;x++) {
					print("%u ", tiles[x,y].tile_type);
				}
				print("\n");
			}
		}
		/**
		 * Gibt alle Werte des Layers und dessen Tiles auf der Konsole aus
		 */
		public void print_all() {
			print_values();
			print_tiles();
		}
	}
}