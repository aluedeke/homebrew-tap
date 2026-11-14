class Tenx < Formula
  desc "Work on many tasks in parallel, each with its own git worktrees and its own Claude Code agent, and always know which one needs you"
  homepage "https://github.com/aluedeke/tenx"
  version "0.39.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.39.0/tenx-cli-aarch64-apple-darwin.tar.xz"
      sha256 "95db76e61afb52d1bdfcfc082e8e5beb8abc6034db58c639b8e71eb26f4675bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.39.0/tenx-cli-x86_64-apple-darwin.tar.xz"
      sha256 "43abb1d4cb82070cbab2e7d05e94d43237dbf7d7e6d293eed574bdbef305c83f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aluedeke/tenx/releases/download/v0.39.0/tenx-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "351f273a68c2d49d9ce0b81a8b2f1fb0537acc8472118db67d27d393496ffff6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aluedeke/tenx/releases/download/v0.39.0/tenx-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b6fd8f992b2fa3639721ee8c7dc03d01a56fc41647b8405afeac972665de8bb2"
    end
  end
  on_macos do
    on_arm do
      resource "tenx-app" do
        url "https://github.com/aluedeke/tenx/releases/download/v0.39.0/tenx-app-aarch64-apple-darwin.tar.xz"
        sha256 "ed12d2b8cbedc74ea2d34c8a11d804ff35d71cedd3c71e0cf8ce49b3e3ba176b"
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
