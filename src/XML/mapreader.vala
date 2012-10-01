using Sxml;
using Gee;
using ZLib;
/**
 * MapReader als Hilfe fuer das Laden einer XML-basierten Map-Datei.
 * Wir verwenden dafuer das Dateiformat von "Tiled", einem Mapeditor
 * der hier zu finden ist: [[http://www.mapeditor.org/|mapeditor.org]]<<BR>>
 * Derzeit werden noch keine komprimierten Dateien unterstuetzt.
 * Die zu ladenden Maps werden fuer gewoehnlich von der Klasse Hmwd.MapManager
 * uebernommen.<<BR>>
 * Die definitionen des Kartenformats sind [[https://github.com/bjorn/tiled/wiki/TMX-Map-Format|hier]] zu finden.
 *
 * @see Hmwd.MapManager
 */

// Bits on the far end of the 32-bit global tile ID are used for tile flags
const uint64 FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
const uint64 FLIPPED_VERTICALLY_FLAG   = 0x40000000;
const uint64 FLIPPED_DIAGONALLY_FLAG   = 0x20000000;

public class Hmwd.MapReader : Hmwd.DataReader, Object {

	protected MarkupTokenType current_token {get; set;}
	protected MarkupSourceLocation begin {get; set;}
	protected MarkupSourceLocation end {get; set;}
	protected ErrorReporter reporter {get; set;}
	protected MarkupReader reader {get; set;}

	protected Hmwd.Map map;
	/**
	 * Path der Mapdateien
	 */
	public string path { get; construct set; }

	/**
	 * Anzahl der geparsedten Layer
	 */
	protected int layer_count = 0;

	public Hmwd.TileSetManager tilesetmanager { get; construct set; } //TODO remove?

	public MapReader (string path, Hmwd.TileSetManager tilesetmanager) {
		Object(path:path, tilesetmanager:tilesetmanager);
	}

	construct {
		reporter = new ErrorReporter();
	}

	public void print_properties() {
		print("properties: ");
		foreach (var key in map.properties.keys) {
			print("%s:%s\n", key, map.properties.get (key));
		}
		print("\n\n");
	}

	public Hmwd.Map parse(string filename) {	
		map = new Hmwd.Map(filename, tilesetmanager);
		reader = new MarkupReader (path+filename, reporter);
		next ();
		while(!is_start_element("map")){next ();}
		parse_map();
		print("Map parsed: %s\n", path+filename);
		return map;
	}

	protected void parse_map() {
		start_element("map");
		Gee.Map<string,string> attributes = reader.get_attributes();
		foreach (var key in attributes.keys) {
			switch (key) {
			case "tilewidth":
				map.tilewidth = int.parse(attributes.get (key));
				break;
			case "tileheight":
				map.tileheight = int.parse(attributes.get (key));
				break;
			case "version":
				map.version =  attributes.get (key);
				break;
			case "orientation":
				map.orientation =  attributes.get (key);
				break;
			case "width":
				map.width = int.parse(attributes.get (key));
				break;
			case "height":
				map.height = int.parse(attributes.get (key));
				break;
			default:
				error ("unknown property of '%s'".printf (key));
			}
		}
		next();
		if(is_start_element("properties")) {
			parse_map_properties();
		}
		parse_tileset();
		while(is_start_element("layer")) {
			parse_layer();
		}
		end_element("map");
	}

	protected void parse_map_properties() {
		start_element("properties");
		next();
		while(!is_end_element("properties")) {
			string prop_value = null;
			string prop_name = null;
			parse_property(out prop_value, out prop_name);
			if(prop_name != null && prop_value != null)
				map.properties.set(prop_name, prop_value);

		}
		end_element("properties");
	}

	protected void parse_property(out string prop_name, out string prop_value) {
		start_element("property");
		Gee.Map<string,string> attributes = reader.get_attributes();
		prop_value = null;
		prop_name = null;
		foreach (var key in attributes.keys) {
			if(key == "value")
				prop_value =  attributes.get (key);
			else
				prop_name =  attributes.get (key);
		}
		next();
		end_element("property");
	}

	protected void parse_tileset() {
		start_element("tileset");
		Gee.Map<string,string> attributes = reader.get_attributes();

		string ts_filename = Hmwd.File.PathToFilename( attributes.get ("source"));
		Hmwd.TileSet ts_source = tilesetmanager.getFromFilename(ts_filename);
		int firstgid = int.parse(attributes.get ("firstgid"));
		//Den zusammengestellten neuen TileSet in die Liste einfuegen
		map.tileset.add( new TileSetReference(firstgid, ts_source));
		next();
		end_element("tileset");
	}

	protected void parse_layer() {
		start_element("layer");
		Gee.Map<string,string> attributes = reader.get_attributes();
		string layer_name = null;
		int layer_width = 0;
		int layer_height = 0;
		bool collision = false;
		DrawLevel drawlayer = DrawLevel.UNDER;

		foreach (var key in attributes.keys) {
			switch (key) {
			case "width":
				layer_width = int.parse(attributes.get (key));
				break;
			case "height":
				layer_height = int.parse(attributes.get (key));
				break;
			case "name":
				layer_name =  attributes.get (key);
				break;
			}
		}
		next();
		parse_layer_properties(out drawlayer, out collision);

		Hmwd.Layer new_layer = new Layer.all( layer_name, layer_count+1, collision, layer_width, layer_height);

		new_layer.tiles = parse_data();
		switch (drawlayer) {
			case DrawLevel.UNDER:
				map.layers_under.add( new_layer );
				break;
			case DrawLevel.SAME:
				map.layers_same.add( new_layer );
				break;
			case DrawLevel.OVER:
				map.layers_over.add( new_layer );
				break;
			default:
				error ("expected property of '%s'".printf ("drawlayer"));
		}
		layer_count++;
		end_element("layer");
	}

