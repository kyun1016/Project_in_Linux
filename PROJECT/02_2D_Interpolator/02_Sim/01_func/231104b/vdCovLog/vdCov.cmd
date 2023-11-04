gui_exclusion -set_force true
gui_assert_mode -mode flat
gui_class_mode -mode hier
gui_excl_mgr_flat_list -on  0
gui_covdetail_select -id  CovDetail.1   -name   Line
verdiWindowWorkMode -win $_vdCoverage_1 -coverageAnalysis
gui_open_cov  -hier ./simv.vdb -testdir {} -test {./simv/test} -merge MergedTest -db_max_tests 10 -fsm transition
gui_set_pref_value -category {ColumnCfg} -key {covtblAssertList_Assert} -value {true}
gui_list_expand -id  CoverageTable.1   -list {covtblInstancesList} tb_top
gui_list_select -id CoverageTable.1 -list covtblInstancesList { tb_top.u_rtl_top   }
gui_list_select -id CoverageTable.1 -list covtblInstancesList { tb_top.u_rtl_top  tb_top   }
gui_list_action -id  CoverageTable.1 -list {covtblInstancesList} tb_top  -column {} 
gui_covtable_show -show  { Design Hierarchy } -id  CoverageTable.1  -test  MergedTest
gui_src_highlight_item -id CovSrc.1 -lfrom 30 -idxfrom 1 -fileIdFrom 0 -lto 39 -idxto 26 -fileIdTo 0 -selection {   m_itf.i_en      = 1;
    m_itf.i_x       = 24;
    m_itf.i_weight0 = 104;
    m_itf.i_weight1 = 235;
    m_itf.i_weight2 = 293;
    m_itf.i_weight3 = 439;
    m_itf.i_weight4 = 595;
    m_itf.i_weight5 = 662;
    m_itf.i_weight6 = 691;
    m_itf.i_weight7 = 694;} -selectionId 0 -replace 0
gui_open_source -id CovSrc.1  -active  tb_top  -activate  -matrix  Line
gui_covtable_show -show  { Design Hierarchy } -id  CoverageTable.1  -test  MergedTest
gui_src_highlight_item -id CovSrc.1 -lfrom 33 -idxfrom 4 -fileIdFrom 0 -lto 33 -idxto 19 -fileIdTo 0 -selection {m_itf.i_weight1} -selectionId 0 -replace 0
vdCovExit -noprompt
