package Player;

import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Draw.TextArea;
import Enemy.AbstractEnemy;
import Item.AbstractItem;
import Item.AbstractPotion;
import Item.Slot;
import Item.SlotType;


public abstract class AbstractPlayer implements Subject {
	
	private ArrayList<Observer> observers = new ArrayList<Observer>();
	
	private String name;
	private PlayerType type;
	
	private TextArea area;	
	
	private int initHitPoints;
	private int initManaPoints;
	private int initBaseStrength;
	private int initBaseIntelligence;
	
	private int hitPoints;
	private int manaPoints;
	private int baseStrength;
	private int baseIntelligence;
	private int experiencePoints;
	private int level;
	
	private int maxHitPoints;
	private int maxManaPoints;
	private int maxBaseStrength;
	private int maxBaseIntelligence;
	
	private int x;
	private int y;
	private int armory;
	private int vision = 6;
	
	private Map<SlotType, Slot> slots = new HashMap<SlotType, Slot>();
	private Map<Integer, Level> levels = new HashMap<Integer, Level>();
	private List<AbstractItem> inventory = new ArrayList<AbstractItem>();
	private List<AbstractPotion> bag = new ArrayList<AbstractPotion>();
	private List<SlotType> slotIndices = new ArrayList<SlotType>();
	
	
	public void move(int x, int y) {
		this.x = getX() + x;
		this.y = getY() + y;
	}
	
	public void draw(Graphics g) {
		int tileSize = 10;
		g.setColor(Color.GREEN);
		g.fillRect(this.x*tileSize+2, this.y*tileSize+2, 8, 8);
	}
	
	public void restoreHP() {
		area.clear();
		if (getHitPoints() + 10 > getMaxHitPoints()) {
			setHitPoints(getMaxHitPoints());
			area.addText(getName() + " recovered to full HP");
		}
		else {
			setHitPoints(getHitPoints() + 10);
			area.addText(getName() + " recovered 10 HP");
		}
	}
	
	public void restoreMP() {
		if (getManaPoints() + 10 > getMaxManaPoints()) {
			setManaPoints(getMaxManaPoints());
			area.addText(getName() + " recovered to full MP");
		}
		else {
			setManaPoints(getManaPoints()+10);
			area.addText(getName() + " recovered 10 MP");
		}
	}
	
	public abstract void attack(ArrayList<AbstractEnemy> e);
	
	public void setArea(TextArea area) {
		this.area = area;
	}
	
	public TextArea getArea() {
		return this.area;
	}
	
	public void setType(PlayerType type) {
		this.type = type;
	}
	
	public PlayerType getType() {
		return this.type;
	}
	
	public void pickUp(AbstractItem item) {
		this.inventory.add(item);
	}
	
	public void drop(AbstractItem item) {
		this.inventory.remove(item);
	}
	
	public List<AbstractItem> getInventory(){
		return this.inventory;
	}
	
	public void setArmory(int n) {
		this.armory = n;
	}
	
	public int getArmory() {
		return this.armory;
	}
	
	public void takeDamage(int damage) {
		this.hitPoints -= damage;
	}
	
	public void setX(int x) {
		this.x = x;
	}
	
	public int getX() {
		return x;
	}
	
	public void setY(int y) {
		this.y = y;
	}
	
	public int getY() {
		return y;
	}
	
	public void setVision(int vision) {
		this.vision = vision;
	}
	
