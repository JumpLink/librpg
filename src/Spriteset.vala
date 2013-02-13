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
		public Gee.List<SpriteLayer> layers { get; set; }

		public SpriteLayer get_layers_from_index(int index) {
			return layers[index];
		}

		public int layers_size { get {return layers.size;} }

		public int layers_length { get {return layers.size;} }

		/**
		 * Ein Sprite kann mehrere Animationen beinhalten, sie sind als Koordinaten des Sprites der layers gespeichert.
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
			layers = new Gee.ArrayList<SpriteLayer>();
			animations = new Gee.ArrayList<SpriteAnimation>();
		}

		public SpriteLayer? get_base_layer()
		{
			foreach (SpriteLayer sl in layers) {
				if (sl.sprite_layer_type == rpg.SpriteLayerType.BASE)
					return sl;
			}
			print("no base layer found!");
			return null;
		}

		public GdkTexture merge_layer () {
			int i = 0;
			GdkTexture tex = new GdkTexture.from_pixbuf(layers.get(0).tex.pixbuf.copy());

			foreach (SpriteLayer layer in layers) {
				if(i!=0 && layer.active) {
					tex.pixbuf = GdkTexture.blit(tex.pixbuf, layer.tex.pixbuf);
				}
				++i;
			}
			return tex;
		}

		/**
		 * Get spriteset as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(SpritesetJsonParam params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);

			if(params.filename)
				object.set_string_member("filename", filename);

			if(params.folder)
				object.set_string_member("folder", folder);

			if(params.name)
				object.set_string_member("name", name);

			if(params.version)
				object.set_string_member("version", version);

			if(params.size) {
				object.set_double_member("width", width);
				object.set_double_member("height", height);
			}

			if(params.sprite_size) {
				object.set_double_member("sprite_width", sprite_width);
				object.set_double_member("sprite_height", sprite_height);
			}

			if(params.pixel_size) {
				object.set_double_member("pixel_width", pixel_width);
				object.set_double_member("pixel_height", pixel_height);
			}

			if(params.layer.or_gate()) {
				var layer_json_array = new Json.Array();
				foreach (rpg.SpriteLayer layer in layers) {
					layer_json_array.add_object_element(layer.get_json_indi( params.layer ).get_object() );
				}
				object.set_array_member("layers", layer_json_array);
			}

			if(params.animation.or_gate()) {
				var animation_json_array = new Json.Array();
				foreach (rpg.SpriteAnimation animation in animations) {
					animation_json_array.add_object_element(animation.get_json_indi( params.animation ).get_object() );
				}
				object.set_array_member("animations", animation_json_array);
			}

			return root;
		}
	}

	public class SpritesetJsonParam:GLib.Object {

		public bool filename { get; construct set; default=false; }

		public bool folder { get; construct set; default=false; }

		public bool name { get; construct set; default=false; }

		public bool version { get; construct set; default=false; }

		public bool size { get; construct set; default=false; }

		public bool sprite_size { get; construct set; default=false; }

		public bool pixel_size { get; construct set; default=false; }

		public SpriteLayerJsonParam layer { get; construct set; default=new SpriteLayerJsonParam(); }

		public SpriteAnimationJsonParam animation { get; construct set; default=new SpriteAnimationJsonParam(); }

		public SpritesetJsonParam ( bool filename = false, bool folder = false, bool name = false, bool size = false, bool sprite_size = false, bool pixel_size = false, bool version = false, SpriteLayerJsonParam layer = new SpriteLayerJsonParam(), SpriteAnimationJsonParam animation = new SpriteAnimationJsonParam() ) {
			GLib.Object( filename:filename, folder:folder, name:name, size:size, sprite_size:sprite_size, pixel_size:pixel_size, version:version, layer:layer, animation:animation );
		}

		public bool or_gate() {
			return filename || folder || name || size || sprite_size || pixel_size || version || layer.or_gate() || animation.or_gate();
		}	
	}

}