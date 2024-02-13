package calculator.main;

public class Calculator {

    public int add(int a, int b) {
        return a + b;
    }

    public int subtraction(int a, int b) {
        return a - b;
    }

    public int multiplication(int a, int b) {
        return a * b;
    }

    public int division(int a, int b) {
        try {
            return a / b;
        }
        catch(Exception IllegalArgumentException) {
            System.out.println("Division by zero is not allowed");
        }
        return a / b;
    }

}
