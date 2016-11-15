#include <Timer.h>
#include "Master.h"

module MasterC {
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli> as Timer0;
    uses interface Packet;
    uses interface SplitControl as AMControl;
    uses interface Receive;
}

implementation {
    uint16_t counter = 0;
    message_t pkt;
    uint16_t time[10] = {0};
    bool connect[10] = {0};
    uint16_t cnt = 0;

    event void Boot.booted() {
        call AMControl.start();
    }

    event void Timer0.fired() {
        uint8_t i;
        counter++;
        for (i = 0; i < 10; i++)
        {
            if (!connect[i])
                continue;
            if (time[i] == counter || time[i] + 1 == counter || time[i] + 2 == counter)
                continue;
            connect[i] = FALSE;
            cnt--;
        }
        call Leds.set(cnt);
    }

    event void AMControl.startDone(error_t err) {
        if (err == SUCCESS) {
            call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
        }
        else {
            call AMControl.start();
        }
    }
    event void AMControl.stopDone(error_t err) {}

    event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
        if (len == sizeof(MasterMsg)) {
            MasterMsg *mpkt = (MasterMsg *)payload;
            uint16_t id = mpkt->nodeid;
            if (!connect[id])
                cnt++;
            time[id] = counter;
            connect[id] = TRUE;
        }
        return msg;
    }
}
