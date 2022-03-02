package Draw;

import java.awt.Container;
import java.awt.Dimension;
import java.util.ArrayList;

import javax.swing.SpringLayout;

import Enemy.AbstractEnemy;
import Item.AbstractItem;
import Item.AbstractPotion;
import Player.AbstractPlayer;
import Player.Key;

public class Game {

	private AbstractPlayer Nekron;
	private Redraw r;
	
	public Game(AbstractPlayer Nekron)  {
		this.Nekron = Nekron;
		start(this.Nekron);
	}

	private void start(AbstractPlayer Nekron) {
		TextArea area = new TextArea();	
		this.Nekron.setArea(area);
		
		Map map = new Map(Nekron);
		ItemMenu iMenu = new ItemMenu();
		PotionMenu pMenu = new PotionMenu();
		PlayerInfo info = new PlayerInfo(Nekron);
		
		Nekron.addObserver(info);
		
		ArrayList<AbstractEnemy> e = new ArrayList<AbstractEnemy>();
		ArrayList<AbstractPotion> potions = new ArrayList<AbstractPotion>();
		ArrayList<AbstractItem> items = new ArrayList<AbstractItem>();
		
		new Initiate(map, Nekron, e, potions, items);
		
		r = new Redraw(map, Nekron, e, potions, items);
		MyFrame frame = new MyFrame();
		
		
		frame.setPreferredSize(new Dimension(1400,800));
		frame.setSize(new Dimension(1400,800));
		frame.pack();
		Container c = frame.getContentPane();
		frame.addKeyListener(new Key(map, Nekron, r, e, potions, items, iMenu, pMenu, frame, info, area));
		
		SpringLayout sp = new SpringLayout();
		c.setLayout(sp);
		
		c.add(r);
		c.add(iMenu);
		c.add(pMenu);
		c.add(info);
		c.add(area);
		
		sp.putConstraint(SpringLayout.WEST, r, 0, SpringLayout.WEST, c);
		sp.putConstraint(SpringLayout.NORTH, r, 0, SpringLayout.NORTH, c);
		
		sp.putConstraint(SpringLayout.WEST, iMenu, 990, SpringLayout.WEST, c);
		sp.putConstraint(SpringLayout.NORTH, iMenu, 0, SpringLayout.NORTH, c);
		
		sp.putConstraint(SpringLayout.WEST, pMenu, 990, SpringLayout.WEST, c);
		sp.putConstraint(SpringLayout.NORTH, pMenu, 0, SpringLayout.NORTH, c);
		
		sp.putConstraint(SpringLayout.WEST, info, 920, SpringLayout.WEST, c);
		sp.putConstraint(SpringLayout.NORTH, info, 0, SpringLayout.NORTH, c);
		
		sp.putConstraint(SpringLayout.WEST, area, 0, SpringLayout.WEST, c);
		sp.putConstraint(SpringLayout.NORTH, area, 580, SpringLayout.NORTH, c);
	}
}
