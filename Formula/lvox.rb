class Lvox < Formula
  desc "Leanvox CLI — lean voice API from your terminal"
  homepage "https://leanvox.com"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.2/lvox-aarch64-apple-darwin.tar.xz"
      sha256 "75318cce343f91963525f6352d3507d328af002ba91fefed81d825171fbfadfc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.2/lvox-x86_64-apple-darwin.tar.xz"
      sha256 "2bfc12a5cefb57e56dc6e3a4da92b632d5d87b598a88bf2b74756de4ad9fbc1c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.2/lvox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f88214dcd22540545581596d738981e8977a5f00acf833e48961b34bb916f972"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.2/lvox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1dfb45b5972e033e3f44fe1d58cba6984d686a8b564786dd01c0e4019ee88bf3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lvox" if OS.mac? && Hardware::CPU.arm?
    bin.install "lvox" if OS.mac? && Hardware::CPU.intel?
    bin.install "lvox" if OS.linux? && Hardware::CPU.arm?
    bin.install "lvox" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
