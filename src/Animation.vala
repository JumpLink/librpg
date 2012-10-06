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
	 * Allgemeine Klasse fuer Sprites
	 */
	public class Animation : Object {
		public string name { get; construct set; }
		public Direction direction { get; construct set; }
		public bool repeat { get; construct set; }
		public int size {get{return animationdata.size;}}
		/**
		 * Animationsframes pro Sekunde
		 */
		public double frame_ps { get; set; default=6; }
		//private double timer = 0;
		public Gee.List<AnimationData> animationdata { get; construct set; }

		private int _current_frame_index = 0;
		public int current_frame_index {
			get { return _current_frame_index; }
			set {
				if(animationdata == null || value >= animationdata.size) {
					_current_frame_index = 0;
				}
				else if ( value < 0) {
					_current_frame_index = animationdata.size -1;
				}
				else {
					_current_frame_index = value;
				}
			}
		}
		public Animation() {
		}
		public Animation.all(string name, bool repeat, Direction direction, Gee.List<AnimationData> animationdata) {
			Object(name: name, repeat: repeat, direction: direction, animationdata:animationdata);
		}
		construct {
			// if (animationdata == null) {
			// 	printerr("animationdata == null create new animationdata\n");
			// 	animationdata = new Gee.ArrayList<AnimationData>();
			// }
		}

		public AnimationData get_AnimationData ()
		requires (animationdata != null)
		requires (animationdata[current_frame_index] != null)
		{
			return animationdata[current_frame_index];
		}
		// public void time() {
		// 	timer += STATE.interval;
		// 	if (timer * frame_ps >= 1) {
		// 		current_frame_index++;
		// 		timer = 0;
		// 	}
		// }
		public void time() {
			current_frame_index++;
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void printAnimationData() {
			print("SpriteSetAnimationData\n");
			int count = 0;
			foreach (AnimationData ad in animationdata) {
				print(@"# $count AniData: $ad \n");
				count++;
			}
		}
		/**
		 * Gibt alle Werte des SpriteSets auf der Konsole aus
		 */
		public void printValues() {
			print("SpriteSetAnimationValues\n");
			print("name: %s\n", name);
			print("direction: %s\n", direction.to_string());
			print("repeat: %s\n", repeat.to_string());
		}
		/**
		 * Gibt alles des SpriteSets auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printAnimationData();
		}
	}
}