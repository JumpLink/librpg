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
namespace rpg {
	/**
	 * Einfache Klasse fuer n x m - Matrizen.
	 */
	public class Matrix : Object {
		/**
		 * Breite der Matrix.
		 */
		public int n { get; construct set; }
		/**
		 * Hoehe der Matrix.
		 */
		public int m { get; construct set; }
		/**
		 * Matrixdaten.
		 */
		public double[,] mat;
		/**
		 * Flag ob Matrix quadratisch ist.
		 */
		public bool sq;

		/* Konstruktoren */

		/**
		 * Konstruktor.
		 * 
		 * Erzeugt eine nicht initialisierte quadratische n x n-Matrix.
		 * 
		 * @param n Dimension der Matrix
		 */
		public Matrix.square(int n) {

			Object(n: n, m: n);
		}
		/**
		 * Default-Konstruktor.
		 * 
		 * Erzeugt eine unintialisierte n x m - Matrix.
		 * 
		 * @param n Dimension in x
		 * @param m Dimension in y
		 */
		public Matrix(int n, int m) {
			
			Object(n: n, m: m);
		}

		construct {
			mat = new double[n,m];
			if(n == m)
				this.sq = true;
			else {
				this.sq = false;
			}
		}
		/**
		 * Copy-Konstruktor.
		 * 
		 * Erzeugt eine Matrix als Kopie einer anderen Matrix.
		 * 
		 * @param m Matrix die kopiert wird
		 */
		public Matrix.copy(Matrix m) {
			this.n = m.n;
			this.m = m.m;
			this.sq = m.sq;
			this.mat = new double[m.n,m.m];
			this.copy_matrix(m);
		}

		/* Initialisierung und Besetzung der Matrix mit Werten. */

		/**
		 * Setzt diese Matrix als Einheitsmatrix.
		 * 
		 * @return Referenz auf diese Matrix (Zur Verkettung).
		 */
		public Matrix unity_matrix() {
			for (int x = 0; x < n; ++x)
				for (int y = 0; y < m; ++y)
					mat[x,y] = x == y ? 1 : 0;
			
			return this;
		}

		/**
		 * Besetzt diese Matrix mit Nullen.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix null_matrix() {
			for (int x = 0; x < n; ++x)
				for (int y = 0; y < m; ++y)
					mat[x,y] = 0;

			return this;
		}
		
		/**
		 * Besetzt diese Matrix als Kopie einer anderen Matrix.
		 * 
		 * @param c Matrix, die kopiert wird.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix copy_matrix(Matrix c) {
			assert(this.m == c.m);
			assert(this.n == c.n);

			for (int x = 0; x < n; ++x)
				for (int y = 0; y < m; ++y)
					mat[x,y] = c.mat[x,y];

			return this;
		}

		/**
		 * Besetzt diese Matrix als Translationsmatrix.
		 * 
		 * @param t Verschiebungsvektor.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix translation_matrix(Vector t) {
			/* assertion: Matrix ist mindestens einen hoeher als Vektor */
			assert(this.m > t.dim);
			
			for (int x = 0; x < n; ++x)
				for (int y = 0; y < n; ++y)
					mat[x,y] = x == y ? 1
							           : x == n-1 ? t.vec[y]
			                                      : 0;

			return this;
		}

		/**
		 * Besetzt diese Matrix als Skalierungsmatrix.
		 * 
		 * @param s Skalierungsvektor.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix scaling_matrix(Vector s) {
			/* assertion: Matrix ist mindestens so gross wie Vektor */
			assert(this.m >= s.dim);
			
			for (int x = 0; x < n; ++x)
				for (int y = 0; y < n; ++y)
					mat[x,y] = x != y ? 0
					                   : x < s.dim ? s.vec[x]
					                		       : 1;

