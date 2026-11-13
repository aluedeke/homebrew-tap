class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.37.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.37.0/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b9765503ae1330009c5860d18b3503a899187c0d672435fb3a00d00643b11a17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.37.0/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6bcaa287aac741d2414098fb4aa51e14a8f41860c3982e78ad821346edf8b73d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.37.0/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4d04caf67a7db2133a8c93fa8c6574910d777ec23e44cf6263c34fff878d7ca8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.37.0/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "49f4a8b0ebbde6c2b36b0acf722ba1a6dcbb3087bc1855d147ecb84a3ca1930e"
    end
  end
  on_macos do
    on_arm do
      resource "tenx-app" do
        url "https://github.com/aluedeke/tenx/releases/download/v0.37.0/tenx-app-aarch64-apple-darwin.tar.xz"
        sha256 "e01fc5810744797ade1dbafb56a94458b7ee5d0dcdd4603f21945407c3830e2e"
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
