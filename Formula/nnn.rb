class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.5.tar.gz"
  sha256 "3636f172a024de5c12420a80dbe3d006d42b5e0a17e70a527963c864af22655c"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c032ece32ca1970c4a4224c246255191c42dac2f6ab6d6350dd87dc0770bf9a6" => :mojave
    sha256 "161ac6aad7a8a4e1441dd8d2eee8ff8024f9f827c452ffe8504e83a6cfc9a6cf" => :high_sierra
    sha256 "614a1b1a101ff166305e09052e3ed2e6422375637c00353b1f285b3c57aaf55c" => :sierra
    sha256 "4b73e09662d8abbae6a4d39324238722aa8df71fc4d56cea9ba26e46751141cf" => :x86_64_linux
  end

  depends_on "readline"
  depends_on "ncurses" unless OS.mac?

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "scripts/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "scripts/auto-completion/zsh/_nnn"
    fish_completion.install "scripts/auto-completion/fish/nnn.fish"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if ENV["CIRCLECI"] || ENV["TRAVIS"]

    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
