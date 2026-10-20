///|
async fn generate_version(output : String) -> Unit {
  let source = @fs.read_file("moon.mod").text()
  @fs.write_file(
    output,
    generate_version_source(source),
    create_mode=CreateOrTruncate,
  )
}
