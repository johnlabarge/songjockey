//
//  SJPlaylists.m
//  SongJockey
//
//  Created by John La Barge on 1/19/14.
//  Copyright (c) 2014 John La Barge. All rights reserved.
//

#import "SJPlaylists.h"


@interface SJPlaylists()
+(instancetype)instance;
@property (nonatomic, strong)NSMutableDictionary *mediaPlaylistsByName;
@property (nonatomic, strong)NSMutableArray *playListNames;
@property (nonatomic, strong)NSArray *mediaPlaylists;
-(SJPlaylist *)sjplaylist:(NSString *)name;

@end

@interface SJPlaylist()

@property (nonatomic, strong) NSMutableArray * sjSongs;
-(instancetype) initWithMediaPlaylist:(MPMediaItemCollection *)mediaList;

@end

@implementation SJPlaylists
-(instancetype) init {
    self  = [super init];
    [self loadPlaylists];
    return self;
}
-(void) loadPlaylists
{
    MPMediaQuery * query = [MPMediaQuery playlistsQuery];
    self.mediaPlaylists = [query collections];
    self.playListNames = [[NSMutableArray alloc] initWithCapacity:self.mediaPlaylists.count];
    self.mediaPlaylistsByName = [[NSMutableDictionary alloc] initWithCapacity:self.mediaPlaylists.count];

    [self.mediaPlaylists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MPMediaItemCollection *playlist = (MPMediaItemCollection *)obj;
        NSString * name = [playlist valueForKey:MPMediaPlaylistPropertyName];
        [self.mediaPlaylistsByName setObject:playlist forKey:name];
        [self.playListNames addObject:name];
    }];
}

-(BOOL) playListAvailable:(NSString *)name
{
     MPMediaItemCollection * mediaPlaylist = (MPMediaItemCollection *) [self.mediaPlaylistsByName objectForKey:name];
    return (mediaPlaylist != nil);
}
-(SJPlaylist *)sjplaylist:(NSString *)name
{
    MPMediaItemCollection * mediaPlaylist = (MPMediaItemCollection *) [self.mediaPlaylistsByName objectForKey:name];
    return [[SJPlaylist alloc] initWithMediaPlaylist:mediaPlaylist];

}
+(instancetype) instance {
    static dispatch_once_t once;
    static id it;
    
    dispatch_once(&once, ^{
        it = [[self alloc] init];
    });
    return it;
}


+(SJPlaylist *)getByName:(NSString *)name
{
    return [[self instance] sjplaylist:name];
}
+(NSArray *) availablePlaylists
{
    SJPlaylists * instance = [self instance];
    return instance.playListNames;
}
+(BOOL)availableFor:(NSString *)name
{
    return [[self instance] playListAvailable:name];
}

@end


@implementation SJPlaylist
-(instancetype) init
{
    self = [super init];
    self.sjSongs = [[NSMutableArray alloc] initWithCapacity:10];
    return self;
}
-(instancetype) initWithCapacity:(NSInteger)size
{
    self = [super init];
    self.sjSongs = [[NSMutableArray alloc] initWithCapacity:size];
    return self;
}

-(instancetype) initWithMediaPlaylist:(MPMediaItemCollection *)mediaList;
{
    self = [super init];
    self.name = [mediaList valueForProperty:MPMediaPlaylistPropertyName];
    NSArray * list = [mediaList items];
    NSMutableArray * songs = [[NSMutableArray alloc ] initWithCapacity:list.count];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      SongJockeySong * song = [[SongJockeySong alloc] initWithItem:(MPMediaItem *)obj];
      [songs addObject:song];
    }];
    self.sjSongs = songs;
    return self;
}

-(void) eachSong:(void (^)(SongJockeySong *, NSUInteger index, BOOL *stop))it
{
    [self.songs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        it((SongJockeySong *)obj,idx,stop);
    }];
    
}
-(NSArray *) songs
{
    return self.sjSongs;
}

-(void)addSong:(SongJockeySong *)song forDuration:(NSInteger)seconds {
    SongJockeySong * copy = [song copy];
    copy.seconds = seconds;

    [self.sjSongs addObject:copy];
}

-(void) addSong:(SongJockeySong *)song
{
    SongJockeySong *copy= [song copy];
    [self.sjSongs addObject:copy];
}
-(NSInteger) count
{
    return self.sjSongs.count;
}

-(SongJockeySong *) songNumber:(NSInteger)number
{
    return [self.sjSongs objectAtIndex:number];
}

 
@end




