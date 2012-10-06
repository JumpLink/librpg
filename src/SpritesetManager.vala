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
	 * Klasse fuer SpritesetManager
	 */
	public class SpritesetManager : GLib.Object {
		public Gee.List<Spriteset> spriteset;

		public int length { get{return spriteset.size;} }
		public int size { get{return spriteset.size;} }

		public string folder { get; construct set; }
		/**
		 * Konstruktor
		 */
		public SpritesetManager(string folder) {
			GLib.Object(folder: folder);
		}
		construct {
			spriteset = new Gee.ArrayList<Spriteset>();
			loadAllFromFolder(folder);
		}

		/**
		 * Ladet alle Spritesets aus dem Verzeichniss "folder"
		 *
		 * Dabei werden alle Dateien mit der Endung .ssx berücksichtigt.
		 * Anschließend wird jedes Spriteset in eine ArrayList gespeichert.
		 *
		 * @param folder Ordnername aus dem gelesen werden soll.
		 */
		public void loadAllFromFolder(string folder) {
			if(folder.length < 1) {
				printerr("folder is undefined, using default: ./data/spriteset/\n");
				folder = "./data/spriteset/";
			}

			Gee.List<string> files = Hmwd.File.loadAllFromFolder(folder, ".ssx");
			SpritesetReader spritesetreader = new SpritesetReader(folder);
			foreach (string filename in files) {
				//print("Dateiname: %s\n\n", filename);
				//Hmwd.Spriteset current_spriteset = new Hmwd.Spriteset.fromPath(folder, filename);
				spriteset.add(spritesetreader.parse(filename));
			}
			//print("spritset size: %i\n",this.size);
		}
		/**
		 * Gibt das Spriteset mit dem Namen "name" zurück
		 *
		 * @param name name des gesuchten Spriteset
		 * @return Bei Erfolg das gefundene Spriteset, sonst ein neues Objekt Spriteset
		 */
		public Spriteset getFromName(string name) {
			foreach (Spriteset ss in spriteset)
					if (ss.name == name) {
						return ss;
					}
			error("Spriteset %s nicht gefunden!", name);
		}
		public Spriteset getFromIndex(int index) {
			return spriteset[index];
		}
		/**
		 * Gibt das Spriteset mit dem Dateiname "filename" zurück
		 *
		 * @param filename Dateiname des gesuchten Spritesets
		 * @return Bei Erfolg das gefundene Spriteset, sonst ein neues Objekt Spriteset
		 */
		public Spriteset getFromFilename(string filename)
		requires (filename.length > 0)
		{
			foreach (Spriteset ss in spriteset)
					if (ss.filename == filename) {
						return ss;
					}		
			error("Spriteset %s nicht gefunden!", filename);
		}
		/**
		 * Gibt die Werte aller Spritesets in der Liste aus.
		 */
		public void print_all() {
			print("==Print All Spritesets==\n");
			int count = 0;
			foreach (Spriteset ss in spriteset) {
					print("Nr. %i: ", count);
					ss.print_all();
					count++;
	    	}
		}
	}
}
