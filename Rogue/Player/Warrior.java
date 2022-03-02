package Player;

import java.util.ArrayList;

import Enemy.AbstractEnemy;
import Item.Slot;
import Item.SlotType;

public class Warrior extends AbstractPlayer{

	public Warrior(String name ,int level) {
		super.setName(name);
		super.setLevel(level);
		//setArea(area);
		setType(PlayerType.WARRIOR);
		setInitHitPoints(30);
		setInitBaseStrength(10);
		setInitBaseIntelligence(0);
		setInitManaPoints(0);
		setArmory(1);
		
		Level lv1 = new Level(1, 299, 0, 0, 0, 0, 0);
		addLevels(1, lv1);
		
		Level lv2 = new Level(2, 899, 300, 30, 0, 10, 0);
		addLevels(2, lv2);
		
		Level lv3 = new Level(3, 2699, 900, 20, 0, 5, 0);
		addLevels(3, lv3);
		
		Level lv4 = new Level(4, 6499, 2700, 10, 0, 5, 0);
		addLevels(4, lv4);
		
		Level lv5 = new Level(5, 13999, 6500, 10, 0, 5, 0);
		addLevels(5, lv5);
		
		
		Slot sl1 = new Slot(SlotType.CHEST, 1);
		addSlots(SlotType.CHEST, sl1);
		
		Slot sl2 = new Slot(SlotType.FINGER, 10);
		addSlots(SlotType.FINGER, sl2);
		
		Slot sl3 = new Slot(SlotType.HAND, 2);
		addSlots(SlotType.HAND, sl3);
		
		Slot sl4 = new Slot(SlotType.NECK, 1);
		addSlots(SlotType.NECK, sl4);
		
		Slot sl5 = new Slot(SlotType.LEGS, 2);
		addSlots(SlotType.LEGS, sl5);
		
		setSlotIndices(SlotType.CHEST);
		setSlotIndices(SlotType.FINGER);
		setSlotIndices(SlotType.HAND);
		setSlotIndices(SlotType.NECK);
		setSlotIndices(SlotType.LEGS);
		
		super.setMaxHitPoints();
		super.setMaxManaPoints();
		super.setMaxBaseStrength();
		super.setMaxBaseIntelligence();
		
		super.setHitPoints(getMaxHitPoints());
		super.setManaPoints(getMaxManaPoints());
		super.setBaseStrength(getMaxBaseStrength());
		super.setBaseIntelligence(getMaxBaseIntelligence());
		super.setExperiencePoints(0);
	}
	
	public void attack(ArrayList<AbstractEnemy> e) {
		AbstractEnemy enemy = null;
		
		for (AbstractEnemy i : e) {
			if (i.getX() == getX() && i.getY() == getY()) {
				if (enemy == null) {
					enemy = i;
				}
				else if (i.getHitPoints() < enemy.getHitPoints()) {
					enemy = i;
				}
			}
			else if (i.getX() == getX()+1 && i.getY() == getY()) {
				if (enemy == null) {
					enemy = i;
				}
				else if (i.getHitPoints() < enemy.getHitPoints()) {
					enemy = i;
				}
			}
			else if (i.getX() == getX()-1 && i.getY() == getY()) {
				if (enemy == null) {
					enemy = i;
				}
				else if (i.getHitPoints() < enemy.getHitPoints()) {
					enemy = i;
				}
			}
			else if (i.getX() == getX() && i.getY() == getY()+1) {
				if (enemy == null) {
					enemy = i;
				}
				else if (i.getHitPoints() < enemy.getHitPoints()) {
					enemy = i;
				}
			}
			else if (i.getX() == getX() && i.getY() == getY()-1) {
				if (enemy == null) {
					enemy = i;
				}
				else if (i.getHitPoints() < enemy.getHitPoints()) {
					enemy = i;
				}
			}
		}
		
		if (enemy != null) {
			enemy.takeDamage(getBaseStrength());
			
			if (enemy.getHitPoints() > 0) {
				enemy.takeDamage(getBaseIntelligence());
				if (enemy.getHitPoints() > 0) {
					getArea().setText(enemy.getName() + " has " + enemy.getHitPoints() + " Hp");
				}
				
			}
			
			if (enemy.getHitPoints() <= 0) {
				getArea().setText(enemy.getName() + " is dead \n");
				addXP(enemy.getXP());
				update();
			}
		}
		
	}	
}
