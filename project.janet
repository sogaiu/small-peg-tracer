(declare-project
  :name "simple-peg-tracer"
  :url "https://github.com/sogaiu/simple-peg-tracer"
  :repo "git+https://github.com/sogaiu/simple-peg-tracer.git")

(declare-source
  :source @["spt"])

(declare-binscript
  :main "bin/spt"
  :is-janet true)

