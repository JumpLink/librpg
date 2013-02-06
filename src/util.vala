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

/**
 * Library zur Verwaltung von Ressourcen eines 2D-Spiels basierend auf [[http://www.mapeditor.org/|Tiled]].
 */

using Json;

namespace rpg {
	public static int Round(double num) {
		(num > 0) ? (num+= 0.5) : (num+= (-0.5));
		return (int)num;
	}
	/**
	 * Switch boolean from true to false or from false to true.
	 * @param b boolean to switch
	 * @return switched boolean
	 */
	public static bool toggle(bool b) {
		return b ? false : true;
	}
	/**
	 * Gibt eines der uebergebenen TilesetReference's zur gid passenden TilesetReference zurueck.
	 * Dabei wird nach der firstgid gesucht die kleiner ist als die gid
	 * aber groesser ist als alle anderen firstgids
	 * @param tilesetrefs Liste von TilesetReference's in der gesucht werden soll.
	 * @param gid Die zu der das passende Tileset gesucht werden soll.
	 * @return Das gefundene TilesetReference.
	 */
	public static TilesetReference get_tilesetref_from_gid(Gee.List<rpg.TilesetReference> tilesetrefs, uint gid) {	
		rpg.TilesetReference found = tilesetrefs[0];
		foreach (rpg.TilesetReference tsr in tilesetrefs) {
			if ( tsr.firstgid < gid && found.firstgid > tsr.firstgid)
				found = tsr;
		}
		return found;
	}

	/**
	 * compress a buffer TODO TESTME
	 * @param inbuf The buffer to comress
	 * @param format The type of data format ZLIB, GZIP or RAW
	 * @return  Compressed buffer
	 */
	public static uint8[] compress_buffer(uint8[] inbuf, ZlibCompressorFormat format) {
		uint8[] outbuf = new uint8[inbuf.length];

		size_t bytes_read = 0;
		size_t bytes_written = 0;

		ConverterResult res;
		ZlibCompressor compressor = new GLib.ZlibCompressor(format);

		try {
			res = compressor.convert (inbuf, outbuf, ConverterFlags.INPUT_AT_END, out bytes_read, out bytes_written);
		} catch (Error e) {
			error ("can not convert data: %s".printf(e.message));
		}
		outbuf.resize((int) bytes_written);
		print("bytes_written: "+bytes_written.to_string()+"\n");
		print("bytes_read: "+bytes_read.to_string()+"\n");
		
		if (res != ConverterResult.FINISHED)
			error ("wrong converter result: %s".printf(res.to_string()));
		return outbuf;
	}

	/**
	 * decompress a buffer
	 * @param inbuf The buffer to decomress
	 * @param format The type of data format ZLIB, GZIP or RAW
	 * @return  Deompressed buffer
	 */
	public static uint8[] decompress_buffer(uint8[] inbuf, ZlibCompressorFormat format, int size) {
		uint8[] outbuf = new uint8[size];

		size_t bytes_read = 0;
		size_t bytes_written = 0;

		ConverterResult res;
		ZlibDecompressor decompressor = new ZlibDecompressor(format);
		try {
			res = decompressor.convert (inbuf, outbuf, ConverterFlags.INPUT_AT_END, out bytes_read, out bytes_written);
		} catch (Error e) {
			error ("can not convert data: %s".printf(e.message));
		}
		if (res != ConverterResult.FINISHED)
			error ("wrong converter result: %s".printf(res.to_string()));
		return outbuf;
	}

	/**
	 * generates a json string from Json.Node
	 * @param json The Json.Node to parse
	 * @return new json string
	 */
	public static string json_to_string(Json.Node json) {
		size_t length;
		string json_str;

		var gen = new Generator();
		gen.set_root(json);
		json_str = gen.to_data(out length);
		return json_str;
	}

	public class MapJsonParam:GLib.Object {
		/**
		 * If true json includes filename.
		 */
		public bool with_filename { get; construct set; }
		/**
		 * If true json includes orientation.
		 */
		public bool with_orientation { get; construct set; }
		/**
		 * If true json includes verion of format.
		 */
		public bool with_version { get; construct set; }
		/**
		 * If true json includes width and height.
		 */
		public bool with_size { get; construct set; }
		/**
		 * If true json includes tilewidth and tileheight.
		 */
		public bool with_tilesize { get; construct set; }
		/**
		 * If true json includes properties.
		 */
		public bool with_property { get; construct set; }
		/**
		 * If true json includes layers.
		 */
		public bool with_layer { get; construct set; }
		/**
		 * If true json includes the texture of the under- and overlayer as a png base64 string (empty if texture is unset, use merge() to set the texture).
		 */
		public bool with_merged_layer_pixbuf { get; construct set; }
	}
}