	public int getVision() {
		return this.vision;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName(){
		return this.name;
	}
	
	public void setSlotIndices(SlotType type) {
		this.slotIndices.add(type);
	}
	
	public List<SlotType> getSlotIndices(){
		return this.slotIndices;
	}
	
	public List<AbstractPotion> getBag(){
		return this.bag;
	}
	
	public void pickUp(AbstractPotion potion) {
		boolean q = false;
		for (AbstractPotion p: bag) {
			if (p.getName().equals(potion.getName())) {
				p.setUsesLeft(p.usesLeft() + potion.usesLeft());
				q = true;
			}
		}
		if (q == false) {
			this.bag.add(potion);
		}
		
	}
	
	public void drop(AbstractPotion potion) {
		if (bag.contains(potion)) {
			this.bag.remove(potion);
		}
	}
	
	public void addXP(int xp) {
		this.experiencePoints += xp;
	}
	
	public void removeXP(int xp) {
		this.experiencePoints -= xp;
	}
	
	public void setInitHitPoints(int initHitPoints) {
		this.initHitPoints = initHitPoints;
	}
	
	public void setInitManaPoints(int initManaPoints) {
		this.initManaPoints = initManaPoints;
	}
	
	public void setInitBaseStrength(int initBaseStrength) {
		this.initBaseStrength = initBaseStrength;
	}
	
	public void setInitBaseIntelligence(int initBaseIntelligence) {
		this.initBaseIntelligence = initBaseIntelligence;
	}
	
	public void setHitPoints(int hitPoints) {
		this.hitPoints = hitPoints;
	}
	
	public void setManaPoints(int manaPoints) {
		this.manaPoints = manaPoints;
	}
	
	public void setBaseStrength(int baseStrength) {
		this.baseStrength = baseStrength;
	}
	
	public void setBaseIntelligence(int baseIntelligence) {
		this.baseIntelligence = baseIntelligence;
	}
	
	public void setExperiencePoints(int experiencePoints) {
		this.experiencePoints = experiencePoints;
	}
	
	public void setLevel(int level) {
		this.level = level;
	}
	
	public void addSlots(SlotType type, Slot slot) {
		this.slots.put(type, slot);
	}
	
	public void addLevels(int i, Level level) {
		this.levels.put(i, level);
	}
	
	public void setMaxHitPoints() {
		int HP = 0;
		for (SlotType s : getSlotIndices()) {
			HP += getSlots().get(s).getBonusHitPoints();
		}
		for(int i=1; i <= getLevel(); i++) {
			HP += getLevels().get(i).getLvlHP();
		}
		this.maxHitPoints = getInitHitPoints() + HP;
	}
	
	public void setMaxManaPoints() {
		int MP = 0;
		for (SlotType s : getSlotIndices()) {
			MP += getSlots().get(s).getBonusManaPoints();
		}
		for(int i=1; i <= getLevel(); i++) {
			MP += getLevels().get(i).getLvlMana();
		}
		this.maxManaPoints = getInitManaPoints() + MP;
	}
	
	public void setMaxBaseStrength() {
		int BS = 0;
		for (SlotType s : getSlotIndices()) {
			BS += getSlots().get(s).getBonusBaseStrength();
		}
		for(int i=1; i <= getLevel(); i++) {
			BS += getLevels().get(i).getLvlAttackDamage();
		}
		this.maxBaseStrength = getInitBaseStrength() + BS;
	}
	
	public void setMaxBaseIntelligence() {
		int BI = 0;
		for (SlotType s : getSlotIndices()) {
			BI += getSlots().get(s).getBonusBaseIntelligence();
		}
		for(int i=1; i <= getLevel(); i++) {
			BI += getLevels().get(i).getLvlintelligence();
		}
		this.maxBaseIntelligence = getInitBaseIntelligence() + BI;
	}
	
	
	public int getInitHitPoints() {
		return this.initHitPoints;
	}
	
	public int getInitManaPoints() {
		return this.initManaPoints;
	}
	
	public int getInitBaseStrength() {
		return this.initBaseStrength;
	}
	
	public int getInitBaseIntelligence() {
		return this.initBaseIntelligence;
	}
	
	public int getHitPoints() {
		return this.hitPoints;
	}
	
	public int getManaPoints() {
		return this.manaPoints;
	}
	
	public int getBaseStrength() {
		return this.baseStrength;
	}
	
	public int getBaseIntelligence() {
		return this.baseIntelligence;
	}
	
	public int getExperiencePoints() {
		return this.experiencePoints;
	}
	
	public int getLevel() {
		return this.level;
	}
	
	
	public Map<SlotType, Slot> getSlots() {
		return this.slots;
	}
	
	public Map<Integer, Level> getLevels() {
		return this.levels;
	}
	
	
	public int getMaxHitPoints() {
		return this.maxHitPoints;
	}
	
	public int getMaxManaPoints() {
		return this.maxManaPoints;
	}
	
	public int getMaxBaseStrength() {
		return this.maxBaseStrength;
	}
	
	public int getMaxBaseIntelligence() {
		return this.maxBaseIntelligence;
	}
	
	public void update() {
		int hp = getMaxHitPoints() - getHitPoints();
		int mp = getMaxManaPoints() - getManaPoints();
		int bs = getMaxBaseStrength() - getBaseStrength();
		int bi = getMaxBaseIntelligence() - getBaseIntelligence();
		
		if (getExperiencePoints() > getLevels().get(1).getMinLvlExperiencePoints() && getExperiencePoints() < getLevels().get(1).getMaxLvlExperiencePoints()) {
			setLevel(1);
		}
		else if (getExperiencePoints() > getLevels().get(2).getMinLvlExperiencePoints() && getExperiencePoints() < getLevels().get(2).getMaxLvlExperiencePoints()) {
			setLevel(2);
		}
		else if (getExperiencePoints() > getLevels().get(3).getMinLvlExperiencePoints() && getExperiencePoints() < getLevels().get(3).getMaxLvlExperiencePoints()) {
			setLevel(3);
		}
		else if (getExperiencePoints() > getLevels().get(4).getMinLvlExperiencePoints() && getExperiencePoints() < getLevels().get(4).getMaxLvlExperiencePoints()) {
			setLevel(4);
		}
		else if (getExperiencePoints() > getLevels().get(4).getMaxLvlExperiencePoints()) {
			setLevel(5);
		}
		
		setMaxHitPoints();
		setMaxManaPoints();
		setMaxBaseStrength();
		setMaxBaseIntelligence();
	
		setHitPoints(getMaxHitPoints() - hp);
		setManaPoints(getMaxManaPoints() - mp);
		setBaseStrength(getMaxBaseStrength() - bs);
		setBaseIntelligence(getMaxBaseIntelligence() - bi);
	}
	
	@Override
	public void addObserver(Observer o) {
		this.observers.add(o);
	}
	
	@Override
	public void notifyObservers() {
		for (Observer o : this.observers)
			o.update();
	}

	public boolean isDead() {
		if (this.hitPoints <= 0) {
			return true;
		}
		else
			return false;
	}
}
