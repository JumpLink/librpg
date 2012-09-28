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

/*
 * Various operations with libxml2: Parsing and creating an XML file
 */

using Xml;
using Xml.XPath;
using Gee;

using Hmwd;
namespace Hmwd {
    /**
     * Klasse fuer XML-Operationen
     */
    class XML : GLib.Object {
        // Line indentation
        protected int indent = 0;
		/**
		 * Hilsvariable mit Dateityp von libxml2, fuer weitere Informationen siehe
		 * [[http://xmlsoft.org/html/libxml-tree.html#xmlDoc|xmlsoft.org]]
		 * und [[http://valadoc.org/libxml-2.0/Xml.Doc.html|valadoc.org]]
		 */
		protected Xml.Doc* doc;
		/**
		 * Hilsvariable mit Dateityp von libxml2, fuer weitere Informationen siehe
		 * [[http://xmlsoft.org/html/libxml-xpath.html#xmlXPathContext|xmlsoft.org]]
		 * und [[http://valadoc.org/libxml-2.0/Xml.XPath.Context.html|valadoc.org]]
		 */
		protected Context ctx;
		/**
		 * Speichert den path der zu bearbeitenden Mapdatei
		 */
		public string path { get; construct set; }
		/**
		 * Konstrukter
		 */
		public XML(string path) {
			GLib.Object(path:path);
		}
		construct {
			print("Erstelle Xml-Objekt\n");
			// Initialisation, not instantiation since the parser is a static class
			Parser.init ();
			//this.path = path;
			doc = Parser.parse_file (path);
			if(doc==null) printerr("failed to read the .xml file\n");

			ctx = new Context(doc);
			if(ctx==null) printerr("failed to create the xpath context\n");
		}
		/**
		 * Dekonstrukter
		 */
		~XML() {
			print("loesche XML-Objekt\n");
			// Do the parser cleanup to free the used memory
			//delete doc;
			Parser.cleanup ();
		}

		/**
		* Gibt einen Wert der XML aus
		* @param node Nodename
		* @param content Wert vom Nodename
		* @param token Wert der der Ausgabe vorangestellt wird
		*/
		protected void print_indent (string node, string content, char token = '+') {
			string indent = string.nfill (this.indent * 2, ' ');
			print ("%s%c%s: %s\n", indent, token, node, content);
		}
		/**
		 * In dieser Methode werden die Tile-Werte aus der XML gelesen und als return zurueck gegeben.
		 * In der XML sind es jeweils nur ein propertie mit dem namen "gid" des entsprechenden tile-Tags.
		 * Eine Karte kann mehrere Tiles beinhalten, daher wird mit einem Array von Tiles gearbeitet.
		 *
		 * @return Array mit den geparsten Tiles
		 */
		protected Gee.List loadPropertiesOfSameNodes (string eval_expression) {
			Gee.List<Gee.HashMap<string, string>> properties = new Gee.ArrayList<Gee.HashMap<string, string>>();
			Gee.HashMap<string, string> propertie;

			Xml.Node* node;
			//XPath-Expression ausfuehren
			unowned Xml.XPath.Object obj = ctx.eval_expression(eval_expression);
			if(obj==null) printerr("failed to evaluate xpath\n");
			//Alle Tiles des XPath-Expression-Ergebnisses durchlaufen
			for (int i=0;(obj.nodesetval != null && obj.nodesetval->item(i) != null);i++) {
				//Holt sich das Tile
				node = obj.nodesetval->item(i);
				propertie = loadProperties(node);
				properties.add(propertie);
			}
			return properties;
		}
		/**
		 * Allgemeine Hilfsmethode fuer das Parsen von properties eines Knotens.
		 *
		 * @param node der zu parsenden properties.
		 * @return Liste mit den geparsten properties, key ist der propertiename und value ist der propertievalue.
		 */
		protected Gee.HashMap<string, string> loadProperties(Xml.Node* node) {
			Xml.Attr* attr = node->properties;
			Gee.HashMap<string, string> properties = new Gee.HashMap<string, string>();
			//print("loadProperties - ");
			while ( attr != null ) {
				//print("Attribute: \tname: %s\tvalue: %s\n", attr->name, attr->children->content);
				properties.set(attr->name, attr->children->content);
				attr = attr->next;
			}
			return properties;
		}
		/**
		 * Allgemeine Hilfsmethode fuer das ausfuhren einer XPath-Expression.
		 *
		 * @param expression Auszufuehrende Expression als String.
		 * @return node mit dem Ergebniss der Expression.
		 */
	    protected Xml.Node* evalExpression (string expression ) {
	        unowned Xml.XPath.Object obj = ctx.eval_expression(expression);
	        if(obj==null) printerr("failed to evaluate xpath\n");

	        Xml.Node* node = null;
	        if ( obj.nodesetval != null && obj.nodesetval->item(0) != null ) {
	            node = obj.nodesetval->item(0);
	            //print("Found the node we want\n");
	        } else {
	            printerr("failed to find the expected node\n");
	        }
	        return node;
	    }
	}
	/**
	 * Unterklasse zum Spiechern von Dialogbaeumen.
	 */
	class DTX : Hmwd.XML {
		public DTX (string path) {
			base (path);
		}

