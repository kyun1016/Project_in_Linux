simSetSimulator "-vcssv" -exec "./simv" -args \
           "-reportstats -cm line+cond+fsm+tgl+branch -cm_hier ./02_cc/."
debImport "-dbdir" "./simv.daidir"
debLoadSimResult \
           /home/park/PROJECT/02_2D_Interpolator/03_Sim/1_func/231101a/03_fsdb/waveform.fsdb
wvCreateWindow
srcDeselectAll -win $_nTrace1
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_top"
verdiWindowBeWindow -win $_nSchema_3
schZoom {13440} {7002} {21009} {11602} -win $_nSchema3
schFit -win $_nSchema3
schCloseWindow -win $_nSchema3
wvSetCursor -win $_nWave2 50.215257
schCreateWindow -delim "." -win $_nSchema1 -scope "tb_top"
verdiWindowBeWindow -win $_nSchema_4
schCloseWindow -win $_nSchema4
debExit
