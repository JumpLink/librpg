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
using Gee;
using Gdk;
//using GLib; //Fuer assertions
using Json;
using rpg;
namespace rpg {
	/**
	 * Klasse fuer Tilesets
	 */
	public class Tileset : GLib.Object {
		/**
		 * Name des Tilesets.
		 */
		public string name { get; set; }
		/**
		 * Dateiname des Tilesets.
		 */
		public string filename { get; construct set; }
		/**
		 * Breite eines Tiles
		 */
		public int tile_width { get; set; }
		/**
		 * Hoehe eines Tiles
		 */
		public int tile_height { get; set; }
		/**
		 * Dateiname des Tileset-Bildes
		 */
		public string source { get; set; }
		/**
		 * transparencyparente Farbe im Tileset
		 */
		public string transparency { get; set; }
		/**
		 * Gesamtbreite des Tilesets
		 */
		public int width { get; set; }
		/**
		 * Gesamthoehe des Tilesets
		 */
		public int height { get; set; }
		/**
		 * Die Tiles in Form eines 2D-Array des Tilesets
		 */
		public Tile[,] tile { get; set; }

		public int count_y {
			get { return (height / tile_height); }
		}

		public int count_x {
			get { return (width / tile_width); }
		}

		public GdkTexture tex { get; set; }

		/**
		 * Konstruktor
		 */
		public Tileset(string filename) {
			GLib.Object(filename:filename);
		}

		/**
		 * Get tileset as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(TilesetJsonParam tileset_params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);
			
			if(tileset_params.name)
				object.set_string_member("name", name);

			if(tileset_params.filename)
				object.set_string_member("filename", filename);

			if(tileset_params.tile_size) {
				object.set_int_member("tile_width", tile_width);
				object.set_int_member("tile_height", tile_height);
			}

			if(tileset_params.source) {
				object.set_string_member("source", source);
			}

			if(tileset_params.transparency) {
				object.set_string_member("transparency", transparency);
			}

			if(tileset_params.size) {
				object.set_int_member("width", width);
				object.set_int_member("height", height);
			}

			if(tileset_params.count) {
				object.set_int_member("count_y", count_y);
				object.set_int_member("count_x", count_x);
			}

			if(tileset_params.tex)
				object.set_string_member("texture", tex.base64);

			if(tileset_params.tile.or_gate()) {

				var first_dimension = new Json.Array();
				
				for (int y=0;(y<count_y);y++) {

					var secound_dimension = new Json.Array();
					for (int x=0;(x<count_x);x++) {
						secound_dimension.add_object_element( tile[x,y].get_json_indi(tileset_params.tile).get_object() );
					}
					first_dimension.add_array_element(secound_dimension);
				}

				object.set_array_member("tiles", first_dimension);
			}

			return root;
		}

		/**
		 * Like ''get_json_indi ()'' but returns the json string using ''rpg.json_to_string ()'', please see ''get_json_indi ()'' for parameter information.
		 *
		 * @return The new generated json string.
		 *
		 * @see rpg.json_to_string
		 * @see get_json_indi
		 */
		public string get_json_indi_as_str(TilesetJsonParam tileset_params) {
			return json_to_string(get_json_indi(tileset_params));
		}

		/**
		 * Gibt ein gesuchtes Tile anhand seines Index zurueck.
		 *
		 * @param index Index des gesuchten Tiles
		 */
		public rpg.Tile get_tile_from_index(int index)
		requires (index >= 0)
		{
			int count = 0;
			for (int y=0;(y<count_y);y++) {
				for (int x=0;(x<count_x);x++) {
					if (count == index) {
						return tile[x,y];
					}
					count++;
				}
			}
			error("Tile mit index %i nicht gefunden!", index);
		}

		/**
		 * Ladet die Pixel fuer die Tiles.
		 * Zur Zeit alle noch als RegularTile.
		 */
		public void split(string folder) {
			tex = new GdkTexture.from_file(folder+source);
			int split_width = (int) tile_width;
			int split_height = (int) tile_height;
			tile = new Tile[count_x,count_y];
			Pixbuf pxb = tex.pixbuf;
			for(int y = 0; y < count_y; y++) {
				for(int x = 0; x < count_x; x++) {
					Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), split_width, split_height);
					pxb.copy_area((int) split_width*x, (int) split_height*y, (int) split_width, (int) split_height, split, 0, 0);
					tile[x,y] = new RegularTile.from_pixbuf(split);
				}
			}
		}

		/**
		 * Speichert alle Tiles als Datei.
		 * @param folder Ordner in dem die Bilder gespeichert werden sollen.
		 */
		public void save(string folder = "./tmp/") {
			for (int y=0;y<count_y;y++) {
				for (int x=0;x<count_x;x++) {
					tile[x,y].save(folder+name+"_y"+y.to_string()+"_x"+x.to_string()+".png");
				}
			}
		}

		/**
		 * Gibt alle Werte Tiles auf der Konsole aus
		 */
		public void print_tiles() {
			print("==Tiles==\n");
			for (int y=0;y<count_y;y++) {
				for (int x=0;x<count_x;x++) {
					tile[x,y].print_values();
				}
				print("\n");
			}
			print("\nWenn du dies siehst konnten alle Tiles durchlaufen werden\n");
		}
		/**
		 * Gibt alle Werte des Tilesets auf der Konsole aus
		 */
		public void print_values() {
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("tile_width: %u\n", tile_width);
			print("tile_height: %u\n", tile_height);
			print("source: %s\n", source);
			print("transparency: %s\n", transparency);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alle Werte und die Tiles des Tilesets auf der Konsole aus
		 */
		public void printAll() {
			print_values();
			print_tiles();
		}
	}

	public class TilesetJsonParam:GLib.Object {

		/**
		 * If true json includes name.
		 */
		public bool name { get; construct set; default=false; }

		/**
		 * If true json includes filename.
		 */
		public bool filename { get; construct set; default=false; }

		/**
		 * If true json includes tilewidth and tileheight.
		 */
		public bool tile_size { get; construct set; default=false; }

		/**
		 * If true json includes image-source.
		 */
		public bool source { get; construct set; default=false; }

		/**
		 * If true json includes transparency
		 */
		public bool transparency { get; construct set; default=false; }

		/**
		 * If true json includes width and height.
		 */
		public bool size { get; construct set; default=false; }

		/**
		 * If true json includes count_y and count_x.
		 */
		public bool count { get; construct set; default=false; }

		/**
		 * If true json includes pixbuf.
		 */
		public bool tex { get; construct set; default=false; }

		/**
		 * If true json includes array of tiles
		 */
		public TileJsonParam tile { get; construct set; default=new TileJsonParam(); }

		public TilesetJsonParam(bool name = false, bool filename = false, bool tile_size = false, bool source = false, bool transparency = false, bool size = false, bool count = false, bool tex = false, TileJsonParam tile = new TileJsonParam()) {
			this.name = name;
			this.filename = filename;
			this.tile_size = tile_size;
			this.source = source;
			this.transparency = transparency;
			this.size = size;
			this.count = count;
			this.tex = tex;
			this.tile = tile;
		}

		/*
		 * @return true if any properity of this object is true, false if all properities false
		 */
		public bool or_gate() {
			return ( name || filename || tile_size || source || transparency || size || tile.or_gate());
		}
	}

}