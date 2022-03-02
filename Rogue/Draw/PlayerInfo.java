package Draw;

import java.awt.Color;
import java.awt.Dimension;
import java.util.ArrayList;

import javax.swing.JPanel;

import Item.AbstractItem;
import Item.AbstractPotion;
import Player.AbstractPlayer;
import Player.Observer;

public class PlayerInfo extends JPanel implements Observer {

	private static final long serialVersionUID = 1L;
	
	private final int W = 400;
	private final int H = 580;
	private int startForItems = 0;;
	private PlayerInfoLabel name;
	private PlayerInfoLabel type;
	private PlayerInfoLabel lvl;
	private PlayerInfoLabel hp;
	private PlayerInfoLabel mp;
	private PlayerInfoLabel strength;
	private PlayerInfoLabel intelligence;
	private PlayerInfoLabel item;
	private ArrayList<PlayerInfoLabel> potions = new ArrayList<PlayerInfoLabel>();
	private ArrayList<PlayerInfoLabel> items = new ArrayList<PlayerInfoLabel>();
	private AbstractPlayer player;
	
	public PlayerInfo(AbstractPlayer player) {
		this.player = player;
		this.setBackground(Color.BLACK);
		this.setLayout(null);
		this.setPreferredSize(new Dimension(W, H));
		this.setSize(new Dimension(W, H));
		this.setVisible(true);
		
		this.name = new PlayerInfoLabel("Name : " + player.getName());
		this.type = new PlayerInfoLabel("Type : " + player.getType().toString());
		this.lvl = new PlayerInfoLabel("lvl : " + Integer.toString(player.getLevel()));
		this.hp = new PlayerInfoLabel("HP : " + Integer.toString(player.getHitPoints()) + " / " + Integer.toString(player.getMaxHitPoints()));
		this.mp = new PlayerInfoLabel("Mana : " + Integer.toString(player.getManaPoints()) + " / " + Integer.toString(player.getMaxManaPoints()));
		this.strength = new PlayerInfoLabel("Strength : " + Integer.toString(player.getBaseStrength()));
		this.intelligence = new PlayerInfoLabel("Intelligence : " + Integer.toString(player.getBaseIntelligence()));
		
		
		startForItems = 280;
		for (AbstractItem i : player.getInventory()) {
			this.item = new PlayerInfoLabel("Items : " + i.getName());
			this.item.setBounds(0, startForItems, W, 30);
			startForItems += 40;
			this.items.add(this.item);
		}
		
		for (AbstractPotion i : player.getBag()) {
			this.item = new PlayerInfoLabel(i.getName());
			this.item.setBounds(0, startForItems, W, 30);
			startForItems += 40;
			this.potions.add(this.item);
		}
		
		this.setBounds(0, 0, W,H);
		this.name.setBounds(0, 0, W, 30);
		this.lvl.setBounds(0, 40, W, 30);
		this.type.setBounds(0, 80, W, 30);
		this.hp.setBounds(0, 120, W, 30);
		this.mp.setBounds(0, 160, W, 30);
		this.strength.setBounds(0, 200, W, 30);
		this.intelligence.setBounds(0, 240, W, 30);
		
		this.add(this.name);
		this.add(this.lvl);
		this.add(this.type);
		this.add(this.hp);
		this.add(this.mp);	
		this.add(this.strength);	
		this.add(this.intelligence);
		
		for (PlayerInfoLabel i : this.items) {
			this.add(i);
		}
		
		for (PlayerInfoLabel i : this.potions) {
			this.add(i);
		}
	}
	
	public void update() {
		this.name.setText("Name : " + player.getName());
		this.type.setText("Type : " + player.getType().toString());
		this.lvl.setText("lvl : " + Integer.toString(player.getLevel()));
		this.hp.setText("HP : " + Integer.toString(player.getHitPoints()) + " / " + Integer.toString(player.getMaxHitPoints()));
		this.mp.setText("Mana : " + Integer.toString(player.getManaPoints())+ " / " + Integer.toString(player.getMaxManaPoints()));
		this.strength.setText("Strength : " + Integer.toString(player.getBaseStrength()));
		this.intelligence.setText("Intelligence : " + Integer.toString(player.getBaseIntelligence()));
		
		for (PlayerInfoLabel i : this.items) {
			this.remove(i);
		}
		
		for (PlayerInfoLabel i : this.potions) {
			this.remove(i);
		}
		
		startForItems = 280;
		for (AbstractItem i : player.getInventory()) {
			this.item = new PlayerInfoLabel("Items : " + i.getName());
			this.item.setBounds(0, startForItems, W, 30);
			startForItems += 40;
			this.add(this.item);
			this.items.add(this.item);
		}
		
		for (AbstractPotion i : player.getBag()) {
			this.item = new PlayerInfoLabel(i.getName());
			this.item.setBounds(0, startForItems, W, 30);
			startForItems += 40;
			this.add(this.item);
			this.potions.add(this.item);
		}
		
		this.repaint();
	}
	
}
