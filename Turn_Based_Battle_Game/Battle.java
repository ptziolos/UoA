import java.util.ArrayList;
import java.util.Scanner;

public class Battle {
	
	public static void main(String[] Args) {
		
		int points = 100;
		int result, hitpoints=0, rounds=0, target, weapon, damage;
		Dice d = new Dice();
		ArrayList<Enemy> enemies = new ArrayList<Enemy>();
		ArrayList<Ally> allies = new ArrayList<Ally>();
		Scanner s = new Scanner(System.in);
		
		allies.add(new Warrior()); 
		
		while (points > 0 && hitpoints <= 60) {
			hitpoints = 0;
			result = d.roll(1,20);
			if (result < 10) {
				enemies.add(new Goblin());
			}else if (result >= 10 && result <= 15) {
				enemies.add(new Orc());
			}else if (result > 15 && result <= 20) {
				enemies.add(new Troll());
			}
			for (Enemy i : enemies) {
				hitpoints += i.getLifePoints();
			}
		}
		
		for (Enemy i : enemies) {
			System.out.println("Enemy : "+i.getName());
		}
		 
		
		while (!enemies.isEmpty() && !allies.isEmpty() && enemies.get(0).getLifePoints() > 0 && allies.get(0).getLifePoints() > 0) {
			rounds++;
			System.out.println("\n\\======]  Round " + rounds + "  [======/\n");
			
			for (Enemy i : enemies) {
				System.out.println(i.getName() + " attacks for " + (damage = i.calculateDamageDealt()) + " damage"); 
				allies.get(0).reduceLifepoints(damage);
			}
			System.out.println("\nLife points remaining : " + allies.get(0).getLifePoints() + "\n");
			
			for (Enemy i : enemies) {
				System.out.println("[" + enemies.indexOf(i) + "] " + i.getName() + " [" + i.getLifePoints() + "]");
			}
			System.out.print("\nSelect an enemy to attack :");
			target = s.nextInt();
			System.out.println(); 
			
			for (Weapon i : allies.get(0).getWeapon()) {
				System.out.println("[" + allies.get(0).getWeapon().indexOf(i) + "]" + " Weapon " +  "[" + i.getName() +", Dice" + "[" + i.getDice() + "]" + "]");
			}
			System.out.print("\nSelect a weapon to use :");
			weapon =  s.nextInt();
			
			System.out.println("\nYou attack " + enemies.get(target).getName() + "[" + enemies.get(target).getLifePoints() + "]" +
			" with the weapon " + "[" + allies.get(0).getWeapon(weapon).getName() + ", Dice" + "[" + allies.get(0).getWeapon(weapon).getDice() + "]" + "]" +
			" for " + enemies.get(target).calculateDamageTaken(allies.get(0).getWeapon(weapon).getDT(), damage = allies.get(0).calculateDamageDealt(weapon)) +
			"(" + allies.get(0).getWeapon(weapon).getDT() + ")");
			
			enemies.get(target).reduceLifepoints(enemies.get(target).calculateDamageTaken(allies.get(0).getWeapon(weapon).getDT(), damage));
			
			
			if (enemies.get(target).getLifePoints() <= 0) {
				System.out.println("\n" + enemies.get(target).getName() + "[" + enemies.get(target).getLifePoints() + "]" + "has died"); 
				enemies.remove(target);
			}
		}
		
		if (enemies.isEmpty()) {
			System.out.println("\nYOU WIN");
		}else if (allies.isEmpty()) {
			System.out.println("\nYOU LOSE");
		}
		
		s.close();
		
	}
	
}
