class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2019.06.03.00.tar.gz"
  sha256 "a8b6ea626cabcc210700d5d0389985ffc7ab9f96433386322b4cfd3df9b9eabd"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "3dcb1509a2781403663158660ffe7417d6624424aa21fb05217fcbc5d1c6dde5" => :mojave
    sha256 "0d1631bb0285b77cbcfbacbecf7c4239bce34479b5ce69b9ddeabcea73023ab2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"

  # https://github.com/facebook/folly/issues/966
  depends_on :macos => :high_sierra if OS.mac?

  depends_on "openssl"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  depends_on "python" unless OS.mac?

  # Known issue upstream. They're working on it:
  # https://github.com/facebook/folly/pull/445
  fails_with :gcc => "6"

  # patch for pclmul compiler flags to fix mojave build
  patch do
    url "https://github.com/facebook/folly/commit/964ca3c4979f72115ebfec58056e968a69d5942c.diff?full_index=1"
    sha256 "b719dd8783f655f0d98cd0e2339ef66753a8d2503c82d334456a86763b0b889f"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    mkdir "_build" do
      args = std_cmake_args + %w[
        -DFOLLY_USE_JEMALLOC=OFF
      ]

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
