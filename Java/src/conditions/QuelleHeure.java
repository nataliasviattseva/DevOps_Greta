package conditions;

import java.util.Scanner;

public class QuelleHeure {
    public static void main(String[] args) {
        int choix;
        Scanner sc = new Scanner(System.in);
        System.out.println("Quelle heure y a-t-it ? (sans les minutes)");
        choix = sc.nextInt();

        if (choix <= 16) {
            System.out.println("Bonjour !");
        }
        else {
            System.out.println("Bonsoir !");
        }
    }
}
