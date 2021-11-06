# frozen_string_literal: true

class Pen < Formula
  version '0.3.1'
  desc 'Pen programming language'
  homepage 'https://github.com/pen-lang/pen'
  url "https://github.com/pen-lang/pen/archive/refs/tags/v#{version}.tar.gz"
  sha256 'cf795ec070d5e063ddc2efa56300f8482e8a72d23d298aaf0db03dc1764bfe44'
  license 'MIT'

  conflicts_with 'pen'

  depends_on 'git'
  depends_on 'jq'
  depends_on 'llvm@12'
  depends_on 'ninja'
  depends_on 'rust'

  def install
    system 'cargo', 'build', '--locked', '--release'
    libexec.install 'target/release/pen'

    paths = [
      'git',
      'jq',
      'llvm@12',
      'ninja'
    ].map do |name|
      Formula[name].opt_bin
    end.join(':')

    File.write 'pen.sh', <<~EOS
      #!/bin/sh
      set -e
      export PEN_ROOT=#{prefix}
      export PATH=#{paths}:$PATH
      if ! which rustup >/dev/null; then
        export PATH=#{Formula['rust'].opt_bin}:$PATH
      fi
      #{libexec / 'pen'} "$@"
    EOS

    chmod 0o755, 'pen.sh'
    libexec.install 'pen.sh'
    bin.install_symlink (libexec / 'pen.sh') => 'pen'

    (prefix / 'cmd').install Dir['cmd/*']
    lib.install Dir['lib/*']
  end

  test do
    ENV.prepend_path 'PATH', bin

    system 'pen', 'create', '.'
    system 'pen', 'build'
    system 'pen', 'test'
    system './app'
  end
end
