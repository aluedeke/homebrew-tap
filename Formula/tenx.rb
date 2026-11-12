class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.36.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.36.0/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "83782b8bf7d2dae87b1a81306ff5153b0c3c8ae981b6443e14789764339c2199"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.36.0/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ab0d0c172827aca212e219334a496032cb9358a1bd8c1d8e753a725d3096c52e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.36.0/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "110d3151d1fd995e32138e332fb2308e6ecdd97f8af0d7df83cbb35e792115d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.36.0/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e40c9fb25b42a3660ec8d2adf093239d6894120fdd78db19d9839401542a9e67"
    end
  end
  on_macos do
    on_arm do
      resource "tenx-app" do
        url "https://github.com/aluedeke/tenx/releases/download/v0.36.0/tenx-app-aarch64-apple-darwin.tar.xz"
        sha256 "681872320b3261a4f7179ac0abcc43d16fe3d1c1acab63d67e5bad6ee5eaa5e2"
      end
    end
  end
  license any_of: ["MIT", "Apache-2.0"]
  depends_on "tmux"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tenx", "tenx-whisper", "tenx-tts"
      resource("tenx-app").stage do
        app = (File.basename(Dir.pwd) == "tenx.app") ? Pathname.pwd : Pathname.pwd/"tenx.app"
        (prefix/"tenx.app").install app.children
      end
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tenx", "tenx-tts"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tenx"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tenx"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
