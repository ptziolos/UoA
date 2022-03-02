package Draw;
import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.util.Random;

import Player.AbstractPlayer;


public class Map{
	
	final int WIDTH = 900;
	final int HEIGHT = 580;
	final int tileSize = 10;
	final int nx = WIDTH/tileSize;
	final int ny = HEIGHT/tileSize;
	
	private Random r = new Random();
	
	private int direction = r.nextInt(4);
	private int start_x;
	private int start_y;
	private int pos_x;
	private int pos_y;
	private int exit_x;
	private int exit_y;
	
	
	private String[][] gameMap = new String[nx][ny];
	private String[][] visionMap = new String[nx][ny];
	private String[][] treasureMap = new String[nx][ny];
	
	final double percentage = 0.37;
	
	public Map(AbstractPlayer player) {
		createMap(player);
	}
	
	public int getStartX() {
		return this.start_x;
	}
	
	public int getStartY() {
		return this.start_y;
	}
	
	public int getExitX() {
		return this.exit_x;
	}
	
	public int getExitY() {
		return this.exit_y;
	}
	
	public int getNX() {
		return this.nx;
	}
	
	public int getNY() {
		return this.ny;
	}
	
	public void draw(Graphics g) {
		Image img = createBufferedImage();
	    g.drawImage(img, 0, 0, 1920, 1080, null);
	}

	
	private Image createBufferedImage() {
		
		BufferedImage bufferedImage = new BufferedImage(1920, 1080, BufferedImage.TYPE_3BYTE_BGR);
	    Graphics2D g = (Graphics2D) bufferedImage.getGraphics();
		
	    
		for (int i=0; i<nx; i++) {
			for (int j=0; j<ny; j++){
				if (gameMap[i][j].equals("floor")) {
					if (visionMap[i][j].equals("visible")) {
						g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1f));
					}
					else if (visionMap[i][j].equals("fogged") || visionMap[i][j].equals("unknown")) {
						g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.1f));
					}
					g.setColor(Color.ORANGE);
					g.fillRect(i*tileSize+2, j*tileSize+2 , 8, 8);
				}
				else if(gameMap[i][j].equals("start")) {
					g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1f));
					g.setColor(Color.WHITE);
					g.fillRect(start_x*tileSize+2, start_y*tileSize+2, 8, 8);
				}
				else if (gameMap[i][j].equals("exit")) {
					if (visionMap[i][j].equals("visible")) {
						g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 1f));
					}
					else {
						g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0f));
					}
					g.setColor(Color.CYAN);
					g.fillRect(exit_x*tileSize+2, exit_y*tileSize+2, 8, 8);
				}
			}
		}
		
		return bufferedImage;
	}

	
	public void createMap(AbstractPlayer player) {
		
		for (int i=0; i<nx; i++) {
			for (int j=0; j<ny; j++) {
				gameMap[i][j] = "wall";
				visionMap[i][j] = "unknown";
				treasureMap[i][j] = "empty";
			}
		}
		
		if (direction == 0) {
			start_x = r.nextInt(nx);
			start_y = r.nextInt(3);
		}
		else if (direction == 1) {
			start_x = r.nextInt(nx);
			start_y = ((ny-1) - r.nextInt(3));
		}
		else if (direction == 2) {
			start_x = r.nextInt(3);
			start_y = r.nextInt(ny);
		}
		else if (direction == 3) {
			start_x = ((nx-1) - r.nextInt(3));
			start_y = r.nextInt(ny);
		}
		
		gameMap[start_x][start_y] = "start";
		
		pos_x = start_x;
		pos_y = start_y;
		
		double filled = 0.0;
		double floor_tiles = 0;

		while (filled < percentage) {
			
			direction = r.nextInt(4);
			
			if (direction == 0) {
				if (pos_y + 1 < ny) {
					pos_y += 1;
				}
			}
			else if (direction == 1) {
				if (pos_y - 1 >= 0) {
					pos_y -= 1;
				}
			}
			else if (direction == 2) {
				if (pos_x + 1 < nx) {
					pos_x += 1;
				}
			}
			else if (direction == 3) {
				if (pos_x - 1 >= 0) {
					pos_x -= 1;
				}
			}
			
			if (!gameMap[pos_x][pos_y].equals("start") && !gameMap[pos_x][pos_y].equals("floor")) {
				gameMap[pos_x][pos_y] = "floor";
				floor_tiles += 1;
			}
			
			filled = Double.valueOf(floor_tiles/(nx*ny));
			
		}
		
		double distance = 0;
		double relDis = 0;
		
		for (int i=0; i<nx; i++) {
			for (int j=0; j<ny; j++){
				if (gameMap[i][j].equals("floor")) {
					relDis = Math.sqrt(Math.pow(i-start_x, 2) + Math.pow(j-start_y, 2));
					if (relDis > distance){
						distance = relDis;
						exit_x = i;
						exit_y = j;
	 				}
				}
			}
		}
		
		gameMap[exit_x][exit_y] = "exit";
		tileVisible(start_x, start_y, player);
		player.setX(start_x);
		player.setY(start_y);
		
	}
	
	
	public void tileVisible(int playerX, int playerY, AbstractPlayer player) {
		
		for (int i=0; i<nx; i++) {
			for (int j=0; j<ny; j++){
				if (Math.sqrt(Math.pow(Math.abs(playerX-i), 2) + Math.pow(Math.abs(playerY-j), 2)) < player.getVision()) {
					if (gameMap[i][j].equals("floor")) {
						visionMap[i][j] = "visible";
					}
					else if (gameMap[i][j].equals("exit")) {
						visionMap[i][j] = "visible";
					}
				}
				else if (Math.sqrt(Math.pow(Math.abs(playerX-i), 2) + Math.pow(Math.abs(playerY-j), 2)) >= player.getVision()) {
					if (visionMap[i][j].equals("visible")) {
						visionMap[i][j] = "fogged";	
					}
				}
			}
		}
		
	}
	
	public String[][] getMap() {
		return this.gameMap;
	}
	
	public void setTreasureMap(int x, int y, String s) {
		this.treasureMap[x][y] = s;
	}
	
	public String[][] getTreasureMap() {
		return this.treasureMap;
	}
	
}

