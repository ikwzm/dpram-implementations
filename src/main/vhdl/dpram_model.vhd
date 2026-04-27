-----------------------------------------------------------------------------------
--!     @file    dpram_model.vhd
--!     @brief   Generic Dual Port RAM Architecture(Model)
--!     @version 1.0.0
--!     @date    2026/4/27
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2026 Ichiro Kawazome
--      All rights reserved.
--
--      Redistribution and use in source and binary forms, with or without
--      modification, are permitted provided that the following conditions
--      are met:
--
--        1. Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--        2. Redistributions in binary form must reproduce the above copyright
--           notice, this list of conditions and the following disclaimer in
--           the documentation and/or other materials provided with the
--           distribution.
--
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- アーキテクチャ本体
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture MODEL of DPRAM is
    constant  INDEX_MIN     :  integer := 0;
    constant  INDEX_MAX     :  integer := 2**ADDR_BITS-1;
    subtype   INDEX_TYPE    is integer range INDEX_MIN to INDEX_MAX;
    function  addr_to_index(ADDR: std_logic_vector) return INDEX_TYPE is
        alias     u_addr    :  std_logic_vector(ADDR'length-1 downto 0) is ADDR;
        variable  u_index   :  unsigned(u_addr'range);
    begin
        for i in u_index'range loop
            if (u_addr(i) = '1') then
                u_index(i) := '1';
            else
                u_index(i) := '0';
            end if;
        end loop;
        return to_integer(u_index);
    end function;
    subtype   DATA_TYPE     is std_logic_vector(DATA_BITS-1 downto 0);
    type      DATA_VECTOR   is array(integer range <>) of DATA_TYPE;
    signal    ram           :  DATA_VECTOR(INDEX_MIN to INDEX_MAX);
    signal    r_index       :  INDEX_TYPE;
    signal    w_index       :  INDEX_TYPE;
begin
    w_index <= addr_to_index(WADDR);
    r_index <= addr_to_index(RADDR);
    process (WCLK) begin
        if (WCLK'event and WCLK = '1') then
            for pos in DATA_TYPE'range loop
                if (WE(pos) = '1') then
                    ram(w_index)(pos) <= WDATA(pos);
                end if;
            end loop;
        end if;
    end process;
    RDATA  <= ram(r_index);
end MODEL;
