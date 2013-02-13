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
	 * Allgemeine Klasse fuer Spriteanimationen
	 */
	public class SpriteAnimation : GLib.Object {

		/**
		 * Name der Animation, z.B. "go" oder "stay".
		 */
		public string name { get; construct set; }

		/**
		 * Bewegungsrichtung fuer die die Animation ausgelegt ist,
		 * z.B. die Laufanimation eines Sprites in Richtung "north".
		 */
		public Direction direction { get; construct set; }

		/**
		 * Wenn true wird die Animation nach durchlauf wiederholt.
		 */
		public bool repeat { get; construct set; }

		/**
		 * Anzahl der Frames
		 */
		public int number_of_frames {get{return frames.size;}}

		/**
		 * Animationsframes pro Sekunde
		 */
		public int frame_ps { get; set; default=6; }

		public Gee.List<SpriteFrame> frames { get; construct set; }

		public SpriteAnimation.all(string name, bool repeat, Direction direction, Gee.List<SpriteFrame> frames) {
			GLib.Object(name: name, repeat: repeat, direction: direction, frames:frames);
		}

		/**
		 * Get sprite animation as individually json. You can define which properties should be included.
		 * @return The new generated json node.
		 */
		public Json.Node get_json_indi(SpriteAnimationJsonParam params) {

			var root = new Json.Node(NodeType.OBJECT);
			var object = new Json.Object();

			root.set_object(object);

			if(params.name) {
				object.set_string_member("name", name);
			}

			if(params.direction)
				object.set_string_member("direction", direction.to_string());

			if(params.repeat)
				object.set_boolean_member("repeat", repeat);

			if(params.number_of_frames)
				object.set_int_member("number_of_frames", number_of_frames);

			if(params.frame_ps)
				object.set_int_member("frame_ps", frame_ps);

			if(params.frame.or_gate()) {

				var frames_json_array = new Json.Array();

				foreach (rpg.SpriteFrame frame in frames) {
					frames_json_array.add_object_element(frame.get_json_indi( params.frame ).get_object() );
				}

				object.set_array_member("frames", frames_json_array);
			}

			return root;
		}

		/**
		 * Like ''get_json_indi ()'' but returns the json string using ''rpg.json_to_string ()'', please see ''get_json_indi ()'' for parameter information.
		 *
		 * @return The new generated json string.
		 */
		public string get_json_indi_as_str(SpriteAnimationJsonParam params) {
			return json_to_string(get_json_indi(params));
		}

	}

	public class SpriteAnimationJsonParam:GLib.Object {

		public bool name { get; construct set; default=false; }

		public bool direction { get; construct set; default=false; }

		public bool repeat { get; construct set; default=false; }

		public bool number_of_frames { get; construct set; default=false; }

		public bool frame_ps { get; construct set; default=false; }

		public SpriteFrameJsonParam frame { get; construct set; default = new SpriteFrameJsonParam(); }

		public SpriteAnimationJsonParam ( bool name = false, bool direction = false, bool repeat = false, bool number_of_frames = false, bool frame_ps = false, SpriteFrameJsonParam frame = new SpriteFrameJsonParam() ) {
			GLib.Object( name:name, direction:direction, repeat:repeat, number_of_frames:number_of_frames, frame_ps:frame_ps, frame:frame );
		}

		/*
		 * @return true if any properity of this object is true, false if all properities false
		 */
		public bool or_gate() {
			return name || direction || repeat || number_of_frames || frame_ps || frame.or_gate();
		}	
	}
}