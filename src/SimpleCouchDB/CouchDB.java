package SimpleCouchDB;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.MutableDateTime;
import org.lightcouch.CouchDbClient;
import org.lightcouch.CouchDbProperties;
import org.lightcouch.CouchDbException;

import twitter4j.GeoLocation;

import au.edu.unimelb.twitterSearch.SentimentClassifier;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**

Contains the domain logic and View rendering code to be used by the front 
facing JSP pages.

Team 1 - Adelaide
Erick Thomas Gaspar (527823)
Nasir Uddin (558747)
Mohamad Ilhamy Putra (595179)
Prapon Chaimuttayompol (575141)
Chi Wang (523312)


*/

public class CouchDB {
	
	private CouchDbProperties properties;
	private CouchDbClient dbClient;
	
	private String view_GeoLocationOfUser = "geo/geo_location_of_user";
	private String view_GeoLocationByTime = "geo/geo_location_over_time";
	private String view_CountTweet = "tweet/count_tweet_over_time";
	private String view_CountEnTweet = "tweet/count_en_tweet_over_time";
	private String view_CountNonEnTweet = "tweet/count_non_en_tweet_over_time";
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
		
		//Hokonent server
		/*properties = new CouchDbProperties()
		  .setDbName("adelaide_db")
		  .setCreateDbIfNotExist(true)
		  .setProtocol("http")
		  .setHost("115.146.94.161")
		  .setPort(5984)
		  .setMaxConnections(100)
		  .setConnectionTimeout(0);
		dbClient = new CouchDbClient(properties);*/
		
