## @file
#  Platform description.
#
#
#  Copyright (c) 2019, Intel Corporation. All rights reserved.<BR>
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
#
##

[Defines]
  #
  # Set platform specific package/folder name, same as passed from PREBUILD script.
  # PLATFORM_PACKAGE would be the same as PLATFORM_NAME as well as package build folder
  # DEFINE only takes effect at R9 DSC and FDF.
  #
  DEFINE      PLATFORM_PACKAGE          = MinPlatformPkg
  DEFINE      PLATFORM_SI_PACKAGE       = CoffeelakeSiliconPkg
  DEFINE      PLATFORM_SI_BIN_PACKAGE   = CoffeelakeSiliconBinPkg
  DEFINE      PLATFORM_FSP_BIN_PACKAGE  = CoffeeLakeFspBinPkg
  DEFINE      PLATFORM_BOARD_PACKAGE    = WhiskeylakeOpenBoardPkg
  DEFINE      BOARD                     = WhiskeylakeURvp
  DEFINE      PROJECT                   = $(PLATFORM_BOARD_PACKAGE)/$(BOARD)

  #
  # Platform On/Off features are defined here
  #
  !include OpenBoardPkgConfig.dsc
  !include OpenBoardPkgPcd.dsc

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                       = $(PLATFORM_PACKAGE)
  PLATFORM_GUID                       = 84D0F5BD-0EF3-4CC0-9B09-F2D0F2AA5C5E
  PLATFORM_VERSION                    = 0.1
  DSC_SPECIFICATION                   = 0x00010005
  OUTPUT_DIRECTORY                    = Build/$(PROJECT)
  SUPPORTED_ARCHITECTURES             = IA32|X64
  BUILD_TARGETS                       = DEBUG|RELEASE
  SKUID_IDENTIFIER                    = ALL


  FLASH_DEFINITION                    = $(PROJECT)/OpenBoardPkg.fdf

  FIX_LOAD_TOP_MEMORY_ADDRESS         = 0x0
  DEFINE   TOP_MEMORY_ADDRESS         = 0x0

  #
  # Default value for OpenBoardPkg.fdf use
  #
  DEFINE BIOS_SIZE_OPTION = SIZE_70

################################################################################
#
# SKU Identification section - list of all SKU IDs supported by this
#                              Platform.
#
################################################################################
[SkuIds]
  0|DEFAULT              # The entry: 0|DEFAULT is reserved and always required.
  0x60|WhiskeylakeURvp

################################################################################
#
# Library Class section - list of all Library Classes needed by this Platform.
#
################################################################################

  !include $(PLATFORM_PACKAGE)/Include/Dsc/CoreCommonLib.dsc
  !include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiLib.dsc
  !include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeLib.dsc

