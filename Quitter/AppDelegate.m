//
//  AppDelegate.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetListViewController.h"
#import "TwitterClient.h"

@interface AppDelegate ()

@property (strong, nonatomic) TwitterClient *twitterClient;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) TweetListViewController *tweetListViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
	self.loginViewController = [[LoginViewController alloc] init];
	self.tweetListViewController = [[TweetListViewController alloc] init];
	self.navController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
	self.window.rootViewController = self.navController;
	
	[self.navController.navigationBar setBarTintColor:[UIColor colorWithRed:121.0/255.0 green:184.0/255.0 blue:234.0/255.0 alpha:1.0]];
	[self.navController.navigationBar setTranslucent:YES];
	
	[[UINavigationBar appearance] setTitleTextAttributes:@{
		NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]/*,
		NSFontAttributeName: [UIFont fontWithName:@"Arial-Bold" size:0.0]*/
	}];
	
	/*
	// Use UIAppearance proxy to style all UIBarButtonItems in application.
	NSDictionary *barButtonAppearanceDict = @{ NSFontAttributeName : [UIFont fontWithName:@"Avenir-Medium" size:20.0] };
	[[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
	[[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(-1.0, -1.5) forBarMetrics:UIBarMetricsDefault];
	//	[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:<#(UIOffset)#> forBarMetrics:<#(UIBarMetrics)#>
	
	[businessListViewController setNeedsStatusBarAppearanceUpdate];
	*/
	
	/*
	 // Dump font families/names
	 for (NSString* family in [UIFont familyNames]) {
	 NSLog(@"%@", family);
	 for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
	 NSLog(@"  %@", name);
	 }
	 }
	 */
	
	self.twitterClient = [TwitterClient instance];
	if ([self.twitterClient isAuthorized]) {
		// If already authorized, go straight to tweet list
		[self.navController pushViewController:self.tweetListViewController animated:NO];
	}
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	if ([url.scheme isEqualToString:@"quitterapp"]) {
		if ([url.host isEqualToString:@"oauth-authorizeApp"]) {
			NSString *accessTokenPath = @"oauth/access_token";
			
			[self.twitterClient fetchAccessTokenWithPath:accessTokenPath method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
				// Persist OAuth access token and immediately display tweet list
				[self.twitterClient.requestSerializer saveAccessToken: accessToken];
				[self.navController pushViewController:self.tweetListViewController animated:NO];
			} failure:^(NSError *error) {
				NSLog(@"error getting access token%@", error);
			}];
		}
		
		return YES;
	}
	
	return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
