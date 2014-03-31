//
//  TweetModel.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TweetModel.h"
#import "MHPrettyDate.h"

@implementation TweetModel

+ (NSMutableDictionary *)models {
	// Static variables are declared only once. Ever.
	static NSMutableDictionary *modelsDict = nil;
	
	// Initialize only once.
	if (!modelsDict) {
		modelsDict = [NSMutableDictionary dictionary];
	}
	
	return modelsDict;
}

+ (TweetModel *)initWithJSON:(NSDictionary *)json {
	TweetModel *model = [TweetModel models][json[@"id"]];
	if (!model) {
		model = [[TweetModel alloc] init];
		model.id = json[@"id_str"];
		model.text = json[@"text"];
		model.numRetweets = json[@"retweet_count"];
		model.numFavorites = json[@"favorite_count"];
		
		model.datestamp = [[TweetModel longDateFormatter] dateFromString:json[@"created_at"]];
		model.shortDateStr = [MHPrettyDate prettyDateFromDate:model.datestamp withFormat:MHPrettyDateShortRelativeTime];
		model.longDateStr = [NSDateFormatter localizedStringFromDate:model.datestamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
		
		NSDictionary *retweetStatus = json[@"retweeted_status"];
		if (retweetStatus) {
			// favorite_count exists within retweeted_status when retweeted_status exists.
			model.numFavorites = retweetStatus[@"favorite_count"];
			model.retweeter = [UserModel initWithJSON:json[@"user"]];
			model.user = [UserModel initWithJSON:retweetStatus[@"user"]];
		} else {
			model.user = [UserModel initWithJSON:json[@"user"]];
		}
		
		[TweetModel models][json[@"id"]] = model;
	}
	
	return model;
}

+ (NSDateFormatter *)longDateFormatter {
	static NSDateFormatter *longDateFormatter;
	
	if (!longDateFormatter) {
		longDateFormatter = [[NSDateFormatter alloc] init];
		[longDateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
	}
	
	return longDateFormatter;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<TweetModel: %@>", self.text];
}

@end
