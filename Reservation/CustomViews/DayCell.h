//
//  DayCell.h
//  Reservation
//
//  Created by Hafiz Amaduddin Ayub on 3/8/17.
//  Copyright © 2017 GApp Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end
