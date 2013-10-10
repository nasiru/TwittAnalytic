package SimpleCouchDB;

import java.util.Date;

/**

Wrapper for other sentiment classes

Team 1 - Adelaide
Erick Thomas Gaspar (527823)
Nasir Uddin (558747)
Mohamad Ilhamy Putra (595179)
Prapon Chaimuttayompol (575141)
Chi Wang (523312)


*/

public class TweetSentiment {
	
	private int neutral;
	private int positive;
	private int negative;
	private Date date;
	
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

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
	
}
