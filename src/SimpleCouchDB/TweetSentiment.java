package SimpleCouchDB;

public class TweetSentiment {
	
	private int neutral;
	private int positive;
	private int negative;
	
	public TweetSentiment(){
		neutral = 0;
		positive = 0;
		negative = 0;
	}
	
	public int getNeutral() {
		return neutral;
	}
	public int getPositive() {
		return positive;
	}
	public int getNegative() {
		return negative;
	}
	public void setNeutral(int neutral) {
		this.neutral = neutral;
	}
	public void setPositive(int positive) {
		this.positive = positive;
	}
	public void setNegative(int negative) {
		this.negative = negative;
	}
	public void incrementNeutral(){
		this.neutral++;
	}
	public void incrementPositive(){
		this.positive++;
	}
	public void incrementNegative() {
		this.negative++;
	}
	public int countTotalTweets(){
		return neutral + positive + negative;
	}
	
}