[LibraryClasses.common]

  PeiLib|$(PLATFORM_PACKAGE)/Library/PeiLib/PeiLib.inf
  ReportFvLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/PeiReportFvLib/PeiReportFvLib.inf

  PciHostBridgeLib|$(PLATFORM_PACKAGE)/Pci/Library/PciHostBridgeLibSimple/PciHostBridgeLibSimple.inf
  PciSegmentInfoLib|$(PLATFORM_PACKAGE)/Pci/Library/PciSegmentInfoLibSimple/PciSegmentInfoLibSimple.inf
  PlatformBootManagerLib|$(PLATFORM_PACKAGE)/Bds/Library/DxePlatformBootManagerLib/DxePlatformBootManagerLib.inf
  I2cAccessLib|$(PLATFORM_BOARD_PACKAGE)/Library/PeiI2cAccessLib/PeiI2cAccessLib.inf
  GpioExpanderLib|$(PLATFORM_BOARD_PACKAGE)/Library/BaseGpioExpanderLib/BaseGpioExpanderLib.inf

  PlatformHookLib|$(PROJECT)/Library/BasePlatformHookLib/BasePlatformHookLib.inf

  FspWrapperHobProcessLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/PeiFspWrapperHobProcessLib/PeiFspWrapperHobProcessLib.inf
  PlatformSecLib|$(PLATFORM_BOARD_PACKAGE)/FspWrapper/Library/SecFspWrapperPlatformSecLib/SecFspWrapperPlatformSecLib.inf

  FspWrapperApiLib|IntelFsp2WrapperPkg/Library/BaseFspWrapperApiLib/BaseFspWrapperApiLib.inf
  FspWrapperApiTestLib|IntelFsp2WrapperPkg/Library/PeiFspWrapperApiTestLib/PeiFspWrapperApiTestLib.inf

  FspWrapperPlatformLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf
  SiliconPolicyUpdateLib|$(PLATFORM_BOARD_PACKAGE)/FspWrapper/Library/PeiSiliconPolicyUpdateLibFsp/PeiSiliconPolicyUpdateLibFsp.inf

  ConfigBlockLib|$(PLATFORM_SI_PACKAGE)/Library/BaseConfigBlockLib/BaseConfigBlockLib.inf
  BoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/BoardInitLibNull/BoardInitLibNull.inf
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLibNull/TestPointCheckLibNull.inf

  # Tbt
  !if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
    TbtCommonLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/PeiDxeSmmTbtCommonLib/TbtCommonLib.inf
  !endif
  DxeTbtPolicyLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/DxeTbtPolicyLib/DxeTbtPolicyLib.inf
  #
  # Silicon Init Package
  #
  !include $(PLATFORM_SI_PACKAGE)/SiPkgCommonLib.dsc
  PchHsioLib|$(PLATFORM_SI_PACKAGE)/Pch/Library/PeiDxeSmmPchHsioLib/PeiDxeSmmPchHsioLib.inf
  MmPciLib|$(PLATFORM_SI_PACKAGE)/Library/PeiDxeSmmMmPciLib/PeiDxeSmmMmPciLib.inf
  PchPmcLib|$(PLATFORM_SI_PACKAGE)/Pch/Library/PeiDxeSmmPchPmcLib/PeiDxeSmmPchPmcLib.inf

  TimerLib|$(PLATFORM_BOARD_PACKAGE)/Library/AcpiTimerLib/BaseAcpiTimerLib.inf

[LibraryClasses.IA32]
  #
  # PEI phase common
  #
  SiliconPolicyInitLib|$(PLATFORM_BOARD_PACKAGE)/FspWrapper/Library/PeiFspPolicyInitLib/PeiFspPolicyInitLib.inf
  FspWrapperPlatformLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf
  !if $(TARGET) == DEBUG
    TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/PeiTestPointCheckLib.inf
  !endif
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/PeiTestPointLib.inf
  MultiBoardInitSupportLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/PeiMultiBoardInitSupportLib.inf
  BoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/PeiMultiBoardInitSupportLib.inf
  TimerLib|$(PLATFORM_BOARD_PACKAGE)/Library/AcpiTimerLib/BaseAcpiTimerLib.inf
  HdaVerbTableLib|$(PLATFORM_BOARD_PACKAGE)/Library/PeiHdaVerbTableLib/PeiHdaVerbTableLib.inf

  # Tbt
  !if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
    PeiTbtPolicyLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/PeiTbtPolicyLib/PeiTbtPolicyLib.inf
    PeiDTbtInitLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/Private/PeiDTbtInitLib/PeiDTbtInitLib.inf
  !endif

  #
  # Silicon Init Package
  #
  !include $(PLATFORM_SI_PACKAGE)/SiPkgPeiLib.dsc
    PeiPolicyInitLib|$(PLATFORM_BOARD_PACKAGE)/Policy/Library/PeiPolicyInitLib/PeiPolicyInitLib.inf
    PeiPolicyBoardConfigLib|$(PROJECT)/Library/PeiPolicyBoardConfigLib/PeiPolicyBoardConfigLib.inf
    PeiPolicyUpdateLib|$(PLATFORM_BOARD_PACKAGE)/Policy/Library/PeiPolicyUpdateLib/PeiPolicyUpdateLib.inf
    PeiPlatformHookLib|$(PROJECT)/Library/PeiPlatformHookLib/PeiPlatformHooklib.inf
  !if $(TARGET) == DEBUG
    GpioCheckConflictLib|$(PROJECT)/Library/BaseGpioCheckConflictLib/BaseGpioCheckConflictLib.inf
  !else
    GpioCheckConflictLib|$(PROJECT)/Library/BaseGpioCheckConflictLibNull/BaseGpioCheckConflictLibNull.inf
  !endif

