class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.4.0.tar.gz"
  sha256 "fc410720df01dd5f996b044a3278d19974348e3eb9bc7e2b0404204a041f4aa7"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "9ed41be7f790942c8f8bbe8082fa15bd6d18a95fbd589502fb827a008a2b1f7e" => :mojave
    sha256 "5368d364f8a69dece59ea7560e2336bb1a7a3f42c6d3443fe1ff9ae740f086e0" => :high_sierra
    sha256 "503eec5cec3b9c1e2ea3629cc3eca7a670e3776106224aa0d744a42994251270" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/golang-migrate/migrate").install buildpath.children

    # Build and install CLI as "migrate"
    cd "src/github.com/golang-migrate/migrate" do
      system "make", "build-cli", "VERSION=v#{version}"
      bin.install "cli/build/migrate.darwin-amd64" => "migrate"
      prefix.install_metafiles
    end
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end
