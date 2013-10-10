package SimpleCouchDB;

import java.util.Comparator;
import java.util.Map;

/**

Sentiment Analysis comparator

Team 1 - Adelaide
Erick Thomas Gaspar (527823)
Nasir Uddin (558747)
Mohamad Ilhamy Putra (595179)
Prapon Chaimuttayompol (575141)
Chi Wang (523312)


*/

class ValueComparator implements Comparator<String> {

    Map<String, UserStat> base;
    String sentiment;
    
    public ValueComparator(Map<String, UserStat> base, String sentiment) {
        this.base = base;
        this.sentiment = sentiment;
    }

    // Note: this comparator imposes orderings that are inconsistent with equals.    
    public int compare(String a, String b) {
    	//System.out.println(base);
    	//System.out.println(a +" "+ b);
    	if(sentiment.equals("pos")){
    		if (base.get(a).getPositive_tweet() >= base.get(b).getPositive_tweet()) {
                return -1;
            } else {
                return 1;
            } // returning 0 would merge keys
    	}
    	else if(sentiment.equals("neg")){
    		if (base.get(a).getNegative_tweet() >= base.get(b).getNegative_tweet()) {
                return -1;
            } else {
                return 1;
            } // returning 0 would merge keys
    	}
    	else if(sentiment.equals("neu")){
    		if (base.get(a).getNeutral_tweet() >= base.get(b).getNeutral_tweet()) {
                return -1;
            } else {
                return 1;
            } // returning 0 would merge keys
    	}
    	else if(sentiment.equals("all")){
    		if (base.get(a).getAll_tweet() >= base.get(b).getAll_tweet()) {
                return -1;
            } else {
                return 1;
            } // returning 0 would merge keys
    	}
    	return 0;
        
    }
}