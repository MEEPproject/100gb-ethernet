
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
// #include <vector>
// #include <string>
// #include <xil_sleeptimer.h>
// #include <cassert>
// #include <iostream>
// #include <fstream>
// #include <sstream>
// #include <thread>
// #include <chrono>
// #include <fcntl.h>
// #include <sys/stat.h>

#include "xparameters.h"
#include "xaxis_switch.h"
#include "xgpio.h"
#include "../../../src/ethernet_test_cmac_usplus_0_0_axi4_lite_registers.h" // this header is generated if AXI-Lite is enabled in Ethernet core
#include "fsl.h" // FSL macros: https://www.xilinx.com/support/documentation/sw_manuals/xilinx2016_4/oslib_rm.pdf#page=16

// using namespace std;

void transmitToChan(uint8_t chanDepth, bool rxCheck) {
    printf("Transmitting random data (%0X...%0X) to channel with depth %d:\n", 0, RAND_MAX, chanDepth);
    uint32_t putData = 0;
    uint32_t getData = 0;
    bool fslNrdy = true;
    bool fslErr  = true;

    if (rxCheck) {
      // if initially Rx channel should be empty
      getfslx(getData, 0, FSL_NONBLOCKING);
      fsl_isinvalid(fslNrdy);
      fsl_iserror  (fslErr);
      if (!fslNrdy) {
        printf("\nERROR: Before starting filling Tx channel Rx channel is not empty: FSL0 = %0lX, Empty = %d, Err = %d \n",
                 getData, fslNrdy, fslErr);
        exit(1);
      }
    }

    srand(1);
    for (uint8_t word = 0; word < chanDepth;                 word++)
    for (uint8_t chan = 0; chan < XPAR_MICROBLAZE_FSL_LINKS; chan++) {
      putData = rand();
      // FSL id goes to macro as literal
      if (word%2) { // transmitting TLAST in odd words (FSL 0 only is used to pass this control)
        if (chan==0)  putfslx(putData,  0, FSL_NONBLOCKING_CONTROL);
        if (chan==1)  putfslx(putData,  1, FSL_NONBLOCKING);
        if (chan==2)  putfslx(putData,  2, FSL_NONBLOCKING);
        if (chan==3)  putfslx(putData,  3, FSL_NONBLOCKING);
        if (chan==4)  putfslx(putData,  4, FSL_NONBLOCKING);
        if (chan==5)  putfslx(putData,  5, FSL_NONBLOCKING);
        if (chan==6)  putfslx(putData,  6, FSL_NONBLOCKING);
        if (chan==7)  putfslx(putData,  7, FSL_NONBLOCKING);
        if (chan==8)  putfslx(putData,  8, FSL_NONBLOCKING);
        if (chan==9)  putfslx(putData,  9, FSL_NONBLOCKING);
        if (chan==10) putfslx(putData, 10, FSL_NONBLOCKING);
        if (chan==11) putfslx(putData, 11, FSL_NONBLOCKING);
        if (chan==12) putfslx(putData, 12, FSL_NONBLOCKING);
        if (chan==13) putfslx(putData, 13, FSL_NONBLOCKING);
        if (chan==14) putfslx(putData, 14, FSL_NONBLOCKING);
        if (chan==15) putfslx(putData, 15, FSL_NONBLOCKING);
      } else {
        if (chan==0)  putfslx(putData,  0, FSL_NONBLOCKING);
        if (chan==1)  putfslx(putData,  1, FSL_NONBLOCKING_CONTROL);
        if (chan==2)  putfslx(putData,  2, FSL_NONBLOCKING_CONTROL);
        if (chan==3)  putfslx(putData,  3, FSL_NONBLOCKING_CONTROL);
        if (chan==4)  putfslx(putData,  4, FSL_NONBLOCKING_CONTROL);
        if (chan==5)  putfslx(putData,  5, FSL_NONBLOCKING_CONTROL);
        if (chan==6)  putfslx(putData,  6, FSL_NONBLOCKING_CONTROL);
        if (chan==7)  putfslx(putData,  7, FSL_NONBLOCKING_CONTROL);
        if (chan==8)  putfslx(putData,  8, FSL_NONBLOCKING_CONTROL);
        if (chan==9)  putfslx(putData,  9, FSL_NONBLOCKING_CONTROL);
        if (chan==10) putfslx(putData, 10, FSL_NONBLOCKING_CONTROL);
        if (chan==11) putfslx(putData, 11, FSL_NONBLOCKING_CONTROL);
        if (chan==12) putfslx(putData, 12, FSL_NONBLOCKING_CONTROL);
        if (chan==13) putfslx(putData, 13, FSL_NONBLOCKING_CONTROL);
        if (chan==14) putfslx(putData, 14, FSL_NONBLOCKING_CONTROL);
        if (chan==15) putfslx(putData, 15, FSL_NONBLOCKING_CONTROL);
      }
      fsl_isinvalid(fslNrdy);
      fsl_iserror  (fslErr);
      // printf("Writing word %d to FSL%d = %0lX, Full = %d, Err = %d \n", word, chan, putData, fslNrdy, fslErr);
      if (fslNrdy || fslErr) {
        printf("\nERROR: Failed write of word %d to FSL%d = %0lX, Full = %d, Err = %d \n", word, chan, putData, fslNrdy, fslErr);
        exit(1);
      }
    }
    printf("\n");
    // here Tx channel should be full
    putfslx(putData, 0, FSL_NONBLOCKING);
    fsl_isinvalid(fslNrdy);
    if (!fslNrdy) {
      printf("\nERROR: After filling Tx channel it is still not full\n");
      exit(1);
    }
}

