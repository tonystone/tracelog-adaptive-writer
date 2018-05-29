#
#   Vagrantfile
#
#   Copyright 2016 Tony Stone
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   Created by Tony Stone on 4/29/16.
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'getoptlong'

#
# Default build information (if no parameters are passed)
#
TYPE_DEFAULT='RELEASE'
VERSION_DEFAULT='4.0'
SNAPSHOT_DEFAULT=nil
PLATFORM_PROVIDER_DEFAULT='ubuntu'
PLATFORM_VERSION_DEFAULT='14.04'

build=nil
swift_version=nil
platform_version=nil

options = GetoptLong.new(
    [ '--swift-release',    GetoptLong::REQUIRED_ARGUMENT ],
    [ '--platform-version', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--build',            GetoptLong::REQUIRED_ARGUMENT ],
)
options.quiet = true

begin
  options.each do |option, value|
    if    option == '--swift-release'    then swift_version=value
    elsif option == '--platform-version' then platform_version=value
    elsif option == '--build'            then build=value
    end
  end
rescue GetoptLong::InvalidOption
  pass
end

begin
  build_info = ParameterParser.parse(build, swift_version, platform_version)
rescue StandardError => e
  puts "Invalid Argument: #{e}"
  abort
end

Vagrant.configure("2") do |config|

  config.vm.box = "bento/#{build_info.platform_provider}-#{build_info.platform_version}"

  config.vm.provider "virtualbox" do |v|
    v.name = "#{File.basename(Dir.pwd)}: Swift " + "#{build_info.type}".capitalize + " #{build_info.version} Development (#{build_info.platform_provider} #{build_info.platform_version})"
    v.memory = 1024
  end

  config.vm.provision "Fix no TTY",                               :privileged => true,  type: :shell, inline: "sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  config.vm.provision "Change to non-interactive shell",          :privileged => true,  type: :shell, inline: "ex +'%s@DPkg@//DPkg' -cwq /etc/apt/apt.conf.d/70debconf && sudo dpkg-reconfigure debconf -f noninteractive -p critical"
  config.vm.provision "Update apt-get",                           :privileged => true,  type: :shell, inline: "apt-get update"
  config.vm.provision "Install clang 3.6 or greater",             :privileged => true,  type: :shell, inline: $install_clang_script
  config.vm.provision "Install common development libraries",     :privileged => true,  type: :shell, inline: "apt-get --assume-yes install libcurl3 libicu-dev libpython2.7-dev"
  config.vm.provision "Install build-tools dependencies",         :privileged => true,  type: :shell, inline: "apt-get --assume-yes install git ruby-dev"
  config.vm.provision "Install cmake 3.10",                       :privileged => true,  type: :shell, inline: "wget --progress=bar:force https://cmake.org/files/v3.10/cmake-3.10.0-Linux-x86_64.sh && sudo mkdir /opt/cmake && sudo sh cmake-3.10.0-Linux-x86_64.sh --skip-license --exclude-subdir --prefix=/opt/cmake && sudo ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake; "
  config.vm.provision "Download Swift #{build_info.source_name}", :privileged => false, type: :shell, inline: "wget --progress=bar:force '#{build_info.full_path}' && wget --progress=bar:force '#{build_info.full_path}'.sig"
  config.vm.provision "Validate Swift signatures",                :privileged => false, type: :shell, inline: "wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import - && gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift && gpg --verify '#{build_info.source_name}'.sig"
  config.vm.provision "Install Swift",                            :privileged => false, type: :shell, inline: "tar zxf '#{build_info.source_name}' && sudo chown -R vagrant:vagrant swift-*"
  config.vm.provision "Setup paths",                              :privileged => false, type: :shell, inline: "echo 'export PATH=$(pwd)/#{build_info.name}/usr/bin:\"${PATH}\"' >> .profile && echo 'export C_INCLUDE_PATH=$(pwd)/#{build_info.name}/usr/lib/swift/clang/include/' >> .profile && echo 'export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH' >> .profile"
  config.vm.provision "Clean up",                                 :privileged => false, type: :shell, inline: "rm '#{build_info.source_name}' && rm '#{build_info.source_name}'.sig"
  config.vm.provision "Display instructions",                     :privileged => false, type: :shell, inline: "echo \"Swift #{build_info.source_name} has been successfully installed on Linux\" && echo \"\" && echo \"To use it, call 'vagrant ssh' and once logged in, cd to the /vagrant directory\""
end

BEGIN {

  # No-op function
  def pass; end
  
  class BuildInfo
    attr_accessor :type, :version, :snapshot, :platform_provider, :platform_version

    def initialize(type: type = nil, version: version = nil, snapshot: snapshot = nil, platform_provider: platform_provider = nil, platform_version: platform_version = nil)

      @type = type || TYPE_DEFAULT
      @version = version || VERSION_DEFAULT
      @snapshot = snapshot || SNAPSHOT_DEFAULT
      @platform_provider = platform_provider || PLATFORM_PROVIDER_DEFAULT
      @platform_version = platform_version || PLATFORM_VERSION_DEFAULT
    end

    def full_path
      platform      = platform_provider + platform_version
      path_platform = platform.tr('.', '')
      is_branch     = version != nil

      case [type, is_branch]
        when ['RELEASE',              true]  then "https://swift.org/builds/swift-#{version}-release/#{path_platform}/swift-#{version}-RELEASE/swift-#{version}-RELEASE-#{platform}.tar.gz"
        when ['DEVELOPMENT-SNAPSHOT', false] then "https://swift.org/builds/development/#{path_platform}/swift-DEVELOPMENT-SNAPSHOT-#{snapshot}-a/swift-DEVELOPMENT-SNAPSHOT-#{snapshot}-a-#{platform}.tar.gz"
        when ['DEVELOPMENT-SNAPSHOT', true]  then "https://swift.org/builds/swift-#{version}-branch/#{path_platform}/swift-#{version}-DEVELOPMENT-SNAPSHOT-#{snapshot}-a/swift-#{version}-DEVELOPMENT-SNAPSHOT-#{snapshot}-a-#{platform}.tar.gz"
        # Note: these older releases were only 2.2 release so the hard coded swift-2.2-branch should be harmless
        when ['SNAPSHOT',             true]  then "https://swift.org/builds/swift-2.2-branch/#{path_platform}/swift-#{version}-SNAPSHOT-#{snapshot}-a/swift-#{version}-SNAPSHOT-#{snapshot}-a-#{platform}.tar.gz"
        else nil
      end
    end

    def source_name
      full_path.split('/').last
    end

    def name
      source_name.chomp('.tar.gz')
    end
  end

  class ParameterParser

    def self.parse(build, version, platform_version)

      if build != nil
        parse_build build
      elsif version || platform_version
        parse_version_platform version, platform_version
      else
        BuildInfo.new
      end
    end

    class << self
      private

      def parse_build(build)
        group = build.match(/.*swift(-(\d{1}\.\d{1}(\.\d{1})?))?(-(RELEASE|DEVELOPMENT-SNAPSHOT|SNAPSHOT))?(-(\d{4}-\d{2}-\d{2})-a)?-([a-zA-Z]+)(\d{2}\.\d{2}).*/)

        raise "Build '#{build}' is invalid or in an invalid format." unless group

        BuildInfo.new(type: group[5], version: group[2], snapshot: group[7], platform_provider: group[8], platform_version: group[9])
      end

      def parse_version_platform(swift_version, platform_version)

        if swift_version
          swift_version_group = swift_version.match(/^((\d{1}\.\d{1})(\.\d{1})?)$/)

          raise "Value '#{swift_version}' is an invalid swift-version." unless swift_version_group
	      end

        if platform_version
          platform_version_group = platform_version.match(/^(\d{2}\.\d{2})$/)

          raise "Value '#{platform_version}' is an invalid platform-version." unless platform_version_group
	      end

        BuildInfo.new(version: swift_version, platform_version: platform_version )
      end
    end
  end

  $install_clang_script = <<SCRIPT

    function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

    AVAILABLE_CLANG_VERSION=$(apt-cache policy clang | grep Candidate | cut -d ':' -f 3 | cut -d '-' -f 1)

    #
    # Clang 3.6 or greater is required for swift and REPL
    #
    if version_ge $AVAILABLE_CLANG_VERSION "3.6"; then
        echo ""
        echo "Clang version $AVAILABLE_CLANG_VERSION available, installing."
        echo ""
        apt-get --assume-yes install clang
    else
        echo ""
        echo "Clang version $AVAILABLE_CLANG_VERSION lower than required version, installing 3.6 instead."
        echo ""
        apt-get --assume-yes install clang-3.6 lldb-3.6 python-lldb-3.6
        sudo ln -s /usr/bin/clang-3.6 /usr/bin/clang
        sudo ln -s /usr/bin/clang++-3.6 /usr/bin/clang++
    fi
SCRIPT

}

