//
//  CDContainsFilter.h
//  Persistence
//
//  Created by Jozef Bozek on 27.3.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDOperatorFilter.h"

@interface CDContainsFilter : CDOperatorFilter {
    
}

@property (nonatomic, assign) BOOL caseSensitive;

-(NSString*)operatorString;

@end
