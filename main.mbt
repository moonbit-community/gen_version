///|
/// Run from the module root:
/// moon run . -- -o version.mbt
async fn main {
  let command = @argparse.Command(
    "gen_version",
    about="Generate a MoonBit MODULE_VERSION constant from moon.mod.",
    options=[
      OptionArg(
        "output",
        short='o',
        required=true,
        about="Path to the generated MoonBit source file.",
      ),
    ],
  )
  let args = command.parse() catch {
    error => {
      eprintln("\{error}")
      @sys.exit(2)
      return
    }
  }
  let output = args.values["output"][0]
  guard !output.is_empty() else {
    eprintln("error: output file must not be empty\n\n" + command.render_help())
    @sys.exit(2)
    return
  }
  generate_version(output) catch {
    InvalidConfig(message) => {
      eprintln("error: " + message)
      @sys.exit(1)
    }
    error => {
      eprintln("error: \{error}")
      @sys.exit(1)
    }
  }
}
