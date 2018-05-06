# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build LASzipBuilder
sources = [
    "https://github.com/LASzip/LASzip.git" =>
    "002c42593a3a90609e12805e52350cfa4c6f6563",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd LASzip/
mkdir build
cd build/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_VERBOSE_MAKEFILE=OFF ..
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
    BinaryProvider.Linux(:x86_64, :glibc),
    # BinaryProvider.MacOS(),
    # BinaryProvider.Windows(:i686),
    # BinaryProvider.Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "liblaszip", :liblaszip),
    LibraryProduct(prefix, "liblaszip_api", :liblaszip_api)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "LASzipBuilder", sources, script, platforms, products, dependencies)

