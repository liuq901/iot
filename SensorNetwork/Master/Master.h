#ifndef MASTER_H
#define MASTER_H

enum {
    AM_BLINKTORADIO = 6,
    TIMER_PERIOD_MILLI = 100
};

typedef nx_struct MasterMsg {
    nx_uint16_t nodeid;
}MasterMsg;

#endif
