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
using Hmwd;
namespace Hmwd {
	/**
	 * Klasse fuer Maplayer.
	 */
	public class Layer : Object {
		/**
		 * Name des Layers
		 */
		public string name { get; set; }
		/**
		 * z-offset zum Zeichnen dieses Layers
		 */
		public double zoff { get; set; }
		/**
		 * Breite des Layers
		 */
		public uint width { get; set; }
		/**
		 * Hoehe des Layers
		 */
		public uint height { get; set; }
		/**
		 * Tiles des Layers
		 */
		public Hmwd.Tile[,] tiles { get; set; }
		/**
		 * Zur ueberpruefung ob dieser Layer Kollision erzeugt.
		 */
		public bool collision { get; set; }

		/**
		 * Konstruktor
		 */
		public Layer() {
			Object(name : "new Layer", zoff : 0, width : 10, height : 10, collision:false);
		}

		construct {
			// if(tiles != null) {
			// 	print("create Tile Array\n");
			// 	this.tiles = new Hmwd.Tile[width, height];
			// } else {
			// 	print("Tile Array allrady exist\n");
			// }
			
		}

		public Hmwd.Tile? getTileXY(uint x, uint y) {
			return tiles[x,y];
		}

		/**
		 * Konstruktor mit Groessenangaben
		 */
		public Layer.sized(int width, int height) {
			Object(name:"new Layer", width:width, height:height, zoff:0);
		}

		/**
		 * Konstruktor mit allen Werten non-default
		 */
		public Layer.all(string name, double zoff, bool collision, int width, int height) {
			//this.tiles = tiles; //TODO make this work in node-gir
			Object(name:name, zoff:zoff, width:width, height:height, collision:collision);
		}
		/*
		 * TODO OLE
		 */
		public void calcEdges () {
			TileType[] neighbours = new TileType[8];
			for (uint r = 0; r < height; ++r)
				for (uint c = 0; c < width; ++c) {
					neighbours[0] = ( c != 0 ) ? tiles[c - 1, r].tile_type : TileType.EMPTY_TILE;
					neighbours[1] = (c != 0 && r != 0 ) ? tiles[c - 1, r - 1].tile_type : TileType.EMPTY_TILE;
					neighbours[2] = ( r != 0 ) ? tiles[c, r - 1].tile_type : TileType.EMPTY_TILE;
					neighbours[3] = ( r != 0 && c < width ) ? tiles[c + 1, r - 1].tile_type : TileType.EMPTY_TILE;
					neighbours[4] = ( c < width ) ? tiles[c + 1, r].tile_type : TileType.EMPTY_TILE;
					neighbours[5] = ( r < height && c < width ) ? tiles[c + 1, r + 1].tile_type : TileType.EMPTY_TILE;
					neighbours[6] = ( r < height ) ? tiles[c, r + 1].tile_type : TileType.EMPTY_TILE;
					neighbours[7] = ( r < height && c != 0 ) ? tiles[c - 1, r + 1].tile_type : TileType.EMPTY_TILE;
					tiles[c, r].calcEdges(neighbours);
				}
		}
		/**
		 * Gibt alle Werte des Layers (bis auf die Tiles) auf der Konsole aus
		 */
		public void printValues() {
			print("==Layer==\n");
			print("name: %s\n", name);
			print("zoff: %f\n", zoff);
			print("width: %u\n", width);
			print("height: %u\n", height);
			print("collision: %s\n", collision.to_string());
		}
		/**
		 * Gibt die Tiles des Layers auf der Konsole aus
		 */
		public void printTiles() {
			print("==Tiles==\n");
			for (int y=0;y<height;y++) {
				for (int x=0;x<width;x++) {
					print("%u ", tiles[x,y].tile_type);
				}
				print("\n");
			}
		}
		/**
		 * Gibt alle Werte des Layers und dessen Tiles auf der Konsole aus
		 */
		public void printAll() {
			printValues();
			printTiles();
		}
	}
}