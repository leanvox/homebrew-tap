class Lvox < Formula
  desc "Leanvox CLI — lean voice API from your terminal"
  homepage "https://leanvox.com"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/voco-labs/leanvox-mono/releases/download/v0.2.0/lvox-aarch64-apple-darwin.tar.xz"
      sha256 "fd801166cdbff81ae8fc508eff10b9ddf83cbd9a907d875ff305210ebcf04684"
    end
    if Hardware::CPU.intel?
      url "https://github.com/voco-labs/leanvox-mono/releases/download/v0.2.0/lvox-x86_64-apple-darwin.tar.xz"
      sha256 "18b1bd62dc2bd21dbb5a90caf4c5a16492d172473c4469aa947265470b3a89a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/voco-labs/leanvox-mono/releases/download/v0.2.0/lvox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a2d496ddcaa97de28cfd0314d555b7ba955089081ee98e13db548ba95173fa30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/voco-labs/leanvox-mono/releases/download/v0.2.0/lvox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "245c9e46ed67167ee8a1dbd365fca41ed69ac6a9b69334dc3675fd9b569bb253"
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