void receiveFrChan(uint8_t chanDepth) {
    printf("Receiving random data (%0X...%0X) from channel with depth %d:\n", 0, RAND_MAX, chanDepth);
    uint32_t putData = 0;
    uint32_t getData = 0;
    bool fslNrdy = true;
    bool fslErr  = true;

    srand(1);
    for (uint8_t word = 0; word < chanDepth     ;            word++)
    for (uint8_t chan = 0; chan < XPAR_MICROBLAZE_FSL_LINKS; chan++) {
      putData = rand();
      // FSL id goes to macro as literal 
      if (word%2) { // expecting TLAST in odd words (populated to all FSLs)
        if (chan==0)  getfslx(getData,  0, FSL_NONBLOCKING_CONTROL);
        if (chan==1)  getfslx(getData,  1, FSL_NONBLOCKING_CONTROL);
        if (chan==2)  getfslx(getData,  2, FSL_NONBLOCKING_CONTROL);
        if (chan==3)  getfslx(getData,  3, FSL_NONBLOCKING_CONTROL);
        if (chan==4)  getfslx(getData,  4, FSL_NONBLOCKING_CONTROL);
        if (chan==5)  getfslx(getData,  5, FSL_NONBLOCKING_CONTROL);
        if (chan==6)  getfslx(getData,  6, FSL_NONBLOCKING_CONTROL);
        if (chan==7)  getfslx(getData,  7, FSL_NONBLOCKING_CONTROL);
        if (chan==8)  getfslx(getData,  8, FSL_NONBLOCKING_CONTROL);
        if (chan==9)  getfslx(getData,  9, FSL_NONBLOCKING_CONTROL);
        if (chan==10) getfslx(getData, 10, FSL_NONBLOCKING_CONTROL);
        if (chan==11) getfslx(getData, 11, FSL_NONBLOCKING_CONTROL);
        if (chan==12) getfslx(getData, 12, FSL_NONBLOCKING_CONTROL);
        if (chan==13) getfslx(getData, 13, FSL_NONBLOCKING_CONTROL);
        if (chan==14) getfslx(getData, 14, FSL_NONBLOCKING_CONTROL);
        if (chan==15) getfslx(getData, 15, FSL_NONBLOCKING_CONTROL);
      } else {
        if (chan==0)  getfslx(getData,  0, FSL_NONBLOCKING);
        if (chan==1)  getfslx(getData,  1, FSL_NONBLOCKING);
        if (chan==2)  getfslx(getData,  2, FSL_NONBLOCKING);
        if (chan==3)  getfslx(getData,  3, FSL_NONBLOCKING);
        if (chan==4)  getfslx(getData,  4, FSL_NONBLOCKING);
        if (chan==5)  getfslx(getData,  5, FSL_NONBLOCKING);
        if (chan==6)  getfslx(getData,  6, FSL_NONBLOCKING);
        if (chan==7)  getfslx(getData,  7, FSL_NONBLOCKING);
        if (chan==8)  getfslx(getData,  8, FSL_NONBLOCKING);
        if (chan==9)  getfslx(getData,  9, FSL_NONBLOCKING);
        if (chan==10) getfslx(getData, 10, FSL_NONBLOCKING);
        if (chan==11) getfslx(getData, 11, FSL_NONBLOCKING);
        if (chan==12) getfslx(getData, 12, FSL_NONBLOCKING);
        if (chan==13) getfslx(getData, 13, FSL_NONBLOCKING);
        if (chan==14) getfslx(getData, 14, FSL_NONBLOCKING);
        if (chan==15) getfslx(getData, 15, FSL_NONBLOCKING);
      }
      fsl_isinvalid(fslNrdy);
      fsl_iserror  (fslErr);
      // printf("Reading word %d from FSL%d = %0lX, Empty = %d, Err = %d \n", word, chan, getData, fslNrdy, fslErr);
      if (fslNrdy || fslErr || getData!=putData) {
        printf("\nERROR: Failed read of word %d from FSL%d = %0lX (expected %0lX), Empty = %d, Err = %d \n",
               word, chan, getData, putData, fslNrdy, fslErr);
        exit(1);
      }
    }
    printf("\n");
    // here Rx channel should be empty
    getfslx(getData, 0, FSL_NONBLOCKING);
    fsl_isinvalid(fslNrdy);
    fsl_iserror  (fslErr);
    if (!fslNrdy) {
      printf("\nERROR: After reading out Rx channel it is still not empty: FSL0 = %0lX, Empty = %d, Err = %d \n",
               getData, fslNrdy, fslErr);
      exit(1);
    }
}

