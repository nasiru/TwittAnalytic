package SimpleCouchDB;

import java.util.Date;

public class TweetCount {
	
	private Date date;
	private int count;
	
	public TweetCount(Date date, int count){
		this.date = date;
		this.count = count;
	}
	
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	

}
