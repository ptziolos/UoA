package Draw;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import javax.imageio.ImageIO;
import javax.swing.JPanel;
import javax.swing.SpringLayout;

import Item.AbstractItem;

public class ItemMenu extends JPanel {

	private static final long serialVersionUID = 1L;
	
	private final int W = 300;
	private final int H = 600;
	
	private MyFrame fr;
	private CompletableFuture<AbstractItem> f1;
	private JPanel p = this;
	private List<AbstractItem> items = new ArrayList<AbstractItem>();
	private ArrayList<MyLabel> l = new ArrayList<MyLabel>();
	private MyLabel selectedName;
	private AbstractItem selectedItem;
	private SpringLayout sp;
	private int index = 0;
	private int i2 = 0;
	private BufferedImage menu;
	private BufferedImage arrow;
	
	private MyLabel n1;
	
	public ItemMenu() {
		
		this.setPreferredSize(new Dimension(W, H));
		this.setSize(new Dimension(W, H));
		
		this.addKeyListener(new Key());
		
		sp = new SpringLayout();
		this.setLayout(sp);
		this.setVisible(false);
		
		menu = null;
		
		try {
			menu = ImageIO.read(this.getClass().getResource("/artwork/menu.png"));
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		
		arrow = null;
		
		try {
			arrow = ImageIO.read(this.getClass().getResource("/artwork/arr3.png"));
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public void createLayout() {
		int i = 0;
		
		for (MyLabel n : l) {
			sp.putConstraint(SpringLayout.WEST, n,  W/2 - n.getWidth()/2, SpringLayout.WEST, p);
			sp.putConstraint(SpringLayout.NORTH, n, 200 + i, SpringLayout.NORTH, p); 
			i += 40;
		}
	}
	
	public void createMenu(List<AbstractItem> items) {
		this.items.clear();
		this.items.addAll(items);
		
		l.clear();
		p.removeAll();
		
		for (int i = 0; i < items.size(); i ++) {
			n1 = new MyLabel(items.get(i).getName());
			l.add(n1);
			p.add(n1);
		}
		
		selectedName = l.get(index);
		selectedItem = this.items.get(index);
		
		createLayout();
	}
	
	public void paintComponent(Graphics g) {
		
		g.setColor(Color.BLACK);
		g.fillRect(0, 0, W, H);
		
		if (menu != null)
			g.drawImage(menu, 0, 0, W, H, null);
		
		g.setColor(Color.red);
		if (l.size() > 0)
			g.drawRect(W/2 - selectedName.getWidth()/2, 200 + i2, this.selectedName.getWidth(), this.selectedName.getHeight());
		
		if (arrow != null)
			g.drawImage(arrow, 20, 200 + i2 - arrow.getHeight()/2 + this.selectedName.getHeight()/2, 15, 20, null);
	}
	
	class Key implements KeyListener {

		@Override
		public void keyTyped(KeyEvent e) {}

		@Override
		public void keyPressed(KeyEvent e) {
			if (e.getKeyCode() == KeyEvent.VK_DOWN) {
				if (index < l.size()-1) {
					index += 1;
					selectedName = l.get(index);
					selectedItem = items.get(index);
					i2 += 40;
					p.repaint();
				}
			}
			else if (e.getKeyCode() == KeyEvent.VK_UP) {
				if (index > 0) {
					index -= 1;
					selectedName = l.get(index);
					selectedItem = items.get(index);
					i2 -= 40;
					p.repaint();
				}
			}
			else if (e.getKeyCode() == KeyEvent.VK_ENTER) {
				p.setVisible(false);
				f1.complete(selectedItem);
				fr.setFocusable(true);
				fr.requestFocusInWindow();	
			}
		}

		@Override
		public void keyReleased(KeyEvent e) {}
		
	}
	
	public void setFocus() {
		p.setFocusable(true);
		p.requestFocusInWindow();
	}

	public void pass(CompletableFuture<AbstractItem> f1, MyFrame fr) {
		this.f1 = f1;
		this.fr = fr;
	}
}
