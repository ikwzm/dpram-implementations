-----------------------------------------------------------------------------------
--!     @file    dpram_64x32_ramd64e.vhd
--!     @brief   Dual Port RAM (64words x 32bit) 
--!     @version 1.0.0
--!     @date    2026/4/26
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
library ieee;
use     ieee.std_logic_1164.all;
-----------------------------------------------------------------------------------
--! @brief   DPRAM :
-----------------------------------------------------------------------------------
entity  DPRAM_64x32_RAMD64E is
    port (
        WCLK        : in  std_logic;
        WE          : in  std_logic_vector(31 downto 0);
        WADDR       : in  std_logic_vector( 5 downto 0);
        WDATA       : in  std_logic_vector(31 downto 0);
        RADDR       : in  std_logic_vector( 5 downto 0);
        RDATA       : out std_logic_vector(31 downto 0)
    );
end     DPRAM_64x32_RAMD64E;
-----------------------------------------------------------------------------------
-- アーキテクチャ本体
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library unisim;
use     unisim.VCOMPONENTS.RAMD64E;
architecture MODEL of DPRAM_64x32_RAMD64E is
  -- component RAMD64E
  --   generic (
  --      INIT : bit_vector(63 downto 0) := X"0000000000000000";
  --      IS_CLK_INVERTED : bit := '0';
  --      RAM_ADDRESS_MASK : std_logic_vector (1 downto 0) := "00";
  --      RAM_ADDRESS_SPACE : std_logic_vector (1 downto 0) := "00"
  --   );
  --   port (
  --      O : out std_ulogic;
  --      CLK : in std_ulogic;
  --      I : in std_ulogic;
  --      RADR0 : in std_ulogic;
  --      RADR1 : in std_ulogic;
  --      RADR2 : in std_ulogic;
  --      RADR3 : in std_ulogic;
  --      RADR4 : in std_ulogic;
  --      RADR5 : in std_ulogic;
  --      WADR0 : in std_ulogic;
  --      WADR1 : in std_ulogic;
  --      WADR2 : in std_ulogic;
  --      WADR3 : in std_ulogic;
  --      WADR4 : in std_ulogic;
  --      WADR5 : in std_ulogic;
  --      WADR6 : in std_ulogic;
  --      WADR7 : in std_ulogic;
  --      WE : in std_ulogic
  --   );
  -- end component;
  constant sig_0 : std_logic := '0';
begin
    U: for i in 0 to 31 generate
        RAM: RAMD64E port map(
            O     => RDATA(i)  , -- Out :
            CLK   => WCLK      , -- In  :
            I     => WDATA(i)  , -- In  :
            RADR0 => RADDR(0)  , -- In  :
            RADR1 => RADDR(1)  , -- In  :
            RADR2 => RADDR(2)  , -- In  :
            RADR3 => RADDR(3)  , -- In  :
            RADR4 => RADDR(4)  , -- In  :
            RADR5 => RADDR(5)  , -- In  :
            WADR0 => WADDR(0)  , -- In  :
            WADR1 => WADDR(1)  , -- In  :
            WADR2 => WADDR(2)  , -- In  :
            WADR3 => WADDR(3)  , -- In  :
            WADR4 => WADDR(4)  , -- In  :
            WADR5 => WADDR(5)  , -- In  :
            WADR6 => sig_0     , -- In  :
            WADR7 => sig_0     , -- In  :
            WE    => WE(i)       -- In  :
         );
    end generate;
end MODEL;
