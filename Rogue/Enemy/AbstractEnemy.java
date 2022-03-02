package Enemy;

import java.awt.Color;
import java.awt.Graphics;
import java.util.ArrayList;
import java.util.Random;

import Draw.Map;
import Item.AbstractPotion;
import Item.MinorHealthPotion;
import Item.MinorManaPotion;
import Player.AbstractPlayer;



public abstract class AbstractEnemy {
	
	private String name;
	
	private int initHitPoints;
	private int initBaseStrength;
	
	private int hitPoints;
	private int baseStrength;
	
	private int xp;
	private int radius;
	
	private int minlvl;
	private int maxlvl;
	
	private int x;
	private int y;
	
	Random ran = new Random();
	
	
	public void move(int x, int y) {
		this.x = this.x + x;
		this.y = this.y + y;
	}
	
	public void draw(Graphics g) {
		int tileSize = 10;
		g.setColor(Color.RED);
		g.fillRect(this.x*tileSize+2, this.y*tileSize+2, 8, 8);
	}
	
	public void spawn(AbstractPlayer player, Map map, AbstractEnemy enemy) {
		int x, y, t;
		ArrayList<Integer> k = new ArrayList<Integer>();
		ArrayList<Integer> l = new ArrayList<Integer>();
		if (player.getVision() >= this.radius) {
			for (int i=0; i<map.getNX(); i++) {
				for (int j=0; j<map.getNY(); j++) {
					if ((int) Math.sqrt(Math.pow(Math.abs(player.getX()-i), 2) + Math.pow(Math.abs(player.getY()-j), 2)) == player.getVision()+1) {
						if (!map.getMap()[i][j].equals("wall")) {
							k.add(i);
							l.add(j);
						}
					}
				}
			}
			
			t = ran.nextInt(k.size());
			x = k.get(t);
			y = l.get(t);
			
			enemy.setX(x);
			enemy.setY(y);

		}
		else {
			if (player.getVision() < this.radius) {
				for (int i=0; i<map.getNX(); i++) {
					for (int j=0; j<map.getNY(); j++) {
						if ((int) Math.sqrt(Math.pow(Math.abs(player.getX()-i), 2) + Math.pow(Math.abs(player.getY()-j), 2)) == player.getVision()+1) {
							if (!map.getMap()[i][j].equals("wall")) {
								k.add(i);
								l.add(j);
							}
						}
					}
				}
			}
				
			t = ran.nextInt(k.size());
			x = k.get(t);
			y = l.get(t);
				
			enemy.setX(x);
			enemy.setY(y);
		}
		
	}
	
	public void dropItem(Map map, ArrayList<AbstractPotion> potions) {
		int t = ran.nextInt(40);
		
		if (t <= 10) {
			t = ran.nextInt(1);
			
			if (t == 0) {
				AbstractPotion p = new MinorHealthPotion();
				potions.add(p);
				potions.get(potions.indexOf(p)).setX(getX());
				potions.get(potions.indexOf(p)).setY(getY());
				map.getTreasureMap()[potions.get(potions.indexOf(p)).getX()][potions.get(potions.indexOf(p)).getY()] = "potion";
				p = null;
			}
			else if (t == 1) {
				AbstractPotion p = new MinorManaPotion();
				potions.add(p);
				potions.get(potions.indexOf(p)).setX(getX());
				potions.get(potions.indexOf(p)).setY(getY());
				map.getTreasureMap()[potions.get(potions.indexOf(p)).getX()][potions.get(potions.indexOf(p)).getY()] = "potion";
				p = null;
			}
		}
	}
	
	public void chaseOrAttack(AbstractPlayer player, String[][] map) {
		int x = player.getX();
		int y = player.getY();
		double distance = Math.sqrt(Math.pow(this.x-x, 2) + Math.pow(this.y-y, 2));
		
		if (distance < this.radius && distance > 1) {
			if  (Math.sqrt(Math.pow(this.x-x, 2) + Math.pow(this.y-1-y, 2)) < distance && !map[this.x][this.y-1].equals("wall")){
				move(0, -1);
			}
			
			else if  (Math.sqrt(Math.pow(this.x-x, 2) + Math.pow(this.y+1-y, 2)) < distance && !map[this.x][this.y+1].equals("wall")){
				move(0, 1);
			}
			
			else if  (Math.sqrt(Math.pow(this.x-1-x, 2) + Math.pow(this.y-y, 2)) < distance && !map[this.x-1][this.y].equals("wall")){
				move(-1, 0);
			}
			
			else if  (Math.sqrt(Math.pow(this.x+1-x, 2) + Math.pow(this.y-y, 2)) < distance && !map[this.x+1][this.y].equals("wall")){
				move(1, 0);
			}
		}
		else if (distance <= 1) {
			player.takeDamage(this.initBaseStrength);
		}
		
	}
	
	public void setMinlvl(int minlvl) {
		this.minlvl = minlvl;
	}
	
	public void setMaxlvl(int maxlvl) {
		this.maxlvl = maxlvl;
	}
	
	public int getMinlvl() {
		return this.minlvl;
	}
	
	public int getMaxlvl() {
		return this.maxlvl;
	}
	
	public void takeDamage(int damage) {
		this.hitPoints -= damage;
	}
	
	public void setXP(int xp) {
		this.xp = xp;
	}
	
	public int getXP() {
		return this.xp;
	}
	
	public void setRadius(int radius) {
		this.radius = radius;
	}
	
	public int getRadius() {
		return this.radius;
	}
	
	public void setX(int x) {
		this.x = x;
	}
	
	public void setY(int y) {
		this.y = y;
	}
	
	public int getX() {
		return this.x;
	}
	
	public int getY() {
		return this.y;
	}
	
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getName(){
		return this.name;
	}
	
	
	public void setInitHitPoints(int initHitPoints) {
		this.initHitPoints = initHitPoints;
		this.hitPoints = initHitPoints;
	}
	
	public void setInitBaseStrength(int initBaseStrength) {
		this.initBaseStrength = initBaseStrength;
		this.baseStrength = initBaseStrength;
	}
	
	public void setHitPoints(int hitPoints) {
		this.hitPoints = hitPoints;
	}
	
	public void setBaseStrength(int baseStrength) {
		this.baseStrength = baseStrength;
	}
	
	
	
	public int getInitHitPoints() {
		return this.initHitPoints;
	}
	
	public int getInitBaseStrength() {
		return this.initBaseStrength;
	}
	
	public int getHitPoints() {
		return this.hitPoints;
	}
	
	public int getBaseStrength() {
		return this.baseStrength;
	}
	
}

