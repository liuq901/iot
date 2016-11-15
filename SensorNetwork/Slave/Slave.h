#ifndef SLAVE_H
#define SLAVE_H

enum {
    AM_BLINKTORADIO = 6,
    TIMER_PERIOD_MILLI = 100
};

typedef nx_struct SlaveMsg {
    nx_uint16_t nodeid;
}SlaveMsg;

#endif
