package SimpleCouchDB;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.lightcouch.CouchDbClient;
import org.lightcouch.CouchDbProperties;
import org.lightcouch.CouchDbException;

import au.edu.unimelb.twitterSearch.SentimentClassifier;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;


public class CouchDB {
	
	private CouchDbProperties properties;
	private CouchDbClient dbClient;
	
	private String view_GeoLocationOfUser = "geo/geo_location_of_user";
	private String view_GeoLocationByTime = "geo/geo_location_over_time";
	private String view_CountTweet = "tweet/count_tweet_over_time";
	private String view_TweetMessage = "tweet/tweet_message_over_time";
	private String view_Tweet = "tweet/tweet_over_time";
	
	public CouchDB(){
		//CouchDB connection
		/*properties = new CouchDbProperties()
				  .setDbName("adelaide_db")
				  .setCreateDbIfNotExist(true)
				  .setProtocol("http")
				  .setHost("127.0.0.1")
				  .setPort(5984)
				  .setUsername("admin")
				  .setPassword("z002d0wd")
				  .setMaxConnections(100)
				  .setConnectionTimeout(0);
		dbClient = new CouchDbClient(properties);*/
		
		properties = new CouchDbProperties()
		  .setDbName("adelaide_db")
		  .setCreateDbIfNotExist(true)
		  .setProtocol("http")
		  .setHost("115.146.94.161")
		  .setPort(5984)
		  .setMaxConnections(100)
		  .setConnectionTimeout(0);
		dbClient = new CouchDbClient(properties);
		
	}
	
	public List<TweetLocation> getTweetLocations(int limit){
		
		//List<JsonObject> allDocs = dbClient.view("all/geo_location").limit(limit).query(JsonObject.class);
		List<JsonObject> allDocs = dbClient.view(view_GeoLocationOfUser).limit(limit).query(JsonObject.class);
		
		String id;
		String screen_name;
		double[] geolocation = new double[2];
		List<TweetLocation> list = new ArrayList<TweetLocation>();
		
		for(JsonObject json : allDocs){
			screen_name = json.get("key").getAsString();
			geolocation[0] = json.get("value").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.get("value").getAsJsonArray().get(1).getAsDouble();
			id = json.get("id").getAsString();
			
			list.add(new TweetLocation(id,screen_name,geolocation[0],geolocation[1]));
			
			/*System.out.println(screen_name);
			System.out.println(geolocation[0]);
			System.out.println(geolocation[1]);
			System.out.println(id);
			System.out.println("----------------");*/
		}
		
		return list;
	}
	
	public List<TweetLocation> getTweetLocations(int limit, String username){

		//List<JsonObject> allDocs = dbClient.view("all/geo_location").key(username).limit(10).query(JsonObject.class);
		List<JsonObject> allDocs = dbClient.view(view_GeoLocationOfUser).limit(limit).query(JsonObject.class);
		
		String id;
		String screen_name;
		double[] geolocation = new double[2];
		List<TweetLocation> list = new ArrayList<TweetLocation>();
		
		for(JsonObject json : allDocs){
			screen_name = json.get("key").getAsString();
			geolocation[0] = json.get("value").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.get("value").getAsJsonArray().get(1).getAsDouble();
			id = json.get("id").getAsString();
			
			list.add(new TweetLocation(id,screen_name,geolocation[0],geolocation[1]));
		}
		return list;
	}
	
	public List<TweetLocation> getTweetLocations(int limit,Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		//List<JsonObject> allDocs = dbClient.view("all/geo_location_time")
		List<JsonObject> allDocs = dbClient.view(view_GeoLocationByTime)
											.limit(limit)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		String id;
		String screen_name;
		double[] geolocation = new double[2];
		List<TweetLocation> list = new ArrayList<TweetLocation>();
		
		for(JsonObject json : allDocs){
			//screen_name = json.get("key").getAsString();
			screen_name = json.get("key").toString();
			geolocation[0] = json.get("value").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.get("value").getAsJsonArray().get(1).getAsDouble();
			id = json.get("id").getAsString();
				
			list.add(new TweetLocation(id,screen_name,geolocation[0],geolocation[1]));
		}
		
		return list;
	}
	