		//public DialogTree loadDialogTree () {

		//}
	}
	/**
	 * Klasse fuer XML-Operationen
	 */
	class TSX : Hmwd.XML {
		public TSX(string path) {
			base(path);
		}
		~TSX() {
			//base(path);
		}
		/**
		 * Läd die Werte einer TileSet-XML.tsx
		 * 
		 * @param folder Ordner in dem sich die auszulesende XML befindet
		 * @param filename Dateiname der auszulesenden XML
		 */
	    public void getDataFromFile (string folder, string filename, out string name, out uint tilewidth, out uint tileheight, out string source, out string trans, out uint width, out uint height) {
	    	//print("\tFuehre getTileSetDataFromFile aus\n");
	    	Gee.HashMap<string, string> tileset_global_properties = new Gee.HashMap<string, string>();
	    	Gee.HashMap<string, string> tileset_image_properties = new Gee.HashMap<string, string>();
			
	    	parse_file (folder+filename, tileset_global_properties, tileset_image_properties);
	    	
	    	// Zuweisung der geparsten Werte
	    	name = (string) tileset_global_properties.get ("name");
	    	tilewidth = int.parse(tileset_global_properties.get ("tilewidth"));
	    	tileheight = int.parse(tileset_global_properties.get ("tileheight"));
	    	
	    	source = (string) tileset_image_properties.get ("source");
	    	trans = (string) tileset_image_properties.get ("trans");
	    	width = int.parse(tileset_image_properties.get ("width"));
	    	height = int.parse(tileset_image_properties.get ("height"));
	    }

		/**
		 * Hilfsfunktion welche eine XML auslesen kann
		 *
		 * @return true bei Fehler, sonst false
		 */
	    private bool parse_file (string path, Gee.HashMap<string, string> tileset_global_properties, Gee.HashMap<string, string> tileset_image_properties) {
	    	//print("\tbeginne Datei zu parsen\n");

	        // Get the root node. notice the dereferencing operator -> instead of .
	        Xml.Node* root = doc->get_root_element ();
	        if (root == null) {
	            // Free the document manually before returning
	            delete doc;
	            print ("The xml file '%s' is empty", path);
	            return true;
	        }

	        print_indent ("XML document", path, '-');

	        // Print the root node's name
	        print_indent ("Root node", root->name);
	        
	    	// Prüfe ob root bereits eines der gesuchten Nodes beinhaltet
			switch (root->name) {
				case "tileset":
					//print("\t%s in root gefunden\n",root->name);
					parse_properties (root, tileset_global_properties);
				break;
				case "image":
					//print("\t%s in root gefunden\n",root->name);
					parse_properties (root, tileset_image_properties);
				break;
				default:
					printerr("Keine passende Node gefunden!\n");
				break;
			}
	        
	        // Let's parse those nodes
	        parse_node (root, tileset_global_properties, tileset_image_properties);

	        // Free the document
	        delete doc;
	        return true;
	    }

		/**
		 * 
		 */
	    private void parse_node (Xml.Node* node, Gee.HashMap<string, string> tileset_global_properties, Gee.HashMap<string, string> tileset_image_properties) {
	    	//print("\tbeginne Node zu parsen\n");
	        this.indent++;
	        // Loop over the passed node's children
	        for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {
	            // Spaces between tags are also nodes, discard them
	            if (iter->type != ElementType.ELEMENT_NODE) {
	                continue;
	            }

	            // Get the node's name
	            string node_name = iter->name;
	            // Get the node's content with <tags> stripped
	            string node_content = iter->get_content ();
	            print_indent (node_name, node_content);
			    
				// Prüfe ob node eines der gesuchten Nodes beinhaltet
				switch (iter->name) {
					case "tileset":
						//print("\t%s in node gefunden\n",iter->name);
						parse_properties (iter, tileset_global_properties);
					break;
					case "image":
						//print("\t%s in node gefunden\n",iter->name);
						parse_properties (iter, tileset_image_properties);
					break;
					default:
						print("\tKeine (weiteren) passende Nodes gefunden!\n");
					break;
				}
	        
	            // Followed by its children nodes
	            parse_node (iter, tileset_global_properties, tileset_image_properties);
	        }
	        this.indent--;
	    }

