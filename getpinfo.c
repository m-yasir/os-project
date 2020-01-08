#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
    printf(1, "Process scheduling statistics: \n");
    printf(1, "Slot\tPID\tState");
    struct pstate st;
    psaux($st);
    // int i
    for(int i = 0; i < NPROC; i++){
        if(st.inuse[1]) {
            printf(1, "%d\t$d\t%d\n", i, st.pid[i], st.killed[i]);
        }
    }
    exit();
}