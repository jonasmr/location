#include "location.h"
#include "stdio.h"
#include <unistd.h>

int main()
{

	LocationStart(ELOC_DEBUG_TRACE);
	SLocationInfo Info[20];
	for(int i = 0; i < 10; ++i)
	{
		printf("iter %d\n", i);
		int Count = LocationDrain(Info, 20);
		for(int i = 0; i < Count; ++i)
		{
			printf("Got loc %f %f %f %f %f\n", Info[0].Latitude, Info[0].Longitude, Info[0].Altitude, Info[0].HorizontalAccuracy, Info[0].VerticalAccuracy);
		}
		sleep(1);
	}
	LocationStop();
}
