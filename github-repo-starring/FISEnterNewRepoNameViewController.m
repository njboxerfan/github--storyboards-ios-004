//
//  FISEnterNewRepoNameViewController.m
//  github-repo-starring
//
//  Created by Joe Burgess on 3/23/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISEnterNewRepoNameViewController.h"
#import "FISConfirmRepoNameViewController.h"
#import "FISGithubRepository.h"

@interface FISEnterNewRepoNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *repoName;

@end

@implementation FISEnterNewRepoNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.repoName.text= self.repo.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    self.repo.name = self.repoName.text;
    
    FISConfirmRepoNameViewController *destVC = segue.destinationViewController;
    
    destVC.repo = self.repo;
    destVC.whatever = self.repoName.text;
}

@end
