class Lvox < Formula
  desc "Leanvox CLI — lean voice API from your terminal"
  homepage "https://leanvox.com"
  version "0.4.0"
  license "MIT"

  # Placeholder — will be auto-updated by cargo-dist release workflow
  url "https://github.com/leanvox/lvox/releases/download/v0.4.0/lvox-aarch64-apple-darwin.tar.xz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  def install
    bin.install "lvox"
  end

  test do
    system "#{bin}/lvox", "--version"
  end
end
