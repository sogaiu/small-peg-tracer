(def data/accumulate-sequence-capture-integer
  `````
[~(accumulate (sequence (capture 1)
                        (capture 1)
                        (capture 1)))
 "abc"]
  `````
)

(def data/backmatch-sequence-capture-string
  `````
[~(sequence (capture "a")
            "b"
            (capture (backmatch)))
 "aba"]
  `````
)

(def data/backref-sequence-capture-some-string-keyword
  `````
[~(sequence (capture (some "smile") :x) (backref :x))
 "smile!"]

  `````
)

(def data/choice-string-error
  `````
[~(choice "a"
          "b"
          (error ""))
 "c"]
  `````
)

(def data/cms-constant
  `````
[~(cms (constant [:alice :bob :carol])
       ,identity)
 "ab"]

  `````
)

(def data/cmt-sequence-capture-string
  `````
[~(cmt (sequence (capture "a") (capture "b"))
       ,(fn [left right]
          [right left]))
 "ab"]

  `````
)

(def data/colon-extended-numbers
  `````
[~{:main (drop (sequence (cmt (capture (some :num-char))
                              ,scan-number)
                         (opt (sequence ":" (range "AZ" "az")))))
   :num-char (choice (range "09" "AZ" "az")
                     (set "&+-_"))}
 "2:u"]
  `````
)

(def data/group-sequence-capture-integer
  `````
[~(group (sequence (capture 1)
                   (capture 1)
                   (capture 1)))
 "abc"]
  `````
)

(def data/lenprefix-sequence-number-capture-backref
  `````
[~(sequence (number :d nil :tag)
            (capture (lenprefix (backref :tag)
                                1)))
 "3abc"]

  `````
)

(def data/pyrmont-inqk
  `````
[~{:main (* :tagged -1)
   :tagged (unref (replace (* :open-tag :value :close-tag) ,struct))
   :open-tag (* (constant :tag) "<" (capture :w+ :tag-name) ">")
   :value (* (constant :value) (group (any (+ :tagged :untagged))))
   :close-tag (drop (* "</" (cmt (* (backref :tag-name) (capture :w+)) ,=) ">"))
   :untagged (capture (some (if-not "<" 1)))}
 "<p><em>Hello</em> <strong>world</strong>!</p>"]
  `````
)

(def data/sequence-only-tags-capture-integer-backref
  `````
[(quasiquote (sequence (only-tags (sequence (capture 1 :a) (capture 2 :b))) (backref :a)))
 "xyz"]  `````
)

(def data/sequence-string-some-integer-string
  `````
[~(sequence "a" (some 1) "c")
 "abc"]
  `````
)

(def data/sequence-string
  `````
[~(sequence "a" "b")
 "ab"
 0
 :hello :hi]
  `````
)

(def data/sequence-til-capture-to-capture-to
  `````
[~(sequence (til "bcde" (capture (to -1)))
            (capture (to -1)))
           "abcdef"]

  `````
)

(def data/split-keyword-capture-to-integer
  `````
[~(split :s+ (capture (to -1)))
 "a b  c"]
  `````
)

(def data/struct-choice-keyword-constant-look-integer-sequence-string-position
  `````
[~{:main (choice :back (constant 0))
   :back (look -1 (choice (sequence "/" (position))
                          :back))}
 "/home/taro/.bashrc"
 18]
  `````
)

(def data/struct-some-if-not-string-integer-set-opt-replace-any-capture-keyword-constant
  `````
[~{:main (sequence (opt (sequence (replace (capture :lead)
                                           ,(fn [& xs]
                                              [:lead (get xs 0)]))
                                  (any (set `\/`))))
                   (opt (capture :span))
                   (any (sequence :sep (capture :span)))
                   (opt (sequence :sep (constant ""))))
   :lead (sequence (opt (sequence :a `:`)) `\`)
   :span (some (if-not (set `\/`) 1))
   :sep (some (set `\/`))}
 `C:\WINDOWS\config.sys`]
  `````
)

(def data/sub-sequence-constant-integer-capture-backref
  `````
[~(sequence (constant 5 :tag)
            (sub (capture "abc" :tag)
                 (backref :tag)))
 "abcdef"]
  `````
)

(def data/unref-struct-sequence-integer-choice-capture-any-if-not-string-some-keyword-backmatch
  `````
[~{:main (sequence :thing -1)
   :thing (choice (unref (sequence :open :thing :close))
                  (capture (any (if-not "[" 1))))
   :open (capture (sequence "[" (some "_") "]")
                  :delim)
   :close (capture (backmatch :delim))}
 "[__][_]a[_][__]"]
  `````
)

