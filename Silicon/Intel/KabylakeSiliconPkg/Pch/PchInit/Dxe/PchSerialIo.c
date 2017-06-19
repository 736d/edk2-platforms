/** @file
  Initializes Serial IO Controllers.

Copyright (c) 2017, Intel Corporation. All rights reserved.<BR>
This program and the accompanying materials are licensed and made available under
the terms and conditions of the BSD License that accompanies this distribution.
The full text of the license may be found at
http://opensource.org/licenses/bsd-license.php.

THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/
#include <PchInit.h>
#include <Library/PchSerialIoLib.h>


/**
  Puts all SerialIo controllers (except UARTs in debug mode) in D3
  Clears MemoryEnable for all PCI-mode controllers
**/
EFI_STATUS
ConfigureSerialIoAtBoot (
  VOID
  )
{
  PCH_SERIAL_IO_CONTROLLER Index;
  UINTN                    PciCfgBase;

  for (Index = 0; Index < PchSerialIoIndexMax; Index++) {
    if ((mPchConfigHob->SerialIo.DevMode[Index] == PchSerialIoDisabled) ||
        (mPchConfigHob->SerialIo.DevMode[Index] == PchSerialIoSkipInit) ) {
      continue;
    }
    if ((Index >= PchSerialIoIndexUart0) &&
        (mPchConfigHob->SerialIo.EnableDebugUartAfterPost) &&
        (mPchConfigHob->SerialIo.DebugUartNumber == (UINT32) (Index - PchSerialIoIndexUart0))) {
      continue;
    }
    PciCfgBase = FindSerialIoBar (Index,1);
    MmioOr32 (PciCfgBase + R_PCH_SERIAL_IO_PME_CTRL_STS, B_PCH_SERIAL_IO_PME_CTRL_STS_PWR_ST);
    MmioRead32 (PciCfgBase + R_PCH_SERIAL_IO_PME_CTRL_STS);
    if (mPchConfigHob->SerialIo.DevMode[Index] == PchSerialIoPci) {
      MmioAnd32 (PciCfgBase + PCI_COMMAND_OFFSET, (UINT32)~(EFI_PCI_COMMAND_MEMORY_SPACE | EFI_PCI_COMMAND_BUS_MASTER) );
    }
  }
  return EFI_SUCCESS;
}

