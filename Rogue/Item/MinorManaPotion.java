package Item;


public class MinorManaPotion extends AbstractPotion{

	public MinorManaPotion() {
		super.setName("Minor Mana Potion");
		super.addEffects(new ItemEffect(EffectType.MANA_REPLENISH, 10));
		super.setUsesLeft(10);
	}
	
}
