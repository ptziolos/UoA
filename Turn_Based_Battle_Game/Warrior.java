
public class Warrior extends Ally {
	
	Warrior() {
		super.setLifePoints(200);
		super.setName("Dargor");
		super.addWeapon(new Greatsword());
		super.addWeapon(new Warhammer());
	}
	
	public int calculateDamageTaken(damageType dT, int damage) {
		return damage;
	}
	
	public int calculateDamageDealt(int weapon) {
		return this.getWeapon(weapon).hit(this.getWeapon(weapon).getDice());
	}
	
	/*@Override
	public String toString() {
		return new StringBuilder().append(this.getName()).append(" attacks for ").append(this.calculateDamageDealt()).append(" damage").toString();
	}*/

}