void switch_CPU_DMAxEth_LB(bool txNrx, bool cpu2eth_dma2lb) {
  // AXIS switches control: https://www.xilinx.com/support/documentation/ip_documentation/axis_infrastructure_ip_suite/v1_1/pg085-axi4stream-infrastructure.pdf#page=27
  uint32_t* strSwitch = txNrx ? reinterpret_cast<uint32_t*>(XPAR_TX_AXIS_SWITCH_BASEADDR) :
                                reinterpret_cast<uint32_t*>(XPAR_RX_AXIS_SWITCH_BASEADDR);
  enum {SW_CTR = XAXIS_SCR_CTRL_OFFSET         / sizeof(uint32_t),
        MI_MUX = XAXIS_SCR_MI_MUX_START_OFFSET / sizeof(uint32_t)
       };

  printf("Stream switch state:\n");
  printf("Tx/Rx:%d Control = %0lX, Out0 = %0lX, Out1 = %0lX \n", txNrx, strSwitch[SW_CTR], strSwitch[MI_MUX], strSwitch[MI_MUX+1]);
  if (cpu2eth_dma2lb) {
    printf("Connecting CPU to Ethernet core, DMA to Short LB:\n");
    strSwitch[MI_MUX+0] = 1; // connect Out0(Tx:LB /Rx:CPU) to In1(Tx:DMA/Rx:Eth)
    strSwitch[MI_MUX+1] = 0; // connect Out1(Tx:Eth/Rx:DMA) to In0(Tx:CPU/Rx:LB)
  } else {
    printf("Connecting DMA to Ethernet core, CPU to Short LB\n");
    strSwitch[MI_MUX+0] = 0; // connect Out0(Tx:LB /Rx:CPU) to In0(Tx:CPU/Rx:LB)
    strSwitch[MI_MUX+1] = 1; // connect Out1(Tx:Eth/Rx:DMA) to In1(Tx:DMA/Rx:Eth)
  }
  printf("Tx/Rx:%d Control = %0lX, Out0 = %0lX, Out1 = %0lX \n", txNrx, strSwitch[SW_CTR], strSwitch[MI_MUX], strSwitch[MI_MUX+1]);
  printf("Commiting the setting\n");
  strSwitch[SW_CTR] = XAXIS_SCR_CTRL_REG_UPDATE_MASK;
  printf("Control = %0lX \n", strSwitch[SW_CTR]);
  printf("Tx/Rx:%d Control = %0lX, Out0 = %0lX, Out1 = %0lX \n", txNrx, strSwitch[SW_CTR], strSwitch[MI_MUX], strSwitch[MI_MUX+1]);
  printf("\n");
}


