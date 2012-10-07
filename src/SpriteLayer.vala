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
using Hmwd;
namespace Hmwd {
	/**
	 * Allgemeine Klasse fuer Sprites
	 */
	public class SpriteLayer : Object {
		//string name; Name wird als HashMap gespeichert, nicht hier.
		public SpriteLayerType sprite_layer_type { get; construct set; }
		/**
		 * aktiv oder inaktiv
		 */
		public bool active { get; construct set; }
		public string name { get; construct set; }
		public int number { get; construct set; }
		//->image
		public string image_filename { get; construct set; }
		public uint image_width { get{ return width*sprite_width; } }
		public uint image_height { get{ return height*sprite_height; } }
		public string folder {get; construct set;}
		/**
		 * Transparente Farbe im SpriteLayers
		 */
		public string transparency;
		//<-image
		public uint width { get; construct set; }
		public uint height { get; construct set; }
		public uint sprite_width { get; construct set; }
		public uint sprite_height { get; construct set; }
		/**
		 * Array fuer die einzelnen Sprites
		 */	
		public Sprite[,] sprites;	
	
		public SpriteLayer.all(string folder, int number, string name, string image_filename, SpriteLayerType type, string trans, uint width, uint height, uint sprite_width, uint sprite_height) {			
			Object(folder:folder, name:name, image_filename:image_filename, sprite_layer_type:type, width:width, height:height, sprite_width:sprite_width, sprite_height:sprite_height, active:true);
		}
		/**
		 * Ladet die Pixel fuer die Sprites.
		 */
		public void split()
		{
			if (image_filename != "") {
				GdkTexture tex = new GdkTexture.from_file(folder+image_filename);
				sprites = new Sprite[height,width];
				Pixbuf pxb = tex.pixbuf;
				for(int y = 0; y < height; y++) {
					for(int x = 0; x < width; x++) {
						Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), (int) sprite_width, (int) sprite_height);
						pxb.copy_area((int) sprite_width*x, (int) sprite_height*y, (int) sprite_width, (int) sprite_height, split, 0, 0);
						sprites[y,x] = new Hmwd.Sprite(split);
					}
				}
			} else {
				GLib.error("Objekt enthaelt keinen Dateinamen fuer das zu splittende Bild!\n");
			}
		}
		public void print_sprites()
		{
			print("==Sprites==\n");
			for (uint y=0;y<width;y++) {
				for (uint x=0;x<height;x++) {
					sprites[y,x].print_values();
				}
				print("\n");
			}
		}
		public void print_all() {
			print("SpriteLayerAll\n");
			print_values();
		}
		public void print_values()
		requires (image_filename.length > 0)
		{
			print("SpriteLayerValues\n");
			print("Visable: %s\n", active.to_string());
			print("Name: %s\n", name);
			print("Number: %i\n", number);
			print("Image FileName: %s\n", image_filename);
			print("folder: %s\n", folder);
			print("width: %u\n",width);
			print("height: %u\n",height);
			print("sprite_width: %u\n",sprite_width);
			print("sprite_height: %u\n",sprite_height);
		}
	}
}