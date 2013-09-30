package au.edu.unimelb.twitterSearch;

import java.io.File;
import java.io.IOException;

import com.aliasi.classify.ConditionalClassification;
import com.aliasi.classify.LMClassifier;
import com.aliasi.util.AbstractExternalizable;

public class SentimentClassifier {

	String[] categories;
	LMClassifier classfyr;

	public SentimentClassifier(String filename) {
	
	try {
		//classfyr= (LMClassifier) AbstractExternalizable.readObject(new File("/WEB-INF/classifier/classifier.txt"));
		classfyr= (LMClassifier) AbstractExternalizable.readObject(new File(filename));
		categories = classfyr.categories();
	}
	catch (ClassNotFoundException e) {
		e.printStackTrace();
	}
	catch (IOException e) {
		e.printStackTrace();
	}

	}

	public String classify(String text) {
	ConditionalClassification classification = classfyr.classify(text);
	return classification.bestCategory();
	}	
	
}
