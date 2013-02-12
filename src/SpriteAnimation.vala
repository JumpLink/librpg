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
	 * Allgemeine Klasse fuer Spriteanimationen
	 */
	public class SpriteAnimation : Object {

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
		public int size {get{return frame.size;}}

		/**
		 * Anzahl der Frames
		 */
		public int length {get{return size;}}

		/**
		 * Animationsframes pro Sekunde
		 */
		public double frame_ps { get; set; default=6; }

		public Gee.List<SpriteFrame> frame { get; construct set; }

		public SpriteAnimation.all(string name, bool repeat, Direction direction, Gee.List<SpriteFrame> frame) {
			Object(name: name, repeat: repeat, direction: direction, frame:frame);
		}
	}
}