//
//  CustomCell.h
//  FavoriteICons
//
//  Created by Ronald Hernandez on 10/4/15.
//  Copyright © 2015 Hardcoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;

@end
