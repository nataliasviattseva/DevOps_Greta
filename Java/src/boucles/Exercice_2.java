// réaliser un programme qui affiche plusieurs fois "Bonjour" : le nombre d'affichage
//doit être saisi par l'utilisateur.

package boucles;

import java.util.Scanner;

public class Exercice_2 {
    public static void main(String[] args) {
        System.out.println("Entre le nombre : ");
        Scanner sc = new Scanner(System.in);
        int nombre = sc.nextInt();
        int i = 0;

        while (i < nombre) {
            System.out.println("Bonjour");
            i++;
        }


    }
}
