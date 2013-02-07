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
using GLib;
using Json;
using rpg;

namespace rpg {

	/**
	 * Klasse fuer den MapManager, mit dieser Klasse werden alle Maps im Spiel verwaltet.
	 * Sie kann beispielsweise alle Maps aus einem angegebenen Verzeichnis Laden.
	 */
	public class MapManager : GLib.Object {
		/**
		 * List of Maps to store Maps in the MapManager
		 */
		Gee.List<rpg.Map> map;

		/**
		 * Get list of maps as json
		 */
		public Json.Node json {
			owned get {
				MapJsonParam map_params = new MapJsonParam(true, false, false, false, false, false, false, false);
				MapManagerJsonParam map_manager_params = new MapManagerJsonParam(true, map_params);
				return get_json_indi(map_manager_params);
			}
		}

		/**
		 * Get list of maps as json string
		 */
		public string json_str {
			owned get { return json_to_string(json); }
		}

		/**
		 * String of folder that was set wit the createn-method.
		 */
		public string folder { get; construct set; }

		/**
		 * TilesetManager that is used from the MapReader
		 */
		public rpg.TilesetManager tilesetmanager { get; construct set; } //TODO remove?

		/**
		 * Length of List of Maps
		 */
		public int map_length {
			get { return map.size; }
		}

		/**
		 * Konstruktor mit uebergebenem Ordner fuer das Map-Verzeichnis.
		 * @param folder Verzeichnis der Maps, default ist: "./data/map/".
		 */
		public MapManager(string folder,  rpg.TilesetManager tilesetmanager ) {
			GLib.Object(folder: folder, tilesetmanager : tilesetmanager);
		}

		construct {
			map = new Gee.ArrayList<rpg.Map>();
			load_all_from_folder(folder, tilesetmanager);
		}

		/**
		 * Ladet alle Maps aus dem Verzeichniss "path"
		 *
		 * Dabei werden alle Dateien mit der Endung .tsx berücksichtigt.
		 * Das Parsen der XML wird von der Klasse Map.XML übernommen.
		 * Anschließend wird jede Map in eine ArrayList gespeichert.
		 *
		 * @param folder der Ordnername aus dem gelesen werden soll.
		 */
		private void load_all_from_folder(string folder, rpg.TilesetManager tilesetmanager) {
			//print("Fuehre MapManager.loadAllFromPath mit folder %s aus.\n", folder);
			Gee.List<string> files = rpg.File.load_all_from_folder(folder, ".tmx");
			MapReader mapreader = new MapReader(folder, tilesetmanager);
			foreach (string filename in files) {

				map.add(mapreader.parse(filename));
			}
		}

		/**
		 * Get all maps as individually json. You can define which properties should be included.
		 */
		public Json.Node get_json_indi(MapManagerJsonParam map_manager_params) {
			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);
	
			if(map_manager_params.with_folder)
				object.set_string_member("folder", folder);

			if(map_manager_params.map_params != null) {
				var maps = new Json.Array();

				foreach (rpg.Map m in map) {
					maps.add_object_element(m.get_json_indi((!) map_manager_params.map_params).get_object() );
				}

				object.set_array_member("maps", maps);
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
		public string get_json_indi_as_str(MapManagerJsonParam map_manager_params) {
			return json_to_string(get_json_indi(map_manager_params));
		}

		public rpg.Map get_map_from_index(int index) {
			return map[index];
		}

		public string get_map_filename_from_index(int index) {
			return map[index].filename;
		}

		/**
		 * Gibt die Map mit dem Dateinamen "filename" zurueck
		 *
		 * @param filename Dateiname der gesuchten Map
		 * @return Bei Erfolg die gefundene Map, sonst null
		 */
		public rpg.Map? get_from_filename(string filename) {
			foreach (rpg.Map m in map) if (m.filename == filename) { return m;}
			//error("Map %s nicht gefunden", filename);
			return null;
		}

		/**
		 * Gibt die Werte aller Maps in der Liste aus.
		 */
		public void print_all() {
			print("=====ALL MAPS====\n");
			foreach (rpg.Map m in map) {
					m.print_all();
			}
		}
	}

	public class MapManagerJsonParam:GLib.Object {
		/**
		 * If true json includes folder.
		 */
		public bool with_folder { get; construct set; }
		/**
		 * If not null the maps saved in MapManager are included in the Json. 
		 */
		public MapJsonParam? map_params { get; construct set; }

		public MapManagerJsonParam(bool with_folder = false, MapJsonParam? map_params = null) {
			this.with_folder = with_folder;
			this.map_params = map_params;
		}
	}
}
