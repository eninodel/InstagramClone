//
//  DetailsViewController.m
//  Instagram
//
//  Created by Edwin Delgado on 6/30/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.caption.text = self.post.caption;
    self.username.text = self.post.author.username;
    NSURL *postImageURL = [NSURL URLWithString:self.post.image.url];
    [self.postImage setImageWithURL: postImageURL];
    self.createdAt.text = self.post.createdAt.description;
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
