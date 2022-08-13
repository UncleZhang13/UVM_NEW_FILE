module thread();

  initial begin
  
    fork
      // Thread 1
      begin
        #6;
        $display("******@%0t, fork join sub thread 1 begin", $time);
      end
  
      // Thread 2
      begin
        #5;
        $display("******@%0t, fork join sub thread 2 begin", $time);
      end
    join
    $display("******@%0t, fork join father thread begin", $time);
  
    #20;
    fork
      // Thread 1
      begin
        #6;
        $display("******@%0t, fork join_any sub thread 1 begin", $time);
      end
  
      // Thread 2
      begin
        #5;
        $display("******@%0t, fork join_any sub thread 2 begin", $time);
      end
    join_any
    $display("******@%0t, fork join_any father thread begin", $time);
  
    #20;
    fork
      // Thread 1
      begin
        #6;
        $display("******@%0t, fork join_none sub thread 1 begin", $time);
      end
  
      // Thread 2
      begin
        #5;
        $display("******@%0t, fork join_none sub thread 2 begin", $time);
      end
    join_none
    $display("******@%0t, fork join_none father thread begin", $time);
    
      # 20;
      $finish;
  end

  
  endmodule 
  