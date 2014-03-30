//
//  TweetListViewController.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TweetListViewController.h"
#import "TwitterClient.h"
#import "TweetModel.h"
#import "TweetViewCell.h"
#import "TweetComposeViewController.h"

@interface TweetListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetModels;
@property (strong, nonatomic) TweetViewCell *cellForMetrics;

@end


@implementation TweetListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		
		// Custom initialization
		self.navigationItem.title = @"Quitter";
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	
    // UITableView setup
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	// Register cell nibs
	UINib *cellNib = [UINib nibWithNibName:@"TweetViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetViewCell"];
	
	// UINavigationBar setup
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutPressed)];
	[leftButton setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
	self.navigationItem.leftBarButtonItem = leftButton;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweetPressed)];
	[rightButton setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
	self.navigationItem.rightBarButtonItem = rightButton;
	
	/*
	TwitterClient *twitterClient = [TwitterClient instance];
	if (![twitterClient isAuthorized]) {
		[twitterClient authorizeApp];
	} else {
		[self displayUserTweets];
	}
	*/
}

- (void)viewDidAppear:(BOOL)animated {
	
	// Load tweets if not already loaded and authorized.
	if (!self.tweetModels || [self.tweetModels count] == 0) {
		TwitterClient *twitterClient = [TwitterClient instance];
		if ([twitterClient isAuthorized]) {
			[self displayUserTweets];
		}
	}
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)displayUserTweets {
	[[TwitterClient instance] fetchHomeTimelineWithSuccess:^(NSMutableArray *tweetModels) {
		if (!self.tweetModels) {
			self.tweetModels = tweetModels;
		} else {
			[self.tweetModels addObjectsFromArray:tweetModels];
		}
		[self.tableView reloadData];
	}];
}

- (void)signOutPressed {
	[[TwitterClient instance].requestSerializer removeAccessToken];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableView protocol implementation
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tweetModels ? [self.tweetModels count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell" forIndexPath:indexPath];
	if (!self.tweetModels || [self.tweetModels count] == 0) { return cell; }
	
	[cell initWithModel:[self.tweetModels objectAtIndex:[indexPath row]]];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
	/*
	if (!self.tweetModels || [self.tweetModels count] == 0) { return 90; }
	return [[self cellForMetrics] calcHeightWithModel:self.tweetModels[[indexPath row]]];
	 */
}

/**
 * Generate a cell to populate with data and measure.
 */
- (TweetViewCell *) cellForMetrics {
	if (!self.cellForMetrics) {
		self.cellForMetrics = [self.tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
	}
	return self.cellForMetrics;
}


#pragma mark - Tweet compose management
- (void)newTweetPressed {
	TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] init];
	tweetComposeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	tweetComposeViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tweetComposeViewController];
	
//	[self.navigationController presentViewController:tweetComposeViewController animated:YES completion:nil];
	[self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)tweetComposeViewController:(TweetComposeViewController *)tweetComposeViewController didComposeTweet:(TweetModel *)tweetModel {
	if (tweetModel) {
		NSLog(@"Add tweet model to tweetModels list?");
	} else {
		NSLog(@"Cancelled.");
	}
	
	[self.navigationController dismissViewControllerAnimated:YES completion:^{
		NSLog(@"Update display with new tweet?");
	}];
}



@end