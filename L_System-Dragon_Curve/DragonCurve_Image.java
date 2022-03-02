import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.GridLayout;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.swing.BoxLayout;
import javax.swing.JPanel;

public class DragonCurve_Image {
	
	
	public DragonCurve_Image(DragonCurve_Implementation curve) {
    
		ExecutorService executor = Executors.newFixedThreadPool(2);
		
		var frame = new MyFrame();

		var panel1 = new JPanel();
		panel1.setLayout(new GridLayout(1,2));
		panel1.add(new MyLabel("Select Order"));
		
		var orderSlider = new MySlider(1, 25, 19);
		panel1.add(orderSlider);
		panel1.add(new MyLabel(""));
		panel1.setBackground(Color.BLACK);
		
		var panel2 = new JPanel();
		panel2.setLayout(new GridLayout(1,2));
		
		var pixelSlider = new MySlider(1, 10, 1);
		panel2.add(new MyLabel(""));
		panel2.add(new MyLabel("Select Pixel"));
		panel2.add(pixelSlider);
		panel2.setBackground(Color.BLACK);
		
		var panel3 = new JPanel();
		panel3.setLayout(new GridLayout(1,3));
		
		var colorButton = new MyButton("Change Color");
		panel3.add(colorButton);
		panel3.setBackground(Color.BLACK);
		
		var panel4 = new JPanel();
		panel4.setLayout(new GridLayout(1,2));
		
		var exeButton = new MyButton("Reanimate");
		panel4.add(exeButton);
		panel4.setBackground(Color.BLACK);
		
		var panel5 = new JPanel();
		panel5.setLayout(new GridLayout(2,1)); 
		panel5.add(panel3);
		panel5.add(panel4);
		
		var panell = new JPanel();
		panell.setLayout(new BoxLayout(panell, BoxLayout.X_AXIS));
		panell.add(panel1);
		panell.add(panel5);
		panell.add(panel2);
		
		var superPanel = new JPanel();
		superPanel.setLayout(new BorderLayout());
		superPanel.add(panell, BorderLayout.NORTH);
		
		
		/*pixelSlider.addChangeListener(l-> { pixelSlider.setEnabled(false);
											orderSlider.setEnabled(false);
											colorButton.setEnabled(false);
											curve.setPixels(pixelSlider.getValue());
											curve.repaint();
											pixelSlider.setEnabled(true);
											orderSlider.setEnabled(true);
											colorButton.setEnabled(true);
											} );
		
		orderSlider.addChangeListener(l-> { pixelSlider.setEnabled(false);
											orderSlider.setEnabled(false);
											colorButton.setEnabled(false);
											curve.callSetOrder(curve.getDragonCurve(), orderSlider.getValue());
											curve.setDragonString(curve.getDragonCurve().createDragonString());
											curve.repaint();
											pixelSlider.setEnabled(true);
											orderSlider.setEnabled(true);
											colorButton.setEnabled(true);
										  	} );
		
		colorButton.addActionListener(l -> {pixelSlider.setEnabled(false);
											orderSlider.setEnabled(false);
											colorButton.setEnabled(false);
											exeButton.setEnabled(false);
											curve.changeColor();
											curve.repaint();
											pixelSlider.setEnabled(true);
											orderSlider.setEnabled(true);
											colorButton.setEnabled(true);
											exeButton.setEnabled(true);
										   });
		
		*/
		
		exeButton.addActionListener(l -> {executor.execute(()->{pixelSlider.setEnabled(false);
																orderSlider.setEnabled(false);
																colorButton.setEnabled(false);
																exeButton.setEnabled(false);
																curve.setPixels(pixelSlider.getValue());
																curve.callSetOrder(curve.getDragonCurve(), orderSlider.getValue());
																curve.setDragonString(curve.getDragonCurve().createDragonString());
																curve.repaint();
																pixelSlider.setEnabled(true);
																orderSlider.setEnabled(true);
																colorButton.setEnabled(true);
																exeButton.setEnabled(true);});
																});
		
		colorButton.addActionListener(l -> {executor.execute(()->{pixelSlider.setEnabled(false);
																  orderSlider.setEnabled(false);
																  colorButton.setEnabled(false);
																  exeButton.setEnabled(false);
																  curve.changeColor();
																  curve.repaint();
																  pixelSlider.setEnabled(true);
																  orderSlider.setEnabled(true);
																  colorButton.setEnabled(true);
																  exeButton.setEnabled(true);});
																  });
		
		
		frame.add(curve, BorderLayout.CENTER);
		frame.add(superPanel, BorderLayout.NORTH);
		
		
		frame.pack(); 
		
	}
	
}
