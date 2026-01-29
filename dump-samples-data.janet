(def ext-idx (- (inc (length ".janet"))))

(def samples-dir "data")

(with [of (file/temp)]
  # start names table
  (file/write of
              "(def names\n"
              "  @{\n")
  # add entries to names table
  (each fpath (sort (os/dir samples-dir))
    (def name-from-fpath (string/slice fpath 0 ext-idx))
    (def name
      (if (string/has-prefix? "0." name-from-fpath)
        (string "_" (string/slice name-from-fpath 2))
        name-from-fpath))
    (def content (slurp (string samples-dir "/" fpath)))
    (file/write of
                `"` name `"` "\n"
                "````````\n"
                (string/trimr content) "\n"
                "````````\n"))
  # end names table
  (file/write of "  })\n")
  #
  (file/flush of)
  (file/seek of :set 0)
  (spit "src/data.janet" (file/read of :all)))

