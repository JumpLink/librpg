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

using Hmwd;
namespace Hmwd {
	public class GdkTextureFactory {
		public GdkTextureFactory() {

		}
		public Hmwd.GdkTexture empty () {
			return new OpenGLTexture();
			//return new ClutterTexture();
		}
		public Hmwd.GdkTexture fromPixbuf(Gdk.Pixbuf pixbuf) {
			Hmwd.GdkTexture tex = this.empty();
			tex.loadFromPixbuf(pixbuf);
			return tex;
		}
	}
}