		/**
		 * 
		 */
	    private void parse_properties (Xml.Node* node, Gee.HashMap<string, string> properties) {
	    	//print("\tbeginne Werte zu parsen\n");
	        // Loop over the passed node's properties (attributes)
	        for (Xml.Attr* prop = node->properties; prop != null; prop = prop->next) {
	            string attr_name = prop->name;
	            // Notice the ->children which points to a Node*
	            // (Attr doesn't feature content)
	            string attr_content = prop->children->content;

				print_indent (attr_name, attr_content, '|');
				properties.set(attr_name, attr_content);
	        }
	    }
	}
	/**
	 * Klasse als Hilfe fuer das Laden einer XML-basierten SpriteSet-Datei.
	 * Wir verwenden dafuer ein eigenes Dateiformat an das der Maps angelehnt.
	 *
	 */
	class SSX : Hmwd.XML {
		string filename; //TODO inkosistent
		string folder; //TODO inkosistent
		/**
		 * Konstrukter der internen XML-Klasse.
		 * Hier wird der Parser initialisiert und die uebergebene Datei vorbereitet.
		 *
		 * @param path Pfadangabe der vorzubereitenden XML-Datei
		 */
		public SSX(string path, string filename) {
			base(path+filename);
			this.filename = filename;
			this.folder = path;
		}
		/**
		 * Dekonstrukter der internen XML-Klasse.
		 * Hier wird der Parser gesaeubert und Variablen wieder freigegeben.
		 */
		~SSX() {
			delete doc;
			Parser.cleanup ();
		}
		/**
		 * In dieser Methode werden die globalen SpriteSetwerte aus der XML gelesen
		 * und als Parameter zurueck gegeben. In der XML sind es die properties des map-Tags
		 *
		 * @param name Des SpriteSets
		 * @param version The SSX format version, generally 1.0.
		 * @param width The spriteset width in sprites.
		 * @param height The spriteset height in sprites.
		 * @param spritewidth The width of a sprite.
		 * @param spriteheight The height of a sprite.
		 */
		public void loadGlobalProperties (out string name, out string version, out uint width, out uint height, out uint spritewidth, out uint spriteheight) {
			//XPath-Expression verarbeiten
			Xml.Node* node = evalExpression("/spriteset");
			//properties des resultats verarbeiten.
			Gee.HashMap<string, string> properties = loadProperties(node);
			//geparsten properties speichern.
			name = (string) properties.get ("name");
			version = (string) properties.get ("version");
			width = int.parse(properties.get ("width"));
			height = int.parse(properties.get ("height"));
			spritewidth = int.parse(properties.get ("spritewidth"));
			spriteheight = int.parse(properties.get ("spriteheight"));
		}
		/**
		 * In dieser Methode werden die Layer-Werte aus der XML gelesen
		 * und als return zurueck gegeben.
		 * In der XML sind dies die properties und die Kinder des layer-Tags.
		 * Eine Karte kann mehrere Layer beinhalten, daher wird mit einer Liste von Layern gearbeitet.
		 *
		 * @return Gee.ArrayList vom Typ Hmwd.Layer aller Layer
		 * @see Hmwd.Layer
		 * @see Gee.ArrayList
		 */
		public Gee.List<Animation> loadAnimations (uint width, uint height) {
			print("loadAnimations\n");
			Gee.List<Animation> animation = new Gee.ArrayList<Animation>();
			Gee.List<AnimationData> ani_datas;
			string name;
			string direction;
			string repeat;
			//XPath-Expression ausfuehren
			unowned Xml.XPath.Object obj = ctx.eval_expression("/spriteset/animation");
			if(obj==null) printerr("failed to evaluate xpath\n");
			//Durchläuft alle Nodes, also alle resultierten Layer-Tags
			for (int i=0;(obj.nodesetval != null && obj.nodesetval->item(i) != null);i++) {
				//Holt entsprechenden Layer
				Xml.Node* node = obj.nodesetval->item(i);
				//Parst dessen properties
				Gee.HashMap<string, string> properties = loadProperties(node);
				//Speichert die geparsten properties
				name = (string) properties.get ("name");
				direction = (string) properties.get ("direction");
				repeat = (string) properties.get ("repeat");

				ani_datas = loadAnimationData(i, width, height);

				animation.add( new Animation(name, bool.parse(repeat), Hmwd.Direction.parse(direction), ani_datas) );
			}
			return animation;
		}
		/**
		 * In dieser Methode werden die Tile-Werte aus der XML gelesen und als return zurueck gegeben.
		 * In der XML sind es jeweils nur ein propertie mit dem namen "gid" des entsprechenden tile-Tags.
		 * Eine Karte kann mehrere Tiles beinhalten, daher wird mit einem Array von Tiles gearbeitet.
		 *
		 * @return Array mit den geparsten Tiles
		 */
		public Gee.List<AnimationData> loadAnimationData (uint animation_number, uint width, uint height) {
			int id = 0;
			string mirror = null;
			Gee.List<AnimationData> res = new Gee.ArrayList<AnimationData>();
			AnimationData tmp_ani_data = new AnimationData();
			//tmp_ani_data.x = 0;
			//tmp_ani_data.y = 0;
			//tmp_ani_data.mirror = Hmwd.Mirror.NONE;
			string eval_expression = "/spriteset/animation["+(animation_number+1).to_string()+"]/data/sprite";
			Gee.List<Gee.HashMap<string, string>> properties = loadPropertiesOfSameNodes (eval_expression);
			int count = 0;
			foreach (Gee.HashMap<string, string> propertie in properties) {
				tmp_ani_data = new AnimationData();
				id = int.parse(propertie.get ("gid")) - 1;
				mirror = (string) propertie.get ("mirror");
				tmp_ani_data.mirror = Hmwd.Mirror.parse(mirror);

				if (id >= 0) {
					tmp_ani_data.x = (int)(id%width);
					tmp_ani_data.y = (int)(id/width);

				}
				res.add(tmp_ani_data);
				count++;
			}
			return res;
		}
		/**
		 * In dieser Methode werden die Layer-Werte aus der XML gelesen
		 * und als return zurueck gegeben.
		 * In der XML sind dies die properties und die Kinder des layer-Tags.
		 * Eine Karte kann mehrere Layer beinhalten, daher wird mit einer Liste von Layern gearbeitet.
		 *
		 * @return Gee.ArrayList vom Typ Hmwd.Layer aller Layer
		 * @see Hmwd.Layer
		 * @see Gee.ArrayList
		 */
		public Gee.List<SpriteLayer> loadLayers () {
			Gee.List<SpriteLayer> res = new Gee.ArrayList<SpriteLayer>();
			SpriteLayer tmp_spritelayer;
			Xml.Node* node;
			Gee.HashMap<string, string> properties;
			string name;
			string tile_type_str;
			SpriteLayerType tile_type;
			string image_filename;
			string trans;
			uint width;
			uint height;
			uint spritewidth;
			uint spriteheight;
			//XPath-Expression ausfuehren
			unowned Xml.XPath.Object obj = ctx.eval_expression("/spriteset/layer");
			if(obj==null) printerr("failed to evaluate xpath\n");
			//Durchläuft alle Nodes, also alle resultierten Layer-Tags
			for (int i=0;(obj.nodesetval != null && obj.nodesetval->item(i) != null);i++) {
				//print("LadeLayer\n");
				node = obj.nodesetval->item(i);
				properties = loadProperties(node);
				name = (string) properties.get ("name");
				tile_type_str = (string) properties.get ("type");
				width = int.parse(properties.get ("width"));
				height = int.parse(properties.get ("height"));
				spritewidth = int.parse(properties.get ("spritewidth"));
				spriteheight = int.parse(properties.get ("spriteheight"));
				loadLayerImage(i, out image_filename, out trans);
				if(tile_type_str == null || tile_type_str.length < 0){
					printerr("xml: sprite: loadLayers: tile_type is null, using base-type\n");
					tile_type = Hmwd.SpriteLayerType.BASE;
				} else {
					tile_type = Hmwd.SpriteLayerType.parse(tile_type_str);
				}
				
				tmp_spritelayer = new SpriteLayer(folder+image_filename, i, name, image_filename, tile_type, trans, width, height, spritewidth, spriteheight);
				res.add(tmp_spritelayer);
			}
			return res;
		}
		/**
		 * In dieser Methode werden die globalen SpriteSetwerte aus der XML gelesen
		 * und als Parameter zurueck gegeben. In der XML sind es die properties des map-Tags
		 *
		 * @param image_filename Des Bildes welches der Layer verwendet.
		 * @param trans Transparente Farbe im Layer
		 * //@param width The Image width in sprites.
		 * //@param height The spriteset height in sprites.
		 */
		public void loadLayerImage (int spritelayer_number, out string image_filename, out string trans) {
			//print("loadLayerImage\n");
			//XPath-Expression verarbeiten
			Xml.Node* node = evalExpression("/spriteset/layer["+(spritelayer_number+1).to_string()+"]/image");
			//properties des resultats verarbeiten.
			Gee.HashMap<string, string> properties = loadProperties(node);
			//geparsten properties speichern.
			image_filename = (string) properties.get ("source");
			trans = (string) properties.get ("trans");
			//width = int.parse(properties.get ("width"));
			//height = int.parse(properties.get ("height"));
		}
	}
}