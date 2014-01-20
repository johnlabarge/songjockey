//
//  PlaylistChooserViewController.m
//  SongJockey
//
//  Created by John La Barge on 1/19/14.
//  Copyright (c) 2014 John La Barge. All rights reserved.
//

#import "PlaylistChooserViewController.h"
#import "SJPlaylists.h"

@interface PlaylistChooserViewController ()
@property (nonatomic, strong) NSString * chosen;
@end

@implementation PlaylistChooserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseAndClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate optionChosen:self.chosen];
    }];
}

#pragma mark UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [SJPlaylists availablePlaylists].count ;
}
#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[SJPlaylists availablePlaylists] objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosen = [[SJPlaylists availablePlaylists] objectAtIndex:row];
}
@end
