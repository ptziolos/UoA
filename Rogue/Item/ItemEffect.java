package Item;

public class ItemEffect implements Item{

	private EffectType effect;
	private int amount;
	
	public ItemEffect(EffectType effect, int amount) {
		setItemEffect(effect);
		setAmount(amount);
	}
	
	
	public void setItemEffect(EffectType effect) {
		this.effect = effect;
	}
	
	public void setAmount(int amount) {
		this.amount = amount;
	}
	
	
	public EffectType getItemEffect() {
		return this.effect;
	}
	
	public int getAmount() {
		return this.amount;
	}
	
}
