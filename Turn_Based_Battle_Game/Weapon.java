enum damageType {BLUNT, SLASHING};

public abstract class Weapon {
	
	private damageType dT;
	private String dice;
	private String description;
	private String name;
	private int damage;
	
	public int hit(String dice) {
		
		Dice d = new Dice();
		int n, s, bonus;
		
		n = Integer.parseInt(String.valueOf(dice.charAt(0)));
		s = Integer.parseInt(String.valueOf(dice.charAt(2)));
		bonus = Integer.parseInt(String.valueOf(dice.charAt(4)));
		
		damage = d.roll(n,s) + bonus;
		
		return damage;
	}

	public damageType getDT() {
		return dT;
	}

	public void setDT(damageType dT) {
		this.dT = dT;
	}

	public String getDice() {
		return dice;
	}

	public void setDice(String dice) {
		this.dice = dice;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getDamage() {
		return damage;
	}

	public void setDamage(int damage) {
		this.damage = damage;
	}
	
	
}
