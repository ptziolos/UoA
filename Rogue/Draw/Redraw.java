package Draw;

import java.awt.Dimension;
import java.awt.Graphics;
import java.util.ArrayList;

import javax.swing.JComponent;

import Enemy.AbstractEnemy;
import Item.AbstractItem;
import Item.AbstractPotion;
import Player.AbstractPlayer;

public class Redraw extends JComponent{
	
	private static final long serialVersionUID = 1L;
	Map map;
	AbstractPlayer p;
	ArrayList<AbstractEnemy> e;
	ArrayList<AbstractPotion> potions;
	ArrayList<AbstractItem> items;

	public Redraw(Map map, AbstractPlayer p, ArrayList<AbstractEnemy> e, ArrayList<AbstractPotion> potions, ArrayList<AbstractItem> items) {
		this.map = map;
		this.p = p;
		this.e = e;
		this.items = items;
		this.potions = potions;
		this.setPreferredSize(new Dimension(900, 580));
		this.setSize(900, 580);
	}
	
	public void paintComponent(Graphics g) {
		map.draw(g);
		p.draw(g);
		for (AbstractEnemy i : e) {
			if (Math.sqrt(Math.pow(p.getX() - i.getX(), 2) + Math.pow(p.getY() - i.getY(), 2)) < p.getVision()){
				i.draw(g);
			}
		}
		for (AbstractPotion i : potions)
			if (Math.sqrt(Math.pow(p.getX() - i.getX(), 2) + Math.pow(p.getY() - i.getY(), 2)) < p.getVision()){
				i.draw(g);
			}
		for(AbstractItem i : items)
			if (Math.sqrt(Math.pow(p.getX() - i.getX(), 2) + Math.pow(p.getY() - i.getY(), 2)) < p.getVision()){
				i.draw(g);
			}
	}

}
