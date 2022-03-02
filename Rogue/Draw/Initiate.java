package Draw;

import java.util.ArrayList;
import java.util.Random;

import Enemy.AbstractEnemy;
import Item.AbstractItem;
import Item.AbstractPotion;
import Item.MinorHealthPotion;
import Item.MinorManaPotion;
import Item.RelicOfTheAncients;
import Item.RingOfDestruction;
import Item.RingOfHealth;
import Item.WristBandOfMana;
import Player.AbstractPlayer;

public class Initiate {
	
	private Random ran = new Random();
	
	public Initiate(Map map, AbstractPlayer player, ArrayList<AbstractEnemy> e, ArrayList<AbstractPotion> potions, ArrayList<AbstractItem> items) {
		createItems(map, items);
		createPotions(map, potions);
	}

	public void createItems(Map map, ArrayList<AbstractItem> items) {
		items.add(new RelicOfTheAncients());
		items.add(new RingOfDestruction());
		items.add(new RingOfHealth());
		items.add(new WristBandOfMana());
		
		ArrayList<Integer> k = new ArrayList<Integer>();
		ArrayList<Integer> l = new ArrayList<Integer>();
		
		for (int i=0; i<map.getNX(); i++) {
			for (int j=0; j<map.getNY(); j++) {
				if (!map.getMap()[i][j].equals("wall")) {
					k.add(i);
					l.add(j);
				}
			}
		}
		
		for (AbstractItem item : items) {
			int t = ran.nextInt(k.size());
			item.setX(k.get(t));
			item.setY(l.get(t));
			map.getTreasureMap()[k.get(t)][l.get(t)] = "item";
			k.remove(k.get(t));
			l.remove(l.get(t));
		}
	}
	
	public void createPotions(Map map, ArrayList<AbstractPotion> potions) {
		potions.add(new MinorHealthPotion());
		potions.add(new MinorHealthPotion());
		potions.add(new MinorHealthPotion());
		potions.add(new MinorManaPotion());
		potions.add(new MinorManaPotion());
		potions.add(new MinorManaPotion());
		
		ArrayList<Integer> k = new ArrayList<Integer>();
		ArrayList<Integer> l = new ArrayList<Integer>();
		
		for (int i=0; i<map.getNX(); i++) {
			for (int j=0; j<map.getNY(); j++) {
				if (!map.getMap()[i][j].equals("wall")) {
					k.add(i);
					l.add(j);
				}
			}
		}
		
		for (AbstractPotion potion : potions) {
			int t = ran.nextInt(k.size());
			potion.setX(k.get(t));
			potion.setY(l.get(t));
			map.getTreasureMap()[k.get(t)][l.get(t)] = "potion";
			k.remove(k.get(t));
			l.remove(l.get(t));
		}
		
	}
	
	
	
}
