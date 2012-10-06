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
		public int pxl_width {
			get {return width*tilewidth;}
		}
		/**
		 * Gesamthoehe der Map in Pixel
		 */
		public int pxl_height {
			get {return height*tileheight;}
		}
		/**
		 * Breite eines Tiles
		 */
		public int tilewidth { get; set; }
		/**
		 * Höhe eines Tiles
		 */
		public int tileheight { get; set; }
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
		// 	get { return (VIEW.window_width - width * tilewidth)/2;}
		// }
		// public double shift_y {
		// 	get { return (VIEW.window_height - height * tileheight)/2;}
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
		 * @param tilesetrefs Liste von TilesetReference's in der gesucht werden soll.
		 * @param gid Die zu der das passende Tileset gesucht werden soll.
		 * @return Das gefundene TilesetReference.
		 */
		public static TilesetReference getTilesetRefFromGid(Gee.List<Hmwd.TilesetReference> tilesetrefs, uint gid) {	
			Hmwd.TilesetReference found = tilesetrefs[0];
			foreach (Hmwd.TilesetReference tsr in tilesetrefs) {
				if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
					found = tsr;
			}
			return found;
		}
		public TilesetReference getTilesetRefFromGidFromOwn(int gid) {	
			Hmwd.TilesetReference found = tileset[0];
			foreach (Hmwd.TilesetReference tsr in tileset) {
				if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
					found = tsr;
			}
			return found;
		}
		public int getTilesetIndexFromGid(int gid) {	
			return tileset.index_of(getTilesetRefFromGidFromOwn(gid));
		}
		public string getTilesetSourceFromIndex(int index) {	
			return tileset[index].source.source;
		}
		public TilesetReference getTilesetRefFromIndex(int index) {	
			return tileset[index];
		}
		public Tileset getTilesetRefFromPosition(int x, int y, int layer_index) {
			return getTilesetFromIndex(getTilesetIndexFromPosition(x,y,layer_index));
		}
		public Tileset getTilesetFromIndex(int index) {	
			return tileset[index].source;
		}
		public int getTilesetIndexFromPosition(int x, int y, int layer_index) {
			return getTilesetIndexFromGid(getTileGIDFromPosition(x,y,layer_index));
		}
		public int getTileIDFromGid(int gid) {	
			TilesetReference tref = getTilesetRefFromGidFromOwn(gid);
			return (int) gid - (int) (tref.firstgid-1);
		}
		public int getTileIDFromPosition(int x, int y, int layer_index) {
			Hmwd.Layer layer = getLayerFromIndex(layer_index);
			Hmwd.Tile tile = layer.getTileXY(x,y);
			Hmwd.TilesetReference tref = getTilesetRefFromGidFromOwn(tile.gid);
			return (int) tile.gid - (int) (tref.firstgid-1);
		}
		/**
		 * tile X-Coord of the tilesetimage
		 */
		public uint getTileImageXCoordFromPosition(int x, int y, int layer_index) {
			Hmwd.Layer layer = getLayerFromIndex(layer_index);
			Hmwd.Tile tile = layer.getTileXY(x,y);
			Hmwd.TilesetReference tref = getTilesetRefFromGidFromOwn(tile.gid);
			int id = (int) tile.gid - (int) (tref.firstgid-1);
			uint res = (id%tref.source.count_x)*tilewidth;
			return res == 0 && id != 0 ? tref.source.count_x*tilewidth : res;
		}
		/**
		 * tile X-Coord of the tilesetimage
		 */
		public int getTileImageYCoordFromPosition(int x, int y, int layer_index) {
			Hmwd.Layer layer = getLayerFromIndex(layer_index);
			Hmwd.Tile tile = layer.getTileXY(x,y);
			Hmwd.TilesetReference tref = getTilesetRefFromGidFromOwn(tile.gid);
			int id = tile.gid - (tref.firstgid-1);
			int res = (id/tref.source.count_x)*tileheight;
			return id%tref.source.count_x == 0 && id != 0 ? res-1*tileheight : res;
		}
		public int getTileGIDFromPosition(int x, int y, int layer_index) {
			return getLayerFromIndex(layer_index).getTileXY(x,y).gid;
		}
		/**
		 * Gibt den Layer eines gesuchten Layers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter Layername
		 * @return Layer aus der Layerliste
		 */
		public Layer getLayerFromName(string name){
			foreach (Layer i in layers_under) {
				if (name == i.name) {
					return i;
				}
			}
			foreach (Layer i in layers_same) {
				if (name == i.name) {
					return i;
				}
			}
			foreach (Layer i in layers_over) {
				if (name == i.name) {
					return i;
				}
			}
			error("keinen Layer mit diesem Namen gefunden\n");
		}

		public Layer getLayerFromIndex(int index){
			int count = 0;
			foreach (Layer i in layers_over) {
				if (count == index) {
					return i;
				}
				count++;
			}
			foreach (Layer i in layers_same) {
				if (count == index) {
					return i;
				}
				count++;
			}
			foreach (Layer i in layers_under) {
				if (count == index) {
					return i;
				}
				count++;
			}
			error("keinen Layer mit dem Index %i gefunden\n",index);
		}

		public Layer getLayerFromIndexInverse(int index){
			int count = 0;
			for(int i=layers_under.size-1;i>=0;i++,count++) {
				if (count == index)
					return layers_under[i];
			}
			for(int i=layers_same.size-1;i>=0;i++,count++) {
				if (count == index)
					return layers_same[i];
			}
			for(int i=layers_over.size-1;i>=0;i++,count++) {
				if (count == index)
					return layers_over[i];
			}
			error("keinen Layer mit dem Index %i gefunden\n",index);
		}
		/**
		 * Gibt den Index eines gesuchten Layers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter Layername
		 * @return Index aus der Layerliste
		 */
		public int getIndexOfLayerName(string name){
			
			foreach (Layer i in layers_same) {
				if (name == i.name) {
					return layers_same.index_of(i);
				}
			}
			foreach (Layer i in layers_over) {
				if (name == i.name) {
					return layers_over.index_of(i);
				}
			}
			return -1;
		}

		/**
		 * Gibt an, ob eine Position begehbar ist.
		 * @param x X-Koordinate.
		 * @param y Y-Koordinate.
		 */
		public bool walkable (int x, int y) {
			if (x >= width || y >= height)
				return false;
			//print ("Zielposition: %u, %u\n", y, x);
			bool obstacle = false;
			foreach (Layer l in layers_same) {
				obstacle = obstacle || (l.collision && l.tiles[x, y].tile_type != TileType.NO_TILE);
			}
			return !obstacle;
		}
		/**
		 * Gibt alle Werte (bis auf die Layer) der Map auf der Konsole aus
		 */
		public void printValues()
		{
			print("==MAP==\n");
			print("filename: %s\n", filename);
			print("orientation: %s\n", orientation);
			print("version: %s\n", version);
			print("width: %u\n", width);
			print("height: %u\n", height);
			print("tilewidth: %u\n", tilewidth);
			print("tileheight: %u\n", tileheight);
		}
		/**
		 * Gibt die Werte aller Layer der Map auf der Konsole aus
		 */
		public void printLayers()
		{
			print("====ALL LAYERS FROM MAP %s====\n", filename);
			print("under ");
			foreach (Hmwd.Layer l in layers_under) {
				l.printValues();
				l.printTiles();
			}
			print("same ");
			foreach (Hmwd.Layer l in layers_same) {
				l.printValues();
				l.printTiles();
			}
			print("over ");
			foreach (Hmwd.Layer l in layers_over) {
				l.printValues();
				l.printTiles();
			}
		}
		/**
		 * Gibt die Werte aller Tilesets der Map auf der Konsole aus
		 */
		public void printTilesets()
		{
			print("====ALL TILESETS FROM MAP %s====\n", filename);
			foreach (Hmwd.TilesetReference tsr in tileset) {
				tsr.printValues();
			}
		}
		/**
		 * Gibt alle Werte und alle Layer der Map auf der Konsole aus
		 */
		public void print_all() {
			printValues();
			printLayers();
			printTilesets();
		}
	}
}
