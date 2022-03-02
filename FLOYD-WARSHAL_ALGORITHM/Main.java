import java.util.Scanner;

public class Main {
	
public static void main(String Args[]) {
		
		int n, t;
		double[][] w;
		double[][][] r;
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
				
				//Initialization of the matrix R0 
				r = new double[n+1][n][n];
				for (int v=0; v<n; v++) {
					for (int u=0; u<n; u++) {
						r[0][u][v] = w[u][v];
					}
				}
				
				//Calculation of the matrices R2 to Rn
				for (int k=0; k<n; k++) {
					for (int v=0; v<n; v++) {
						for (int u=0; u<n; u++) {
							r[k+1][u][v] = r[k][u][v];
							if (r[k+1][u][v] > r[k][u][k] + r[k][k][v]) {
								r[k+1][u][v] = r[k][u][k] + r[k][k][v];
							}
						}
					}
				}
				
				//Testing for negative cycles
				for (int k=0; k<n; k++) {
					for (int u=0; u<n; u++) {
						if(r[k][u][u] < 0) {
							result = false;
						}
					}
				}
				
				//Printing of the matrices R0 to Rn on the screen
				t=0;
				System.out.println("\n");
				for (double[][] i : r) {
					System.out.println("R" + t + " = \n"); 
					for (double[] j : i) {
						for (double m : j) {
							if (m != inf) {
								System.out.print(m + "\t\t");
							}
							else {
								System.out.print(m + "\t");
							}
						}
						System.out.println("\n");
					}
					System.out.println("\n");
					t++;
				}
				
				System.out.println("----" + result + "----\n");
				
			}else if (operation.equals("q")) {
				System.out.println("Quit");
				s.close();
			}
		}
		
	}
	
}
