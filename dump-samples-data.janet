(import ./src/names :as n)

(def ext-idx (- (inc (length ".janet"))))

(def names-table (invert n/names))

(with [of (file/temp)]
  (each p (sort (os/dir "data"))
    (def name-from-f (string/slice p 0 ext-idx))
    (when (get names-table name-from-f)
      (def name
        (if (string/has-prefix? "0." name-from-f)
          (string "_" (string/slice name-from-f 2))
          name-from-f))
      (def content (slurp (string "data/" p)))
      (file/write of 
                  "(def " name "\n"
                  "  `````\n"
                  content
                  "  `````\n"
                  ")\n\n")))
  (file/flush of)
  (file/seek of :set 0)
  (spit "src/data.janet" (file/read of :all)))

