//
//  PhotoMapViewController.m
//  Instagram
//
//  Created by Edwin Delgado on 6/28/22.
//

#import "PhotoMapViewController.h"
#import "Post.h"
#import "FeedTableViewController.h"
#import "SceneDelegate.h"

@interface PhotoMapViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *openCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *pickFromGalleryButton;

- (IBAction)didOpenCamera:(id)sender;
- (IBAction)didPickFromGallery:(id)sender;
- (IBAction)didShare:(id)sender;
- (IBAction)didCancel:(id)sender;

@end

@implementation PhotoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.postImageView setHidden:true];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"in prepare for segue");
}

- (void) didPickImage{
    NSLog(@"in pick image");
    [self.pickFromGalleryButton setHidden:true];
    [self.openCameraButton setHidden:true];
    [self.postImageView setHidden:false];
}

- (IBAction)didCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didShare:(id)sender {
    if([self.postImageView isEqual:nil] || [self.captionTextField.text isEqual:@""]){
        return;
    }
    [Post postUserImage:self.postImageView.image withCaption:self.captionTextField.text withCompletion:^(BOOL succeeded, NSError *_Nullable error){
        if(error){
            NSLog(@"Error in uploading post");
            NSLog(@"%@", error.description);
        } else{
            NSLog(@"Successfully uploaded post");
            [self.delegate didSharePost];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) displayCamera{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void) displayGallery{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    if([editedImage isEqual:nil]){
        [self.postImageView setImage:originalImage];
    } else{
        [self.postImageView setImage:editedImage];
    }
    [self didPickImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPickFromGallery:(id)sender {
    [self displayGallery];
}

- (IBAction)didOpenCamera:(id)sender {
    [self displayCamera];
}
@end
