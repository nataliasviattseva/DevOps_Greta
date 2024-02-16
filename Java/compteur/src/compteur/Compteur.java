package compteur;

public class Compteur {
	private int valeur;

	/* Constructeur de la classe Compteur */
	public Compteur() {
		valeur = 0;
		System.out.println("Je suis le constructeur sans argument");
		System.out.println("La valeur du compteur =" + valeur);
	}

	/* 2ème constructeur de la classe Compteur */
	public Compteur(int n) {
		valeur = n;
		System.out.println("Je suis le constructeur avec un argument");
		System.out.println("La valeur du compteur = " + valeur);
	}

	public void affiche() {
		System.out.println("Valeur du compteur = " + valeur);
	}

	public void incremente() {
		valeur++;
	}

	public void decremente() {
		if (valeur > 0)
			valeur--;
	}
	
	public int getValeur() {
		return valeur;
	}

	public static void main(String argv[]) {
		Compteur c1, c2;
		c1 = new Compteur();
		c1.affiche();
		c2 = new Compteur(15);
		c2.affiche();
		int i = 0;
		while (i++ < 10)
			c2.incremente();
		System.out.println("Apres 10 incrémentations");
		c2.affiche();
		i = 0;
		while (i++ < 20)
			c2.decremente();
		System.out.println("Apres 20 décrémentations");
		c2.affiche();
	}
}
