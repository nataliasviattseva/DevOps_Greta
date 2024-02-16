package compteur;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class CompteurTest {

	@Test
	void testIncremente() {
		Compteur c = new Compteur(10);
		c.incremente();
		assertEquals(11, c.getValeur(), "test incremente");
	}

	@Test
	void testDecremente() {
		Compteur c = new Compteur();
		c.decremente();
		assertEquals(0, c.getValeur(), "test decremente");	}

	@Test
	void testGetValue() {
		Compteur c = new Compteur(20);
		c.decremente();
		assertEquals(19, c.getValeur(), "test getValeur");	}

}
