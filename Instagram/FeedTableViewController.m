//
//  FeedTableViewController.m
//  Instagram
//
//  Created by Edwin Delgado on 6/27/22.
//

#import "FeedTableViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "PostTableViewCell.h"
#import "PhotoMapViewController.h"

@interface FeedTableViewController () <PhotoMapViewControllerDelegate>
- (IBAction)didLogout:(id)sender;
@property (strong, nonatomic) NSArray *postsArray;
@property (assign, nonatomic) NSInteger reloadThreshold;
@end

@implementation FeedTableViewController
@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reloadThreshold = 0;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action: @selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self fetchData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *navigationController = [segue destinationViewController];
    PhotoMapViewController *photoVC = (PhotoMapViewController *) navigationController.topViewController;
    photoVC.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (void) fetchData {
    NSLog(@"in fetchData");
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"image"];
    query.limit = 20;
    query.skip = self.reloadThreshold;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.postsArray = posts;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
//            self.reloadThreshold += 20;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostTableViewCell" forIndexPath:indexPath];
    cell.post = self.postsArray[indexPath.row];
    [cell initializeCell];
    return cell;
}


- (IBAction)didLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"Error in didLogout");
        }
    }];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    SceneDelegate *sceneDelegate = (SceneDelegate * ) UIApplication.sharedApplication.connectedScenes.allObjects.firstObject.delegate;
    sceneDelegate.window.rootViewController = loginViewController;
}
- (void)didSharePost {
    NSLog(@"in did share post");
    [self fetchData];
}

@end
