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
	 * Klasse fuer TilesetManager
	 */
	public class TilesetManager : GLib.Object {
		Gee.List<Tileset> tileset;
		public string folder { get; construct set; }
		public int size {
			get {
				return tileset.size;
			} 
		}

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
}
