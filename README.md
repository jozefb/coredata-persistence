# CoreData Persistence

Persistence has been implemented for the simplification and making easier the work with Core Data Framework and represents its light object wrapper. The project is inspired by the kbucek Persistence API framework built on Java

It is designed for the common usage scenarios, where it is sufficient the Core Data stack handling and the basic object (objects graph) querying or possibble using of projection for some of the attributes of the managed objects.

It covers the base Core Data Framework functionality by using the common patterns: DAO (Data Access Object) and Factory.

##Introduction
Persistence has been implemented for the simplification and making easier the work with Core Data Framework and represents its light object wrapper.

It is designed for the common usage scenarios, where it is sufficient the Core Data stack handling and the basic object (objects graph) querying or possibble using of projection for some of the attributes of the managed objects.

It covers the base Core Data Framework functionality by using the common patterns: DAO (Data Access Object) and Factory.

Besides the both there is also added a group of classes which act as light objects wrapped around the Cocoa predicates.

In the following section are decribed the base blocks of Presistence API

At the very beginning you need to set the store data file path and its store type inside of the app delegate right next to the calling of the method „application DidFinishLaunching?“ (for instance for sqlite store type):

```objc
- (void)applicationDidFinishLaunching:(UIApplication *)application {  
        [DAOFactory setStorePath:@"test.sqlite"]; 
        [DAOFactory setStoreType:NSSQLiteStoreType];
        ...
```
File test.sqlite is empty or prefilled database file located inside the Resources group (Xcode). 
The file will by automatically copied for the first time into the Documents folder of the application.

##DAOFactory
Its used for dynamic DAO creation of RuntimeDAO objects or descendants the DAOBase class.
```objc
        DAOFactory *factory = [DAOFactory factory];
        DAO *dao = [factory createRuntimeDAO:@"EntityName"];
```        
You can extend DAOFactory and implement factory methods for your custom DAOs:
```objc
        DAOFactory *factory = [DAOFactory factory];
        MyCustomDAO *dao = (MyCustomDAO*)[factory newDAO:MyCustomDAO.class];
        ...
        [dao release];
```
##DAO
DAO class with its protocol defines generic methods for managed object manipulation. Each DAO serves for only the one single managed object type, which means that it is defined for only this particular managed object type. The RuntimeDAO class is simple DAO implementation which can be used if you do not need to implement the custom methods for data object manipulation. If you need or want to wrap up your business logic which is related to core data's object manipulation (CRUD with extended features), we are recommending you to implement it right into your custom DAO. Example of DAO's methods declaration:
```objc
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
```
