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
using Sxml;
using Gee;
/**
 * Ladet eine XML-basierte Tileset-Datei.
 * Wir verwenden dafuer ein eigenes Dateiformat, welches an das der Maps angelehnt ist.
 *
 * @see rpg.MapReader
 * @see rpg.SpritesetReader
 * @see rpg.TilesetManager
 */
public class rpg.TilesetReader : Sxml.DataReader, Object {

	protected MarkupTokenType current_token {get; set;}
	protected MarkupSourceLocation begin {get; set;}
	protected MarkupSourceLocation end {get; set;}
	protected XmlStreamReader reader {get; set;}

	/**
	 * Path of Data
	 */
	public string path { get; construct set; }

	protected rpg.Tileset tileset;

	public TilesetReader (string path) {
		Object(path:path);
	}

	public rpg.Tileset parse(string filename) {	
		tileset = new rpg.Tileset(filename);
		reader = new XmlStreamReader (path+filename);
		next ();
		while(!is_start_element("tileset")){next ();}
		parse_tileset();
		print("tileset parsed: %s\n", path+filename);
		return tileset;
	}

	protected void parse_tileset() {
		start_element("tileset");
		//print_node();
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "tilewidth":
				tileset.tile_width = int.parse(attributes.get (key));
				break;
			case "tileheight":
				tileset.tile_height = int.parse(attributes.get (key));
				break;
			case "name":
				tileset.name =  attributes.get (key);
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		next();
		parse_image();
		end_element("tileset");
	}
	protected void parse_image() {
		//TODO gibt es mehrere sources?
		start_element("image");
		//print_node();
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "width":
				tileset.width = int.parse(attributes.get (key));
				break;
			case "height":
				tileset.height = int.parse(attributes.get (key));
				break;
			case "source":
				tileset.source =  attributes.get (key);
				break;
			case "trans":
				tileset.transparency =  attributes.get (key);
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		next();
		end_element("image");
	}
}