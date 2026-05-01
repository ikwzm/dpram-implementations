-----------------------------------------------------------------------------------
--!     @file    axi_dpram.vhd
--!     @brief   Dual Port RAM with AXI4 Lite I/F
--!     @version 1.1.0
--!     @date    2026/5/1
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
--! @brief   AXI_DPRAM_64x32_MODEL :
-----------------------------------------------------------------------------------
entity  AXI_DPRAM is
    -------------------------------------------------------------------------------
    -- ジェネリック変数
    -------------------------------------------------------------------------------
    generic (
        C_ADDR_WIDTH    : integer := 32;
        C_ALEN_WIDTH    : integer :=  8;
        C_ID_WIDTH      : integer :=  4;
        C_DATA_WIDTH    : integer := 32;
        RAM_ADDR_WIDTH  : integer :=  6;
        RAM_DATA_WIDTH  : integer := 32;
        RAM_NUM         : integer :=  4
    );
    port (
        ARESETn         : in    std_logic;
        ACLK            : in    std_logic;
        C_ARID          : in    std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_ARADDR        : in    std_logic_vector(C_ADDR_WIDTH  -1 downto 0);
        C_ARLEN         : in    std_logic_vector(C_ALEN_WIDTH  -1 downto 0);
        C_ARSIZE        : in    std_logic_vector(2 downto 0);
        C_ARBURST       : in    std_logic_vector(1 downto 0);
        C_ARVALID       : in    std_logic;
        C_ARREADY       : out   std_logic;
        C_RID           : out   std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_RDATA         : out   std_logic_vector(C_DATA_WIDTH  -1 downto 0);
        C_RRESP         : out   std_logic_vector(1 downto 0);
        C_RLAST         : out   std_logic;
        C_RVALID        : out   std_logic;
        C_RREADY        : in    std_logic;
        C_AWID          : in    std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_AWADDR        : in    std_logic_vector(C_ADDR_WIDTH  -1 downto 0);
        C_AWLEN         : in    std_logic_vector(C_ALEN_WIDTH  -1 downto 0);
        C_AWSIZE        : in    std_logic_vector(2 downto 0);
        C_AWBURST       : in    std_logic_vector(1 downto 0);
        C_AWVALID       : in    std_logic;
        C_AWREADY       : out   std_logic;
        C_WDATA         : in    std_logic_vector(C_DATA_WIDTH  -1 downto 0);
        C_WSTRB         : in    std_logic_vector(C_DATA_WIDTH/8-1 downto 0);
        C_WLAST         : in    std_logic;
        C_WVALID        : in    std_logic;
        C_WREADY        : out   std_logic;
        C_BID           : out   std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_BRESP         : out   std_logic_vector(1 downto 0);
        C_BVALID        : out   std_logic;
        C_BREADY        : in    std_logic
    );
