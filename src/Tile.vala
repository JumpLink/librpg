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
using Gdk;
using Json;
namespace rpg {
	/**
	 * Allgemeine Klasse fuer Tiles
	 */
	public abstract class Tile : GLib.Object {
		/**
		 * Tiletextur, die Pixel des Tiles
		 */
		public GdkTexture tex { get; construct set; }

		public int gid { get; set; }

		/**
		 * Gibt die Breite eines Tiles zurueck.
		 */
		public int width {
			get { if (tile_type != TileType.NO_TILE) return tex.width; else return 0; }
		}

		/**
		 * Gibt die Hoehe eines Tiles zurueck.
		 */
		public int height {
			get { if (tile_type != TileType.NO_TILE) return tex.height; else return 0; }
		}

		/**
		 * Tiletyp
		 */
		public TileType tile_type { get; construct set; }

		/**
		 * Konstruktor erzeugt ein leeres Tile vom Typ TileType.NO_TILE
		 * @see TileType.NO_TILE
		 */
		public Tile() {
			GLib.Object(tile_type: TileType.NO_TILE);
		}

		/**
		 * Get map as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(TileJsonParam tile_params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);
			
			if(tile_params.tex)
				object.set_string_member("texture", tex.base64);

			if(tile_params.gid)
				object.set_int_member("gid", gid);

			if(tile_params.size) {
				object.set_int_member("width", width);
				object.set_int_member("height", height);
			}

			if(tile_params.tile_type) {
				object.set_string_member("tile_type", tile_type.to_string());
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
		public string get_json_indi_as_str(TileJsonParam tile_params) {
			return json_to_string(get_json_indi(tile_params));
		}

		/**
		 * Speichert das Tile mit dem Dateiname filename als Datei
		 * @param filename Zu verwendender Dateiname
		 */
		public virtual void save (string filename) {
			if(tile_type != TileType.NO_TILE ) { // TODO && tile_type != TileType.EMPTY_TILE
				tex.save(filename);
			} else {
				print("Tile ist empty");
			}
		}

		/**
		 * Zeichnet das Tile an einer Bildschirmposition.
		 * @param x linke x-Koordinate
		 * @param y untere y-Koordinate
		 * @param zoff Angabe der hoehe des Tiles Z.B unter, ueber, gleich, .. dem Held.
		 */
		//public abstract void draw (double x, double y, double zoff);
		/**
		 * Gibt alle Werte eines Tiles auf der Konsole aus.
		 */
		public abstract void print_values ();

		/**
		 * Berechnet anhand der Nachbartiles das aussehen dieses Tiles,
		 * dies findet beispielsweise bei Wegen, Strassen, Sand oder Grass verwendung.
		 * TODO an Ole, ueberpruefe diese Beschreibung!
		 */
		public abstract void calc_edges (TileType[] neighbours);
	}

	public class TileJsonParam:GLib.Object {

		/**
		 * If true json includes filename.
		 */
		public bool tex { get; construct set; default=false; }

		/**
		 * If true json includes orientation.
		 */
		public bool gid { get; construct set; default=false; }

		/**
		 * If true json includes verion of format.
		 */
		public bool size { get; construct set; default=false; }

		/**
		 * If true json includes tilewidth and tileheight.
		 */
		public bool tile_type { get; construct set; default=false; }


		public TileJsonParam(bool tex = false, bool gid = false, bool size = false, bool tile_type = false) {
			this.tex = tex;
			this.gid = gid;
			this.size = size;
			this.tile_type = tile_type;
		}

		public bool or_gate() {
			return ( tex || gid || size || tile_type );
		}
	}
}