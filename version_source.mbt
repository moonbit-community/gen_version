///|
priv suberror VersionError {
  InvalidConfig(String)
} derive(Debug)

///|
fn generate_version_source(source : String) -> String raise VersionError {
  let (ast, reports) = @moon_config.parse_moon_mod(source)
  if !reports.is_empty() {
    raise InvalidConfig(
      "invalid moon.mod:\n" + reports.map(r => Show::to_string(r)).join("\n"),
    )
  }
  let version = match ToJson::to_json(ast) {
    { "version": String(version), .. } if !version.is_empty() => version
    _ => raise InvalidConfig("moon.mod requires a nonempty string version")
  }
  "const MODULE_VERSION = \{Repr(version)}\n"
}
