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
using HMP;
namespace HMP {
	 /**
	  * Klasse fuer Pflanzen.
	  */
	 public abstract class Plant {
	 	/**
	 	 * Pflanze lebt.
	 	 */
	 	protected bool alive;
	 	/**
	 	 * Pflanze wurde begossen.
	 	 */
	 	protected bool watered;
	 	/**
	 	 * Tage, die bis zur naechsten Ernte vergehen muessen.
	 	 */
	 	protected uint daysUntilHarvest;
	 	/**
	 	 * Pflanze kann noch so oft geerntet werden.
	 	 */
	 	protected uint cropsLeft;
	 	/**
	 	 * Minimale Zeit zwischen Ernten.
	 	 */
	 	protected static uint timeBetweenCrops;
	 	/**
	 	 * Maximale Anzahl an Ernten.
	 	 */
	 	protected static uint maxCrops;
	 	/**
	 	 * Art der Ernte.
	 	 */
	 	protected static CropType crop;
	 	/**
	 	 * Spriteset der Pflanze.
	 	 */
	 	public SpriteSet spriteset;

	 	/**
	 	 * Konstruktor.
	 	 */
	 	public Plant () {
	 		alive = true;
	 		watered = false;
	 		daysUntilHarvest = timeBetweenCrops;
	 		cropsLeft = maxCrops;
	 	}

	 	/**
	 	 * Pflanze wachsen lassen.
	 	 */
	 	public void grow () {
	 		if (watered && daysUntilHarvest > 0)
	 			--daysUntilHarvest;
	 		watered = false;
	 	}

	 	/**
	 	 * Pflanze begiessen, sofern sie noch lebt.
	 	 */
	 	public void water () {
	 		watered = alive;
	 	}

	 	/**
	 	 * Erntet eine Pflanze.
	 	 * @return Die Ernte.
	 	 */
	 	public CropType harvest () {
	 		if (daysUntilHarvest == 0) {
	 			--cropsLeft;
	 			daysUntilHarvest = timeBetweenCrops;
	 			return crop;
	 		}
	 		return CropType.EMPTY_CROP;
	 	}
	 }
}