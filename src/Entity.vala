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
	 * Allgemeine Entityklasse.
	 * hiervon erben Spieler, NPCs und andere Dynamische Objekte.
	 */
	public abstract class Entity : Object {

		/**
		 * Geschwindigkeit (Schritte in X-Richtung pro Sekunde)
		 */
		public double steps_ps { get; set; default=35; }

		/**
		 * Position des Entities
		 */
		public Coordinate2D pos {get; protected set; default=new Coordinate2D();}

		/**
		 * Ausrichtung der Entitaet.
		 */
		public Direction direction { get; set; default=Direction.SOUTH; }

		public bool motion { get; protected set; default = false;}

		public double collision_radius { get; protected set; default = 5.0;}
		
		/**
		 * Spriteset der Entity, beinhaltet Animationen und deren Grafiken.
		 */
		public Spriteset spriteset { get; set;}

		public static int compare (Entity a, Entity b) {
			return (int) (a.pos.y - b.pos.y);
		}
	}
}