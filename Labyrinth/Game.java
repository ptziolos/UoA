import java.util.ArrayList;
import java.util.Scanner;

public class Game {
	
	private ArrayList<Room> rooms = new ArrayList<Room>();
	
	public Game() {
		
	}
	
	public Room defaultGame() {
		Room r1=new Room(), r2=new Room(), r3=new Room(), r4=new Room(), r5=new Room(), r6=new Room(), r7=new Room(), r8=new Room();
		r1.configureRoom("r1","a dark cell",null,null,null,r2);
		r2.configureRoom("r2","a dark underground crossing",null,r4,r1,r3);
		r3.configureRoom("r3","a dead-end corridor",null,r5,r2,null);
		r4.configureRoom("r4","an abandoned wine cellar",r2,null,null,r5);
		r5.configureRoom("r5","a dusty storage room",r3,r6,r4,null);
		r6.configureRoom("r6","a dimly-lit crossing",r5,r7,null,r8);
		r7.configureRoom("r7","an underground well",r6,null,null,null);
		r8.configureRoom("r8","the exit!",null,null,r6,null);
		rooms.add(r1);
		rooms.add(r2);
		rooms.add(r3);
		rooms.add(r4);
		rooms.add(r5);
		rooms.add(r6);
		rooms.add(r7);
		rooms.add(r8);
		return r1;
	}
	
	public Room createMap() {
		try (Scanner s = new Scanner(System.in)) {
			Room initial = null;
			String action = "*";
			while (!action.equals("s")) {
				System.out.println("Press : \"i\" to create a room, \"l\" to link rooms, \"s\" to stop");
				action = s.nextLine();
				if (action.equals("i")) {
					System.out.print("What is the name of the room; \nname : ");
					String name = s.nextLine();
					System.out.print("What is the description of the room; \ndescription : ");
					String description = s.nextLine();
					Room room = new Room(name,description);
					rooms.add(room);
				}else if (action.equals("l")) {
					System.out.print("\nWhat are the names of the rooms you want to link together; \nroom1 : ");
					String room1 = s.nextLine();
					System.out.print("room2 : ");
					String room2 = s.nextLine();
					System.out.println("In which direction should " + room2 + " be linked to " + room1);
					System.out.println("Press : \"north\" for north, \"south\" for south, \"west\" for west, \"east\" for east");
					String link = s.nextLine();
					Room r1 = null, r2 = null;
					for(Room i : rooms) {
						if (i.getName().equals(room1)) {
							r1 = i;
						}
						if (i.getName().equals(room2)) {
							r2 = i;
						}
					}
					if (r1 != null && r2 != null) {
						if (link.equals("north")) {
							r1.setNorth(r2);
							r2.setSouth(r1);
						}else if (link.equals("south")) {
							r1.setSouth(r2);
							r2.setNorth(r1);
						}else if (link.equals("west")) {
							r1.setWest(r2);
							r2.setEast(r1);
						}else if (link.equals("east")) {
							r1.setEast(r2);
							r2.setWest(r1);
						}else {
							System.out.println("The direction " + link + " does not exist");
						}
					}
				}else if (action.equals("s")) {
					action = "s";
					System.out.println("The map is ready");
					int n = 0;
					for (Room i : rooms) {
						 while (n == 0) {
							 initial = i;
							 n++;
						 }
					}
				}
			}
			return initial;
		}
	}
	
	public static void main(String[] args) {
		Scanner s = new Scanner(System.in);
		Game game = new Game();
		Room room;
		String choice = "1";
		System.out.println("Press : \"1\" to create a new map, \"2\" to run default map");
		choice = s.nextLine();
		if (choice.equals("1")) {
			room = game.createMap();
		}else {
			room = game.defaultGame();
		}
		
		String operation = "*";
		Room exit = null;
		for (Room i : game.rooms) {
			exit = i;
		}
		while (!operation.equals("q")) {
			System.out.println("Press : \"r\" to run the game, \"p\" to print the map, \"q\" to quit");
			operation = s.nextLine();
			if (operation.equals("r")) {
				while (!room.getName().equals(exit.getName())) {
					System.out.println("You are in a " + room.getDescription());
					String direction = s.nextLine();
					room = room.moveTo(direction);
				}
				System.out.println("The exit!");
				System.out.println("Congratsulations!!!");
			}else if (operation.equals("p")) {
				for (Room i : game.rooms) {
					i.printRoomInfo();
				}
			}else if (operation.equals("q")) {
				System.out.println("Quit");
				s.close();
			}
		}

	}
	
}
