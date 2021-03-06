/*
 * flash - driver for FLASH ROM
 *
 * Copyright (c) 2009 Openmoko Inc.
 *
 * Authors   Christopher Hall <hsw@openmoko.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#if  !defined(_FLASH_H_)
#define _FLASH_H_ 1

#include <stdbool.h>
#include <inttypes.h>

enum {
	// basic FLASH parameters
	FLASH_PageSize = 256,                 // maximum bytes to program in one write
	FLASH_SectorSize = 4096,
	FLASH_TotalBytes = 65536,
	FLASH_TotalSectore = FLASH_TotalBytes / FLASH_SectorSize,

	// addresses of known items
	FLASH_SerialNumberAddress   = 0x1fe0, // just ASCII characters (0x00 or 0xff padded)
	FLASH_SerialNumberSize      = 32,

	FLASH_RevisionNumberAddress = 0x02f0, // 1st 4 bytes (uint32_t) used as simple number
	FLASH_RevisionNumberSize    = 16,
};

void FLASH_initialise(void);

// this is the default case
void FLASH_SelectInternal(void);

// allow access to test jig flash
// only for production testing
void FLASH_SelectExternal(void);

// must call before any write/erase
// it is only active for one command
bool FLASH_WriteEnable(void);

bool FLASH_read(void *buffer, size_t size, uint32_t ROMAddress);
bool FLASH_write(const void *buffer, size_t size, uint32_t ROMAddress);
bool FLASH_verify(const uint8_t *buffer, size_t size, uint32_t ROMAddress);
bool FLASH_SectorErase(uint32_t ROMAddress);
bool FLASH_ChipErase(void);

#endif
