import java.awt.Color;

import javax.swing.JButton;

public class MyButton extends JButton{
	
	public MyButton(String discription) {
		super(discription);
		setEnabled(true);
		setBackground(Color.WHITE);
		setForeground(Color.BLACK);
	}
	
}
