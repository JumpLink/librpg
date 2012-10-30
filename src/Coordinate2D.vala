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
	 * 2D Koordinaten, bei Koordinaten-opperationen kann die Vector-Klasse
	 * verwendet werden von der diese Klasse erbt.
	 */
	public class Coordinate2D:Vector {
		public Coordinate2D() {
			base(2);
		}
		public Coordinate2D.nondefault (double x, double y) {
			this();
			this.x = x;
			this.y = y;
		}
		public double x {
			get { return vec[1]; }
			set { vec[1] = value; }
		}
		public double y {
			get { return vec[0]; }
			set { vec[0] = value; }
		}
	}
}