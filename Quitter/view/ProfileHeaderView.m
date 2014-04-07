//
//  ProfileHeaderView.m
//  Quitter
//
//  Created by Eric Socolofsky on 4/5/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

@end

@implementation ProfileHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	UIView *containerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
	containerView.frame = self.bounds;
	[self addSubview:containerView];
	
	return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)initWithModel:(UserModel *)model {
	self.usernameLabel.text = model.name;
	self.screennameLabel.text = [NSString stringWithFormat:@"@%@", model.screenName];
	
	self.profileImageView.layer.cornerRadius = 5.0;
	self.profileImageView.layer.masksToBounds = YES;
	[self.profileImageView setImageWithURL:[NSURL URLWithString:model.profileImageUrl]];
	/*
	// why is backgroundImageView not clipping to bounds???
	self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.backgroundImageView.clipsToBounds = YES;
	self.backgroundImageView.frame = CGRectMake(0, 0, 320, 160);
	 */
	[self.backgroundImageView setImageWithURL:[NSURL URLWithString:model.profileBackgroundImageUrl]];
	
}

@end
