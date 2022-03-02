package Item;

public class MinorHealthPotion extends AbstractPotion{

	public MinorHealthPotion() {
		super.setName("Minor Health Potion");
		super.addEffects(new ItemEffect(EffectType.HP_REPLENISH, 5));
		super.setUsesLeft(10);
	}
	
}
