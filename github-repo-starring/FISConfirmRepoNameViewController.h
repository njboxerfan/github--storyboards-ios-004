//
//  FISConfirmRepoNameViewController.h
//  github-repo-starring
//
//  Created by Joe Burgess on 3/23/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FISGithubRepository;

@interface FISConfirmRepoNameViewController : UIViewController

@property (strong, nonatomic) FISGithubRepository *repo;

@property NSString *whatever;

@end
