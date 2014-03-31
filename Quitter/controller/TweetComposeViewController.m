//
//  TweetComposeViewController.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TweetComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "UserModel.h"

@interface TweetComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UITextView *composeTextView;

@property (strong, nonatomic) TweetModel *tweetModel;
@property (strong, nonatomic) UILabel *charCountLabel;

@end


@implementation TweetComposeViewController

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
//	self.navigationItem.title = @"Compose";
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped)];
	[leftButton setTintColor:[UIColor colorWithRed:121.0/255.0 green:184.0/255.0 blue:234.0/255.0 alpha:1.0]];
	self.navigationItem.leftBarButtonItem = leftButton;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(tweetTapped)];
	[rightButton setTintColor:[UIColor colorWithRed:121.0/255.0 green:184.0/255.0 blue:234.0/255.0 alpha:1.0]];
	self.navigationItem.rightBarButtonItem = rightButton;
	
	self.charCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 12, 30, 20)];
	self.charCountLabel.text = @"140";
	[self.charCountLabel setTextColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]];
	[self.navigationController.navigationBar addSubview:self.charCountLabel];
	
	self.composeTextView.delegate = self;
	
	if (!self.tweetModel) {
		self.tweetModel = [[TweetModel alloc] init];
		self.tweetModel.user = [[[TwitterClient instance] authorizedUser] copy];
	}
	
	self.usernameLabel.text = self.tweetModel.user.name;
	self.screennameLabel.text = self.tweetModel.user.screenName;
	self.composeTextView.text = self.tweetModel.text;
	[self textViewDidChange:self.composeTextView];
	
	self.profileImageView.layer.cornerRadius = 4.0;
	self.profileImageView.layer.masksToBounds = YES;
	[self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweetModel.user.profileImageUrl]];
}

- (void)viewDidAppear:(BOOL)animated {
	[self.composeTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// Dismiss keyboard on touch outside
    NSLog(@"touchesBegan:withEvent:");
	[self.view endEditing:YES];
	[super touchesBegan:touches withEvent:event];
}
*/

- (void)textViewDidChange:(UITextView *)textView {
	int charCount = 140 - textView.text.length;
	if (charCount < 0) {
		[self.charCountLabel setTextColor:[UIColor colorWithRed:204.0/255.0 green:51.0/255.0 blue:0.0/255.0 alpha:1.0]];
	} else if (charCount < 10) {
		[self.charCountLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:51.0/255.0 blue:0.0/255.0 alpha:1.0]];
	} else if (charCount < 20) {
		[self.charCountLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
	} else {
		[self.charCountLabel setTextColor:[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]];
	}
	self.charCountLabel.text = [NSString stringWithFormat:@"%d", charCount];
}

- (void)cancelTapped {
	[self.delegate tweetComposeViewController:self didComposeTweet:nil];
}

- (void)tweetTapped {
	self.tweetModel.text = self.composeTextView.text;
	[self.delegate tweetComposeViewController:self didComposeTweet:self.tweetModel];
}

@end
