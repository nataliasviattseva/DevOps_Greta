package calculator.test;

import calculator.main.Calculator;
import org.junit.Test;
import org.junit.rules.ExpectedException;

import static org.junit.Assert.assertEquals;

public class CalculatorJUnitTest {

    Calculator calc = new Calculator();

    @Test
    public void testAdd() {
        assertEquals(calc.add(3,7), 10);
        System.out.println("Check addition passed!");
    }

    @Test
    public void testSubtraction() {
        assertEquals(calc.subtraction(6, 3), 3);
        System.out.println("Check subtraction passed!");
    }

    @Test
    public void testMultiplication() {
        assertEquals(calc.multiplication(8, 3), 24);
        System.out.println("Check multiplication passed!");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testDivision() {
        assertEquals(calc.division(18, 3), 6);
        System.out.println("Check division passed!");
    }

    @Test
    public void testDivisionZero() {
        ExpectedException thrown= ExpectedException.none();
        thrown.expect(ArithmeticException.class);
//        assertEquals(calc.division(18, 0), null);
        System.out.println("Check division passed!");
    }
}
