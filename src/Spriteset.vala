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
	 * Klasse fuer Spritesets
	 */
	public class Spriteset : Object {
		/**
		 * Dateiname des Spritesets.
		 */
		public string filename { get; construct set; }
		public string folder { get; construct set; }
		/**
		 * Name des Spritesets.
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
		 * Gesamtbreite des Spritesets in Sprites
		 */
		public uint width { get; set; }
		/**
		 * Gesamthoehe des Spritesets in Sprites
		 */
		public uint height { get; set; }
		/**
		 * Gesamtbreite des Spritesets in Pixel
		 */
		public uint pixelwidth {
			get {return (uint) (width * spritewidth);}
		}
		/**
		 * Gesamthoehe des Spritesets in Pixel
		 */
		public uint pixelheight {
			get {return (uint) (height * spriteheight);}
		}
		/**
		 * Die Version des Spritesets-XML-Formates
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
		public Spriteset() {

		}
		/**
		 * Konstrukter, ladet Spriteset mit Daten einer SpritesetDatei
		 *
		 * @param folder Das Verzeichnis aus dem gelesen werden soll
		 * @param filename Der Dateiname der gelesen werden soll
		 */
		public Spriteset.fromPath (string folder, string filename) {
			Object(folder:folder, filename:filename);

		}
		construct {
			spritelayers = new Gee.ArrayList<SpriteLayer>();
			animations = new Gee.ArrayList<Animation>();
			// print("Lade Spritesetdateien von %s + %s\n", folder, filename);
		}

		/**
		 * Setzt eine Animation anhand ihres Namens und ihrer Richtung,
		 * dadurch wird dann durch draw das entsprechende Sprite verwendet.
		 */
		public void set_Animation(string name, Direction direction)
		{
			/*Wenn es sich um eine neue Bewegung handelt*/
			if (name != current_animation.name || current_animation.direction != direction) {
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
		{
			foreach (SpriteLayer sl in spritelayers) {
				if (sl.sprite_layer_type == Hmwd.SpriteLayerType.BASE)
					return sl;
				else return null;
			}
			return null;
		}
		/**
		 * Gibt alle Werte SpriteLayer auf der Konsole aus.
		 */
		public void printSpriteLayers()
		{
			if (spritelayers.size > 0) {
				print("==SpriteLayer==\n");
				int count=0;
				foreach (SpriteLayer sl in spritelayers) {
					print("Nr. %i: ",count);
					sl.print_all();
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
		{
			print("==Animations==\n");
			int count=0;
			foreach (Animation ani in animations) {
				print("Nr. %i: ",count);
				ani.print_all();
				count++;
			}
		}
		/**
		 * Gibt alle Werte des Spritesets auf der Konsole aus.
		 */
		public void printValues()
		{
			print("SpritesetValues\n");
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("spritewidth: %u\n", spritewidth);
			print("spritewidth: %u\n", spritewidth);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alles vom Spriteset auf der Konsole aus.
		 */
		public void print_all() {
			printValues();
			printSpriteLayers();
			printAnimation();
		}

	}
}