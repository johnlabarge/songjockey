//
//  SongJockeyPlayer.h
//  SongJockey
//
//  Created by John La Barge on 12/28/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SongJockeyPlayer : NSObject
@property (nonatomic, strong) AVPlayer * currentPlayer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger playForSeconds;
@property (nonatomic, assign) BOOL iCloudItemsPresent;
-(instancetype) initWithQueue:(NSArray *)songJockeySongs;
-(void)pause;
-(void)next;
-(void)previous;
-(void)play;
-(BOOL)canLoadWholeQueue;
@end
