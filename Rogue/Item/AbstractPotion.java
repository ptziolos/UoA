package Item;

import java.awt.Color;
import java.awt.Graphics;
import java.util.HashSet;
import java.util.Set;

import Draw.TextArea;
import Player.AbstractPlayer;

public abstract class AbstractPotion implements Usable{
	
	private Set<ItemEffect> effects = new HashSet<ItemEffect>();
	
	private String name;
	private int manaToRegain;
	private int hPToRegain;
	private int uses;
	private int x;
	private int y;
	
	public void draw(Graphics g) {
		int tileSize = 10;
		g.setColor(Color.MAGENTA);
		g.fillRect(this.x*tileSize+5, this.y*tileSize+5, 2, 2);
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName() {
		return this.name;
	}
	
	public void setX(int x) {
		this.x = x;
	}
	
	public void setY(int y) {
		this.y = y;
	}
	
	public int getX() {
		return this.x;
	}
	
	public int getY() {
		return this.y;
	}
	
	
	public int usesLeft() {
		return uses;
	}
	
	public void use(AbstractPotion potion, AbstractPlayer player, TextArea area) {
		for(ItemEffect eff: effects) {
			if (eff.getItemEffect().equals(EffectType.HP_REPLENISH)) {
				if (player.getHitPoints() + potion.gethPToRegain() > player.getMaxHitPoints()) {
					player.setHitPoints(player.getMaxHitPoints());
					area.setText(player.getName() + " recovered to full HP");
					potion.reduceUses();
				}
				else {
					player.setHitPoints(player.getHitPoints() + potion.gethPToRegain());
					area.setText(player.getName() + " recovered " + potion.gethPToRegain() +" HP");
					potion.reduceUses();
				}
			}
			else if (eff.getItemEffect().equals(EffectType.MANA_REPLENISH)) {
				if (player.getManaPoints() + potion.getManaToRegain() > player.getMaxManaPoints()) {
					player.setManaPoints(player.getMaxManaPoints());
					area.setText(player.getName() + " recovered to full MP");
					potion.reduceUses();
				}
				else {
					player.setManaPoints(player.getManaPoints() + potion.getManaToRegain());
					area.setText(player.getName() + " recovered " + potion.getManaToRegain() +" MP");
					potion.reduceUses();
				}
			}
		}
	}
	
	public void invokeEffects() {
		for(ItemEffect eff: effects) {
			if (eff.getItemEffect().equals(EffectType.HP_REPLENISH)) {
				sethPToRegain(eff.getAmount());
			}
			else if (eff.getItemEffect().equals(EffectType.MANA_REPLENISH)){
				setManaToRegain(eff.getAmount());
			}
		}
	}
	
	public void setUsesLeft(int uses) {
		this.uses = uses;
	}
	
	public void reduceUses() {
		this.uses -= 1;
	}
	
	public void addEffects(ItemEffect effect) {
		this.effects.add(effect);
		invokeEffects();
	}
	
	
	public void sethPToRegain(int hPToRegain) {
		this.hPToRegain = hPToRegain;
	}
	
	public void setManaToRegain(int manaToRegain) {
		this.manaToRegain = manaToRegain;
	}
	
	
	public Set<ItemEffect> getEffects() {
		return this.effects;
	}
	
	
	public int gethPToRegain() {
		return this.hPToRegain;
	}
	
	public int getManaToRegain() {
		return this.manaToRegain;
	}

}