[LibraryClasses.IA32.SEC]
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/SecTestPointCheckLib.inf
  SecBoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/SecBoardInitLibNull/SecBoardInitLibNull.inf
  TimerLib|$(PLATFORM_BOARD_PACKAGE)/Library/AcpiTimerLib/BaseAcpiTimerLib.inf

[LibraryClasses.X64]
  #
  # DXE phase common
  #
  FspWrapperPlatformLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/DxeFspWrapperPlatformLib/DxeFspWrapperPlatformLib.inf
  !if $(TARGET) == DEBUG
    TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/DxeTestPointCheckLib.inf
  !endif
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/DxeTestPointLib.inf
  MultiBoardInitSupportLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/DxeMultiBoardInitSupportLib.inf
  BoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/DxeMultiBoardInitSupportLib.inf
  MultiBoardAcpiSupportLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/DxeMultiBoardAcpiSupportLib.inf
  BoardAcpiTableLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/DxeMultiBoardAcpiSupportLib.inf

  DxePolicyBoardConfigLib|$(PROJECT)/Library/DxePolicyBoardConfigLib/DxePolicyBoardConfigLib.inf
  DxePolicyUpdateLib|$(PLATFORM_BOARD_PACKAGE)/Policy/Library/DxePolicyUpdateLib/DxePolicyUpdateLib.inf
  #
  # Silicon Init Package
  #
  !include $(PLATFORM_SI_PACKAGE)/SiPkgDxeLib.dsc
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf

[LibraryClasses.X64.DXE_SMM_DRIVER]
  SpiFlashCommonLib|$(PLATFORM_SI_PACKAGE)/Pch/Library/SmmSpiFlashCommonLib/SmmSpiFlashCommonLib.inf
  !if $(TARGET) == DEBUG
    TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/SmmTestPointCheckLib.inf
  !endif
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/SmmTestPointLib.inf
  MultiBoardAcpiSupportLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/SmmMultiBoardAcpiSupportLib.inf
  BoardAcpiEnableLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/SmmMultiBoardAcpiSupportLib.inf
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf

[LibraryClasses.X64.DXE_RUNTIME_DRIVER]
  ResetSystemLib|$(PLATFORM_SI_PACKAGE)/Pch/Library/DxeRuntimeResetSystemLib/DxeRuntimeResetSystemLib.inf
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf

[Components.IA32]
  #
  # Common
  #
  !include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiInclude.dsc

  #
  # FSP wrapper SEC Core
  #
  UefiCpuPkg/SecCore/SecCore.inf {
    <LibraryClasses>
      PcdLib|MdePkg/Library/PeiPcdLib/PeiPcdLib.inf
  }

  #
  # Silicon
  #
  !include $(PLATFORM_SI_PACKAGE)/SiPkgPei.dsc

  #
  # Platform
  #
  $(PLATFORM_PACKAGE)/PlatformInit/ReportFv/ReportFvPei.inf
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitPei/PlatformInitPreMem.inf {
    <LibraryClasses>
      !if gBoardModuleTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardInitLib|$(PROJECT)/Library/BoardInitLib/PeiBoardInitPreMemLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardInitLib/PeiMultiBoardInitPreMemLib.inf
      !endif
      NULL|$(PROJECT)/Library/BaseFuncLib/BaseFuncLib.inf
  }
  IntelFsp2WrapperPkg/FspmWrapperPeim/FspmWrapperPeim.inf
  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPreMem.inf {
    <LibraryClasses>
      SiliconPolicyInitLib|MinPlatformPkg/PlatformInit/Library/SiliconPolicyInitLibNull/SiliconPolicyInitLibNull.inf
      SiliconPolicyUpdateLib|MinPlatformPkg/PlatformInit/Library/SiliconPolicyUpdateLibNull/SiliconPolicyUpdateLibNull.inf
  }
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitPei/PlatformInitPostMem.inf {
    <LibraryClasses>
      !if gBoardModuleTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardInitLib|$(PROJECT)/Library/BoardInitLib/PeiBoardInitPostMemLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardInitLib/PeiMultiBoardInitPostMemLib.inf
      !endif
  }
  IntelFsp2WrapperPkg/FspsWrapperPeim/FspsWrapperPeim.inf
#to do  $(PLATFORM_PACKAGE)/FspWrapper/FspWrapperPeim/FspWrapperPeim.inf
  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPostMem.inf {
    <LibraryClasses>
      SiliconPolicyInitLib|MinPlatformPkg/PlatformInit/Library/SiliconPolicyInitLibNull/SiliconPolicyInitLibNull.inf
      SiliconPolicyUpdateLib|MinPlatformPkg/PlatformInit/Library/SiliconPolicyUpdateLibNull/SiliconPolicyUpdateLibNull.inf
  }

  #
  # Security
  #

  !if gMinPlatformPkgTokenSpaceGuid.PcdTpm2Enable == TRUE
    $(PLATFORM_PACKAGE)/Tcg/Tcg2PlatformPei/Tcg2PlatformPei.inf
  !endif

  IntelSiliconPkg/Feature/VTd/IntelVTdPmrPei/IntelVTdPmrPei.inf
  IntelSiliconPkg/Feature/VTd/PlatformVTdInfoSamplePei/PlatformVTdInfoSamplePei.inf

  # Tbt
  !if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
    $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Pei/PeiTbtInit.inf
  !endif