	protected void parse_layer_properties(out DrawLevel _drawlayer, out bool _collision) {
		start_element("properties");
		next();
		_drawlayer =DrawLevel.UNDER;
		_collision = false;
		while(!is_end_element("properties")) {
			string prop_value = null;
			string prop_name = null;
			parse_property(out prop_value, out prop_name);
			switch (prop_name) {
			case "drawlayer":
				_drawlayer = DrawLevel.parse(prop_value);
				break;
			case "collision":
				_collision = bool.parse(prop_value);
				break;
			}
		}
		end_element("properties");
	}

	protected Hmwd.Tile[,] parse_data() {
		start_element("data");
		Hmwd.Tile[,] _tiles = null;
		Gee.Map<string,string> attributes = reader.get_attributes();
		if (attributes.has_key("compression")) {
			// parse data with encoding and compression
			next();
			if (!attributes.has_key("encoding") || attributes.get("encoding") != "base64")
				error ("unknown encoding '%s'".printf (attributes.get("encoding")));
			uint8[] data = null;
			switch(attributes.get("compression")) {
			case "zlib":
				data = inflate(Base64.decode(reader.content), ZlibCompressorFormat.ZLIB);
				break;
			case "gzip":
				data = inflate(Base64.decode(reader.content), ZlibCompressorFormat.GZIP);
				break;
			default:
				error ("unknown compression '%s'".printf (attributes.get("compression")));
			}				
			_tiles = parse_binary(data);
			next();
		} else if (attributes.has_key("encoding")) {
			// parse data with encoding but without compression
			if (attributes.get("encoding") != "base64")
				error ("unknown encoding '%s'".printf (attributes.get("encoding")));
			next();
			uchar[] data = Base64.decode(reader.content);
			_tiles = parse_binary(data);
			next();
		} else {
			// parse data directly from xml without encoding and compression 
			next();
			_tiles = new Tile[map.width,map.height];
			int tile_count = 0;
			while(!is_end_element("data")) {
				_tiles[(uint)(tile_count%map.width), (uint)(tile_count/map.width)] = parse_tile();
				tile_count++;
			}
		}
		end_element("data");
		return _tiles;
	}
	// Decompress zlib compressed inbuf
	protected uint8[] inflate(uint8[] inbuf, ZlibCompressorFormat format) {
		uint8[] outbuf = new uint8[map.width*map.height*4];

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

	protected Hmwd.Tile[,] parse_binary(uchar[] data) {
		if(data.length != map.width*map.height*4)
			error("data.length: %i != map.width*map.height*4: %i\n", data.length, (int) (map.width*map.height*4));
		uint tile_index = 0;
		Hmwd.Tile[,] _tiles = new Tile[map.width,map.height];
		for (int y = 0; y < map.height; ++y) {
			for (int x = 0; x < map.width; ++x) {
				int global_tile_id = data[tile_index] |
				                          data[tile_index + 1] << 8 |
				                          data[tile_index + 2] << 16 |
				                          data[tile_index + 3] << 24;
				tile_index += 4;

				// Read out the flags TODO save this!
				bool flipped_horizontally = (global_tile_id & FLIPPED_HORIZONTALLY_FLAG) == FLIPPED_HORIZONTALLY_FLAG;
				bool flipped_vertically = (global_tile_id & FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG;
				bool flipped_diagonally = (global_tile_id & FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG;

				// Clear the flags
				global_tile_id &= ~(FLIPPED_HORIZONTALLY_FLAG |
				                    FLIPPED_VERTICALLY_FLAG |
				                    FLIPPED_DIAGONALLY_FLAG);
				// Resolve the tile
				_tiles[y,x] = resolve_tile(global_tile_id);
			}
		}
		return _tiles;
	}

	protected Hmwd.Tile parse_tile() {
		start_element("tile");
		Hmwd.Tile tmp_tile = resolve_tile(int.parse(reader.get_attributes().get("gid")));
		next();
		end_element("tile");
		return tmp_tile;
	}

	protected Hmwd.Tile resolve_tile(int gid) {
		Hmwd.Tile tmp_tile;
		Hmwd.TileSetReference tmp_tilesetref;
		// TODO bestimmung des tiles vereinfachen
		if(gid > 0) {
			tmp_tilesetref = Hmwd.Map.getTileSetRefFromGid(map.tileset, gid);
			tmp_tile = tmp_tilesetref.source.getTileFromIndex(gid - tmp_tilesetref.firstgid);	
			tmp_tile.gid = gid;
			tmp_tile.tile_type = TileType.EMPTY_TILE; //TODO anhand der ID den echten TileTyp bestimmen.
		} else {
			tmp_tile = new RegularTile();
			tmp_tile.tile_type = TileType.NO_TILE;
		}
		return tmp_tile;
	}
}