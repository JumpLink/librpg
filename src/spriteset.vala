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
	 * Klasse fuer SpriteSets
	 */
	public class SpriteSet : Object {
		/**
		 * Dateiname des SpriteSets.
		 */
		public string filename { get; construct set; }
		public string folder { get; construct set; }
		/**
		 * Name des SpriteSets.
		 */
		public string name { get; set; }
		/**
		 * Breite eines Sprites
		 */
		public uint spritewidth { get; set; }
		/**
		 * Hoehe eines Sprites
		 */
		public uint spriteheight { get; set; }
		/**
		 * Gesamtbreite des SpriteSets in Sprites
		 */
		public uint width { get; set; }
		/**
		 * Gesamthoehe des SpriteSets in Sprites
		 */
		public uint height { get; set; }
		/**
		 * Gesamtbreite des SpriteSets in Pixel
		 */
		public uint pixelwidth {
			get {return (uint) (width * spritewidth);}
		}
		/**
		 * Gesamthoehe des SpriteSets in Pixel
		 */
		public uint pixelheight {
			get {return (uint) (height * spriteheight);}
		}
		/**
		 * Die Version des SpriteSets-XML-Formates
		 */
		public string version { get; set; }
		/**
		 * Ein Sprite kann aus mehreren Layern bestehen, sie werden mit einer Map gespeichert.
		 * Es gibt aktive und inaktive Layer, die inaktiven Layer werden beim zeichnen uebersprungen.
		 */
		public Gee.List<SpriteLayer> spritelayers { get; set; }
		public SpriteLayer get_spritelayers_from_index(int index) {
			return spritelayers[index];
		}
		public int spritelayers_size { get {return spritelayers.size;} }
		public int spritelayers_length { get {return spritelayers.size;} }
		/**
		 * Ein Sprite kann mehrere Animationen beinhalten, sie sind als Koordinaten des Sprites der SpriteLayers gespeichert.
		 * Die Animationen sind unabhaenig von den derzeit aktiven Layern. 
		 */
		public Gee.List<Animation> animations { get; set; }
		/**
		 * Aktuelle Animation die gerade verwendet wird.
		 */
		public Animation current_animation { get; set; }
		/**
		 * Konstruktor
		 */
		public SpriteSet() {

		}
		/**
		 * Konstrukter, ladet SpriteSet mit Daten einer SpriteSetDatei
		 *
		 * @param folder Das Verzeichnis aus dem gelesen werden soll
		 * @param filename Der Dateiname der gelesen werden soll
		 */
		public SpriteSet.fromPath (string folder, string filename) {
			Object(folder:folder, filename:filename);

		}
		construct {
			spritelayers = new Gee.ArrayList<SpriteLayer>();
			animations = new Gee.ArrayList<Animation>();
			// print("Lade SpriteSetdateien von %s + %s\n", folder, filename);

			// if(folder != null && filename != null) {
			// 	SSX xml = new SSX(folder,filename);
			// 	string tmp_name;
			// 	string tmp_version;
			// 	uint tmp_width;
			// 	uint tmp_height;
			// 	uint tmp_spritewidth;
			// 	uint tmp_spriteheight;
			// 	xml.loadGlobalProperties(out tmp_name, out tmp_version, out tmp_width, out tmp_height, out tmp_spritewidth, out tmp_spriteheight);
			// 	this.name = tmp_name;
			// 	this.version = tmp_version;
			// 	this.width = tmp_width;
			// 	this.height = tmp_height;
			// 	this.spritewidth = tmp_spritewidth;
			// 	this.spriteheight = tmp_spriteheight;
			// 	print("loadGlobalProperties -> name %s\n", name);
			// 	spritelayers = xml.loadLayers();
			// 	animations = xml.loadAnimations(width, height);
			// } else {
			// 	printerr("SpriteSet.fromPath: folder or filename is null\n");
			// }
		}

		/**
		 * Setzt eine Animation anhand ihres Namens und ihrer Richtung,
		 * dadurch wird dann durch draw das entsprechende Sprite verwendet.
		 */
		public void set_Animation(string name, Direction direction)
		requires (spritelayers != null)
		ensures (current_animation != null)
		{
			/*Wenn es sich um eine neue Bewegung handelt*/
			if (current_animation == null || name != current_animation.name || current_animation.direction != direction) {
				//if (current_animation != null) print(@"neue Bewegung!\n	$name $(current_animation.name) $direction  $(current_animation.direction)\n");
				foreach (Animation ani in animations) {
					if (ani.name == name && ani.direction == direction) {
						current_animation = ani;
						//setzt das Animationsframe an den Anfangsframe
						current_animation.current_frame_index = 0;
						break;
					}
				}
			} else { /* Wenn es sich um die gleiche Bewegung handelt*/
				//kein wechsel
			}
		}
		public void set_Animation_from_string(string name, string direction) {
			set_Animation(name, Hmwd.Direction.parse(direction));
		}

		public SpriteLayer? get_baseLayer()
		requires (spritelayers != null)
		{
			foreach (SpriteLayer sl in spritelayers) {
				if (sl.sprite_layer_type == Hmwd.SpriteLayerType.BASE)
					return sl;
				else return null;
			}
			return null;
		}
		// public void time() {
		// 	current_animation.time();
		// }
		/**
		 * Gibt alle Werte SpriteLayer auf der Konsole aus.
		 */
		public void printSpriteLayers()
		requires (spritelayers != null)
		{
			if (spritelayers.size > 0) {
				print("==SpriteLayer==\n");
				int count=0;
				foreach (SpriteLayer sl in spritelayers) {
					print("Nr. %i: ",count);
					sl.printAll();
					count++;
				}
			} else {
				error("Keine SpriteLayer vorhanden!\n");
			}
		}
		/**
		 * Gibt alle Animationen auf der Konsole aus.
		 */
		public void printAnimation()
		requires (animations != null)
		{
			print("==Animations==\n");
			int count=0;
			foreach (Animation ani in animations) {
				print("Nr. %i: ",count);
				ani.printAll();
				count++;
			}
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus.
		 */
		public void printValues()
		requires (name != null)
		{
			print("SpriteSetValues\n");
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("spritewidth: %u\n", spritewidth);
			print("spritewidth: %u\n", spritewidth);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alles vom SpriteSet auf der Konsole aus.
		 */
		public void printAll() {
			printValues();
			printSpriteLayers();
			printAnimation();
		}

	}
}