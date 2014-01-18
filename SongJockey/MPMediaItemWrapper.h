//
//  MPMediaItemWrapper.h
//  SongJockey
//
//  Created by John La Barge on 12/27/13.
//  Copyright (c) 2013 John La Barge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPMediaItemWrapper <NSObject>
-(MPMediaItem *) mediaItem;
-(NSString*) songTitle;
@end
