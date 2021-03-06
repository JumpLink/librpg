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
	 * Klasse fuer einen Dialogbaum.
	 */
	public class DialogTree : Object {
		/**
		 * Antwort auf vorhergehende Frage.
		 */
		public string answer { get; construct set; }
		/**
		 * Aktuelle Frage.
		 */
		public string question { get; construct set; }
		/**
		 * Ausgewaehlte Antwort.
		 */
		public int choice { get; construct set; }
		/**
		 * Antwortmoeglichkeiten.
		 */
		public rpg.DialogTree[] children { get; private set; } //FIXME: http://pastebin.com/nEcr7VMe

		/**
		 * Konstruktor.
		 * @param q Frage.
		 * @param a Antwort.
		 * @param c Nachfolger.
		 */
		public DialogTree (string q, string a, rpg.DialogTree[] c) { 
			Object(question: q, answer: a/*, children: c, choice: 0*/); //FIXME
		}
		construct {

		}
		/**
		 * Aendert ausgewaehlte Antwort.
		 * @param next Naechste Antwort ? sonst vorherige
		 */
		public void choose_answer (bool next) {
			choice = (choice + (next ? 1 : -1)) % children.length;
		}
		/**
		 * Gibt aktuelle Frage und moegliche Antworten aus.
		 * @return Frage und Antworten als string.
		 */
		public string get_text () {
			if (children.length == 0) {
				//STATE.dialog = false;
				return "Dialog beendet!";
			}
			string text = question + "\n";
			for (uint i = 0; i < children.length; ++i) {
				text += i.to_string() + " : " + children[i].answer + ((i == choice) ? "!" : "") + "\n";			
			}
			return text;
		}
		/**
		 * Gibt ausgewaehlte Antwort aus.
		 * @return Die Antwort.
		 */
		public DialogTree get_chosen_answer () {
			return children[choice];
		}
	}
}