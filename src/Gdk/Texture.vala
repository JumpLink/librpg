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
	public class GdkTexture : GLib.Object {
		/**
		 * Liefert den Pixbuf der Textur, Pixbuf wird fuer die Verwalltung der Pixel verwendet.<<BR>>
		 * * Weitere Informationen: [[http://valadoc.org/gdk-pixbuf-2.0/Gdk.Pixbuf.html]]
		 * @see Gdk.Pixbuf
		 */
		public Pixbuf pixbuf { get; set construct; }
		public string path { get; set construct; }
		public double width {
			get { return pixbuf.get_width(); }
			set { width = value;}
		}
		public double height {
			get { return pixbuf.get_height(); }
			set { height = value;}
		}
		public Hmwd.Colorspace colorspace {
			get { return Hmwd.Colorspace.fromGdkPixbuf(pixbuf); }
		}
		public uint length {
			get { return pixbuf.rowstride*pixbuf.height; }
		}
		/**
		 * Liefert ein Zeiger auf ein Array uint8[] mit den Pixelwerten,
		 * der hier vorgegebene Rueckgabetyp ist hier void* damit dieser mit OpenGL
		 * kompatibel ist.
		 */
		public uint8[] pixels {
			get {
				return pixbuf.get_pixels();
			}
		}

		public uint8[] copy_pixels() {
			uint size = pixbuf.rowstride*pixbuf.height;
			uint8[] p = new uint8[size];
			//uint8[] p = pixbuf.get_pixels()[0:size];
			print("pixel size: %u\n",size);
			// uint8[] tmp =  pixbuf.get_pixels();
			// uint8[] p = new uint8[size];

			for (int i = 0;i<size;i++) {
				p[i] = pixbuf.get_pixels()[i];
				print("%u ", p[i]);
			}
			//p = pixbuf.get_pixels();
			
			return p;
		}

		public uint8 copy_pixel(int n) {
			return pixbuf.get_pixels()[n];
		}

		public string string_pixels {
			get { return (string) pixbuf.get_pixels(); }
		}

		public uint8[] save_to_buffer(string type) {
	 		try {
				uint8[] pixel_buffer;
				pixbuf.save_to_buffer(out pixel_buffer, type );
				print("buffer_size: %u\n",pixel_buffer.length);
				return pixel_buffer;
			}
			catch (GLib.Error e) {
				GLib.error("%s pixel konnten nicht kopiert werden", path);
			}
		}
		public string save_to_buffer_string(string type) {
	 		try {
				uint8[] pixel_buffer;
				pixbuf.save_to_buffer(out pixel_buffer, type);
				print("buffer_size: %u\n",pixel_buffer.length);
				return (string) pixel_buffer;
			}
			catch (GLib.Error e) {
				GLib.error("%s pixel konnten nicht kopiert werden", path);
			}
		}

		/**
		 * Liefert Information darueber ob die Textur einen Alphakanal enthaelt.
		 * @see Gdk.Pixbuf.get_has_alpha
		 */
		public bool has_alpha {
			get { return this.pixbuf.get_has_alpha(); }
		}
		public GdkTexture() {

		}
		public GdkTexture.fromFile(string path) {
			GLib.Object(path:path);
		}
		public GdkTexture.fromPixbuf(Gdk.Pixbuf pixbuf) {
			GLib.Object(pixbuf:pixbuf);
		}
		construct {
			if(path != null) {
				loadFromFile(path);
			}
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected void loadFromFile(string path)
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
		public void loadFromPixbuf(Gdk.Pixbuf pixbuf)
		{
			print("GdkTexture: loadFromPixbuf\n");
			this.pixbuf = pixbuf;
		}
		/**
		 *
		 */
		public void save (string filename) {
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