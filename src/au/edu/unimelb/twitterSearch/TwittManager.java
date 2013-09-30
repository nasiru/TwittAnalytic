package au.edu.unimelb.twitterSearch;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;

public class TwittManager {
	SentimentClassifier sentClassifier;
	int LIMIT= 500; //the number of retrieved tweets
	ConfigurationBuilder cb;
	Twitter twitter;

	public TwittManager() {
		cb = new ConfigurationBuilder();
		cb.setOAuthConsumerKey("0Ja3FG4Ty0z5fS1E7omEVw");
		cb.setOAuthConsumerSecret("UatKBi2XfxxdRb7h6mISU1q4ww2YAvwKmRUqKGDu8nc");
		cb.setOAuthAccessToken("1113512082-5MxDAbl2q7VljMl7EMH3TxVSaZjqn9CVBaDZwIz");
		cb.setOAuthAccessTokenSecret("CGBO3as3PqKv7XBCLYlixySNO9I0LvJqRW16ySJaQ");
		twitter = new TwitterFactory(cb.build()).getInstance();
		sentClassifier = new SentimentClassifier("classifier.txt");
	}

	public void performQuery(String inQuery) throws InterruptedException, IOException {
		Query query = new Query(inQuery);
		query.setCount(100);
		try {
			int count=0;
			QueryResult result;
/*	        do {
	            result = twitter.search(query);
	            List<Status> tweets = result.getTweets();
	            for (Status tweet : tweets) {
	                System.out.println("@" + tweet.getUser().getScreenName() + " - " + tweet.getText());
	                String sent = sentClassifier.classify(tweet.getText());
	                System.err.println("Sentiment: " + sent); 
	            }
	        } while ((query = result.nextQuery()) != null);
	        System.exit(0);*/
        
			do {
				result = twitter.search(query);
				List<Status> tweets = result.getTweets();
				ArrayList ts= (ArrayList) result.getTweets();

				for (int i = 0; i < ts.size() && count < LIMIT; i++) {
					count++;
					Status t = (Status) ts.get(i);
					String text = t.getText();
					//System.out.println("Text: " + text);
					String name = t.getUser().getScreenName();
					//System.out.println("User: " + name);
					String sent = sentClassifier.classify(t.getText());
					//System.err.println("Sentiment: " + sent); 
					System.out.println("#Sentiment: " + sent +"==@" + t.getUser().getScreenName() + " - " + t.getText());
					//System.err.println("Sentiment: " + sent);
					//count++;
				}   
			} while ((query = result.nextQuery()) != null && count < LIMIT);
		}		
		catch (TwitterException te) {
			System.out.println("Couldn't connect: " + te);
		}
		
        /*          
        Status status;
		try {
			status = twitter.updateStatus("running sentiment analysis");
	        System.out.println("Successfully updated the status to [" + status.getText() + "].");
		} catch (TwitterException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}


        try {

        	ResponseList<Status> a = twitter.getUserTimeline(new Paging(1,5));
        	
        	for(Status b: a) {
        		System.out.println(b.getText());
        	}
        	

        }catch(Exception e ){
        	
        }
        
      try {
            Query query = new Query("obama");
            QueryResult result;
            do {
                result = twitter.search(query);
                List<Status> tweets = result.getTweets();
                for (Status tweet : tweets) {
                    System.out.println("@" + tweet.getUser().getScreenName() + " - " + tweet.getText());
                }
            } while ((query = result.nextQuery()) != null);
            System.exit(0);
        } catch (TwitterException te) {
            te.printStackTrace();
            System.out.println("Failed to search tweets: " + te.getMessage());
            System.exit(-1);
        }*/
	}
}
