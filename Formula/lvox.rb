class Lvox < Formula
  desc "Leanvox CLI — lean voice API from your terminal"
  homepage "https://leanvox.com"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.4.0/lvox-aarch64-apple-darwin.tar.xz"
      sha256 "12fc4a9f81c9cde9fea2bf4b8b12ce4967fdde085e7991ef74324d300c54977b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.4.0/lvox-x86_64-apple-darwin.tar.xz"
      sha256 "93e7d8aa23009593e10c59cba8a7c08acc93921c2337587198824a66ab0410a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.4.0/lvox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7042302471c742467335e88f2dfc1ec46d3f1721550e1ba54bbbc610f7fc1e9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.4.0/lvox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e4ea7c253028b9f3e2b2ff03b18e1354b43524864d4f31ff3e9c074c8dc36b6"
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
