//
//  FISConfirmRepoNameViewController.m
//  github-repo-starring
//
//  Created by Joe Burgess on 3/23/15.
//  Copyright (c) 2015 Joe Burgess. All rights reserved.
//

#import "FISConfirmRepoNameViewController.h"
#import "FISReposTableViewController.h"
#import "FISGithubRepository.h"
#import "FISGithubAPIClient.h"

@interface FISConfirmRepoNameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *confirmedName;

- (IBAction)submitTapped:(id)sender;

@end

@implementation FISConfirmRepoNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.confirmedName.text = self.whatever;
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

- (IBAction)submitTapped:(id)sender
{
    NSString *newName = self.confirmedName.text;
    
    [FISGithubAPIClient changeRepoWithFullName:self.repo.fullName newName:newName CompletionBlock:^(NSDictionary *repo) {
        
        FISReposTableViewController *reposTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reposTableViewController"];
        
        UINavigationController *presentingNavVC = (UINavigationController *)self.navigationController;
        
        [presentingNavVC setViewControllers:@[reposTableVC]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
