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
using Gee;
namespace Hmwd {
	/**
	 * Klasse fuer Maps.
	 * Diese Klasse dient zur Speicherung von Mapinformationen.
	 * Sie kann zudem die Maps auf der Konsole ausgeben und eine Map-Datei laden.
	 */
	public class Map : Object {
		/**
		 * properties der Map.
		 */
		public Gee.Map<string, string> properties = new HashMap<string, string> (str_hash, str_equal);
		/**
		 * orientation der Map.
		 */
		public string orientation { get; set; }
		/**
		 * Version des Kartenformats, fuer gewoehnloch 1.0
		 */
		public string version { get; set; }
		/**
		 * Gesamtbreite der Map in Tiles
		 */
		public int width { get; set; }
		/**
		 * Gesamthoehe der Map in Tiles
		 */
		public int height { get; set; }
		/**
		 * Gesamtbreite der Map in Pixel
		 */
		public int pixel_width {
			get {return width*tile_width;}
		}
		/**
		 * Gesamthoehe der Map in Pixel
		 */
		public int pixel_height {
			get {return height*tile_height;}
		}
		/**
		 * Breite eines Tiles
		 */
		public int tile_width { get; set; }
		/**
		 * Höhe eines Tiles
		 */
		public int tile_height { get; set; }
		/**
		 * Dateiname der Map
		 */
		public string filename { get; construct set; }
		// /**
		//  * Path der Mapdateien
		//  */
		// public string path { get; construct; }
		/**
		 * Tilesets die für auf der Map verwendet werden
		 */
		public Gee.List<Hmwd.TilesetReference> tileset  { get; set; default=new Gee.ArrayList<TilesetReference>();}
		public int tileset_size {
			get { return tileset.size; }
		}
		/**
		 * Layer der Map ueber dem Helden
		 */
		public Gee.List<Layer> layers_over { get; set; default=new Gee.ArrayList<Layer>();}
		/**
		 * Layer der Map gleich dem Helden
		 */
		public Gee.List<Layer> layers_same { get; set; default=new Gee.ArrayList<Layer>();} 
		/**
		 * Layer der Map unter dem Helden
		 */
		public Gee.List<Layer> layers_under { get; set; default=new Gee.ArrayList<Layer>();} 

		public int all_layer_size {
			get {
				return layers_same.size+layers_under.size+layers_over.size;
			}
		}
		/** 
		 * Entities auf der Map
		 */
		public Gee.List<Entity> entities { get; set; default=new Gee.ArrayList<Entity>();}

		public LogicalTile [,] tiles { get; set; }

		public Hmwd.TilesetManager tilesetmanager { get; construct set; } //TODO remove?


		// public double shift_x {
		// 	get { return (VIEW.window_width - width * tile_width)/2;}
		// }
		// public double shift_y {
		// 	get { return (VIEW.window_height - height * tile_height)/2;}
		// }

		/**
		 * Konstruktor fuer eine leere Map
		 */
		public Map(string filename, Hmwd.TilesetManager tilesetmanager) {
			Object(filename:filename, tilesetmanager:tilesetmanager);
		}
		construct {

		}

		/**
		 * Gibt das zur gid passende TilesetReference zurueck.
		 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
		 * aber groesser ist als alle anderen firstgids
		 * @param gid Die zu der das passende Tileset gesucht werden soll.
		 * @return Das gefundene TilesetReference.
		 */
		public TilesetReference get_tilesetref_from_gid(int gid) {	
			Hmwd.TilesetReference found = tileset[0];
			foreach (Hmwd.TilesetReference tsr in tileset) {
				if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
					found = tsr;
			}
			return found;
		}
		/**
		 * Gibt eines der übergebenen TilesetReference's zur gid passenden TilesetReference zurueck.
		 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
		 * aber groesser ist als alle anderen firstgids
		 * @param tilesetrefs Liste von TilesetReference's in der gesucht werden soll.
		 * @param gid Die zu der das passende Tileset gesucht werden soll.
		 * @return Das gefundene TilesetReference.
		 */
		public static TilesetReference get_extern_tilesetref_from_gid(Gee.List<Hmwd.TilesetReference> tilesetrefs, uint gid) {	
			Hmwd.TilesetReference found = tilesetrefs[0];
			foreach (Hmwd.TilesetReference tsr in tilesetrefs) {
				if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
					found = tsr;
			}
			return found;
		}
		public int get_tileset_index_from_gid(int gid) {	
			return tileset.index_of(get_tilesetref_from_gid(gid));
		}
		public string get_tileset_source_from_index(int index) {	
			return tileset[index].source.source;
		}
		public TilesetReference get_tilesetref_from_index(int index) {	
			return tileset[index];
		}
		public Tileset get_tilesetref_from_position(int x, int y, int layer_index) {
			return get_tileset_from_index(get_tileset_index_from_position(x,y,layer_index));
		}
		public Tileset get_tileset_from_index(int index) {	
			return tileset[index].source;
		}
		public int get_tileset_index_from_position(int x, int y, int layer_index) {
			return get_tileset_index_from_gid(get_tilegid_from_position(x,y,layer_index));
		}
		public int get_tileid_from_gid(int gid) {	
			TilesetReference tref = get_tilesetref_from_gid(gid);
			return (int) gid - (int) (tref.firstgid-1);
		}
		public int get_tileid_from_position(int x, int y, int layer_index) {
			Hmwd.Layer layer = get_layer_from_index(layer_index);
			Hmwd.Tile tile = layer.get_tile_from_coordinate(x,y);
			Hmwd.TilesetReference tref = get_tilesetref_from_gid(tile.gid);
			return (int) tile.gid - (int) (tref.firstgid-1);
		}
		/**
		 * Tile-X-Coord of the tilesetimage
		 */
		public uint get_tile_image_x_from_position(int x, int y, int layer_index) {
			Hmwd.Layer layer = get_layer_from_index(layer_index);
			Hmwd.Tile tile = layer.get_tile_from_coordinate(x,y);
			Hmwd.TilesetReference tref = get_tilesetref_from_gid(tile.gid);
			int id = (int) tile.gid - (int) (tref.firstgid-1);
			uint res = (id%tref.source.count_x)*tile_width;
			return res == 0 && id != 0 ? tref.source.count_x*tile_width : res;
		}
		/**
		 * Tile-Y-Coord of the tilesetimage
		 */
		public int get_tile_image_y_from_position(int x, int y, int layer_index) {
			Hmwd.Layer layer = get_layer_from_index(layer_index);
			Hmwd.Tile tile = layer.get_tile_from_coordinate(x,y);
			Hmwd.TilesetReference tref = get_tilesetref_from_gid(tile.gid);
			int id = tile.gid - (tref.firstgid-1);
			int res = (id/tref.source.count_x)*tile_height;
			return id%tref.source.count_x == 0 && id != 0 ? res-1*tile_height : res;
		}
		public int get_tilegid_from_position(int x, int y, int layer_index) {
			return get_layer_from_index(layer_index).get_tile_from_coordinate(x,y).gid;
		}
		/**
		 * Gibt den Layer eines gesuchten Layers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter Layername
		 * @return Layer aus der Layerliste
		 */
		public Layer get_layer_from_name(string name){
			foreach (Layer i in layers_under) if (name == i.name) return i;
			foreach (Layer i in layers_same) if (name == i.name) return i;
			foreach (Layer i in layers_over) if (name == i.name) return i;
			error("keinen Layer mit diesem Namen gefunden\n");
		}

