HMWorld
=========

HMWworld - A 2D orthogonal RPG Remake

Dokumentations
-------------

* Cogl - Matrixs, Vectors, ...
	* vala: http://unstable.valadoc.org/#!api=cogl-1.0/Cogl
	* original: http://docs.clutter-project.org/docs/cogl/stable/

* Gee - Lists, Maps, .. like the Lists, Maps, .. from java 
	* vala, original: http://unstable.valadoc.org/#!wiki=gee-0.8/index
	* Samples: https://live.gnome.org/Vala/GeeSamples

* GIO - Fileoperations
	* vala: http://unstable.valadoc.org/#!wiki=gio-2.0/index
	* original: http://developer.gnome.org/gio/

* Glib
	* vala: http://unstable.valadoc.org/#!api=glib-2.0/GLib
	* original: http://developer.gnome.org/glib/

* XPath
	* vala: http://unstable.valadoc.org/#!api=libxml-2.0/Xml.XPath
	* original: http://xmlsoft.org/html/libxml-xpath.html

Build this Software
-------------

To compile this software install the following dependencies on Ubuntu

Clutter

	sudo apt-get install libclutter-gtk-1.0-dev libclutter-1.0-dev libcogl-dev
Gee

	sudo apt-get install gee-1.0 libgee-dev
	
OpenGL

	sudo apt-get install valac freeglut3 freeglut3-dev libxi-dev libxi6 libxmu-dev libxi6 libxmu-dev libxmu6
	
Gdk

	sudo apt-get install libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-dev
	
XML

	sudo apt-get install libxml2 libxml2-dev
	
ValaDoc

	sudo apt-get install valadoc libvaladoc0 libvaladoc-dev
	
For Debuggin

	sudo apt-get install nemiver
	
To generate vapis

	sudo apt-get install gobject-introspection


License
-------------

This software is free software; you can redistribute it and/or
modify it under the terms of the Creative Commons licenses CC BY-SA 3.0.
License as published by the Creative Commons organisation; either
version 3.0 of the License, or (at your option) any later version.
More informations on: http://creativecommons.org/licenses/by-sa/3.0/ 

### Authors and Copyright (C) 2012
* Pascal Garber <pascal.garber@gmail.com>
* Ole Lorenzen <ole.lorenzen@gmx.net>
* Patrick König <knuffi@gmail.com>

More
-------------

More informations on http://incux.de/projects/reloaded