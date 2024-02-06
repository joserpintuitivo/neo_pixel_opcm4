// SPDX-FileCopyrightText: 2018 Frank Hunleth, Mark Sebald
//
// SPDX-License-Identifier: Apache-2.0

#include "rgb_nif.h"
#include <linux/spi/spidev.h>
#include <sys/types.h>
#include <inttypes.h>

#ifndef _IOC_SIZE_BITS
// Include <asm/ioctl.h> manually on platforms that don't include it
// from <sys/ioctl.h>.
#include <asm/ioctl.h>
#endif

