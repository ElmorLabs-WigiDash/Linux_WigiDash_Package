#include <stdbool.h>
#include <stdio.h>
#include <stdint.h>
#include <errno.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <getopt.h>
#include <inttypes.h>
#include <sys/types.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>


#define MAX_CPUS_NEEDED 512

typedef struct _CPU_CORE_STRUCT{
    int threads;
    int Efficiency_Class[MAX_CPUS_NEEDED];
    int num_smallcores;
    int num_bigcores;
    int Hyperthreaded[MAX_CPUS_NEEDED];
}__attribute__((packed)) CPU_CORE_STRUCT;

extern "C" {
    void deinitialize_cpu_stats();
    bool initialize_cpu_stats();
    void get_cpu_core_struct(CPU_CORE_STRUCT* inbuf);
    void stream_freq_vid_temp(int* freqarr, int* vidarr, int* temparr);
}

int totalcores=1;

int freqarray[MAX_CPUS_NEEDED];
 int vidarray[MAX_CPUS_NEEDED];
  int temparray[MAX_CPUS_NEEDED];


extern "C" {
    //my exports
bool initialize_wigi_lib()
{
    return initialize_cpu_stats();
}

void deinitialize_wigi_lib()
{
    deinitialize_cpu_stats();
}

void xchange_data(void* send_buf, void* receive_buf, int inlen, int* outlen, int in_type, int* out_type)
{
    int* buf=(int*)(send_buf);
    if(buf[0]==1)
    {
        //send cpu struct
        CPU_CORE_STRUCT inbuf;
        get_cpu_core_struct(&inbuf);
        totalcores=inbuf.num_bigcores+inbuf.num_smallcores;
        *out_type=0;//integer 
        *outlen=(sizeof(CPU_CORE_STRUCT))/(sizeof(int));
        memcpy(receive_buf, (void*)&inbuf, sizeof(CPU_CORE_STRUCT));
    }
    else
    { //send stats
        int* buf=(int*)(receive_buf);
        stream_freq_vid_temp(freqarray, vidarray, temparray);
        int index=0;
        for(int i=0;i<totalcores;i++)
        {
            buf[index]=freqarray[i];
            index++;
            buf[index]=vidarray[i];
            index++;
            buf[index]=temparray[i];
            index++;
        }
        *out_type=0;//integer 
        *outlen=totalcores*3;
    }
    
}


}

