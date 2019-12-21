#include "location.h"
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

static void LocationProcessLocation(double Latitude, double Longitude, double Altitude, double HorizontalAccuracy, double VerticalAccuracy);
/**
		- codesign --verbose --force --deep --entitlements Foo.entitlements
--sign - ./Foo.app





Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd"> <plist version="1.0"> <dict>
  <key>CFBundleGetInfoString</key>
  <string>Foo</string>
  <key>CFBundleExecutable</key>
  <string>sph</string>
  <key>CFBundleIdentifier</key>
  <string>com.storfist.www</string>
  <key>CFBundleName</key>
  <string>foo</string>
  <key>CFBundleIconFile</key>
  <string>foo.icns</string>
  <key>CFBundleShortVersionString</key>
  <string>0.01</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>IFMajorVersion</key>
  <integer>0</integer>
  <key>IFMinorVersion</key>
  <integer>1</integer>
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>This application requires location services to work FISK FISK</string>
  <key>NSLocationAlwaysUsageDescription</key>
  <string>This application requires location services to work HEST HEST</string>
</dict>
</plist>j


		Foo.entitlements
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd"> <plist version="1.0"> <dict>
		<key>com.apple.security.app-sandbox</key>
		<true/>
		<key>com.apple.security.files.user-selected.read-only</key>
		<true/>
		<key>com.apple.security.personal-information.location</key>
		<true/>
</dict>
</plist>


lav run-loop:

void start_run_loop()
{
	BOOL done = NO;

	// Add your sources or timers to the run loop and do any other setup.

	do
	{
		// Start the run loop but return after each source is handled.
		SInt32    result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);

		// If a source explicitly stopped the run loop, or if there are no
		// sources or timers, go ahead and exit.
		if ((result == kCFRunLoopRunStopped) || (result ==
kCFRunLoopRunFinished))
		{
			// done = YES;
		}

		// Check for any other exit conditions here and set the
		// done variable as needed.
	}
	while (!done);

}


//init thread from _main..

*/

@interface Foo : NSObject <CLLocationManagerDelegate>
{
	NSUInteger age;
	NSString* name;

	// @property (weak) id <XYZPieChartViewDataSource> dataSource;
}

@property(nonatomic, readwrite) NSUInteger age;
@property(nonatomic, copy) NSString* name;
@property(nonatomic, readwrite, retain) CLLocationManager* LocationManager;
// @property (retain) id <CLLocationManagerDelegate> theDelegate;

- (void)multiplyAgeByFactor:(NSUInteger)factor;
- (NSString*)description;
- (void)logDescription;

@end

@implementation Foo
@synthesize age;
@synthesize name;

- (void)multiplyAgeByFactor:(NSUInteger)factor
{
	[self setAge:([self age] * factor)];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"age: %i, name: %@\n", (unsigned)[self age], [self name]];
}

- (void)logDescription
{
	NSLog(@"%@", [self description]);
}

- (void)fisk_status
{

	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	// NSLog(@"AUTH xx STATUS %d", status);
	[self.LocationManager requestLocation];

	if([CLLocationManager locationServicesEnabled])
	{
		// NSLog(@"Location Services enabled");
	}
	else
	{
		// NSLog(@"Location Services not enabled");
	}
}

- (void)fisk
{

	NSString* ns = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
	NSLog(@"THE STRING IS %@", ns);
	NSLog(@"STARTING IT");

	// dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT,
	// 0), ^{
	//     NSData* data = [NSData dataWithContentsOfURL:
	//       kLatestKivaLoansURL];
	//     [self performSelectorOnMainThread:@selector(fetchedData:)
	//       withObject:data waitUntilDone:YES];
	// });
	dispatch_async(dispatch_get_main_queue(), ^{
	  NSLog(@"****ALLOC MAIN&*****");
	  NSLog(@"****ALLOC MAIN&*****");
	  NSLog(@"****ALLOC MAIN&*****");
	  NSLog(@"****ALLOC MAIN&*****");
	  self.LocationManager = [[CLLocationManager alloc] init];
	  self.LocationManager.delegate = self;
	  // [self.LocationManager requestLocation];
	  // [self.LocationManager requestAlwaysAuthorization];
	  [self.LocationManager startUpdatingLocation];
	  NSLog(@"****ALLOC MAIN DONE &*****");
	  NSLog(@"****ALLOC MAIN DONE &*****");
	  NSLog(@"****ALLOC MAIN DONE &*****");
	  NSLog(@"****ALLOC MAIN DONE &*****");
	});
}
- (void)dealloc
{
	NSLog(@"DEALLOC!!!! %@", [self description]);
	[super dealloc];
}

#pragma mark - CLLocationManagerDelegate

- (void)LocationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
	NSLog(@"**************************** didFailWithError %@", error);
}

