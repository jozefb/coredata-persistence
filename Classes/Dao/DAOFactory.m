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

#import <CoreData/CoreData.h>
#import "DAO.h"
#import "common_defines.h"
#import "DAOFactory.h"
#import "RuntimeDAO.h"

@interface DAOFactory () 

@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;

@end

@implementation DAOFactory

static DAOFactory* factory;
static NSString* storePath;
static NSString* storeType;
static NSDictionary* options;

+(void)initialize {
	factory = [[DAOFactory alloc] init];
}

+ (void)setStoreOptions:(NSDictionary *)_options {
    if (options != _options) {
		options = [_options copy];
	}
}

+ (void)setStorePath:(NSString*)path {
	if (storePath != path) {
		storePath = [path copy];
	}
}

+ (NSString*)storePath {
	return storePath;
}

+ (void)setStoreType:(NSString*)aStoreType {
	if (storeType != aStoreType) {
		storeType = [aStoreType copy];
	}
}

+ (NSString*)storeType {
	return storeType;
}

-init {
	if (factory) {
		return factory;
	}
	
	if (!(self=[super init])) {
		return nil;
	}
	
	return factory=self;  
}

+(DAOFactory*)factory {
 	return factory;
}

-(id)newDAO:(Class)daoType {
	DAO *dao = [[daoType alloc] initWithContext:self.managedObjectContext];
	return dao;
}

-(id)newRuntimeDAO:(NSString*)entityName {
	DAO *dao = [[RuntimeDAO alloc] initWithContextAndEntityName:self.managedObjectContext entityName:entityName];
	return dao;
}

-(id)createDAO:(NSString*)entityName {
	DAO *dao = [[RuntimeDAO alloc] initWithContextAndEntityName:self.managedObjectContext entityName:entityName];
	return dao;
}

-(BOOL)save:(NSError**)error {
	BOOL result = [self.managedObjectContext save:error];
	return result;
}

-(BOOL)save {
	NSError* error = nil;
	BOOL result = [self.managedObjectContext save:&error];
	if (!result) {
		LOG_ERROR(error);
	}
	return result;
}

- (void)undo{
	[self.managedObjectContext undo];
}

- (void)redo{
	[self.managedObjectContext redo];
}

- (void)reset{
	[self.managedObjectContext reset];
}

- (void)rollback {
	[self.managedObjectContext rollback];
}

-(NSUndoManager*)undoManager {
	return [self managedObjectContext].undoManager;
}

-(void)setUndoManager:(NSUndoManager*)undoManager {
	self.managedObjectContext.undoManager = undoManager;
}


- (BOOL)setupCoreDataStack {
    NSString* storePathTmp = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[DAOFactory storePath]];
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:storePathTmp]) {
		
		NSMutableString* compsString = [NSMutableString stringWithCapacity:100];
		NSArray* comps = [storePath componentsSeparatedByString:@"."];
		for (int i = 0; i < comps.count - 1; i++) {
			NSString* comp = [comps objectAtIndex:i];
			[compsString appendString:comp];
			if (i < comps.count - 2) {
				[compsString appendString:@"."];
			}
		}
		
		NSString* resType = [comps objectAtIndex:comps.count - 1];
		NSString* path = [[NSBundle mainBundle] pathForResource:compsString ofType:resType];
        if (path && [path length] > 0) {
            NSError* error;
            if (![fileManager copyItemAtPath:path toPath:storePathTmp error:&error]) {
                LOG_ERROR(error);
                return NO;
            }
        }
	}
	
    NSURL *storeUrl = [NSURL fileURLWithPath: storePathTmp];
	
	NSError *error = nil;
	if (storeType == nil) {
		[DAOFactory setStoreType:NSSQLiteStoreType];
	}
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: _managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:[DAOFactory storeType] configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
		LOG_ERROR(error);
        return NO;
    }
    
    return YES;
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (_managedObjectContext == nil) {
        [self setupCoreDataStack];
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
    }
	
    return _managedObjectContext;
}

- (void)registerManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    [self willChangeValueForKey:@"managedObjectContext"];
    _managedObjectContext = managedObjectContext;
    [self didChangeValueForKey:@"managedObjectContext"];
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel == nil) {
        [self setupCoreDataStack];
    }
    
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator == nil) {
        [self setupCoreDataStack];
    }
	
    return _persistentStoreCoordinator;
}

#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = [paths lastObject];
    return basePath;
}


#pragma mark -


@end
