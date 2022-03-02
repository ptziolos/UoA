import java.util.Scanner;

public class Matrix {
	
	private int[][][] L;


	public Matrix(int n) {
		L = new int [n][n][n];
	}
	
	public void setValues() {
		Scanner s = new Scanner(System.in);
		System.out.println("\n");
		for (int i=0; i<L[0].length; i++) {
			for (int j=0; j<L[0][i].length; j++) {
				System.out.print("L1[" + (i+1) + "][" + (j+1) + "] = ");
				L[0][i][j] = s.nextInt();
			}
		}
		System.out.println("\n");
	}
	
	public void computeMatrices() {
		int max;
		for (int i=1; i<L.length; i++) {
			for (int k=0; k<L.length; k++) {
				for(int l=0; l<L[k].length; l++) {
					max = -1;
					for (int m=0; m<L.length; m++) {
						if (L[0][k][m] != -1  &&  L[i-1][m][l] != -1) {
							if (max < L[0][k][m]+L[i-1][m][l]) {
								max = L[0][k][m]+L[i-1][m][l];
							}
						}
					}
					L[i][k][l] = max;
				}
			}
		}
	}
	
	public void findIterationBound() {
		double ib=0;
		for (int i=0; i<L.length; i++) {
			for(int l=0; l<L.length; l++) {
				if (ib != -1  &&  ib < (double)((L[i][l][l])/(i+1))) {
					ib = (double)(L[i][l][l])/(double)(i+1);
				}
			}
		}
		System.out.println("The iteration bound is : " + ib);
	}
	
	public void print() {
		int k = 1;
		for (int[][] a : L) {
			System.out.println("L"+ k + ":");
			k++;
			for (int[] b : a) {
				for (int i : b) {
					System.out.print(i + "\t");
				}
				System.out.println("\n");
			}
			System.out.println();
		}
	}
	
}
