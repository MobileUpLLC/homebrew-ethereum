require 'formula'

class Ethereum < Formula
  version '1.4.4'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 19
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'd44e2a7f572bbe14051ea3336032910d48a41eac1d9d47f7d898c4a918e5f7cb' => :yosemite
    sha256 '3ee42d8d35dc5e66d3e0ff2cd7655d408da97d5a29556b30e2be59c7604b9b44' => :el_capitan
  end

  devel do
    bottle do
      revision 194
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '9fa7296a424cc4f7601db2aadfdf5ef7c145451d34fac8a36314c3cc53f9f961' => :yosemite
      sha256 'ace4a4cfaf0a30234ad3e3a8a06c75f38824c352697290d4776176638aaff47e' => :el_capitan
    end

    version '1.5.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
