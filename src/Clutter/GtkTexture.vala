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

using GLib;
using Hmwd;
using GtkClutter;
using Gdk;
namespace Hmwd {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public class GtkClutterTexture : GdkTexture {
		public GtkClutter.Texture clutter_tex { get; protected set; }

		public GtkClutterTexture() {
			clutter_tex = new GtkClutter.Texture();
		}
		public GtkClutterTexture.fromFile(string path) {
			this();
			loadFromFile (path);
		}
		public GtkClutterTexture.fromPixbuf(Gdk.Pixbuf pixbuf) {
			loadFromPixbuf(pixbuf);
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected new void loadFromFile(string path) {
			base.loadFromFile(path);
			usePixbuf(pixbuf);
		}
		/**
		 * Ladet eine Textur aus einem Pixbuf in die Klasse.
		 * @param pixbuf Der pixbuf aus dem die Textur erstellt werden soll.
		 */
		public new void loadFromPixbuf(Gdk.Pixbuf pixbuf) {
			base.loadFromPixbuf(pixbuf);
			usePixbuf(pixbuf);
		}
		private void usePixbuf(Gdk.Pixbuf pixbuf) {
			try {
				clutter_tex.set_from_pixbuf(pixbuf);
			} catch (GLib.Error e) {
				print("Error: %s\n", e.message);
			}
		}
		/**
		 *
		 */
		// public override void draw( int x, int y, double zoff, Mirror mirror = Hmwd.Mirror.NONE) {
		// 	//TODO
		// 	print("TODO");
		// }
	}
}