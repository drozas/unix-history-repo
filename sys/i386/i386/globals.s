/*-
 * Copyright (c) Peter Wemm <peter@netplex.com.au>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * $Id: globals.s,v 1.6 1998/06/21 14:45:00 bde Exp $
 */

#include "opt_vm86.h"
#include "opt_user_ldt.h"

#ifndef SMP
#include <machine/asmacros.h>
#endif
#include <machine/pmap.h>

#include "assym.s"

#ifdef SMP
	/*
	 * Define layout of per-cpu address space.
	 * This is "constructed" in locore.s on the BSP and in mp_machdep.c
	 * for each AP.  DO NOT REORDER THESE WITHOUT UPDATING THE REST!
	 */
	.globl	_SMP_prvstart
	.set	_SMP_prvstart,(MPPTDI << PDRSHIFT)

	.globl	globaldata,_SMP_prvpt,_lapic,_SMP_ioapic
	.globl	_prv_CPAGE1,_prv_CPAGE2,_prv_CPAGE3,_prv_PPAGE1
	.globl	_idlestack,_idlestack_top

	.set	globaldata,_SMP_prvstart + PS_GLOBALDATA
	.set	_SMP_prvpt,_SMP_prvstart + PS_PRVPT
	.set	_lapic,_SMP_prvstart + PS_LAPIC
	.set	_idlestack,_SMP_prvstart + PS_IDLESTACK
	.set	_idlestack_top,_SMP_prvstart + PS_IDLESTACK_TOP
	.set	_prv_CPAGE1,_SMP_prvstart + PS_CPAGE1
	.set	_prv_CPAGE2,_SMP_prvstart + PS_CPAGE2
	.set	_prv_CPAGE3,_SMP_prvstart + PS_CPAGE3
	.set	_prv_PPAGE1,_SMP_prvstart + PS_PPAGE1
	.set	_SMP_ioapic,_SMP_prvstart + PS_IOAPICS
#endif

	/*
	 * Define layout of the global data.  On SMP this lives in
	 * the per-cpu address space, otherwise it's in the data segment.
	 */
#ifndef SMP
	.data
	ALIGN_DATA
globaldata:
	.space	GD_SIZEOF		/* in data segment */
#endif
	.globl	_curproc,_curpcb,_npxproc,_common_tss,_switchtime
	.set	_curproc,globaldata + GD_CURPROC
	.set	_curpcb,globaldata + GD_CURPCB
	.set	_npxproc,globaldata + GD_NPXPROC
	.set	_common_tss,globaldata + GD_COMMON_TSS
	.set	_switchtime,globaldata + GD_SWITCHTIME

#ifdef VM86
	.globl	_common_tssd,_private_tss,_my_tr
	.set	_common_tssd,globaldata + GD_COMMON_TSSD
	.set	_private_tss,globaldata + GD_PRIVATE_TSS
	.set	_my_tr,globaldata + GD_MY_TR
#endif

#ifdef USER_LDT
	.globl	_currentldt
	.set	_currentldt,globaldata + GD_CURRENTLDT
#endif

#ifdef SMP
	/*
	 * The BSP version of these get setup in locore.s and pmap.c, while
	 * the AP versions are setup in mp_machdep.c.
	 */
	.globl	_cpuid,_cpu_lockid,_other_cpus,_my_idlePTD,_ss_eflags
	.globl	_prv_CMAP1,_prv_CMAP2,_prv_CMAP3,_prv_PMAP1
	.globl	_inside_intr

	.set	_cpuid,globaldata + GD_CPUID
	.set	_cpu_lockid,globaldata + GD_CPU_LOCKID
	.set	_other_cpus,globaldata + GD_OTHER_CPUS
	.set	_my_idlePTD,globaldata + GD_MY_IDLEPTD
	.set	_ss_eflags,globaldata + GD_SS_EFLAGS
	.set	_prv_CMAP1,globaldata + GD_PRV_CMAP1
	.set	_prv_CMAP2,globaldata + GD_PRV_CMAP2
	.set	_prv_CMAP3,globaldata + GD_PRV_CMAP3
	.set	_prv_PMAP1,globaldata + GD_PRV_PMAP1
	.set	_inside_intr,globaldata + GD_INSIDE_INTR
