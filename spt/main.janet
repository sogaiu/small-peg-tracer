(import ./argv :as av)
(import ./tempdir :as td)
(import ./trace/generate :as tg)
(import ./trace/theme :as tt)
(import ./trace/web :as tw)

(def usage
  ``
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
  (when (or (empty? opts)
            (opts :help))
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
  (when (opts :trace)
    (def temp-dir (td/mk-temp-dir "spt-trace-///"))
    (when (opts :stdin)
      (def content (file/read stdin :all))
      (tg/gen-files-from-call-str content true temp-dir true)
      (os/exit 0))
    #
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

  # start web server
  (when (opts :web)
    (def content
      (if (opts :stdin)
        (file/read stdin :all)
        nil))
    (def port
      (when-let [port-str (first rest)]
        (scan-number port-str)))
    # expressing this way allows process to stay alive
    (break (tw/serve content nil nil port))))

