(def a/arg-data
  {"--dark" "-d"
   "--help" "-h"
   "--light" "-l"
   "--stdin" "-s"
   "--version" "-v"})

(def a/shorts-table
  (tabseq [[full short] :pairs a/arg-data
           :when short]
    short full))

(defn a/opt-to-keyword
  [opt-str]
  (def full-opt-str (get a/shorts-table opt-str opt-str))
  (when (not (string/has-prefix? "--" full-opt-str))
    (break (string/format "Unknown short option: %s" opt-str)))
  (when (not (get a/arg-data full-opt-str))
    (break (string/format "Unknown option: %s" opt-str)))
  (keyword (string/slice full-opt-str 2)))

(defn a/parse-argv
  [argv]
  (def opts @{})
  (def rest @[])
  (def errs @[])
  (def argc (length argv))
  #
  (when (> argc 1)
    (var i 1)
    (while (< i argc)
      (def arg (get argv i))
      (if (string/has-prefix? "-" arg)
        (let [res (a/opt-to-keyword arg)]
          (cond
            (string? res)
            (array/push errs res)
            #
            (keyword? res)
            (put opts res true)
            #
            (array/push errs
                        (string/format "unexpected type: %n"
                                       (type res)))))
        (array/push rest arg))
      (++ i)))
  #
  [opts rest errs])

