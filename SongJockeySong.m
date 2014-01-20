//
//  SongJockeySong.m
//  SongJockey
//
//  Created by John La Barge on 12/28/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import "SongJockeySong.h"

@implementation SongJockeySong
-(instancetype) initWithItem:(MPMediaItem *) item
{
    self = [super init];
    self.mediaItem = item;
    return self;
}
-(NSString *) songTitle
{
    return [self.mediaItem valueForProperty:MPMediaItemPropertyTitle];
}
-(NSURL *) url
{
    return [self.mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
}
-(NSInteger) startSeconds
{
    
    NSInteger start = 0;
    NSInteger duration = self.totalDuration;
    if (self.seconds < duration) {
         NSInteger midpoint = duration/2;
         start = midpoint - self.seconds/2;
    }
    return start;
    
}
-(NSInteger) totalDuration
{
    NSNumber * durationN = [self.mediaItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    return durationN.integerValue;
}
- (id)copyWithZone:(NSZone *)zone
{
    SongJockeySong * copy = [[self.class alloc] initWithItem:self.mediaItem];
    copy.seconds = self.seconds;
    copy.avAsset = self.avAsset;
    
    return copy ;
}

-(BOOL) equals:(SongJockeySong *)otherSong
{
    return (otherSong.seconds == self.seconds && [otherSong.url isEqual:self.url] );
}
-(BOOL) isICloudItem
{
    BOOL mediaItemICloud = [[self.mediaItem valueForProperty:MPMediaItemPropertyIsCloudItem] boolValue];
    
    return ( mediaItemICloud || (self.url == nil) );
}

-(void) loadAsset:(void(^)(void))complete {
    self.avAsset = [[AVURLAsset alloc] initWithURL:self.url options:nil];
    [self.avAsset loadValuesAsynchronouslyForKeys:@[@"tracks"]
     
                            completionHandler:^{
                                complete();
                            }];
    
}

@end;

