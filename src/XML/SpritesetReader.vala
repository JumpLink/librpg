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
 */
using Sxml;
using Gee;
/**
 * Ladet eine XML-basierte Spriteset-Datei.
 * Wir verwenden dafuer ein eigenes Dateiformat, welches an das der Maps angelehnt ist.
 *
 * @see Hmwd.MapReader
 * @see Hmwd.TilesetReader
 * @see Hmwd.SpritesetManager
 */
public class Hmwd.SpritesetReader : Sxml.DataReader, Object {

	protected MarkupTokenType current_token {get; set;}
	protected MarkupSourceLocation begin {get; set;}
	protected MarkupSourceLocation end {get; set;}
	protected XmlStreamReader reader {get; set;}

	/**
	 * Path of Data
	 */
	public string path { get; construct set; }

	protected Hmwd.Spriteset spriteset;

	/**
	 * Anzahl der geparsedten Layer
	 */
	protected int layer_count = 0;

	public SpritesetReader (string path) {
		Object(path:path);
	}

	public Hmwd.Spriteset parse(string filename) {	
		spriteset = new Hmwd.Spriteset.from_path(path, filename);
		reader = new XmlStreamReader (path+filename);
		next ();
		while(!is_start_element("spriteset")){next ();}
		parse_spriteset();
		print("spriteset parsed: %s\n", path+filename);
		return spriteset;
	}

	protected void parse_spriteset() {
		start_element("spriteset");
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "width":
				spriteset.width = int.parse(attributes.get (key));
				break;
			case "height":
				spriteset.height = int.parse(attributes.get (key));
				break;
			case "spritewidth":
				spriteset.sprite_width = int.parse(attributes.get (key));
				break;
			case "spriteheight":
				spriteset.sprite_height = int.parse(attributes.get (key));
				break;
			case "version":
				spriteset.version = attributes.get (key);
				break;
			case "name":
				spriteset.name = attributes.get (key);
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		next();
		while(is_start_element("layer")) {
			parse_layer();
		}
		while(is_start_element("animation")) {
			spriteset.animations.add(parse_animation());
		}
		end_element("spriteset");
	}
	protected void parse_layer() {
		start_element("layer");
		SpriteLayer spritelayer = new SpriteLayer();
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "width":
				spritelayer.width = int.parse(attributes.get (key));
				break;
			case "height":
				spritelayer.height = int.parse(attributes.get (key));
				break;
			case "spritewidth":
				spritelayer.sprite_width = int.parse(attributes.get (key));
				break;
			case "spriteheight":
				spritelayer.sprite_height = int.parse(attributes.get (key));
				break;
			case "name":
				spritelayer.name = attributes.get (key);
				break;
			case "type":
				spritelayer.sprite_layer_type = SpriteLayerType.parse( attributes.get (key));
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		spritelayer.number = layer_count;
		layer_count++;
		next();
		parse_image(ref spritelayer);
		
		spritelayer.folder = spriteset.folder; //TODO workaround
		spritelayer.split();
		spriteset.sprite_layers.add(spritelayer);
		end_element("layer");
	}
	protected Hmwd.Animation parse_animation() {
		start_element("animation");
		Hmwd.Animation ani = new Hmwd.Animation();
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "name":
				ani.name =  attributes.get (key);
				break;
			case "direction":
				ani.direction = Hmwd.Direction.parse(attributes.get (key));
				break;
			case "repeat":
				ani.repeat = bool.parse(attributes.get (key));
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		
		next();
		ani.animationdata = parse_data();
		end_element("animation");
		return ani;
	}
	protected void parse_image(ref SpriteLayer spritelayer) {
		start_element("image");
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "source":
				spritelayer.image_filename = attributes.get (key);
				break;
			case "trans":
				spritelayer.transparency = attributes.get (key);
				break;
			case "width":
				//spritelayer.width = int.parse(attributes.get (key));
				break;
			case "height":
				//spritelayer.height = int.parse(attributes.get (key));
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		next();
		end_element("image");
	}
	protected Gee.List<AnimationData> parse_data() {
		start_element("data");
		Gee.List<AnimationData> datas = new Gee.ArrayList<AnimationData>();
		next();
		while(is_start_element("sprite")) {
			datas.add(parse_sprite());
		}
		end_element("data");
		return datas;
	}
	protected AnimationData parse_sprite() {
		start_element("sprite");
		AnimationData sprite = new AnimationData();
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "gid":
				int id = int.parse(attributes.get (key)) - 1;
				if (id >= 0) {
					sprite.x = (int)(id%spriteset.width);
					sprite.y = (int)(id/spriteset.width);
				}
				break;
			case "mirror":
				sprite.mirror = Hmwd.Mirror.parse(attributes.get (key));
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		
		next();
		end_element("sprite");
		return sprite;
	}
}