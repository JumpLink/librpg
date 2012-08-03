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
using Gdk;
using HMP;
namespace HMP {
	/**
	 * Allgemeine Klasse fuer Sprites
	 */
	public class Sprite {
		public GdkTexture tex { get; private set; }
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
			tex = TEXTUREFACTORY.fromPixbuf(pixbuf);
		}
		/**
		 * 
		 */
		public void printValues ()
		requires (tex != null)
		{
			print("ich bin ein Sprite: ");
			tex.printValues();
		}
		public void printAll (){
			printValues();
		}
		/**
		 * 
		 */
		public void save (string filename) {
			tex.save(filename);
		}
	}
}