//
//  ProfileViewController.m
//  Quitter
//
//  Created by Eric Socolofsky on 4/5/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "TwitterClient.h"
#import "ProfileSubheaderTableViewCell.h"
#import "TweetViewCell.h"
#import "TweetDetailViewController.h"
#import "UIView+Screenshot.h"
#import <GPUImage/GPUImage.h>

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet ProfileHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetModels;
@property (strong, nonatomic) TweetViewCell *tweetCellForMetrics;
@property (strong, nonatomic) UIImage *headerImage;
@property (strong, nonatomic) GPUImageView *headerBlurImage;
@property (strong, nonatomic) GPUImagePicture *headerImagePicture;

@end

@implementation ProfileViewController

GPUImageiOSBlurFilter *_blurFilter;
GPUImageZoomBlurFilter *_blurZoomFilter;
GPUImageMotionBlurFilter *_blurMotionFilter;

@synthesize userModel = _userModel;
- (void)setUserModel:(UserModel *)userModel {
	NSLog(@"setting user model with username:%@", userModel.name);
	_userModel = userModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
		/*
		// programmatically add ProfileHeaderView
		self.headerView = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:self options:nil][0];
		[self.headerView setFrame:CGRectMake(0, 0, self.headerView.frame.size.width, self.headerView.frame.size.height)];
		[self.view addSubview:self.headerView];
		self.headerView.clipsToBounds = YES;
		NSLog(@"header height:%f", self.headerView.frame.size.height);
		
		// constrain ProfileHeaderView to topLayoutGuide (bottom of status/nav bar)
		[self.headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
		id topLayoutGuide = self.topLayoutGuide;
		id headerView = self.headerView;
		NSDictionary *viewPair = NSDictionaryOfVariableBindings(headerView, topLayoutGuide);
		[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-0-[headerView]" options:0 metrics:nil views:viewPair]];
		*/
    }
	
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// constrain to bottom of UINavigationBar
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
    // UITableView setup
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.separatorInset = UIEdgeInsetsZero;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Profile";
	
	// Register cell nibs
	UINib *cellNib = [UINib nibWithNibName:@"ProfileSubheaderTableViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"ProfileSubheaderTableViewCell"];
	cellNib = [UINib nibWithNibName:@"TweetViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetViewCell"];
	
	_blurFilter = [[GPUImageiOSBlurFilter alloc] init];
	_blurZoomFilter = [[GPUImageZoomBlurFilter alloc] init];
	_blurMotionFilter = [[GPUImageMotionBlurFilter alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	if (!self.userModel) {
		self.userModel = [[[TwitterClient instance] authorizedUser] copy];
	}
	[self.headerView initWithModel:self.userModel];
	
	[[TwitterClient instance] fetchUserTimelineWithUserId:self.userModel.id success:^(NSMutableArray *tweetModels) {
		if (!self.tweetModels) {
			self.tweetModels = tweetModels;
		} else {
			[self.tweetModels addObjectsFromArray:tweetModels];
		}
		[self.tableView reloadData];
	}];
}

#pragma mark - UITableView protocol implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 10;
//			return self.tweetModels ? [self.tweetModels count] : 0;
		default:
			return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		ProfileSubheaderTableViewCell *profileSubheaderCell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileSubheaderTableViewCell" forIndexPath:indexPath];
		[profileSubheaderCell initWithModel:self.userModel];
		return profileSubheaderCell;
	} else if (indexPath.section == 1) {
		TweetViewCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell" forIndexPath:indexPath];
		if (self.tweetModels && [self.tweetModels count]) {
			[tweetCell initWithModel:[self.tweetModels objectAtIndex:[indexPath row]]];
		}
		return tweetCell;
	} else {
		return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 50;
	} else {
		if (!self.tweetModels || [self.tweetModels count] == 0) { return 100; }
		return [[self tweetCellForMetrics] calcHeightWithModel:self.tweetModels[[indexPath row]]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithTweetModel:self.tweetModels[indexPath.row]];
	[self.navigationController pushViewController:tweetDetailViewController animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	// TODO: this should only be done once, on some sort of lifecycle/init,
	// but couldn't get it to work in lifecycle methods...
	self.headerImage = [self.headerView convertViewToImage];
	
	if (!self.headerBlurImage) {
		self.headerBlurImage = [[GPUImageView alloc] initWithFrame:self.headerView.frame];
		self.headerBlurImage.clipsToBounds = YES;
		self.headerBlurImage.layer.contentsGravity = kCAGravityTop;
		[self.view addSubview:self.headerBlurImage];
		
		/*
		self.headerImagePicture = [[GPUImagePicture alloc] initWithImage:self.headerImage];
		[self.headerImagePicture addTarget:_blurFilter];
		[_blurFilter addTarget:self.headerBlurImage];
		*/
		
		self.headerImagePicture = [[GPUImagePicture alloc] initWithImage:self.headerImage];
		[self.headerImagePicture addTarget:_blurZoomFilter];
		[_blurZoomFilter addTarget:self.headerBlurImage];
		_blurZoomFilter.blurCenter = CGPointMake(0.5f, 0.25f);
		
		/*
		self.headerImagePicture = [[GPUImagePicture alloc] initWithImage:self.headerImage];
		[self.headerImagePicture addTarget:_blurMotionFilter];
		[_blurMotionFilter addTarget:self.headerBlurImage];
		*/
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.tableView.contentOffset.y <= 0) {
		double scrollRatio = (100.0 - self.tableView.contentOffset.y) / 100.0;
//		self.headerView.transform = CGAffineTransformMakeScale(scrollRatio, scrollRatio);
//		NSLog(@"scrollRatio:%f", scrollRatio);
		
//		self.headerImage = [self.headerView convertViewToImage];
		
//		_blurFilter.blurRadiusInPixels = 5.0f * (scrollRatio - 1.0f);
		
		_blurZoomFilter.blurSize = 5.0f * (scrollRatio - 1.0f);
		
//		_blurMotionFilter.blurSize = 15.0f * (scrollRatio - 1.0f);
//		_blurMotionFilter.blurAngle = 90;
		
		[self.headerImagePicture processImage];
		
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
//		self.headerView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
		_blurZoomFilter.blurSize = 0.0f;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//	self.headerView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	_blurZoomFilter.blurSize = 0.0f;
}

/**
 * Generate a cell to populate with data and measure.
 */
@synthesize tweetCellForMetrics = _tweetCellForMetrics;
- (TweetViewCell *) tweetCellForMetrics {
	if (!_tweetCellForMetrics) {
		self.tweetCellForMetrics = [self.tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
	}
	return _tweetCellForMetrics;
}



@end
