//
//  AppDelegate.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "MainMenuViewController.h"
#import "LoginViewController.h"
#import "TweetListViewController.h"
#import "ProfileViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) TwitterClient *twitterClient;

@property (strong, nonatomic) MainMenuViewController *mainMenuViewController;

@property (strong, nonatomic) UINavigationController *mainNavController;
@property (strong, nonatomic) UIViewController *containerViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) TweetListViewController *homeViewController;
@property (strong, nonatomic) TweetListViewController *mentionsViewController;
@property (strong, nonatomic) TweetListViewController *retweetsViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, nonatomic) BOOL mainMenuViewOpen;
@property (strong, nonatomic) NSArray *mainNavViewControllers;

@end

@implementation AppDelegate

static double mainNavOpenX;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	[self initViewControllers];
	[self setupStyles];
	
	// Pan to open MainMenuViewController
	self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
	[self.window addGestureRecognizer:self.panGestureRecognizer];
	
	// Verify authentication or kickoff OAuth flow
	self.twitterClient = [TwitterClient instance];
	if ([self.twitterClient isAuthorized]) {
		// If already authorized, go straight to tweet list
		[self.mainNavController pushViewController:self.homeViewController animated:NO];
	}
	
	mainNavOpenX = [[UIScreen mainScreen] bounds].size.width - 54;
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initViewControllers {
	// Main container view controller
	self.containerViewController = [[UIViewController alloc] init];
	self.window.rootViewController = self.containerViewController;
	
	// Main menu view controller on bottom of stack
	self.mainMenuViewController = [[MainMenuViewController alloc] init];
	[self.containerViewController.view addSubview:self.mainMenuViewController.view];
	self.mainMenuViewController.delegate = self;
	
	// View controllers managed by UINavigationController
	self.loginViewController = [[LoginViewController alloc] init];
	self.profileViewController = [[ProfileViewController alloc] init];
	self.homeViewController = [[TweetListViewController alloc] initWithTweetListType:TweetListTypeHome];
	self.mentionsViewController = [[TweetListViewController alloc] initWithTweetListType:TweetListTypeMentions];
	self.retweetsViewController = [[TweetListViewController alloc] initWithTweetListType:TweetListTypeRetweets];
	self.mainNavViewControllers = @[
		self.profileViewController,
		self.homeViewController,
		self.mentionsViewController,
		self.retweetsViewController
	];
	
	// Main navigation controller on top of that
	self.mainNavController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
	[self.containerViewController.view addSubview:self.mainNavController.view];
	
	// dropshadow on main nav
	UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.mainNavController.view.bounds];
	self.mainNavController.view.layer.masksToBounds = NO;
	self.mainNavController.view.layer.shadowColor = [UIColor blackColor].CGColor;
	self.mainNavController.view.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
	self.mainNavController.view.layer.shadowOpacity = 0.25f;
	self.mainNavController.view.layer.shadowRadius = 2.0f;
	self.mainNavController.view.layer.shadowPath = shadowPath.CGPath;
}

- (void)setupStyles {
	[self.mainNavController.navigationBar setBarTintColor:[UIColor colorWithRed:121.0/255.0 green:184.0/255.0 blue:234.0/255.0 alpha:1.0]];
	[self.mainNavController.navigationBar setTranslucent:YES];
	
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
}

- (void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
	switch (panGestureRecognizer.state) {
		case UIGestureRecognizerStateChanged:
			[self onPanChanged:panGestureRecognizer];
			break;
		case UIGestureRecognizerStateEnded:
			[self onPanEnded:panGestureRecognizer];
			break;
	}
}

- (void)onPanChanged:(UIPanGestureRecognizer *)panGestureRecognizer {
	CGPoint translation = [panGestureRecognizer translationInView:self.window];
	double targetX = self.mainMenuViewOpen ? mainNavOpenX + translation.x : translation.x;
	CGRect frame = self.mainNavController.view.frame;
	frame.origin.x = MIN(MAX(0.0, targetX), mainNavOpenX);
	self.mainNavController.view.frame = frame;
}

- (void)onPanEnded:(UIPanGestureRecognizer *)panGestureRecognizer {
	double screenWidth = [[UIScreen mainScreen] bounds].size.width;
	CGPoint panVelocity = [panGestureRecognizer velocityInView:self.window];
	
	if (!self.mainMenuViewOpen && (self.mainNavController.view.frame.origin.x > screenWidth * 0.35)) {
		[self setMainMenuOpen:YES withVelocity:panVelocity];
	} else if (self.mainMenuViewOpen && (self.mainNavController.view.frame.origin.x < screenWidth * 0.65)) {
		[self setMainMenuOpen:NO withVelocity:panVelocity];
	} else {
		[self setMainMenuOpen:self.mainMenuViewOpen withVelocity:panVelocity];
	}
}

- (void)setMainMenuOpen:(BOOL)isOpen {
	[self setMainMenuOpen:isOpen withVelocity:CGPointMake(isOpen ? 100 : -100, 0)];
}

- (void)setMainMenuOpen:(BOOL)isOpen withVelocity:(CGPoint)velocity {
	self.mainMenuViewOpen = isOpen;
	
	CGRect frame = self.mainNavController.view.frame;
	double remainingDistance;
	CGFloat damping = isOpen ? 0.60f : 1.0f;	// don't bounce when closing, as this reveals stuff below on right edge
	
	if (isOpen) {
		remainingDistance = mainNavOpenX - frame.origin.x;
		frame.origin.x = mainNavOpenX;
	} else {
		remainingDistance = frame.origin.x;
		frame.origin.x = 0.0;
	}
	
	double initialSpringVelocity = remainingDistance / velocity.x;
	[UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:damping initialSpringVelocity:initialSpringVelocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.mainNavController.view.frame = frame;
	} completion:nil];
}

/**
 * Handle OAuth callbacks.
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	if ([url.scheme isEqualToString:@"quitterapp"]) {
		if ([url.host isEqualToString:@"oauth-authorizeApp"]) {
			NSString *accessTokenPath = @"oauth/access_token";
			
			[self.twitterClient fetchAccessTokenWithPath:accessTokenPath method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
				// Persist OAuth access token and immediately display tweet list
				[self.twitterClient.requestSerializer saveAccessToken: accessToken];
				[self.twitterClient fetchAccountCredentialsWithSuccess:^(UserModel *userModel) {
					self.profileViewController.userModel = userModel;
					[self.mainNavController pushViewController:self.homeViewController animated:NO];
				}];
			} failure:^(NSError *error) {
				NSLog(@"error getting access token%@", error);
			}];
		}
		
		return YES;
	}
	
	return NO;
}

#pragma	mark - MainMenuDelegate implementation
- (void)mainMenuViewController:(MainMenuViewController *)mainMenuViewControler didSelectMenuItem:(int)menuId {
	UIViewController *targetViewController = self.mainNavViewControllers[menuId];
	
	// Don't push if target is already on top of stack
	if (targetViewController && self.mainNavController.topViewController != targetViewController) {
		[self.mainNavController popToRootViewControllerAnimated:NO];
		[self.mainNavController pushViewController:targetViewController animated:NO];
	}
	
	// Close main menu
	[self setMainMenuOpen:NO];
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
