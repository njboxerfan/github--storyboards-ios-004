//
//  FISLoginViewController.m
//  github-repo-starring
//
//  Created by Joe Burgess on 7/25/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISLoginViewController.h"
#import "FISConstants.h"
#import "FISGithubAPIClient.h"

@interface FISLoginViewController ()
- (IBAction)loginTapped:(id)sender;

@end

@implementation FISLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([FISGithubAPIClient loggedIn]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginTapped:(id)sender {

    NSString *githubString = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@",GITHUB_CLIENT_ID];
    NSURL *githubURL = [NSURL URLWithString:githubString];
    [[UIApplication sharedApplication] openURL:githubURL];
}
@end
