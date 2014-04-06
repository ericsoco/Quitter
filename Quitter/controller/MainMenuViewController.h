//
//  MainMenuViewController.h
//  Quitter
//
//  Created by Eric Socolofsky on 4/5/14.
//  Copyright (c) 2014 Eric Socolofsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainMenuViewController;
@protocol MainMenuDelegate <NSObject>

- (void)mainMenuViewController:(MainMenuViewController *)mainMenuViewControler didSelectMenuItem:(int)menuId;

@end

@interface MainMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id<MainMenuDelegate> delegate;

@end
