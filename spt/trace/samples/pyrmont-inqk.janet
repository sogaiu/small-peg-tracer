[~{:main (* :tagged -1)
  :tagged (unref (replace (* :open-tag :value :close-tag) ,struct))
  :open-tag (* (constant :tag) "<" (capture :w+ :tag-name) ">")
  :value (* (constant :value) (group (any (+ :tagged :untagged))))
  :close-tag (drop (* "</" (cmt (* (backref :tag-name) (capture :w+)) ,=) ">"))
  :untagged (capture (some (if-not "<" 1)))}
 "<p><em>Hello</em> <strong>world</strong>!</p>"]
