package SimpleCouchDB;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class UserStatList {
	
	private Map<String, UserStat> usersStatTable;
	private ValueComparator compare_pos;
	private ValueComparator compare_neg;
	private ValueComparator compare_neu;
	private ValueComparator compare_all;
	
	public UserStatList(Map<String, UserStat> usersStatTable){
		this.usersStatTable = usersStatTable;
		
		compare_pos =  new ValueComparator(usersStatTable,"pos");
		compare_neg =  new ValueComparator(usersStatTable,"neg");
		compare_neu =  new ValueComparator(usersStatTable,"neu");
		compare_all =  new ValueComparator(usersStatTable,"all");
	}
	
	public List<UserStat> getListSortedByPos(int topK){
		return getListSortedBy("pos", topK);
	}
	
	public List<UserStat> getListSortedByNeg(int topK){
		return getListSortedBy("neg", topK);
	}
	
	public List<UserStat> getListSortedByNeu(int topK){
		return getListSortedBy("neu", topK);
	}
	
	public List<UserStat> getListSortedByTotalTweet(int topK){
		return getListSortedBy("all", topK);
	}
	
	private List<UserStat> getListSortedBy(String sentiment, int topK){
		TreeMap<String, UserStat> rankingTable;
		
		if(sentiment.equals("pos")){
			rankingTable = new TreeMap<String, UserStat>(compare_pos);
		}
		else if(sentiment.equals("neg")){
			rankingTable = new TreeMap<String, UserStat>(compare_neg);
		}
		else if(sentiment.equals("neu")){
			rankingTable = new TreeMap<String, UserStat>(compare_neu);
		}
		else{
			rankingTable = new TreeMap<String, UserStat>(compare_all);
		}
		
		rankingTable.putAll(usersStatTable);
		
		List<UserStat> users = new ArrayList<UserStat>();
		int counter = 1;
		for(UserStat userstat : rankingTable.values()){
			//Add user to the list
			users.add(userstat);
			
			//Break when reach the topk
			if(counter == topK) break;
			counter++;
		}
		
		return users;
	}
}
