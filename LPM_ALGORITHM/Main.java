import java.util.Scanner;

public class Main {

	public static void main(String Args[]) {
		
		int n;
		String operation = "*";
		Scanner s = new Scanner(System.in);
		
		while (!operation.equals("q")) {
			System.out.println("\nPRESS \"i\" to enter a matrix, \"q\" to quit");
			operation = s.next();
			if (operation.equals("i")) {
				System.out.println("\nWhat is the number of the delays");
				System.out.print("Number = ");
				n = s.nextInt();
				Matrix L = new Matrix(n);
				L.setValues();
				L.computeMatrices();
				L.print();
				L.findIterationBound();
			}else if (operation.equals("q")) {
				System.out.println("Quit");
				s.close();
			}
		}
		
	}
	
}
