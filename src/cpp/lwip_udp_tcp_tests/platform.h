/*
 * Copyright (C) 2009 - 2021 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#ifndef __PLATFORM_H_
#define __PLATFORM_H_

#define PLATFORM_EMAC_BASEADDR        XPAR_ETHMAC_LITE_BASEADDR // setting the address of LwIP-supported EthLite core, present in the design as dummy unit
#define PLATFORM_TIMER_BASEADDR       XPAR_TMRCTR_0_BASEADDR
#define PLATFORM_TIMER_INTERRUPT_INTR XPAR_INTC_0_TMRCTR_0_VEC_ID
#define PLATFORM_TIMER_INTERRUPT_MASK (1 << XPAR_INTC_0_TMRCTR_0_VEC_ID)

void init_platform();
void cleanup_platform();
#ifdef __MICROBLAZE__
void timer_callback();
#endif
void platform_setup_timer();
void platform_enable_interrupts();
u64_t get_time_ms();
#endif
