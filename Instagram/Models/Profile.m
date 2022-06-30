//
//  Profile.m
//  Instagram
//
//  Created by Edwin Delgado on 6/30/22.
//

#import "Profile.h"
#import "Parse/Parse.h"
#import <Foundation/Foundation.h>

@implementation Profile

@dynamic profileImage;

+ (nonnull NSString *) parseClassName{
    return @"Profile";
}

+(void) updateUserProfileImage: ( UIImage * _Nullable )image
                withCompletion: (PFBooleanResultBlock  _Nullable)completion{
//    NSArray<PFObject *> *currentUserArray = [[NSArray alloc] init];
//    [PFObject fetchAllIfNeeded: [currentUserArray arrayByAddingObject:[PFUser currentUser]]];
    NSString *profileObjectId = [PFUser currentUser][@"Profile"];
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId: profileObjectId
                                 block:^(PFObject *profile, NSError *error) {
        profile[@"profileImage"] = [self getPFFileFromImage:image];
        [profile saveInBackground];
    }];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
@end
