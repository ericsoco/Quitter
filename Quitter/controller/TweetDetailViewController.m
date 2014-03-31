//
//  TweetDetailViewController.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetComposeViewController.h"
#import "TwitterClient.h"


@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedByIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *faveCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *faveButton;

@property (strong, nonatomic) TweetModel *tweetModel;

@end


@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTweetModel:(TweetModel *)model {
	self = [super init];
	self.tweetModel = model;
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// UINavigationBar setup
	self.navigationItem.title = @"Tweet";
	self.navigationItem.backBarButtonItem.title = @"Home";
	// doesn't work...
//	[self.navigationItem.backBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
	// makes everything white!
//	[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
	self.navigationItem.title = @"Tweet";
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(replyTapped)];
	[rightButton setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
	self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewWillAppear:(BOOL)animated {
	self.usernameLabel.text = self.tweetModel.user.name;
	self.screennameLabel.text = self.tweetModel.user.screenName;
	self.tweetLabel.text = self.tweetModel.text;
	self.timestampLabel.text = self.tweetModel.longDateStr;
	self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", self.tweetModel.numRetweets];
	self.faveCountLabel.text = [NSString stringWithFormat:@"%@", self.tweetModel.numFavorites];
	
	if (self.tweetModel.retweeter) {
		self.retweetedByLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweetModel.retweeter.screenName];
		self.retweetedByIcon.hidden = self.retweetedByLabel.hidden = NO;
	} else {
		self.retweetedByIcon.hidden = self.retweetedByLabel.hidden = YES;
	}
	
	self.profileImageView.layer.cornerRadius = 4.0;
	self.profileImageView.layer.masksToBounds = YES;
	[self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweetModel.user.profileImageUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)replyButtonTapped:(id)sender {
	NSLog(@"reply");
	[self replyTapped];
}

- (IBAction)retweetButtonTapped:(id)sender {
	NSLog(@"retweet");
}

- (IBAction)faveButtonTapped:(id)sender {
	NSLog(@"fave");
}

#pragma mark - Tweet compose management
- (void)replyTapped {
	TweetModel *replyTweetModel = [[TweetModel alloc] init];
	replyTweetModel.user = [[[TwitterClient instance] authorizedUser] copy];
	if (replyTweetModel.retweeter) {
		replyTweetModel.text = [NSString stringWithFormat:@"@%@ @%@", self.tweetModel.user.screenName,  self.tweetModel.retweeter.screenName];
	} else {
		replyTweetModel.text = [NSString stringWithFormat:@"@%@", self.tweetModel.user.screenName];
	}
	
	TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] initWithTweetModel:replyTweetModel];
	tweetComposeViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	tweetComposeViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tweetComposeViewController];
	[self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)tweetComposeViewController:(TweetComposeViewController *)tweetComposeViewController didComposeTweet:(TweetModel *)tweetModel {
	void(^ dismissCompletionHandler)();
	
	if (tweetModel) {
		[[TwitterClient instance] postTweetWithModel:tweetModel success:^(NSDictionary *response) {
			NSLog(@"Tweet posted successfully.");
		}];
		dismissCompletionHandler = ^{
			NSLog(@"Compose dismissed.");
			// TODO: add reply to bottom of TweetDetailViewController.
			//		 add UITableView below the rest of the content,
			//		 or make the rest of the content a uniquely-formatted nib...
//			[self.tweetModels insertObject:tweetModel atIndex:0];
//			[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
		};
	} else {
		dismissCompletionHandler = ^{};
		NSLog(@"Cancelled.");
	}
	
	[self.navigationController dismissViewControllerAnimated:YES completion:dismissCompletionHandler];
}

@end
