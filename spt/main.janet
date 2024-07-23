(import ./argv :as av)
(import ./tempdir :as td)
(import ./trace/generate :as tg)
(import ./trace/theme :as tt)

(def usage
  ``
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
  ``)

(defn main
  [& argv]
  (setdyn :spt-rng (math/rng (os/cryptorand 8)))

  (def [opts rest errs]
    (av/parse-argv argv))

  (when (not (empty? errs))
    (each err errs
      (eprint "spt: " err))
    (eprint "Try 'spt -h' for usage text.")
    (os/exit 1))

  # usage
  (when (opts :help)
    (print usage)
    (os/exit 0))

  (cond
    (opts :light)
    (setdyn :spt-theme tt/light-theme)
    #
    (opts :dark)
    (setdyn :spt-theme tt/dark-theme)
    #
    (setdyn :spt-theme tt/dark-theme))

  # generate trace files
  (def temp-dir (td/mk-temp-dir "spt-trace-///"))
  (when (opts :stdin)
    (def content (file/read stdin :all))
    (tg/gen-files-from-call-str content true temp-dir true)
    (os/exit 0))

  (def arg-file
    (if-let [arg (first rest)]
      (if (os/stat arg)
        arg
        (tg/scan-with-random arg))
      (tg/choose-random (tg/enum-samples))))
  (when (not (os/stat arg-file))
    (eprintf "Failed to find file: %s" arg-file)
    (os/exit 1))

  (printf "Selected file: %s" arg-file)
  (tg/gen-files (slurp arg-file) false temp-dir true)
  (os/exit 0))

