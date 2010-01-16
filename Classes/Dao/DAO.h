//
//  Persistence
//
//  Created by Ing. Jozef Bozek on 29.5.2009.
//
//	Copyright © 2009 Grapph. All Rights Reserved.
// 
//	Redistribution and use in source and binary forms, with or without 
//	modification, are permitted provided that the following conditions are met:
//
//	1. Redistributions of source code must retain the above copyright notice, this 
//	   list of conditions and the following disclaimer.
//
//	2. Redistributions in binary form must reproduce the above copyright notice, 
//	   this list of conditions and the following disclaimer in the documentation 
//	   and/or other materials provided with the distribution.
//
//	3. Neither the name of the author nor the names of its contributors may be used
//	   to endorse or promote products derived from this software without specific
//	   prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY GRAPPH "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
//	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

@class CDSearchCriteria;
@class NSManagedObject;
@class NSManagedObjectID;
@class NSFetchedResultsController;

@protocol DAO <NSObject>

// returns all managed objects id
-(NSArray*)findAllId;

// returns all managed objects
-(NSArray*)findAll;

// returns all managed objects - with pagination
-(NSArray*)findAll:(NSUInteger)fetchOffset limit:(NSUInteger)limit;

// returns all managed objects id - with pagination
-(NSArray*)findAllId:(CDSearchCriteria*)criteria;

// returns all managed objects based on given criteria
-(NSArray*)findAll:(CDSearchCriteria*)criteria;

// returns all managed objects based on given criteria - with pagination
-(NSArray*)findAll:(CDSearchCriteria*)criteria fetchOffset:(NSUInteger)fetchOffset limit:(NSUInteger)limit;

// returns all managed objects count
-(NSUInteger)count;

// returns all managed objects based on given criteria
-(NSUInteger)count:(CDSearchCriteria*)criteria;

// inserts new managed object and returns it to caller
-(NSManagedObject*)insertNewObject;

// deletes given managed object
-(void)deleteObject:(NSManagedObject*)object;

// resturns managed object with given id
-(NSManagedObject*)findObjectById:(NSManagedObjectID*)objectID;

// if flag is YES, merges an object with the state of the object available in the persistent store coordinator; 
// if flag is NO, simply refaults an object without merging (which also causes other related managed objects to be released, so you can use this method to trim the portion of your object graph you want to hold in memory) 
- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag;

// returns new fetched results controller
-(NSFetchedResultsController*)newFetchedResultsController:(CDSearchCriteria*)criteria sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;

// returns autoreleased fetched results controller
-(NSFetchedResultsController*)createFetchedResultsController:(CDSearchCriteria*)criteria sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;

@end