#endif

#if defined(SMP) || defined(APIC_IO)
	.globl	lapic_eoi, lapic_svr, lapic_tpr, lapic_irr1, lapic_ver
	.globl	lapic_icr_lo,lapic_icr_hi,lapic_isr1
/*
 * Do not clutter our namespace with these unless we need them in other
 * assembler code.  The C code uses different definitions.
 */
#if 0
	.globl	lapic_id,lapic_ver,lapic_tpr,lapic_apr,lapic_ppr,lapic_eoi
	.globl	lapic_ldr,lapic_dfr,lapic_svr,lapic_isr,lapic_isr0
	.globl	lapic_isr2,lapic_isr3,lapic_isr4,lapic_isr5,lapic_isr6
	.globl	lapic_isr7,lapic_tmr,lapic_tmr0,lapic_tmr1,lapic_tmr2
	.globl	lapic_tmr3,lapic_tmr4,lapic_tmr5,lapic_tmr6,lapic_tmr7
	.globl	lapic_irr,lapic_irr0,lapic_irr1,lapic_irr2,lapic_irr3
	.globl	lapic_irr4,lapic_irr5,lapic_irr6,lapic_irr7,lapic_esr
	.globl	lapic_lvtt,lapic_pcint,lapic_lvt1
	.globl	lapic_lvt2,lapic_lvt3,lapic_ticr,lapic_tccr,lapic_tdcr
#endif
	.set	lapic_id,	_lapic + 0x020
	.set	lapic_ver,	_lapic + 0x030
	.set	lapic_tpr,	_lapic + 0x080
	.set	lapic_apr,	_lapic + 0x090
	.set	lapic_ppr,	_lapic + 0x0a0
	.set	lapic_eoi,	_lapic + 0x0b0
	.set	lapic_ldr,	_lapic + 0x0d0
	.set	lapic_dfr,	_lapic + 0x0e0
	.set	lapic_svr,	_lapic + 0x0f0
	.set	lapic_isr,	_lapic + 0x100
	.set	lapic_isr0,	_lapic + 0x100
	.set	lapic_isr1,	_lapic + 0x110
	.set	lapic_isr2,	_lapic + 0x120
	.set	lapic_isr3,	_lapic + 0x130
	.set	lapic_isr4,	_lapic + 0x140
	.set	lapic_isr5,	_lapic + 0x150
	.set	lapic_isr6,	_lapic + 0x160
	.set	lapic_isr7,	_lapic + 0x170
	.set	lapic_tmr,	_lapic + 0x180
	.set	lapic_tmr0,	_lapic + 0x180
	.set	lapic_tmr1,	_lapic + 0x190
	.set	lapic_tmr2,	_lapic + 0x1a0
	.set	lapic_tmr3,	_lapic + 0x1b0
	.set	lapic_tmr4,	_lapic + 0x1c0
	.set	lapic_tmr5,	_lapic + 0x1d0
	.set	lapic_tmr6,	_lapic + 0x1e0
	.set	lapic_tmr7,	_lapic + 0x1f0
	.set	lapic_irr,	_lapic + 0x200
	.set	lapic_irr0,	_lapic + 0x200
	.set	lapic_irr1,	_lapic + 0x210
	.set	lapic_irr2,	_lapic + 0x220
	.set	lapic_irr3,	_lapic + 0x230
	.set	lapic_irr4,	_lapic + 0x240
	.set	lapic_irr5,	_lapic + 0x250
	.set	lapic_irr6,	_lapic + 0x260
	.set	lapic_irr7,	_lapic + 0x270
	.set	lapic_esr,	_lapic + 0x280
	.set	lapic_icr_lo,	_lapic + 0x300
	.set	lapic_icr_hi,	_lapic + 0x310
	.set	lapic_lvtt,	_lapic + 0x320
	.set	lapic_pcint,	_lapic + 0x340
	.set	lapic_lvt1,	_lapic + 0x350
	.set	lapic_lvt2,	_lapic + 0x360
	.set	lapic_lvt3,	_lapic + 0x370
	.set	lapic_ticr,	_lapic + 0x380
	.set	lapic_tccr,	_lapic + 0x390
	.set	lapic_tdcr,	_lapic + 0x3e0
#endif
