//
//  TwitterClient.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TwitterClient.h"
#import "TweetModel.h"

@implementation TwitterClient


/**
 * Objective-C Singleton pattern, from:
 * http://stackoverflow.com/questions/2199106/thread-safe-instantiation-of-a-singleton#answer-2202304
 */
+ (TwitterClient *)instance {
	static TwitterClient *instance = nil;
	static dispatch_once_t pred;
	
	if (instance) return instance;
	
	dispatch_once(&pred, ^{
		instance = [TwitterClient alloc];
		instance = [instance initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] consumerKey:@"CVOfIgyTu2uIc7IOshtw" consumerSecret:@"6FFmD3Su0l2rMOcezmdBtQXaoatdT6szNZffzJuSQ0"];
	});
	
	return instance;
}

- (void)authorizeApp {
	
	// Remove stale access token when attempting to login again
	[self.requestSerializer removeAccessToken];
	
	NSString *requestTokenPath = @"oauth/request_token";
	NSString *authorizeURL = @"https://api.twitter.com/oauth/authorize";
	NSString *method = @"POST";
	
	// can deeplink into app with this callback url if desired
	// Project Navigator -> Project -> Info -> URL Types -> URL Schemes
	NSURL *callbackURL = [NSURL URLWithString:@"quitterapp://oauth-authorizeApp"];
	
	[self fetchRequestTokenWithPath:requestTokenPath method:method callbackURL:callbackURL scope:nil success:^(BDBOAuthToken *requestToken) {
		NSString *authURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@", authorizeURL, requestToken.token];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURLWithToken]];
	} failure:^(NSError *error) {
		NSLog(@"error getting request token:%@", error);
	}];
	
}

- (void)fetchHomeTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success {
	
	NSString *requestPath = @"1.1/statuses/home_timeline.json";
//	NSDictionary *params = @{@"screen_name": @"ericsoco"};
	
	void(^ failure)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"error fetching tweets:%@", error);
//		[ZAActivityBar showErrorWithStatus:@"Something went wrong. Please pull down to reload tweets."];
	};
	
	[self GET:requestPath parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
		NSMutableArray *tweetModels = [NSMutableArray array];
		if ([response isKindOfClass:[NSArray class]]) {
			for (NSDictionary *tweetData in response) {
				[tweetModels addObject:[TweetModel initWithJSON:tweetData]];
			}
			success(tweetModels);
		} else {
			// bad server response
			failure(nil, [NSError errorWithDomain:@"com.transmote.quitter" code:1
										 userInfo:@{@"message": @"Invalid response",
													@"response": response
													}]);
		}
	} failure:failure];
	
}

@end