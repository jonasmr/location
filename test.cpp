#include "location.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include <dispatch/dispatch.h>
#include <thread>
#include <unistd.h>

void write_it(FILE* fout)
{
	char path[1000];
	getcwd(path, sizeof(path));
	fprintf(fout, "fisk 1\n");
	fprintf(fout, "path is %s\n", path);
	FILE* F = fopen("fisk.txt", "r");
	if(F)
	{
		fseek(F, 0, SEEK_END);
		int size = ftell(F);

		fseek(F, 0, SEEK_SET);
		char* text = (char*)malloc(size + 1);
		memset(text, 0, size + 1);
		fread(text, 1, size, F);
		fprintf(fout, "TEXT IS %s\n", text);
	}
	fprintf(fout, "fisk 2\n");
}

void write_it_path(const char* p)
{
	FILE* F = fopen(p, "w");
	if(!F)
	{
		// __builtin_trap();
	}
	write_it(F);
	fclose(F);
}
void* the_object = 0;
void startup()
{
	the_object = objc_create(1212, "foo");
}
void main_loop()
{
	static int CC = 0;
	// printf("MAIN LOOP %d\n", CC++);
	CC++;
	sleep(1);
	objc_fuzz(the_object, 1);
	if(CC == 100)
	{
		exit(0);
	}
	dispatch_async(dispatch_get_main_queue(), ^{
	  main_loop();
	});
}

void dispatch_thread()
{
	dispatch_main();
}

int main()
{

	printf("starting\n");

	if(1)
	{
		LocationStart();
		SLocationInfo Info[20];
		for(int i = 0; i < 100; ++i)
		{
			int Count = LocationDrain(Info, 20);
			printf("loop %d drained %d\n", i, Count);
			for(int i = 0; i < Count; ++i)
			{
				printf("Got loc %f %f %f %f %f\n", Info[0].Latitude, Info[0].Longitude, Info[0].Altitude, Info[0].HorizontalAccuracy, Info[0].VerticalAccuracy);
			}
			sleep(1);
		}
		LocationStop();
	}
	else
	{

		dispatch_queue_t main_q = dispatch_get_main_queue();

		dispatch_async(dispatch_get_main_queue(), ^{
		  startup();
		});

		// startup();
		dispatch_async(dispatch_get_main_queue(), ^{
		  main_loop();
		});
		// dispatch_main();
		start_run_loop();

		printf("EXITING!!\n");
		printf("EXITING!!\n");
		printf("EXITING!!\n");
		printf("EXITING!!\n");
		printf("EXITING!!\n");
		exit(0);
	}
	// for

	//  for (int i = 1; i < 10; i++)
	//    {
	//        /* Add some work to the main queue. */
	//        dispatch_async(main_q, ^{ printf("Hello !\n"); });
	//    }

	//    /* Add a last item to the main queue. */
	//    dispatch_async(main_q, ^{ printf("Goodbye!\n"); });

	//    std::thread foo(dispatch_thread);
	//    // dispatch_main();

	// foo.join();

	//    for(int i = 0; i < 1000; ++i)
	//    {
	//    	printf("...\n");
	//    	sleep(1);
	//    }
	// printf("done\n");
	// exit(0);
	// void* object = objc_create(1212, "foo");

	for(int i = 0; i < 1000; ++i)
	{
		sleep(1);
		// objc_fuzz(object, 1);
	}
	// objc_fuzz(object, 2);
	// objc_fuzz(object, 10);
	// objc_fuzz(object, 200);

	// objc_delete(object);

	write_it(stdout);
	// write_it_path("output.
}
