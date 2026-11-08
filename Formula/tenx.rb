class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.26.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.26.0/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e43691d9186131bc54855fd8da9d25e029e54e18de1f5b74473ee3320f0401e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.26.0/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a93f6d52aaa3de2c887919f8d5ba25cb5bf07cbf8cae5a256c36e51fe465848b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.26.0/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5be61ad9dfe6515eb454ef4965f3d201a666f92467c8355e8e93812ab0df2acb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.26.0/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "852227d8a8c9a0df6215ea12840759d531e1a2c8402925df396a462925170ebc"
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
