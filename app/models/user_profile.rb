#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

class UserProfile
  attr_accessor :user
  def initialize(user)
    @user = user
  end
  
  def short_name
    @user.short_name
  end
  
  def name
    @user.name
  end
  
  def asset_string
    @user.asset_string
  end
  
  def opaque_identifier(*args)
    @user.opaque_identifier(*args)
  end
  
  TAB_PROFILE = 0
  TAB_COMMUNICATION_PREFERENCES = 1
  TAB_FILES = 2
  TAB_EPORTFOLIOS = 3
  TAB_HOME = 4
  def tabs_available(user=nil, opts={})
    unless @tabs
      @tabs = [
        { :id => TAB_HOME, :label => I18n.t('#tabs.home', "Home"), :css_class => 'home', :href => :dashboard_path, :no_args => true },
        { :id => TAB_PROFILE, :label => I18n.t('#user_profile.tabs.profile', "Profile"), :css_class => 'profile', :href => :profile_path, :no_args => true },
        { :id => TAB_COMMUNICATION_PREFERENCES, :label => I18n.t('#user_profile.tabs.notifications', "Notifications"), :css_class => 'notifications', :href => :communication_profile_path, :no_args => true },
        { :id => TAB_FILES, :label => I18n.t('#tabs.files', "Files"), :css_class => 'files', :href => :dashboard_files_path, :no_args => true }
      ]
      @tabs << { :id => TAB_EPORTFOLIOS, :label => I18n.t('#tabs.eportfolios', "ePortfolios"), :css_class => 'eportfolios', :href => :dashboard_eportfolios_path, :no_args => true } if @user.eportfolios_enabled?
      if user && opts[:root_account]
        opts[:root_account].context_external_tools.active.having_setting('user_navigation').each do |tool|
          @tabs << {
            :id => tool.asset_string,
            :label => tool.label_for(:user_navigation, opts[:language]),
            :css_class => tool.asset_string,
            :href => :user_external_tool_path,
            :args => [user.id, tool.id]
          }
        end
      end
      if user && user.fake_student?
        @tabs = @tabs.slice(0,2)
      end
    end
    @tabs
  end
end
