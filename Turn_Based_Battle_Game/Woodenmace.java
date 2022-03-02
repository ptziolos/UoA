
public class Woodenmace extends Weapon{
	Woodenmace() {
		super.setName("Wooden mace");
		super.setDescription("A wooden trunk used by Troll");
		super.setDT(damageType.BLUNT);
		super.setDice("1d6+1");
	}
}
