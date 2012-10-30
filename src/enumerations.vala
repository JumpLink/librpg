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
	 * Benamsung der Farbindizes
	 */
	enum ColorIndex {
		/**
		 * Rot
		 */
		R=0,
		/**
		 * Gruen
		 */
		G=1,
		/**
		 * Blau
		 */
		B=2,
		/**
		 * Alpha
		 */
		A=3 }
	/**
	 * Kantenform eines unterteilten Tiles.
	 */
	public enum EdgeShape {
		FULL,
		OUTER_CORNER,
		INNER_CORNER,
		V_LINE,
		H_LINE
	}
	/**
	 * Ausrichtung einer Entitaet.
	 */
	public enum Direction {
		/**
		 * Noerdliche (oben) Richtung.
		 */
		NORTH=0,
		/**
		 * Oestliche (echts) Richtung.
		 */
		EAST=1,
		/**
		 * Suedliche (unten) Richtung.
		 */
		SOUTH=2,
		/**
		 * Westliche (links) Richtung.
		 */
		WEST=3;

		public string to_string () {
			switch (this) {
				case rpg.Direction.NORTH:
					return "north";
				case rpg.Direction.EAST:
					return "east";
				case rpg.Direction.WEST:
					return "west";
				case rpg.Direction.SOUTH:
					return "south";
				default:
					assert_not_reached();
			}
		}
		public static Direction parse (string str) {
			switch (str) {
				case "north":
					return rpg.Direction.NORTH;
				case "east":
					return rpg.Direction.EAST;
				case "west":
					return rpg.Direction.WEST;
				case "south":
					return rpg.Direction.SOUTH;
				default:
					assert_not_reached();
			}
		}
	}
	/**
	 * Art einer Ernte.
	 */
	public enum CropType {
		/**
		 * nichts
		 */
		EMPTY_CROP=0,
		/**
		 * Grass
		 */
		GRASS=1,
		/**
		 * Kartoffel
		 */
		POTATO=2
	}
	/**
	 * Typ fuer Tiles, beschreibt logische Eigenschaften.
	 */
	public enum TileType {
		/**
		 * Typ fuer Tiles die, nicht gezeichnet werden, bzw. gar nicht existieren.
		 */
		NO_TILE=0,
		/**
		 * Typ fuer Tiles ohne besondere Eigenschaften.
		 */
		EMPTY_TILE=1,
		/**
		 * Typ fuer Tiles, die bepflanzt werden koennen.
		 */
		PLANTABLE=2,
		/**
		 * Typ fuer Tiles, die bepflanzt sind.
		 */
		PLANT=3,
		/**
		 * Typ fuer Tiles, die mit grass bewachsen sind.
		 */
		GRASS=4,
		/**
		 * Typ fuer Tiles, die von NPCs begehbar sind.
		 */
		PATH=5,
		/**
		 * Typ fuer Tiles, die von einem Gebaeude besetzt sind.
		 */
		BUILDING=6,
		/**
		 * Typ fuer Tiles, die von einem Felsstein besetzt sind.
		 */
		ROCK=7,
		/**
		 * Typ fuer Tiles, die von einem Baumstumpf besetzt sind.
		 */
		WOOD=8,
		/**
		 * Typ fuer Tiles, die von einem Gewaesser besetzt sind.
		 */
		WATER=9
	}
	/**
	 * SpriteLayerTypes fuer SpriteLayer, beschreibt die Art des Layers.
	 */
	public enum SpriteLayerType {
		/**
		 * Basistyp, die Grundlage eines Sprites
		 */
		BASE=0,
		/**
		 * Itemtyp, Erweiterungen des Sprites, z.B. Klamotten.
		 */
		ITEM=1;

		public static SpriteLayerType parse (string str) {
			switch (str) {
				case "item":
					return rpg.SpriteLayerType.ITEM;
				case "base":
				default:
					return rpg.SpriteLayerType.BASE;
			}
		}
	}
	/**
	 * Wird angewendet wenn eine Textur/Grafik gespiegelt dargestellt werden soll.
	 */
	public enum Mirror {
		NONE,
		VERTICAL,
		HORIZONTAL;

		public string to_string () {
			switch (this) {
				case rpg.Mirror.VERTICAL:
					return "vertical";
				case  rpg.Mirror.HORIZONTAL:
					return "horizontal";
				case rpg.Mirror.NONE:
					return "none";
				default:
					assert_not_reached();
			}
		}

		public static Mirror parse (string str) {
			switch (str) {
				case "vertical":
				case "VERTICAL":
					return rpg.Mirror.VERTICAL;
				case "horizontal":
				case "HORIZONTAL":
					return rpg.Mirror.HORIZONTAL;
				case "none":
				case "NONE":
					return rpg.Mirror.NONE;
				default:
					assert_not_reached();
			}
		}
	}
	/**
	 * Colorspace einer Textur / eines Pixelbuffers / einer Grafik
	 */
	public enum Colorspace {
		RGB,
		RGBA;
		// public GLenum to_opengl () {
		// 	switch (this) {
		// 		case rpg.Colorspace.RGB:
		// 			return GL.GL_RGB;
		// 		case  rpg.Colorspace.RGBA:
		// 			return GL.GL_RGBA;
		// 		default:
		// 			assert_not_reached();
		// 	}
		// }
		public string to_string() {
			switch (this) {
				case rpg.Colorspace.RGB:
					return "rgb";
				case  rpg.Colorspace.RGBA:
					return "rgba";
				default:
					assert_not_reached();
			}
		}
		public static rpg.Colorspace fromGdkPixbuf (Gdk.Pixbuf pixbuf) {
			if(pixbuf.colorspace == Gdk.Colorspace.RGB) {
				if (pixbuf.has_alpha) {
					return rpg.Colorspace.RGBA;
				} else {
					return rpg.Colorspace.RGB;
				}
			} else {
				assert_not_reached();
			}
		}
		public int to_channel () {
			switch (this) {
				case rpg.Colorspace.RGB:
					return 3;
				case  rpg.Colorspace.RGBA:
					return 4;
				default:
					assert_not_reached();
			}
		}
		public bool has_alpha () {
			switch (this) {
				case rpg.Colorspace.RGB:
					return false;
				case  rpg.Colorspace.RGBA:
					return true;
				default:
					assert_not_reached();
			}
		}
	}
	/**
	 * Zur angabe in welcher Hoehe ein Layer gezeichnet werden soll (ueber oder unter dem Player)
	 */
	public enum DrawLevel {
		/**
		 * Objekt wird unter einem anderen gezeichnet.
		 */
		UNDER = 1,
		/**
		 * Keine genaue Angabe darueber ob das Objekt unter oder ueber einem anderen gezeichnet werden soll.
		 */
		NONE = 0,
		/**
		 * Objekt wird ueber einem anderen gezeichnet.
		 */
		OVER = -1;
		/**
		 * parst einen String zu DrawLevel
		 */
		public static DrawLevel parse (string str) {
			switch (str) {
				case "none":
				case "None":
				case "NONE":
					return rpg.DrawLevel.NONE;
				case "over":
				case "Over":
				case "OVER":
					return rpg.DrawLevel.OVER;
				case "under":
				case "Under":
				case "UNDER":
					return rpg.DrawLevel.UNDER;
				default:
					assert_not_reached();
			}
		}
	}
	/**
	 * View Engine die verwendet wird / werden soll.
	 */
	public enum ViewEngine {
		SDL,
		OPENGL,
		CLUTTER,
		GTK_CLUTTER;
	}
	/**
	 * Jahreszeit.
	 */
	public enum Season {
		SPRING = 0,
		SUMMER = 1,
		FALL = 2,
		WINTER = 3;
	}
}