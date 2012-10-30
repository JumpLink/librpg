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
	 * Klasse fuer SpritesetManager
	 */
	public class SpritesetManager : GLib.Object {
		public Gee.List<Spriteset> spriteset;

		public int length { get{return spriteset.size;} }
		public int size { get{return length;} }

		public string folder { get; construct set; }
		/**
		 * Konstruktor
		 */
		public SpritesetManager(string folder) {
			GLib.Object(folder: folder);
		}
		construct {
			spriteset = new Gee.ArrayList<Spriteset>();
			load_all_from_folder(folder);
		}

		/**
		 * Ladet alle Spritesets aus dem Verzeichniss "folder"
		 *
		 * Dabei werden alle Dateien mit der Endung .ssx berücksichtigt.
		 * Anschließend wird jedes Spriteset in eine ArrayList gespeichert.
		 *
		 * @param folder Ordnername aus dem gelesen werden soll.
		 */
		public void load_all_from_folder(string folder) {
			Gee.List<string> files = rpg.File.load_all_from_folder(folder, ".ssx");
			SpritesetReader spritesetreader = new SpritesetReader(folder);
			foreach (string filename in files) {
				spriteset.add(spritesetreader.parse(filename));
			}
		}
		/**
		 * Gibt das Spriteset mit dem Namen "name" zurück
		 *
		 * @param name name des gesuchten Spriteset
		 * @return Bei Erfolg das gefundene Spriteset, sonst ein neues Objekt Spriteset
		 */
		public Spriteset get_from_name(string name) {
			foreach (Spriteset ss in spriteset)
				if (ss.name == name) {
					return ss;
				}
			error("Spriteset %s nicht gefunden!", name);
		}
		public Spriteset get_from_index(int index) {
			return spriteset[index];
		}
		/**
		 * Gibt das Spriteset mit dem Dateiname "filename" zurück
		 *
		 * @param filename Dateiname des gesuchten Spritesets
		 * @return Bei Erfolg das gefundene Spriteset, sonst ein neues Objekt Spriteset
		 */
		public Spriteset get_from_filename(string filename)
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
