package Item;

public class RelicOfTheAncients extends AbstractItem{
	
	public RelicOfTheAncients() {
		super.setName("Relic Of The Ancients");
		super.setSlotType(SlotType.NECK);
		super.addEffects(new ItemEffect(EffectType.HP_BOOST, 80));
		super.addEffects(new ItemEffect(EffectType.DAMAGE_BOOST, 42));
	}

}
