//
//  SongJockeyPlayer.h
//  SongJockey
//
//  Created by John La Barge on 12/28/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SJConstants.h"
#import "SJPlaylists.h"

@interface SongJockeyPlayer : NSObject
@property (nonatomic, strong) AVPlayer * currentPlayer;
@property (nonatomic, assign) NSInteger currentIndex;
/**
 * songs that won't load (most likely because they are stored in iCloud and not local
 * are pruned from the supplied playlist
 * this property returns their index within the originally supplied list.
 */
@property (readonly) NSInteger originalIndexOfCurrentSong;
@property (nonatomic, assign) NSInteger playForSeconds;
@property (nonatomic, assign) BOOL iCloudItemsPresent;
@property (nonatomic, strong) SJPlaylist * songQueue;
@property (readonly) SongJockeySong * currentSong;
-(instancetype) initWithSJPlaylist:(SJPlaylist *)sjplaylist;
-(void)pause;
-(void)next;
-(void)previous;
-(void)play;
-(BOOL)canLoadWholeQueue;
@end
