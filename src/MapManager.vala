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
using rpg;
namespace rpg {
	/**
	 * Klasse fuer den MapManager, mit dieser Klasse werden alle Maps im Spiel verwaltet.
	 * Sie kann beispielsweise alle Maps aus einem angegebenen Verzeichnis Laden.
	 */
	public class MapManager : GLib.Object {
		Gee.List<rpg.Map> map;
		public string folder { get; construct set; }
		public rpg.TilesetManager tilesetmanager { get; construct set; } //TODO remove?
		public int length {
			get { return map.size; }
		}
		public int size {
			get { return map.size; }
		}
		/**
		 * Konstruktor mit uebergebenem Ordner fuer das Map-Verzeichnis.
		 * @param folder Verzeichnis der Maps, default ist: "./data/map/".
		 */
		public MapManager(string folder,  rpg.TilesetManager tilesetmanager )
		//requires (tilesetmanager != null)
		{
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
		 * @return Bei Erfolg die gefundene Map, sonst ein neues Objekt Map
		 */
		public rpg.Map get_from_filename(string filename) {
			foreach (rpg.Map m in map) if (m.filename == filename) { return m;}
			error("Map %s nicht gefunden", filename);
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
}
