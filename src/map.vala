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
		 * orientation der Map.
		 */
		public string orientation;
		/**
		 * Version des Kartenformats, fuer gewoehnloch 1.0
		 */
		public string version;
		/**
		 * Gesamtbreite der Map in Tiles
		 */
		public uint width;
		/**
		 * Gesamthoehe der Map in Tiles
		 */
		public uint height;
		/**
		 * Gesamtbreite der Map in Pixel
		 */
		public uint pxl_width {
			get {return width*tilewidth;}
		}
		/**
		 * Gesamthoehe der Map in Pixel
		 */
		public uint pxl_height {
			get {return height*tileheight;}
		}
		/**
		 * Breite eines Tiles
		 */
		public uint tilewidth;
		/**
		 * Höhe eines Tiles
		 */
		public uint tileheight;
		/**
		 * Dateiname der Map
		 */
		public string filename { get; construct set; }
		/**
		 * Path der Mapdateien
		 */
		public string path { get; construct; }
		/**
		 * Tilesets die für auf der Map verwendet werden
		 */
		public Gee.List<Hmwd.TileSetReference> tileset = new Gee.ArrayList<TileSetReference>();
		/**
		 * Layer der Map ueber dem Helden
		 */
		public Gee.List<Layer> layers_over = new Gee.ArrayList<Layer>();
		/**
		 * Layer der Map gleich dem Helden
		 */
		public Gee.List<Layer> layers_same = new Gee.ArrayList<Layer>();
		/**
		 * Layer der Map unter dem Helden
		 */
		public Gee.List<Layer> layers_under = new Gee.ArrayList<Layer>();
		/** 
		 * Entities auf der Map
		 */
		public Gee.List<Entity> entities = new Gee.ArrayList<Entity>();

		public LogicalTile [,] tiles;


		// public double shift_x {
		// 	get { return (VIEW.window_width - width * tilewidth)/2;}
		// }
		// public double shift_y {
		// 	get { return (VIEW.window_height - height * tileheight)/2;}
		// }

		/**
		 * Konstruktor fuer eine leere Map
		 */
		public Map() {
			print("Erstelle leeres Map Objekt\n");
		}
		public Map.fromPath (string path, string filename) {
			Object(path: path, filename:filename);
		}
		construct {
			setFromPath (path, filename);
		}
		/**
		 * Konstrukter, ladet Map mit Daten einer Mapdatei
		 *
		 * @param path Das Verzeichnis aus dem gelesen werden soll
		 * @param filename Der Dateiname der gelesen werden soll
		 */
		public void setFromPath (string path, string filename) {
			print("Lade Mapdateien von %s + %s\n", path, filename);
			
			TMX xml = new TMX(path+filename);
			xml.loadGlobalMapProperties(out orientation, out version, out width, out height, out tilewidth, out tileheight);
			tiles = new LogicalTile [width, height];
			for (uint x = 0; x < width; ++x)
				for (uint y = 0; y < height; ++y) {
					tiles[x,y] = new LogicalTile ();
			}
			tileset = xml.loadTileSets();
			xml.loadLayers(tileset, out layers_over, out layers_same, out layers_under);
		}
		/**
		 * Gibt das zur gid passende TileSetReference zurueck.
		 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
		 * aber groesser ist als alle anderen firstgids
		 * @param tilesetrefs Liste von TileSetReference's in der gesucht werden soll.
		 * @param gid Die zu der das passende TileSet gesucht werden soll.
		 * @return Das gefundene TileSetReference.
		 */
		public static TileSetReference getTileSetRefFromGid(Gee.List<Hmwd.TileSetReference> tilesetrefs, uint gid) {	
			Hmwd.TileSetReference found = tilesetrefs[0];
			foreach (Hmwd.TileSetReference tsr in tilesetrefs) {
				if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
					found = tsr;
			}
			//print("Das passende TileSet ist %s\n", found.source.name);
			return found;
		}
		/**
		 * Gibt den Layer eines gesuchten Layers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter Layername
		 * @return Layer aus der Layerliste
		 */
		public Layer? getLayerFromName(string name){
			foreach (Layer i in layers_same) {
				if (name == i.name) {
					return i;
				}
			}
			foreach (Layer i in layers_under) {
				if (name == i.name) {
					return i;
				}
			}
			foreach (Layer i in layers_over) {
				if (name == i.name) {
					return i;
				}
			}
			return null;
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
			foreach (Layer i in layers_under) {
				if (name == i.name) {
					return layers_under.index_of(i);
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
		public bool walkable (uint x, uint y) {
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
		requires (filename != null)
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
		requires (layers_same != null)
		requires (layers_under != null)
		requires (layers_over != null)
		requires (layers_same[0] != null)
		requires (layers_under[0] != null)
		requires (layers_over[0] != null)
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
		 * Gibt die Werte aller TileSets der Map auf der Konsole aus
		 */
		public void printTileSets()
		requires (tileset != null)
		{
			print("====ALL TILESETS FROM MAP %s====\n", filename);
			foreach (Hmwd.TileSetReference tsr in tileset) {
				tsr.printValues();
			}
		}
		/**
		 * Gibt alle Werte und alle Layer der Map auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printLayers();
			printTileSets();
		}

		/**
		 * Altert alle Entitaeten und Pflanzen um einen Tag.
		 */
		// public void age () {
		// 	foreach (Entity e in entities) {
		// 		e.age();
		// 	}
		// 	for (uint x = 0; x < width; ++x)
		// 		for (uint y = 0; y < height; ++y) {
		// 			if (tiles[x, y].plant != null)
		// 				tiles[x, y].plant.grow ();
		// 	}
		// }
	}
}
