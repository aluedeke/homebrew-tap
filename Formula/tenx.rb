class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.38.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.38.0/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1588bb9aa7114cd4d3f0136b6f59104ed2b97b80ca3e06ae666237a7ee1f9fa8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.38.0/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8108cce9815083631ff41f90a83a498ff182a82acbc37b0db8d7b92ba180c3a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.38.0/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "03f05d535efcd07d430d1513499cdf64e3cee821066841fca961820ec1720c25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.38.0/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "218b3dea15a9e3f6727ccfeffd7bac0ed12cb2e753cf06a22869c6505ece2579"
    end
  end
  on_macos do
    on_arm do
      resource "tenx-app" do
        url "https://github.com/aluedeke/tenx/releases/download/v0.38.0/tenx-app-aarch64-apple-darwin.tar.xz"
        sha256 "339b3f86740ec55f6e924daa693dd0c10e669fc4b46f7e1e388a3de6d629d89d"
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
