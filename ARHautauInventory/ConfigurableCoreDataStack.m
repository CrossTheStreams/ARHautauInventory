//
//  Created by Martin Nash on 3/4/15.
//  Copyright (c) 2015 Martin Nash. All rights reserved.
//

#import "ConfigurableCoreDataStack.h"


@implementation CoreDataStackConfiguration

-(instancetype)initWithConfigurator:(id<StackConfigurator>)config
{
    self = [super init];
    if (self) {
        _storeType = [config storeType];
        _modelName = [config modelName];
        _appIdentifier = [config appIdentifier];
        _dataFileNameWithExtension = [config dataFileNameWithExtension];
        _searchPathDirectory = [config searchPathDirectory];
    }
    return self;
}

@end



@interface ConfigurableCoreDataStack ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) CoreDataStackConfiguration *configuration;

@end

@implementation ConfigurableCoreDataStack

+(instancetype)defaultStack {
    static ConfigurableCoreDataStack *defaultStack = nil;
    @synchronized(self) {
        if (defaultStack == nil) {
            // Insert code here to initialize your application
            CoreDataStackConfiguration *config = [[CoreDataStackConfiguration alloc] init];
            [config setStoreType: NSSQLiteStoreType];
            [config setModelName: @"Item"];
            [config setAppIdentifier:@"com.ARHautauInventory"];
            [config setDataFileNameWithExtension:@"ARHautauInventory.sqlite"];
            [config setSearchPathDirectory: NSApplicationSupportDirectory];
            defaultStack = [[ConfigurableCoreDataStack alloc] initWithConfiguration: config];
        }
    }
    return defaultStack;
}

+(instancetype)stackWithConfiguration:(CoreDataStackConfiguration *)configuration
{
    return [[self alloc] initWithConfiguration:configuration];
}

+(instancetype)stackWithConfigurator:(id<StackConfigurator>)configurator
{
    return [[self alloc] initWithConfigurator:configurator];
}

-(instancetype)initWithConfigurator:(id<StackConfigurator>)configurator
{
    CoreDataStackConfiguration *cf = [[CoreDataStackConfiguration alloc] initWithConfigurator:configurator];
    return [self initWithConfiguration:cf];
}

-(instancetype)initWithConfiguration:(CoreDataStackConfiguration*)configuration;
{
    self = [super init];
    if (self) {
        _configuration = configuration;
        [self setupStack];
    }
    return self;
}

-(instancetype)init
{
    @throw @"Use -initWithStoreType:";
}




#pragma mark - internal

/// returns url to file `~/<your serach path directory>/<your reverse told app identifier>`
-(NSURL *)applicationDocumentsDirectory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *possible = [fm URLsForDirectory:self.configuration.searchPathDirectory inDomains:NSUserDomainMask];
    NSURL *appSupportURL = [possible lastObject];
    return [appSupportURL URLByAppendingPathComponent:self.configuration.appIdentifier];
}

/// returns url to file `~/<your serach path directory>/<your reverse told app identifier>/<your data file name with extension>`
-(NSURL*)dataFileURL
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.configuration.dataFileNameWithExtension];
}

-(void)setupStack
{
    // ENSURE APP FILES DIRECTORY EXISTS
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *appPath = [[self applicationDocumentsDirectory] path];
    [fm createDirectoryAtPath:appPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    // MODEL
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.configuration.modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    // STORE & COORDINATOR
    NSURL *storeURL = [self dataFileURL];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [psc addPersistentStoreWithType:self.configuration.storeType
                      configuration:nil
                                URL:storeURL
                            options:nil
                              error:nil];
    
    
    // CONTEXT
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;
    _managedObjectContext = moc;
    
}

-(void) killCoreDataStack {
    [[NSFileManager defaultManager] removeItemAtURL:[self dataFileURL] error: nil];
}

@end
