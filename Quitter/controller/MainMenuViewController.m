//
//  MainMenuViewController.m
//  Quitter
//
//  Created by Eric Socolofsky on 4/5/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // UITableView setup
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.separatorInset = UIEdgeInsetsZero;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	// Register cell nibs
//	UINib *cellNib = [UINib nibWithNibName:@"TweetViewCell" bundle:nil];
//	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"TweetViewCell"];
	
	// TODO: store these in AppDelegate as an NSDictionary, as keys for their respective view controllers,
	// and pass that NSDictionary into custom MainMenuViewController init.
	self.tableData = @[
	  @"Profile",
	  @"Home",
	  @"Mentions",
	  @"Retweets"
	];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableView protocol implementation
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tableData ? [self.tableData count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell" forIndexPath:indexPath];
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	if (!self.tableData || [self.tableData count] == 0) { return cell; }
	
//	[cell initWithModel:[self.tweetModels objectAtIndex:[indexPath row]]];
//	cell.delegate = self;
	cell.textLabel.text = [self.tableData objectAtIndex:[indexPath row]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.delegate mainMenuViewController:self didSelectMenuItem:indexPath.row];
	
//	TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithTweetModel:self.tweetModels[indexPath.row]];
//	[self.navigationController pushViewController:tweetDetailViewController animated:YES];
//	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
