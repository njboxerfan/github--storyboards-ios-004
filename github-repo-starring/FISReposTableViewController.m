//
//  FISReposTableViewController.m
//  
//
//  Created by Joe Burgess on 5/5/14.
//
//

#import "FISReposTableViewController.h"
#import "FISReposDataStore.h"
#import "FISLoginViewController.h"
#import "FISGithubRepository.h"
#import "FISGithubAPIClient.h"
#import "FISEnterNewRepoNameViewController.h"

@interface FISReposTableViewController ()
@property (strong, nonatomic) FISReposDataStore *dataStore;
- (void) signInTapped;
@end

@implementation FISReposTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.tableView.accessibilityIdentifier=@"Repo Table View";

    self.tableView.accessibilityIdentifier = @"Repo Table View";
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.dataStore = [FISReposDataStore sharedDataStore];

    UIBarButtonItem *signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleBordered target:self action:@selector(signInTapped)];
    self.navigationItem.rightBarButtonItem = signInButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([FISGithubAPIClient loggedIn]) {
        [self.dataStore getUserRepositoriesWithCompletion:^(BOOL success) {
            self.title = @"Your Repos";
            [self.tableView reloadData];
        }];
    } else
    {
        self.title = @"All Repos";
        [self.dataStore getRepositoriesWithCompletion:^(BOOL success) {
            [self.tableView reloadData];
        }];
    }
}

- (void) signInTapped
{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    
    FISLoginViewController *loginVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataStore.repositories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];

    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    cell.textLabel.text = repo.fullName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataStore toggleStarForRepo:repo CompletionBlock:^(BOOL starred) {
        if (starred) {
            NSString *message = [NSString stringWithFormat:@"You just starred %@", repo.fullName];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Repo Starred"  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else
        {
            NSString *message = [NSString stringWithFormat:@"You just unstarred %@", repo.fullName];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Repo Unstarred"  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    FISEnterNewRepoNameViewController *destVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newRepoNameVC"];
    
//    NSIndexPath *ip = [self.tableView indexPathForCell:sender];
    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    destVC.repo = repo;
    
    [self.navigationController pushViewController:destVC animated:YES];
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    FISEnterNewRepoNameViewController *destVC = segue.destinationViewController;
//
//    NSIndexPath *ip = [self.tableView indexPathForCell:sender];
//    FISGithubRepository *repo = self.dataStore.repositories[ip.row];
//    destVC.repo = repo;
//}

@end
