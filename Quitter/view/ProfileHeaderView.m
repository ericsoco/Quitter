//
//  ProfileHeaderView.m
//  Quitter
//
//  Created by Eric Socolofsky on 4/5/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "UserModel.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

@end

@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initWithModel:(UserModel *)model {
	self.usernameLabel.text = model.name;
	self.screennameLabel.text = model.screenName;
	
	self.profileImageView.layer.cornerRadius = 5.0;
	self.profileImageView.layer.masksToBounds = YES;
	[self.profileImageView setImageWithURL:[NSURL URLWithString:model.profileImageUrl]];
	
	[self.backgroundImageView setImageWithURL:[NSURL URLWithString:model.profileBackgroundImageUrl]];
}

@end
