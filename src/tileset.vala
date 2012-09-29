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
	 * Klasse fuer TileSets
	 */
	public class TileSet : Object {
		/**
		 * Name des TileSets.
		 */
		public string name { get; set; }
		/**
		 * Dateiname des TileSets.
		 */
		public string filename { get; construct set; }
		/**
		 * Breite eines Tiles
		 */
		public uint tilewidth { get; set; }
		/**
		 * Hoehe eines Tiles
		 */
		public uint tileheight { get; set; }
		/**
		 * Dateiname des TileSet-Bildes
		 */
		public string source { get; set; } //TODO gibt es mehrere sources?
		/**
		 * Transparente Farbe im TileSet
		 */
		public string trans { get; set; }
		/**
		 * Gesamtbreite des TileSets
		 */
		public uint width { get; set; }
		/**
		 * Gesamthoehe des TileSets
		 */
		public uint height { get; set; }
		/**
		 * Die Tiles in Form eines 2D-Array des TileSets
		 */
		public Tile[,] tile { get; set; }

		public uint count_y {
			get { return (uint) (height / tileheight); }
		}

		public uint count_x {
			get { return (uint) (width / tilewidth); }
		}

		/**
		 * Konstruktor
		 */
		public TileSet(string filename) {
			Object(filename:filename);
		}
		/**
		 * Dekonstruktor
		 */
		~TileSet() {
			//print("Lösche TileSet Objekt\n");
		}
		/**
		 * Gibt ein gesuchtes Tile anhand seines Index zurueck.
		 *
		 * @param index Index des gesuchten Tiles
		 */
		public Hmwd.Tile getTileFromIndex(uint index)
		requires (index >= 0)
		{
			//print("==GETTILEFROMINDEX==\n");
			uint count = 0;
			bool found = false;
			Hmwd.Tile result = null;
			//print(" index: %u \n", index);
			for (int y=0;(y<count_y&&!found);y++) {
				for (int x=0;(x<count_x&&!found);x++) {
					//print("- ");
					if (count == index) {
						//print("X ");
						found = true;
						result = tile[x,y];
					}
					count++;
				}
				//print("\n");
			}
			//print("\n");
			return result;
		}
		/**
		 * Ladet die Pixel fuer die Tiles.
		 * Zur Zeit alle noch als RegularTile.
		 */
		public void loadTiles(string folder) {
			GdkTexture tex = new GdkTexture.fromFile(folder+source);
			int split_width = (int) tilewidth;
			int split_height = (int) tileheight;
			tile = new Tile[count_x,count_y];
			//int count = 0;
			Pixbuf pxb = tex.pixbuf;
			//print("=====LOADTILES=====\n");
			for(int y = 0; y < count_y; y++) {
				for(int x = 0; x < count_x; x++) {
					Pixbuf split = new Pixbuf(Gdk.Colorspace.RGB, pxb.get_has_alpha(), pxb.get_bits_per_sample(), split_width, split_height);
					//print("y: %i x:%i split_width:%i split_height:%i count %i", y, x, split_width, split_height, count);
					pxb.copy_area((int) split_width*x, (int) split_height*y, (int) split_width, (int) split_height, split, 0, 0);
					tile[x,y] = new RegularTile.fromPixbuf(split);
					//count++;
					//tile[y,x].printValues();
				}
			}
			//print("Tiles zerteilt\n");
		}
		/**
		 * Speichert alle Tiles als Datei.
		 * @param folder Ordner in dem die Bilder gespeichert werden sollen.
		 */
		public void save(string folder = "./tmp/") {
			for (uint y=0;y<count_y;y++) {
				for (uint x=0;x<count_x;x++) {
					tile[x,y].save(folder+name+"_y"+y.to_string()+"_x"+x.to_string()+".png");
					//print("speichere "+folder+name+"_y"+y.to_string()+"_x"+x.to_string()+".png\n");
				}
			}
		}
		/**
		 * Gibt alle Werte Tiles auf der Konsole aus
		 */
		public void printTiles() {
			print("==Tiles==\n");
			for (uint y=0;y<count_y;y++) {
				for (uint x=0;x<count_x;x++) {
					//print("%u ", tile[y,x].type);
					tile[x,y].printValues();
				}
				print("\n");
			}
			print("\nWenn du dies siehst konnten alle Tiles durchlaufen werden\n");
		}
		/**
		 * Gibt alle Werte des TileSets auf der Konsole aus
		 */
		public void printValues() {
			print("name: %s\n", name);
			print("filename: %s\n", filename);
			print("tilewidth: %u\n", tilewidth);
			print("tileheight: %u\n", tileheight);
			print("source: %s\n", source);
			print("trans: %s\n", trans);
			print("width: %u\n", width);
			print("height: %u\n", height);
		}
		/**
		 * Gibt alle Werte und die Tiles des TileSets auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printTiles();
		}
	}
}