end     AXI_DPRAM;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library PIPEWORK;
use     PIPEWORK.AXI4_TYPES.all;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_REGISTER_READ_INTERFACE;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_REGISTER_WRITE_INTERFACE;
architecture RTL of AXI_DPRAM is
    -------------------------------------------------------------------------------
    -- リセット信号.
    -------------------------------------------------------------------------------
    signal    RST               :  std_logic;
    constant  CLR               :  std_logic := '0';
    -------------------------------------------------------------------------------
    -- データバスのバイト数の２のべき乗値を計算する関数.
    -------------------------------------------------------------------------------
    function CALC_DATA_SIZE(BITS:integer) return integer is
        variable value : integer;
    begin
        value := 0;
        while (2**(value+3) < BITS) loop
            value := value + 1;
        end loop;
        return value;
    end function;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    constant  WORD_BITS          :  integer := RAM_DATA_WIDTH/RAM_NUM;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    ram_raddr          :  std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
    signal    ram_waddr          :  std_logic_vector(RAM_ADDR_WIDTH-1 downto 0);
    signal    ram_we             :  std_logic_vector(RAM_NUM       -1 downto 0);
    signal    ram_wdata          :  std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
    signal    ram_rdata          :  std_logic_vector(RAM_DATA_WIDTH-1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    component DPRAM
        generic (
            DATA_BITS   : integer := 32;
            ADDR_BITS   : integer :=  6;
            N           : integer :=  1
        );
        port (
            WCLK        : in  std_logic;
            WE          : in  std_logic_vector(N        -1 downto 0);
            WADDR       : in  std_logic_vector(ADDR_BITS-1 downto 0);
            WDATA       : in  std_logic_vector(DATA_BITS-1 downto 0);
            RADDR       : in  std_logic_vector(ADDR_BITS-1 downto 0);
            RDATA       : out std_logic_vector(DATA_BITS-1 downto 0)
        );
    end component;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    RST <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    -- Control Status Register AXI I/F
    -------------------------------------------------------------------------------
    AXI_IF: block
        constant  AXI4_LITE     :  integer := 1;
        type      STATE_TYPE    is (IDLE, S_ACK);
        signal    r_state       :  STATE_TYPE;
        constant  RAM_DATA_SIZE :  integer := CALC_DATA_SIZE(RAM_DATA_WIDTH);
        constant  REG_ADDR_WIDTH:  integer := RAM_ADDR_WIDTH+RAM_DATA_SIZE;
        constant  REG_DATA_WIDTH:  integer := RAM_DATA_WIDTH;
        signal    r_req         :  std_logic;
        signal    r_ack         :  std_logic;
        constant  r_err         :  std_logic := '0';
        signal    r_addr        :  std_logic_vector(REG_ADDR_WIDTH  -1 downto 0);
        signal    r_ben         :  std_logic_vector(REG_DATA_WIDTH/8-1 downto 0);
        signal    r_data        :  std_logic_vector(REG_DATA_WIDTH  -1 downto 0);
        signal    w_state       :  STATE_TYPE;
        signal    w_req         :  std_logic;
        signal    w_ack         :  std_logic;
        constant  w_err         :  std_logic := '0';
        signal    w_addr        :  std_logic_vector(REG_ADDR_WIDTH  -1 downto 0);
        signal    w_ben         :  std_logic_vector(REG_DATA_WIDTH/8-1 downto 0);
        signal    w_data        :  std_logic_vector(REG_DATA_WIDTH  -1 downto 0);
    begin
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        R: AXI4_REGISTER_READ_INTERFACE              -- 
            generic map (                            -- 
                AXI4_LITE       => AXI4_LITE       , -- 
                AXI4_ADDR_WIDTH => C_ADDR_WIDTH    , -- 
                AXI4_DATA_WIDTH => C_DATA_WIDTH    , -- 
                AXI4_ID_WIDTH   => C_ID_WIDTH      , -- 
                REGS_ADDR_WIDTH => r_addr'length   , -- 
                REGS_DATA_WIDTH => r_data'length     -- 
            )                                        -- 
            port map (                               -- 
            -----------------------------------------------------------------------
            -- Clock and Reset Signals.
            -----------------------------------------------------------------------
                CLK             => ACLK            , -- In  :
                RST             => RST             , -- In  :
                CLR             => CLR             , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Read Address Channel Signals.
            -----------------------------------------------------------------------
                ARID            => C_ARID          , -- In  :
                ARADDR          => C_ARADDR        , -- In  :
                ARLEN           => C_ARLEN         , -- In  :
                ARSIZE          => C_ARSIZE        , -- In  :
                ARBURST         => C_ARBURST       , -- In  :
                ARVALID         => C_ARVALID       , -- In  :
                ARREADY         => C_ARREADY       , -- Out :
            -----------------------------------------------------------------------
            -- AXI4 Read Data Channel Signals.
            -----------------------------------------------------------------------
                RID             => C_RID           , -- Out :
                RDATA           => C_RDATA         , -- Out :
                RRESP           => C_RRESP         , -- Out :
                RLAST           => C_RLAST         , -- Out :
                RVALID          => C_RVALID        , -- Out :
                RREADY          => C_RREADY        , -- In  :
            -----------------------------------------------------------------------
            -- Register Write Interface.
            -----------------------------------------------------------------------
                REGS_REQ        => r_req           , -- Out :
                REGS_ACK        => r_ack           , -- In  :
                REGS_ERR        => r_err           , -- In  :
                REGS_ADDR       => r_addr          , -- Out :
                REGS_BEN        => r_ben           , -- Out :
                REGS_DATA       => r_data            -- In  :
            );                                       -- 
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        W: AXI4_REGISTER_WRITE_INTERFACE             -- 
            generic map (                            -- 
                AXI4_LITE       => AXI4_LITE       , -- 
                AXI4_ADDR_WIDTH => C_ADDR_WIDTH    , -- 
                AXI4_DATA_WIDTH => C_DATA_WIDTH    , -- 
                AXI4_ID_WIDTH   => C_ID_WIDTH      , -- 
                REGS_ADDR_WIDTH => w_addr'length   , -- 
                REGS_DATA_WIDTH => w_data'length     --
            )                                        -- 
            port map (                               -- 
            ---------------------------------------------------------------------------
            -- Clock and Reset Signals.
            ---------------------------------------------------------------------------
                CLK             => ACLK            , -- In  :
                RST             => RST             , -- In  :
                CLR             => CLR             , -- In  :
            ---------------------------------------------------------------------------
            -- AXI4 Write Address Channel Signals.
            ---------------------------------------------------------------------------
                AWID            => C_AWID          , -- In  :
                AWADDR          => C_AWADDR        , -- In  :
                AWLEN           => C_AWLEN         , -- In  :
                AWSIZE          => C_AWSIZE        , -- In  :
                AWBURST         => C_AWBURST       , -- In  :
                AWVALID         => C_AWVALID       , -- In  :
                AWREADY         => C_AWREADY       , -- Out :
            ---------------------------------------------------------------------------
            -- AXI4 Write Data Channel Signals.
            ---------------------------------------------------------------------------
                WDATA           => C_WDATA         , -- In  :
                WSTRB           => C_WSTRB         , -- In  :
                WLAST           => C_WLAST         , -- In  :
                WVALID          => C_WVALID        , -- In  :
                WREADY          => C_WREADY        , -- Out :
            ---------------------------------------------------------------------------
            -- AXI4 Write Response Channel Signals.
            ---------------------------------------------------------------------------
                BID             => C_BID           , -- Out :
                BRESP           => C_BRESP         , -- Out :
                BVALID          => C_BVALID        , -- Out :
                BREADY          => C_BREADY        , -- In  :
            ---------------------------------------------------------------------------
            -- Register Write Interface.
            ---------------------------------------------------------------------------
                REGS_REQ        => w_req           , -- Out :
                REGS_ACK        => w_ack           , -- In  :
                REGS_ERR        => w_err           , -- In  :
                REGS_ADDR       => w_addr          , -- Out :
                REGS_BEN        => w_ben           , -- Out :
                REGS_DATA       => w_data            -- Out :
            );                                       -- 
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        process (ACLK, RST) begin
            if (RST = '1') then
                r_state <= IDLE;
            elsif (ACLK'event and ACLK = '1') then
                case r_state is
                    when IDLE =>
                        if (r_req = '1') then
                            r_state <= S_ACK;
                        else
                            r_state <= IDLE;
                        end if;
                    when others =>
                        r_state <= IDLE;
                end case;
            end if;
        end process;
        process (ACLK) begin
            if (ACLK'event and ACLK = '1') then
                r_data <= ram_rdata;
            end if;
        end process;
        ram_raddr <= r_addr(r_addr'high downto RAM_DATA_SIZE);
        r_ack     <= '1' when (r_state = S_ACK) else '0';
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        process (w_req, w_ben) begin
            if (w_req = '1') then
                for i in ram_we'range loop
                    ram_we(i) <= w_ben((i*WORD_BITS)/8);
                end loop;
            else
                ram_we <= (others => '0');
            end if;
        end process;
        ram_waddr <= w_addr(w_addr'high downto RAM_DATA_SIZE);
        ram_wdata <= w_data;
        w_state   <= S_ACK when (w_req = '1') else IDLE;
        w_ack     <= '1'   when (w_req = '1') else '0';
    end block;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    U: DPRAM
        generic map (
            N           => RAM_NUM       ,
            DATA_BITS   => RAM_DATA_WIDTH,
            ADDR_BITS   => RAM_ADDR_WIDTH
        )
        port map (
            WCLK        => ACLK          ,
            WE          => ram_we        ,
            WADDR       => ram_waddr     ,
            WDATA       => ram_wdata     ,
            RADDR       => ram_raddr     ,
            RDATA       => ram_rdata
        );
end RTL;
    
