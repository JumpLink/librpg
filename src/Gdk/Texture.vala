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

using Gdk;
using GLib;
using Hmwd;
namespace Hmwd {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public abstract class GdkTexture : GLib.Object, Texture {
		/**
		 * Liefert den Pixbuf der Textur, Pixbuf wird fuer die Verwalltung der Pixel verwendet.<<BR>>
		 * * Weitere Informationen: [[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Pixbuf.html]]
		 * @see Gdk.Pixbuf
		 */
		public virtual Pixbuf pixbuf { get; protected set; }
		public virtual double width {
			get { return pixbuf.get_width(); }
			set { width = value;}
		}
		public virtual double height {
			get { return pixbuf.get_height(); }
			set { height = value;}
		}
		public virtual Hmwd.Colorspace colorspace {
			get { return Hmwd.Colorspace.fromGdkPixbuf(pixbuf); }
		}
		/**
		 * Liefert ein Zeiger auf ein Array uint8[] mit den Pixelwerten,
		 * der hier vorgegebene Rueckgabetyp ist hier void* damit dieser mit OpenGL
		 * kompatibel ist.
		 */
		public virtual void* pixels {
			get { return pixbuf.get_pixels(); }
		}
		/**
		 * Liefert Information darueber ob die Textur einen Alphakanal enthaelt.
		 * @see Gdk.Pixbuf.get_has_alpha
		 */
		public virtual bool has_alpha {
			get { return this.pixbuf.get_has_alpha(); }
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected virtual void loadFromFile(string path)
		requires (path != null)
		{
	 		try {
				pixbuf = new Pixbuf.from_file (path);
			}
			catch (GLib.Error e) {
				//GLib.error("", e.message);
				GLib.error("%s konnte nicht geladen werden", path);
			}
			print("GdkTexture: loadFromFile\n");
			loadFromPixbuf(pixbuf);
		}

		/**
		 * Ladet eine Textur aus einem Pixbuf in die Klasse.
		 * @param pixbuf Der pixbuf aus dem die Textur erstellt werden soll.
		 */
		public virtual void loadFromPixbuf(Gdk.Pixbuf pixbuf)
		requires (pixbuf != null)
		{
			print("GdkTexture: loadFromPixbuf\n");
			this.pixbuf = pixbuf;
		}
		/**
		 *
		 */
		public virtual void save (string filename) {
			try {
				pixbuf.save(filename, "png");
				print("GdkTexture: save\n");
			} catch (GLib.Error e) {
				error ("Error! Konnte Sprite nicht Speichern: %s\n", e.message);
			}
		}
		/**
		 *
		 */
		//public abstract void draw( int x, int y, double zoff, Mirror mirror = Hmwd.Mirror.NONE);

		/**
		 * Gibt die Werte der Textur auf der Konsole aus.
		 */
		public void printValues() {
			print("=Tex=\n");
			print(@"width: $width \n");
			print(@"height: $height \n");
			print(@"has alpha: $has_alpha \n");
		}
	}
}