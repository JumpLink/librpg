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
	public class Sprite : GLib.Object {

		public int width {
			get { return tex.width; }
		}

		public int height {
			get { return tex.height; }
		}

		public GdkTexture tex { get; set; }

		/**
		 * Konstruktor mit uebergabe eines bereits existierenden und zu verwendenen Pixbuf.
		 * @param pixbuf Pixelbufer der in das Tile uebernommen werden soll.
		 */
		public Sprite (Pixbuf pixbuf) {
			GLib.Object(tex: new rpg.GdkTexture.from_pixbuf(pixbuf));
		}

		construct {

		}

		/**
		 * 
		 */
		public void save (string filename) {
			tex.save(filename);
		}

		/**
		 * Get sprite as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(SpriteJsonParam params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);

			if(params.size) {
				object.set_int_member("width", width);
				object.set_int_member("height", height);
			}

			if(params.tex)
				object.set_string_member("texture", tex.base64);

			return root;
		}

		/**
		 * Like ''get_json_indi ()'' but returns the json string using ''rpg.json_to_string ()'', please see ''get_json_indi ()'' for parameter information.
		 *
		 * @return The new generated json string.
		 */
		public string get_json_indi_as_str(SpriteJsonParam params) {
			return json_to_string(get_json_indi(params));
		}
	}

	public class SpriteJsonParam:GLib.Object {

		/**
		 * If true json includes filename.
		 */
		public bool tex { get; construct set; default=false; }

		/**
		 * If true json includes width and height.
		 */
		public bool size { get; construct set; default=false; }

		public SpriteJsonParam( bool tex = false, bool size = false ) {
			GLib.Object( tex:tex, size:size );
		}

		/*
		 * @return true if any properity of this object is true, false if all properities false
		 */
		public bool or_gate() {
			return tex || size ;
		}
	}
}