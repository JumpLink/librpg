using Sxml;
using Gee;
/**
 * MapReader als Hilfe fuer das Laden einer XML-basierten TileSet-Datei.
 * Wir verwenden dafuer das Dateiformat von "Tiled", einem Mapeditor
 * der hier zu finden ist: [[http://www.mapeditor.org/|mapeditor.org]]<<BR>>
 *
 * @see Hmwd.MapManager
 */
public class Hmwd.TileSetReader : Sxml.DataReader, Object {

	protected MarkupTokenType current_token {get; set;}
	protected MarkupSourceLocation begin {get; set;}
	protected MarkupSourceLocation end {get; set;}
	protected XMLStreamReader reader {get; set;}

	/**
	 * Path of Data
	 */
	public string path { get; construct set; }

	protected Hmwd.TileSet tileset;

	public TileSetReader (string path) {
		Object(path:path);
	}

	public Hmwd.TileSet parse(string filename) {	
		tileset = new Hmwd.TileSet(filename);
		reader = new XMLStreamReader (path+filename);
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
				tileset.tilewidth = int.parse(attributes.get (key));
				break;
			case "tileheight":
				tileset.tileheight = int.parse(attributes.get (key));
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
				tileset.trans =  attributes.get (key);
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		next();
		end_element("image");
	}
}