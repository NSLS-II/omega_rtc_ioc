#!../../bin/linux-x86_64/omegaCNi32

## You may have to change omegaCNi32 to something else
## everywhere it appears in this file

<xf31id1-ioc1-netsetup.cmd

#epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST","NO")
#epicsEnvSet("EPICS_CA_ADDR_LIST","10.66.210.255")
#epicsEnvSet("EPICS_CA_ADDR_LIST","192.168.127.255")

epicsEnvSet("TOP","/epics/iocs/omega_rtc_ioc")
epicsEnvSet("EPICS_BASE","/usr/lib/epics")

# IOC-specific variables
epicsEnvSet("SYS","Test-CT")
epicsEnvSet("IOC_PREFIX","$(SYS){IOC:RTC}")

cd ${TOP}

## Register all support components
dbLoadDatabase("dbd/omegaCNi32.dbd",0,0)
omegaCNi32_registerRecordDeviceDriver(pdbbase) 

## Streamdevice Protocol Path

epicsEnvSet ("STREAM_PROTOCOL_PATH", "protocols")

# Controller-specific variables
epicsEnvSet("PORT","tsrvx-px")
epicsEnvSet("DEV","{RG:T}")
epicsEnvSet("IP","xf31id1-lab3-tsrv1:4001")

drvAsynIPPortConfigure("$(PORT)", "$(IP)")

## Load record instances
dbLoadRecords("db/omegaCNi32_temp.db","Sys=$(SYS),Dev=$(DEV),Chan=,PORT=$(PORT)")
dbLoadRecords("db/asynRecord.db","P=$(SYS),R=$(DEV)Asyn,PORT=$(PORT),ADDR=0,IMAX=256,OMAX=256")

## autosave/restore machinery
save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")

set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

dbLoadRecords("$(EPICS_BASE)/db/save_restoreStatus.db","P=$(IOC_PREFIX)")
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db","IOC=$(IOC_PREFIX)")
save_restoreSet_status_prefix("$(IOC_PREFIX)")

iocInit

## more autosave/restore machinery
cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

dbl > ${TOP}/records.dbl
