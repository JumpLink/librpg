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
		 * Layertextur, die Pixel der zusammen gesetzten Tiles für eine Layer.
		 * Erst gesetzt nachdem ''merge ()'' ausgeführt wurde.
		 * 
		 * @see merge
		 */
		public GdkTexture tex { get; set; }

		/**
		 * Get layer as json. If you wish a smaller json please use ''get_json_indi ()''.
		 * <<BR>><<BR>>
		 * Node: This is only a wrapper to ''get_json_indi ()''.
		 *
		 * @see get_json_indi
		 */
		public Json.Node json {
			owned get { return get_json_indi(); }
		}

		/**
		 * Get layer as json ''string''. If you wish a smaller json string please use ''get_json_indi ()''.
		 * <<BR>><<BR>>
		 * Node: This is only a wrapper to ''get_json_indi_as_str ()''.
		 *
		 * @see get_json_indi_as_str
		 */
		public string json_str {
			owned get { return get_json_indi_as_str(); }
		}		

		/**
		 * Konstruktor
		 */
		public Layer() {

		}

		/**
		 * Konstruktor mit Groessenangaben
		 */
		public Layer.sized (int width, int height) {
			GLib.Object(name:"new Layer", width:width, height:height, zoff:0);
		}

		/**
		 * Konstruktor mit allen Werten non-default
		 */
		public Layer.all (string name, double zoff, bool collision, int width, int height) {
			//this.tiles = tiles; //TODO make this work in node-gir
			GLib.Object(name:name, zoff:zoff, width:width, height:height, collision:collision);
		}

		/**
		 * Get map as individually json. You can define which properties should be included.
		 *
		 * @param with_name if true json includes name.
		 * @param with_zoff if true json includes zoff.
		 * @param with_size if true json includes width and height.
		 * @param with_collision if true json includes collision.
		 * @param with_data if true json includes data (array of global ids of all tiles).
		 * @param with_texture if true json includes the texture of the layer as a png base64 string (empty if texture is unset, use merge() to set the texture).
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi (bool with_name = true, bool with_zoff = true, bool with_size = true, bool with_collision = true, bool with_data = true, bool with_texture = false) {
			
			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);
			
			if(with_name)
				object.set_string_member("name", name);
			if(with_zoff)
				object.set_double_member("zoff", zoff);
			if(with_size) {
				object.set_int_member("width", width);
				object.set_int_member("height", height);
			}
			if(with_collision)
				object.set_boolean_member("collision", collision);

			if(with_data) {
				var data = new Json.Array();

				for (int y=0;y<height;y++) {
					for (int x=0;x<width;x++) {
						data.add_int_element (tiles[x,y].gid);
					}
				}

				object.set_array_member ("data", data);
			}

			if(with_texture) {
				if(tex.width > 0)
					object.set_string_member("texture", tex.base64);
				else
					object.set_string_member("texture", "unset");
			}

			return root;
		}

		/**
		 * Get map as individually json ''string''. You can define which properties should be included.
		 *
		 * @param with_name if true json includes name.
		 * @param with_zoff if true json includes zoff.
		 * @param with_size if true json includes width and height.
		 * @param with_collision if true json includes collision.
		 * @param with_data if true json includes data (array of global ids of all tiles).
		 * @return The new generated json string.
		 *
		 * @see rpg.json_to_string
		 */
		public string get_json_indi_as_str (bool with_name = true, bool with_zoff = true, bool with_size = true, bool with_collision = true, bool with_data = true, bool with_texture = false) {
			return rpg.json_to_string(get_json_indi(with_name, with_zoff, with_size, with_collision, with_data, with_texture));
		}

		public rpg.Tile get_tile_from_coordinate(uint x, uint y) {
			return tiles[x,y];
		}

		/**
		 * Generiert eine Layer-Textur aus den vorhandenen Tiles.
		 * 
		 * @param tile_width width of one tile
		 * @param tile_height height of one tile
		 */
		public void merge (int tile_width, int tile_height) {
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