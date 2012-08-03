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

using HMP;
namespace HMP {
	/**
	 * Klasse fuer TileSetManager
	 */
	public class TileSetManager {
		Gee.List<TileSet> tileset;
		//string folder;
		/**
		 * Konstruktor
		 */
		public TileSetManager(string folder) {
			print("Erstelle TileSetManager\n");
			tileset = new Gee.ArrayList<TileSet>();
			loadAllFromFolder(folder);
		}
		/**
		 * Dekonstruktor
		 */
		~TileSetManager() {
			print("Lösche TileSetManager\n");
		}

		/**
		 * Ladet alle Tilesets aus dem Verzeichniss "folder"
		 *
		 * Dabei werden alle Dateien mit der Endung .tsx berücksichtigt.
		 * Das Parsen der XML wird von der Klasse TileSet übernommen.
		 * Anschließend wird jedes TileSet in eine ArrayList gespeichert.
		 *
		 * @param folder der Ordnername aus dem gelesen werden soll.
		 */
		private void loadAllFromFolder(string folder = "./data/tileset/") {
			Gee.List<string> files = HMP.File.loadAllFromFolder(folder, ".tsx");
			foreach (string filename in files) {
				print("Dateiname: %s\n\n", filename);
				tileset.add(new HMP.TileSet.fromPath(folder, filename));
			}
		}
		/**
		 * Gibt das TileSet mit dem Namen "name" zurück
		 *
		 * @param name name des gesuchten TileSets
		 * @return Bei Erfolg das gefundene TileSet, sonst ein neues Objekt TileSet
		 */
		public TileSet getFromName(string name) {
			foreach (TileSet ts in tileset)
					if (ts.name == name) {
						print("TileSet gefunden!\n");
						return ts;
					}
						
			return new TileSet();
		}
		/**
		 * Gibt das TileSet mit dem Dateiname "filename" zurück
		 *
		 * @param filename Dateiname des gesuchten TileSets
		 * @return Bei Erfolg das gefundene TileSet, sonst ein neues Objekt TileSet
		 */
		public TileSet getFromFilename(string filename)
		requires (filename.length > 0)
		{
			TileSet result = null;
			foreach (TileSet ts in tileset)
					if (ts.filename == filename) {
						print("TileSet mit gleichem Namen %s gefunden!\n", filename);
						result = ts;
						break;
					}		
			return result;
		}
		/**
		 * Gibt das TileSet mit dem Namen "name" zurück
		 *
		 * @param source Ort des gesuchten TileSets
		 * @return Bei Erfolg das gefundene TileSet, sonst ein neues Objekt TileSet
		 */
		public TileSet getFromSource(string source) {
			foreach (TileSet ts in tileset)
					if (ts.source == source) {
						print("TileSet gefunden!\n");
						return ts;
					}
						
			return new TileSet();
		}

		/*public TileSet loadFromPath(string filename) {

			return loadFromPath(path+filename);
		}*/

		/**
		 * Gibt die Werte aller TileSets in der Liste aus.
		 */
		public void printAll() {
			foreach (TileSet ts in tileset) {
					ts.printValues ();
	    	}
		}
	}
}
