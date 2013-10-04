package SimpleCouchDB;

import au.edu.unimelb.twitterSearch.SentimentClassifier;

public class TweetLocation {

	private String id;
	//private double[] geolocation;
	
	private double lat;
	private double lng;
	
	private String screen_name;
	private String message;
	
	public TweetLocation(String id, String screen_name, double lat, double lng){
		this.setId(id);
		this.setScreen_name(screen_name);
		this.setLat(lat);
		this.setLng(lng);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getScreen_name() {
		return screen_name;
	}

	public void setScreen_name(String screen_name) {
		this.screen_name = screen_name;
	}

	public double getLat() {
		return lat;
	}

	public void setLat(double lat) {
		this.lat = lat;
	}

	public double getLng() {
		return lng;
	}

	public void setLng(double lng) {
		this.lng = lng;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
		
	}

	public String getSentiment(String c_filename) {
		
		SentimentClassifier classifier = new SentimentClassifier(c_filename);
		
		if(message == null){
			return null;
		}
		else{
			return classifier.classify(this.message);
		}
		
	}

}
