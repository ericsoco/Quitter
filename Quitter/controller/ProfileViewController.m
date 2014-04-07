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

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet ProfileHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
	
	// TODO next:
	// ProfileHeaderView stays at top, with tableView below it.
	// first cell in tableView: ProfileSubheaderTableViewCell.
	// some tweets below that...
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	if (!self.userModel) {
		self.userModel = [[[TwitterClient instance] authorizedUser] copy];
	}
}

@end
