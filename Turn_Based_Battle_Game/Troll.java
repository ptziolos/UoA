
public class Troll extends Enemy {
	
	Troll() {
		super.setLifePoints(35);
		super.setName("Troll");
		super.addWeapon(new Woodenmace());
	}
	
	public int calculateDamageTaken(damageType dT, int damage) {
		if (dT.equals(damageType.SLASHING)) {
			damage = damage / 3;
		}
		return damage;
	}
	
	public int calculateDamageDealt() {
		return this.getWeapon(0).hit(this.getWeapon(0).getDice());
	}
	
}
