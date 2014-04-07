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

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet ProfileHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetModels;
@property (strong, nonatomic) TweetViewCell *cellForMetrics;


@end

@implementation ProfileViewController

@synthesize userModel = _userModel;
- (void)setUserModel:(UserModel *)userModel {
	_userModel = userModel;
	[self.headerView initWithModel:self.userModel];
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
	
	// Register cell nibs
	UINib *cellNib = [UINib nibWithNibName:@"ProfileSubheaderTableViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"ProfileSubheaderTableViewCell"];
	cellNib = [UINib nibWithNibName:@"TweetViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetViewCell"];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	if (!self.userModel) {
		self.userModel = [[[TwitterClient instance] authorizedUser] copy];
	}
	
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
	if (!self.tweetModels || [self.tweetModels count] == 0) { return 100; }
	return [[self cellForMetrics] calcHeightWithModel:self.tweetModels[[indexPath row]]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithTweetModel:self.tweetModels[indexPath.row]];
	[self.navigationController pushViewController:tweetDetailViewController animated:YES];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	 */
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



@end
