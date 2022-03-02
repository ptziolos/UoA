import java.util.ArrayList;

public abstract class Ally {
	
	private int lifePoints;
	private String name;
	private ArrayList<Weapon> weapon = new ArrayList<Weapon>();
	
	public abstract int calculateDamageTaken(damageType dT, int damage);
	public abstract int calculateDamageDealt(int weapon);

	public void reduceLifepoints(int damage) {
		this.lifePoints-=damage;
	}
	
	public int getLifePoints() {
		return lifePoints;
	}

	public void setLifePoints(int lifePoints) {
		this.lifePoints = lifePoints;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ArrayList<Weapon> getWeapon() {
		return weapon;
	}
	
	public Weapon getWeapon(int i) {
		return weapon.get(i);
	}

	public void addWeapon(Weapon weapon) {
		this.weapon.add(weapon);
	}
}
