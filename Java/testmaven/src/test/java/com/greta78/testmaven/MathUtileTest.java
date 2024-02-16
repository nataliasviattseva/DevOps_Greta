package com.greta78.testmaven;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class MathUtileTest {
	MathUtile t = new MathUtile(5);

	@Test
	void testFactorielle() {
		assertEquals(120, t.factorielle(), "Factorielle de 5 =");
	}

	@Test
	void testSomme() {
		assertEquals(15, t.somme(), "Somme de 5");
	}

	@Test
	void testAleatoire() {
		assertTrue(t.aleatoire() <= 5, "La valeur aléatoire est convenable");
	}
}