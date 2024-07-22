# janet-usages-as-tests

Generate and run tests from usage examples

## Background

It can be useful to record usages (calls):

```janet
(peg/match ~(cmt (capture "hello")
                 ,(fn [cap]
                    (string cap "!")))
           "hello")
```

and the asssociated results:

```janet
@["hello!"]
```

that tend to arise while developing for later reference,
documentation, and/or reuse.

What if these pairs of things could also be used as tests?

```janet
(comment

  (peg/match ~(cmt (capture "hello")
                   ,(fn [cap]
                      (string cap "!")))
             "hello")
  # =>
  @["hello!"]

  )
```

`janet-usages-as-tests` is an evolution of
[usages-as-tests](https://github.com/sogaiu/usages-as-tests).  The
basic idea is the same once things are setup.

## Sample Repositories

The following repositories use `janet-usages-as-tests` (hover for
descriptions):

* [ajrepl](https://github.com/sogaiu/ajrepl "Emacs Support for Janet
  REPL Interaction")
* [babashka-tasks-view](https://github.com/sogaiu/babashka-tasks-view
  "View Babashka tasks by tag")
* [clojure-peg](https://github.com/sogaiu/clojure-peg "Parse and
  Generate Clojure Source")
* [index-janet-source](https://github.com/sogaiu/index-janet-source
  "Index Janet Source Code")
* [jandent](https://github.com/sogaiu/jandent "Janet Indenter")
* [janet-aliases](https://github.com/sogaiu/janet-aliases "Janet
  Source Aliases Reporter")
* [janet-bits](https://github.com/sogaiu/janet-bits "IEEE 754 Exploration")
* [janet-editor-elf](https://github.com/sogaiu/janet-editor-elf
  "Helpful Bits for Janet Support in Editors ")
* [janet-peg](https://github.com/sogaiu/janet-peg "Parse and Generate
  Janet Source Code")
* [janet-pegdoc](https://github.com/sogaiu/janet-pegdoc "Janet PEG
  special doc tool")
* [janet-ref](https://github.com/sogaiu/janet-ref "Janet Reference
   Tool")
* [janet-tree-sitter](https://github.com/sogaiu/janet-tree-sitter
  "Janet bindings for tree-sitter ")
* [janet-ts-dsl](https://github.com/sogaiu/janet-ts-dsl "Alternate
  DSLs for tree-sitter Grammars")
* [janet-walk-dir](https://github.com/sogaiu/janet-walk-dir "Walking
  Directory Trees")
* [janet-xmlish](https://github.com/sogaiu/janet-xmlish "Hack to Work
  with Some Amount of XML")
* [janet-zipper](https://github.com/sogaiu/janet-zipper "Zippers in
  Janet")
* [jaylib-wasm-demo](https://github.com/sogaiu/jaylib-wasm-demo "Demo
  of using jaylib in a web browser")
* [jpm-tasks-view](https://github.com/sogaiu/jpm-tasks-view
  "View jpm tasks by tag")
* [margaret](https://github.com/sogaiu/margaret "A Janet
  implementation of Janet’s peg/match")

## Running Tests

### Repositories Using janet-usages-as-tests

Invoke `jpm test` as usual.

### This Repository

Invoking `jpm test` will not work for this repository as it is not set
up to be tested in that manner.

Instead, to test the code in this repository, invoke:
```
janet make-and-run-juat-tests.janet
```

## Setup and Configuration

There are a few ways `janet-usages-as-tests` can be used with some
target project.

### Basic

0. Clone this repository somewhere.
1. Copy just the subdirectory named `janet-usages-as-tests` of the
   cloned repository as a subdirectory of a target project.
2. Copy or move the included `make-and-run-juat-tests.janet` file into
   the `test` directory of the target project.
3. Edit `make-and-run-juat-tests.janet` to specify files and/or
   directories that are the target of usages to be treated as tests.

Note, most sample repositories listed above (except for
`jaylib-wasm-demo`) used this method of setup.

### Git Submodule

1. In place of step 1 above, add this repository as a submodule of a
   target project.  See
   [jaylib-wasm-demo](https://github.com/sogaiu/jaylib-wasm-demo) for
   an example that does this.
2. Copy or move the included `make-and-run-juat-tests-submodule.janet`
   file into the `test` directory of the target project.
3. Edit `make-and-run-juat-tests-submodule.janet` to specify
   files and/or directories that are the target of usages to be
   treated as tests.

## Writing Tests

Within `comment` blocks, put expressions / forms to be tested along
with expected values (or expressions):

```janet
(comment

  (- 1 1)
  # =>
  0

  )
```

Here `(- 1 1)` is the expression to be tested and `0` is the
corresponding expected value.  The instance of `# =>` indicates
the presence of a test / usage.

See [Usage / Test Writing Tips](./doc/tips.md) for more details.

## Acknowledgments

* andrewchambers - suggestion and explanation
* bakpakin - janet, jpm, helper.janet, path.janet, peg for janet, etc.
* pepe - discussion, One-Shot Power Util Solver ™ motivation, and naming
* pyrmont - discussion and exploration
* rduplain - bringing to light customization of `jpm test`
* Saikyun - discussion and testing
* srnb@gitlab - suggestion