[Components.X64]

  #
  # Common
  #
  !include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeInclude.dsc

  $(PLATFORM_SI_PACKAGE)/SystemAgent/SaInit/Dxe/SaInitDxe.inf

  UefiCpuPkg/CpuDxe/CpuDxe.inf
  MdeModulePkg/Bus/Pci/PciHostBridgeDxe/PciHostBridgeDxe.inf

  MdeModulePkg/Bus/Pci/SataControllerDxe/SataControllerDxe.inf
  MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
  MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
  MdeModulePkg/Universal/Console/GraphicsOutputDxe/GraphicsOutputDxe.inf
  MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf

  #
  # Shell
  #
  ShellPkg/Application/Shell/Shell.inf {
   <PcdsFixedAtBuild>
     gEfiShellPkgTokenSpaceGuid.PcdShellLibAutoInitialize|FALSE
   <LibraryClasses>
     NULL|ShellPkg/Library/UefiShellLevel2CommandsLib/UefiShellLevel2CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellLevel1CommandsLib/UefiShellLevel1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellLevel3CommandsLib/UefiShellLevel3CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellDriver1CommandsLib/UefiShellDriver1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellInstall1CommandsLib/UefiShellInstall1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellDebug1CommandsLib/UefiShellDebug1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellNetwork1CommandsLib/UefiShellNetwork1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellNetwork2CommandsLib/UefiShellNetwork2CommandsLib.inf
     ShellCommandLib|ShellPkg/Library/UefiShellCommandLib/UefiShellCommandLib.inf
     HandleParsingLib|ShellPkg/Library/UefiHandleParsingLib/UefiHandleParsingLib.inf
     BcfgCommandLib|ShellPkg/Library/UefiShellBcfgCommandLib/UefiShellBcfgCommandLib.inf
     ShellCEntryLib|ShellPkg/Library/UefiShellCEntryLib/UefiShellCEntryLib.inf
     ShellLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf
  }

  #
  # Silicon
  #
  !include $(PLATFORM_SI_PACKAGE)/SiPkgDxe.dsc

  # Tbt
  !if gBoardModuleTokenSpaceGuid.PcdTbtEnable == TRUE
    $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Smm/TbtSmm.inf
    $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Dxe/TbtDxe.inf
    $(PLATFORM_BOARD_PACKAGE)/Features/PciHotPlug/PciHotPlug.inf
  !endif

  #
  # Platform
  #
  $(PLATFORM_BOARD_PACKAGE)/Policy/PolicyInitDxe/PolicyInitDxe.inf{
    <LibraryClasses>
      NULL|$(PROJECT)/Library/BaseFuncLib/BaseFuncLib.inf
  }

  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyDxe/SiliconPolicyDxe.inf {
    <LibraryClasses>
      SiliconPolicyInitLib|MinPlatformPkg/PlatformInit/Library/SiliconPolicyInitLibNull/SiliconPolicyInitLibNull.inf
	  SiliconPolicyUpdateLib|MinPlatformPkg/PlatformInit/Library/SiliconPolicyUpdateLibNull/SiliconPolicyUpdateLibNull.inf
  }
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitDxe/PlatformInitDxe.inf
  IntelFsp2WrapperPkg/FspWrapperNotifyDxe/FspWrapperNotifyDxe.inf

  $(PLATFORM_PACKAGE)/FspWrapper/SaveMemoryConfig/SaveMemoryConfig.inf

  $(PLATFORM_PACKAGE)/Test/TestPointStubDxe/TestPointStubDxe.inf
  $(PLATFORM_PACKAGE)/Test/TestPointDumpApp/TestPointDumpApp.inf

  #
  # OS Boot
  #
  !if gMinPlatformPkgTokenSpaceGuid.PcdBootToShellOnly == FALSE
    $(PLATFORM_PACKAGE)/Acpi/AcpiTables/AcpiPlatform.inf
  $(PLATFORM_BOARD_PACKAGE)/Acpi/BoardAcpiDxe/BoardAcpiDxe.inf
  $(PLATFORM_PACKAGE)/Acpi/AcpiSmm/AcpiSmm.inf {
    <LibraryClasses>
      !if gBoardModuleTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardAcpiEnableLib|$(PROJECT)/Library/BoardAcpiLib/SmmBoardAcpiEnableLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardAcpiLib/SmmMultiBoardAcpiSupportLib.inf
      !endif
  }

  $(PLATFORM_PACKAGE)/Flash/SpiFvbService/SpiFvbServiceSmm.inf
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitSmm/PlatformInitSmm.inf

  UefiCpuPkg/PiSmmCpuDxeSmm/PiSmmCpuDxeSmm.inf {
    <PcdsPatchableInModule>
      gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80080046
    <LibraryClasses>
      !if $(TARGET) == DEBUG
        DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
      !endif
  }

  !endif

  #
  # Security
  #
  $(PLATFORM_PACKAGE)/Hsti/HstiIbvPlatformDxe/HstiIbvPlatformDxe.inf

  !if gMinPlatformPkgTokenSpaceGuid.PcdTpm2Enable == TRUE
    $(PLATFORM_PACKAGE)/Tcg/Tcg2PlatformDxe/Tcg2PlatformDxe.inf
  !endif

  IntelSiliconPkg/Feature/VTd/IntelVTdDxe/IntelVTdDxe.inf

  #
  # Other
  #
  $(PLATFORM_SI_BIN_PACKAGE)/Microcode/MicrocodeUpdates.inf

  !include $(PLATFORM_SI_PACKAGE)/SiPkgBuildOption.dsc
  !include OpenBoardPkgBuildOption.dsc

