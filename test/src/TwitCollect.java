import com.fourspaces.couchdb.Database;
import com.fourspaces.couchdb.Document;
import com.fourspaces.couchdb.Session;

import twitter4j.*;
import twitter4j.conf.ConfigurationBuilder;
import twitter4j.json.DataObjectFactory;

public final class TwitCollect {

	static Session dbSession;

	static Database db;

	public static void main(String[] args) throws TwitterException {

		createDatabase(args[0], args[1]);

        ConfigurationBuilder cb = new ConfigurationBuilder();
     	cb.setDebugEnabled(true)
     	  .setOAuthConsumerKey("")
     	  .setOAuthConsumerSecret("")
     	  .setOAuthAccessToken("-")
     	  .setOAuthAccessTokenSecret("");
     	cb.setJSONStoreEnabled(true);

		TwitterStreamFactory tf = new TwitterStreamFactory(cb.build());

		TwitterStream twitterStream = tf.getInstance();
		StatusListener listener = new StatusListener() {
			@Override
			public void onStatus(Status status) {
				if (status.getGeoLocation() != null) {

					DataObjectFactory.getRawJSON(status.getUser());
					saveDocument(getDocument(String.valueOf(status.getId()),

					DataObjectFactory.getRawJSON(status)

					));
				}

			}

			@Override
			public void onDeletionNotice(
					StatusDeletionNotice statusDeletionNotice) {
				// System.out.println("Got a status deletion notice id:" +
				// statusDeletionNotice.getStatusId());
			}

			@Override
			public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
				// System.out.println("Got track limitation notice:" +
				// numberOfLimitedStatuses);
			}

			@Override
			public void onScrubGeo(long userId, long upToStatusId) {
				// System.out.println("Got scrub_geo event userId:" + userId +
				// " upToStatusId:" + upToStatusId);
			}

			@Override
			public void onStallWarning(StallWarning warning) {
				// System.out.println("Got stall warning:" + warning);
			}

			@Override
			public void onException(Exception ex) {
				ex.printStackTrace();
			}
		};

		twitterStream.addListener(listener);
		double[][] loc = { { 136.5271, -36.155618 },
				{ 139.400024, -34.288992 },

		};
		twitterStream.filter(new FilterQuery().locations(loc));
	}

	public static void createDatabase(String ip, String dbName) {

		dbSession = new Session(ip, 5984);

		if (dbSession.getDatabaseNames().contains(dbName)) {
			db = dbSession.getDatabase(dbName);
		} else {
			db = dbSession.createDatabase(dbName);
		}
	}

	public static Document getDocument(String id, String twit) {

		Document doc = new Document();

		doc.setId(id);
		doc.put("twit", twit);

		return doc;

	}

	public static void saveDocument(Document doc) {

		try {

			db.saveDocument(doc);

		} catch (Exception e) {

		}

	}
}
