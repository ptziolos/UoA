import java.awt.Color;

import javax.swing.JSlider;

public class MySlider extends JSlider {
	
	public MySlider(int min, int max, int initial) {
		super(JSlider.HORIZONTAL, min, max, initial);
		setMajorTickSpacing((max-min)/3);
		setMinorTickSpacing(1);
		setPaintTicks(true);
		setPaintLabels(true);
		setBackground(Color.BLACK);
		setForeground(Color.WHITE);
	}
	
}
