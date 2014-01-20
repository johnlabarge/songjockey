//
//  SJPlaylists.h
//  SongJockey
//
//  Created by John La Barge on 1/19/14.
//  Copyright (c) 2014 John La Barge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongJockeySong.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SJPlaylist : NSObject
@property (nonatomic, strong) NSString *name;
@property (readonly) NSArray *songs;
@property (readonly) NSInteger count;
/**
 *  inits the contained array with the given size
 *  @param size - the size of the contained array
 */
-(instancetype) initWithCapacity:(NSInteger)size;
-(void)eachSong:(void(^)(SongJockeySong * song, NSUInteger index, BOOL *stop))it;
/** 
 * adds song with same duration as param
 * @param song the song to add.
 */
-(void)addSong:(SongJockeySong *)song;
/**
 * adds song with the supplied duration
 * @param song the song to add.
 */
-(void)addSong:(SongJockeySong *)song forDuration:(NSInteger)seconds;

-(SongJockeySong *)songNumber:(NSInteger) number;

@end

@interface SJPlaylists : NSObject


+(NSArray *)availablePlaylists;
+(SJPlaylist *)getByName:(NSString *)name;

@end