	public TweetSentiment getSentiment(String c_filename,Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_TweetMessage)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		
		String tweet_message;
		TweetSentiment sentiment = new TweetSentiment();
		SentimentClassifier classifier = new SentimentClassifier(c_filename);
		
		for(JsonObject json : allDocs){
			tweet_message = json.get("value").getAsString();
			//System.out.println("msg=" + tweet_message);
			String feedback = classifier.classify(tweet_message);
			//System.out.println(feedback + " = " + tweet_message);
			if(feedback.equals("pos")){	//Positive tweet
				sentiment.incrementPositive();
			}
			else if(feedback.equals("neg")){ //Negative tweet
				sentiment.incrementNegative();
			}
			else if(feedback.equals("neu")){ //Neutral tweet
				sentiment.incrementNeutral();
			}
		}
		
		return sentiment;	
	}
	
	public UserStatList getTopUser(String c_filename, 
										Date start_date, 
										Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_Tweet)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		
		SentimentClassifier classifier = new SentimentClassifier(c_filename);

		//Map<String, Integer> table = new HashMap<String, Integer>();
		Map<String, UserStat> table = new HashMap<String, UserStat>();
		/*ValueComparator compare_pos =  new ValueComparator(table,"pos");
		ValueComparator compare_neg =  new ValueComparator(table,"neg");
		ValueComparator compare_neu =  new ValueComparator(table,"neu");
		ValueComparator compare_all =  new ValueComparator(table,"all");
		TreeMap<String, Integer> rankingTable = new TreeMap<String, Integer>(bvc);*/
		
		for(JsonObject json : allDocs){
			String user = json.getAsJsonObject("value").get("screen_name").getAsString();
			String message = json.getAsJsonObject("value").get("message").getAsString();
			String feedback = classifier.classify(message);
			UserStat userstat;
			
			if(!table.containsKey(user)){
				userstat =  new UserStat(user);
				userstat.increment(feedback);
				table.put(user, userstat);
			}
			//Increment the value if 
			else{
				userstat = table.get(user);
				userstat.increment(feedback);
				table.put(user, userstat);
			}
		}

		return new UserStatList(table);
		// Put the map in the tree
		/*rankingTable.putAll(table);
		
		List<UserStat> users = new ArrayList();
		int counter = 1;
		for(String key : rankingTable.keySet()){
			//Set name and count negative, positive or neutral tweet
			UserStat user = new UserStat(key);
			if(sentiment.equals("pos")){
				user.setPositive_tweet(table.get(key));
			}
			else if(sentiment.equals("neg")){
				user.setNegative_tweet(table.get(key));
			}
			else if(sentiment.equals("neu")){
				user.setNeutral_tweet(table.get(key));
			}
			else if(sentiment.equals("all")){
				user.setAll_tweet(table.get(key));
			}
			//Add user to the list
			users.add(user);
			
			//Break when reach the topk
			if(counter == topk) break;
			counter++;
		}
		
		return users;*/
		
	}
	
	public int countTweet(Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		//List<JsonObject> allDocs = dbClient.view("all/geo_location_count")
		List<JsonObject> allDocs = dbClient.view(view_CountTweet)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		
		for(JsonObject json : allDocs){
			return json.get("value").getAsInt();
		}
		
		return 0;
	}
	
	public List<TweetCount> countDailyTweet(Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		//List<JsonObject> allDocs = dbClient.view("all/geo_location_count")
		List<JsonObject> allDocs = dbClient.view(view_CountTweet)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.group(true)
											.groupLevel(3)
											.query(JsonObject.class);
		
		List<TweetCount> list = new ArrayList<TweetCount>();
		
		for(JsonObject json : allDocs){
			
			Date date = convertToDate(json.get("key").getAsJsonArray());
			int count = json.get("value").getAsInt();
			
			list.add(new TweetCount(date,count));
		}
		
		return list;
	}
	
	private int[] convertToDateArray(Date date){
		Calendar date_calendar = GregorianCalendar.getInstance(); // creates a new calendar instance
		date_calendar.setTime(date);   // assigns calendar to given date
		
		int[] modified_date = {date_calendar.get(Calendar.YEAR) , 
				+ date_calendar.get(Calendar.MONTH) +1 ,
				+ date_calendar.get(Calendar.DAY_OF_MONTH) ,
				+ date_calendar.get(Calendar.HOUR_OF_DAY) ,
				+ date_calendar.get(Calendar.MINUTE) ,
				+ date_calendar.get(Calendar.SECOND) };
		
		return modified_date;
	}
	
	
	
	private Date convertToDate(JsonArray jarray){
		
		int yyyy = 2013;
		int MM = 2;
		int dd = 2;
		int hh = 0;
		int mm = 0;
		int ss = 0;
		
		
		for(int i=0;i<jarray.size();i++){

			switch (i) {
            case 0:  yyyy = jarray.get(i).getAsInt(); break;
            case 1:  MM = jarray.get(i).getAsInt(); break;
            case 2:  dd = jarray.get(i).getAsInt(); break;
            case 3:  hh = jarray.get(i).getAsInt(); break;
            case 4:  mm = jarray.get(i).getAsInt(); break;
            case 5:  ss = jarray.get(i).getAsInt(); break;
			}
		}

		try {
			Date date = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse(yyyy + "-" + MM + "-" + dd 
																			+ " " + hh + ":" + mm + ":" + ss);
			return date;
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return null;
	}

	public static void main(String[] args) {
		
		CouchDB db = new CouchDB();
		Date start_time = null;
		Date end_time = null;
		try {
			start_time = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse("2013-09-24 00:00:00");
			end_time = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse("2013-09-25 23:59:59");
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		UserStatList list = db.getTopUser("classifier.txt",start_time, end_time);
		List<UserStat> sortedList1 = list.getListSortedByPos(10);
		List<UserStat> sortedList2 = list.getListSortedByNeg(10);
		List<UserStat> sortedList3 = list.getListSortedByNeu(10);
		List<UserStat> sortedList4 = list.getListSortedByTotalTweet(10);
		
		for(UserStat u : sortedList1){
			System.out.println(u.getScreen_name() + "=" + u.getPositive_tweet());
		}
		System.out.println("------------------");
		for(UserStat u : sortedList2){
			System.out.println(u.getScreen_name() + "=" + u.getNegative_tweet());
		}
		System.out.println("------------------");
		for(UserStat u : sortedList3){
			System.out.println(u.getScreen_name() + "=" + u.getNeutral_tweet());
		}
		System.out.println("------------------");
		for(UserStat u : sortedList4){
			System.out.println(u.getScreen_name() + "=" + u.getAll_tweet());
		}
		
		/*TweetSentiment sentiment = db.getSentiment("classifier.txt",start_time, end_time);
		System.out.println("positive=" + sentiment.getPositive() );
		System.out.println("negative=" + sentiment.getNegative() );
		System.out.println("neutral=" + sentiment.getNeutral() );*/
		
		/*System.out.println(db.countDailyTweet(start_time, end_time));
		
		List<TweetCount> temp = db.countDailyTweet(start_time, end_time);
		for(TweetCount count_obj : temp){
			System.out.println(count_obj.getDate());
			System.out.println(count_obj.getCount());
			System.out.println("----------------");
		}*/
		
		/*
		List<TweetLocation> temp = db.getTweets(10,start_time,end_time);

		for(TweetLocation location : temp){
			System.out.println(location.getId());
			System.out.println(location.getScreen_name());
			System.out.println(location.getLat());
			System.out.println(location.getLng());
			System.out.println("----------------");
		}*/
	}

}
