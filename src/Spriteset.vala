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
using Json;
using rpg;
namespace rpg {
	/**
	 * Klasse fuer Spritesets
	 */
	public class Spriteset : GLib.Object {

		/**
		 * Dateiname des Spritesets.
		 */
		public string filename { get; construct set; }

		public string folder { get; construct set; } // TODO remove?

		/**
		 * Name des Spritesets.
		 */
		public string name { get; set; }

		/**
		 * Breite eines Sprites
		 */
		public int sprite_width { get; set; }

		/**
		 * Hoehe eines Sprites
		 */
		public int sprite_height { get; set; }

		/**
		 * Gesamtbreite des Spritesets in Sprites
		 */
		public int width { get; set; }

		/**
		 * Gesamthoehe des Spritesets in Sprites
		 */
		public int height { get; set; }

		/**
		 * Gesamtbreite des Spritesets in Pixel
		 */
		public int pixel_width {
			get {return (width * sprite_width);}
		}

		/**
		 * Gesamthoehe des Spritesets in Pixel
		 */
		public int pixel_height {
			get {return (height * sprite_height);}
		}

		/**
		 * Die Version des Spritesets-XML-Formates
		 */
		public string version { get; set; }

		/**
		 * Ein Sprite kann aus mehreren Layern bestehen, sie werden mit einer Map gespeichert.
		 * Es gibt aktive und inaktive Layer, die inaktiven Layer werden beim zeichnen uebersprungen.
		 */
		public Gee.List<SpriteLayer> sprite_layers { get; set; }

		public SpriteLayer get_sprite_layers_from_index(int index) {
			return sprite_layers[index];
		}

		public int sprite_layers_size { get {return sprite_layers.size;} }

		public int sprite_layers_length { get {return sprite_layers.size;} }

		/**
		 * Ein Sprite kann mehrere Animationen beinhalten, sie sind als Koordinaten des Sprites der sprite_layers gespeichert.
		 * Die Animationen sind unabhaenig von den derzeit aktiven Layern. 
		 */
		public Gee.List<SpriteAnimation> animations { get; set; }

		/**
		 * Konstrukter, ladet Spriteset mit Daten einer SpritesetDatei
		 *
		 * @param folder Das Verzeichnis aus dem gelesen werden soll
		 * @param filename Der Dateiname der gelesen werden soll
		 */
		public Spriteset.from_path (string folder, string filename) {
			GLib.Object(folder:folder, filename:filename);
		}

		construct {
			sprite_layers = new Gee.ArrayList<SpriteLayer>();
			animations = new Gee.ArrayList<SpriteAnimation>();
		}

		public SpriteLayer? get_base_layer()
		{
			foreach (SpriteLayer sl in sprite_layers) {
				if (sl.sprite_layer_type == rpg.SpriteLayerType.BASE)
					return sl;
			}
			print("no base layer found!");
			return null;
		}

		public GdkTexture merge_layer () {
			int i = 0;
			GdkTexture tex = new GdkTexture.from_pixbuf(sprite_layers.get(0).tex.pixbuf.copy());

			foreach (SpriteLayer layer in sprite_layers) {
				if(i!=0 && layer.active) {
					tex.pixbuf = GdkTexture.blit(tex.pixbuf, layer.tex.pixbuf);
				}
				++i;
			}
			return tex;
		}
	}
}