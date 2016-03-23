//
//  TVShowTableViewCell.h
//  Freelancer-Exam-Jimenez
//
//  Created by Mark Jeremiah Jimenez on 23/03/2016.
//  Copyright © 2016 Mark Jeremiah Jimenez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVShowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *channelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *tvShowNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSlotLabel;

@end
