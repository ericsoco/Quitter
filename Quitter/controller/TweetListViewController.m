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
#import "TweetComposeViewController.h"
#import "TweetDetailViewController.h"

@interface TweetListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetModels;
@property (strong, nonatomic) TweetViewCell *cellForMetrics;

@property (assign, nonatomic) TweetListType tweetListType;

@end


@implementation TweetListViewController

- (id)initWithTweetListType:(TweetListType)tweetListType {
	self = [super init];
	self.tweetListType = tweetListType;
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	
    // UITableView setup
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.separatorInset = UIEdgeInsetsZero;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	// Register cell nibs
	UINib *cellNib = [UINib nibWithNibName:@"TweetViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetViewCell"];
	
	// UINavigationBar setup
	switch (self.tweetListType) {
		case TweetListTypeHome:
			self.navigationItem.title = @"Home";
			break;
		case TweetListTypeMentions:
			self.navigationItem.title = @"Mentions";
			break;
		case TweetListTypeRetweets:
			self.navigationItem.title = @"Retweets";
			break;
		default:
			break;
	}
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutTapped)];
	[leftButton setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
	self.navigationItem.leftBarButtonItem = leftButton;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newTweetTapped)];
	[rightButton setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
	self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewDidAppear:(BOOL)animated {
	
	NSLog(@"viewDidAppear with tweetListType:%d", self.tweetListType);
	
	// Load tweets if not already loaded and authorized.
	if (!self.tweetModels || [self.tweetModels count] == 0) {
		TwitterClient *twitterClient = [TwitterClient instance];
		if ([twitterClient isAuthorized]) {
			[self displayTweets];
		}
	}
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)displayTweets {
	void(^ success)(NSMutableArray *tweetModels) = ^(NSMutableArray *tweetModels) {
		if (!self.tweetModels) {
			self.tweetModels = tweetModels;
		} else {
			[self.tweetModels addObjectsFromArray:tweetModels];
		}
		[self.tableView reloadData];
	};
	
	NSLog(@"displayTweets with tweetListType:%d", self.tweetListType);
	switch (self.tweetListType) {
		case TweetListTypeHome:
			[[TwitterClient instance] fetchHomeTimelineWithSuccess:success];
			break;
		case TweetListTypeMentions:
			[[TwitterClient instance] fetchMentionsTimelineWithSuccess:success];
			break;
		case TweetListTypeRetweets:
			[[TwitterClient instance] fetchRetweetsTimelineWithSuccess:success];
			break;
		default:
			break;
	}
	
	/*
	SEL tweetFetchSelector;
	switch (self.tweetListType) {
		case TweetListTypeHome:
			tweetFetchSelector = NSSelectorFromString(@"fetchHomeTimelineWithSuccess:");
			break;
		case TweetListTypeMentions:
			tweetFetchSelector = NSSelectorFromString(@"fetchMentionsTimelineWithSuccess:");
			break;
		case TweetListTypeRetweets:
			tweetFetchSelector = NSSelectorFromString(@"fetchRetweetsTimelineWithSuccess:");
			break;
		default:
			break;
	}
	
	IMP imp = [[TwitterClient instance] methodForSelector:tweetFetchSelector];
	void (*func)(id, SEL, )

	IMP imp = [_controller methodForSelector:selector];
	CGRect (*func)(id, SEL, CGRect, UIView *) = (void *)imp;
	CGRect result = func(_controller, selector, someRect, someView);
	 */
	
	
	/*
	if (tweetFetchSelector) {
		[[TwitterClient instance] performSelector:tweetFetchSelector withObject:^(NSMutableArray *tweetModels) {
			if (!self.tweetModels) {
				self.tweetModels = tweetModels;
			} else {
				[self.tweetModels addObjectsFromArray:tweetModels];
			}
			[self.tableView reloadData];
		}];
	}
	*/
	
	/*
	[[TwitterClient instance] fetchHomeTimelineWithSuccess:^(NSMutableArray *tweetModels) {
		if (!self.tweetModels) {
			self.tweetModels = tweetModels;
		} else {
			[self.tweetModels addObjectsFromArray:tweetModels];
		}
		[self.tableView reloadData];
	}];
	*/
}

- (void)signOutTapped {
	[[TwitterClient instance].requestSerializer removeAccessToken];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)presentTweetComposeViewControllerWithTweetModel:(TweetModel *)tweetModel {
	TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] initWithTweetModel:tweetModel];
	tweetComposeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	tweetComposeViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tweetComposeViewController];
	[self.navigationController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - UITableView protocol implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tweetModels ? [self.tweetModels count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell" forIndexPath:indexPath];
	if (!self.tweetModels || [self.tweetModels count] == 0) { return cell; }
	
	[cell initWithModel:[self.tweetModels objectAtIndex:[indexPath row]]];
	cell.delegate = self;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tweetModels || [self.tweetModels count] == 0) { return 100; }
	return [[self cellForMetrics] calcHeightWithModel:self.tweetModels[[indexPath row]]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithTweetModel:self.tweetModels[indexPath.row]];
	[self.navigationController pushViewController:tweetDetailViewController animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 * Generate a cell to populate with data and measure.
 */
@synthesize cellForMetrics = _cellForMetrics;
- (TweetViewCell *) cellForMetrics {
	if (!_cellForMetrics) {
		self.cellForMetrics = [self.tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
	}
	return _cellForMetrics;
}


#pragma mark - TweetViewCellDelegate implementation
- (void)tweetViewCell:(TweetViewCell *)tweetViewCell replyWasTapped:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:tweetViewCell];
	TweetModel *tweetModel = self.tweetModels[indexPath.row];
	
	TweetModel *replyTweetModel = [[TweetModel alloc] init];
	replyTweetModel.user = [[[TwitterClient instance] authorizedUser] copy];
	if (tweetModel.retweeter) {
		replyTweetModel.text = [NSString stringWithFormat:@"@%@ @%@", tweetModel.user.screenName,  tweetModel.retweeter.screenName];
	} else {
		replyTweetModel.text = [NSString stringWithFormat:@"@%@", tweetModel.user.screenName];
	}
	
	[self presentTweetComposeViewControllerWithTweetModel:replyTweetModel];
}

- (void)tweetViewCell:(TweetViewCell *)tweetViewCell retweetWasTapped:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:tweetViewCell];
	TweetModel *tweetModel = self.tweetModels[indexPath.row];
	
	if (!tweetModel.retweetedByMe) {
		[[TwitterClient instance] retweetTweetWithId:tweetModel.id success:^(NSDictionary *response) {
			// TODO: store id of new tweet (retweet) for use in unretweeting
//			tweetModel.id = 
		}];
		tweetModel.retweetedByMe = YES;
	} else {
		[[TwitterClient instance] deleteTweetWithId:tweetModel.id];
		tweetModel.retweetedByMe = NO;
	}
	
	tweetViewCell.retweeted = tweetModel.retweetedByMe;
	
}

