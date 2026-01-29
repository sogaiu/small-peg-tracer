#! /usr/bin/env janet

(use ./sh-dsl)

(prin "generating data.janet...") (flush)
(def gen-data-exit ($ janet dump-samples-data.janet))
(assertf (zero? gen-data-exit)
         "script exited: %d" gen-data-exit)
(print "done")

(prin "running jell...") (flush)
(def jell-exit ($ janet ./bin/jell))
(assertf (zero? jell-exit)
         "jell exited: %d" jell-exit)
(print "done")

(print "running niche...")
(def niche-exit ($ janet ./bin/niche.janet))
(assertf (zero? niche-exit)
         "niche exited: %d" niche-exit)
(print "done")

