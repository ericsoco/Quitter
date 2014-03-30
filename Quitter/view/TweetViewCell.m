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
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *faveButton;

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
	self.usernameLabel.text = model.userName;
	self.tweetLabel.text = model.text;
	self.screennameLabel.text = model.userScreenName;
	
	
	self.profileImageView.layer.cornerRadius = 4.0;
	self.profileImageView.layer.masksToBounds = YES;
	[self.profileImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.userProfileImageUrl]]
						   placeholderImage:nil//[UIImage imageNamed:@"placeholder-avatar"]
									success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
										self.profileImageView.image = image;
										/*
										 self.profileImageView.alpha = 0.0;
										 self.profileImageView.image = image;
										 [UIView animateWithDuration:0.35 animations:^{
										 self.profileImageView.alpha = 1.0;
										 }];
										 */
									}
									failure:NULL];
	
}

- (CGFloat)calcHeightWithModel:(TweetModel *)model {
	return 0;
}


- (IBAction)replyButtonTapped:(id)sender {
	NSLog(@"reply");
}

- (IBAction)retweetButtonTapped:(id)sender {
	NSLog(@"retweet");
}

- (IBAction)faveButtonTapped:(id)sender {
	NSLog(@"fave");
}

@end
