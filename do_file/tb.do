#退出仿真
quit -sim

#新建work库
vlib work

#将work库映射到当前工作目录
vmap work work

#编译文件
# vlog -sv "../BOOK_source/chp10/lec3/*.sv"
# vlog -sv "../EXAM/lab1/factory_mechanism_ref.sv"
# vlog -sv "../tb.sv"


#打开仿真
vsim -novopt -classdebug -sv_seed random work.factory_override
# vsim -novopt -classdebug +UVM_TESTNAME=object_create work.factory_mechanism_ref
# vsim -novopt -classdebug work.thread

#保存数据
# log -r /*   

#运行仿真
# run 0
run -all
 