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
	 * Allgemeine Klasse fuer Sprites
	 */
	public class SpriteLayer : GLib.Object {
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

		public GdkTexture tex { get; set; }

		/**
		 * Array fuer die einzelnen Sprites
		 */	
		public Sprite[,] sprites;
	
		public SpriteLayer.all(string folder, int number, string name, string image_filename, SpriteLayerType type, string trans, uint width, uint height, uint sprite_width, uint sprite_height) {			
			GLib.Object(folder:folder, name:name, image_filename:image_filename, sprite_layer_type:type, width:width, height:height, sprite_width:sprite_width, sprite_height:sprite_height, active:true);
		}

		construct {

		}

		/**
		 * Get sprite as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(SpriteLayerJsonParam params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);

			if(params.sl_type) {
				object.set_string_member("type", sprite_layer_type.to_string());
			}

			if(params.active)
				object.set_boolean_member("active", active);

			if(params.name)
				object.set_string_member("name", name);

			if(params.number)
				object.set_int_member("number", number);

			if(params.image_filename)
				object.set_string_member("image_filename", image_filename);

			if(params.image_size) {
				object.set_int_member("image_width", image_width);
				object.set_int_member("image_height", image_height);
			}

			if(params.folder)
				object.set_string_member("folder", folder);

			if(params.transparency)
				object.set_string_member("transparency", transparency);

			if(params.size) {
				object.set_int_member("width", width);
				object.set_int_member("height", height);
			}

			if(params.sprite_size) {
				object.set_int_member("sprite_width", sprite_width);
				object.set_int_member("sprite_height", sprite_height);
			}

			if(params.tex)
				object.set_string_member("texture", tex.base64);

			if(params.sprites.or_gate()) {

				var first_dimension = new Json.Array();
				
				for (int y=0;(y<sprites.length[0]);y++) {

					var secound_dimension = new Json.Array();
					for (int x=0;(x<sprites.length[1]);x++) {
						secound_dimension.add_object_element( sprites[x,y].get_json_indi(params.sprites).get_object() );
					}
					first_dimension.add_array_element(secound_dimension);
				}

				object.set_array_member("sprites", first_dimension);
			}

			return root;
		}

		/**
		 * Like ''get_json_indi ()'' but returns the json string using ''rpg.json_to_string ()'', please see ''get_json_indi ()'' for parameter information.
		 *
		 * @return The new generated json string.
		 */
		public string get_json_indi_as_str(SpriteLayerJsonParam params) {
			return json_to_string(get_json_indi(params));
		}

		public void load_tex() {
			tex = new GdkTexture.from_file(folder+image_filename);
		}

		/**
		 * Ladet die Pixel fuer die Sprites.
		 */
		public void split() {
			if (image_filename != "") {
				//tex = new GdkTexture.from_file(folder+image_filename);
				sprites = new Sprite[height,width];
				Pixbuf pxb = tex.pixbuf;
				for(int y = 0; y < height; y++) {
					for(int x = 0; x < width; x++) {
						Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), (int) sprite_width, (int) sprite_height);
						pxb.copy_area((int) sprite_width*x, (int) sprite_height*y, (int) sprite_width, (int) sprite_height, split, 0, 0);
						sprites[y,x] = new rpg.Sprite(split);
					}
				}
			} else {
				GLib.error("Objekt enthaelt keinen Dateinamen fuer das zu splittende Bild!\n");
			}
		}
	}

	public class SpriteLayerJsonParam:GLib.Object {

		public bool sl_type { get; construct set; default=false; }

		public bool active { get; construct set; default=false; }

		public bool name { get; construct set; default=false; }

		public bool number { get; construct set; default=false; }

		public bool image_filename { get; construct set; default=false; }

		public bool image_size { get; construct set; default=false; }

		public bool folder { get; construct set; default=false; }

		public bool transparency { get; construct set; default=false; }

		public bool size { get; construct set; default=false; }

		public bool sprite_size { get; construct set; default=false; }

		public bool tex { get; construct set; default=false; }

		public SpriteJsonParam sprites { get; construct set; default = new SpriteJsonParam(); }

		public SpriteLayerJsonParam ( bool sl_type = false, bool active = false, bool name = false, bool number = false, bool image_filename = false, bool image_size = false, bool folder = false, bool transparency = false, bool size = false, bool sprite_size = false, bool tex = false, SpriteJsonParam sprites = new SpriteJsonParam() ) {
			GLib.Object( sl_type:sl_type, active:active, name:name, number:number, image_filename:image_filename, image_size:image_size, folder:folder, transparency:transparency, size:size, sprite_size:sprite_size, tex:tex, sprites:sprites );
		}

		/*
		 * @return true if any properity of this object is true, false if all properities false
		 */
		public bool or_gate() {
			return sl_type || active || name || number || image_filename || image_size || folder || transparency || size || sprite_size || tex || sprites.or_gate();
		}	
	}
}