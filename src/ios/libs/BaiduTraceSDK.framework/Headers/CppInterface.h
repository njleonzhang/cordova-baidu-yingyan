#ifndef __BaiduTraceSDK__CppInterface__
#define __BaiduTraceSDK__CppInterface__

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    void set_device_info(char*, int, char*, int, char*, int, char*, int, char*, int, char*, int, char*, int, char*, int);
    void set_gps_info(unsigned char, unsigned short, unsigned char, unsigned short, short, int, int);
    void add_custom_data(char*, int, char*, int);
    void clear_custom_data();
    void build_request_data(char* , unsigned long *, unsigned short, int);
    void build_location_data(char*, unsigned long *);
    void set_app_info(char*, int, char*, int, long long, char*, int, char*, int);
    void parse_response_data(unsigned char *, unsigned long *, unsigned char *, int);
    void set_pack_data(unsigned char, char*, int);
    void set_push_result_data(unsigned int, unsigned char);
    
#ifdef __cplusplus
}
#endif


#endif
