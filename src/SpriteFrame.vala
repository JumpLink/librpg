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

		public string to_string () {
			return @"x: $x y: $y mirror: $mirror";
		}
		public string x_to_string () {
			return @"$x";
		}
		public string y_to_string () {
			return @"$y";
		}
		public string mirror_to_string () {
			return @"$mirror";
		}
		public string to_string_for_split (string s) {
			return @"$x$s$y$s$mirror";
		}
	}
}