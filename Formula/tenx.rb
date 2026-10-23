class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.17.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.17.2/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1f9ce1df023d73ada0269ff67194373662b553ba17116efeb22ff83520ce4056"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.17.2/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d336863aa2168b31adfe23855850c0534e24539ce9fbc86bf938eb2a2ff26b90"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.17.2/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f4f407659f0d860defdc68afac842781c382b84c2643e24ec2cbc228a4484075"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.17.2/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4d85ca22faf6d5c4fe777854622e7745f8655b40b76aff273cc27a4fe0b1ae62"
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
