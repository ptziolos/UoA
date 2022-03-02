
public class Goblin extends Enemy {
	
	Goblin() {
		super.setLifePoints(10);
		super.setName("Goblin");
		super.addWeapon(new Feeblesword());
	}
	
	public int calculateDamageTaken(damageType dT, int damage) {
		return damage;
	}
	
	public int calculateDamageDealt() {
		return this.getWeapon(0).hit(this.getWeapon(0).getDice());
	}
	
}