- (void)tweetViewCell:(TweetViewCell *)tweetViewCell favoriteWasTapped:(id)sender {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:tweetViewCell];
	TweetModel *tweetModel = self.tweetModels[indexPath.row];
	
	if (!tweetModel.favoritedByMe) {
		[[TwitterClient instance] favoriteTweetWithId:tweetModel.id];
		tweetModel.favoritedByMe = YES;
	} else {
		[[TwitterClient instance] unfavoriteTweetWithId:tweetModel.id];
		tweetModel.favoritedByMe = NO;
	}
	
	tweetViewCell.favorited = tweetModel.favoritedByMe;
}


#pragma mark - Tweet compose management
- (void)newTweetTapped {
	[self presentTweetComposeViewControllerWithTweetModel:nil];
}

- (void)tweetComposeViewController:(TweetComposeViewController *)tweetComposeViewController didComposeTweet:(TweetModel *)tweetModel {
	void(^ dismissCompletionHandler)();
	
	if (tweetModel) {
		[[TwitterClient instance] postTweetWithModel:tweetModel success:^(NSDictionary *response) {
			NSLog(@"Tweet posted successfully.");
		}];
		dismissCompletionHandler = ^{
			[self.tweetModels insertObject:tweetModel atIndex:0];
			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		};
	} else {
		dismissCompletionHandler = ^{};
		NSLog(@"Cancelled.");
	}
	
	[self.navigationController dismissViewControllerAnimated:YES completion:dismissCompletionHandler];
}



@end