//
//  Session+Internal.h
//  Smackdown
//
//  Created by Leon Gersing on 12/16/11.
//  Copyright (c) 2011 fallenrogue.com. All rights reserved.
//

#import "Session.h"

@interface Session(Internal)
+ (Session *)sessionWithAttributes:(NSMutableDictionary *)attributes;
@end
