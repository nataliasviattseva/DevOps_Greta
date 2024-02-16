package com.greta78.testmaven;

public class MainMathUtile {
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		MathUtile u1 = new MathUtile(0);
		u1.somme();
		u1.factorielle();
		u1.aleatoire();
		u1.affiche();
		MathUtile u2 = new MathUtile(4);
		u2.somme();
		u2.factorielle();
		u2.aleatoire();
		u2.affiche();
		MathUtile u3 = new MathUtile(6);
		u3.somme();
		u3.factorielle();
		u3.aleatoire();
		u3.affiche();
	}

}
