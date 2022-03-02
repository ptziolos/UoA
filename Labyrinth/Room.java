
public class Room {
	
	private String name;
	private String description;
	private Room north;
	private Room south;
	private Room west;
	private Room east;
	
	public Room() {
		
	}
	
	public Room (String aName, String aDescription) {
		name = aName;
		description = aDescription;
		north = null;
		south = null;
		west = null;
		east = null;
	}
	
	public void configureRoom (String aName, String aDescription, Room aNorth, Room aSouth, Room aWest, Room anEast) {
		name = aName;
		description = aDescription;
		north = aNorth;
		south = aSouth;
		west = aWest;
		east = anEast;
	}
	
	public void setNorth (Room aNorth) {
		north = aNorth;
	}
	
	public void setSouth(Room aSouth) {
		south = aSouth;
	}
	
	public void setWest(Room aWest) {
		west = aWest;
	}
	
	public void setEast(Room anEast) {
		east = anEast;
	}
	
	public String getName() {
		return name;
	}
	
	public String getDescription() {
		return description;
	}
	
	public Room moveTo(String direction) {
		if (north != null && direction.equals("north")) {
			return north;
		}else if (south != null && direction.equals("south")) {
			return south;
		}else if (west != null && direction.equals("west")) {
			return west;
		}else if (east != null && direction.equals("east")) {
			return east;
		}else {
			System.out.println("You cant go there!");
			return this;
		}
	}
	
	public void printRoomInfo() {
		System.out.println("\nThe room " + name + " is " + description + " and");
		if (north != null) {
			System.out.println("is neighbouring north with room " + north.getName());
		}
		if (south != null) {
			System.out.println("is neighbouring south with room " + south.getName());
		}
		if (west != null) {
			System.out.println("is neighbouring west with room " + west.getName());
		}
		if (east != null) {
			System.out.println("is neighbouring east with room " + east.getName());
		}
		System.out.println("");
	}
	
}
