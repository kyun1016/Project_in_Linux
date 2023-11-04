simSetSimulator "-vcssv" -exec "./simv" -args \
           "-reportstats -cm line+cond+fsm+tgl+branch -cm_hier ./02_cc/."
debImport "-dbdir" "./simv.daidir"
debLoadSimResult \
           /home/park/PROJECT/02_2D_Interpolator/03_Sim/1_func/231104b/03_fsdb/waveform.fsdb
wvCreateWindow
srcHBSelect "tb_top.u_rtl_top" -win $_nTrace1
srcHBSelect "tb_top.u_rtl_top" -win $_nTrace1
srcHBSelect "tb_top.u_rtl_top" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.u_rtl_top" -delim "."
srcHBSelect "tb_top.u_rtl_top" -win $_nTrace1
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_top.u_rtl_top"
verdiWindowBeWindow -win $_nSchema_3
schPopViewUp -win $_nSchema3
schFit -win $_nSchema3
schSelect -win $_nSchema3 -inst "u_rtl_top"
schPushViewIn -win $_nSchema3
schSelect -win $_nSchema3 -inst "u_itp"
schPushViewIn -win $_nSchema3
schSelect -win $_nSchema3 -signal "w_msb\[7:0\]"
schAddSelectedToWave -win $_nSchema3 -clipboard
wvDrop -win $_nWave2
schFit -win $_nSchema3
schDeselectAll -win $_nSchema3
schZoom {35639} {-12218} {83856} {23371} -win $_nSchema3
schSelect -win $_nSchema3 -inst \
          "linear_interpolator_2d\(@1\):Always49#Always0:29:41:Mux"
schPushViewIn -win $_nSchema3
srcSetScope -win $_nTrace1 "tb_top.u_rtl_top.u_itp" -delim "."
srcSelect -win $_nTrace1 -range {31 40 1 3 1 1}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -win $_nTrace1 -range {9 24 3 1 7 1} -backward
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvUnknownSaveResult -win $_nWave2 -clear
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 2 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvSelectSignal -win $_nWave2 {( "G1" 3 )} 
wvZoom -win $_nWave2 979.330570 1134.220510
wvZoom -win $_nWave2 1006.254392 1025.173834
wvSetCursor -win $_nWave2 1010.889021 -snap {("G1" 14)}
schFit -win $_nSchema3
schZoom {20821} {3787} {39734} {27503} -win $_nSchema3
schFit -win $_nSchema3
schZoom {38983} {184} {54144} {11442} -win $_nSchema3
schFit -win $_nSchema3
schZoom {72757} {-53853} {110283} {-21881} -win $_nSchema3
schDeselectAll -win $_nSchema3
schFit -win $_nSchema3
schPopViewUp -win $_nSchema3
schPopViewUp -win $_nSchema3
schSelect -win $_nSchema3 -inst "m_itf"
schPushViewIn -win $_nSchema3
schFit -win $_nSchema3
schPopViewUp -win $_nSchema3
schCloseWindow -win $_nSchema3
debExit
