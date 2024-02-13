package conditions;

import java.util.Scanner;

public class CalculIMC {
    public static void main(String[] args) {
        int poids;
        Scanner sc = new Scanner(System.in);
        System.out.println("Taper le poids : ");
        poids = sc.nextInt();
        System.out.println("Taper le taille : ");
        double taille = sc.nextDouble();

        double imc = poids/(taille*taille);

        if (imc < 16.5) {
            System.out.println("Dénutrition");
        } else if (imc >= 16.5 && imc < 18.5) {
            System.out.println("Maigreur");
        } else if (imc >= 18.5 && imc < 25) {
            System.out.println("Corpulence normale");
        } else if (imc >= 25 && imc < 30) {
            System.out.println("Surpoids");
        } else {
            System.out.println("Obésité");
        }
    }
    
}
