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
	 * Klasse fuer einen NPC.
	 */
	public class NPC : Entity {

		/**
		 * Dialogbaum.
		 */
		private DialogTree dialog;

		/**
		 * Konstruktor.
		 * @param pos Position.
		 * @param s Spriteset.
		 */
		public NPC (Coord pos, SpriteSet s) {
			this.pos = pos;
			spriteset = s;
			spriteset.set_Animation("stay", Direction.SOUTH	);
			DialogTree[] c = new DialogTree[2];
			c[0] = new DialogTree ("", "Gut.", new DialogTree[0]);
			c[1] = new DialogTree ("", "Nicht gut.", new DialogTree[0]);
			dialog = new DialogTree ("Wie gehts?", "", c);
		}
		/**
		 * Aendert ausgewaehlte Antwort.
		 * @param next Naechste Antwort ? sonst vorherige
		 */
		public void chooseAnswer (bool next) {
			dialog.chooseAnswer(next);
			print (dialog.getText());
		}

		public override void interactWith (Player p) {
			if (!STATE.dialog) {
				print ("Spieler %s redet mit NPC\n", p.name);
				STATE.dialog = true;
			} else
				dialog = dialog.getAnswer ();
			print (dialog.getText());
		}

	}
}