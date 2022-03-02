package Item;

public class WristBandOfMana extends AbstractItem{
	
	public WristBandOfMana() {
		super.setName("Wrist Band Of Mana");
		super.setSlotType(SlotType.HAND);
		super.addEffects(new ItemEffect(EffectType.MANA_BOOST, 5));
	}
	
}
