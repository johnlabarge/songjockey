//
//  PlaylistChooserViewController.h
//  SongJockey
//
//  Created by John La Barge on 1/19/14.
//  Copyright (c) 2014 John La Barge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionDelegate.h"

@interface PlaylistChooserViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) UIPickerView * pickerView;
@property (nonatomic, weak) UIButton * okButton;

@property (nonatomic, weak) id <OptionDelegate> delegate;

@end
