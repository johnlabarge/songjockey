//
//  OptionDelegate.h
//  SongJockey
//
//  Created by John La Barge on 1/19/14.
//  Copyright (c) 2014 John La Barge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OptionDelegate <NSObject>
-(void) optionChosen:(NSObject *)option;
@end
