import java.util.List;

import org.lightcouch.CouchDbClient;

import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;
import twitter4j.json.DataObjectFactory;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

public class test1 {

	/**
	 * Usage: java twitter4j.examples.search.SearchTweets [query]
	 * 
	 * @param args
	 * @throws InterruptedException
	 */
	public static void main(String[] args) throws InterruptedException {
		int count = 0;

		CouchDbClient db = new CouchDbClient("couchdb.properties");


		CouchDbClient dbLocal = new CouchDbClient("couchdblocal.properties");

//		ConfigurationBuilder cb = new ConfigurationBuilder();
//		cb.setDebugEnabled(true)
//				.setOAuthConsumerKey("UPPeoMIG5z3Abp0drdQJw")
//				.setOAuthConsumerSecret(
//						"bz3FLdqMp8QX3Tx2bdgzeRW26waHAMYNoxjQftP8dI")
//				.setOAuthAccessToken(
//						"1889233045-FbHawUOxyd2xJZwEW5jF2QUAfWNjlcAQfjSn4ML")
//				.setOAuthAccessTokenSecret(
//						"Qqb8eD9pGqRupNS4A0r0l7cpWY2HTGqtwrlvklxLY");
//		cb.setJSONStoreEnabled(true);
//
//		TwitterFactory tf = new TwitterFactory(cb.build());
//
//		Twitter twitter = tf.getInstance();
		while (true) {
			List<JsonObject> listOfUser = db.view("user/count_tweet_per_user")
					.group(true).groupLevel(9).query(JsonObject.class);

			for (JsonObject user : listOfUser) {

				System.out.println(count + " counting");

				JsonObject json = new JsonObject();
				json.addProperty("_id", String.valueOf(count));
				json.add("twits", null);
				dbLocal.save(json);
				count++;

			}
		}
	}
}
