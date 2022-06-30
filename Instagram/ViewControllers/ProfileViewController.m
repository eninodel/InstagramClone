//
//  ProfileViewController.m
//  Instagram
//
//  Created by Edwin Delgado on 6/30/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "Profile.h"

@interface ProfileViewController ()
- (IBAction)didUpdateProfileImage:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didUpdateProfileImage:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
//    NSLog(@"%@", [[PFUser currentUser] objectId]);
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    [query includeKey:@"Profile"];
    
    __block NSString *profileObjectId = @"";
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects != nil){
            NSLog(@"%@", objects);
            PFUser *user = objects[0];
            profileObjectId = (NSString*) user[@"Profile"][@"objectId"];
        } else{
            
        }
    }];
    NSLog(@"%@", profileObjectId);
}
@end
