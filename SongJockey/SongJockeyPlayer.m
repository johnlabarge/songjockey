//
//  SongJockeyPlayer.m
//  SongJockey
//
//  Created by John La Barge on 12/28/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import "SongJockeyPlayer.h"
#import "SongJockeySong.h"
#import "AVFoundation/AVPlayer.h"
@interface SongJockeyPlayer() {
        dispatch_queue_t _timer_queue;
        dispatch_source_t _timer;
        dispatch_queue_t _playerLoadingQueue;
}

@property (nonatomic, weak) NSTimer * secondsClock;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger pausedIndex;
@property (nonatomic, assign) NSInteger pausedTime;
@property (nonatomic, assign) NSInteger timeUntilSwitch;

 


@property (nonatomic, assign) NSInteger readyPlayers;
@property (nonatomic, weak) NSTimer * readyTimer;

@end
@implementation SongJockeyPlayer


-(instancetype) initWithSJPlaylist:(SJPlaylist *)sjplaylist
{
    self = [super init];
 
    self.currentIndex=0;
    
    self.songQueue = [[SJPlaylist alloc] initWithCapacity:sjplaylist.count]; 
    
    
    [sjplaylist eachSong:^(SongJockeySong *song, NSUInteger index, BOOL *stop) {
        if (!song.isICloudItem) {
            NSLog(@"loading asset for song : %@ at %@", song.songTitle, [song.url absoluteString]);
            
            song.userInfo = [NSNumber numberWithInteger:index]; 
            [song loadAsset:^{ NSLog(@"loaded asset for %@", song.songTitle);}];
            /*can't play for longer than the song */
            [self.songQueue addSong:song forDuration:MIN(song.seconds,song.totalDuration)];
        } else {
            self.iCloudItemsPresent = YES;
        }
    }];
    
    _playerLoadingQueue = dispatch_queue_create("playerLoading", NULL);
    

   
    return self;
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{ }
-(void) timerTick
{
    self.time++;
    self.timeUntilSwitch--;
    if (self.timeUntilSwitch <= 0) {
        [self next];
    }
    [self tickNotification];
}

-(BOOL) canLoadWholeQueue
{
    __block BOOL answer;
   [self.songQueue eachSong:^(SongJockeySong *song, NSUInteger index, BOOL *stop) {
      if (song.isICloudItem) {  /*icloud item*/
          answer = NO;
          *stop = YES;
      }
   }];
    
    return answer;
}

-(void) tickNotification
{
    NSNotification * note = [NSNotification notificationWithName:kSJTimerNotice  object:[NSNumber numberWithInteger:self.timeUntilSwitch]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

-(void) nextNotification
{
    NSNotification *note = [NSNotification notificationWithName:kSJNextSong object:[NSNumber numberWithInteger:self.currentIndex]];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void) readyTimeout
{
    NSNotification * note = [NSNotification notificationWithName:kSJPlayerReadyTimeout object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}
-(void)pause
{
    [self.currentPlayer pause];
    [self killTimer];
}
-(void) fixIndex
{
    if (_currentIndex > (self.songQueue.count -1)) {
        _currentIndex = 0;
    } else if (_currentIndex < 0) {
        _currentIndex = 0;
    }
}

-(void) setCurrentIndex:(NSInteger)newValue
{
    _currentIndex = newValue;
    [self fixIndex];
}
-(SongJockeySong *) currentSong
{
    return [self.songQueue songNumber:self.currentIndex];
}
-(NSInteger) originalIndexOfCurrentSong
{
    return [(NSNumber *)self.currentSong.userInfo integerValue];
}
-(void)next
{

    [self.currentPlayer pause];
    self.currentIndex++;
    self.time = 0;
    [self nextNotification];
    [self playSong];
    
}
-(void)previous
{
    [self.currentPlayer pause];
    self.currentIndex--;
    [self playSong];
}
-(void)playSong
{
    SongJockeySong * currentSong = self.currentSong;
    NSLog(@"playing %@", currentSong.songTitle);
    self.currentPlayer = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithAsset:currentSong.avAsset]];
 
    
    if (self.currentPlayer.status != AVPlayerStatusReadyToPlay) {
        NSLog(@"player not ready...");
    }
    
    if (self.currentPlayer.status == AVPlayerStatusFailed) {
        NSLog(@"player status failed");
    }
    
    else if (self.currentPlayer.status == AVPlayerItemStatusUnknown) {
        NSLog(@"player status unknown");
    }
    NSInteger startSeconds = currentSong.startSeconds;
    if (self.time > 0) {
        startSeconds += self.time;
    } else {
        self.timeUntilSwitch = currentSong.seconds;
    }
   
    [self playWhenReady];
    
    
}
-(void) playWhenReady
{
    __weak SongJockeyPlayer * me = self;
    dispatch_async(_playerLoadingQueue, ^{
        while (true) {
            NSLog(@"busy wait %@", me.currentSong.songTitle);
            if (me.currentPlayer.status == AVPlayerStatusReadyToPlay && me.currentPlayer.status == AVPlayerItemStatusReadyToPlay)
                break;
        }
        [me.currentPlayer play];
        [me.currentPlayer seekToTime:CMTimeMake(me.currentSong.startSeconds,1)];
        
        [me createTimer];
    });

    

}
-(void) playIndex:(NSInteger)index
{
    self.currentIndex = index;
    [self fixIndex];
    [self playSong];
}

-(void) play
{
    [self playSong];
}

-(void) createTimer
{
    _timer_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    /*timer source, handle undefined for timer, mask is also unused for timer, use the queue above */
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _timer_queue);
    
    /* setup a one second timer for the dispatcher */
    dispatch_source_set_timer(_timer,dispatch_time(DISPATCH_TIME_NOW,0) , NSEC_PER_SEC,0);
   
    /* call back to self to issue the timer tick notification */
    __weak SongJockeyPlayer * me = self;
    dispatch_source_set_event_handler(_timer, ^{
        [me timerTick];
    });
    
    /*start the timer*/
    dispatch_resume(_timer);
}
-(void) killTimer
{
    /* cancel the timer dispatch source
     */
    dispatch_source_cancel(_timer);
}
@end
