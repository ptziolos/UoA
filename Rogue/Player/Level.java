package Player;

public class Level {
	
	private int level;
	private int maxLvlExperiencePoints;
	private int minLvlExperiencePoints;
	private int lvlHP;
	private int lvlMana;
	
	private int lvlIntelligence;
	private int lvlAttackDamage;
	
	public Level(int level, int maxLvlExperiencePoints, int minLvlExperiencePoints, int lvlHP, int lvlMana, int lvlattackDamage, int lvlIntelligence) {
		setLevel(level);
		setMaxLvlExperiencePoints(maxLvlExperiencePoints);
		setMinLvlExperiencePoints(minLvlExperiencePoints);
		setLvlHP(lvlHP);
		setLvlMana(lvlMana);
		setLvlAttackDamage(lvlattackDamage);
		setLvlIntelligence(lvlIntelligence);
	}
	
	public void setLevel(int level) {
		this.level = level;
	}
	
	public void setMaxLvlExperiencePoints(int maxLvlExperiencePoints) {
		this.maxLvlExperiencePoints = maxLvlExperiencePoints;
	}
	
	public void setMinLvlExperiencePoints(int minLvlExperiencePoints) {
		this.minLvlExperiencePoints = minLvlExperiencePoints;
	}
	
	public void setLvlHP(int lvlHP) {
		this.lvlHP = lvlHP;
	}
	
	public void setLvlMana(int lvlMana) {
		this.lvlMana = lvlMana;
	}
	
	public void setLvlAttackDamage(int lvlattackDamage) {
		this.lvlAttackDamage = lvlattackDamage;
	}
	
	public void setLvlIntelligence(int lvlIntelligence) {
		this.lvlIntelligence = lvlIntelligence;
	}
	
	
	public int getLevel() {
		return this.level;
	}
	
	public int getMaxLvlExperiencePoints() {
		return this.maxLvlExperiencePoints;
	}
	
	public int getMinLvlExperiencePoints() {
		return this.minLvlExperiencePoints;
	}
	
	public int getLvlHP() {
		return this.lvlHP;
	}
	
	public int getLvlMana() {
		return this.lvlMana;
	}
	
	public int getLvlAttackDamage() {
		return this.lvlAttackDamage;
	}
	
	public int getLvlintelligence() {
		return this.lvlIntelligence;
	}
	
}
