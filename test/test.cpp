#include "../location.h"
#include "stdio.h"
#ifndef _WIN32
#include <unistd.h>
#else
#include <Windows.h>
#include "Synchapi.h"
#endif

int main()
{
	printf("start\n");
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
		#ifdef _WIN32
		Sleep(1000);
		#else
		sleep(1);
		#endif


	}
	LocationStop();
	printf("done\n");
}
