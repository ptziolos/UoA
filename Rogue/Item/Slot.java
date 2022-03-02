package Item;

import java.util.HashSet;
import java.util.Set;

public class Slot {

	private SlotType slotType;
	private int capacity;
	
	private int bonusManaPoints = 0;
	private int bonusHitPoints = 0;
	private int bonusBaseStrength = 0;
	private int bonusBaseIntelligence = 0;
	
	private Set<AbstractItem> items = new HashSet<AbstractItem>();
	
	public Slot(SlotType chest, int capacity) {
		setSlotType(chest);
		setCapacity(capacity);
	}
	
	
	public void setSlotType(SlotType slotType) {
		this.slotType = slotType;
	}
	
	public void setCapacity(int capacity){
		this.capacity = capacity;
	}
	
	
	public SlotType getSlotType() {
		return this.slotType;
	}
	
	public int getCapacity() {
		return this.capacity;
	}
	
	public Set<AbstractItem> getItems() {
		return this.items;
	}
	
	
	public boolean equip(AbstractItem item){
		
		if (capacity > 0) {
			items.add(item);
			capacity -= 1;
			return true;
		} 
		else {
			return false;
		}
	}
	
	public void remove(Equippable item){

		items.remove(item);
		capacity += 1;
		
	}
	
	private void setBonusManaPoints() {
		this.bonusManaPoints = 0;
		if (!getItems().isEmpty()) {
			for (AbstractItem i: getItems()) {
				this.bonusManaPoints +=i.getBonusMana();
			}
		}
	}
	
	private void setBonusHitPoints() {
		this.bonusHitPoints = 0;
		for (AbstractItem i: getItems()) {
			this.bonusHitPoints +=i.getBonusHP();
		}
	}
	
	private void setBonusBaseStrength() {
		this.bonusBaseStrength = 0;
		if (!getItems().isEmpty()) {
			for (AbstractItem i: getItems()) {
				this.bonusBaseStrength +=i.getBonusDamage();
			}
		}
	}
	
	private void setBonusBaseIntelligence() {
		this.bonusBaseIntelligence = 0;
		if (!getItems().isEmpty()) {
			for (AbstractItem i: getItems()) {
				this.bonusBaseIntelligence +=i.getBonusIntelligence();
			}
		}
	}
	
	public int getBonusManaPoints(){
		setBonusManaPoints();
		return this.bonusManaPoints;
	}
	
	public int getBonusHitPoints() {
		setBonusHitPoints();
		return this.bonusHitPoints;
	}
	
	public int getBonusBaseStrength() {
		setBonusBaseStrength();
		return this.bonusBaseStrength;
	}
	
	public int getBonusBaseIntelligence() {
		setBonusBaseIntelligence();
		return this.bonusBaseIntelligence;
	}
	
}
