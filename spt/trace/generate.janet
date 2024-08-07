(import ../random :as rnd)
(import ./render :as r)

(def samples-root
  # XXX: kind of a work-around
  (string (dyn :syspath) "/spt/trace/samples"))

(defn enum-samples
  []
  (os/dir samples-root))

(defn scan-for-files
  [pattern]
  (when (empty? pattern)
    (break (enum-samples)))
  #
  (filter |(string/find pattern $)
          (enum-samples)))

(defn choose-random
  [files]
  (string samples-root "/" (rnd/choose files)))

(defn scan-with-random
  [pattern]
  (let [results (scan-for-files pattern)
        files (if (not (empty? results))
                results
                (enum-samples))]
    (choose-random files)))

(defn report
  [dir-path]
  (printf "Generated trace files in %s." dir-path)
  (printf "Recommended starting points:")
  (def first-event-path
    (string/format "file://%s/first.html" dir-path))
  (def last-event-path
    (string/format "file://%s/last.html" dir-path))
  (def event-log-path
    (string/format "file://%s/log.html" dir-path))
  (printf "* first event: %s" first-event-path)
  (printf "* last event: %s" last-event-path)
  (printf "* event log: %s" event-log-path))

# XXX: might be a better way...
(defn extract
  [content]
  # quote and eval to prepare to remove head element
  (def form (eval-string (string "'" content)))
  # check that the call is to peg/match or meg/match
  (assert (peg/match ~(sequence (set "mp")
                                "eg/match"
                                -1)
                     (string (first form)))
          (string/format "not a call to peg/match or meg/match: %s"
                         (first form)))
  (def args (drop 1 form))
  # back to string and eval again to handle any quote / quasiquote
  (map |(eval-string (string/format "%n" $))
       args))

(comment

  (extract ``
           (peg/match ~(sequence "abc"
                                 (argument 0))
                      "abc"
                      0
                     :smile
                     :it-is-fine)
           ``)
  # =>
  '@[(sequence "abc" (argument 0)) "abc" 0 :smile :it-is-fine]

  )

(defn gen-files-inner
  [opts peg text start & args]
  (def {:force force
        :dir-path dir-path
        :text-report text-report} opts)
  (default text-report true)
  (def stat (os/stat dir-path))
  (def mode (get stat :mode))
  (when (and stat
             (not= :directory mode))
    (errorf "non-directory with name %s exists already" dir-path))
  #
  (cond
    (nil? stat)
    (do
      (os/mkdir dir-path)
      (assert (= :directory
                 (os/stat dir-path :mode))
              (string/format "failed to arrange for trace directory: %s"
                             dir-path)))
    #
    (and (false? force)
         (not (empty? (os/dir dir-path))))
    (do
      (def prmpt
        (string/format "Directory `%s` exists, overwrite contents? [y/N] "
                       dir-path))
      (def buf (getline prmpt))
      (when (not (string/has-prefix? "y" (string/ascii-lower buf)))
        (eprintf "Ok, bye!")
        (break))))
  #
  (def old-dir (os/cwd))
  (defer (os/cd old-dir)
    (os/cd dir-path)
    (r/render peg text start ;args))
  #
  (when text-report
    (report dir-path)))

(defn gen-files
  [content &opt force dir-path text-report]
  (default force false)
  (default dir-path ".")
  (default text-report false)
  (try
    (do
      (def [peg text start & args]
        (eval-string content))
      (default start 0)
      (default args [])
      (gen-files-inner {:force force
                        :dir-path dir-path
                        :text-report text-report}
                       peg text start ;args))
    ([e f]
      (eprintf "problem creating trace files using: %s" content)
      (propagate e f))))

(defn gen-files-from-call-str
  [call-str &opt force dir-path text-report]
  (default force true)
  (default dir-path ".")
  (default text-report false)
  (try
    (do
      (def [peg text start & args]
        (extract call-str))
      (default start 0)
      (default args [])
      (gen-files-inner {:force force
                        :dir-path dir-path
                        :text-report text-report}
                       peg text start ;args))
    ([e f]
      (eprintf "problem creating trace files using: %s" call-str)
      (propagate e f))))

