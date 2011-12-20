//
//  Agenda+Agenda_Internal_.h
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "Agenda.h"

@interface Agenda (Agenda_Internal_)

+ (Agenda *)sharedAgenda;
+ (BOOL)isAttendingSession:(Session *)session;

- (void)attendSession:(Session *)session;
- (void)doNotAttendSession:(Session *)session;

@end
