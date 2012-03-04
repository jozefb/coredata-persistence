//
//  Child.h
//  Persistence
//
//  Created by Jozef Bozek on 4.3.2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Child : NSManagedObject

@property (nonatomic, strong) NSManagedObject *owner;

@end
