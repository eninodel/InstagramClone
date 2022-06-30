//
//  DetailsViewController.h
//  Instagram
//
//  Created by Edwin Delgado on 6/30/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Post *post;

- (void) initializeDetailsView;
@end

NS_ASSUME_NONNULL_END
