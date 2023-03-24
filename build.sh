set -e

mkdir -p build
cd build
cmake `clsdk-cmake-args` ..
make -j $(nproc)
ctest -j10 -V
cd ..

cp build/starter.* ./starter/  || true

echo "WASM hash: $(sha256sum starter/starter.wasm)"