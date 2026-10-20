///|
async test "generate_version creates and truncates the output file" {
  let dir = @fs.tmpdir(prefix="gen_version_test")
  defer @fs.rmdir(dir, recursive=true)
  let output = "\{dir}/version.mbt"
  let expected = generate_version_source(@fs.read_file("moon.mod").text())
  generate_version(output)
  assert_eq(@fs.read_file(output).text(), expected)
  @fs.write_file(output, expected + "stale trailing content")
  generate_version(output)
  assert_eq(@fs.read_file(output).text(), expected)
}
