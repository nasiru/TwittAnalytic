package SimpleCouchDB;
import twitter4j.GeoLocation;

/**

Bounding box code for geospatial analysis

Team 1 - Adelaide
Erick Thomas Gaspar (527823)
Nasir Uddin (558747)
Mohamad Ilhamy Putra (595179)
Prapon Chaimuttayompol (575141)
Chi Wang (523312)


*/

public class RectArea {

	private GeoLocation north_east;
	private GeoLocation south_west;

	public RectArea(GeoLocation ne, GeoLocation sw){
		this.setNorth_east(ne);
		this.setSouth_west(sw);
	}

	public GeoLocation getNorth_east() {
		return north_east;
	}

	public void setNorth_east(GeoLocation north_east) {
		this.north_east = north_east;
	}

	public GeoLocation getSouth_west() {
		return south_west;
	}

	public void setSouth_west(GeoLocation south_west) {
		this.south_west = south_west;
	}
	
	public GeoLocation getMiddlePoint(){
		return new GeoLocation( (north_east.getLatitude() + south_west.getLatitude())/2,
				 				(north_east.getLongitude() + south_west.getLongitude())/2);
	}
	
	public boolean isInside(double lat, double lng){
		if(lng < north_east.getLongitude() && lat < north_east.getLatitude() &&
				lng > south_west.getLongitude() && lat > south_west.getLatitude()){
			return true;
		}
		else{
			return false;
		}
	}
}
