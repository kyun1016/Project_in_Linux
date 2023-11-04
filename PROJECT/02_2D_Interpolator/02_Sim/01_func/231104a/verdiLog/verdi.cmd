simSetSimulator "-vcssv" -exec "./simv" -args \
           "-reportstats -cm line+cond+fsm+tgl+branch -cm_hier ./02_cc/."
debImport "-dbdir" "./simv.daidir"
debLoadSimResult \
           /home/park/PROJECT/02_2D_Interpolator/03_Sim/1_func/231104a/03_fsdb/waveform.fsdb
wvCreateWindow
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_top"
schFit -win $_nSchema3
schZoom {12982} {8229} {22310} {13492} -win $_nSchema3
schFit -win $_nSchema3
schSetPreference -portName on -pinName on -instName on -localNetName on \
           -completeName on -highContrastMode on
schSetPreference -detailRTL on
simSetInteractiveFsdbFile inter.fsdb
simSetSvtbMode off
srcSetPreference -filterPowerAwareInstruments off -profileTime off
tbvSetPreference -dynamicDumpMDA 1 -dynamicDumpStruct 1 -dynamicDumpSystemCStruct \
           1 -dynamicDumpSystemCPlain 1 -dynamicDumpSystemCFIFO 1
srcSetPreference -setDefaultEditor OtherEditor
srcHBSelect "tb_top.u_rtl_top" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.u_rtl_top" -delim "."
srcHBSelect "tb_top.u_rtl_top" -win $_nTrace1
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/tb_top"
wvGetSignalSetScope -win $_nWave2 "/tb_top/m_itf"
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/m_itf/clk} \
{/tb_top/m_itf/i_en} \
{/tb_top/m_itf/i_weight0\[9:0\]} \
{/tb_top/m_itf/i_weight1\[9:0\]} \
{/tb_top/m_itf/i_weight2\[9:0\]} \
{/tb_top/m_itf/i_weight3\[9:0\]} \
{/tb_top/m_itf/i_weight4\[9:0\]} \
{/tb_top/m_itf/i_weight5\[9:0\]} \
{/tb_top/m_itf/i_weight6\[9:0\]} \
{/tb_top/m_itf/i_weight7\[9:0\]} \
{/tb_top/m_itf/i_x\[7:0\]} \
{/tb_top/m_itf/o_y\[9:0\]} \
{/tb_top/m_itf/rst_n} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 )} 
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvSetPosition -win $_nWave2 {("G1" 13)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/tb_top/m_itf/clk} \
{/tb_top/m_itf/i_en} \
{/tb_top/m_itf/i_weight0\[9:0\]} \
{/tb_top/m_itf/i_weight1\[9:0\]} \
{/tb_top/m_itf/i_weight2\[9:0\]} \
{/tb_top/m_itf/i_weight3\[9:0\]} \
{/tb_top/m_itf/i_weight4\[9:0\]} \
{/tb_top/m_itf/i_weight5\[9:0\]} \
{/tb_top/m_itf/i_weight6\[9:0\]} \
{/tb_top/m_itf/i_weight7\[9:0\]} \
{/tb_top/m_itf/i_x\[7:0\]} \
{/tb_top/m_itf/o_y\[9:0\]} \
{/tb_top/m_itf/rst_n} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 )} 
wvSetPosition -win $_nWave2 {("G1" 13)}
wvGetSignalClose -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
debExit
