//
//  Persistence
//
//  Created by Ing. Jozef Bozek on 29.5.2009.
//
//	Copyright © 2010 bring-it-together s.r.o.. All Rights Reserved.
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
//	THIS SOFTWARE IS PROVIDED BY BRING-IT-TOGETHER S.R.O. "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
//	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "DAOBase.h"
#import <CoreData/CoreData.h>
#import "CDSearchCriteria.h"
#import "common_defines.h"

@implementation DAO

@synthesize managedObjectContext;
@synthesize entityName;

- (id <CDQueryTransformInterceptor>)newCriteriaInterceptor {
	return self;
}

- (void)registerInterceptor:(id <CDCriteria>)criteria {
	CDSearchCriteria *sc = (CDSearchCriteria*)criteria;
	[sc registerInterceptor:[self newCriteriaInterceptor]];
}

- (NSFetchRequest*)createFetchRequest {
	NSEntityDescription* entityDescritpion = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescritpion];
	return request;
}

-(NSArray*)findAll {
	CDSearchCriteria* criteria = [CDSearchCriteria criteria];
	return [self findAll:criteria];
}

-(NSArray*) findAll:(NSUInteger)fetchOffset limit:(NSUInteger)limit {
	CDSearchCriteria* criteria = [CDSearchCriteria criteria];		
	return [self findAll:criteria fetchOffset:fetchOffset limit:limit];
}

-(NSArray*) findAll:(CDSearchCriteria*)criteria fetchOffset:(NSUInteger)fetchOffset limit:(NSUInteger)limit {
	if (criteria == nil) {
		criteria = [CDSearchCriteria criteria];
	}
	
	[self registerInterceptor:criteria];
	NSFetchRequest* request = [criteria createFetchRequest];
	[request setFetchLimit:limit];
	[request setFetchOffset:fetchOffset];
	
	NSError* error = nil;
	NSArray* result = [managedObjectContext executeFetchRequest:request error:&error];
	CHECK_LOG_ERROR(error);
	
	return result;
}

-(NSArray*)findAllId {
	CDSearchCriteria* criteria = [CDSearchCriteria criteria];		
	return [self findAllId:criteria];
}


-(NSUInteger)count {
	return [self count:nil];
}

-(NSUInteger)count:(CDSearchCriteria*)criteria {
	if (criteria == nil) {
		criteria = [CDSearchCriteria criteria];
	}
	
	[self registerInterceptor:criteria];
	NSFetchRequest* request = [criteria createFetchRequest];

	[request setResultType:NSManagedObjectIDResultType];
	NSError* error = nil;
	NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
	CHECK_LOG_ERROR(error);
	
	return count;
}

-(NSArray*) findAllId:(CDSearchCriteria*)criteria {
	if (criteria == nil) {
		criteria = [CDSearchCriteria criteria];
	}

	[self registerInterceptor:criteria];
	NSFetchRequest* request = [criteria createFetchRequest];
	
	[request setResultType:NSManagedObjectIDResultType];
	NSError* error = nil;
	NSArray* result = [managedObjectContext executeFetchRequest:request error:&error];
	CHECK_LOG_ERROR(error);
	
	return result;
}

-(NSArray*) findAll:(CDSearchCriteria*)criteria {
	if (criteria == nil) {
		criteria = [CDSearchCriteria criteria];
	}
	
	[self registerInterceptor:criteria];
	NSFetchRequest* request = [criteria createFetchRequest];
	NSError* error = nil;
	NSArray* result = [managedObjectContext executeFetchRequest:request error:&error];
	CHECK_LOG_ERROR(error);
		
	return result;
}

-(id)insertNewObject{
	NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
	return object;
}

-(void)deleteObject:(NSManagedObject*)object{	
	[managedObjectContext deleteObject:object];
}

-(id)findObjectById:(NSManagedObjectID*)entityID {
	return [managedObjectContext objectWithID:entityID];
}

// if flag is YES, merges an object with the state of the object available in the persistent store coordinator; if flag is NO, simply refaults an object without merging (which also causes other related managed objects to be released, so you can use this method to trim the portion of your object graph you want to hold in memory) 
- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag {
	[managedObjectContext refreshObject:object mergeChanges:flag];
}

////////////////////////////////

-(id)init{
    self = [super init];
	if (self) {
		
	}
	
	return self;
}

-(id)initWithContextAndEntityName:(NSManagedObjectContext*)context entityName:(NSString*)name {
    self = [self init];
	if (self) {
		self.entityName = name;
		self.managedObjectContext = context;
	}
	
	return self;
}

-(id)initWithContextAndEntityName:(NSManagedObjectContext*)context entityClass:(Class)entityClass {
    return [self initWithContextAndEntityName:context entityName:NSStringFromClass(entityClass)];
}

-(id)initWithContext:(NSManagedObjectContext*)context {
    self = [self initWithContextAndEntityName:context entityName:nil];
	if (self) {
		
	}
	
	return self;
}


-(NSFetchedResultsController*)newFetchedResultsController:(CDSearchCriteria*)criteria sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
	[self registerInterceptor:criteria];
	NSFetchRequest* request = [criteria createFetchRequest];
		
	NSFetchedResultsController* result = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:sectionNameKeyPath cacheName:name];
	return result;
}

-(NSFetchedResultsController*)createFetchedResultsController:(CDSearchCriteria*)criteria sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
	return [self newFetchedResultsController:criteria sectionNameKeyPath:sectionNameKeyPath cacheName:name];
}

#pragma mark CDSearchCriteriaDelegate
- (void)beforeCreateFetchRequest:(id<CDCriteria>)criteria {
	
}

@end
