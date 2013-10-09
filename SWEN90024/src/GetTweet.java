
import java.util.*;
import org.lightcouch.CouchDbClient;

import com.google.gson.JsonObject;
import org.lightcouch.DocumentConflictException;
import twitterSearch.SentimentClassifier;


public class GetTweet {

    public static void main(String[] args) {
        CouchDbClient dbLocalClient = new CouchDbClient("localhost.properties");
        CouchDbClient dbAtreidesClient = new CouchDbClient("atreides.properties");
        //CouchDbClient dbHarkonnenClient = new CouchDbClient("harkonnen.properties");
        //CouchDbClient dbFremenClient = new CouchDbClient("fremen.properties");
        //CouchDbClient dbOrdosClient = new CouchDbClient("ordos.properties");
        SentimentClassifier sentimentClassifier = new SentimentClassifier("classifier.txt");

          List<JsonObject> listOfTweet = dbLocalClient.view("tweet/gettweet").limit(250).query(JsonObject.class);
          for(JsonObject tweet : listOfTweet){
              if(tweet.get("value").isJsonNull()){
                JsonObject json = tweet.get("key").getAsJsonObject();
                json.addProperty("inserted", true);
                dbLocalClient.update(json);
                String input = json.get("twits").getAsJsonObject().get("text").getAsString();
                json.addProperty("sentiment", sentimentClassifier.classify(input));
                json.remove("inserted");
                json.remove("_rev");
                try{
                    dbAtreidesClient.save(json);
                }catch(DocumentConflictException e){}}
          }
    }
}