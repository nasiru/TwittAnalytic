package SimpleCouchDB;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**

Used to maintain statistics for a particular keyword or phrase

Team 1 - Adelaide
Erick Thomas Gaspar (527823)
Nasir Uddin (558747)
Mohamad Ilhamy Putra (595179)
Prapon Chaimuttayompol (575141)
Chi Wang (523312)


*/

public class KeywordsCount {
	
	private Date date;
	private Map<String, Integer> counts;
	
	public KeywordsCount(Date date){
		this.date = date;
		counts = new HashMap<String, Integer>();
	}
	
	public KeywordsCount(Date date, Map<String, Integer> counts){
		this.date = date;
		this.counts = counts;
	}
	
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}

	public void setKeyword(String key, int value){
		counts.put(key, value);
	}
	
	public int getCount(String key){
		if(counts.containsKey(key)){
			return counts.get(key);
		}
		else{
			return 0;
		}
	}
	
	public Map<String, Integer> getTable(){
		return counts;
	}

}
