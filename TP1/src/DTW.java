import java.util.Vector;

import javafx.geometry.Point2D;

public class DTW {
	
	private TemplateManager tm;
	
	public DTW() {
		tm = new TemplateManager();
		tm.loadFile("gestures.xml");
	}
	
	public Template find(Vector<Point2D> gesture) {
		Vector<Template> templates = tm.getTemplates();
		Template res = null;
		double minDTW = Double.MAX_VALUE;
		
		Vector<Point2D> gestureN = this.normalize(gesture);
		gestureN = this.correctCentroid(gestureN);
		
		for(Template t : templates) {
			Vector<Point2D> templateN = this.normalize(t.getPoints());
			templateN = this.correctCentroid(templateN);
			
			double dtw = this.compute(gestureN, templateN).items[gestureN.size() - 1][templateN.size() - 1];
			
			if(minDTW > dtw) {
				minDTW = dtw;
				res = t;
			}
		}
		
		
		return res;
	}
	
	public Matrix compute(Vector<Point2D> gesture, Vector<Point2D>template) {
		int n = gesture.size();
		int m = template.size();
		
		Matrix mat = new Matrix(n, m);
		
		mat.items[0][0] = 0;
		mat.couple[0][0] = new Couple(0, 0);
		
		for(int i = 1; i < n; i++) {
			mat.items[i][0] = mat.items[i - 1][0] + dst(gesture.get(i), template.get(0));
			mat.couple[i][0] = new Couple(i - 1, 0);
		}
		
		for(int i = 1; i < m; i++) {
			mat.items[0][i] = mat.items[0][i - 1] + dst(gesture.get(0), template.get(i));
			mat.couple[0][i] = new Couple(0, i - 1);
		}
		
		for(int i  = 1; i < n; i++) {
			for(int j = 1; j < m; j++) {
				Couple c = new Couple();
				double min = Double.MAX_VALUE;
				
				if(min > mat.items[i][j - 1]) c.x = i; c.y = j - 1; min = mat.items[i][j - 1];
				if(min > mat.items[i - 1][j]) c.x = i - 1; c.y = j; min = mat.items[i - 1][j];
				if(min > mat.items[i - 1][j - 1]) c.x = i - 1; c.y = j - 1; min = mat.items[i - 1][j - 1];
				
				mat.items[i][j] = dst(gesture.get(i), template.get(j)) + min;
				mat.couple[i][j] = c;
			}
		}
		
		return mat;
	}
	
	private double dst(Point2D g, Point2D t) {
		return g.distance(t);
	}
	
	private Point2D centroid(Vector<Point2D> points) {
		Point2D centroid = new Point2D(0.5, 0.5);
//		for(Point2D p : points) {
//			centroid = centroid.add(p);
//		}
//		centroid = centroid.multiply(1.0 / points.size());
		return centroid;
	}
	
	private Vector<Point2D> correctCentroid(Vector<Point2D> points) {
		Point2D centroid = this.centroid(points);
		Vector<Point2D> res = new Vector<Point2D>();
		
		for(Point2D p : points) {
			res.add(p.subtract(centroid));
		}
		
		return res;
	}
	
	private Vector<Point2D> normalize(Vector<Point2D> points) {
		double minX = Double.MAX_VALUE, maxX = Double.MIN_VALUE, minY = Double.MAX_VALUE, maxY = Double.MIN_VALUE;
		Vector<Point2D> res = new Vector<Point2D>();
		
		for(Point2D p : points) {
			minX = Math.min(minX, p.getX());
			maxX = Math.max(maxX, p.getX());
			minY = Math.min(minY, p.getY());
			maxY = Math.max(maxY, p.getY());
		}
		
		for(Point2D p : points) {
			Point2D tmp = new Point2D((p.getX() - minX) / (maxX - minX), (p.getY() - minY) / (maxY - minY));
			res.add(tmp);
		}
		
		return res;
	}
}
