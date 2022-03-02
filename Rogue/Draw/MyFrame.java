package Draw;
import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JFrame;

public class MyFrame extends JFrame {
	
	private static final long serialVersionUID = 1L;

	public MyFrame() {
		super();
		setPreferredSize(new Dimension(918,621));
		setVisible(true);
		setResizable(true);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		getContentPane().setBackground(Color.BLACK);
		pack();
	}

}
