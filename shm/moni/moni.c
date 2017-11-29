#include <unistd.h>
#include "eva.h"

using namespace std;

int main(int argc, char **argv){
    
    EVA_BUS_ST_p p = (EVA_BUS_ST_t *)eva_map(0);

    char  info[4096];

    do{
        eva_show( p , info);
        fprintf(stderr,"%s", info);
        usleep(100000);
    }while(1);
    
    return 0;
}
