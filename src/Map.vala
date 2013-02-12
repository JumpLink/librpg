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
using Json;
namespace rpg {
	/**
	 * Klasse fuer Maps.
	 * Diese Klasse dient zur Speicherung von Mapinformationen.
	 * Sie kann zudem die Maps auf der Konsole ausgeben und eine Map-Datei laden.
	 */
	public class Map : GLib.Object {
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
		public Gee.List<rpg.TilesetReference> tileset  { get; set; default=new Gee.ArrayList<TilesetReference>();}
		// public int tileset_size {
		// 	get { return tileset.size; }
		// }

		/**
		 * MapLayer der Map ueber dem Helden
		 */
		public Gee.List<MapLayer> layers_over { get; set; default=new Gee.ArrayList<MapLayer>();}

		/**
		 * MapLayer der Map gleich dem Helden
		 */
		public Gee.List<MapLayer> layers_same { get; set; default=new Gee.ArrayList<MapLayer>();} 

		/**
		 * MapLayer der Map unter dem Helden
		 */
		public Gee.List<MapLayer> layers_under { get; set; default=new Gee.ArrayList<MapLayer>();} 

		/**
		 * Sum of sizes of all layers.
		 */
		public int all_layer_size {
			get {
				return layers_same.size+layers_under.size+layers_over.size;
			}
		}
		public GdkTexture over {
			owned get {
				return merge_layer(layers_over);
			}
		}
		public GdkTexture under {
			owned get{
				return merge_layer(layers_under);
			}
		}

		/** 
		 * Entities auf der Map
		 */
		public Gee.List<Entity> entities { get; set; default=new Gee.ArrayList<Entity>();}

		/** 
		 * Note: this are not tiles like tiles in layers
		 */
		public LogicalTile [,] tiles { get; set; }

		/**
		 * Konstruktor fuer eine leere Map.
		 *
		 * @param filename filename of Map.
		 */
		public Map(string filename) {
			GLib.Object(filename:filename);
		}

		/**
		 * Get map as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(MapJsonParam map_params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);
			
			if(map_params.with_filename)
				object.set_string_member("filename", filename);

			if(map_params.with_orientation)
				object.set_string_member("orientation", orientation);

			if(map_params.with_version)
				object.set_string_member("version", version);

			if(map_params.with_size) {
				object.set_int_member("width", width);
				object.set_int_member("height", height);
			}

			if(map_params.with_tilesize) {
				object.set_int_member("tilewidth", tile_width);
				object.set_int_member("tileheight", tile_height);
			}

			if(map_params.with_property) {

				var props = new Json.Object();

				var props_iter = properties.map_iterator();
				if( props_iter.first() )
					do {
						string k = props_iter.get_key ();
						string v = props_iter.get_value ();

						props.set_string_member(k, v);

					} while( props_iter.next() );

				object.set_object_member("properties", props);
			}

			if(map_params.map_layer_params.or_gate()) {

				var layers_json_array = new Json.Array();
				
				for (var i = 0;i<all_layer_size;i++) {
					if(get_layer_from_index(i) != null)
						layers_json_array.add_object_element( ( (!) get_layer_from_index(i) ).get_json_indi(map_params.map_layer_params).get_object() );
				}

				object.set_array_member("layers", layers_json_array);
			}

			if(map_params.layer_under_pixbuf) {
				if(under.width > 0)
					object.set_string_member("layer_under_pixbuf", under.base64);
				else
					object.set_string_member("layer_under_pixbuf", "unset");
			}

			if(map_params.layer_over_pixbuf) {
				if(over.width > 0)
					object.set_string_member("layer_over_pixbuf", over.base64);
				else
					object.set_string_member("layer_over_pixbuf", "unset");
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
		public string get_json_indi_as_str(MapJsonParam p) {
			return json_to_string(get_json_indi(p));
		}

		/**
		 * Gibt das zur gid passende TilesetReference zurueck.
		 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
		 * aber groesser ist als alle anderen firstgids.
		 * @param gid Die zu der das passende Tileset gesucht werden soll.
		 * @return Das gefundene TilesetReference.
		 */
		public TilesetReference get_tilesetref_from_gid(int gid) {	
			rpg.TilesetReference found = tileset[0];
			foreach (rpg.TilesetReference tsr in tileset) {
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
			rpg.MapLayer layer = (!) get_layer_from_index(layer_index);
			rpg.Tile tile = (!) layer.get_tile_from_coordinate(x,y);
			rpg.TilesetReference tref = get_tilesetref_from_gid(tile.gid);
			return (int) tile.gid - (int) (tref.firstgid-1);
		}

		/**
		 * Tile-X-Coord of the tilesetimage
		 */
		public uint get_tile_image_x_from_position(int x, int y, int layer_index) {
			rpg.MapLayer layer = (!) get_layer_from_index(layer_index);
			rpg.Tile tile = (!) layer.get_tile_from_coordinate(x,y);
			rpg.TilesetReference tref = get_tilesetref_from_gid(tile.gid);
			int id = (int) tile.gid - (int) (tref.firstgid-1);
			int res = (id%tref.source.count_x)*tile_width;
			return res == 0 && id != 0 ? tref.source.count_x*tile_width : res;
		}

		/**
		 * Tile-Y-Coord of the tilesetimage
		 */
		public int get_tile_image_y_from_position(int x, int y, int layer_index) {
			rpg.MapLayer layer = (!) get_layer_from_index(layer_index);
			rpg.Tile tile = (!) layer.get_tile_from_coordinate(x,y);
			rpg.TilesetReference tref = get_tilesetref_from_gid(tile.gid);
			int id = tile.gid - (tref.firstgid-1);
			int res = (id/tref.source.count_x)*tile_height;
			return id%tref.source.count_x == 0 && id != 0 ? res-1*tile_height : res;
		}

		/*
		 * @return -1 on error.
		 */
		public int get_tilegid_from_position(int x, int y, int layer_index) {
			MapLayer? layer = get_layer_from_index(layer_index);

			if (layer != null)
				return ((!)layer).get_tile_from_coordinate(x,y).gid;
			else
				return -1;
		}

		/**
		 * Gibt den MapLayer eines gesuchten MapLayers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter MapLayername
		 * @return MapLayer aus der MapLayerliste, null on error
		 */
		public MapLayer? get_layer_from_name(string name){
			foreach (MapLayer i in layers_under) if (name == i.name) return i;
			foreach (MapLayer i in layers_same) if (name == i.name) return i;
			foreach (MapLayer i in layers_over) if (name == i.name) return i;
			print("keinen MapLayer mit diesem Namen gefunden\n");
			return null;
		}

		/**
		 * @return null on error
		 */
		public MapLayer? get_layer_from_index(int index){
			int count = 0;
			foreach (MapLayer i in layers_over) {
				if (count == index) return i;
				count++;
			}
			foreach (MapLayer i in layers_same) {
				if (count == index) return i;
				count++;
			}
			foreach (MapLayer i in layers_under) {
				if (count == index) return i;
				count++;
			}
			print("keinen MapLayer mit dem Index %i gefunden\n",index);
			return null;
		}

		/**
		 * @return null on error
		 */
		public MapLayer? get_layer_from_index_inverse(int index){
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
			print("keinen MapLayer mit dem Index %i gefunden\n",index);
			return null;
		}

		/**
		 * Gibt den Index eines gesuchten MapLayers mit dem Namen name zurueck.
		 *
		 * @param name Gesichter MapLayername
		 * @return Index aus der MapLayerliste, -1 on error
		 */
		public int get_index_of_layer_name(string name){
			foreach (MapLayer i in layers_same) if (name == i.name) return layers_same.index_of(i);
			foreach (MapLayer i in layers_over) if (name == i.name) return layers_over.index_of(i);
			print("MapLayer %s nicht gefunden!", name);
			return -1;
		}

		/**
		 * Generiert aus MapLayer ''layer_over''/''layer_under'' ein Pixbuf und speichert es in ''over''/''under''.
		 *
		 * @see rpg.Map.over
		 * @see rpg.Map.under
		 * @see rpg.Map.layers_over
		 * @see rpg.Map.layers_under
		 */
		public GdkTexture merge_layer (Gee.List<MapLayer> layers) {
			int i = 0;
			layers.get(0).merge(tile_width, tile_height);
			GdkTexture tex = new GdkTexture.from_pixbuf( layers.get(0).tex.pixbuf.copy() );

			foreach (MapLayer layer in layers) {
				if(i!=0) {
					layer.merge(tile_width, tile_height);
					tex.pixbuf = GdkTexture.blit(tex.pixbuf, layer.tex.pixbuf);
				}
				++i;
			}
			return tex;
		}

		/**
		 * Gibt an, ob eine Position begehbar ist.
		 * @param x X-Koordinate.
		 * @param y Y-Koordinate.
		 */
		public bool walkable (int x, int y) {
			if (x >= width || y >= height) return false;
			bool obstacle = false;
			foreach (MapLayer l in layers_same) {
				obstacle = obstacle || (l.collision && l.tiles[x, y].tile_type != TileType.NO_TILE);
			}
			return !obstacle;
		}
	}

