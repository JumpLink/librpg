var fs = require('fs');
module.exports = function (data) {

	function generateTileCss() {
		var max_width = 30;
		var max_heigth = 16; 
		var width = 16;
		var height = 16;

		var css = 	".tile{background-repeat:no-repeat; width:"+width+"px; height:"+height+"px; float:left;} "+
					".tid_0{background:none !important;}";

		for (var a = 0; a < max_width*max_heigth; a++) {
			css +=
			".tid_"+(a+1)+"{background-position:-"+(a%max_width)*width+"px -"+parseInt(a/max_width)*height+"px;} ";
		};
		//console.log(css);
		fs.writeFile(__dirname+"/public/stylesheets/tile.less", css, function(err) {
			if(err) {
				console.log(err);
			} else {
				console.log("The css file was saved!");
			}
		}); 
	}
	function generateTileSetCss() {
		var tilesets = [];
		for (var i = 0; i < data.tilesetmanager.size; i++) {
			tilesets[i]=data.tilesetmanager.getSourcesFromIndex(i);
			tilesets[i].replace
		};
		console.log(tilesets);
		var css = " ";
		for (var i = 0; i < tilesets.length; i++) {
			css +=
			".ts_"+i+"{background-image: url(/data/tileset/"+tilesets[i].replace(new RegExp(" ","g"), '%20')+");}"
		};
		fs.writeFile(__dirname+"/public/stylesheets/tileset.less", css, function(err) {
			if(err) {
				console.log(err);
			} else {
				console.log("The css file was saved!");
			}
		}); 

	}

	return {
		generateTileCss : generateTileCss,
		generateTileSetCss : generateTileSetCss
	}
}