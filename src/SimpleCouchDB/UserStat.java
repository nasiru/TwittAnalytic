package SimpleCouchDB;

public class UserStat {
	
	private String screen_name;
	private int positive_tweet;
	private int negative_tweet;
	private int neutral_tweet;
	//private int all_tweet;
	
	public UserStat(String username){
		setScreen_name(username);
		positive_tweet = 0;
		negative_tweet = 0;
		neutral_tweet = 0;
		//all_tweet = 0;
	}
	
	public void incrementPos(){
		this.positive_tweet++;
	}
	
	public void incrementNeg(){
		this.negative_tweet++;
	}
	
	public void incrementNeu(){
		this.neutral_tweet++;
	}
	
	public void increment(String sentiment){
		if(sentiment.equals("pos")){
			this.positive_tweet++;
		}
		else if(sentiment.equals("neg")){
			this.negative_tweet++;
		}
		else if(sentiment.equals("neu")){
			this.neutral_tweet++;
		}
	}

	public String getScreen_name() {
		return screen_name;
	}

	public void setScreen_name(String screen_name) {
		this.screen_name = screen_name;
	}

	public int getPositive_tweet() {
		return positive_tweet;
	}

	public void setPositive_tweet(int positive_tweet) {
		this.positive_tweet = positive_tweet;
	}

	public int getNegative_tweet() {
		return negative_tweet;
	}

	public void setNegative_tweet(int negative_tweet) {
		this.negative_tweet = negative_tweet;
	}

	public int getNeutral_tweet() {
		return neutral_tweet;
	}

	public void setNeutral_tweet(int neutral_tweet) {
		this.neutral_tweet = neutral_tweet;
	}

	public int getAll_tweet() {
		return positive_tweet + negative_tweet + neutral_tweet;
	}

	/*public void setAll_tweet(int all_tweet) {
		this.all_tweet = all_tweet;
	}*/

}
