//
//  LoginViewController.m
//  Instagram
//
//  Created by Edwin Delgado on 6/27/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)didSignUp:(id)sender;
- (IBAction)didLogin:(id)sender;


@end

@implementation LoginViewController

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

- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            // manually segue to logged in view
        }
    }];
}

// return true if fields fields are valid, false otherwise
- (Boolean) validateLoginForm{
    return [self.passwordTextField.text isEqual:@""] != true && [self.usernameTextField isEqual:@""] != true;
}

- (IBAction)didLogin:(id)sender {
    if(![self validateLoginForm]){
        NSLog(@"invalid login form");
    }
    [self loginUser];
}

- (IBAction)didSignUp:(id)sender {
    if(![self validateLoginForm]){
        NSLog(@"invalid login form");
    }
    [self registerUser];
}
@end
