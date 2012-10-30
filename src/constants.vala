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
using rpg;
namespace rpg {
	const int TIMER_CALLS_PS = 30;

	/**
	 * Kapazitaet der Giesskanne.
	 */
	const uint WATER_CAPACITY = 10;

	/**
	 * Samen pro Sack.
	 */
	const uint SEED_PER_BAG = 10;

	/**
	 * Standardausdauer des Spielers.
	 */
	const int DEFAULT_STAMINA = 25;

	/**
	 * Multiplikator fuer Stufenabhaengige Zusatzausdauer.
	 */
	const int STAMINA_MULTIPLIER = 10;

	/**
	 * Erfahrungsfaktor, benoetigt zum Erreichen hoeherer Spielerstufen.
	 */
	const int EXPERIENCE = 100;

	/**
	 * Sonnenaufgang/Tagesbeginn (6 Uhr).
	 */
	const uint DAWN = 6;

	/**
	 * Sonnenuntergang/Tagesende (18 Uhr).
	 */
	const uint DUSK = 18;

	/**
	 * Tage pro Jahreszeit.
	 */
	const uint DAYS_PER_SEASON = 30;
	// Bits on the far end of the 32-bit global tile ID are used for tile flags
	const uint64 FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
	const uint64 FLIPPED_VERTICALLY_FLAG   = 0x40000000;
	const uint64 FLIPPED_DIAGONALLY_FLAG   = 0x20000000;
}