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
	public class SpriteLayer {
		//string name; Name wird als HashMap gespeichert, nicht hier.
		public SpriteLayerType type;
		/**
		 * Transparente Farbe im SpriteLayers
		 */
		public string trans;
		/**
		 * aktiv oder inaktiv
		 */
		public bool active;
		public string name;	
		public int number;
		public string image_filename;
		uint width;
		uint height;
		uint spritewidth;
		uint spriteheight;
		/**
		 * Array fuer die einzelnen Sprites
		 */	
		public Sprite[,] sprites;
	
		public SpriteLayer(int number, string name, string image_filename, SpriteLayerType type, string trans, uint count_x, uint count_y, uint spritewidth, uint spriteheight) {
			this.name = name;
			this.image_filename = image_filename;
			this.type = type;
			this.width = count_x;
			this.height = count_y;
			this.spritewidth = spritewidth;
			this.spriteheight = spriteheight;
			this.active = true;
			this.loadSprites(count_y, count_x, spritewidth, spriteheight);

		}
		/**
		 * Ladet die Pixel fuer die Sprites.
		 */
		private void loadSprites(uint count_y, uint count_x, uint spritewidth, uint spriteheight)
		requires (image_filename != null)
		{
			if (image_filename != "") {
				GdkTexture tex = new OpenGLTexture.FromFile("./data/spriteset/"+image_filename);
				sprites = new Sprite[count_y,count_x];
				//int count = 0;
				Pixbuf pxb = tex.pixbuf;
				tex.printValues();
				print("=====LOADSPRITES=====\n");
				for(int y = 0; y < count_y; y++) {
					for(int x = 0; x < count_x; x++) {
						Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), (int) spritewidth, (int) spriteheight);
						//print("y: %i x:%i spritewidth:%u spriteheight:%u count %i", y, x, spritewidth, spriteheight, count);
						pxb.copy_area((int) spritewidth*x, (int) spriteheight*y, (int) spritewidth, (int) spriteheight, split, 0, 0);
						sprites[y,x] = new HMP.Sprite(split);
						//count++;
						//tile[y,x].printValues();
					}
				}
				print("Sprites zerteilt\n");
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
			print("width: %u\n",width);
			print("height: %u\n",height);
			print("spritewidth: %u\n",spritewidth);
			print("spriteheight: %u\n",spriteheight);
		}
	}
}