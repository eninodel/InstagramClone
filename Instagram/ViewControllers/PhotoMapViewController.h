//
//  PhotoMapViewController.h
//  Instagram
//
//  Created by Edwin Delgado on 6/28/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoMapViewControllerDelegate <NSObject>

-(void) didSharePost;

@end

@interface PhotoMapViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id<PhotoMapViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
