package Player;

import java.util.ArrayList;

import Enemy.AbstractEnemy;
import Item.Slot;
import Item.SlotType;

public class Wizard extends AbstractPlayer{

	public Wizard(String name , int level) {
		super.setName(name);
		super.setLevel(level);
		//setArea(area);
		setType(PlayerType.WIZARD);
		setInitHitPoints(20);
		setInitBaseStrength(0);
		setInitBaseIntelligence(10);
		setInitManaPoints(30);
		setArmory(1);
		
		Level lv1 = new Level(1, 299, 0, 0, 0, 0, 0);
		addLevels(1, lv1);
		
		Level lv2 = new Level(2, 899, 300, 20, 20, 0, 10);
		addLevels(2, lv2);
		
		Level lv3 = new Level(3, 2699, 900, 10, 20, 0, 10);
		addLevels(3, lv3);
		
		Level lv4 = new Level(4, 6499, 2700, 5, 20, 0, 10);
		addLevels(4, lv4);
		
		Level lv5 = new Level(5, 13999, 6500, 5, 20, 0, 10);
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
		ArrayList<AbstractEnemy> enemies = new ArrayList<AbstractEnemy>();
		
		for (AbstractEnemy i : e) {
			if (i.getX() == getX() && i.getY() == getY()) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+1 && i.getY() == getY()) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-1 && i.getY() == getY()) {
				enemies.add(i);
			}
			else if (i.getX() == getX() && i.getY() == getY()+1) {
				enemies.add(i);
			}
			else if (i.getX() == getX() && i.getY() == getY()-1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+1 && i.getY() == getY()+1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-1 && i.getY() == getY()-1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-1 && i.getY() == getY()+1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+1 && i.getY() == getY()-1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+2 && i.getY() == getY()) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-2 && i.getY() == getY()) {
				enemies.add(i);
			}
			else if (i.getX() == getX() && i.getY() == getY()+2) {
				enemies.add(i);
			}
			else if (i.getX() == getX() && i.getY() == getY()-2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+2 && i.getY() == getY()+1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+2 && i.getY() == getY()-1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-2 && i.getY() == getY()+1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-2 && i.getY() == getY()-1) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+1 && i.getY() == getY()+2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+1 && i.getY() == getY()-2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-1 && i.getY() == getY()+2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-1 && i.getY() == getY()-2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+2 && i.getY() == getY()+2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()+2 && i.getY() == getY()-2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-2 && i.getY() == getY()+2) {
				enemies.add(i);
			}
			else if (i.getX() == getX()-2 && i.getY() == getY()-2) {
				enemies.add(i);
			}
		}
		
		if (getManaPoints() >= 5 && enemies.size() > 0) {
			getArea().clear();
			for (AbstractEnemy i : enemies)
			{
				if (i.getHitPoints() > 0) {
					i.takeDamage(getBaseIntelligence());
					if (i.getHitPoints() > 0) {
						getArea().addText(i.getName() + " has " + i.getHitPoints() + " Hp");
					}
					
				}
				
				if (i.getHitPoints() <= 0) {
					getArea().addText(i.getName() + " is dead \n");
					addXP(i.getXP());
					update();
				}
			}
			
			enemies.clear();
			
			setManaPoints(getManaPoints()-5);
		}
		else if (getManaPoints() < 5){
			getArea().setText("Not enough Mana");
		}
		else if (enemies.size() < 1){
			getArea().setText("No enemies nearby");
		}
		
	}
	
}