- (void)LocationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
	CLLocation* newLocation = [locations lastObject];
	NSLog(@"**************************** didUpdateLocations %@", newLocation);
}

- (void)LocationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	NSLog(@"**************************** didChangeAuthorizationStatus !!!%d", status);
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
	NSLog(@"**************************** didFailWithError %@", error);
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
	CLLocation* newLocation = [locations lastObject];
	NSLog(@"**************************** didUpdateLocations %@", newLocation);
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	NSLog(@"**************************** didChangeAuthorizationStatus !!!%d", status);
}

// - (void)locationManager:(CLLocationManager *)manager
// didChangeAuthorizationStatus:(CLAuthorizationStatus)status
// {
// 	NSLog(@"didChangeAuthorizationStatus !!!%d", status);
// }

@end

@interface LocationWrapper : NSObject <CLLocationManagerDelegate>
{
	NSUInteger DebugTrace;
}
@property(nonatomic, readwrite, retain) CLLocationManager* LocationManager;
@property(nonatomic, readwrite) NSUInteger DebugTrace;
@end

@implementation LocationWrapper
@synthesize DebugTrace;

- (void)debug_print
{
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	[self.LocationManager requestLocation];

	if([CLLocationManager locationServicesEnabled])
	{
		NSLog(@"Location Services enabled");
	}
	else
	{
		NSLog(@"Location Services not enabled");
	}
}

- (void)start:(NSUInteger)TraceEnabled
{

	// NSString* ns = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
	// NSLog(@"THE STRING IS %@", ns);
	NSLog(@"STARTING IT");

	// dispatch_async(dispatch_get_main_queue(), ^{
	NSLog(@"****ALLOC MAIN&*****");
	NSLog(@"****ALLOC MAIN&*****");
	NSLog(@"****ALLOC MAIN&*****");
	NSLog(@"****ALLOC MAIN&*****");
	self.LocationManager = [[CLLocationManager alloc] init];
	self.LocationManager.delegate = self;
	[self.LocationManager requestLocation];
	// [self.LocationManager requestAlwaysAuthorization];
	[self.LocationManager startUpdatingLocation];
	NSLog(@"****ALLOC MAIN DONE &*****");
	NSLog(@"****ALLOC MAIN DONE &*****");
	NSLog(@"****ALLOC MAIN DONE &*****");
	NSLog(@"****ALLOC MAIN DONE &*****");
	// });
}
- (void)stop
{
	NSLog(@"STOP!!");
}
- (void)dealloc
{
	NSLog(@"DEALLOC!!!! %@", [self description]);
	[super dealloc];
}

#pragma mark - CLLocationManagerDelegate

- (void)LocationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
	NSLog(@"**************************** didFailWithError %@", error);
}

- (void)LocationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
	CLLocation* newLocation = [locations lastObject];
	CLLocationCoordinate2D coordinate = [newLocation coordinate];
	double latitude = coordinate.latitude;
	double longitude = coordinate.longitude;
	double altitude = [newLocation altitude];
	double horizontalAccuracy = [newLocation horizontalAccuracy];
	double verticalAccuracy = [newLocation verticalAccuracy];
	NSLog(@"***********xxxx ***************** didUpdateLocations %@", newLocation);
	LocationProcessLocation(latitude, longitude, altitude, horizontalAccuracy, verticalAccuracy);
	NSLog(@"**************************** didUpdateLocations %@", newLocation);
}

- (void)LocationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	NSLog(@"**************************** didChangeAuthorizationStatus !!!%d", status);
}

- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
	NSLog(@"**************************** didFailWithError %@", error);
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
	CLLocation* newLocation = [locations lastObject];

	// CLLocation* newLocation = [locations lastObject];
	CLLocationCoordinate2D coordinate = [newLocation coordinate];
	double latitude = coordinate.latitude;
	double longitude = coordinate.longitude;
	double altitude = [newLocation altitude];
	double horizontalAccuracy = [newLocation horizontalAccuracy];
	double verticalAccuracy = [newLocation verticalAccuracy];
	NSLog(@"***********xwwwwwwxxx ***************** didUpdateLocations %@", newLocation);
	LocationProcessLocation(latitude, longitude, altitude, horizontalAccuracy, verticalAccuracy);

	NSLog(@"**************xqqq************** didUpdateLocations %@", newLocation);
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	NSLog(@"**************************** didChangeAuthorizationStatus !!!%d", status);
}

@end

