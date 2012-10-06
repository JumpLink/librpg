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
using GLib;

using Hmwd;
namespace Hmwd {
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
		//string folder;
		/**
		 * Konstruktor
		 */
		public TilesetManager(string folder) {
			 GLib.Object(folder:folder);
		}
		construct{
			//print("Erstelle TilesetManager\n");
			tileset = new Gee.ArrayList<Tileset>();
			if (folder != null)
				loadAllFromFolder(folder);
			else
				printerr("property folder is undefined");
		}
		/**
		 * Dekonstruktor
		 */
		~TilesetManager() {
			//print("Lösche TilesetManager\n");
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
		private void loadAllFromFolder(string folder) {
			Gee.List<string> files = Hmwd.File.loadAllFromFolder(folder, ".tsx");
			TilesetReader tilesetreader = new TilesetReader(folder);
			foreach (string filename in files) {
				//print("Dateiname: %s\n\n", filename);
				Tileset tmp_tileset = tilesetreader.parse(filename);
				tmp_tileset.loadTiles(folder);
				tileset.add(tmp_tileset);
			}
		}
		/**
		 * Gibt das Tileset mit dem Namen "name" zurück
		 *
		 * @param name name des gesuchten Tilesets
		 * @return Bei Erfolg das gefundene Tileset, sonst ein neues Objekt Tileset
		 */
		public Tileset? getFromName(string name) {
			foreach (Tileset ts in tileset)
					if (ts.name == name) {
						//print("Tileset gefunden!\n");
						return ts;
					}
						
			return null;
		}
		/**
		 * Gibt das Tileset mit dem Dateiname "filename" zurück
		 *
		 * @param filename Dateiname des gesuchten Tilesets
		 * @return Bei Erfolg das gefundene Tileset, sonst ein neues Objekt Tileset
		 */
		public Tileset getFromFilename(string filename)
		requires (filename.length > 0)
		{
			Tileset result = null;
			foreach (Tileset ts in tileset)
				if (ts.filename == filename) {
					//print("Tileset mit gleichem Namen %s gefunden!\n", filename);
					result = ts;
					break;
				}
			return result;
		}
		/**
		 * Gibt das Tileset mit dem Namen "name" zurück
		 *
		 * @param source Ort des gesuchten Tilesets
		 * @return Bei Erfolg das gefundene Tileset, sonst ein neues Objekt Tileset
		 */
		public Tileset? getFromSource(string source) {
			foreach (Tileset ts in tileset)
					if (ts.source == source) {
						//print("Tileset gefunden!\n");
						return ts;
					}
						
			return null;
		}

		public string getSourcesFromIndex(int index) {
			return tileset[index].source;
		}
		public Tileset getFromIndex(int index) {
			return tileset[index];
		}

		/*public Tileset loadFromPath(string filename) {

			return loadFromPath(path+filename);
		}*/

		/**
		 * Gibt die Werte aller Tilesets in der Liste aus.
		 */
		public void printAll() {
			foreach (Tileset ts in tileset) {
					ts.printValues ();
	    	}
		}
	}
}