		public Layer get_layer_from_index(int index){
			int count = 0;
			foreach (Layer i in layers_over) {
				if (count == index) return i;
				count++;
			}
			foreach (Layer i in layers_same) {
				if (count == index) return i;
				count++;
			}
			foreach (Layer i in layers_under) {
				if (count == index) return i;
				count++;
			}
			error("keinen Layer mit dem Index %i gefunden\n",index);
		}

		public Layer get_layer_from_index_inverse(int index){
			int count = 0;
			for(int i=layers_under.size-1;i>=0;i++,count++) {
				if (count == index) return layers_under[i];
			}
			for(int i=layers_same.size-1;i>=0;i++,count++) {
				if (count == index) return layers_same[i];
			}
			for(int i=layers_over.size-1;i>=0;i++,count++) {
				if (count == index) return layers_over[i];
			}
			error("keinen Layer mit dem Index %i gefunden\n",index);
		}
		/**
		 * Gibt den Index eines gesuchten Layers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter Layername
		 * @return Index aus der Layerliste
		 */
		public int get_index_of_layer_name(string name){
			foreach (Layer i in layers_same) if (name == i.name) return layers_same.index_of(i);
			foreach (Layer i in layers_over) if (name == i.name) return layers_over.index_of(i);
			error("Layer %s nicht gefunden!", name);
		}

		/**
		 * Gibt an, ob eine Position begehbar ist.
		 * @param x X-Koordinate.
		 * @param y Y-Koordinate.
		 */
		public bool walkable (int x, int y) {
			if (x >= width || y >= height) return false;
			bool obstacle = false;
			foreach (Layer l in layers_same) {
				obstacle = obstacle || (l.collision && l.tiles[x, y].tile_type != TileType.NO_TILE);
			}
			return !obstacle;
		}
		/**
		 * Gibt alle Werte (bis auf die Layer) der Map auf der Konsole aus
		 */
		public void print_values()
		{
			print("==MAP==\n");
			print("filename: %s\n", filename);
			print("orientation: %s\n", orientation);
			print("version: %s\n", version);
			print("width: %u\n", width);
			print("height: %u\n", height);
			print("tile_width: %u\n", tile_width);
			print("tile_height: %u\n", tile_height);
		}
		/**
		 * Gibt die Werte aller Layer der Map auf der Konsole aus
		 */
		public void print_layers()
		{
			print("====ALL LAYERS FROM MAP %s====\n", filename);
			print("under ");
			foreach (Hmwd.Layer l in layers_under) {
				l.print_values();
				l.print_tiles();
			}
			print("same ");
			foreach (Hmwd.Layer l in layers_same) {
				l.print_values();
				l.print_tiles();
			}
			print("over ");
			foreach (Hmwd.Layer l in layers_over) {
				l.print_values();
				l.print_tiles();
			}
		}
		/**
		 * Gibt die Werte aller Tilesets der Map auf der Konsole aus
		 */
		public void print_tilesets()
		{
			print("====ALL TILESETS FROM MAP %s====\n", filename);
			foreach (Hmwd.TilesetReference tsr in tileset) {
				tsr.print_values();
			}
		}
		/**
		 * Gibt alle Werte und alle Layer der Map auf der Konsole aus
		 */
		public void print_all() {
			print_values();
			print_layers();
			print_tilesets();
		}
	}
}
