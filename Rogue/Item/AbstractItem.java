package Item;

import java.awt.Color;
import java.awt.Graphics;
import java.util.HashSet;
import java.util.Set;

public abstract class AbstractItem implements Equippable{
	
	private SlotType slotType;
	private Set<ItemEffect> effects = new HashSet<ItemEffect>();
	
	private String name;
	private int bonusMana;
	private int bonusHP;
	private int bonusDamage;
	private int bonusIntelligence;
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
	
	public void invokeEffects() {
		for(ItemEffect eff: effects) {
			if (eff.getItemEffect().equals(EffectType.HP_BOOST)) {
				setBonusHP(eff.getAmount());
			}
			else if (eff.getItemEffect().equals(EffectType.DAMAGE_BOOST)){
				setBonusDamage(eff.getAmount());
			}
			else if (eff.getItemEffect().equals(EffectType.MANA_BOOST)) {
				setBonusMana(eff.getAmount());
			}
			else if (eff.getItemEffect().equals(EffectType.INTELLIGENCE_BOOST)) {
				setBonusIntelligence(eff.getAmount());
			}
		}
	}
	
	
	public void setSlotType(SlotType slotType) {
		this.slotType = slotType;
	}
	
	public void addEffects(ItemEffect effect) {
		this.effects.add(effect);
		invokeEffects();
	}
	
	
	public void setBonusHP(int bonusHP) {
		this.bonusHP = bonusHP;
	}
	
	public void setBonusDamage(int bonusDamage) {
		this.bonusDamage = bonusDamage;
	}
	
	public void setBonusMana(int bonusMana) {
		this.bonusMana = bonusMana;
	}
	
	public void setBonusIntelligence(int bonusIntelligence) {
		this.bonusIntelligence = bonusIntelligence;
	}
	
	
	public SlotType getSlotType() {
		return this.slotType;
	}
	
	public Set<ItemEffect> getEffects() {
		return this.effects;
	}
	
	
	public int getBonusHP() {
		return this.bonusHP;
	}
	
	public int getBonusDamage() {
		return this.bonusDamage;
	}
	
	public int getBonusMana() {
		return this.bonusMana;
	}
	
	public int getBonusIntelligence() {
		return this.bonusIntelligence;
	}

}
