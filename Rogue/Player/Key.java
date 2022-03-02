package Player;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.ArrayList;
import java.util.Random;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.swing.JLabel;

import Draw.Initiate;
import Draw.ItemMenu;
import Draw.Map;
import Draw.MyFrame;
import Draw.PlayerInfo;
import Draw.PotionMenu;
import Draw.Redraw;
import Draw.TextArea;
import Enemy.AbstractEnemy;
import Enemy.Ettin;
import Enemy.GiantRat;
import Enemy.Goblin;
import Enemy.GraySlime;
import Enemy.OrcGrunt;
import Enemy.OrcWarlord;
import Enemy.Skeleton;
import Enemy.Vampire;
import Enemy.Wyrm;
import Item.AbstractItem;
import Item.AbstractPotion;

public class Key implements KeyListener {
	
	private Map map;
	private AbstractPlayer player;
	private Redraw r;
	private ArrayList<AbstractEnemy> e;
	private ArrayList<AbstractPotion> potions;
	private ArrayList<AbstractItem> items;
	private ItemMenu iM;
	private PotionMenu pM;
	private ExecutorService s = Executors.newSingleThreadExecutor();
	private MyFrame fr;
	private Random ran = new Random();
	private int floor = 1;
	private PlayerInfo info;
	private TextArea area;
	
	public Key(Map map, AbstractPlayer player, Redraw r, ArrayList<AbstractEnemy> e, ArrayList<AbstractPotion> potions, ArrayList<AbstractItem> items, ItemMenu iM, PotionMenu pM, MyFrame fr, PlayerInfo info, TextArea area) {
		this.map = map;
		this.player = player;
		this.r = r;
		this.e = e;
		this.potions = potions;
		this.items = items;
		this.iM = iM;
		this.pM = pM;
		this.fr = fr;
		this.info = info;
		this.area = area;
	}

	@Override
	public void keyTyped(KeyEvent e) {
		if (e.getKeyChar()=='W' || e.getKeyChar()=='w') {
			movePlayer(0, -1);
		}
		else if (e.getKeyChar()=='S' || e.getKeyChar()=='s') {
			movePlayer(0, 1);
		}
		else if (e.getKeyChar()=='A' || e.getKeyChar()=='a') {
			movePlayer(-1, 0);
		}
		else if (e.getKeyChar()=='D' || e.getKeyChar()=='d') {
			movePlayer(1, 0);
		}
		player.notifyObservers();
	}

	@Override
	public void keyPressed(KeyEvent e) {
		
		if (e.getKeyCode() == KeyEvent.VK_UP) {
			movePlayer(0, -1);
		}
		else if (e.getKeyCode() == KeyEvent.VK_DOWN) {
			movePlayer(0, 1);
		}
		else if (e.getKeyCode() == KeyEvent.VK_LEFT) {
			movePlayer(-1, 0);
		}
		else if (e.getKeyCode() == KeyEvent.VK_RIGHT) {
			movePlayer(1, 0);
		}
		else if (e.getKeyChar() == 'R' || e.getKeyChar() == 'r') {
			if (player.getType() == PlayerType.WARRIOR){
				player.restoreHP();
			}
			else {
				player.restoreHP();
				player.restoreMP();
			}
			movePlayer(0, 0);
		}
		else if (e.getKeyChar() == 'E' || e.getKeyChar() == 'e') {
			if (map.getTreasureMap()[player.getX()][player.getY()].equals("item")) {
				for (int k=0; k<items.size(); k++) {
					final int i = k;
					if (items.get(i).getX() == player.getX() && items.get(i).getY() == player.getY()) {
						if (player.getArmory() > 0) {
							player.pickUp(items.get(i));
							player.getSlots().get(items.get(i).getSlotType()).equip(items.get(i));
							player.update();
							area.setText("You picked up a " + items.get(i).getName() + "\n");
							map.getTreasureMap()[player.getX()][player.getY()] = "empty";
							player.setArmory(0);
							items.remove(items.get(i));
							k--;
						}
						else {
							iM.setVisible(true);
							iM.setFocus();
							iM.createMenu(player.getInventory());
							fr.repaint();
							CompletableFuture<AbstractItem> f1 = CompletableFuture.supplyAsync(() -> {
								try {
									Thread.sleep(5000);
								} catch (InterruptedException e1) {
									e1.printStackTrace();
								}
								return null;
							}, s);
							iM.pass(f1, fr);
							f1.whenComplete((item, Exception) -> {
								if ( item == null) {
									map.getTreasureMap()[player.getX()][player.getY()] = "item";
									iM.setVisible(false);
									fr.setFocusable(true);
									fr.requestFocusInWindow();
								}
								else {
									player.drop(item);
									player.getSlots().get(item.getSlotType()).remove(item);
									player.pickUp(items.get(i));
									player.getSlots().get(items.get(i).getSlotType()).equip(items.get(i));
									player.update();
									
									area.setText("You picked up a " + items.get(i).getName() + "\n");
									
									items.remove(items.get(i));
									
									item.setX(player.getX());
									item.setY(player.getY());
									
									items.add(0, item);
									map.getTreasureMap()[player.getX()][player.getY()] = "item";
								}
								player.notifyObservers();
							});
						}
					}
				}
			}
			movePlayer(0, 0);
		}
		else if (e.getKeyChar() == 'T' || e.getKeyChar() == 't') {
			ArrayList<AbstractEnemy> walkingDead = new ArrayList<AbstractEnemy>();
			
			player.attack(this.e);
			for (AbstractEnemy i : this.e)
			{
				if (i.getHitPoints() <= 0) {
					i.dropItem(map, potions);
					walkingDead.add(i);
				}
			}
			
			for (AbstractEnemy z : walkingDead) {
				this.e.remove(z);
			}
			
			walkingDead.clear();
			
			movePlayer(0, 0);
			fr.revalidate();
			fr.repaint();
		}
		else if (e.getKeyChar() == 'P' || e.getKeyChar() == 'p') {
			if (!player.getBag().isEmpty()) {
				pM.setVisible(true);
				pM.setFocus();
				pM.createMenu(player.getBag());
				fr.repaint();
				CompletableFuture<AbstractPotion> f1 = CompletableFuture.supplyAsync(() -> {
					try {
						Thread.sleep(5000);
					} catch (InterruptedException e1) {
						e1.printStackTrace();
					}
					return null;
				}, s);
				pM.pass(f1, fr);
				f1.whenComplete((item, Exception) -> {
					if (item == null) {
						map.getTreasureMap()[player.getX()][player.getY()] = "item";
						pM.setVisible(false);
						fr.setFocusable(true);
						fr.requestFocusInWindow();
					}
					else {
						item.use(item, player, area);
						player.update();
						if (item.usesLeft() <= 0) {
							player.getBag().remove(item);
						}
						info.setVisible(true);
						fr.revalidate();
						fr.repaint();
					}
					
					movePlayer(0, 0);
				});
			}
		}
		player.notifyObservers();
		if (player.isDead()) {
			fr.remove(r);
			fr.remove(area);
			fr.remove(info);
			JLabel l = new JLabel("YOU LOSE !!!");
			l.setFont(new Font("Cambria", Font.BOLD, 100));
			l.setForeground(Color.WHITE);
			fr.getContentPane().setBackground(Color.BLACK);
			fr.setLayout(null);
			l.setBounds(400, 250, 600, 200);
			fr.add(l);
			fr.revalidate();
			fr.repaint();
		}
	}

