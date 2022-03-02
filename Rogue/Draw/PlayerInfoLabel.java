package Draw;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.font.FontRenderContext;
import java.awt.geom.AffineTransform;

import javax.swing.JLabel;

public class PlayerInfoLabel extends JLabel {

private static final long serialVersionUID = 1L;
	
	private int textwidth;
	private int textheight;

	public PlayerInfoLabel(String s) {
		super(s);
		AffineTransform affinetransform = new AffineTransform();     
		FontRenderContext frc = new FontRenderContext(affinetransform,true,true);  
		Font font = new Font("Times New Roman", Font.PLAIN, 30);
		textwidth = (int)(font.getStringBounds(s, frc).getWidth());
		textheight = (int)(font.getStringBounds(s, frc).getHeight());
		this.setFont(font);
		this.setPreferredSize(new Dimension(textwidth, textheight));
		this.setForeground(Color.WHITE);
		this.setVisible(true);
	}
}
