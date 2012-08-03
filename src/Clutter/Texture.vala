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
using Clutter;
namespace Hmwd {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public class ClutterTexture : GdkTexture {
		public Clutter.Texture clutter_tex { get; private set; }
		public new double width {
			get {return clutter_tex.get_width ();}
			set {clutter_tex.set_width ((float)value);}
		}
		public new double height {
			get {return clutter_tex.get_height ();}
			set {clutter_tex.set_height ((float)value);}
		}
		public new Hmwd.Colorspace colorspace {
			get { return Hmwd.Colorspace.fromCogl(clutter_tex.pixel_format); }
		}

		public ClutterTexture() {
			clutter_tex = new Clutter.Texture();

		}
		/**
		 * Ladet eine Textur aus einer Datei.
		 * @param path Pfadangabe der zu ladenden Grafikdatei.
		 */
		protected new void loadFromFile(string path)
		requires (path != null)
		{
			//clutter_tex = new Clutter.Texture.from_file(path);
			base.loadFromFile(path);
			loadFromPixbuf(pixbuf);
		}
		public new void loadFromPixbuf(Gdk.Pixbuf pixbuf) {
			base.loadFromPixbuf(pixbuf);
			try {
				clutter_tex.set_from_rgb_data (
											(uint8[])pixels,
											has_alpha,
											(int)base.width,
											(int)base.height,
											pixbuf.get_rowstride(),
											Hmwd.Colorspace.fromGdkPixbuf(pixbuf).to_channel(),
											Clutter.TextureFlags.NONE
											);
			} catch (GLib.Error e) {
				print("Error: %s\n", e.message);
			}
		}
		/**
		 *
		 */
		// public override void draw( int x, int y, double zoff, Mirror mirror = Hmwd.Mirror.NONE) {
		// 	print("TODO");
		// }
	}
}