int main(int argc, char *argv[])
{

  //100Gb Ethernet subsystem registers: https://www.xilinx.com/support/documentation/ip_documentation/cmac_usplus/v3_1/pg203-cmac-usplus.pdf#page=177
  // uint32_t* ethCore = reinterpret_cast<uint32_t*>(XPAR_CMAC_USPLUS_0_BASEADDR);
  enum {
    GT_RESET_REG          = GT_RESET_REG_OFFSET          / sizeof(uint32_t),
    RESET_REG             = RESET_REG_OFFSET             / sizeof(uint32_t),
    CORE_VERSION_REG      = CORE_VERSION_REG_OFFSET      / sizeof(uint32_t),
    CORE_MODE_REG         = CORE_MODE_REG_OFFSET         / sizeof(uint32_t),
    SWITCH_CORE_MODE_REG  = SWITCH_CORE_MODE_REG_OFFSET  / sizeof(uint32_t),
    CONFIGURATION_TX_REG1 = CONFIGURATION_TX_REG1_OFFSET / sizeof(uint32_t),
    CONFIGURATION_RX_REG1 = CONFIGURATION_RX_REG1_OFFSET / sizeof(uint32_t),
    STAT_TX_STATUS_REG    = STAT_TX_STATUS_REG_OFFSET    / sizeof(uint32_t),
    STAT_RX_STATUS_REG    = STAT_RX_STATUS_REG_OFFSET    / sizeof(uint32_t),
    GT_LOOPBACK_REG       = GT_LOOPBACK_REG_OFFSET       / sizeof(uint32_t)
  };

  // Ethernet core control via GPIO 
  uint32_t* rxtxCtrl = reinterpret_cast<uint32_t*>(XPAR_TX_RX_CTL_STAT_BASEADDR);
  enum {
    TX_CTRL = XGPIO_DATA_OFFSET  / sizeof(uint32_t),
    RX_CTRL = XGPIO_DATA2_OFFSET / sizeof(uint32_t)
  };
  uint32_t* gtCtrl = reinterpret_cast<uint32_t*>(XPAR_GT_CTL_BASEADDR);
  enum { GT_CTRL = XGPIO_DATA_OFFSET  / sizeof(uint32_t) };

  enum {SHORT_LOOPBACK_DEPTH = 104,
        TRANSMIT_FIFO_DEPTH  = 40
       };

  // Tx/Rx memories 
  uint32_t* txMem = reinterpret_cast<uint32_t*>(XPAR_TX_MEM_CPU_S_AXI_BASEADDR);
  uint32_t* rxMem = reinterpret_cast<uint32_t*>(XPAR_RX_MEM_CPU_S_AXI_BASEADDR);
  size_t const txMemWords = (XPAR_TX_MEM_CPU_S_AXI_HIGHADDR+1 -
                             XPAR_TX_MEM_CPU_S_AXI_BASEADDR) / sizeof(uint32_t);
  size_t const rxMemWords = (XPAR_RX_MEM_CPU_S_AXI_HIGHADDR+1 -
                             XPAR_RX_MEM_CPU_S_AXI_BASEADDR) / sizeof(uint32_t);


  while (true) {

    printf("\n");
    printf("------ Ethernet Test App ------\n");
    printf("Please enter test mode:\n");
    printf("  Loopback test:                l\n");
    printf("  2-boards communication test:  c\n");
    printf("  Tx/Rx memory test:            m\n");
    printf("  DMA loopback test:            d\n");
    printf("  Finish:                       f\n");
    char choice;
    scanf("%s", &choice);
    printf("You have entered: %c\n", choice);


    switch (choice) {
      case 'l': // Loopback test

    printf("------- Running Short Loopback test -------\n");
    switch_CPU_DMAxEth_LB(true,  false); // Tx switch: CPU->LB, DMA->Eth
    switch_CPU_DMAxEth_LB(false, false); // Rx switch: LB->CPU, Eth->DMA
    sleep(1); // in seconds
    transmitToChan(SHORT_LOOPBACK_DEPTH, true);
    receiveFrChan (SHORT_LOOPBACK_DEPTH);
    printf("------- Short Loopback test PASSED -------\n\n");


    printf("------- Running Near-end Loopback test -------\n");
    switch_CPU_DMAxEth_LB(true,  true); // Tx switch: CPU->Eth, DMA->LB
    switch_CPU_DMAxEth_LB(false, true); // Rx switch: Eth->CPU, LB->DMA
    sleep(1); // in seconds

    // printf("Soft reset of Ethernet core:\n");
    // printf("GT_RESET_REG: %0lX, RESET_REG: %0lX \n", ethCore[GT_RESET_REG], ethCore[RESET_REG]);
    // ethCore[GT_RESET_REG] = GT_RESET_REG_GT_RESET_ALL_MASK;
    // ethCore[RESET_REG]    = RESET_REG_USR_RX_SERDES_RESET_MASK |
    //                         RESET_REG_USR_RX_RESET_MASK        |
    //                         RESET_REG_USR_TX_RESET_MASK;
    // printf("GT_RESET_REG: %0lX, RESET_REG: %0lX \n", ethCore[GT_RESET_REG], ethCore[RESET_REG]);
    // printf("GT_RESET_REG: %0lX, RESET_REG: %0lX \n", ethCore[GT_RESET_REG], ethCore[RESET_REG]);
    // sleep(1); // in seconds
    // printf("\n");

    // Reading status via GPIO
    printf("GT_STATUS: %0lX \n", gtCtrl[GT_CTRL]);
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
    // Reading status and other regs via AXI
    // printf("GT_RESET_REG:          %0lX \n", ethCore[GT_RESET_REG]);
    // printf("RESET_REG:             %0lX \n", ethCore[RESET_REG]);
    // printf("CORE_VERSION_REG:      %0lX \n", ethCore[CORE_VERSION_REG]);
    // printf("CORE_MODE_REG:         %0lX \n", ethCore[CORE_MODE_REG]);
    // printf("SWITCH_CORE_MODE_REG:  %0lX \n", ethCore[SWITCH_CORE_MODE_REG]);
    // printf("CONFIGURATION_TX_REG1: %0lX \n", ethCore[CONFIGURATION_TX_REG1]);
    // printf("CONFIGURATION_RX_REG1: %0lX \n", ethCore[CONFIGURATION_RX_REG1]);
    // printf("STAT_TX_STATUS_REG:    %0lX \n", ethCore[STAT_TX_STATUS_REG]);
    // printf("STAT_RX_STATUS_REG:    %0lX \n", ethCore[STAT_RX_STATUS_REG]);
    // printf("GT_LOOPBACK_REG:       %0lX \n", ethCore[GT_LOOPBACK_REG]);

    printf("Enabling Near-End PMA Loopback\n");
    // via GPIO
    gtCtrl[GT_CTRL] = 0x2222; // https://www.xilinx.com/support/documentation/user_guides/ug578-ultrascale-gty-transceivers.pdf#page=88
    // via AXI
    // printf("GT_LOOPBACK_REG: %0lX \n", ethCore[GT_LOOPBACK_REG]);
    // ethCore[GT_LOOPBACK_REG] = GT_LOOPBACK_REG_CTL_GT_LOOPBACK_MASK;
    // printf("GT_LOOPBACK_REG: %0lX \n", ethCore[GT_LOOPBACK_REG]);
    // printf("GT_LOOPBACK_REG: %0lX \n", ethCore[GT_LOOPBACK_REG]);

    printf("Ethernet core bring-up.\n");
    // https://www.xilinx.com/support/documentation/ip_documentation/cmac_usplus/v3_1/pg203-cmac-usplus.pdf#page=204
    // via GPIO
    rxtxCtrl[RX_CTRL] = CONFIGURATION_RX_REG1_CTL_RX_ENABLE_MASK;
    rxtxCtrl[TX_CTRL] = CONFIGURATION_TX_REG1_CTL_TX_SEND_RFI_MASK;
    // via AXI
    // printf("CONFIGURATION_TX(RX)_REG1: %0lX, %0lX\n", ethCore[CONFIGURATION_TX_REG1],
    //                                                   ethCore[CONFIGURATION_RX_REG1]);
    // ethCore[CONFIGURATION_RX_REG1] = CONFIGURATION_RX_REG1_CTL_RX_ENABLE_MASK;
    // ethCore[CONFIGURATION_TX_REG1] = CONFIGURATION_TX_REG1_CTL_TX_SEND_RFI_MASK;
    // printf("CONFIGURATION_TX(RX)_REG1: %0lX, %0lX\n", ethCore[CONFIGURATION_TX_REG1],
    //                                                   ethCore[CONFIGURATION_RX_REG1]);
    // printf("CONFIGURATION_TX(RX)_REG1: %0lX, %0lX\n", ethCore[CONFIGURATION_TX_REG1],
    //                                                   ethCore[CONFIGURATION_RX_REG1]);
                                               
    printf("Waiting for RX is aligned...\n");
    while(!(rxtxCtrl[RX_CTRL] & STAT_RX_STATUS_REG_STAT_RX_ALIGNED_MASK)) {
      printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
      // printf("STAT_TX(RX)_STATUS_REG: %0lX, %0lX\n", ethCore[STAT_TX_STATUS_REG],
      //                                                ethCore[STAT_RX_STATUS_REG]);
    }
    printf("RX is aligned:\n");
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
    // printf("STAT_TX(RX)_STATUS_REG: %0lX, %0lX\n", ethCore[STAT_TX_STATUS_REG],
    //                                                ethCore[STAT_RX_STATUS_REG]);

    printf("Disabling TX_SEND_RFI:\n");
    // via GPIO
    rxtxCtrl[TX_CTRL] = 0;
    // via AXI
    // ethCore[CONFIGURATION_TX_REG1] = 0;
    printf("Waiting for RFI is stopped...\n");
    while(!(rxtxCtrl[RX_CTRL] & STAT_RX_STATUS_REG_STAT_RX_ALIGNED_MASK) ||
           (rxtxCtrl[RX_CTRL] & STAT_RX_STATUS_REG_STAT_RX_REMOTE_FAULT_MASK)) {
      printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
      // printf("STAT_TX(RX)_STATUS_REG: %0lX, %0lX\n", ethCore[STAT_TX_STATUS_REG],
      //                                                ethCore[STAT_RX_STATUS_REG]);
    }
    printf("RFI is stopped:\n");
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
    // printf("STAT_TX(RX)_STATUS_REG: %0lX, %0lX\n", ethCore[STAT_TX_STATUS_REG],
    //                                                ethCore[STAT_RX_STATUS_REG]);

    transmitToChan(TRANSMIT_FIFO_DEPTH, true);

    printf("Enabling Ethernet TX:\n");
    // via GPIO
    rxtxCtrl[TX_CTRL] = CONFIGURATION_TX_REG1_CTL_TX_ENABLE_MASK;
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
    // via AXI
    // printf("CONFIGURATION_TX_REG1: %0lX \n", ethCore[CONFIGURATION_TX_REG1]);
    // ethCore[CONFIGURATION_TX_REG1] = CONFIGURATION_TX_REG1_CTL_TX_ENABLE_MASK;
    // printf("CONFIGURATION_TX_REG1: %0lX \n", ethCore[CONFIGURATION_TX_REG1]);
    // printf("CONFIGURATION_TX_REG1: %0lX \n", ethCore[CONFIGURATION_TX_REG1]);

    receiveFrChan (TRANSMIT_FIFO_DEPTH);
    
    // Disabling Tx/Rx
    // via GPIO
    rxtxCtrl[TX_CTRL] = 0;
    rxtxCtrl[RX_CTRL] = 0;
    // via AXI
    // printf("CONFIGURATION_TX_REG1: %0lX \n", ethCore[CONFIGURATION_TX_REG1]);
    // ethCore[CONFIGURATION_TX_REG1] = 0;
    // ethCore[CONFIGURATION_RX_REG1] = 0;
    // printf("CONFIGURATION_TX_REG1: %0lX \n", ethCore[CONFIGURATION_TX_REG1]);
    // printf("CONFIGURATION_TX_REG1: %0lX \n", ethCore[CONFIGURATION_TX_REG1]);

    printf("------- Near-end Loopback test PASSED -------\n\n");
    break;


      case 'c':
    printf("------- Running 2 cards communication test -------\n");
    printf("Please make sure that the app is running on the other side and confirm with 'y'...\n");
    char confirm;
    scanf("%s", &confirm);
    printf("%c\n", confirm);
    if (confirm != 'y') break;

    switch_CPU_DMAxEth_LB(true,  true); // Tx switch: CPU->Eth, DMA->LB
    switch_CPU_DMAxEth_LB(false, true); // Rx switch: Eth->CPU, LB->DMA
    sleep(1); // in seconds

    printf("GT_STATUS: %0lX \n", gtCtrl[GT_CTRL]);
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);

    printf("Enabling GT normal operation with no loopback\n");
    gtCtrl[GT_CTRL] = 0; // https://www.xilinx.com/support/documentation/user_guides/ug578-ultrascale-gty-transceivers.pdf#page=88
    printf("Ethernet core bring-up.\n");
    // https://www.xilinx.com/support/documentation/ip_documentation/cmac_usplus/v3_1/pg203-cmac-usplus.pdf#page=204
    rxtxCtrl[RX_CTRL] = CONFIGURATION_RX_REG1_CTL_RX_ENABLE_MASK;
    rxtxCtrl[TX_CTRL] = CONFIGURATION_TX_REG1_CTL_TX_SEND_RFI_MASK;

    printf("Waiting for RX is aligned and sync-up with other side...\n");
    while(!(rxtxCtrl[RX_CTRL] & STAT_RX_STATUS_REG_STAT_RX_ALIGNED_MASK) ||
          !(rxtxCtrl[RX_CTRL] & STAT_RX_STATUS_REG_STAT_RX_REMOTE_FAULT_MASK)) {
      printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
      sleep(1); // in seconds, user wait process
    }
    printf("RX is aligned and RFI is got from the other side:\n");
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);

    printf("Disabling TX_SEND_RFI:\n");
    sleep(1); // in seconds, timeout to make sure opposite side got RFI
    rxtxCtrl[TX_CTRL] = 0;

    printf("Waiting for RFI is stopped...\n");
    while(!(rxtxCtrl[RX_CTRL] & STAT_RX_STATUS_REG_STAT_RX_ALIGNED_MASK) ||
           (rxtxCtrl[RX_CTRL] & STAT_RX_STATUS_REG_STAT_RX_REMOTE_FAULT_MASK)) {
      printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
      sleep(1); // in seconds, user wait process
    }
    printf("RFI is stopped:\n");
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);

    transmitToChan(TRANSMIT_FIFO_DEPTH, false);
    printf("Enabling Ethernet TX:\n");
    rxtxCtrl[TX_CTRL] = CONFIGURATION_TX_REG1_CTL_TX_ENABLE_MASK;
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
    printf("TX_STATUS: %0lX, RX_STATUS: %0lX \n", rxtxCtrl[TX_CTRL], rxtxCtrl[RX_CTRL]);
    sleep(1); // in seconds, delay not to use blocking read in receive process
    receiveFrChan (TRANSMIT_FIFO_DEPTH);
    // Disabling Tx/Rx
    rxtxCtrl[TX_CTRL] = 0;
    rxtxCtrl[RX_CTRL] = 0;

    printf("------- 2 cards communication test PASSED -------\n\n");
    break;

      case 'm': {
        printf("------- Running Tx/Rx memory test -------\n");
        printf("Checking memories with random values from %0X to %0X \n", 0, RAND_MAX);
        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) rxMem[addr] = rand();
        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) {
          uint32_t expectVal = rand(); 
          if (txMem[addr] != expectVal) {
            printf("\nERROR: Incorret readback of word at addr %0X from Tx Mem: %0lX, expected: %0lX \n", addr, txMem[addr], expectVal);
            exit(1);
          }
        }
        for (size_t addr = 0; addr < rxMemWords; ++addr) {
          uint32_t expectVal = rand(); 
          if (rxMem[addr] != expectVal) {
            printf("\nERROR: Incorret readback of word at addr %0X from Rx Mem: %0lX, expected: %0lX \n", addr, rxMem[addr], expectVal);
            exit(1);
          }
        }
        printf("------- Tx/Rx memory test PASSED -------\n\n");
      }
      break;

      case 'd': {
        printf("------- Running DMA loopback test -------\n");
        srand(1);
        for (size_t addr = 0; addr < txMemWords; ++addr) txMem[addr] = rand();
        for (size_t addr = 0; addr < rxMemWords; ++addr) rxMem[addr] = 0;

        switch_CPU_DMAxEth_LB(true,  true);  // Tx switch: DMA->LB, CPU->Eth
        switch_CPU_DMAxEth_LB(false, false); // Rx switch: LB->CPU, Eth->DMA
        sleep(1); // in seconds

        // AXI DMA control: http://www.xilinx.com/support/documentation/ip_documentation/axi_dma/v7_1/pg021_axi_dma.pdf
        uint32_t* dmaCore = reinterpret_cast<uint32_t*>(XPAR_ETH_DMA_BASEADDR);

        receiveFrChan(SHORT_LOOPBACK_DEPTH);
        printf("------- DMA loopback test PASSED -------\n\n");
      }
      break;

      case 'f':
        printf("------- Exiting the app -------\n");
        return(0);

      default:
        printf("Please choose right option\n");
    }
  }
}
