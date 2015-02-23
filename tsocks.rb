require 'formula'

class Tsocks < Formula
  # The original is http://tsocks.sourceforge.net/
  # This GitHub repo is a maintained fork with OSX support
  homepage 'http://github.com/aereal/osx-tsocks'
  url 'https://github.com/aereal/osx-tsocks/archive/48dd45c8d3baaf7b108a2a1fca0d1ddacb8d1435.tar.gz'
  version '48dd45c8'
  sha1 '298d6d064ad17f34cfe71d589a44c9ebd64ae894'
  depends_on 'autoconf' => :build if MacOS.xcode_version.to_f >= 4.3

  def install
    system 'autoconf', '-v'
    system './configure', *configure_args

    inreplace('tsocks') { |bin| bin.change_make_var! 'LIBDIR', lib }

    system 'make'
    system 'make', 'install'

    etc.install 'tsocks.conf.simple.example' => 'tsocks.conf' unless config_file.exist?
  end

  def configure_args
    [
      "--prefix=#{prefix}",
      "--with-conf=#{config_file}",
      '--disable-dependency-tracking',
      '--enable-debug',
    ]
  end

  def test
    puts 'Your current public ip is:'
    ohai `curl -sS ifconfig.me 2>&1`.chomp
    puts "If your correctly configured #{config_file}, this should show the ip you have trough the proxy"
    puts 'Your ip through the proxy is:'
    ohai `tsocks curl -sS ifconfig.me 2>&1`.chomp
  end

  def config_file
    etc / 'tsocks.conf'
  end
end
