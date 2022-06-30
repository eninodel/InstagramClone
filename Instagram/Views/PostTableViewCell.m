//
//  PostTableViewCell.m
//  Instagram
//
//  Created by Edwin Delgado on 6/28/22.
//

#import "PostTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PostTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *postBodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end
@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initializeCell{
    self.postBodyLabel.text = self.post.caption;
    NSURL *postImageURL = [NSURL URLWithString:self.post.image.url];
    [self.postImageView setImageWithURL: postImageURL];
}

@end
