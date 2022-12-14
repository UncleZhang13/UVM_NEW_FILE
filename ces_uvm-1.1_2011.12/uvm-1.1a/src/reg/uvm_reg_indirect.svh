//
// -------------------------------------------------------------
//    Copyright 2010 Synopsys, Inc.
//    Copyright 2010 Cadence Design Systems, Inc.
//    Copyright 2011 Mentor Graphics Corporation
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//

typedef class uvm_reg_indirect_ftdr_seq;

//-----------------------------------------------------------------
// CLASS: uvm_reg_indirect_data
// Indirect data access abstraction class
//
// Models the behavior of a register used to indirectly access
// a register array, indexed by a second ~address~ register.
//
// This class should not be instantiated directly.
// A type-specific class extension should be used to
// provide a factory-enabled constructor and specify the
// ~n_bits~ and coverage models.
//-----------------------------------------------------------------

class uvm_reg_indirect_data extends uvm_reg;

   protected uvm_reg m_idx;
   protected uvm_reg m_tbl[];

   // Function: new
   // Create an instance of this class
   //
   // Should not be called directly,
   // other than via super.new().
   // The value of ~n_bits~ must match the number of bits
   // in the indirect register array.
   function new(string name = "uvm_reg_indirect",
                int unsigned n_bits,
                int has_cover);
      super.new(name,n_bits,has_cover);
   endfunction: new

   virtual function void build();
   endfunction: build

   // Function: configure
   // Configure the indirect data register.
   //
   // The ~idx~ register specifies the index,
   // in the ~reg_a~ register array, of the register to access.
   // The ~idx~ must be written to first.
   // A read or write operation to this register will subsequently
   // read or write the indexed register in the register array.
   //
   // The number of bits in each register in the register array must be
   // equal to ~n_bits~ of this register.
   // 
   // See <uvm_reg::configure()> for the remaining arguments.
   function void configure (uvm_reg idx,
                            uvm_reg reg_a[],
                            uvm_reg_block blk_parent,
                            uvm_reg_file regfile_parent = null);
      super.configure(blk_parent, regfile_parent, "");
      m_idx = idx;
      m_tbl = reg_a;

      // Not testable using pre-defined sequences
      uvm_resource_db#(bit)::set({"REG::", get_full_name()},
                                 "NO_REG_TESTS", 1);

      // Add a frontdoor to each indirectly-accessed register
      // for every address map this register is in.
      foreach (m_maps[map]) begin
         add_frontdoors(map);
      end
   endfunction
   
   /*local*/ virtual function void add_map(uvm_reg_map map);
      super.add_map(map);
      add_frontdoors(map);
   endfunction
   
   
   local function void add_frontdoors(uvm_reg_map map);
      foreach (m_tbl[i]) begin
         uvm_reg_indirect_ftdr_seq fd;
         if (m_tbl[i] == null) begin
            `uvm_error(get_full_name(),
                       $sformatf("Indirect register #%0d is NULL", i));
            continue;
         end
         fd = new(m_idx, i, this);
         if (m_tbl[i].is_in_map(map))
            m_tbl[i].set_frontdoor(fd, map);
         else
            map.add_reg(m_tbl[i], -1, "RW", 1, fd);
      end
   endfunction
   
   virtual function void do_predict (uvm_reg_item      rw,
                                     uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                     uvm_reg_byte_en_t be = -1);
      if (m_idx.get() >= m_tbl.size()) begin
         `uvm_error(get_full_name(), $sformatf("Address register %s has a value (%0d) greater than the maximum indirect register array size (%0d)", m_idx.get_full_name(), m_idx.get(), m_tbl.size()));
         rw.status = UVM_NOT_OK;
         return;
      end

      //NOTE limit to 2**32 registers
      begin
         int unsigned idx = m_idx.get();
         m_tbl[idx].do_predict(rw, kind, be);
      end
   endfunction


   virtual function uvm_reg_map get_local_map(uvm_reg_map map, string caller="");
      return  m_idx.get_local_map(map,caller);
   endfunction

   //
   // Just for good measure, to catch and short-circuit non-sensical uses
   //
   virtual function void add_field  (uvm_reg_field field);
      `uvm_error(get_full_name(), "Cannot add field to an indirect data access register");
   endfunction

   virtual function void set (uvm_reg_data_t  value,
                              string          fname = "",
                              int             lineno = 0);
      `uvm_error(get_full_name(), "Cannot set() an indirect data access register");
   endfunction
   
   virtual function uvm_reg_data_t  get(string  fname = "",
                                        int     lineno = 0);
      `uvm_error(get_full_name(), "Cannot get() an indirect data access register");
      return 0;
   endfunction
   
   virtual function uvm_reg get_indirect_reg(string  fname = "",
                                        int     lineno = 0);
      int unsigned idx = m_idx.get_mirrored_value();
      return(m_tbl[idx]);
   endfunction

   virtual function bit needs_update();
      return 0;
   endfunction

   virtual task write(output uvm_status_e      status,
                      input  uvm_reg_data_t    value,
                      input  uvm_path_e        path = UVM_DEFAULT_PATH,
                      input  uvm_reg_map       map = null,
                      input  uvm_sequence_base parent = null,
                      input  int               prior = -1,
                      input  uvm_object        extension = null,
                      input  string            fname = "",
                      input  int               lineno = 0);

      if (path == UVM_DEFAULT_PATH) begin
         uvm_reg_block blk = get_parent();
         path = blk.get_default_path();
      end
      
      if (path == UVM_BACKDOOR) begin
         `uvm_warning(get_full_name(), "Cannot backdoor-write an indirect data access register. Switching to frontdoor.");
         path = UVM_FRONTDOOR;
      end
      
      write(status, value, path, map, parent, prior, extension, fname, lineno);
   endtask

   virtual task read(output uvm_status_e      status,
                     output uvm_reg_data_t    value,
                     input  uvm_path_e        path = UVM_DEFAULT_PATH,
                     input  uvm_reg_map       map = null,
                     input  uvm_sequence_base parent = null,
                     input  int               prior = -1,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0);

      if (path == UVM_DEFAULT_PATH) begin
         uvm_reg_block blk = get_parent();
         path = blk.get_default_path();
      end
      
      if (path == UVM_BACKDOOR) begin
         `uvm_warning(get_full_name(), "Cannot backdoor-read an indirect data access register. Switching to frontdoor.");
         path = UVM_FRONTDOOR;
      end
      
      read(status, value, path, map, parent, prior, extension, fname, lineno);
   endtask

   virtual task poke(output uvm_status_e      status,
                     input  uvm_reg_data_t    value,
                     input  string            kind = "",
                     input  uvm_sequence_base parent = null,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0);
      `uvm_error(get_full_name(), "Cannot poke() an indirect data access register");
      status = UVM_NOT_OK;
   endtask

   virtual task peek(output uvm_status_e      status,
                     output uvm_reg_data_t    value,
                     input  string            kind = "",
                     input  uvm_sequence_base parent = null,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0);
      `uvm_error(get_full_name(), "Cannot peek() an indirect data access register");
      status = UVM_NOT_OK;
   endtask

   virtual task update(output uvm_status_e      status,
                       input  uvm_path_e        path = UVM_DEFAULT_PATH,
                       input  uvm_reg_map       map = null,
                       input  uvm_sequence_base parent = null,
                       input  int               prior = -1,
                       input  uvm_object        extension = null,
                       input  string            fname = "",
                       input  int               lineno = 0);
      status = UVM_IS_OK;
   endtask
   
   virtual task mirror(output uvm_status_e      status,
                       input uvm_check_e        check  = UVM_NO_CHECK,
                       input uvm_path_e         path = UVM_DEFAULT_PATH,
                       input uvm_reg_map        map = null,
                       input uvm_sequence_base  parent = null,
                       input int                prior = -1,
                       input  uvm_object        extension = null,
                       input string             fname = "",
                       input int                lineno = 0);
      status = UVM_IS_OK;
   endtask
   
endclass : uvm_reg_indirect_data


class uvm_reg_indirect_ftdr_seq extends uvm_reg_frontdoor;
   local uvm_reg m_addr_reg;
   local uvm_reg m_data_reg;
   local int     m_idx;
   
   function new(uvm_reg addr_reg,
                int idx,
                uvm_reg data_reg);
      super.new("uvm_reg_indirect_ftdr_seq");
      m_addr_reg = addr_reg;
      m_idx      = idx;
      m_data_reg = data_reg;
   endfunction: new

   virtual task body();

      uvm_reg_item rw;
      
      $cast(rw,rw_info.clone());
      rw.element = m_addr_reg;
      rw.kind    = UVM_WRITE;
      rw.value[0]= m_idx;

      m_addr_reg.do_write(rw);

      if (rw.status == UVM_NOT_OK)
        return;

      $cast(rw,rw_info.clone());
      rw.element = m_data_reg;

      if (rw_info.kind == UVM_WRITE)
        m_data_reg.do_write(rw);
      else begin
        m_data_reg.do_read(rw);
        rw_info.value[0] = rw.value[0];
      end

      rw_info.status = rw.status;
   endtask

endclass
