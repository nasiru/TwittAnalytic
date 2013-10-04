package au.edu.unimelb.twitterSearch;

public class test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		SentimentClassifier cl = new SentimentClassifier("classifier.txt");
		System.out.println(cl.classify("bored?"));
	}

}
