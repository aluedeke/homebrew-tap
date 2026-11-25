class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.44.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.44.0/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6dddbebd24da1d9b6eba252f4dde2db59691c1a3fb8112b2743370422d4811e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.44.0/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "e8d815c104ebf0afff6f2ab5bdddb0e5f6d9ba5c01b5d695d362c7150a5ad2f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.44.0/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "36631ef726d81c83add3c8f6e3053d898beb9d550ff9ec63bd1480aed2870a23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.44.0/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0270f60fd3af28f02c5483a72efcb9e86658c55986daf3141fff60c80673a8ea"
    end
  end
  on_macos do
    on_arm do
      resource "tenx-app" do
        url "https://github.com/aluedeke/tenx/releases/download/v0.44.0/tenx-app-aarch64-apple-darwin.tar.xz"
        sha256 "e1fc7a7e0622b654a3a8d8aa9ebc89065450e5234265611e1b61b63be7f5e9f2"
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
