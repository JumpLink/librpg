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
using Hmwd;
namespace Hmwd {
	/**
	 * Klasse fuer ausgelagerte Dateioperationen
	 */
	class File : Object {
		/**
		 * Extrahiert den Dateinamen eines kompletten Pfades.
		 * @param path Der pfad dessen Dateiname zurueck gegeben werden soll.
		 */
		public static string PathToFilename(string path) {
			return path.substring(path.last_index_of ("/", 0)+1, -1);
		}
		/**
		 * Speichert alle Dateinamen mit der Dateiendung "extension" aus dem Verzeichniss "path"
		 * in eine Liste aus Strings.
		 *
		 * @param folder der Ordnername aus dem gelesen werden soll.
		 * @param extension die Dateiendung die beruecksichtigt werden soll.
		 */
		public static Gee.List<string> loadAllFromFolder(string folder, string extension) {
			GLib.File directory = GLib.File.new_for_path(folder);
			FileEnumerator enumerator;
			Gee.List<string> files = new Gee.ArrayList<string>();
			try {
				FileInfo? file_info;
				// 'Oeffnet' das Verzeichnis path
				directory = GLib.File.new_for_path (folder);
				// Ladet die Dateien die sich im Verzeichnis path befinden
				enumerator = directory.enumerate_children (GLib.FileAttribute.STANDARD_NAME, 0);
				// Durchläuft alle gefundenen Dateien und wertet dessen Informationen zur Weiterverarbeitung aus
				while ((file_info = enumerator.next_file ()) != null) {
					string filename = ((!) file_info).get_name (); // https://live.gnome.org/Vala/Tutorial#Strict_Non-Null_Mode
					string tmp_extension;

					//extrahiert die Dateiendung
					tmp_extension = filename.substring(filename.last_index_of (".", 0), -1);
					if (tmp_extension == extension) {
						files.add(filename);
					}
				}
			} catch (Error e) {
				error ("Error: %s\n", e.message);
			}
			return files;
		}
	}
}


