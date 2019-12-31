#include "location.h"
#include "stdint.h"
#include "string.h"
static void LocationProcessLocation(double Latitude, double Longitude, double Altitude, double HorizontalAccuracy, double VerticalAccuracy);

// @interface LocationWrapper : NSObject <CLLocationManagerDelegate>
// {
// 	NSUInteger DebugTrace;
// }
// @property(nonatomic, readwrite, retain) CLLocationManager* LocationManager;
// @property(nonatomic, readwrite) NSUInteger DebugTrace;
// @end

// @implementation LocationWrapper
// @synthesize DebugTrace;

// - (void)debug_print
// {
// 	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
// 	[self.LocationManager requestLocation];

// 	if([CLLocationManager locationServicesEnabled])
// 	{
// 		NSLog(@"**LOCCATION**: Location Services enabled");
// 	}
// 	else
// 	{
// 		NSLog(@"**LOCCATION**: Location Services not enabled");
// 	}
// }

// - (void)start:(NSUInteger)TraceEnabled
// {
// 	self.DebugTrace = TraceEnabled;

// 	if(self.DebugTrace)
// 	{
// 		NSLog(@"**LOCCATION**: Starting Location");
// 	}
// 	self.LocationManager = [[CLLocationManager alloc] init];
// 	self.LocationManager.delegate = self;
// 	[self.LocationManager requestLocation];
// 	[self.LocationManager startUpdatingLocation];
// }
// - (void)stop
// {
// 	if(self.DebugTrace)
// 	{
// 		NSLog(@"**LOCCATION**: Stopping Location");
// 	}
// 	[self.LocationManager stopUpdatingLocation];
// }
// - (void)dealloc
// {
// 	[super dealloc];
// }

// #pragma mark - CLLocationManagerDelegate

// - (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
// {
// 	if(self.DebugTrace)
// 	{
// 		NSLog(@"**LOCCATION**: didFailWithError %@", error);
// 	}
// }

// - (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
// {
// 	if(self.DebugTrace)
// 	{
// 		NSLog(@"**LOCCATION**: didChangeAuthorizationStatus !!!%d", status);
// 	}
// }

// - (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
// {
// 	CLLocation* newLocation = [locations lastObject];
// 	CLLocationCoordinate2D coordinate = [newLocation coordinate];
// 	double latitude = coordinate.latitude;
// 	double longitude = coordinate.longitude;
// 	double altitude = [newLocation altitude];
// 	double horizontalAccuracy = [newLocation horizontalAccuracy];
// 	double verticalAccuracy = [newLocation verticalAccuracy];
// 	LocationProcessLocation(latitude, longitude, altitude, horizontalAccuracy, verticalAccuracy);

// 	if(self.DebugTrace)
// 	{
// 		NSLog(@"**LOCCATION**: didUpdateLocations %@", newLocation);
// 	}
// }

// @end

struct SLocationState
{
	enum
	{
		MAX_LOCATIONS = 32,
	};
	uint32_t NumLocations;
	SLocationInfo Locations[MAX_LOCATIONS];
	uint32_t Flags;
};
#ifdef _WIN32
#define ZBREAK() __debugbreak()
#else
#define ZBREAK() __builtin_trap()
#endif
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

static void LocationProcessLocation(double Latitude, double Longitude, double Altitude, double HorizontalAccuracy, double VerticalAccuracy)
{
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
	// ZASSERT(!Running);
	// State.Flags = Flags;

	// NSUInteger Trace = Flags & ELOC_DEBUG_TRACE ? 1 : 0;

	// State.Wrapper = [[LocationWrapper alloc] init];
	// [State.Wrapper start:Trace];
	// [State.Wrapper retain];
	// Running = 1;
	return 0;
}
void LocationStop()
{
	ZASSERT(Running);

	// [State.Wrapper stop];
	// [State.Wrapper release];
	// [State.Wrapper dealloc];
	// State.Wrapper = 0;
	Running = 1;
}
uint32_t LocationDrain(SLocationInfo* pLocationInfo, uint32_t NumLocationInfo, uint32_t Flags)
{
	// if(State.Flags & ELOC_DEBUG_TRACE)
	// {
	// 	[State.Wrapper debug_print];
	// }

	// if(Flags & ELOCDRAIN_OSXRUNLOOP)
	// {
	// 	int x = 0;
	// 	int r = 0;
	// 	do
	// 	{
	// 		r = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, YES);
	// 	} while(kCFRunLoopRunHandledSource == r || kCFRunLoopRunFinished == r);
	// }
	// NumLocationInfo = NumLocationInfo < State.NumLocations ? NumLocationInfo : State.NumLocations;
	// memcpy(pLocationInfo, State.Locations, NumLocationInfo * sizeof(pLocationInfo[0]));
	// State.NumLocations = 0;
	return 0;
}
