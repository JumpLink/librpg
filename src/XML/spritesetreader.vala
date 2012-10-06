using Sxml;
using Gee;
/**
 * MapReader als Hilfe fuer das Laden einer XML-basierten TileSet-Datei.
 * Wir verwenden dafuer das Dateiformat von "Tiled", einem Mapeditor
 * der hier zu finden ist: [[http://www.mapeditor.org/|mapeditor.org]]<<BR>>
 *
 * @see Hmwd.MapManager
 */
public class Hmwd.SpriteSetReader : Sxml.DataReader, Object {

	protected MarkupTokenType current_token {get; set;}
	protected MarkupSourceLocation begin {get; set;}
	protected MarkupSourceLocation end {get; set;}
	protected XmlStreamReader reader {get; set;}

	/**
	 * Path of Data
	 */
	public string path { get; construct set; }

	protected Hmwd.SpriteSet spriteset;

	/**
	 * Anzahl der geparsedten Layer
	 */
	protected int layer_count = 0;

	public SpriteSetReader (string path) {
		Object(path:path);
	}

	public Hmwd.SpriteSet parse(string filename) {	
		spriteset = new Hmwd.SpriteSet.fromPath(path, filename);
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
				spriteset.spritewidth = int.parse(attributes.get (key));
				break;
			case "spriteheight":
				spriteset.spriteheight = int.parse(attributes.get (key));
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
				spritelayer.spritewidth = int.parse(attributes.get (key));
				break;
			case "spriteheight":
				spritelayer.spriteheight = int.parse(attributes.get (key));
				break;
			case "name":
				spritelayer.name =  attributes.get (key);
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
		spritelayer.loadSprites();
		spriteset.spritelayers.add(spritelayer);
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
				spritelayer.trans = attributes.get (key);
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