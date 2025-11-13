# Custom PyTorch CUDA Build Notes

This directory keeps supporting materials for building PyTorch/Torchaudio wheels targeting GPUs that are not yet supported by official binaries.

## Third-party license stubs

The PyTorch packaging step (`setup.py bdist_wheel`) checks every bundled dependency for a recognizable license file. Some vcpkg ports included with `opentelemetry-cpp` ship informal notices that PyTorch’s detector does not understand, so canonical MIT text is tracked under `docs/licenses/`:

- `docs/licenses/gettimeofday_LICENSE.txt`
- `docs/licenses/hungarian_LICENSE.txt`

During the build we copy these license texts into the corresponding `third_party/opentelemetry-cpp/tools/vcpkg/ports/...` directories so the packaging step can complete.

If additional ports trigger the same error, add their canonical license text to `docs/licenses/` and copy it into the build tree before rerunning the wheel build.
