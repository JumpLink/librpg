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
		public uint image_width { get{ return width*spritewidth; } }
		public uint image_height { get{ return height*spriteheight; } }
		public string folder {get; construct set;}
		/**
		 * Transparente Farbe im SpriteLayers
		 */
		public string trans;
		//<-image
		public uint width { get; construct set; }
		public uint height { get; construct set; }
		public uint spritewidth { get; construct set; }
		public uint spriteheight { get; construct set; }
		/**
		 * Array fuer die einzelnen Sprites
		 */	
		public Sprite[,] sprites;

		public SpriteLayer() {

		}	

	
		public SpriteLayer.all(string folder, int number, string name, string image_filename, SpriteLayerType type, string trans, uint width, uint height, uint spritewidth, uint spriteheight) {			
			Object(folder:folder, name:name, image_filename:image_filename, sprite_layer_type:type, width:width, height:height, spritewidth:spritewidth, spriteheight:spriteheight, active:true);
		}
		construct{
			//this.loadSprites(folder, height, width, spritewidth, spriteheight);
		}
		/**
		 * Ladet die Pixel fuer die Sprites.
		 */
		public void loadSprites()
		requires (image_filename != null)
		{
			if (image_filename != "") {
				GdkTexture tex = new GdkTexture.fromFile(folder+image_filename);
				sprites = new Sprite[height,width];
				//int count = 0;
				Pixbuf pxb = tex.pixbuf;
				//tex.printValues();
				//print("=====LOADSPRITES=====\n");
				for(int y = 0; y < height; y++) {
					for(int x = 0; x < width; x++) {
						Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), (int) spritewidth, (int) spriteheight);
						//print("y: %i x:%i spritewidth:%u spriteheight:%u count %i", y, x, spritewidth, spriteheight, count);
						pxb.copy_area((int) spritewidth*x, (int) spriteheight*y, (int) spritewidth, (int) spriteheight, split, 0, 0);
						sprites[y,x] = new Hmwd.Sprite(split);
						//count++;
						//tile[y,x].printValues();
					}
				}
				//print("Sprites zerteilt\n");
			} else {
				GLib.error("Objekt enthaelt keinen Dateinamen fuer das zu splittende Bild!\n");
			}
		}
		public void printSprites()
		requires (sprites != null)
		{
			print("==Sprites==\n");
			for (uint y=0;y<width;y++) {
				for (uint x=0;x<height;x++) {
					//print("%u ", tile[y,x].type);
					sprites[y,x].printValues();
				}
				print("\n");
			}
		}
		public void printAll() {
			print("SpriteLayerAll\n");
			printValues();
			//printSprites();
		}
		public void printValues()
		requires (image_filename != null)
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
			print("spritewidth: %u\n",spritewidth);
			print("spriteheight: %u\n",spriteheight);
		}
	}
}