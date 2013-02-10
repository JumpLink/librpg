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
	 * Klasse fuer TilesetManager
	 */
	public class TilesetManager : GLib.Object {

		public string folder { get; construct set; }

		Gee.List<Tileset> tileset;

		/**
		 * Konstruktor
		 */
		public TilesetManager(string folder) {
			 GLib.Object(folder:folder);
		}
		construct{
			tileset = new Gee.ArrayList<Tileset>();
			load_all_from_folder(folder);
		}

		/**
		 * Get TilesetManager as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(TilesetManagerJsonParam tileset_manager_params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);
			
			if(tileset_manager_params.folder)
				object.set_string_member("folder", folder);

			if( tileset_manager_params.tileset.or_gate() ) {
				var tilesets = new Json.Array();

				foreach (Tileset ts in tileset) {
					tilesets.add_object_element(ts.get_json_indi(tileset_manager_params.tileset).get_object() );
				}

				object.set_array_member("tilesets", tilesets);
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
		public string get_json_indi_as_str(TilesetManagerJsonParam tileset_manager_params) {
			return json_to_string(get_json_indi(tileset_manager_params));
		}

		/**
		 * Ladet alle Tilesets aus dem Verzeichniss "folder"
		 *
		 * Dabei werden alle Dateien mit der Endung .tsx berücksichtigt.
		 * Das Parsen der XML wird von der Klasse Tileset übernommen.
		 * Anschließend wird jedes Tileset in eine ArrayList gespeichert.
		 *
		 * @param folder der Ordnername aus dem gelesen werden soll.
		 */
		private void load_all_from_folder(string folder) {
			Gee.List<string> files = rpg.File.load_all_from_folder(folder, ".tsx");
			TilesetReader tilesetreader = new TilesetReader(folder);
			foreach (string filename in files) {
				Tileset tmp_tileset = tilesetreader.parse(filename);
				tmp_tileset.split(folder);
				tileset.add(tmp_tileset);
			}
		}

		/**
		 * Gibt das Tileset mit dem Namen "name" zurück
		 *
		 * @param name name des gesuchten Tilesets
		 * @return Bei Erfolg das gefundene Tileset, sonst ein neues Objekt Tileset
		 */
		public Tileset get_from_name(string name) {
			foreach (Tileset ts in tileset) if (ts.name == name) return ts;
			error("Kein TileSet %s gefunden",name);
		}

		/**
		 * Gibt das Tileset mit dem Dateiname "filename" zurück
		 *
		 * @param filename Dateiname des gesuchten Tilesets
		 * @return Bei Erfolg das gefundene Tileset, sonst null
		 */
		public Tileset get_from_filename(string filename)
		requires (filename.length > 0)
		{
			foreach (Tileset ts in tileset) if (ts.filename == filename) return ts;
			error("Kein TileSet %s gefunden",filename);
		}

		/**
		 * Gibt das Tileset mit dem Dateiname "source" zurück
		 *
		 * @param source Ort des gesuchten Tilesets
		 * @return Bei Erfolg das gefundene Tileset, sonst ein neues Objekt Tileset
		 */
		public Tileset get_From_source(string source) {
			foreach (Tileset ts in tileset) if (ts.source == source) { return ts; }
			error("Tileset %s nicht gefunden!", source);
		}

		public string get_sources_from_index(int index) {
			return tileset[index].source;
		}

		public Tileset get_from_index(int index) {
			return tileset[index];
		}

		/**
		 * Gibt die Werte aller Tilesets in der Liste aus.
		 */
		public void print_all() {
			foreach (Tileset ts in tileset) {
					ts.print_values ();
	    	}
		}
	}

	public class TilesetManagerJsonParam:GLib.Object {

		/**
		 * If true json includes folder.
		 */
		public bool folder { get; construct set; default=false; }

		/**
		 * If true json includes array of all tilesets
		 */
		public TilesetJsonParam tileset { get; construct set; default=new TilesetJsonParam(); }

		public TilesetManagerJsonParam(bool folder = false, TilesetJsonParam tileset = new TilesetJsonParam()) {
			GLib.Object(folder:folder, tileset:tileset);
		}

		/*
		 * @return true if any properity of this object is true, false if all properities false
		 */
		public bool or_gate() {
			return ( folder || tileset.or_gate());
		}
	}
}
