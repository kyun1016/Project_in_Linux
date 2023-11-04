gui_exclusion -set_force true
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
gui_open_cov  -hier ./simv.vdb -testdir {} -test {./simv/test} -merge MergedTest -db_max_tests 10 -fsm transition
verdiWindowResize -win $_vdCoverage_1 "287" "30" "1376" "878"
gui_list_expand -id  CoverageTable.1   -list {covtblInstancesList} tb_top
verdiDockWidgetSetCurTab -dock widgetDock_<ExclMgr>
verdiDockWidgetSetCurTab -dock widgetDock_Message
gui_list_expand -id  CoverageTable.1   -list {covtblInstancesList} tb_top.u_rtl_top
gui_list_select -id CoverageTable.1 -list covtblInstancesList { tb_top.u_rtl_top   }
gui_list_action -id  CoverageTable.1 -list {covtblInstancesList} tb_top.u_rtl_top  -column {} 
gui_list_select -id CoverageTable.1 -list covtblInstancesList { tb_top.u_rtl_top  tb_top.u_rtl_top.u_itp   }
gui_list_action -id  CoverageTable.1 -list {covtblInstancesList} tb_top.u_rtl_top.u_itp  -column {} 
gui_covdetail_select -id  CovDetail.1   -name   Toggle
gui_covdetail_select -id  CovDetail.1   -name   FSM
gui_covdetail_select -id  CovDetail.1   -name   Condition
gui_covdetail_select -id  CovDetail.1   -name   Branch
gui_covtable_show -show  { Module List } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Module List } -id  CoverageTable.1  -test  MergedTest
gui_list_expand -id  CoverageTable.1   -list {covtblModulesList} /tb_top
gui_list_select -id CoverageTable.1 -list covtblModulesList { /tb_top/tb_top   } -type { Scope  }
gui_list_action -id  CoverageTable.1 -list {covtblModulesList} /tb_top/tb_top  -type {Scope}  -column {} 
gui_covtable_show -show  { Function Groups } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Asserts } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Statistics } -id  CoverageTable.1  -test  MergedTest
gui_covtable_show -show  { Tests } -id  CoverageTable.1  -test  MergedTest
gui_list_select -id CoverageTable.1 -list covtblTestSummaryList { ./simv/test   }
gui_list_action -id  CoverageTable.1 -list {covtblTestSummaryList} ./simv/test  -column {Started} 
vdCovExit -noprompt
