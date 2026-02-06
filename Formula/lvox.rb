class Lvox < Formula
  desc "Leanvox CLI — lean voice API from your terminal"
  homepage "https://leanvox.com"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.2/lvox-aarch64-apple-darwin.tar.xz"
      sha256 "d7f2acfeb7bab6fdefee8086aad8d566168ffc6d7e88e3d452ecae3e4a1d7ef8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.2/lvox-x86_64-apple-darwin.tar.xz"
      sha256 "6c2cdc497120b8d65097bcf3bba2ac6d42e173947dfaf5724796157573e523ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.2/lvox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5b3f339ff46def310438a088c5feb112519461ea5208ca4fef142eae83e0468"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.2/lvox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dcc2e463b99e4540289fe5b994adebb172ba495a1e2ca71b4348946f670eff25"
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
