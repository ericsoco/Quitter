//
//  TwitterClient.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TwitterClient.h"

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

- (void)login {
	
	// Remove stale access token when attempting to login again
	[self.requestSerializer removeAccessToken];
	
	NSString *requestTokenPath = @"oauth/request_token";
	NSString *authorizeURL = @"https://api.twitter.com/oauth/authorize";
	NSString *method = @"POST";
	
	// can deeplink into app with this callback url if desired
	// Project Navigator -> Project -> Info -> URL Types -> URL Schemes
	NSURL *callbackURL = [NSURL URLWithString:@"quitterapp://oauth-login"];
	
	[self fetchRequestTokenWithPath:requestTokenPath method:method callbackURL:callbackURL scope:nil success:^(BDBOAuthToken *requestToken) {
		NSLog(@"got request token");
		NSString *authURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@", authorizeURL, requestToken.token];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURLWithToken]];
	} failure:^(NSError *error) {
		NSLog(@"error getting request token:%@", error);
	}];
}

@end
