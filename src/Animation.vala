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
 */
using Gee;
using Gdk;	
using Hmwd;
namespace Hmwd {
	/**
	 * Allgemeine Klasse fuer Spriteanimationen
	 */
	public class Animation : Object {
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
		public int size {get{return Frame.size;}}
		/**
		 * Anzahl der Frames
		 */
		public int length {get{return size;}}
		/**
		 * Animationsframes pro Sekunde
		 */
		public double frame_ps { get; set; default=6; }

		public Gee.List<Frame> Frame { get; construct set; }

		private int _current_frame_index = 0;
		public int current_frame_index {
			get { return _current_frame_index; }
			set {
				if(value >= Frame.size) _current_frame_index = 0;
				else if ( value < 0) _current_frame_index = Frame.size -1;
				else _current_frame_index = value;
			}
		}

		public Animation.all(string name, bool repeat, Direction direction, Gee.List<Frame> Frame) {
			Object(name: name, repeat: repeat, direction: direction, Frame:Frame);
		}

		public Frame get_animation_data ()
		{
			return Frame[current_frame_index];
		}
		/**
		 * Setzt das nächste Frame der Animation
		 */
		public void next_frame() {
			current_frame_index++;
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void print_animation_data() {
			print("SpriteSetFrame\n");
			int count = 0;
			foreach (Frame ad in Frame) {
				print(@"# $count AniData: $ad \n");
				count++;
			}
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void print_values() {
			print("SpriteSetAnimationValues\n");
			print("name: %s\n", name);
			print("direction: %s\n", direction.to_string());
			print("repeat: %s\n", repeat.to_string());
		}
		/**
		 * Gibt alles des SpriteSets auf der Konsole aus
		 */
		public void print_all() {
			print_values();
			print_animation_data();
		}
	}
}