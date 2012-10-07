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
//using GLib; //Fuer assertions

using Hmwd;
namespace Hmwd {
	/**
	 * Klasse fuer Tilesets
	 */
	public class Tileset : Object {
		/**
		 * Name des Tilesets.
		 */
		public string name { get; set; }
		/**
		 * Dateiname des Tilesets.
		 */
		public string filename { get; construct set; }
		/**
		 * Breite eines Tiles
		 */
		public int tile_width { get; set; }
		/**
		 * Hoehe eines Tiles
		 */
		public int tile_height { get; set; }
		/**
		 * Dateiname des Tileset-Bildes
		 */
		public string source { get; set; } //TODO gibt es mehrere sources?
		/**
		 * transparencyparente Farbe im Tileset
		 */
		public string transparency { get; set; }
		/**
		 * Gesamtbreite des Tilesets
		 */
		public int width { get; set; }
		/**
		 * Gesamthoehe des Tilesets
		 */
		public int height { get; set; }
		/**
		 * Die Tiles in Form eines 2D-Array des Tilesets
		 */
		public Tile[,] tile { get; set; }

		public int count_y {
			get { return (height / tile_height); }
		}

		public int count_x {
			get { return (width / tile_width); }
		}

		public GdkTexture tex { get; set; }

		/**
		 * Konstruktor
		 */
		public Tileset(string filename) {
			Object(filename:filename);
		}
		/**
		 * Gibt ein gesuchtes Tile anhand seines Index zurueck.
		 *
		 * @param index Index des gesuchten Tiles
		 */
		public Hmwd.Tile get_tile_from_index(int index)
		requires (index >= 0)
		{
			int count = 0;
			for (int y=0;(y<count_y);y++) {
				for (int x=0;(x<count_x);x++) {
					if (count == index) {
						return tile[x,y];
					}
					count++;
				}
			}
			error("Tile mit index %i nicht gefunden!", index);
		}
		/**
		 * Ladet die Pixel fuer die Tiles.
		 * Zur Zeit alle noch als RegularTile.
		 */
		public void split(string folder) {
			tex = new GdkTexture.from_file(folder+source);
			int split_width = (int) tile_width;
			int split_height = (int) tile_height;
			tile = new Tile[count_x,count_y];
			Pixbuf pxb = tex.pixbuf;
			for(int y = 0; y < count_y; y++) {
				for(int x = 0; x < count_x; x++) {
					Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), split_width, split_height);
					pxb.copy_area((int) split_width*x, (int) split_height*y, (int) split_width, (int) split_height, split, 0, 0);
					tile[x,y] = new RegularTile.from_pixbuf(split);
				}
			}
		}
		/**
		 * Speichert alle Tiles als Datei.
		 * @param folder Ordner in dem die Bilder gespeichert werden sollen.
		 */
		public void save(string folder = "./tmp/") {
			for (int y=0;y<count_y;y++) {
				for (int x=0;x<count_x;x++) {
					tile[x,y].save(folder+name+"_y"+y.to_string()+"_x"+x.to_string()+".png");
				}
			}
		}
		/**
		 * Gibt alle Werte Tiles auf der Konsole aus
		 */
		public void print_tiles() {
			print("==Tiles==\n");
			for (int y=0;y<count_y;y++) {
				for (int x=0;x<count_x;x++) {
					tile[x,y].print_values();
				}
				print("\n");
			}
			print("\nWenn du dies siehst konnten alle Tiles durchlaufen werden\n");
		}
		/**
		 * Gibt alle Werte des Tilesets auf der Konsole aus
		 */
		public void print_values() {
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("tile_width: %u\n", tile_width);
			print("tile_height: %u\n", tile_height);
			print("source: %s\n", source);
			print("transparency: %s\n", transparency);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alle Werte und die Tiles des Tilesets auf der Konsole aus
		 */
		public void printAll() {
			print_values();
			print_tiles();
		}
	}
}