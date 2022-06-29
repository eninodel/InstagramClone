//
//  PostTableViewCell.h
//  Instagram
//
//  Created by Edwin Delgado on 6/28/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : UITableViewCell
@property (strong, nonatomic) Post *post;
- (void) initializeCell;
@end

NS_ASSUME_NONNULL_END
