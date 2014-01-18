//
//  SongJockeySong.h
//  SongJockey
//
//  Created by John La Barge on 12/28/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MPMediaItemWrapper.h"
#import <AVFoundation/AVFoundation.h>

@interface SongJockeySong :NSObject <MPMediaItemWrapper, NSCopying>
-(instancetype) initWithItem:(MPMediaItem *)item;
-(MPMediaItem *) mediaItem;
@property (weak, nonatomic) MPMediaItem * mediaItem;
@property (assign, nonatomic) NSInteger seconds;
@property (readonly) NSInteger startSeconds;
@property (readonly) NSURL * url;
@property (readonly) NSString * songTitle;
@property (readonly) BOOL isICloudItem;
@property (strong, nonatomic) AVURLAsset * avAsset;
-(void) loadAsset:(void (^)(void))complete;
@end

