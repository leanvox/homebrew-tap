class Lvox < Formula
  desc "Leanvox CLI — lean voice API from your terminal"
  homepage "https://leanvox.com"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.0/lvox-aarch64-apple-darwin.tar.xz"
      sha256 "9fa6679c8ea7274b0b219a8c330d5c3643f86e3bc4c6993bbbdfb195f03b5f5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.0/lvox-x86_64-apple-darwin.tar.xz"
      sha256 "4cb76fd56f34bcae3a92191f18090d4badb0aabc2e407ddfec8568ca71c4c285"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.0/lvox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "48ab2790690b680b1ac7b1fb8d193db8905d3525c63f6346e6846f7b8a986345"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.5.0/lvox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a3504490b63a2e311d70e8b6a3d163d58d422321c1adc7d3911e6a2b5b4ac04"
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
