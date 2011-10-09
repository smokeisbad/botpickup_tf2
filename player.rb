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

  class Player < ActiveRecord::Base
    has_many :games, :through => :competes
    has_many :competes

    attr_accessor :ready, :user

    def accept_terms_of_use
      self.has_accepted_terms_of_use = 1
      save
    end

    def Player.find_or_create_by_authname(authname)
      p = Player.find_by_authname(authname)
      if p.nil?
        p = Player.new
        p.authname = authname
        p.status = 0
        p.skill = "1" * $classes.size
        p.has_accepted_terms_of_use = 0
        p.save
      end
      p
    end

    def ban(n, reason)
      self.banned_until = DateTime.now.next_day(n)
      if not reason.nil? and reason.length == 0
        reason = nil
      end
      self.ban_reason = reason
      save
    end

    def unban
      unless banned_until.nil?
        self.banned_until = nil
        save
      end
    end

    def banned?
      not banned_until.nil? and banned_until > DateTime.now
    end

    def admin?
      status == 2
    end

    def class_skill(gclass)
      skill[ $classes.index(gclass) ].to_i
    end
  end

end
