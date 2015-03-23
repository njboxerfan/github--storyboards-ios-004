//
//  FISConfirmRepoNameViewController.m
//  github-repo-starring
//
//  Created by Joe Burgess on 3/23/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISConfirmRepoNameViewController.h"
#import "FISGithubRepository.h"

@interface FISConfirmRepoNameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *confirmedName;

@end

@implementation FISConfirmRepoNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.confirmedName.text = self.repo.name;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
