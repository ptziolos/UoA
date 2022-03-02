package Draw;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;

import javax.swing.JTextArea;
import javax.swing.text.BadLocationException;
import javax.swing.text.Document;

public class TextArea extends JTextArea {

	private static final long serialVersionUID = 1L;

	private final int W = 900;
	private final int H = 200;
	private Document d;
	
	public TextArea() {
		super(" press :\n w, s, a, d  or  up, down, right, left  to move\n "
				+ "e  to equip an item\n p  to use a potion\n "
				+ "r  to rest\n t  to attack\n"
				+ "PLEASE DONT CLICK ON THE TEXT AREA BECAUSE FOCUS WILL BE LOST");
		this.setPreferredSize(new Dimension(W, H));
		this.setSize(W, H);
		this.setBackground(Color.BLACK);
		this.setFont(new Font("Cambria", Font.PLAIN, 20));
		this.setForeground(Color.WHITE);
		this.setEditable(false);
		this.setVisible(true);
		
		this.d = this.getDocument();
	}
	
	public void addText(String s) {
		try {
			d.insertString(d.getLength(), s + "\n", null);
		} catch (BadLocationException e) {
			e.printStackTrace();
			System.out.println("An error occured, while trying to show the text");
		}
	}
	
	public void clear() {
		this.setText("");
	}
	
}
