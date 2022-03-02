
public class Orc extends Enemy{
	
	Orc() {
		super.setLifePoints(20);
		super.setName("Orc");
		super.addWeapon(new Feeblemace());
	}
	
	public int calculateDamageTaken(damageType dT, int damage) {
		if (dT.equals(damageType.BLUNT)) {
			damage = damage / 2;
		}
		return damage;
	}
	
	public int calculateDamageDealt() {
		return this.getWeapon(0).hit(this.getWeapon(0).getDice());
	}

}
