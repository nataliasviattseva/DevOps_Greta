package conditions;

import java.util.Scanner;

public class TestSwitch {

    public static void main(String[] args) {
    
        int x;
        Scanner sc = new Scanner(System.in);
        System.out.println("Taper un nombre, soit 1, 2, 3, 4");
        x = sc.nextInt();
        
        switch (x) {
            case 1 : System.out.println("Choix 1");
                    break;
            case 2 : System.out.println("Choix 2");
                    break;
            case 3 : System.out.println("Choix 3");
                    break;
            case 4 : System.out.println("Choix 4");
                    break;
            default : System.out.println("Aucun choix valide");
                    break;
        }
    }
    
}
