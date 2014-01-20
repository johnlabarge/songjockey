//
//  ohstarterViewController.h
//  SongJockey
//
//  Created by John La Barge on 12/15/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongJockeyPlayer.h"
#import "SJConstants.h"
#import "SJPlaylists.h"
#import "OptionDelegate.h"

@interface SongJockeyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, OptionDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *currentPlayListLabel;
@property (weak, nonatomic) IBOutlet UITableView *songTableView;
@property (weak, nonatomic) IBOutlet UITextField *playForTextField;
@property (strong, nonatomic) NSString * thePlaylist;
@property (strong, nonatomic) SJPlaylist * songs;
@property (nonatomic, assign) NSInteger playForSeconds;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) SongJockeyPlayer * sjPlayer;

@property (weak, nonatomic) IBOutlet UILabel *clockLabel;


@end
