/**
 * This Class is used to get the list of status.
 */
package au.edu.unimelb.twitterSearch;

import java.io.IOException;
import java.util.List;

import twitter4j.Paging;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.ResponseList;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;

public class TwittAnalytic {
	
	public static void main(String[] args) {
		
		
        TwittManager twittManager = new TwittManager();
        Twitter twitter = new TwitterFactory().getSingleton();
        
		//	My Applications Consumer and Auth Access Token
        //twitter.setOAuthConsumer("", "");
        //twitter.setOAuthAccessToken(new AccessToken("", ""));

        try {
			twittManager.performQuery("Tony Abott");
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}	
	
}
