# Third-party License Templates

This directory keeps canonical license texts that we copy into vendored dependencies during custom PyTorch/Torchaudio builds. PyTorch’s packaging step refuses to bundle third-party code if it cannot parse a recognized license file, so these templates are used to normalize ports that ship informal notices.

Currently tracked:

- `gettimeofday_LICENSE.txt`
- `hungarian_LICENSE.txt`
- `pdcurses_LICENSE.txt`
- `pqp_LICENSE.txt`
- `sigslot_LICENSE.txt`

If another dependency triggers a “could not identify license file” error, add its canonical text here and copy it into the matching directory inside `build/src/pytorch/third_party/...` before rerunning the wheel build.
