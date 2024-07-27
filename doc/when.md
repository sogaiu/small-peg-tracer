# When to Use small-peg-tracer

Some situations in which one might consider using `spt` include:

* Encountered some error or unexpected behavior for a particular
  `peg/match` call?  `spt` allows stepping through an execution trace
  for a `peg/match` call [1].  Displayed details might help in
  understanding the encountered situation better.  On a side note,
  `spt` was used a number of times in the process of working on `spt`
  itself :)

* Want to learn more about how a particular peg special works?  Come
  up with (or find [2]) some appropriate `peg/match` calls for `spt`
  to generate traces for.  Viewing and interacting with the generated
  traces might help build intuition and shape understanding of
  particular peg specials.

* Want to understand a particular `peg/match` call that seems to be
  doing something neat?  `spt` might help in gaining further insight.

[1] As noted elsewhere, the generated traces are not for `peg/match`,
but rather a mostly-compatible implementation `meg/match`.

[2] There are many `peg/match` example calls in the `examples`
directory of the [margaret](https://github.com/sogaiu/margaret)
repository.
