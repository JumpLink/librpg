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
using HMP;
namespace HMP {
	/**
	 * Klasse fuer das Spielerobjekt
	 */
	public class Player : Entity {
		/**
		 * Name des Spielers
		 */
		public string name;

		/**
		 * Inventar
		 */
		public Inventory tools = new Inventory ();

		/**
		 * Aufgehobener Gegenstand.
		 */
		public Carryable item;

		/**
		 * Lager.
		 */
		public Storage storage = new Storage ();

		/**
		 * Radius, in dem Spieler mit anderen Entitaeten interagieren kann.
		 */
		private double interactionRadius = 15.0;

		/**
		 * Aktuelle Ausdauer.
		 */
		private int stamina = DEFAULT_STAMINA;

		/**
		 * Stufe.
		 */
		private uint level = 1;

		/**
		 * Erfahrungspunkte, die zum Erreichen der naechsten Stufe benoetigt werden.
		 */
		public int requiredExperience = EXPERIENCE;

		/**
		 * Konstruktor
		 */
		public Player(string name, SpriteSet spriteset) {
			base ();
			this.name = name;
			this.spriteset = spriteset;
			spriteset.set_Animation("stay", Direction.SOUTH	);
		}

		/**
		 * Gibt an, ob sich eine Entitaet in Reichweite des Spielers befindet.
		 * @param e Die Entitaet.
		 * @return Entitaet in Reichweite.
		 */
		private bool inRange(Entity e) {
			Vector v = new Vector.fromDifference (e.pos, pos);
			if (e != this && v.VectorNorm() < interactionRadius) {
				//print ("V: %f, %f\n", v.vec[0], v.vec[1]);
				return (direction == Direction.NORTH && v.vec[0] > 0.0)
					|| (direction == Direction.EAST && v.vec[1] < 0.0)
					|| (direction == Direction.SOUTH && v.vec[0] < 0.0)
					|| (direction == Direction.WEST && v.vec[1] > 0.0);
			}
			return false;
		}

		/**
		 * Gibt logisches Teil aus, das sich vor dem Spieler befindet.
		 * @return Das logische Teil.
		 */
		private LogicalTile Target() {
			int 	tx = (int) pos.x, 
					ty = (int) pos.y;
			switch (direction) {
				case Direction.NORTH:
					ty -= 1;
					break;
				case Direction.EAST:
					tx += 1;
					break;
				case Direction.SOUTH:
					ty += 1;
					break;
				case Direction.WEST:
					tx -= 1;
					break;
			}
			return WORLD.CURRENT_MAP.tiles[tx,ty];
		}

		public void printTools() {
			
		}
		public void printItems() {
			
		}
		public void printSpriteSet() {
			spriteset.printAll();
		}
		public void printValues() {
			print("Name: "+this.name+"\n");
		}
		public void printAll() {
			printValues();
			printSpriteSet();
			printItems();
			printTools();
		}
		/**
	 	 * Benutzt ausgeruestetes Werkzeug mit Spielerumgebung.
	 	 */
		public void use () {
			if (stamina > 0) {
				int actions = (int) tools.use (WORLD.CURRENT_MAP, (uint) ((pos.x)/WORLD.CURRENT_MAP.tilewidth), 
					(uint) ((pos.y) /WORLD.CURRENT_MAP.tileheight), direction, storage);
				stamina -= actions;
				requiredExperience -= actions;
			} else {
				print ("Du solltest dich erstmal ausruhen!\n");
			}
		}

		/**
		 * Wechselt zwischen ausgeruesteten Werkzeugen.
		 */
		public void swap () {
			tools.swapTools ();
		}

		/**
		 * Interagiert mit Spielerumgebung (Sachen aufheben, NPCs ansprechen)
		 */
		public void interact () {
			print ("Spieler %s interagiert\n", name);
			//Interaktion mit anderen Entitaeten.
			foreach (Entity e in WORLD.CURRENT_MAP.entities) {
				if (item == null && inRange(e))
					e.interactWith(this);
			}
			LogicalTile t = Target ();
			//Ernten von Pflanzen.
			if (item == null && t.plant != null)
				item = new CropEntity (t.plant.harvest ());
			//Ausloesen von Ereignissen.
			if (t.event != null)
				t.event.trigger (this);
		}
		/**
		 * Aendert ausgewaehlte Antwort.
		 * @param next Naechste Antwort ? sonst vorherige
		 */
		public void chooseAnswer (bool next) {
			if (STATE.dialog) {
				foreach (Entity e in WORLD.CURRENT_MAP.entities) {
					if (item == null && inRange(e) && e is NPC)
						(e as NPC).chooseAnswer (next);
				}
			}
		}

		public override void interactWith (Player p) {
			//TODO Interaktion zwischen zwei Spielern.
		}

		public new void age () {
			if (requiredExperience <= 0) {
				++level;
				requiredExperience = (int) level * EXPERIENCE;
				print ("Level %u erreicht!\n", level);
			}
			stamina = DEFAULT_STAMINA * STAMINA_MULTIPLIER * (int) level;
		}

	}
}
