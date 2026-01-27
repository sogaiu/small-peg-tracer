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
