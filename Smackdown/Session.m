//
//  Session.m
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "Session.h"
#import "Note.h"
#import "Speaker.h"


@implementation Session

@dynamic precompiler;
@dynamic attending;
@dynamic notes;
@dynamic speaker;
@dynamic startAt;
@dynamic name;
@dynamic sessionID;
@synthesize timeSlot=_timeSlot;

- (NSString *)timeSlot{
  if(_timeSlot) return _timeSlot;
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *dateComponents =
  [cal components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:self.startAt];
  
  _timeSlot =  [NSString stringWithFormat:@"%u/%u - %u:%u",
                [dateComponents month],
                [dateComponents day],
                [dateComponents hour],
                [dateComponents minute]];
  
  return _timeSlot;
}


@end