		properties = new CouchDbProperties()
		  .setDbName("adelaide_db")
		  .setCreateDbIfNotExist(true)
		  .setProtocol("http")
		  .setHost("115.146.93.55")
		  .setPort(5984)
		  .setMaxConnections(100)
		  .setConnectionTimeout(0);
		dbClient = new CouchDbClient(properties);
		
	}
	
	public List<TweetLocation> getTweetLocations(int limit){
		
		
		//List<JsonObject> allDocs = dbClient.view(view_GeoLocationOfUser).limit(limit).query(JsonObject.class);
		List<JsonObject> allDocs = dbClient.view(view_Tweet).limit(limit).query(JsonObject.class);
		//view_Tweet
		String id;
		String screen_name;
		String message;
		double[] geolocation = new double[2];
		List<TweetLocation> list = new ArrayList<TweetLocation>();
		
		for(JsonObject json : allDocs){
			screen_name = json.getAsJsonObject("value").get("screen_name").getAsString();
			message = json.getAsJsonObject("value").get("message").getAsString();
			geolocation[0] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(1).getAsDouble();
			id = json.get("id").getAsString();
			
			TweetLocation tweetlocation = new TweetLocation(id,screen_name,geolocation[0],geolocation[1]);
			tweetlocation.setMessage(message);
			
			list.add(tweetlocation);
			
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
		//List<JsonObject> allDocs = dbClient.view(view_GeoLocationByTime)
		List<JsonObject> allDocs = dbClient.view(view_Tweet)
											.limit(limit)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		String id;
		String screen_name;
		String message;
		double[] geolocation = new double[2];
		List<TweetLocation> list = new ArrayList<TweetLocation>();
		
		for(JsonObject json : allDocs){
			//screen_name = json.get("key").getAsString();
			screen_name = json.getAsJsonObject("value").get("screen_name").getAsString();
			message = json.getAsJsonObject("value").get("message").getAsString();
			geolocation[0] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(1).getAsDouble();
			id = json.get("id").getAsString();
			
			TweetLocation tweetlocation = new TweetLocation(id,screen_name,geolocation[0],geolocation[1]);
			tweetlocation.setMessage(message);
			
			list.add(tweetlocation);
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
	
	public TweetSentiment getSentiment(String c_filename, RectArea area,Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_Tweet)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		
		String tweet_message;
		TweetSentiment sentiment = new TweetSentiment();
		SentimentClassifier classifier = new SentimentClassifier(c_filename);
		double[] geolocation = new double[2];
		
		for(JsonObject json : allDocs){
			tweet_message = json.getAsJsonObject("value").get("message").getAsString();

			geolocation[0] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(1).getAsDouble();

			if(area.isInside(geolocation[0], geolocation[1])){
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
		}
		
		return sentiment;	
	}
	
	public TweetSentiment getSentimentExclude(String c_filename, RectArea area, RectArea ex_area,Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_Tweet)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		
		String tweet_message;
		TweetSentiment sentiment = new TweetSentiment();
		SentimentClassifier classifier = new SentimentClassifier(c_filename);
		double[] geolocation = new double[2];
		
		for(JsonObject json : allDocs){
			tweet_message = json.getAsJsonObject("value").get("message").getAsString();

			geolocation[0] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(1).getAsDouble();
			
			if(ex_area.isInside(geolocation[0], geolocation[0])){
				//Do Nothing
			}
			else if(area.isInside(geolocation[0], geolocation[1])){
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
		}
		
		return sentiment;	
	}
	
	public List<TweetSentiment> getDailySentiment(String c_filename, RectArea area,Date start_date, Date end_date){
		
		MutableDateTime temp_start = new MutableDateTime(start_date);
		MutableDateTime temp_end = new MutableDateTime(end_date);
		temp_start.setTime(0, 0, 0, 0);
		temp_end.setTime(0, 0, 0, 0);
		int days = Days.daysBetween(temp_start, temp_end).getDays() +1;
				
		List<TweetSentiment> sentiments_list = new ArrayList<TweetSentiment>();
				
		for(int i=0;i<days;i++){
			DateTime t1 = temp_start.toDateTime().plusDays(i);
			DateTime t2 = temp_start.toDateTime()
										.plusDays(i)
										.plusHours(23)
										.plusMinutes(59)
										.plusSeconds(59);

			TweetSentiment temp = getSentiment(c_filename, area, t1.toDate(), t2.toDate());
			temp.setDate(t1.toDate());
			
			System.out.println(t1);
			System.out.println(t2);
			sentiments_list.add(temp);
		}
		return sentiments_list;
	}
	
	public List<TweetSentiment> getDailySentimentExclude(String c_filename, RectArea area, RectArea ex_area,Date start_date, Date end_date){
		
		MutableDateTime temp_start = new MutableDateTime(start_date);
		MutableDateTime temp_end = new MutableDateTime(end_date);
		temp_start.setTime(0, 0, 0, 0);
		temp_end.setTime(0, 0, 0, 0);
		int days = Days.daysBetween(temp_start, temp_end).getDays() +1;
				
		List<TweetSentiment> sentiments_list = new ArrayList<TweetSentiment>();
				
		for(int i=0;i<days;i++){
			DateTime t1 = temp_start.toDateTime().plusDays(i);
			DateTime t2 = temp_start.toDateTime()
										.plusDays(i)
										.plusHours(23)
										.plusMinutes(59)
										.plusSeconds(59);

			TweetSentiment temp = getSentimentExclude(c_filename, area, ex_area, t1.toDate(), t2.toDate());
			temp.setDate(t1.toDate());
			
			System.out.println(t1);
			System.out.println(t2);
			sentiments_list.add(temp);
		}
		return sentiments_list;
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
	}
	
	public List<TweetCount> getTopKHashTag(int topK, 
											RectArea area, 
											RectArea ex_area,
											Date start_date, 
											Date end_date){
		
		MutableDateTime temp_start = new MutableDateTime(start_date);
		MutableDateTime temp_end = new MutableDateTime(end_date);
		temp_start.setTime(0, 0, 0, 0);
		temp_end.setTime(0, 0, 0, 0);
		int days = Days.daysBetween(temp_start, temp_end).getDays() +1;
		
		List<TweetCount> tweetcount_list = new ArrayList<TweetCount>();
		Map<String, Integer> rankingTable = new HashMap<String, Integer>();
		
		//Build the ranking Table
		for(int i=0;i<days;i++){
			DateTime t1 = temp_start.toDateTime().plusDays(i);
			DateTime t2 = temp_start.toDateTime()
										.plusDays(i)
										.plusHours(23)
										.plusMinutes(59)
										.plusSeconds(59);
			Map<String, Integer> temp = buildHashTag(area, ex_area, t1.toDate(), t2.toDate());
			System.out.println(t1);
			System.out.println(t2);
			
			for(String keyword : temp.keySet()){
				if(!rankingTable.containsKey(keyword)){
					rankingTable.put(keyword, temp.get(keyword));
				}
				else{
					rankingTable.put(keyword, rankingTable.get(keyword) + temp.get(keyword));
				}
			}
		}
		
		//Sort the list
		//--- do sorting
		Map<String, Integer> sortedMap = sortByComparator(rankingTable);
		//System.out.println(sortedMap);
		
		//
		int count = 1;
		for(String keyword : sortedMap.keySet()){
			System.out.println(keyword);
			TweetCount tweetkeyword = new TweetCount(null, rankingTable.get(keyword));
			tweetkeyword.setKeyword(keyword);
			tweetcount_list.add(tweetkeyword);
			
			if(tweetcount_list.size() == topK){
				break;
			}
			count++;
		}
		
		return tweetcount_list;
	}
	
	public List<TweetCount> getTopKHashTag(int topK, 
			RectArea area, 
			Date start_date, 
			Date end_date){

		MutableDateTime temp_start = new MutableDateTime(start_date);
		MutableDateTime temp_end = new MutableDateTime(end_date);
		temp_start.setTime(0, 0, 0, 0);
		temp_end.setTime(0, 0, 0, 0);
		int days = Days.daysBetween(temp_start, temp_end).getDays() +1;
		
		List<TweetCount> tweetcount_list = new ArrayList<TweetCount>();
		Map<String, Integer> rankingTable = new HashMap<String, Integer>();
		
		//Build the ranking Table
		for(int i=0;i<days;i++){
			DateTime t1 = temp_start.toDateTime().plusDays(i);
			DateTime t2 = temp_start.toDateTime()
					.plusDays(i)
					.plusHours(23)
					.plusMinutes(59)
					.plusSeconds(59);
			Map<String, Integer> temp = buildHashTag(area, t1.toDate(), t2.toDate());
			System.out.println(t1);
			System.out.println(t2);
			
			for(String keyword : temp.keySet()){
				if(!rankingTable.containsKey(keyword)){
					rankingTable.put(keyword, temp.get(keyword));
				}
				else{
					rankingTable.put(keyword, rankingTable.get(keyword) + temp.get(keyword));
				}
			}
		}
		
		//Sort the list
		//--- do sorting
		Map<String, Integer> sortedMap = sortByComparator(rankingTable);
		//System.out.println(sortedMap);
		
		//
		int count = 1;
		for(String keyword : sortedMap.keySet()){
		System.out.println(keyword);
		TweetCount tweetkeyword = new TweetCount(null, rankingTable.get(keyword));
		tweetkeyword.setKeyword(keyword);
		tweetcount_list.add(tweetkeyword);
		
		if(tweetcount_list.size() == topK){
			break;
		}
			count++;
		}
		
		return tweetcount_list;
	}
	
	private Map<String, Integer> buildHashTag(RectArea area, RectArea ex_area, Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		Map<String, Integer> rankingTable = new HashMap<String, Integer>();
		
		//Check pattern for hashtags
		Pattern MY_PATTERN = Pattern.compile("#(\\w+|\\W+)");
		
		List<JsonObject> allDocs = dbClient.view(view_Tweet)
														.startKey(modified_start_date)
														.endKey(modified_end_date)
														.query(JsonObject.class);
		double[] geolocation = new double[2];

		for(JsonObject json : allDocs){
			String text = json.getAsJsonObject("value").get("message").getAsString();
			geolocation[0] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(1).getAsDouble();
			
			if(ex_area.isInside(geolocation[0], geolocation[1])){
				// Do nothing
			}
			else if(area.isInside(geolocation[0], geolocation[1])){
				Matcher mat = MY_PATTERN.matcher(text);
				//List<String> hashtags =new ArrayList<String>();
				
				while (mat.find()) {
					String hashtag = mat.group(1);
					if(!rankingTable.containsKey(hashtag)){
						rankingTable.put(hashtag, 1);
					}
					else{
						rankingTable.put(hashtag, rankingTable.get(hashtag) + 1);
					}
				}
			}
		}
		
		return rankingTable;
	}
	
private Map<String, Integer> buildHashTag(RectArea area, Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		Map<String, Integer> rankingTable = new HashMap<String, Integer>();
		
		//Check pattern for hashtags
		Pattern MY_PATTERN = Pattern.compile("#(\\w+|\\W+)");
		
		List<JsonObject> allDocs = dbClient.view(view_Tweet)
														.startKey(modified_start_date)
														.endKey(modified_end_date)
														.query(JsonObject.class);
		double[] geolocation = new double[2];

		for(JsonObject json : allDocs){
			String text = json.getAsJsonObject("value").get("message").getAsString();
			geolocation[0] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(0).getAsDouble();
			geolocation[1] = json.getAsJsonObject("value").get("geo").getAsJsonArray().get(1).getAsDouble();
			
			if(area.isInside(geolocation[0], geolocation[1])){
				Matcher mat = MY_PATTERN.matcher(text);
				//List<String> hashtags =new ArrayList<String>();
				
				while (mat.find()) {
					String hashtag = mat.group(1);
					if(!rankingTable.containsKey(hashtag)){
						rankingTable.put(hashtag, 1);
					}
					else{
						rankingTable.put(hashtag, rankingTable.get(hashtag) + 1);
					}
				}
			}
		}
		
		return rankingTable;
	}
	
	public int countTweet(Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_CountTweet)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		
		for(JsonObject json : allDocs){
			return json.get("value").getAsInt();
		}
		
		return 0;
	}
	
	public int countEnTweet(Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_CountEnTweet)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		
		for(JsonObject json : allDocs){
			return json.get("value").getAsInt();
		}
		
		return 0;
	}
	
	public int countNonEnTweet(Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_CountNonEnTweet)
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
	
	public List<KeywordsCount> countDailyKeyword(String[] keywords, Date start_date, Date end_date){

		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		//Total days
		DateTime temp_start = new DateTime(start_date);
		DateTime temp_end = new DateTime(end_date);
		int days = Days.daysBetween(temp_start, temp_end).getDays() +1;
		
		List<JsonObject> allDocs = dbClient.view(view_TweetMessage)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		// tables[index] index refers to the keyword[index]
		List< Map<Date,Integer> > tables = new ArrayList< Map<Date,Integer> >(keywords.length);
		for(int i=0;i<keywords.length;i++){
			tables.add(new HashMap<Date,Integer>() );
		}
		
		//Map<Date,Integer> table = new HashMap<Date,Integer>();	//keep date and word frequency
		List<KeywordsCount> list = new ArrayList<KeywordsCount>();
		
		for(JsonObject json : allDocs){
			//Get date and tweet message
			Date date = convertToDate(json.get("key").getAsJsonArray());
			date = sethhmmss(date, 0, 0, 0);
			String message = json.get("value").getAsString();
			
			for(int j=0;j<keywords.length;j++){
				
				String keyword = keywords[j];
				
				if(message.toLowerCase().matches("(.*)"+keyword.toLowerCase()+"(.*)")){
					
					Map<Date,Integer> temp_table = tables.get(j);
					
					if(tables.get(j).containsKey(date)){
						
						temp_table.put(date, temp_table.get(date) + 1);
					}
					else{
						temp_table.put(date, 1);
					}
				}
			}
		}
		
		for(int i=0;i<days;i++){
			//Create list of graph which is k size
			DateTime temp_time = temp_start.plusDays(i);
			KeywordsCount keyCount = new KeywordsCount(temp_time.toDate());
			
			for(int k=0;k<tables.size();k++){
				Map<Date,Integer> table = tables.get(k);
				String keyword = keywords[k];
				
				for(Date tempDate : table.keySet()){
					if(tempDate.equals(temp_time.toDate())){
						keyCount.setKeyword(keyword, table.get(tempDate));
					}
				}
			}
			
			list.add(keyCount);
		}
		
		return list;
	}
	
	/*
	public List<TweetCount> countDailyKeyword(String[] keywords, Date start_date, Date end_date){
		
		int[] modified_start_date = convertToDateArray(start_date);
		int[] modified_end_date = convertToDateArray(end_date);
		
		List<JsonObject> allDocs = dbClient.view(view_TweetMessage)
											.startKey(modified_start_date)
											.endKey(modified_end_date)
											.query(JsonObject.class);
		// tables[index] index refers to the keyword[index]
		List< Map<Date,Integer> > tables = new ArrayList< Map<Date,Integer> >(keywords.length);
		for(int i=0;i<keywords.length;i++){
			tables.add(new HashMap<Date,Integer>() );
		}
		
		//Map<Date,Integer> table = new HashMap<Date,Integer>();	//keep date and word frequency
		List<TweetCount> list = new ArrayList<TweetCount>();
		
		for(JsonObject json : allDocs){
			//Get date and tweet message
			Date date = convertToDate(json.get("key").getAsJsonArray());
			date = sethhmmss(date, 0, 0, 0);
			String message = json.get("value").getAsString();
			
			for(int j=0;j<keywords.length;j++){
				
				String keyword = keywords[j];
				
				if(message.toLowerCase().matches("(.*)"+keyword.toLowerCase()+"(.*)")){
					
					Map<Date,Integer> temp_table = tables.get(j);
					
					if(tables.get(j).containsKey(date)){
						
						temp_table.put(date, temp_table.get(date) + 1);
					}
					else{
						temp_table.put(date, 1);
					}
				}
			}
		}
		
		for(int k=0;k<tables.size();k++){
			
			Map<Date,Integer> table = tables.get(k);
			
			for(Date tempDate : table.keySet()){
				TweetCount twc = new TweetCount(tempDate,table.get(tempDate));
				twc.setKeyword(keywords[k]);
				list.add(twc);
			}
		}
		
		return list;
	}*/
	
	public List<KeywordsCount> countDailyKeyword_effectively(String[] keyword, Date start_date, Date end_date){
		
		//int number_of_keyword = keywords.length;
		MutableDateTime temp_start = new MutableDateTime(start_date);
		MutableDateTime temp_end = new MutableDateTime(end_date);
		temp_start.setTime(0, 0, 0, 0);
		temp_end.setTime(0, 0, 0, 0);
		int days = Days.daysBetween(temp_start, temp_end).getDays() +1;
		
		List<KeywordsCount> keywordcount = new ArrayList<KeywordsCount>();
		
		System.out.println(days);
		for(int i=0;i<days;i++){
			DateTime t1 = temp_start.toDateTime().plusDays(i);
			DateTime t2 = temp_start.toDateTime()
										.plusDays(i)
										.plusHours(23)
										.plusMinutes(59)
										.plusSeconds(59);

			List<KeywordsCount> tempList = countDailyKeyword(keyword,t1.toDate(),t2.toDate());
			System.out.println(t1);
			System.out.println(t2);
			keywordcount.addAll(tempList);
		}
		return keywordcount;
	}
	
	private Date sethhmmss(Date date,int hh, int mm, int ss){
		Calendar date_calendar = GregorianCalendar.getInstance(); // creates a new calendar instance
		date_calendar.setTime(date);   // assigns calendar to given date
		Date new_date = null;
		
		try {
			new_date = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
								.parse(date_calendar.get(Calendar.YEAR) 
										+ "-" + (date_calendar.get(Calendar.MONTH) +1) 
										+ "-" + date_calendar.get(Calendar.DAY_OF_MONTH)
										+ " " + hh + ":" + mm + ":" + ss );
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return new_date;
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
	
	private static Map sortByComparator(Map unsortMap) {
		 
		List list = new LinkedList(unsortMap.entrySet());
 
		// sort list based on comparator
		Collections.sort(list, new Comparator() {
			public int compare(Object o1, Object o2) {
				return ((Comparable) ((Map.Entry) (o2)).getValue())
                                       .compareTo(((Map.Entry) (o1)).getValue());
			}
		});
		System.out.println(list);
		// put sorted list into map again
                //LinkedHashMap make sure order in which keys were inserted
		Map sortedMap = new LinkedHashMap();
		for (Iterator it = list.iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			sortedMap.put(entry.getKey(), entry.getValue());
		}
		return sortedMap;
	}

	public static void main(String[] args) {
		
		CouchDB db = new CouchDB();
		Date start_time = null;
		Date end_time = null;
		try {
			start_time = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse("2013-09-28 00:00:00");
			end_time = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").parse("2013-09-29 23:59:59");
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		RectArea adelaid_city = new RectArea(new GeoLocation(-34.8130075199158, 138.70000000000005), 
				new GeoLocation(-34.97030508204433, 138.4835205078125));
		RectArea rural = new RectArea(new GeoLocation(-34.59172168044161, 139.11198730468755), 
				new GeoLocation(-35.27582555470527, 138.412109375));

		List<TweetCount> twc = db.getTopKHashTag(5,rural, adelaid_city, start_time, end_time);
		
		for(TweetCount count : twc){
			System.out.println(count.getKeyword() + " " + count.getCount());
		}
		
		
		/*RectArea adelaid_city = new RectArea(new GeoLocation(-34.8130075199158, 138.70000000000005), 
				new GeoLocation(-34.97030508204433, 138.4835205078125));
		RectArea rural = new RectArea(new GeoLocation(-34.59172168044161, 139.11198730468755), 
				new GeoLocation(-35.27582555470527, 138.412109375));
		
		List<TweetSentiment> sentiment_list_rural = db.getDailySentimentExclude("classifier.txt", rural,adelaid_city, start_time, end_time);
		List<TweetSentiment> sentiment_list_city = db.getDailySentiment("classifier.txt", adelaid_city, start_time, end_time);
		
		System.out.println("-------rural-----");
		for(TweetSentiment sentiment : sentiment_list_rural){
			System.out.println(sentiment.getDate() + " --- " + sentiment.countTotalTweets());
		}
		
		System.out.println("-------city-----");
		for(TweetSentiment sentiment : sentiment_list_city){
			System.out.println(sentiment.getDate() + " --- " + sentiment.countTotalTweets());
		}*/
		
		//int count = db.countTweet1(start_time,end_time);
		//System.out.println(count);
		
		/*List<KeywordsCount> twc1 = db.countDailyKeyword_effectively(new String[]{"GTA","game","AFL"}, start_time, end_time);

		for(KeywordsCount count : twc1){
			System.out.println(count.getDate() + " " + count.getTable() );
		}*/
		
		/*UserStatList list = db.getTopUser("classifier.txt",start_time, end_time);
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
		}*/
		
		//TweetSentiment sentiment = db.getSentiment("classifier.txt",start_time, end_time);
		/*RectArea my_area = new RectArea(new GeoLocation(-34.89187235171962, 138.65920136914065), 
										new GeoLocation(-34.95871643413578, 138.55756948632802));
		TweetSentiment sentiment = db.getSentiment("classifier.txt",my_area,start_time, end_time);
		System.out.println("positive=" + sentiment.getPositive() );
		System.out.println("negative=" + sentiment.getNegative() );
		System.out.println("neutral=" + sentiment.getNeutral() );*/
		
		//System.out.println(db.countDailyTweet(start_time, end_time));
		
		/*List<TweetCount> temp = db.countDailyTweet(start_time, end_time);
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
