# simple-peg-tracer (spt)

Generate and investigate traces for Janet PEG execution [1].

The generated traces are static HTML files that should be viewable and
navigable in typical web browsers.

![Trace Sample](spt-trace-sample.png?raw=true "Trace Sample")

## Installation

Quick:

```
jpm install https://github.com/sogaiu/simple-peg-tracer
```

Manual:

```
git clone https://github.com/sogaiu/simple-peg-tracer
cd simple-peg-tracer
jpm install
```

In either case, success should lead to the command `spt` being
available on `PATH` and a `spt` directory under `JANET_PATH`.

## Usage Patterns

`spt` can be used to generate sample traces from existing samples or
user-specified calls to `peg/match` / `meg/match`.

### spt

With no other arguments, some trace files will be generated based on 
how `janet` is feeling:

```
$ spt
Selected file: $JANET_PATH/spt/trace/samples/backmatch-sequence-capture-string.janet
Generated trace files in /tmp/spt-trace-458.
Recommended starting points:
* first event: file:///tmp/spt-trace-458/first.html
* last event: file:///tmp/spt-trace-458/last.html
* event log: file:///tmp/spt-trace-458/log.html
```

The invocation's output should contain some potentially useful
starting point URLs.  Using a web browser to interact with the
generated files is recommended.  If the browser supports JavaScript,
some shortcut keys may be available.

### spt \<string-that-is-typically-a-peg-special-name\>

With at least one argument that is not a file path or file name, an
attempt will be made to filter for and select from existing samples
whose names (typically built from PEG special names) contain the
supplied argument:

```
$ spt sequence
Selected file: $JANET_PATH/spt/trace/samples/sequence-string.janet
Generated trace files in /tmp/spt-trace-900.
Recommended starting points:
* first event: file:///tmp/spt-trace-900/first.html
* last event: file:///tmp/spt-trace-900/last.html
* event log: file:///tmp/spt-trace-900/log.html
```

### spt \<file-path-or-name\>

`spt` can also be passed a file path or file name containing suitable
text (roughly, arguments that could be passed to `peg/match` wrapped
in a tuple) from which to construct a call to `meg/match`:

```
spt $JANET_PATH/spt/trace/samples/pyrmont-inqk.janet
Selected file: $JANET_PATH/spt/trace/samples/pyrmont-inqk.janet
Generated trace files in /tmp/spt-trace-e75.
Recommended starting points:
* first event: file:///tmp/spt-trace-e75/first.html
* last event: file:///tmp/spt-trace-e75/last.html
* event log: file:///tmp/spt-trace-e75/log.html
```

To see some example files, see the `spt/trace/samples` directory that
may be living under `JANET_PATH` (for a non-project-specific
installation).

### spt -s

`spt -s` can be usefully invoked from an editor, being passed a
suitable selection of text via standard input.  The selection should
be a self-contained call to `peg/match`.  (In Emacs this might be done
via `M-x shell-command-on-region`.)

```
$ echo '(peg/match ~(capture "a") "a")' | spt -s
Generated trace files in /tmp/spt-trace-87a.
Recommended starting points:
* first event: file:///tmp/spt-trace-87a/first.html
* last event: file:///tmp/spt-trace-87a/last.html
* event log: file:///tmp/spt-trace-87a/log.html
```

## Notes

The generated files are not cleaned up automatically by `spt`.  The
operating system might clean them up at some point, but otherwise the
output URLs should give an idea of which directories to delete.

Instances of `$JANET_PATH` above are meant to be filled in via the
reader's imagination :)

## Usage Summary

```
$ spt -h

  Usage: spt [file|pattern] ...

  Generate and inspect Janet PEG execution traces [1].

    -h, --help                   show this output

    -s, --stdin                  read stdin for input

    -d, --dark                   use dark theme
    -l, --light                  use light theme

  Generate trace files for `meg/match` using arguments
  contained in `file` or a file selected by
  substring-matching a file name specified by `pattern`.
  `file` should be a `.janet` file, which when evaluated,
  returns a tuple with values for each desired argument.
  If `file` or `pattern` is not provided, some appropriate
  content will be arranged for.  Generated files will end
  up in a subdirectory.  `meg/match`'s signature is the
  same as that of `peg/match`.

  With the `-s` / `--stdin` option, standard input is
  read for text representing a call to `peg/match` or
  `meg/match`.

  With the `-l` / `--light` option, render using a light
  theme.  If the `-d` / `--dark` option is chosen,
  render using a dark theme.  If none of these options
  is specified, default to rendering using the dark theme.

  [1] Traces are generated using `meg/match`, a pure-Janet
  implementation of Janet's `peg/match`.  See the
  `margaret` Janet module for more details.
```

## Footnotes

[1] `spt` uses `meg/match` (provided by
[margaret](https://github.com/sogaiu/margaret)), which is an emulation
of Janet's `peg/match`.  There are some differences, but hopefully
this tool will still be useful enough (^^;