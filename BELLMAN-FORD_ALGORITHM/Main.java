import java.util.Scanner;

public class Main {
	
	public static void main(String Args[]) {
		
		int n, initial;
		double[][] r, w;
		boolean result=true;
		String input;
		char charinput;
		String operation = "*";
		Scanner s = new Scanner(System.in);
		final double inf = Double.POSITIVE_INFINITY;
		
		while (!operation.equals("q")) {
			System.out.println("PRESS \"i\" to enter a graph, \"q\" to quit");
			operation = s.next();
			if (operation.equals("i")) {
				System.out.println("\nWhat is the number of the vertices");
				System.out.print("Number = ");
				n = s.nextInt();
				System.out.println("\nIf you want to insert infinity press \"n\" \n");
				
				//Initialization of the matrix w which contains the weights of the graph
				w = new double[n][n];
				for (int i=0; i<n; i++) {
					for (int j=0; j<n; j++) {
						System.out.print("w[" + (i+1) + "][" + (j+1) + "] = ");
						input = s.next();
						charinput = input.charAt(0);
						if (charinput == '-') {
							charinput = input.charAt(1);
						}
						if (input.equals("n")) {
							w[i][j] = inf;
						}else if (Character.isDigit(charinput))
						w[i][j] = Double.parseDouble(input);
					}
				}
				
				//Printing of the matrix w on the screen
				System.out.println("\n\nW =\n");
				for (double[] i : w) {
					for (double j : i) {
						if (j != inf) {
							System.out.print(j + "\t\t");
						}
						else {
							System.out.print(j + "\t");
						}
					}
					System.out.println("\n");
				}
				
				//Declaration of the array r and the initial vertex
				r = new double[n][n-1];
				System.out.println("\nWhich is the initial vertex;");
				System.out.print("-> ");
				initial = s.nextInt()-1;
				System.out.println();
				
				//Initialization of the 0th column of the array r
				r[initial][0] = 0;
				for (int k=0; k<n; k++) {
					if (k != initial) {
						r[k][0] = w[initial][k];
					}
				}
				
				//Calculation of the columns 1 to n-2 of the array r
				for (int k=0; k<n-2; k++) {
					for (int v=0; v<n; v++) {
						r[v][k+1] = r[v][k];
						for (int m=0; m<n; m++) {
							if (r[v][k+1] > r[m][k] + w[m][v]) {
								r[v][k+1] = r[m][k] + w[m][v];
							}
						}
					}
				}
				
				//Testing for negative cycles
				for (int v=0; v<n; v++) {
					for (int m=0; m<n; m++) {
						if (r[v][n-2] > r[m][n-2] + w[m][v]) {
							result = false;
						}
					}
				}
				
				//Printing of the array r on the screen
				System.out.println("\nr = \n");
				for (double[] i : r) {
					for (double j : i) {
						if (j != inf) {
							System.out.print(j + "\t\t");
						}
						else {
							System.out.print(j + "\t");
						}
					}
					System.out.println("\n");
				}
				
				System.out.println("----" + result + "----\n");
				
			}else if (operation.equals("q")) {
				System.out.println("Quit");
				s.close();
			}
		}
		
	}
	
}
