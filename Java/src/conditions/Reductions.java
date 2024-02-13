package conditions;

import java.util.Scanner;

public class Reductions {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("La saisie du montant de l'achat ?");
        double prix = sc.nextInt();

        if (prix >= 600) {
            prix *= 0.95;
        } else if (prix >= 350) {
            prix *= 0.97;
        } 

        System.out.println("Montant final %.2f: " + prix);
    }
    
}

// Un magasin consent une réduction dans les conditions suivantes :
//  Si le montant de l'achat est strictement inférieur à 350€, il n'y a pas de réduction
//  Si le montant de l'achat est compris entre 350€ et 600€, 3% de réduction est accordé
//  Si le montant de l'achat est supérieur ou égal à 600€, 5% de réduction est accordé
// Réaliser un programme qui :
// - demande la saisie du montant de l'achat;
// - calcule le prix net à payer et l'affiche.
