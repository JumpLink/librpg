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
using rpg;
namespace rpg {
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
		public int width {
			get { return pixbuf.get_width(); }
			//set { width = value;}
		}
		
		public int height {
			get { return pixbuf.get_height(); }
			//set { height = value;}
		}

		public rpg.Colorspace colorspace {
			get { return rpg.Colorspace.fromGdkPixbuf(pixbuf); }
		}

		public int length {
			get { return pixbuf.rowstride*pixbuf.height; }
		}

		public int size {
			get { return pixbuf.rowstride*pixbuf.height; }
		}

		public int png_length {
			get { return png_buffer.length; }
		}
		/**
		 * Liefert ein Zeiger auf ein Array uint8[] mit den Pixelwerten,
		 * der hier vorgegebene Rueckgabetyp ist hier void* damit dieser mit OpenGL
		 * kompatibel ist.
		 */
		public uint8[] pixels {
			get { return pixbuf.get_pixels(); }
		}
		public uint8[] png_buffer { get; private set; }	//WORKAROUND for nodejs


		public GdkTexture.from_file(string path) {
			GLib.Object(path:path);
			load_from_file(path);
		}

		public GdkTexture.from_pixbuf(Gdk.Pixbuf pixbuf) {
			GLib.Object(pixbuf:pixbuf);
			load_from_pixbuf(pixbuf);
		}
		public GdkTexture.empty(int width, int height) {
			//GLib.Object(width:width, height:height);
			//load_from_pixbuf(pixbuf);
			pixbuf = new Pixbuf(Gdk.Colorspace.RGB, true, 8, width, height);

		}

		public static Pixbuf blit(Pixbuf dst, Pixbuf src) {
			// uint8[] dst_pixel_data = dst.get_pixels_with_length();
			uint8[] dst_pixel_data = GdkTexture.copy_pixels(dst);
			uint8[] src_pixel_data = src.get_pixels_with_length();
			// uint8[] dst_pixel_data = (uint8[]) dst.pixels;
			// uint8[] src_pixel_data = (uint8[]) src.pixels;
			print("src %i %i %i %i\n", src_pixel_data[0], src_pixel_data[1], src_pixel_data[2], src_pixel_data[3]);
			print("dst %i %i %i %i\n", dst_pixel_data[0], dst_pixel_data[1], dst_pixel_data[2], dst_pixel_data[3]);

			for(int i=0; i<dst.rowstride*dst.height-3; i+=4) {
				double alpha = src_pixel_data[i+3] / 256.0f;
				dst_pixel_data[i] = (uint8) (src_pixel_data[i] * alpha + dst_pixel_data[i] * (1 - alpha));
				dst_pixel_data[i+1] = (uint8) (src_pixel_data[i+1] * alpha + dst_pixel_data[i+1] * (1 - alpha));
				dst_pixel_data[i+2] = (uint8) (src_pixel_data[i+2] * alpha + dst_pixel_data[i+2] * (1 - alpha));
				dst_pixel_data[i+3] = (uint8) ((int)src_pixel_data[i+3] + dst_pixel_data[i+3]);
			}

			return new Pixbuf.from_data (dst_pixel_data, dst.colorspace, dst.has_alpha, dst.bits_per_sample, dst.width, dst.height, dst.rowstride);

		}

		public static uint8[] copy_pixels(Pixbuf pixbuf) {
			int size = pixbuf.rowstride*pixbuf.height;
			print("size: %i\n",size);
			uint8[] p = new uint8[size];
			for (int i = 0;i<size;i++) {
				p[i] = pixbuf.get_pixels()[i];
			}
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
				return pixel_buffer;
			}
			catch (GLib.Error e) {
				GLib.error("%s pixel konnten nicht kopiert werden", path);
			}
		}

		public uint8 get_png_buffer_from_index(int index) {
			return png_buffer[index];
		}
		/**
		 * Liefert Information darueber ob die Textur einen Alphakanal enthaelt.
		 * @see Gdk.Pixbuf.get_has_alpha
		 */
		public bool has_alpha {
			get { return this.pixbuf.get_has_alpha(); }
		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected void load_from_file(string path)
		{
	 		try {
				pixbuf = new Pixbuf.from_file (path);
			}
			catch (GLib.Error e) {
				error("%s konnte nicht geladen werden", path);
			}
			load_from_pixbuf(pixbuf);
		}

		/**
		 * Ladet eine Textur aus einem Pixbuf in die Klasse.
		 * @param pixbuf Der pixbuf aus dem die Textur erstellt werden soll.
		 */
		public void load_from_pixbuf(Gdk.Pixbuf pixbuf)
		{
			this.pixbuf = pixbuf;
			png_buffer = save_to_buffer("png");
		}
		/**
		 *
		 */
		public void save (string filename) {
			try {
				pixbuf.save(filename, "png");
			} catch (GLib.Error e) {
				error ("Error! Konnte Tile nicht Speichern: %s\n", e.message);
			}
		}
		public void print_png_as_hex() {
			uint8[] hex = save_to_buffer("png");
			foreach (uint8 h in hex) { stdout.printf("%02X ",h); }
		}

		/**
		 * Gibt die Werte der Textur auf der Konsole aus.
		 */
		public void print_values() {
			print("=Tex=\n");
			print(@"width: $width \n");
			print(@"height: $height \n");
			print(@"has alpha: $has_alpha \n");
		}
	}
}