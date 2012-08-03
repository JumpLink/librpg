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

using HMP;
namespace HMP {
	public class GdkTextureFactory {
		public GdkTextureFactory() {

		}
		public HMP.GdkTexture empty () {
			return new OpenGLTexture();
			//return new ClutterTexture();
		}
		public HMP.GdkTexture fromPixbuf(Gdk.Pixbuf pixbuf) {
			HMP.GdkTexture tex = this.empty();
			tex.loadFromPixbuf(pixbuf);
			return tex;
		}
	}
}