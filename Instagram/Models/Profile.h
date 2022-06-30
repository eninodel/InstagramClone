//
//  Profile.h
//  Instagram
//
//  Created by Edwin Delgado on 6/30/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Profile : PFObject<PFSubclassing>

@property(nonatomic, strong) PFFileObject *profileImage;

+(void) updateUserProfileImage: ( UIImage * _Nullable )image
                withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
