class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.8.2/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4f83d22f860a5ba6002d2d47aae88a37786a92729aeefc4a8dc8184396ceb2ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.8.2/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8195de3c12abcce1e4f1aa987b55f87876d8f9718cf6ddec1e159b8f23bd2da1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.8.2/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7aed75545b08dbf10140bdfc17eddbc7d344e709fa90f8a35ccba5b36c766f5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.8.2/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b5dc40a2ef4f86f59adf21014c4825e0dcf064f3a63b1840c63bd26e8be7e6ab"
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
      bin.install "tenx", "tenx-whisper"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tenx"
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
