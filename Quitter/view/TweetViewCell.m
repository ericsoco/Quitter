//
//  TweetViewCell.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/26/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "TweetViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedByIcon;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *faveButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *faveCountLabel;

@end

@implementation TweetViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithModel:(TweetModel *)model {
	self.usernameLabel.text = model.user.name;
	self.tweetLabel.text = model.text;
	self.screennameLabel.text = [NSString stringWithFormat:@"@%@", model.user.screenName];
	self.timestampLabel.text = model.shortDateStr;
	
	if (model.numRetweets) {
		self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", model.numRetweets];
		self.retweetCountLabel.hidden = NO;
	} else {
		self.retweetCountLabel.hidden = YES;
	}
	if (model.numFavorites) {
		NSLog(@"faves: %@", model.numFavorites);
		self.faveCountLabel.text = [NSString stringWithFormat:@"%@", model.numFavorites];
		self.faveCountLabel.hidden = NO;
	} else {
		self.faveCountLabel.hidden = YES;
	}
	
	if (model.retweeter) {
		self.retweetedByLabel.text = [NSString stringWithFormat:@"%@ retweeted", model.retweeter.screenName];
		self.retweetedByIcon.hidden = self.retweetedByLabel.hidden = NO;
	} else {
		self.retweetedByIcon.hidden = self.retweetedByLabel.hidden = YES;
	}
	
	self.profileImageView.layer.cornerRadius = 4.0;
	self.profileImageView.layer.masksToBounds = YES;
	[self.profileImageView setImageWithURL:[NSURL URLWithString:model.user.profileImageUrl]];
}

- (CGFloat)calcHeightWithModel:(TweetModel *)model {
	// TODO: implement with autolayout nib
	return 100;
}


- (IBAction)replyButtonTapped:(id)sender {
	[self.delegate tweetViewCell:self replyWasTapped:sender];
}

- (IBAction)retweetButtonTapped:(id)sender {
	[self.delegate tweetViewCell:self retweetWasTapped:sender];
}

- (IBAction)faveButtonTapped:(id)sender {
	[self.delegate tweetViewCell:self favoriteWasTapped:sender];
}

@end
