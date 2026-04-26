#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------
require 'pp'

class ScenarioGenerater
  def initialize(name, ram_words, ram_word_bits)
    @name            = name
    @axi4_data_width = 32
    @axi4_data_size  = (Math.log2(@axi4_data_width)).to_i
    @ram_word_bits   = ram_word_bits
    @ram_word_bytes  = @ram_word_bits/8
    @ram_words       = ram_words
    @no              = 0
    @id              = 10
    @data            = (1..@ram_words*@ram_word_bytes).collect{rand(256)}
  end

  def  gen_write(io, address, data, resp)
    io.print "  - WRITE : \n"
    io.print "      ADDR : ", sprintf("0x%08X", address), "\n"
    io.print "      ID   : ", @id, "\n"
    io.print "      DATA : [", (data.collect{ |d| sprintf("0x%02X",d)}).join(',') ,"]\n" if (data.length > 0)
    io.print "      RESP : ", resp, "\n"
  end
  def  gen_read(io, address, data, resp)
    io.print "  - READ : \n"
    io.print "      ADDR : ", sprintf("0x%08X", address), "\n"
    io.print "      ID   : ", @id, "\n"
    io.print "      DATA : [", (data.collect{ |d| sprintf("0x%02X",d)}).join(',') ,"]\n"
    io.print "      RESP : ", resp, "\n"
  end

  def gen_strb_null_test(io)
    address=0x00000010
    data_size= (@axi4_data_width > 32)? 8 : 4;
    data=@data.slice(address, data_size)
    resp="OKAY"
    @no += 1
    io.print "---\n"
    io.print "- - [MARCHAL]\n"
    io.print "  - SAY : \"", @name, " " , @no, "\"\n"
    io.print "- - [MASTER] \n"
    gen_write(io, address, data, resp)
    gen_read( io, address, data, resp)
    gen_write(io, address, []  , resp)
    gen_read( io, address, data, resp)
  end

  def generate(file_name)
    io = open(file_name, "w")
    address = @data.length
    word_bytes = @axi4_data_width/8
    @no += 1
    io.print "---\n"
    io.print "- - [MARCHAL]\n"
    io.print "  - SAY : \"", @name, " " , @no, "\"\n"
    io.print "- - [MASTER] \n"
    while address > 0
        if (address % word_bytes > 0)
            data_len = rand(1..(address % word_bytes))
        else
            data_len = rand(1..word_bytes)
        end
        address  = address - data_len
        gen_write(io, address, @data[address..address+data_len-1], "OKAY")
    end
    io.print "---\n"
    io.print "- - [MASTER] \n"
    address = @data.length
    while address > 0 
        if (address % word_bytes > 0)
            data_len = rand(1..(address % word_bytes))
        else
            data_len = rand(1..word_bytes)
        end
        address  = address - data_len
        gen_read( io, address, @data[address..address+data_len-1], "OKAY")
    end
    gen_strb_null_test(io)
    io.print "---\n"
    io.close
  end
end

gen = ScenarioGenerater.new("AXI4 DPRAM 64x32 TEST", 64, 32)
gen.generate("axi_dpram_64x32_test_bench.snr")
