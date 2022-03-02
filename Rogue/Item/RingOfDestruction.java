package Item;

public class RingOfDestruction extends AbstractItem{
	
	public RingOfDestruction() {
		super.setName("Ring Of Destruction");
		super.setSlotType(SlotType.FINGER);
		super.addEffects(new ItemEffect(EffectType.DAMAGE_BOOST, 12));
	}
	
}
