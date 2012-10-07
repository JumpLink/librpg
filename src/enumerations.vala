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
				case Hmwd.Direction.NORTH:
					return "north";
				case Hmwd.Direction.EAST:
					return "east";
				case Hmwd.Direction.WEST:
					return "west";
				case Hmwd.Direction.SOUTH:
					return "south";
				default:
					assert_not_reached();
			}
		}
		public static Direction parse (string str) {
			switch (str) {
				case "north":
					return Hmwd.Direction.NORTH;
				case "east":
					return Hmwd.Direction.EAST;
				case "west":
					return Hmwd.Direction.WEST;
				case "south":
					return Hmwd.Direction.SOUTH;
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
		EMPTY_CROP,
		/**
		 * Grass
		 */
		GRASS,
		/**
		 * Kartoffel
		 */
		POTATO
	}
	/**
	 * Typ fuer Tiles, beschreibt logische Eigenschaften.
	 */
	public enum TileType {
		/**
		 * Typ fuer Tiles die, nicht gezeichnet werden, bzw. gar nicht existieren.
		 */
		NO_TILE,
		/**
		 * Typ fuer Tiles ohne besondere Eigenschaften.
		 */
		EMPTY_TILE,
		/**
		 * Typ fuer Tiles, die bepflanzt werden koennen.
		 */
		PLANTABLE,
		/**
		 * Typ fuer Tiles, die bepflanzt sind.
		 */
		PLANT,
		/**
		 * Typ fuer Tiles, die mit grass bewachsen sind.
		 */
		GRASS,
		/**
		 * Typ fuer Tiles, die von NPCs begehbar sind.
		 */
		PATH,
		/**
		 * Typ fuer Tiles, die von einem Gebaeude besetzt sind.
		 */
		BUILDING,
		/**
		 * Typ fuer Tiles, die von einem Felsstein besetzt sind.
		 */
		ROCK,
		/**
		 * Typ fuer Tiles, die von einem Baumstumpf besetzt sind.
		 */
		WOOD,
		/**
		 * Typ fuer Tiles, die von einem Gewaesser besetzt sind.
		 */
		WATER
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
					return Hmwd.SpriteLayerType.ITEM;
				case "base":
				default:
					return Hmwd.SpriteLayerType.BASE;
			}
		}
	}

	public enum Mirror {
		NONE,
		VERTICAL,
		HORIZONTAL;

		public string to_string () {
			switch (this) {
				case Hmwd.Mirror.VERTICAL:
					return "vertical";
				case  Hmwd.Mirror.HORIZONTAL:
					return "horizontal";
				case Hmwd.Mirror.NONE:
					return "none";
				default:
					assert_not_reached();
			}
		}

		public static Mirror parse (string str) {
			switch (str) {
				case "vertical":
				case "VERTICAL":
					return Hmwd.Mirror.VERTICAL;
				case "horizontal":
				case "HORIZONTAL":
					return Hmwd.Mirror.HORIZONTAL;
				case "none":
				case "NONE":
					return Hmwd.Mirror.NONE;
				default:
					assert_not_reached();
			}
		}
	}
	public enum Colorspace {
		RGB,
		RGBA;
		// public GLenum to_opengl () {
		// 	switch (this) {
		// 		case Hmwd.Colorspace.RGB:
		// 			return GL.GL_RGB;
		// 		case  Hmwd.Colorspace.RGBA:
		// 			return GL.GL_RGBA;
		// 		default:
		// 			assert_not_reached();
		// 	}
		// }
		public string to_string() {
			switch (this) {
				case Hmwd.Colorspace.RGB:
					return "rgb";
				case  Hmwd.Colorspace.RGBA:
					return "rgba";
				default:
					assert_not_reached();
			}
		}
		public static Hmwd.Colorspace fromGdkPixbuf (Gdk.Pixbuf pixbuf) {
			if(pixbuf.colorspace == Gdk.Colorspace.RGB) {
				if (pixbuf.has_alpha) {
					return Hmwd.Colorspace.RGBA;
				} else {
					return Hmwd.Colorspace.RGB;
				}
			} else {
				assert_not_reached();
			}
		}
		public int to_channel () {
			switch (this) {
				case Hmwd.Colorspace.RGB:
					return 3;
				case  Hmwd.Colorspace.RGBA:
					return 4;
				default:
					assert_not_reached();
			}
		}
		public bool has_alpha () {
			switch (this) {
				case Hmwd.Colorspace.RGB:
					return false;
				case  Hmwd.Colorspace.RGBA:
					return true;
				default:
					assert_not_reached();
			}
		}
	}
	public enum DrawLevel {
		/**
		 * Objekt wird unter einem anderen gezeichnet.
		 */
		UNDER = 1,
		/**
		 * Keine genaue Angabe darueber ob das Objekt unter oder ueber einem anderen gezeichnet werden soll.
		 */
		SAME = 0,
		/**
		 * Objekt wird ueber einem anderen gezeichnet.
		 */
		OVER = -1;
		/**
		 * parst einen String zu DrawLevel
		 */
		public static DrawLevel parse (string str) {
			switch (str) {
				case "same":
				case "Same":
				case "SAME":
					return Hmwd.DrawLevel.SAME;
				case "over":
				case "Over":
				case "OVER":
					return Hmwd.DrawLevel.OVER;
				case "under":
				case "Under":
				case "UNDER":
					return Hmwd.DrawLevel.UNDER;
				default:
					assert_not_reached();
			}
		}
	}
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