void start_run_loop()
{
	BOOL done = NO;

	// Add your sources or timers to the run loop and do any other setup.

	do
	{
		// printf("run loop running!\n");
		// Start the run loop but return after each source is handled.
		SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);

		// If a source explicitly stopped the run loop, or if there are no
		// sources or timers, go ahead and exit.
		if((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
		{
			// done = YES;
		}

		// Check for any other exit conditions here and set the
		// done variable as needed.
	} while(!done);
	printf("run loop quit!\n");
}
void objc_fuzz(void* p, int v)
{
	// NSLog(@"************** FUZZ");
	Foo* f = (Foo*)p;
	[f fisk_status];

	//
	// [f multiplyAgeByFactor:v];
	// [f logDescription];
}

void* objc_create(int age, const char* name)
{
	NSString* NS = @(name);

	Foo* s = [[Foo alloc] init]; // Ref count is 1
	[s fisk];
	[s setAge:age];
	[s setName:NS];
	return (void*)s;
}

void objc_delete(void* s)
{
	Foo* f = (Foo*)s;
	[f release];
}

int call_ojc()
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

	Foo* jon = [[[Foo alloc] init] autorelease];
	[jon setAge:17];
	[jon setName:@"Jon Sterling"];

	[jon logDescription];
	[jon multiplyAgeByFactor:2];
	[jon logDescription];

	[pool drain];

	return 0;
}

#include <thread>

struct SLocationState
{
	enum
	{
		MAX_LOCATIONS = 32,
	};
	uint32_t NumLocations;
	SLocationInfo Locations[MAX_LOCATIONS];

	std::mutex Lock;
	std::thread* pThread;
	std::atomic<uint32_t> nQuit;

	uint32_t Flags;
	LocationWrapper* Wrapper;
};

#define ZBREAK() __builtin_trap()
#define ZASSERT(expr)                                                                                                                                                                                  \
	do                                                                                                                                                                                                 \
	{                                                                                                                                                                                                  \
		if(!(expr))                                                                                                                                                                                    \
		{                                                                                                                                                                                              \
			ZBREAK();                                                                                                                                                                                  \
		}                                                                                                                                                                                              \
	} while(0)

static SLocationState State;
static uint32_t Running;

static void RunLoopThread()
{
	// start_run_loop();
}
static void LocationStartRunLoop()
{
	ZASSERT(State.nQuit == 0);
	ZASSERT(State.pThread == 0);
	State.pThread = new std::thread(RunLoopThread);
}
static void LocationStopRunLoop()
{
	State.nQuit = 1;
	State.pThread->join();
}
static void LocationProcessLocation(double Latitude, double Longitude, double Altitude, double HorizontalAccuracy, double VerticalAccuracy)
{
	printf("Adding location\n");

	uint32_t Pos = State.NumLocations++;
	if(Pos >= SLocationState::MAX_LOCATIONS)
	{
		memmove(&State.Locations[0], &State.Locations[1], sizeof(State.Locations) - sizeof(State.Locations[0]));
		Pos = SLocationState::MAX_LOCATIONS - 1;
		State.NumLocations = SLocationState::MAX_LOCATIONS;
	}
	SLocationInfo& Out = State.Locations[Pos];
	Out.Latitude = Latitude;
	Out.Longitude = Longitude;
	Out.Altitude = Altitude;
	Out.HorizontalAccuracy = HorizontalAccuracy;
	Out.VerticalAccuracy = VerticalAccuracy;
}

uint32_t LocationStart(uint32_t Flags)
{
	ZASSERT(!Running);
	State.Flags = Flags;
	// if(Flags & ELOC_OSX_START_RUNLOOP)
	// {
	// 	LocationStartRunLoop();
	// }
	NSUInteger Trace = Flags & ELOC_DEBUG_TRACE ? 1 : 0;

	State.Wrapper = [[LocationWrapper alloc] init];
	[State.Wrapper start:Trace];
	[State.Wrapper retain];
	Running = 1;
	return 0;
}
void LocationStop()
{
	ZASSERT(Running);
	// if(State.Flags & ELOC_OSX_START_RUNLOOP)
	// {
	// 	LocationStopRunLoop();
	// }
	[State.Wrapper stop];
	[State.Wrapper release];
	[State.Wrapper dealloc];
	State.Wrapper = 0;
	Running = 1;
}
uint32_t LocationDrain(SLocationInfo* pLocationInfo, uint32_t NumLocationInfo, uint32_t Flags)
{
	printf("Drain!\n");
	if(Flags & ELOCDRAIN_OSXRUNLOOP)
	{
		int x = 0;
		int r = 0;
		do
		{

			r = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, YES);
			printf("Retval %d %d\n", r, x++);
		} while(kCFRunLoopRunHandledSource == r || kCFRunLoopRunFinished == r);
	}
	NumLocationInfo = NumLocationInfo < State.NumLocations ? NumLocationInfo : State.NumLocations;
	memcpy(pLocationInfo, State.Locations, NumLocationInfo * sizeof(pLocationInfo[0]));
	State.NumLocations = 0;
	return NumLocationInfo;
}
