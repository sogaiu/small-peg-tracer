# simple-peg-tracer (spt)

Generate and investigate traces for Janet PEG [1] execution.

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

## Usages

### Generate Trace Files

```
$ echo '(peg/match ~(capture "a") "a")' | spt -t -s
Generated trace files in /tmp/spt-trace-900.
Recommended starting points:
* first event: file:///tmp/spt-trace-900/first.html
* last event: file:///tmp/spt-trace-900/last.html
* all events: file:///tmp/spt-trace-900/log.html
```

Notes:

* Using a web browser to interact with the generated files is
  recommended.  The invocation's output should contain some
  potentially useful starting point URLs.  If the browser supports
  JavaScript, some shortcut keys may be available.

* `spt -t` (without `-s`) can be used to generate sample traces from
  existing samples.  With no other arguments, some trace files will be
  generated.  With at least one argument that is not a file path or
  file name, an attempt will be made to filter for and select from
  existing samples whose names contain the supplied argument.

* `spt -t` can also be passed a file path or file name containing
  suitable text (roughly, arguments that could be passed to
  `peg/match` wrapped in a tuple) from which to construct a call to
  `meg/match`.  To see some example files, see the `spt/trace/samples`
  directory.

* `spt -t -s` can be usefully invoked from an editor, being passed a
  suitable selection of text via standard input.  The selection should
  be a self-contained call to `peg/match`.  In Emacs this might be
  done via `M-x shell-command-on-region`.

### Start Web UI

```
$ spt -w
Trying to create directory: spt-trace
Changing working directory to: spt-trace
Trying to start server at http://127.0.0.1:43785
```

* A web server should start up on a suitable port and the console
  output should indicate a URL that should be usable to access a
  starting page.

* The starting page allows one to specify calls to `peg/match` [1] (or
  `meg/match`) via a form.  It's also possible to have a sample trace
  generated based on samples that come with `spt`.  Additionally, if
  there is a generated trace already, this should be viewable.

### Get basic help

```
$ spt -h

  Usage: spt [-t|--trace] ...
         spt [-w|--web] ...

  Generate and inspect Janet PEG execution traces [1].

    -h, --help                   show this output

    -t, --trace [file|pattern]   generate trace files
    -w, --web                    start web ui for tracing

    -s, --stdin                  read stdin for input

    -d, --dark                   use dark theme
    -l, --light                  use light theme

  With the `-t` or `--trace` option, generate trace files for
  `meg/match` using arguments contained in `file` or a file
  selected by substring-matching a file name specified by
  `pattern`.  `file` should be a `.janet` file, which when
  evaluated, returns a tuple with values for each desired
  argument.  If `file` or `pattern` is not provided, some
  appropriate content will be arranged for.  Generated files
  will end up in a subdirectory.  `meg/match`'s signature is
  the same as that of `peg/match`.

  With the `-w` or `--web` option, start a local web server
  that provides access to the tracing functionality described
  for the `-t` or `--trace` option.

  If either of `-t` or `-w` is combined with the `-s` or
  `--stdin` option, standard input is read for text
  representing a call to `peg/match` or `meg/match`.

  If the `-l` / `--light` option is chosen, render using
  a light theme.  If the `-d` / `--dark` option is chosen,
  render using a dark theme.  If none of these options
  is specified, default to rendering using the dark theme.

  [1] Traces are generated using `meg/match`, a pure-Janet
  implementation of Janet's `peg/match`.  See the
  `margaret` Janet module for more details.
```

## Credits

Janet's spork/http is included.

Thus the following license applies to at least those portions.

```
Copyright (c) 2019, 2020, 2021, 2022, 2023, 2024 Calvin Rose and contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Footnotes

[1] `spt` uses `meg/match` (provided by
[margaret](https://github.com/sogaiu/margaret)), which is an emulation
of Janet's `peg/match`.  There are some differences, but hopefully
this tool will still be useful enough (^^;