# tenx-agent, the voice assistant for tenx, from the newest commit on main.
#
#   brew install --HEAD aluedeke/tap/tenx-agent
#   brew services start tenx-agent
#
#   brew upgrade --fetch-HEAD tenx-agent && brew services restart tenx-agent
#
# Install-only from HEAD: tenx-agent has no releases, and its repository is
# private, so it installs over SSH on a machine whose key can read it.
class TenxAgent < Formula
  desc "Voice assistant for tenx: talk to your tasks and their agents"
  homepage "https://github.com/aluedeke/tenx-agent"
  head "git@github.com:aluedeke/tenx-agent.git", branch: "main", using: :git

  depends_on arch: :arm64
  depends_on :macos
  depends_on "uv"

  def install
    # The script imports its sibling modules (timeline.py), so all of them.
    libexec.install Dir["backend/*.py"]
    # uv reads the script's dependencies from its header and keeps their
    # environment in its own cache, so an upgrade only fetches what changed.
    (bin/"tenx-agent").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("uv")}/uv" run --script "#{opt_libexec}/tenx-agent.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      Settings: ~/.config/tenx-agent/config.toml (see the repository's README).
      It needs `tenx web` running for its MCP endpoint.
    EOS
  end

  service do
    run opt_bin/"tenx-agent"
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/tenx-agent.log"
    error_log_path var/"log/tenx-agent.log"
  end

  test do
    assert_path_exists libexec/"tenx-agent.py"
  end
end
