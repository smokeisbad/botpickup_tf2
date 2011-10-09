# encoding: UTF-8

# Copyright (C) 2011 by Olivier Matz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Pickup

  require 'steam-condenser'

  class Server < ActiveRecord::Base

    has_and_belongs_to_many :game_variants
    has_many :games

    def update_status
      begin
        source = SourceServer.new(ip_address, port.to_i)
        source.init
        self.number_of_players = source.server_info['number_of_players']
        self.available = 1
      rescue
        puts self.to_s + " indisponible."
        self.number_of_players = 0
        self.available = 0
      end
      save
    end

    def set_map(map)
      begin
        source = SourceServer.new(ip_address, port.to_i)
        source.rcon_auth(rcon_password)
        source.init
        source.rcon_exec("changelevel " + map)
      rescue
        puts $!.to_s
        puts $!.backtrace
      end
    end

    def load_cfg(cfg)
      begin
        source = SourceServer.new(ip_address, port.to_i)
        source.rcon_auth(rcon_password)
        source.init
        source.rcon_exec("exec " + cfg)
      rescue
        puts $!.to_s
        puts $!.backtrace
      end
    end

    def lock
      self.llock = 1
      save
    end

    def unlock
      self.llock = 0
      save
    end

    def locked?
      llock == 1
    end

    def available?
      available == 1
    end

    def active?
      active == 1
    end

    def to_s
      "#{ip_address}:#{port}"
    end

    def to_s_pw
      if password.nil?
        to_s
      else
        to_s + " (mot de passe : #{password})"
      end
    end

    def to_s_verbose
      "3" + "#{ip_address}:#{port} (#{s.available? ? "#{s.number_of_players} joueurs en ce moment" : "indisponible" })"
    end

  end

end