	public class MapJsonParam:GLib.Object {
		/**
		 * If true json includes filename.
		 */
		public bool with_filename { get; construct set; default=false; }
		/**
		 * If true json includes orientation.
		 */
		public bool with_orientation { get; construct set; default=false; }
		/**
		 * If true json includes verion of format.
		 */
		public bool with_version { get; construct set; default=false; }
		/**
		 * If true json includes width and height.
		 */
		public bool with_size { get; construct set; default=false; }
		/**
		 * If true json includes tilewidth and tileheight.
		 */
		public bool with_tilesize { get; construct set; default=false; }
		/**
		 * If true json includes properties.
		 */
		public bool with_property { get; construct set; default=false; }
		/**
		 * If true json includes the texture of the under-layer as a png base64 string (empty if texture is unset).
		 */
		public bool layer_under_pixbuf { get; construct set; default=false; }
		/**
		 * If true json includes the texture of the over-layer as a png base64 string (empty if texture is unset).
		 */
		public bool layer_over_pixbuf { get; construct set; default=false; }

		public MapLayerJsonParam map_layer_params { get; construct set; default=new MapLayerJsonParam(); }

		public MapJsonParam(bool with_filename = false, bool with_orientation = false, bool with_version = false, bool with_size = false, bool with_tilesize = false, bool with_property = false, bool layer_under_pixbuf = false, bool layer_over_pixbuf = false, MapLayerJsonParam map_layer_params = new MapLayerJsonParam()) {
			GLib.Object(with_filename:with_filename,with_orientation:with_orientation, with_version:with_version, with_size:with_size, with_tilesize:with_tilesize, with_property:with_property, layer_under_pixbuf:layer_under_pixbuf, layer_over_pixbuf:layer_over_pixbuf, map_layer_params:map_layer_params);
		}

		public bool or_gate() {
			return with_filename || with_orientation || with_version || with_size || with_tilesize || with_property || layer_under_pixbuf || layer_over_pixbuf || map_layer_params.or_gate();
		}
	}
}
