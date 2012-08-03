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
using Clutter;
using GtkClutter;
using HMP;
namespace HMP {
	/**
	 * Klasse fuer TileSets Tests
	 */
	public class ClutterTest {

		/**
		 * Konstruktor
		 */
		public ClutterTest() {
			print("Erstelle Clutter Test-Objekt\n");
		}
		public void test_a() {
			print("test_a:\n");
			var stage = Clutter.Stage.get_default ();
			stage.set_title("Clutter Test");
			stage.set_color(Clutter.Color.from_string("black"));
			stage.set_size(300,300);
			stage.use_alpha = true;
			Clutter.Texture clutter_tex = new Clutter.Texture.from_file("./test/data/tileset/Stadt - Sommer.png");
			clutter_tex.show();
			stage.add_actor(clutter_tex);
			stage.show();
			Clutter.main();
		}
		public void test_b() {
			print("test_b:\n");
			var stage = Clutter.Stage.get_default ();
			stage.set_title("Clutter Test");
			stage.set_color(Clutter.Color.from_string("black"));
			stage.set_size(300,300);
			stage.use_alpha = true;
			SpriteSet spriteset = WORLD.SPRITESETMANAGER.getFromName("Hero");
			GtkClutter.Texture clutter_tex = new GtkClutter.Texture();
			clutter_tex.set_from_pixbuf(spriteset.spritelayers[0].sprites[0,0].tex.pixbuf);
			clutter_tex.show();
			stage.add_actor(clutter_tex);
			stage.show();
			Clutter.main();
		}
		public void test_c() {
			print("test_c:\n");
		}
	}
}