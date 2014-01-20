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
#import "SJPlaylists.h"
#import "PlaylistChooserViewController.h"

@interface SongJockeyViewController ()

@property (nonatomic, strong) NSIndexPath * currentSongIndexPath;
@end

@implementation SongJockeyViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.playForTextField.text=@"5";
    self.playForSeconds = 5;
    NSLog(@"self.songs.count = %lu", (unsigned long)self.songs.songs.count);
    UINib * songCellNib = [UINib  nibWithNibName:@"songcell" bundle:nil];
    [self.songTableView registerNib:songCellNib forCellReuseIdentifier:@"songcell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sjtick:) name:kSJTimerNotice object:nil];
        [self playerButtonsEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sjNextSong:) name:kSJNextSong object:nil];

    [self configurePlayForSecondsField];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}


-(void) configurePlayForSecondsField
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowing:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHiding:) name:UIKeyboardWillHideNotification object:nil];
    
    self.playForTextField.inputAccessoryView  = [self doneBar];
    

}

-(UIView *) doneBar
{
    UIToolbar * numberToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,50)];
    numberToolbar.barStyle = UIBarStyleDefault;
   
   
     numberToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissNumberPad:)]];
    
    [numberToolbar sizeToFit];
    return numberToolbar;
}
-(void) setSongs:(SJPlaylist *)songs
{
    _songs = songs;
    [self updateSongsSeconds];
    self.sjPlayer = [[SongJockeyPlayer alloc] initWithSJPlaylist:_songs];
    [self.songTableView reloadData];
    if (!([self.sjPlayer canLoadWholeQueue])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Songs unavailable."
                                                        message: @"Some songs in your playlist weren't available because they haven't been downloaded from iCloud (iTunes Match) yet.  To prevent this message in the future go back to your iPod application and make sure you download all the songs for the playlist." delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        [alert show];
    
    } else {

        [self playerReady];
    }
    

}
-(void) sjtick:(NSNotification *) notification
{
    NSInteger value =  [notification.object integerValue];
    __weak UILabel * clockLabel = self.clockLabel;
    dispatch_async(dispatch_get_main_queue(), ^{
        clockLabel.text = [NSString stringWithFormat:@"%d", value];
    });
}
-(void) sjNextSong:(NSNotification *)notification
{
    __weak SongJockeyViewController * me = self;
    dispatch_async(dispatch_get_main_queue(), ^{ [me.songTableView reloadData];
        NSLog(@"currentSong indexPathRow = %d",me.self.sjPlayer.originalIndexOfCurrentSong);
        
        NSLog(@"scrolling");
        [me.songTableView scrollToRowAtIndexPath:[NSIndexPath  indexPathForItem:self.sjPlayer.originalIndexOfCurrentSong inSection:0]
                                atScrollPosition:UITableViewScrollPositionNone
                                        animated:YES];
        
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

     _playForSeconds = playForSeconds;
    [self updateSongsSeconds];
    self.sjPlayer = [[SongJockeyPlayer alloc] initWithSJPlaylist:_songs];
    [self.songTableView reloadData];
}

-(void) updateSongsSeconds
{
    [self.songs eachSong:^(SongJockeySong *song, NSUInteger index, BOOL *stop) {
        song.seconds = self.playForSeconds;
    }];
    
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
    return self.songs.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SongJockeySong * song = [self.songs.songs objectAtIndex:indexPath.row];
    SongCell * songCell =  (SongCell *)[tableView dequeueReusableCellWithIdentifier:@"songcell"];
    if (song.isICloudItem) {
        NSDictionary * attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]};
        NSAttributedString * songText= [[NSAttributedString alloc] initWithString:song.songTitle attributes:attributes];
        songCell.title.attributedText = songText;
    } else {
          
        songCell.title.text =[song songTitle];
    }
   
    if ([song equals:self.sjPlayer.currentSong ]) {
        NSLog(@"row: %d current song: %@",indexPath.row, song.songTitle);
        self.currentSongIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        songCell.contentView.backgroundColor = [UIColor yellowColor];
        songCell.selected=YES;

    } else {
        songCell.selected = NO;
        songCell.contentView.backgroundColor = [UIColor blackColor];
    }
    return songCell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"playListChooser"]) {
        PlaylistChooserViewController * plvc = (PlaylistChooserViewController *)segue.destinationViewController;
        plvc.delegate = self;
    }
}

#pragma mark OptionDelegate 

-(void) optionChosen:(NSObject *)option
{
    NSString * playListName = (NSString *) option;
    self.songs = [SJPlaylists getByName:playListName];
    self.currentPlayListLabel.text = playListName;
}

#pragma mark UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self playerReady];
}

-(IBAction)dismissNumberPad:(id)sender {
    self.playForSeconds = [self.playForTextField.text integerValue];
    
    [self.playForTextField resignFirstResponder];
}

-(void) keyboardShowing:(NSNotification *)note
{
    NSDictionary * info = note.userInfo;
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - kbSize.height, self.view.frame.size.width, self.view.frame.size.height);
}

-(void) keyboardHiding:(NSNotification *)note
{
    self.view.frame = CGRectMake(0.0,0.0,self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark UITextFieldDelegate



@end
