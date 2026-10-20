///|
test "generate a MODULE_VERSION constant" {
  inspect(
    generate_version_source("version = \"1.2.3\""),
    content="const MODULE_VERSION = \"1.2.3\"\n",
  )
}

///|
test "read the version among comments and other module fields" {
  let source =
    #|// The module version is used verbatim.
    #|name = "example/module"
    #|version = "1.2.3-rc.1+build.42" // release candidate
    #|description = "A module"
    #|import { "moonbitlang/async@0.22.4" }
  inspect(
    generate_version_source(source),
    content="const MODULE_VERSION = \"1.2.3-rc.1+build.42\"\n",
  )
}

///|
test "escape quotes and backslashes in the parsed version" {
  let source =
    #|version = "1.0.0-\"quoted\"\\path\n\t"
  // moon_config retains escape sequences in the parsed string.
  inspect(
    generate_version_source(source),
    content=(
      #|const MODULE_VERSION = "1.0.0-\\\"quoted\\\"\\\\path\\n\\t"
      #|
    ),
  )
}

///|
test "preserve unicode in the version" {
  inspect(
    generate_version_source("version = \"1.0.0-测试🌙\""),
    content="const MODULE_VERSION = \"1.0.0-测试🌙\"\n",
  )
}

///|
test "reject a missing version" {
  for source in ["", "// no version", "name = \"example/module\""] {
    try generate_version_source(source) catch {
      InvalidConfig(message) =>
        inspect(message, content="moon.mod requires a nonempty string version")
    } noraise {
      _ => fail("expected a missing version to be rejected")
    }
  }
}

///|
test "reject an empty version" {
  try generate_version_source("version = \"\"") catch {
    InvalidConfig(message) =>
      inspect(message, content="moon.mod requires a nonempty string version")
  } noraise {
    _ => fail("expected an empty version to be rejected")
  }
}

///|
test "reject nonstring versions" {
  for value in ["123", "true", "[]", "{}"] {
    try generate_version_source("version = " + value) catch {
      InvalidConfig(message) =>
        inspect(message, content="moon.mod requires a nonempty string version")
    } noraise {
      _ => fail("expected a nonstring version to be rejected")
    }
  }
}

///|
test "include parser diagnostics for malformed configuration" {
  for source in ["version =", "version = \"unterminated", "version = null"] {
    try generate_version_source(source) catch {
      InvalidConfig(message) =>
        assert_true(
          message is [.. "invalid moon.mod:\n", .. diagnostics] &&
          !diagnostics.is_empty(),
        )
    } noraise {
      _ => fail("expected malformed configuration to be rejected")
    }
  }
}

///|
test "reject duplicate versions instead of using the recovered AST" {
  let source =
    #|version = "1.0.0"
    #|version = "2.0.0"
  try generate_version_source(source) catch {
    InvalidConfig(message) =>
      assert_true(message is [.. "invalid moon.mod:\n", ..])
  } noraise {
    _ => fail("expected duplicate versions to be rejected")
  }
}
