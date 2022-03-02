import java.util.Random;

public class Dice {
	
	private Random r = new Random();
	private int result;
	
	public int roll(int n, int s) {

		result = 0;
		for (int i=1; i<=n; i++) {
			result += r.nextInt(s-1)+1;
		}
		
		return result;
	}

}
