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
	public class MapLayer : GLib.Object {

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

		/** TODO not as properity?
		 * Layertextur, die Pixel der zusammen gesetzten Tiles für eine Layer.
		 * Erst gesetzt nachdem ''merge ()'' ausgeführt wurde.
		 * 
		 * @see merge
		 */
		public GdkTexture tex {
			owned get {
				return merge (16, 16); //WORKAROUND
			}
		}

		/**
		 * Konstruktor
		 */
		public MapLayer() {

		}

		/**
		 * Konstruktor mit Groessenangaben
		 */
		public MapLayer.sized (int width, int height) {
			GLib.Object(name:"new MapLayer", width:width, height:height, zoff:0);
		}

		/**
		 * Konstruktor mit allen Werten non-default
		 */
		public MapLayer.all (string name, double zoff, bool collision, int width, int height) {
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
		public Json.Node get_json_indi ( MapLayerJsonParam map_layer_params ) {
			
			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);
			
			if(map_layer_params.with_name)
				object.set_string_member("name", name);
			if(map_layer_params.with_zoff)
				object.set_double_member("zoff", zoff);
			if(map_layer_params.with_size) {
				object.set_int_member("width", width);
				object.set_int_member("height", height);
			}
			if(map_layer_params.with_collision)
				object.set_boolean_member("collision", collision);

			if(map_layer_params.with_data) {
				var data = new Json.Array();

				for (int y=0;y<height;y++) {
					for (int x=0;x<width;x++) {
						data.add_int_element (tiles[x,y].gid);
					}
				}

				object.set_array_member ("data", data);
			}

			if(map_layer_params.with_texture) {
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
		public string get_json_indi_as_str ( MapLayerJsonParam map_layer_params ) {
			return rpg.json_to_string(get_json_indi(map_layer_params));
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
		public GdkTexture merge (int tile_width, int tile_height) {
			var tex = new GdkTexture.empty(width*tile_width, height*tile_height);

			for(int x=0; x<width; ++x) {
				for(int y=0; y<height; ++y) {
					if(tiles[x,y].tile_type != TileType.NO_TILE)
						tiles[x,y].tex.pixbuf.copy_area(0, 0, tile_width, tile_height, tex.pixbuf, x*tile_width, y*tile_height);
				}
			}
			return tex;
		}
	}

	public class MapLayerJsonParam : GLib.Object {
		/*
		 * if true json includes name.
		 */
		public bool with_name { get; construct set; default=false; }
		/*
		 * if true json includes zoff.
		 */
		public bool with_zoff { get; construct set; default=false; }
		/*
		 * if true json includes width and height.
		 */
		public bool with_size { get; construct set; default=false; }
		/*
		 * if true json includes collision.
		 */
		public bool with_collision { get; construct set; default=false; }
		/*
		 * if true json includes data (array of global ids of all tiles).
		 */
		public bool with_data { get; construct set; default=false; }
		/*
		 * if true json includes the texture of the layer as a png base64 string (empty if texture is unset, use merge() to set the texture).
		 */
		public bool with_texture { get; construct set; default=false; }

		public MapLayerJsonParam (bool with_name = false, bool with_zoff = false, bool with_size = false, bool with_collision = false, bool with_data = false, bool with_texture = false) {
			GLib.Object(with_name:with_name, with_zoff:with_zoff, with_size:with_size, with_collision:with_collision, with_data:with_data, with_texture:with_texture);
		}

		public bool or_gate() {
			return with_name || with_zoff || with_size || with_collision || with_data || with_texture;
		}
	}
}