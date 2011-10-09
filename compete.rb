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

  class Compete < ActiveRecord::Base
    belongs_to :player
    belongs_to :game
    belongs_to :map_vote, :class_name => "Map"

    # Ready flag is stored in the Compete class although it will not
    # be saved in the database.
    attr_accessor :ready

    def to_s
      "3" + "#{nick} (#{player.authname}) :: Équipe #{ team == 1 ? "rouge" : "bleue" } :: #{$classes[gclass]}#{ map_vote.nil? ? "" : "a voté pour #{map_vote.name}" }"
    end

    def to_s_verbose
      "3" + "dans l'équipe #{ team == 1 ? "rouge" : "bleue" } en tant que #{ $classes[gclass] } sur le serveur #{game.server.to_s_pw}"
    end
  end

end

