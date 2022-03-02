
public class Greatsword extends Weapon {
	
	Greatsword() {
		super.setName("Emerald Sword");
		super.setDescription("A divine sword forged from stone and filled with the might of the angels");
		super.setDT(damageType.SLASHING);
		super.setDice("2d6+1");
	}

}
