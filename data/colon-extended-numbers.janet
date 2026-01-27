[~{:main (drop (sequence (cmt (capture (some :num-char))
                              ,scan-number)
                         (opt (sequence ":" (range "AZ" "az")))))
   :num-char (choice (range "09" "AZ" "az")
                     (set "&+-_"))}
 "2:u"]
