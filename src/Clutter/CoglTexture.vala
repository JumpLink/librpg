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
using HMP;
using Clutter;
namespace HMP {
	/**
	 * Klasse zur Speicherung einer Textur und um diese an OpenGL zu binden.
	 */
	public class CoglTexture : GdkTexture {
		// public Cogl.Texture cogl_tex { get; private set; }
		// public  double width {
		// 	get {return cogl_tex.get_width ();}
		// 	//set {cogl_tex.width = ((float)value);}
		// }
		// public  double height {
		// 	get {return cogl_tex.get_height ();}
		// 	//set {cogl_tex.set_height ((float)value);}
		// }
		// public  HMP.Colorspace colorspace {
		// 	get { return HMP.Colorspace.fromCogl(cogl_tex.pixel_format); }
		// }

		// public CoglTexture() {
		// 	//cogl_tex = new Cogl.Texture();

		// }
		// /**
		//  * Ladet eine Textur aus einer Datei.
		//  * @param path Pfadangabe der zu ladenden Grafikdatei.
		//  */
		// // protected void loadFromFile(string path)
		// // requires (path != null)
		// // {
		// // 	//clutter_tex = new Clutter.Texture.from_file(path);
		// // 	base.loadFromFile(path);
		// // 	loadFromPixbuf(pixbuf);
		// // }
		// public new void loadFromPixbuf(Gdk.Pixbuf pixbuf) {
		// 	base.loadFromPixbuf(pixbuf);
		// 	// cogl_tex.set_from_rgb_data (
		// 	// 								(uint8[])pixels,
		// 	// 								has_alpha,
		// 	// 								(int)base.width,
		// 	// 								(int)base.height,
		// 	// 								pixbuf.get_rowstride(),
		// 	// 								HMP.Colorspace.fromGdkPixbuf(pixbuf).to_channel(),
		// 	// 								Clutter.TextureFlags.NONE
		// 	// 							   );
		// }
		// /**
		//  *
		//  */
		// // public override void draw( int x, int y, double zoff, Mirror mirror = HMP.Mirror.NONE) {
		// // 	print("TODO");
		// // }
	}
}