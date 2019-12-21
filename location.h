#pragma once
#include <stdint.h>

enum ELocationFlags
{
	ELOC_DEBUG_TRACE = 0x1,
};
enum ELocationDrainFlags
{
	ELOCDRAIN_OSXRUNLOOP = 0x1,
};

struct SLocationInfo
{
	double Latitude;
	double Longitude;
	double Altitude;
	double HorizontalAccuracy;
	double VerticalAccuracy;
};

#ifdef __cplusplus
extern "C"
{
#endif

	uint32_t LocationStart(uint32_t Flags = 0);
	void LocationStop();
	uint32_t LocationDrain(SLocationInfo* pLocationInfo, uint32_t NumLocationInfo, uint32_t Flags = ELOCDRAIN_OSXRUNLOOP);

#ifdef __cplusplus
}
#endif
