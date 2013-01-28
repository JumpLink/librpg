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
using Json;
using rpg;
namespace rpg {
	/**
	 * Klasse fuer Maplayer.
	 */
	public class Layer : GLib.Object {
		/**
		 * Name des Layers
		 */
		public string name { get; set; }
		/**
		 * z-offset zum Zeichnen dieses Layers
		 */
		public double zoff { get; set; } //TODO as list of properties?
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
		public rpg.Tile[,] tiles { get; set; }
		/**
		 * Zur ueberpruefung ob dieser Layer Kollision erzeugt.
		 */
		public bool collision { get; set; } //TODO as list of properties?
		/**
		 * Layertextur, die Pixel der zusammen gesetzten Tiles für eine Layer
		 */
		public GdkTexture tex { get; construct set; }

		/**
		 * Get layer as json
		 */
		public Json.Node json {
			owned get {
				
				var root = new Json.Node(NodeType.OBJECT);
				var object = new Json.Object();

				root.set_object(object);
				
				object.set_string_member("name", name);
				object.set_double_member("zoff", zoff);
				object.set_int_member("width", width);
				object.set_int_member("height", height);
				object.set_boolean_member("collision", collision);

				var data = new Json.Array();

				for (int y=0;y<height;y++) {
					for (int x=0;x<width;x++) {
						data.add_int_element (tiles[x,y].gid);
					}
				}

				object.set_array_member ("data", data);

				return root;
			}
		}

		/**
		 * Get layer as json string
		 */
		public string json_str {
			owned get {return json_to_string(json);}
		}

		/**
		 * Konstruktor
		 */
		public Layer() {

		}
		/**
		 * Konstruktor mit Groessenangaben
		 */
		public Layer.sized(int width, int height) {
			GLib.Object(name:"new Layer", width:width, height:height, zoff:0);
		}
		/**
		 * Konstruktor mit allen Werten non-default
		 */
		public Layer.all(string name, double zoff, bool collision, int width, int height) {
			//this.tiles = tiles; //TODO make this work in node-gir
			GLib.Object(name:name, zoff:zoff, width:width, height:height, collision:collision);
		}
		public rpg.Tile get_tile_from_coordinate(uint x, uint y) {
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