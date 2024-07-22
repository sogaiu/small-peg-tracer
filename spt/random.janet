(defn choose
  [things]
  (let [idx (math/rng-int (dyn :spt-rng
                               (math/rng (os/cryptorand 8)))
                          (length things))]
    (get things idx)))

(comment

  (do
    (def things
      [:a :b :c :x :y :z])

    (setdyn :spt-rng
            (math/rng (os/cryptorand 8)))

    (var result true)

    (for i 0 100
      (unless (index-of (choose things) things)
        (set result false)))

    result)
  # =>
  true

  )

