class Lvox < Formula
  desc "Leanvox CLI — lean voice API from your terminal"
  homepage "https://leanvox.com"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.1/lvox-aarch64-apple-darwin.tar.xz"
      sha256 "b59294ba80bc0033cc3cff97ffb8a81976b6c45ff44400b7eaed0f0672688b98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.1/lvox-x86_64-apple-darwin.tar.xz"
      sha256 "ab523774918ceb89f40baccd3c577badc0f6b12e11bf05c67945c81e3f78f5f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.1/lvox-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2fb4698ae97ad055ef8acc2345b9d85bb7e5b4cac6e9714ffc126c3a60171fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/leanvox/lvox/releases/download/v0.2.1/lvox-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "644b5703c296e1290aa6bcc9b3fb817e51d0bfce0e4d56d045d0ccbd70ce4671"
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
