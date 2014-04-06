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

@synthesize authorizedUser = _authorizedUser;

- (UserModel *)authorizedUser {
	if (!_authorizedUser) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSData *userData = [defaults objectForKey:@"authorizedUser"];
		_authorizedUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
	}
	
	return _authorizedUser;
}

- (void)setAuthorizedUser:(UserModel *)authorizedUser {
	NSLog(@"setAuthorizedUser:%@", authorizedUser);
	_authorizedUser = authorizedUser;
	
	NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:_authorizedUser];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:userData forKey:@"authorizedUser"];
	[defaults synchronize];
}

- (void)authorizeApp {
	
	// Remove stale access token when attempting to login again
	[self.requestSerializer removeAccessToken];
	self.authorizedUser = nil;
	
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

- (void)fetchAccountCredentialsWithSuccess:(void (^)(UserModel *userModel))success {
	
	NSString *requestPath = @"1.1/account/verify_credentials.json";
	
	void(^ failure)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"error verifying account credentials:%@", error);
		//		[ZAActivityBar showErrorWithStatus:@"Something went wrong. Please pull down to reload tweets."];
	};
	
	[self GET:requestPath parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
		if ([response isKindOfClass:[NSDictionary class]]) {
			UserModel *userModel = [UserModel initWithJSON:response];
			self.authorizedUser = userModel;
			success(userModel);
		} else {
			// bad server response
			failure(nil, [NSError errorWithDomain:@"com.transmote.quitter" code:1
										 userInfo:@{@"message": @"[fetchAccountCredentials] invalid response",
													@"response": response
													}]);
		}
	} failure:failure];
	
}

- (void)fetchHomeTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success {
	
	NSString *requestPath = @"1.1/statuses/home_timeline.json";
	
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
										 userInfo:@{@"message": @"[fetchHomeTimeline] invalid response",
													@"response": response
													}]);
		}
	} failure:failure];
	
}

- (void)fetchMentionsTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success {
	
	NSString *requestPath = @"1.1/statuses/mentions_timeline.json";
	
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
										 userInfo:@{@"message": @"[fetchMentionsTimeline] invalid response",
													@"response": response
													}]);
		}
	} failure:failure];
	
}

- (void)fetchRetweetsTimelineWithSuccess:(void (^)(NSMutableArray *tweetModels))success {
	
	NSString *requestPath = @"1.1/statuses/retweets_of_me.json";
	
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
										 userInfo:@{@"message": @"[fetchMentionsTimeline] invalid response",
													@"response": response
													}]);
		}
	} failure:failure];
	
}

- (void)fetchUserTimelineWithUserId:(NSString *)userId success:(void (^)(NSMutableArray *tweetModels))success {
	
	NSString *requestPath = @"1.1/statuses/user_timeline.json";
	
	void(^ failure)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"error fetching tweets:%@", error);
		//		[ZAActivityBar showErrorWithStatus:@"Something went wrong. Please pull down to reload tweets."];
	};
	
	NSDictionary *params = @{@"user_id": userId};
	
	[self GET:requestPath parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
		NSMutableArray *tweetModels = [NSMutableArray array];
		if ([response isKindOfClass:[NSArray class]]) {
			for (NSDictionary *tweetData in response) {
				[tweetModels addObject:[TweetModel initWithJSON:tweetData]];
			}
			success(tweetModels);
		} else {
			// bad server response
			failure(nil, [NSError errorWithDomain:@"com.transmote.quitter" code:1
										 userInfo:@{@"message": @"[fetchUserTimeline] invalid response",
													@"response": response
													}]);
		}
	} failure:failure];
	
}

- (void)postTweetWithModel:(TweetModel *)tweetModel success:(void (^)(NSDictionary *response))success {
	
	NSString *requestPath = @"1.1/statuses/update.json";
	
	void(^ failure)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"error posting tweet:%@", error);
		//		[ZAActivityBar showErrorWithStatus:@"Something went wrong. Please pull down to reload tweets."];
	};
	
	NSDictionary *params = @{@"status": tweetModel.text};
	
	[self POST:requestPath parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
		if ([response isKindOfClass:[NSDictionary class]]) {
			success(response);
		} else {
			// bad server response
			failure(nil, [NSError errorWithDomain:@"com.transmote.quitter" code:1
										 userInfo:@{@"message": @"[postTweetWithModel] invalid response",
													@"response": response
													}]);
		}
	} failure:failure];
	
}

- (void)retweetTweetWithId:(NSString *)tweetId success:(void (^)(NSDictionary *response))success {
//	NSString *requestPath = @"statuses/retweet/:id.json";
//	NSDictionary *params = @{@"id": tweetId};
	NSLog(@"retweet with id: %@", tweetId);
}

- (void)deleteTweetWithId:(NSString *)tweetId {
//	NSString *requestPath = @"statuses/destroy/:id.json";
//	NSDictionary *params = @{@"id": tweetId};
}

- (void)favoriteTweetWithId:(NSString *)tweetId {
//	NSString *requestPath = @"favorites/create.json";
//	NSDictionary *params = @{@"id": tweetId};
	NSLog(@"favorite with id: %@", tweetId);
}

- (void)unfavoriteTweetWithId:(NSString *)tweetId {
//	NSString *requestPath = @"favorites/destroy.json";
//	NSDictionary *params = @{@"id": tweetId};
}

@end
