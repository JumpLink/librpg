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
using Gdk;
using rpg;
namespace rpg {
	/**
	 * Allgemeine Klasse fuer Sprites
	 */
	public class Sprite : Object {
		public GdkTexture tex { get; set; }
		public double width {
			get { return tex.width; }
		}
		public double height {
			get { return tex.height; }
		}
		/**
		 * Konstruktor mit uebergabe eines bereits existierenden und zu verwendenen Pixbuf.
		 * @param pixbuf Pixelbufer der in das Tile uebernommen werden soll.
		 */
		public Sprite (Pixbuf pixbuf) {
			Object(tex: new rpg.GdkTexture.from_pixbuf(pixbuf));
		}
		construct {

		}
		/**
		 * 
		 */
		public void save (string filename) {
			tex.save(filename);
		}
	}
}