	@Override
	public void keyReleased(KeyEvent e) {
		
	}
	
	public void movePlayer(int x, int y) {
		if ((player.getX()+x) < 90 && (player.getX()+x) >= 0) {
			if ((player.getY()+y) < 58 && (player.getY()+y) >= 0) {
				if (map.getMap()[player.getX()+x][player.getY()+y].equals("floor") || map.getMap()[player.getX()+x][player.getY()+y].equals("start")) {
					player.move(x, y);
					map.tileVisible(player.getX(), player.getY(), player);
					if (map.getTreasureMap()[player.getX()][player.getY()].equals("potion")) {
						ArrayList<AbstractPotion> pickedUp = new ArrayList<AbstractPotion>();
 						for (AbstractPotion i : this.potions) {
							if (i.getX() == player.getX() && i.getY() == player.getY()) {
								player.pickUp(i);
								map.getTreasureMap()[player.getX()][player.getY()] = "empty";
								pickedUp.add(i);
								area.setText("You picked up a " + i.getName() + "\n");
							}
						}
						for (AbstractPotion i : pickedUp) {
							potions.remove(i);
						}
						pickedUp.clear();
					}
					for (AbstractEnemy i : e) {
						i.chaseOrAttack(player, map.getMap());
					}
					createEnemy(player, e);
					r.repaint();
				}
				else if (map.getMap()[player.getX()+x][player.getY()+y].equals("exit")) {
					player.move(x, y);
					if (floor < 10) {
						createNewMap(map, player, e, potions, items);
						r.repaint();
					}
					else {
						fr.remove(r);
						fr.remove(area);
						fr.remove(info);
						JLabel l = new JLabel("YOU WIN !!!");
						l.setFont(new Font("Cambria", Font.BOLD, 100));
						l.setForeground(Color.WHITE);
						fr.getContentPane().setBackground(Color.BLACK);
						fr.setLayout(null);
						l.setBounds(400, 250, 600, 200);
						fr.add(l);
						fr.revalidate();
						fr.repaint();
					}
				}
			}
		}
		player.notifyObservers();
	}
	
	public void createEnemy(AbstractPlayer p, ArrayList<AbstractEnemy> e) {
		
		int t = ran.nextInt(9);
		int q = ran.nextInt(99);
		
		ArrayList<AbstractEnemy> enemies = new ArrayList<AbstractEnemy>();
		enemies.add(new Ettin());
		enemies.add(new GiantRat());
		enemies.add(new Goblin());
		enemies.add(new GraySlime());
		enemies.add(new OrcGrunt());
		enemies.add(new OrcWarlord());
		enemies.add(new Skeleton());
		enemies.add(new Vampire());
		enemies.add(new Wyrm());
		
		if (e.size() < 11 && q < 40) {
			if (enemies.get(t).getMinlvl() <= p.getLevel() && enemies.get(t).getMaxlvl() >= p.getLevel()) {
				e.add(enemies.get(t));
				e.get(e.indexOf(enemies.get(t))).spawn(p, map, e.get(e.indexOf(enemies.get(t))));
				area.setText(e.get(e.indexOf(enemies.get(t))).getName() + " has spawned");
			}
		}
		enemies.clear();
	}
	
	public void createNewMap(Map map, AbstractPlayer player, ArrayList<AbstractEnemy> e, ArrayList<AbstractPotion> potions, ArrayList<AbstractItem> items) {
		map.createMap(player);
		area.setText("");
		potions.clear();
		items.clear();
		e.clear();
		new Initiate(map, player, e, potions, items);
		floor += 1;
	}
}