import com.fourspaces.couchdb.Database;
import com.fourspaces.couchdb.Document;
import com.fourspaces.couchdb.Session;

import twitter4j.*;
import twitter4j.conf.ConfigurationBuilder;
import twitter4j.json.DataObjectFactory;

public final class TwitCollectFreman {

	static Session dbSession;

	static Database db;

	public static void main(String[] args) throws TwitterException {

		createDatabase(args[0], args[1]);

		ConfigurationBuilder cb = new ConfigurationBuilder();
		cb.setDebugEnabled(true)
				.setOAuthConsumerKey("lL8pPeYPbdJoUdj14VrCg")
				.setOAuthConsumerSecret(
						"HWkmXzA10XtGVsGg91R4RX4Rm9bPeyE8UE1MWo8Ak0")
				.setOAuthAccessToken(
						"1889233045-nYlDsN2Lv4m1TXgBCA113HlkvDceooyrv36Fhyz")
				.setOAuthAccessTokenSecret(
						"fijl8cprpYvvbmSU54ECgMgyGfNqgiQXrEFRTjjXWQ");
		cb.setJSONStoreEnabled(true);

		TwitterStreamFactory tf = new TwitterStreamFactory(cb.build());

		TwitterStream twitterStream = tf.getInstance();
		StatusListener listener = new StatusListener() {
			@Override
			public void onStatus(Status status) {

				// System.out.println(status.toString());
				DataObjectFactory.getRawJSON(status.getUser());
				saveDocument(getDocument(String.valueOf(status.getId()),
						DataObjectFactory.getRawJSON(status)));
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
		double[][] loc = { { 134.351807, -36.226550 },
				{ 140.822754, -35.317366 },

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
		doc.put("twits", twit);

		return doc;

	}

	public static void saveDocument(Document doc) {

		try {

			db.saveDocument(doc);

		} catch (Exception e) {

		}

	}
}
