
public class DragonCurve_Grammar {
	
	private String dragonString;
	private int order;
	
	public DragonCurve_Grammar() {
		
		setOrder(19);

	}
		
	public String createDragonString() {
		
		dragonString = "FX";
		
		for (int i = 1; i <= order; i++) {
			
			dragonString = dragonString.replace("Y", "y");
			dragonString = dragonString.replace("X", "x");
		
			dragonString = dragonString.replace("y", "-FX-Y");
			dragonString = dragonString.replace("x", "X+YF+");
			
		}
		
		return dragonString;
	}
	
	public int getOrder() {
		return order;
	}
	
	public void setOrder(int anOrder) {
		order = anOrder;
	}
	
	public String getDragonString() {
		return dragonString;
	}
	
}
