/**
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 */

import java.util.Vector;

import javafx.application.Application;
import javafx.geometry.Point2D;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

public class DTWGUI extends Application{
	GraphicsContext gc;
	Canvas canvas;
	Vector<Point2D> userGesture = new Vector<Point2D>();
	Template t = null;
	DTW dtw = new DTW();
	
	public void start(Stage stage) {
		VBox root = new VBox();
		canvas = new Canvas (600, 700);
		gc = canvas.getGraphicsContext2D();
		root.getChildren().add(canvas);
		
		canvas.setOnMousePressed(e -> {
			userGesture.clear();
			t = null;
			redrawMyCanvas();			
		});
		
		canvas.setOnMouseDragged(e -> {
			userGesture.add(new Point2D(e.getX(), e.getY()));
			redrawMyCanvas();
		});
		
		canvas.setOnMouseReleased(e -> {
			t = dtw.find(userGesture);
			System.out.println(t.getName());
			redrawMyCanvas();
		});

		Scene scene = new Scene(root);
		stage.setTitle("Université Lille 1 - M2 IVI - NIHM - Dynamic Time Warping - G. Casiez");
		stage.setScene(scene);
		stage.show();
	}
	
	public void redrawMyCanvas() {
		double r = 5.0;
		gc.clearRect(0, 0, canvas.getWidth(), canvas.getHeight());
		
		for (int i=1; i<userGesture.size(); i++) {
			gc.setStroke(Color.BLACK);
			gc.strokeLine(userGesture.elementAt(i-1).getX(), userGesture.elementAt(i-1).getY(),
					userGesture.elementAt(i).getX(), userGesture.elementAt(i).getY());
			gc.strokeOval(userGesture.elementAt(i-1).getX() - r, userGesture.elementAt(i-1).getY() - r, 2*r, 2*r);
		}
		
		if(t != null) {
			for(int i=1; i<t.getPoints().size(); i++) {
				gc.setStroke(Color.ORANGE);
				gc.strokeLine(t.getPoints().elementAt(i-1).getX(), t.getPoints().elementAt(i-1).getY(),
						t.getPoints().elementAt(i).getX(), t.getPoints().elementAt(i).getY());
				gc.strokeOval(t.getPoints().elementAt(i-1).getX() - r, t.getPoints().elementAt(i-1).getY() - r, 2*r, 2*r);
			}
		}
		
	}

	public static void main(String[] args) {
		Application.launch(args);
	}
}
