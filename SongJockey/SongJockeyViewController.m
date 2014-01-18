//
//  ohstarterViewController.m
//  SongJockey
//
//  Created by John La Barge on 12/15/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import "SongJockeyViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMediaItemWrapper.h"
#import "SongCell.h"
#import "SongJockeySong.h"
#import "SongJockeyPlayer.h"

@interface SongJockeyViewController ()


@end

@implementation SongJockeyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.songs = [self getSongsForPlayList:@"songjockeylist"];
    self.playForTextField.text=@"5";
    self.playForSeconds = 5;
    NSLog(@"self.songs.count = %lu", (unsigned long)self.songs.count);
    UINib * songCellNib = [UINib  nibWithNibName:@"songcell" bundle:nil];
    [self.songTableView registerNib:songCellNib forCellReuseIdentifier:@"songcell"];
    [self.songTableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sjtick:) name:@"sjplayertick" object:nil];
    [self playerButtonsEnabled:NO];

    
    self.sjPlayer = [[SongJockeyPlayer alloc] initWithQueue:self.songs];
    if (!([self.sjPlayer canLoadWholeQueue])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Songs unavailable."
                                                        message: @"Some songs in your playlist weren't available because they haven't been downloaded from iCloud (iTunes Match) yet.  To prevent this message in the future go back to your iPod application and make sure you download all the songs for the playlist." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self playerReady];
    }
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void) sjtick:(NSNotification *) notification
{
    NSInteger value =  [notification.object integerValue];
    __weak UILabel * clockLabel = self.clockLabel;
    dispatch_async(dispatch_get_main_queue(), ^{
        clockLabel.text = [NSString stringWithFormat:@"%d", value];
    });
}
-(void) playerReady
{
    [self playerButtonsEnabled:YES];
}

-(void) playerTimeout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Couldn't load all songs." message: @"Couldn't download songs. Try downloading all the songs in your playlist manually" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; 
}
-(void) playerButtonsEnabled:(BOOL)enable
{
    self.previousButton.enabled = enable ;
    self.playButton.enabled = enable;
    self.pauseButton.enabled = enable;
    self.nextButton.enabled = enable;
}
-(void) setPlayForSeconds:(NSInteger)playForSeconds
{
      [self.songs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          SongJockeySong * song = (SongJockeySong *) obj;
          song.seconds = playForSeconds;
      }];
    _playForSeconds = playForSeconds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)previous:(id)sender {
    [self.sjPlayer previous];
    
}
- (IBAction)play:(id)sender {
    [self.sjPlayer play];
}
- (IBAction)pause:(id)sender {
    [self.sjPlayer pause];
}
- (IBAction)next:(id)sender {
    [self.sjPlayer next];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SongJockeySong * song = [self.songs objectAtIndex:indexPath.row];
    SongCell * songCell =  (SongCell *)[tableView dequeueReusableCellWithIdentifier:@"songcell"];
    songCell.title.text =[song songTitle];
    return songCell;
}

-(NSArray *) getSongsForPlayList:(NSString *)
thePlaylist{
    __block NSMutableArray * songs;
    MPMediaQuery *playlistQuery = [MPMediaQuery playlistsQuery];
    NSArray * playlists = [playlistQuery collections];
    __block MPMediaItemCollection * chosenPlaylist;
    [playlists enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MPMediaItemCollection *playlist = (MPMediaItemCollection *)obj;
        if ([[playlist valueForKey:MPMediaPlaylistPropertyName]
            isEqualToString:thePlaylist]) {
            chosenPlaylist = playlist;
            *stop = YES;
            
        }
        
    }];
    if (chosenPlaylist != nil) {
        
        NSArray * mpMediaItems = [chosenPlaylist items];
        songs = [[NSMutableArray alloc ] initWithCapacity:mpMediaItems.count];
        [mpMediaItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SongJockeySong * song = [[SongJockeySong alloc] initWithItem:(MPMediaItem *)obj];
            [songs addObject:song];
            NSLog(@" song = %@", song.songTitle );
        }];
        
    }
    return songs;
    
}



@end
