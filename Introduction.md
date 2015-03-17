# Introduction #

Persistence has been implemented for the simplification and making easier the work with Core Data Framework and represents its light object wrapper.

It is designed for the common usage scenarios, where it is sufficient the Core Data stack handling and the basic object (objects graph) querying or possibble using of projection for some of the attributes of the managed objects.

It covers the base Core Data Framework functionality by using  the common patterns: DAO (Data Access Object) and Factory.

Besides the both there is also added a group of classes which act as light objects wrapped around the Cocoa predicates.

In the following section are decribed the base blocks of Presistence API

At the very beginning you need to set the store data file path and its store type inside of the app delegate right next to the calling of the method „application DidFinishLaunching“ (for instance for sqlite store type):

```
- (void)applicationDidFinishLaunching:(UIApplication *)application {  
 	[DAOFactory setStorePath:@"test.sqlite"]; 
	[DAOFactory setStoreType:NSSQLiteStoreType];
        ...
```

File test.sqlite is empty or prefilled database file located inside the Resources group (Xcode). The file will by automatically copied for the first time into the Documents folder of the application.

## DAOFactory ##
Its used for dynamic DAO creation of _RuntimeDAO_ objects or descendants the _DAOBase_ class.
```
	DAOFactory *factory = [DAOFactory factory];
	DAO *dao = [factory createRuntimeDAO:@"EntityName"];
```

You can extend DAOFactory and implement factory methods for your custom DAOs:
```
	DAOFactory *factory = [DAOFactory factory];
	MyCustomDAO *dao = (MyCustomDAO*)[factory newDAO:MyCustomDAO.class];
	...
	[dao release];
```
## DAO ##
DAO class with its protocol defines generic methods for managed object manipulation.
Each DAO serves for only the one single managed object type, which means that it is defined for only this particular managed object type.
The RuntimeDAO class is simple DAO implementation which can be used if you do not need to implement the custom methods for data object manipulation.
If you need or want to wrap up your business logic which is related to core data's object manipulation (CRUD with extended features), we are recommending you to implement it right into your custom DAO.
Example of DAO's methods declaration:

```
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
## Cocoa predicates - querying ##
As the base class for managed objects querying serves the _CDSearchCriteria_ class, which is simply the holder for the 'filters', 'orders 'and 'projections'. All of the classes appropriate to the criteria contain factory methods for the instantiation of the required criteria objects.

### Filters ###
The Filters are used as the predicates for the restriction of the query's results.
The filters are represented by the _CDFilter_ class (and its subclasses). All of the Core Data predicates (such as 'beginswith', 'ANY', 'ALL' operators… ) are not supported in this current version.
```
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addFilter:[CDFilter like:@"stringProperty1" value:@"abc*" caseSensitive:NO]];
	[criteria addFilter:[CDFilter isNotNull:@"timeStamp"]];
```

### Orders ###
The Orders are used to order the query's results. An order is represented by the _CDOrder_, which is quite simple class.
```
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addOrder:[CDOrder ascendingOrder:@"timeStamp"]];
```

### Projections ###
The Projections are used for obtaining not the whole graphs of the managed objects but only its attributes or the calculated values. Projections are represented by the _CDProjection_ class.
```
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addProjection:[CDProjection createWithProperty:@"timeStamp"]];
```

After successful querying the projection results values are stored in the array for each result row in the dictionary. Simple values of the projection results are stored in the dictionary under the key of the properties name.
Projection for the function is stored in the dictionary with a compound key in the following form `function name:property name` for example `@"min:property1"`.

### Functions ###
Functions are used in the filters or projections and represent certain transformations of the managed objects property values. In the current version  it is  'min', 'max', 'sum' and 'lower'

```
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	[criteria addFilter:[CDFilter isNotNull:@"timeStamp"]];
	[criteria addProjection:[CDProjection createWithFunction:[CDFunction sum:@"timeStamp" resultType:NSDateAttributeType]]];
```

### NSFetchedResultsController ###
DAO protocol contains methods for an easy creation of the NSFetchedResultsController on the basis of the given criteria:
```
	CDSearchCriteria *criteria = [CDSearchCriteria criteria];
	...
	DAO *dao = [[DAOFactory factory] createRuntimeDAO:@"Event"];	
	fetchedResultsController = [dao newFetchedResultsController:criteria sectionNameKeyPath:nil cacheName:@"Root"];
```

No documentation is included in this up-to-date version. Anyhow, the source code is self-explanatory and has altogether only a few hundred lines.

Any questions will be answered, feel free to contact us.

Grapph team