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
	 * Klasse fuer SpriteSetManager
	 */
	public class SpriteSetManager : GLib.Object {
		public Gee.List<SpriteSet> spriteset;

		public int length { get{return spriteset.size;} }
		public int size { get{return spriteset.size;} }

		public string folder { get; construct set; }
		/**
		 * Konstruktor
		 */
		public SpriteSetManager(string folder) {
			GLib.Object(folder: folder);
		}
		construct {
			spriteset = new Gee.ArrayList<SpriteSet>();
			if(folder!=null) {

			} else {
				printerr("folder is undefined, using default: ./data/spriteset/\n");
				folder = "bla/data/spriteset/";
			}
			print("Erstelle SpriteSetManager\n");
			loadAllFromFolder(folder);
		}
		/**
		 * Dekonstruktor
		 */
		~SpriteSetManager() {
			print("Loesche SpriteSetManager\n");
		}

		/**
		 * Ladet alle SpriteSets aus dem Verzeichniss "folder"
		 *
		 * Dabei werden alle Dateien mit der Endung .ssx berücksichtigt.
		 * Anschließend wird jedes SpriteSet in eine ArrayList gespeichert.
		 *
		 * @param folder Ordnername aus dem gelesen werden soll.
		 */
		public void loadAllFromFolder(string folder) {
			if(folder == null || folder.length < 1) {
				printerr("folder is undefined, using default: ./data/spriteset/\n");
				folder = "./data/spriteset/";
			}

			Gee.List<string> files = Hmwd.File.loadAllFromFolder(folder, ".ssx");

			foreach (string filename in files) {
				print("Dateiname: %s\n\n", filename);
				Hmwd.SpriteSet current_spriteset = new Hmwd.SpriteSet.fromPath(folder, filename);
				spriteset.add(current_spriteset);
			}
			print("spritset size: %i\n",this.size);
		}
		/**
		 * Gibt das SpriteSet mit dem Namen "name" zurück
		 *
		 * @param name name des gesuchten SpriteSet
		 * @return Bei Erfolg das gefundene SpriteSet, sonst ein neues Objekt SpriteSet
		 */
		public SpriteSet? getFromName(string name) {
			foreach (SpriteSet ss in spriteset)
					if (ss.name == name) {
						print("SpriteSet gefunden!\n");
						return ss;
					}
						
			return null;
		}
		public SpriteSet? getFromIndex(int index) {
			return spriteset[index];
		}
		/**
		 * Gibt das SpriteSet mit dem Dateiname "filename" zurück
		 *
		 * @param filename Dateiname des gesuchten SpriteSets
		 * @return Bei Erfolg das gefundene SpriteSet, sonst ein neues Objekt SpriteSet
		 */
		public SpriteSet? getFromFilename(string filename)
		requires (filename.length > 0)
		{
			SpriteSet result = null;
			foreach (SpriteSet ss in spriteset)
					if (ss.filename == filename) {
						print("SpriteSet mit gleichem Namen %s gefunden!\n", filename);
						result = ss;
						break;
					}		
			return result;
		}
		/**
		 * Gibt die Werte aller SpriteSets in der Liste aus.
		 */
		public void printAll() {
			print("==Print All SpriteSets==\n");
			int count = 0;
			foreach (SpriteSet ss in spriteset) {
					print("Nr. %i: ", count);
					ss.printAll();
					count++;
	    	}
		}
	}
}
