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
		public uint sprite_width { get; set; }
		/**
		 * Hoehe eines Sprites
		 */
		public uint sprite_height { get; set; }
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
		public uint pixel_width {
			get {return (uint) (width * sprite_width);}
		}
		/**
		 * Gesamthoehe des Spritesets in Pixel
		 */
		public uint pixel_height {
			get {return (uint) (height * sprite_height);}
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
		public Gee.List<Animation> animations { get; set; }
		/**
		 * Aktuelle Animation die gerade verwendet wird.
		 */
		public Animation current_animation { get; set; }
		/**
		 * Konstrukter, ladet Spriteset mit Daten einer SpritesetDatei
		 *
		 * @param folder Das Verzeichnis aus dem gelesen werden soll
		 * @param filename Der Dateiname der gelesen werden soll
		 */
		public Spriteset.from_path (string folder, string filename) {
			Object(folder:folder, filename:filename);
		}
		construct {
			sprite_layers = new Gee.ArrayList<SpriteLayer>();
			animations = new Gee.ArrayList<Animation>();
		}

		/**
		 * Setzt eine Animation anhand ihres Namens und ihrer Richtung,
		 * dadurch wird dann durch draw das entsprechende Sprite verwendet.
		 */
		public void set_animation(string name, Direction direction)
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
		public void set_animation_from_string(string name, string direction) {
			set_animation(name, rpg.Direction.parse(direction));
		}

		public SpriteLayer get_base_layer()
		{
			foreach (SpriteLayer sl in sprite_layers) {
				if (sl.sprite_layer_type == rpg.SpriteLayerType.BASE)
					return sl;
			}
			error("no base layer found!");
		}
		/**
		 * Gibt alle Werte SpriteLayer auf der Konsole aus.
		 */
		public void print_sprite_layers()
		{
			if (sprite_layers.size > 0) {
				print("==SpriteLayer==\n");
				int count=0;
				foreach (SpriteLayer sl in sprite_layers) {
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
		public void print_animation()
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
		public void print_values()
		{
			print("SpritesetValues\n");
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("sprite_width: %u\n", sprite_width);
			print("sprite_width: %u\n", sprite_width);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alles vom Spriteset auf der Konsole aus.
		 */
		public void print_all() {
			print_values();
			print_sprite_layers();
			print_animation();
		}

	}
}