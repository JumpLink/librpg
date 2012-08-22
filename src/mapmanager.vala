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
	 * Klasse fuer den MapManager, mit dieser Klasse werden alle Maps im Spiel verwaltet.
	 * Sie kann beispielsweise alle Maps aus einem angegebenen Verzeichnis Laden.
	 */
	public class MapManager : GLib.Object {
		Gee.List<Hmwd.Map> map;
		public string folder { get; construct set; }
		public Hmwd.TileSetManager tilesetmanager { get; construct set; } //TODO remove?
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
		public MapManager(string folder,  Hmwd.TileSetManager tilesetmanager )
		//requires (tilesetmanager != null)
		{
			GLib.Object(folder: folder, tilesetmanager : tilesetmanager);
		}
		construct {
			print("Erstelle MapManager\n");
			map = new Gee.ArrayList<Hmwd.Map>();
			loadAllFromFolder(folder, tilesetmanager);
		}
		/**
		 * Dekonstruktor
		 */
		~MapManager() {
			print("Lösche MapManager\n");
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
		private void loadAllFromFolder(string folder, Hmwd.TileSetManager tilesetmanager) {
			//print("Fuehre MapManager.loadAllFromPath mit folder %s aus.\n", folder);
			Gee.List<string> files = Hmwd.File.loadAllFromFolder(folder, ".tmx");
			foreach (string filename in files) {
				map.add(new Hmwd.Map.fromPath(folder, filename, tilesetmanager));
			}
		}
		public Hmwd.Map getMapFromIndex(int index) {
			return map[index];
		}
		public string getMapFilenameFromIndex(int index) {
			return map[index].filename;
		}
		/**
		 * Gibt die Map mit dem Dateinamen "filename" zurueck
		 *
		 * @param filename Dateiname der gesuchten Map
		 * @return Bei Erfolg die gefundene Map, sonst ein neues Objekt Map
		 */
		public Hmwd.Map getFromFilename(string filename) {
			foreach (Hmwd.Map m in map)
					if (m.filename == filename) {
						print("Map gefunden!\n");
						return m;
					}
						
			return new Hmwd.Map();
		}
		/**
		 * Gibt die Werte aller Maps in der Liste aus.
		 */
		public void printAll() {
			print("=====ALL MAPS====\n");
			foreach (Hmwd.Map m in map) {
					m.printAll();
	   		}
		}

		/**
		 * Altert alle Maps um einen Tag.
		 */
		// public void age () {
		// 	foreach (Hmwd.Map m in map)
		// 		m.age();
		// }
	}
}
