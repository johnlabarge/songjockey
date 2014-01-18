//
//  SongCell.m
//  SongJockey
//
//  Created by John La Barge on 12/27/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
