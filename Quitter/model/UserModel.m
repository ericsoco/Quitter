//
//  UserModel.m
//  Quitter
//
//  Created by Eric Socolofsky on 3/30/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSMutableDictionary *)models {
	// Static variables are declared only once. Ever.
	static NSMutableDictionary *modelsDict = nil;
	
	// Initialize only once.
	if (!modelsDict) {
		modelsDict = [NSMutableDictionary dictionary];
	}
	
	return modelsDict;
}

+ (UserModel *)initWithJSON:(NSDictionary *)json {
	UserModel *model = [UserModel models][json[@"id"]];
	if (!model) {
		model = [[UserModel alloc] init];
		
		model.id = json[@"id_str"];
		model.name = json[@"name"];
		model.screenName = json[@"screen_name"];
		model.profileImageUrl = json[@"profile_image_url_https"];
		model.profileBackgroundImageUrl = json[@"profile_banner_url"];
		model.numTweets = json[@"statuses_count"];
		model.numFollowing = json[@"friends_count"];
		model.numFollowers = json[@"followers_count"];
		
		[UserModel models][model.id] = model;
	}
	
	return model;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<UserModel: %@>", self.name];
}

#pragma mark - NSCopying implementation
- (id)copyWithZone:(NSZone *)zone {
	UserModel *clone = [[UserModel alloc] init];
	
	clone.id = self.id;
	clone.name = self.name;
	clone.screenName = self.screenName;
	clone.profileImageUrl = self.profileImageUrl;
	clone.profileBackgroundImageUrl = self.profileBackgroundImageUrl;
	clone.numTweets = self.numTweets;
	clone.numFollowing = self.numFollowing;
	clone.numFollowers = self.numFollowers;
	
	return clone;
}

#pragma mark - NSCoding implementation
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	
	self.id = [aDecoder decodeObjectForKey:@"id"];
	self.name = [aDecoder decodeObjectForKey:@"name"];
	self.screenName = [aDecoder decodeObjectForKey:@"screenName"];
	self.profileImageUrl = [aDecoder decodeObjectForKey:@"profileImageUrl"];
	self.profileBackgroundImageUrl = [aDecoder decodeObjectForKey:@"profile_background_image_url_https"];
	self.numTweets = [aDecoder decodeObjectForKey:@"statuses_count"];
	self.numFollowing = [aDecoder decodeObjectForKey:@"friends_count"];
	self.numFollowers = [aDecoder decodeObjectForKey:@"followers_count"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.id forKey:@"id"];
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.screenName forKey:@"screenName"];
	[aCoder encodeObject:self.profileImageUrl forKey:@"profileImageUrl"];
	[aCoder encodeObject:self.profileBackgroundImageUrl forKey:@"profile_background_image_url_https"];
	[aCoder encodeObject:self.numTweets forKey:@"statuses_count"];
	[aCoder encodeObject:self.numFollowing forKey:@"friends_count"];
	[aCoder encodeObject:self.numFollowers forKey:@"followers_count"];
	
}

@end