			return this;
		}

		/**
		 * Besetzt diese Matrix als Rotationsmatrix.
		 * 
		 * @param angle Rotationswinkel (Bogenmass).
		 * @param axis Rotationsachse als Vektor.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix rotation_matrix(double angle, Vector axis) {
			/* TODO allgemeine rot-matrix */
			return this;
		}

		/**
		 * Besetzt diese Matrix mit dem Produkt zweier Matrizen.
		 * 
		 * @param l Linker Operand.
		 * @param r Rechter Operand.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix mult_matrix(Matrix l, Matrix r) {
			/* Spaltenanzahl links muss Zeilenanzahl rechts entsprechen */
			assert(l.n == r.m);
			/* Neue Spalten = Linke Zeilen, neue Zeilen = rechte Spalten */
			assert(this.n == l.m);
			assert(this.m == r.n);

			/* Zielmatrix durchlaufen */
			for (int x = 0; x < n; ++x) {
				for (int y = 0; y < m; ++y) {
					mat[x,y] = 0;
					for (int i = 0; i < l.n; ++i)
						mat[x,y] += l.mat[i,y] * r.mat[x,i];
				}
			}

			return this;
		}
		
		/**
		 * Besetzt diese Matrix mit dem Produkt einer Matrix mit einem Skalar.
		 * 
		 * @param o Matrix.
		 * @param s Skalar.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix mult_matrix_scalar(Matrix o, double s) {
			/* Neue Spalten = Linke Zeilen, neue Zeilen = rechte Spalten */
			assert(this.n == o.m);
			assert(this.m == o.n);

			/* Zielmatrix durchlaufen */
			for (int x = 0; x < n; ++x)
				for (int y = 0; y < m; ++y)
					mat[x,y] = s * o.mat[x,y];

			return this;
		}

		/**
		 * Besetzt diese Matrix mit der Summe zweier Matrizen.
		 * 
		 * @param l Erster Operand der Addition.
		 * @param r Zweiter Operand.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix add_matrix(Matrix l, Matrix r) {
			assert(l.n == r.n);
			assert(l.m == r.m);
			assert(this.n == l.n);
			assert(this.m == l.m);
			
			for (int x = 0; x < n; ++x)
				for (int y = 0; y < m; ++y)
					mat[x,y] = l.mat[x,y] + r.mat[x,y];

			return this;
		}

		/**
		 * Besetzt eine Matrix so, dass sie das Transponierte einer anderen
		 * Matrix ist.
		 * 
		 * @param op zu transponierende Matrix.
		 * 
		 * @return Referenz auf diese Matrix.
		 */
		public Matrix transpose_matrix(Matrix op) {
			assert(this.n == op.m);
			assert(this.m == op.n);

			for (int x = 0; x < n; ++x)
				for (int y = 0; y < m; ++y)
					mat[x,y] = op.mat[y,x];

			return this;
		}

		/* Transformationsmatrizen */
		/**
		 * Erzeugt eine neue Translationsmatrix.
		 * 
		 * @param t Verschiebungsvektor.
		 * 
		 * @return neue Matrix die entsprechend verschiebt.
		 */
		public Matrix mk_trans(Vector t) {
			return new Matrix.square(t.dim+1).translation_matrix(t);
		}
		
		/**
		 * Erzeugt eine neue Skalierungsmatrix.
		 * 
		 * @param s Skalierungsvektor.
		 * 
		 * @return neue Matrix die entsprechend skaliert.
		 */
		public Matrix mk_scale(Vector s) {
			return new Matrix.square(s.dim).scaling_matrix(s);
		}
		
		/**
		 * Erzeugt eine neue Rotationsmatrix.
		 * 
		 * @param arc Winkel der Rotation (radial).
		 * @param axis Rotationsachse.
		 * 
		 * @return neue Matrix die entsprechend rotiert.
		 */
		public Matrix mk_rot(double arc, Vector axis) {
			return new Matrix.square(axis.dim).rotation_matrix(arc, axis);
		}

		/* Rechenoperationen */

		/**
		 * Multipliziert diese Matrix mit einer anderen.
		 * 
		 * @param r Matrix mit der multipliziert wird (rechter Operand).
		 * 
		 * @return neue Matrix mit dem Ergebnis der Multiplikation.
		 */
		public Matrix mult(Matrix r) {
			return new Matrix(this.m, r.n).mult_matrix(this, r);
		}
		
		/**
		 * Multipliziert diese Matrix mit einem Skalar.
		 * 
		 * @param s Skalar mit dem multipliziert wird.
		 * 
		 * @return neue Matrix mit dem Ergebnis der Multiplikation.
		 */
		public Matrix mult_scalar(double s) {
			return new Matrix(this.n, this.m).mult_matrix_scalar(this, s);
			/* TODO: Methode, die direkt multipliziert auch. */
		}

		/**
		 * Multipliziert diese Matrix mit einem Vektor.
		 * 
		 * @param v Skalar mit dem multipliziert wird.
		 * 
		 * @return neuer Vektor mit dem Ergebnis der Multiplikation.
		 */
		public Vector mult_vector(Vector v) {
			return new Vector(v.dim).mult_matrix(this, v);
		}

		/**
		 * Addiert diese Matrix mit einer anderen.
		 * 
		 * @param r Matrix mit der addiert wird.
		 * 
		 * @return neue Ergebnismatrix.
		 */
		public Matrix add(Matrix r) {
			return new Matrix(this.m, this.n).add_matrix(this, r);
		}
		
		/**
		 * Transponiert die Matrix.
		 * 
		 * @return eine neue Matrix mit dem Ergebnis der Transponierung.
		 */
		public Matrix transpose() {
			return new Matrix(this.m, this.n).transpose_matrix(this);
		}
		
		/* Sonstige Operationen */
		
		/**
		 * to_string-Methode zur Ausgabe von Matrizen.
		 * 
		 * @return Matrix als Stringdarstellung.
		 */
		public string to_string() {
			StringBuilder sb = new StringBuilder();
			for (int x = 0; x < n; ++x) {
				for (int y = 0; y < m; ++y) {
					sb.append(mat[x,y].to_string());
					sb.append("\t");
				}
				sb.append("\n");
			}
			
			return sb.str;
		}
	}
}