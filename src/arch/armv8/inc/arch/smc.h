/**
 * Bao, a Lightweight Static Partitioning Hypervisor
 *
 * Copyright (c) Bao Project (www.bao-project.org), 2019-
 *
 * Authors:
 *      Jose Martins <jose.martins@bao-project.org>
 *
 * Bao is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License version 2 as published by the Free
 * Software Foundation, with a special exception exempting guest code from such
 * license. See the COPYING file in the top-level directory for details.
 *
 */

#ifndef __SMC_H__
#define __SMC_H__

#include <bao.h>

#ifndef __ASSEMBLER__

struct smc_res {
    unsigned long x0;
    unsigned long x1;
    unsigned long x2;
    unsigned long x3;
};

unsigned long smc_call(unsigned long x0, unsigned long x1, unsigned long x2,
                    unsigned long x3, unsigned long x4, unsigned long x5,
                    struct smc_res *res);

#endif /* __ASSEMBLER__ */

#endif
