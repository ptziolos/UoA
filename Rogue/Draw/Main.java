package Draw;

import Player.AbstractPlayer;
import Player.Warrior;
import Player.Wizard;

public class Main {

	public static void main(String[] args) {
		if(args.length < 2) {
			System.out.println("Missing arguments");
			System.out.println("Please run as: java rogue.Game " +
			" player-class player-name");
			System.out.println(" where player-class is either " +
			"\"wizard\" or \"warrior\"");
			System.out.println(" and player-name is the " +
			"character name");
			System.exit(0);
		}
		else {
			AbstractPlayer Nekron = null;
			if (args[0].contentEquals("warrior")) {
				Nekron = new Warrior(args[1], 1);
			}
			else if (args[0].contentEquals("wizard")){
				Nekron = new Wizard(args[1], 1);
			}
			new Game(Nekron);
			
		}
	}
}
