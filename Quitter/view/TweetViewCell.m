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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedLabelIconHeightConstraint;

@end

@implementation TweetViewCell

- (void)awakeFromNib
{
    // Initialization code
	
	[self.retweetButton setImage:[UIImage imageNamed:@"retweet.png"] forState:UIControlStateNormal];
	[self.retweetButton setImage:[UIImage imageNamed:@"retweetSelected.png"] forState:UIControlStateSelected];
	
	[self.faveButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
	[self.faveButton setImage:[UIImage imageNamed:@"starSelected.png"] forState:UIControlStateSelected];
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
		self.retweetedLabelIconHeightConstraint.constant = 16.0;
	} else {
		self.retweetedByIcon.hidden = self.retweetedByLabel.hidden = YES;
		self.retweetedLabelIconHeightConstraint.constant = 6.0;
	}
	
	self.profileImageView.layer.cornerRadius = 4.0;
	self.profileImageView.layer.masksToBounds = YES;
	[self.profileImageView setImageWithURL:[NSURL URLWithString:model.user.profileImageUrl]];
	
	self.retweeted = model.retweetedByMe;
	self.favorited = model.favoritedByMe;
}

- (CGFloat)calcHeightWithModel:(TweetModel *)model {
	
	static NSDictionary *tweetLabelAttrs;
	if (!tweetLabelAttrs) {
		tweetLabelAttrs = @{ NSFontAttributeName: self.tweetLabel.font };
	}
	
	// Hardcoded height of all static content and whitespace created in xib.
	// TODO: (next time) create IBOutlets for each constraint and add them up.
	double cellHeight = 3.0 + 16.0 + 2.0 + 21.0 + 0.0 + 16.0 + 5.0;
	
	CGSize minSize = CGSizeMake(246, 90);
	CGSize maxSize = CGSizeMake(246, 0);
	
	cellHeight += [model.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:tweetLabelAttrs context:nil].size.height;
	
	cellHeight = MAX(minSize.height, cellHeight);
	
	return cellHeight;
}

@synthesize retweeted = _retweeted;
- (void)setRetweeted:(BOOL)value {
	if (_retweeted == value) { return; }
	_retweeted = value;
	[self.retweetButton setSelected:!!value];
	self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", ([self.retweetCountLabel.text integerValue] + (value ? 1 : -1))];
}

@synthesize favorited = _favorited;
- (void)setFavorited:(BOOL)value {
	if (_favorited == value) { return; }
	_favorited = value;
	[self.faveButton setSelected:!!value];
	self.faveCountLabel.text = [NSString stringWithFormat:@"%d", ([self.faveCountLabel.text integerValue] + (value ? 1 : -1))];
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
