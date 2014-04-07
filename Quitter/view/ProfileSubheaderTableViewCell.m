//
//  ProfileSubheaderTableViewCell.m
//  Quitter
//
//  Created by Eric Socolofsky on 4/5/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "ProfileSubheaderTableViewCell.h"

@interface ProfileSubheaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;

@end

@implementation ProfileSubheaderTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithModel:(UserModel *)model {
	self.numTweetsLabel.text = [NSString stringWithFormat:@"%@", model.numTweets];
	self.numFollowingLabel.text = [NSString stringWithFormat:@"%@", model.numFollowing];
	self.numFollowersLabel.text = [NSString stringWithFormat:@"%@", model.numFollowers];
}

@end
