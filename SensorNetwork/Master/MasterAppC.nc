#include <Timer.h>
#include "Master.h"

configuration MasterAppC {}

implementation {
    components MainC;
    components LedsC;
    components MasterC as App;
    components new TimerMilliC() as Timer0;
    components ActiveMessageC;
    components new AMReceiverC(AM_BLINKTORADIO);
    App.Boot -> MainC;
    App.Leds -> LedsC;
    App.Timer0 -> Timer0;
    App.Packet -> AMReceiverC;
    App.AMControl -> ActiveMessageC;
    App.Receive -> AMReceiverC;
}
