#include <Timer.h>
#include "Slave.h"

module SlaveC {
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli> as Timer0;
    uses interface Packet;
    uses interface AMSend;
    uses interface SplitControl as AMControl;
}

implementation {
    bool busy = FALSE;
    message_t pkt;

    event void Boot.booted() {
        call AMControl.start();
    }

    event void Timer0.fired() {
        if (!busy) {
            SlaveMsg *spkt = (SlaveMsg *)(call Packet.getPayload(&pkt, sizeof(SlaveMsg)));
            spkt->nodeid = TOS_NODE_ID;
            if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(SlaveMsg)) == SUCCESS)
                busy = TRUE;
        }
    }

    event void AMControl.startDone(error_t err) {
        if (err == SUCCESS) {
            call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
            call Leds.set(TOS_NODE_ID);
        }
        else {
            call AMControl.start();
        }
    }
    event void AMControl.stopDone(error_t err) {}

    event void AMSend.sendDone(message_t *msg, error_t err) {
        if (&pkt == msg) {
            busy = FALSE;
        }
    }
}
