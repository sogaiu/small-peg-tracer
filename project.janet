(declare-project
  :name "small-peg-tracer"
  :url "https://github.com/sogaiu/small-peg-tracer"
  :repo "git+https://github.com/sogaiu/small-peg-tracer.git")

(declare-source
  :source @["spt"])

(declare-binscript
  :main "bin/spt"
  :is-janet true)

