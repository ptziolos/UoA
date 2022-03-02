package Item;

public class RingOfHealth extends AbstractItem{
	
	public RingOfHealth() {
		super.setName("Ring Of Health");
		super.setSlotType(SlotType.FINGER);
		super.addEffects(new ItemEffect(EffectType.HP_BOOST, 10));
		super.addEffects(new ItemEffect(EffectType.DAMAGE_BOOST, 3));
	}
	
}
