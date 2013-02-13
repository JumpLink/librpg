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
using Json;
using rpg;
namespace rpg {
	/**
	 * Verwaltet die Frames einer Animation.
	 */
	public class SpriteFrame:GLib.Object {
		public Coordinate2D coord { public get; private set; }
		construct {
			coord = new Coordinate2D();
		}
		public Mirror mirror;
		public double x {
			get { return coord.x; }
			set { coord.x = value; }
		}
		public double y {
			get { return coord.y; }
			set { coord.y = value; }
		}

		/**
		 * Get sprite frame as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(SpriteFrameJsonParam params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);

			if(params.mirror)
				object.set_string_member("mirror", mirror.to_string());

			if(params.coord) {
				object.set_double_member("x", coord.x);
				object.set_double_member("y", coord.y);
			}

			return root;
		}

		/**
		 * Like ''get_json_indi ()'' but returns the json string using ''rpg.json_to_string ()'', please see ''get_json_indi ()'' for parameter information.
		 *
		 * @return The new generated json string.
		 */
		public string get_json_indi_as_str(SpriteFrameJsonParam params) {
			return json_to_string(get_json_indi(params));
		}
	}

	public class SpriteFrameJsonParam:GLib.Object {

		public bool coord { get; construct set; default=false; }

		public bool mirror { get; construct set; default=false; }

		public SpriteFrameJsonParam ( bool coord = false, bool mirror = false ) {
			GLib.Object( coord:coord, mirror:mirror );
		}

		public bool or_gate() {
			return coord || mirror;
		}	
	}
}