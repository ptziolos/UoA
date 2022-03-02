import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.security.SecureRandom;
import java.util.ArrayList;

import javax.swing.JComponent;

public class DragonCurve_Implementation extends JComponent {
	
	private String dragonString;
	private DragonCurve_Grammar dragonCurve;
	private int pixels;
	private Color color;
	private ArrayList<Color> availableColors;
	private SecureRandom random;
	
	public DragonCurve_Implementation(String aDragonString) {
		dragonCurve = new DragonCurve_Grammar();
		dragonString = aDragonString;
		this.pixels = 1;
		this.color = Color.RED;
		availableColors = new ArrayList<Color>(){{add(Color.BLUE); add(Color.GREEN); add(Color.WHITE); add(Color.CYAN); add(Color.ORANGE); add(Color.RED);}};
		random = new SecureRandom();
	}
	
	
	public void setPixels(int pixels) {
		this.pixels = pixels;
	}
	
	
	public void callSetOrder(DragonCurve_Grammar aDragonCurve, int theOrder) {
		dragonCurve = aDragonCurve;
		dragonCurve.setOrder(theOrder);
	}
	
	
	public DragonCurve_Grammar getDragonCurve() {
		return dragonCurve;
	}
	
	
	public void setDragonString(String aDragonString) {
		dragonString = aDragonString;
	}
	
	
	public void changeColor() {
		int index;
		do{
			index = random.nextInt(availableColors.size()-1);
		}while (color.equals(availableColors.get(index)));
		color = availableColors.get(index);
	}
	
	public void paint(Graphics g) {
		Image img = createBufferedImage();
	    g.drawImage(img, 0, 0, 1920, 1080, this);
	}
	
	
	private Image createBufferedImage() {
		
		BufferedImage bufferedImage = new BufferedImage(1920, 1080, BufferedImage.TYPE_3BYTE_BGR);
	    Graphics g = bufferedImage.getGraphics();
	    g.setColor(color);
	    
	    double angle = Math.PI/2;
		int x1 = 800, y1 = 700;
		
		
		char dragonChar[] = dragonString.toCharArray();
		for(char i : dragonChar) {
			switch(i) {
				case 'F' :
					int x2=x1+(int)(pixels*Math.sin(angle)), y2=y1+(int)(pixels*Math.cos(angle));
					g.drawLine(x1, y1, x2, y2);
					x1 = x2;
					y1 = y2;
					break;
				case '+' :
					angle += Math.PI/2;
					break;
				case '-' :
					angle -= Math.PI/2;
				default :
					break;
			}
		}
      
		return bufferedImage;
	    
	   }
	
}

