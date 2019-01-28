# Scripts for vivado tool flow
- run_np_flow.tcl : To execute vivado flow in command line
- netlist_filter.pl : To report resources used
## Example
- Vivado flow
```powershell
  PS USER> vivado.bat -mode tcl
  ****** Vivado v2018.2 (64-bit)
    **** SW Build 2258646 on Thu Jun 14 20:03:12 MDT 2018
    **** IP Build 2256618 on Thu Jun 14 22:10:49 MDT 2018
      ** Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
  Vivado% source run_np_flow.tcl
  # proc run_vivado {pName sDir tmodule {tDev xc7k70tfbv676-1} {bitgen 0}} {
  #     #Setting Variables
  #     set projectName $pName
  #     set sourceDir $sDir
  ....
  ....
  #     }
  #     close_project
  # }
  Vivado% run_vivado pname source_dir arbiter
  Command: synth_design -top arbiter -flatten rebuilt
  Starting synth_design
  Using part: xc7k70tfbv676-1
  .....
  .....
  .....
  report_drc completed successfully
  report_drc: Time (s): cpu = 00:00:07 ; elapsed = 00:00:12 . Memory (MB): peak = 1340.379 ; gain = 7.066
```
- Resource Utilization
```powershell
  PS USER> netlist_filter arbiter_netlist.v
  FDRE : 8
  LUT6 : 8
  IBUF : 7
  LUT3 : 4
  OBUF : 4
  LUT5 : 2
  LUT2 : 2
  LUT4 : 2
  LUT1 : 1
```
