// Learn more about moon.mod configuration:
// https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html
//
// To add a dependency, run this command in your terminal:
//   moon add moonbitlang/x
//
// Or manually declare it in `import`, for example:
// import {
//   "moonbitlang/x@0.4.6",
// }

name = "moonbit-community/gen_version"

version = "0.0.1"

readme = "README.mbt.md"

repository = "https://github.com/moonbit-community/gen_version"

license = "Apache-2.0"

keywords = [ "codegen", "version" ]

preferred_target = "native"

description = "Generate a MoonBit `MODULE_VERSION` constant from the version in `moon.mod`"

import {
  "moonbitlang/async@0.22.4",
  "moonbitlang/moon_config@0.4.2",
  "moonbitlang/x@0.5.5",
}
