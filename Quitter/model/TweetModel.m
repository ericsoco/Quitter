//
//  TweetModel.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TweetModel.h"

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
		model.userName = json[@"user"][@"name"];
		model.userScreenName = json[@"user"][@"screen_name"];
		model.userProfileImageUrl = json[@"user"][@"profile_image_url_https"];
		
		/*
		model.locationString = [NSString stringWithFormat:@"%@, %@", model.address, model.neighborhood];
		
		NSMutableArray *categoryNames = [NSMutableArray array];
		[(NSArray *)json[@"categories"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[categoryNames addObject:((NSArray *)obj)[0]];
		}];
		model.categories = [categoryNames componentsJoinedByString:@", "];
		*/
		
		[TweetModel models][json[@"id"]] = model;
	}
	
	return model;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<TweetModel: %@>", self.text];
}

@end
