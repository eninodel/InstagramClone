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
#import "Post.h"
#import "DetailsViewController.h"

static int QueryLimit = 20;

@interface FeedTableViewController () <PhotoMapViewControllerDelegate>
- (IBAction)didLogout:(id)sender;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (assign, nonatomic) BOOL reachedBottom;
@end

@implementation FeedTableViewController
@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reachedBottom = NO;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action: @selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"TableViewSectionHeader"];
    [self fetchData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *navigationController = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"FeedtoDetails"]){
        DetailsViewController *detailsVC = (DetailsViewController *) navigationController.topViewController;
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        detailsVC.post = self.postsArray[path.section];
    } else{
        PhotoMapViewController *photoVC = (PhotoMapViewController *) navigationController.topViewController;
        photoVC.delegate = self;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.postsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableViewSectionHeader"];
    Post *post = (Post *) self.postsArray[section];
    NSString *sectionHeader = post.author.username;
    sectionHeader = [sectionHeader stringByAppendingString:@"    "];
    sectionHeader = [sectionHeader stringByAppendingString:post.createdAt.description];
    header.textLabel.text = sectionHeader;
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *detailsVC = [story instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detailsVC.post = self.postsArray[indexPath.section];
    [self.navigationController pushViewController:detailsVC animated:YES];

}
- (void) getFirstPost{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"image"];
    query.limit = 1;
    
    // fetch data asynchronously
    [self.refreshControl beginRefreshing];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            if(self.postsArray.count == 0){
                self.postsArray = (NSMutableArray*) posts;
            } else{
                NSMutableArray *newPostsArray = [[NSMutableArray alloc] init];
                [newPostsArray addObject:posts[0]];
                for(int i = 0; i < self.postsArray.count; i ++){
                    [newPostsArray addObject:self.postsArray[i]];
                }
                self.postsArray = newPostsArray;
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// query builder methods and block callback functions
- (void) fetchData {
    NSLog(@"in fetchData");
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"image"];
    query.limit = QueryLimit;
    query.skip = self.postsArray.count;
    
    // fetch data asynchronously
    [self.refreshControl beginRefreshing];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            if(self.postsArray.count == 0){
                self.postsArray = (NSMutableArray*) posts;
            } else{
                [self.postsArray addObjectsFromArray:posts];
                if(posts.count == 0){
                    self.reachedBottom = YES;
                }
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostTableViewCell" forIndexPath:indexPath];
    cell.post = self.postsArray[indexPath.section];
    [cell initializeCell];
    if(indexPath.section == self.postsArray.count - 1 && self.reachedBottom == NO){
        [self fetchData];
    }
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
    [self getFirstPost];
}

@end
