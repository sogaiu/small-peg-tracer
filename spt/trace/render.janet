(import ../margaret/margaret/meg)
(import ./theme :as t)

(def first-evt-fname "first.html")
(def last-evt-fname "last.html")
(def evt-log-fname "log.html")
(def help-fname "help.html")

(def dump-filename "dump.jdn")

(defn bg-color []
  (get (dyn :spt-theme t/dark-theme) :bg-color))
(defn sk-color []
  (get (dyn :spt-theme t/dark-theme) :shortcut-key-color))
(defn link-color []
  (get (dyn :spt-theme t/dark-theme) :link-color))
(defn s-color []
  (get (dyn :spt-theme t/dark-theme) :success-color))
(defn f-color []
  (get (dyn :spt-theme t/dark-theme) :fail-color))
(defn cf-color []
  (get (dyn :spt-theme t/dark-theme) :current-frame-color))
(defn txt-color []
  (get (dyn :spt-theme t/dark-theme) :text-color))

########################################################################

(defn event?
  [cand]
  (and (dictionary? cand)
       (has-key? cand :event-num)
       (has-key? cand :frame-num)
       (has-key? cand :type)
       (get {:entry true :exit true :error true} (get cand :type))
       (if (= :exit (get cand :type))
         (has-key? cand :ret)
         true)
       (if (= :error (get cand :type))
         (has-key? cand :err)
         true)
       (has-key? cand :index)
       (has-key? cand :peg)
       (has-key? cand :grammar)
       (has-key? cand :state)))

(comment

  (event? '{:event-num 0
            :type :entry
            :frame-num 0
            :index 0
            :peg (sequence (capture (some "smile") :x) (backref :x))
            :grammar @{:main (sequence (capture (some "smile") :x)
                                       (backref :x))}
            :state @{:original-text "smile!"
                     :extrav []
                     :has-backref true
                     :outer-text-end 6
                     #
                     :text-start 0
                     :text-end 6
                     #
                     :captures @[]
                     :tagged-captures @[]
                     :tags @[]
                     #
                     :scratch @""
                     :mode :peg-mode-normal
                     #
                     :linemap @[]
                     :linemaplen -1
                     #
                     :grammar (sequence (capture (some "smile") :x)
                                        (backref :x))
                     :start 0}})
  # =>
  true

  (event? '{:event-num 11
            :type :exit
            :frame-num 0
            :ret 5
            :index 0
            :peg (sequence (capture (some "smile") :x) (backref :x))
            :grammar @{:main (sequence (capture (some "smile") :x)
                                       (backref :x))}
            :state @{:original-text "smile!"
                     :extrav []
                     :has-backref true
                     :outer-text-end 6
                     #
                     :text-start 0
                     :text-end 6
                     #
                     :captures @["smile" "smile"]
                     :tagged-captures @["smile" "smile"]
                     :tags @[:x :x]
                     #
                     :scratch @""
                     :mode :peg-mode-normal
                     #
                     :linemap @[]
                     :linemaplen -1
                     #
                     :grammar (sequence (capture (some "smile") :x)
                                        (backref :x))
                     :start 0}})
  # =>
  true

  (event? '{:event-num 8
            :type :error
            :frame-num 3
            :err "match error at line 1, column 1"
            :index 0
            :peg (error "")
            :grammar @{:main (choice "a" "b" (error ""))}
            :state @{:original-text "c"
                     :extrav []
                     :has-backref false
                     :outer-text-end 1
                     #
                     :text-start 0
                     :text-end 6
                     #
                     :captures @[]
                     :tagged-captures @[]
                     :tags @[]
                     #
                     :scratch @""
                     :mode :peg-mode-normal
                     #
                     :linemap @[]
                     :linemaplen 0
                     #
                     :grammar (choice "a" "b" (error ""))
                     :start 0}})
  # =>
  true

  (event? {:type :exit})
  # =>
  false

  )

(defn entry?
  [event]
  (= :entry (get event :type)))

(defn exit?
  [event]
  (= :exit (get event :type)))

(defn error?
  [event]
  (= :error (get event :type)))

########################################################################

(defn escape
  [x]
  (->> x
       (peg/match
         ~(accumulate (any (choice (sequence `"` (constant "&quot;"))
                                   (sequence "&" (constant "&amp;"))
                                   (sequence "'" (constant "&#39;"))
                                   (sequence "<" (constant "&lt;"))
                                   (sequence ">" (constant "&gt;"))
                                   (capture 1)))))
       first))

(comment

  (escape "<function replacer>")
  # =>
  "&lt;function replacer&gt;"

  )

(defn entry-event-num
  [frm-num events]
  (def event (find |(when (entry? $)
                      (= (get $ :frame-num) frm-num))
                   events))
  (assert event
          (string/format "failed to find event for frm-num: %d" frm-num))
  #
  (get event :event-num))

(comment

  (entry-event-num 1 @[{:type :entry :frame-num 1 :event-num 0}
                       {:type :exit :frame-num 1 :event-num 1}])
  # =>
  0

  )

(defn first-event?
  [event events]
  (deep= event (first events)))

(defn last-event?
  [event events]
  (deep= event (last events)))

########################################################################

(def shortcut-keys-via-js
  ``
  <script>
  function handleKbdEvent(event) {
    // https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key
    const keyName = event.key;

    if (keyName === "?") {
      document.getElementById('help').click();
    } else if (keyName === "u") {
      document.getElementById('up').click();
    } else if (keyName === "g") {
      document.getElementById('log').click();
    } else if (keyName === "f") {
      document.getElementById('first').click();
    } else if (keyName === "p") {
      document.getElementById('prev').click();
    } else if (keyName === "t") {
      document.getElementById('entry').click();
    } else if (keyName === "x") {
      document.getElementById('exit').click();
    } else if (keyName === "n") {
      document.getElementById('next').click();
    } else if (keyName === "l") {
      document.getElementById('last').click();
    } else {
      //
    }

    console.log(event);
  }
  // https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
  document.addEventListener("keydown", handleKbdEvent);
  </script>
  ``)

(defn render-scripts
  [buf]
  (buffer/push buf shortcut-keys-via-js))

(defn render-nav-item
  [buf name key-idx active]
  (if active
    (do
      (def left (string/slice name 0 key-idx))
      (def right (string/slice name (inc key-idx)))
      (def span (string left
                        `<span style="color: ` (sk-color) `">`
                        (string/slice name key-idx (inc key-idx))
                        `</span>`
                        right))
      (buffer/push buf
                   `<a `
                   `style="color: ` (link-color) `" `
                   `id="` name `" `
                   `href="` (string active) ".html"
                   `">[` span `]</a>`))
    (buffer/push buf "[" name "]")))

(defn render-nav
  [buf beg entry prv nxt exit end]
  (buffer/push buf "<pre>")
  (buffer/push buf
               `<a `
               `style="color: ` (link-color) `" `
               `id="up" `
               `href="` ".."
               `">[<span style="color: ` (sk-color) `">u</span>p]</a>`)
  (buffer/push buf " ")
  (buffer/push buf
               `<a `
               `style="color: ` (link-color) `" `
               `id="log" `
               `href="` evt-log-fname
               `">[lo<span style="color: ` (sk-color) `">g</span>]</a>`)
  (buffer/push buf " ")
  (buffer/push buf
               `<a `
               `style="color: ` (link-color) `" `
               `id="help" `
               `href="` help-fname
               `">[<span style="color: ` (sk-color) `">?</span>]</a>`)
  (buffer/push buf "\n")

  (render-nav-item buf "first" 0 beg)
  (buffer/push buf " ")

  (render-nav-item buf "prev" 0 prv)
  (buffer/push buf " ")

  (render-nav-item buf "entry" 2 entry)
  (buffer/push buf " ")

  (render-nav-item buf "exit" 1 exit)
  (buffer/push buf " ")

  (render-nav-item buf "next" 0 nxt)
  (buffer/push buf " ")

  (render-nav-item buf "last" 0 end)

  (buffer/push buf "</pre>"))

(defn ret-as-str
  [ret]
  (cond
    (= :nil ret)
    "nil"
    #
    (number? ret)
    (string ret)
    #
    (errorf "ret not :nil or number: %n" ret)))

########################################################################

(defn render-text-param
  [buf event ret spaces]
  (def original-text (get-in event [:state :original-text]))
  (def boundary
    (if (or (entry? event)
            (= ret :nil))
      (get event :index)
      ret))
  (def left (string/slice original-text 0 boundary))
  (def right (string/slice original-text boundary))
  (buffer/push buf
               "\n" spaces
               `"`
               `<span style="color: ` (s-color) `">`
               (escape (string/slice (string/format "%n" left) 1 -2))
               `</span>`
               `<span style="color: ` (f-color) `">`
               (escape (string/slice (string/format "%n" right) 1 -2))
               `</span>`
               `"`))

(defn render-start-and-args
  [buf event spaces]
  (def start (get-in event [:state :start]))
  (def args (get-in event [:state :extrav]))
  (cond
    (not (empty? args))
    (do
      (buffer/push buf
                   "\n" spaces
                   (escape (string start)))
      (buffer/push buf
                   "\n" spaces
                   # this adds one space too many
                   ;(map |(escape (string/format "%n " $)) args))
      # remove last space
      (buffer/popn buf 1))
    #
    (not (zero? start))
    (buffer/push buf
                 "\n" spaces
                 (escape (string start)))))

(defn render-result
  [buf event events ret]
  (when (and (exit? event)
             (last-event? event events))
    (def ret-str (ret-as-str ret))
    (def outer-ret
      (if (= "nil" ret-str)
        "nil"
        (string/format "%n" (get-in event [:state :captures]))))
    (buffer/push buf "\n# =>\n")
    (buffer/push buf
                 (if (= "nil" ret)
                   (string `<span style="color: ` (f-color) `">`)
                   (string `<span style="color: ` (s-color) `">`))
                 outer-ret
                 `</span>`))

  (when (and (error? event)
             (last-event? event events))
    (def err (get event :err))
    (buffer/push buf (escape "\n# <error>\n"))
    (buffer/push buf
                 `<span style="color: ` (f-color) `">`
                 err
                 `</span>`)))

(defn render-match-params
  [buf event ret events]
  (def spaces
    (string/repeat " " (length "(meg/match ")))
  # XXX: hard-wiring tilde here...is that good enough?
  (buffer/push buf
               "<pre>(meg/match ~"
               (escape (string/format "%n"
                                      (get-in event [:state :grammar]))))
  (render-text-param buf event ret spaces)
  (render-start-and-args buf event spaces)
  (buffer/push buf ")")

  (render-result buf event events ret)

  (buffer/push buf "</pre>"))

########################################################################

(defn render-captures-et-al
  [buf event]
  (buffer/push buf "<pre><u>captures and tags</u></pre>")

  (buffer/push buf
               "<pre>captures: "
               (escape (string/format "%n" (get-in event [:state :captures])))
               "</pre>")

  (def tags (get-in event [:state :tags]))
  (def tagged-captures (get-in event [:state :tagged-captures]))
  (when (not (empty? tagged-captures))
    (buffer/push buf
                 "<pre>tagged-captures:\n"
                 "  tags: " (escape (string/format "%n" tags)) "\n"
                 "  values: "
                 (escape (string/format "%n" tagged-captures)) "\n"
                 "</pre>"))

  (def mode (get-in event [:state :mode]))
  (when (= mode :peg-mode-accumulate)
    (buffer/push buf
                 "<pre>mode: "
                 (escape mode)
                 "</pre>")
    (buffer/push buf
                 "<pre>scratch: "
                 `@"`
                 (escape (get-in event [:state :scratch]))
                 `"`
                 "</pre>")))

########################################################################

(defn render-summary
  [buf event ret events]
  (buffer/push buf "<pre>status: ")

  (case (get event :type)
    :entry
    (buffer/push buf
                 `<span style="color: ` (s-color) `">` "entered" `</span>`)
    :exit
    (buffer/push buf
                 `<span style="color: ` (f-color) `">` "exiting" `</span>`)
    :error
    (buffer/push buf
                 `<span style="color: ` (f-color) `">` "errored in" `</span>`))

  (def frm-num (get event :frame-num))
  (assert frm-num
          (string/format "failed to find event number for event: %n"
                         event))

  (buffer/push buf
               " frame "
               `<span style="color: ` (cf-color) `">` (string frm-num)
               `</span>`)

  (when (exit? event)
    (def ret-str (ret-as-str ret))
    (buffer/push buf
                 " with value: "
                 (if (= "nil" ret)
                   (string `<span style="color: ` (f-color) `">`)
                   (string `<span style="color: ` (s-color) `">`))
                 ret-str
                 `</span>`))

  (buffer/push buf "</pre>"))

(defn render-peg-param
  [buf event]
  (buffer/push buf
               "<pre>peg: "
               `<span style="color: ` (cf-color) `">`
               (escape (string/format "%n" (get event :peg)))
               `</span>`
               "</pre>"))

(defn render-text-param
  [buf event ret text index]
  (buffer/push buf `<pre>text: `)
  (if (or (entry? event)
          (= ret :nil))
    (buffer/push buf
                 `<span style="color: ` (s-color) `">`
                 (escape (string/slice text 0 index))
                 `</span>`
                 `<span style="color: ` (f-color) `">`
                 (escape (string/slice text index))
                 `</span>`)
    (buffer/push buf
                 `<span style="color: ` (s-color) `">`
                 (escape (string/slice text 0 ret))
                 `</span>`
                 `<span style="color: ` (f-color) `">`
                 (escape (string/slice text ret))
                 `</span>`))
  (buffer/push buf `</pre>`))

(defn render-index-param
  [buf event ret index]
  (buffer/push buf
               "<pre>index: "
               (string (get event :index)))
  (when (exit? event)
    (when (and (number? ret) (> ret index))
      (buffer/push buf
                   " advanced to: "
                   `<span style="color: ` (s-color) `">` (string ret)
                   `</span>`)))
  (buffer/push buf "</pre>"))

(defn render-event-params
  [buf event ret events]
  (buffer/push buf "<pre><u>current frame</u></pre>")
  (render-summary buf event ret events)

  (render-peg-param buf event)

  (def text
    (string/slice (get-in event [:state :original-text])
                  (get-in event [:state :text-start])
                  (get-in event [:state :text-end])))
  (def index (get event :index))
  (render-text-param buf event ret text index)

  (render-index-param buf event ret index)

  (when (exit? event)
    (buffer/push buf "<pre>matched: ")
    (cond
      (= ret :nil)
      (buffer/push buf `<span style="color: ` (f-color) `">` "no" `</span>`)
      #
      (number? ret)
      (let [match-str (escape (string/slice text index ret))]
        (buffer/push buf
                     `<span style="color: ` (s-color) `">` match-str
                     `</span>`))
      #
      (errorf "ret not :nil or number: %n" ret))
    (buffer/push buf "</pre>")))

########################################################################

(defn render-backtrace
  [buf stack events]
  (def backtrace (reverse stack))
  (def top (first backtrace))
  (def top-frame-num (get top :frame-num))
  (def top-event-num (entry-event-num top-frame-num events))
  (buffer/push buf "<pre><u>frames call stack</u></pre>")
  (buffer/push buf
               "<pre>"
               `<span style="color: ` (cf-color) `">`
               (string `<a `
                       `style="color: ` (cf-color) `" `
                       `href="` top-event-num ".html" `">`
                       top-frame-num `</a>`
                       " " (escape (string/format "%n" (get top :peg)))
                       "\n")
               `</span>`
               ;(map |(let [frm-num (get $ :frame-num)
                            evt-num (entry-event-num frm-num events)
                            peg (get $ :peg)]
                        (string `<a `
                                `style="color: ` (link-color) `" `
                                `href="` evt-num ".html" `">`
                                frm-num `</a>`
                                " " (escape (string/format "%n" peg))
                                "\n"))
                     (drop 1 backtrace))
               "</pre>"))

########################################################################

(defn count-digits
  [num]
  (if (zero? num)
    1
    (math/floor (+ (math/log10 num) 1))))

(comment

  (count-digits 0)
  # =>
  1

  (count-digits 1)
  # =>
  1

  (count-digits 9)
  # =>

  (count-digits 10)
  # =>
  2

  (count-digits 99)
  # =>
  2

  (count-digits 100)
  # =>
  3

  (count-digits 1000)
  # =>
  4

  )

(defn max-frame-num
  [events]
  (assert (not (empty? events)) "events should be non-empty")

  (var max-frm-num nil)
  (each evt events
    (def frm-num (get evt :frame-num))
    (when (or (nil? max-frm-num)
              (> frm-num max-frm-num))
      (set max-frm-num frm-num)))
  #
  max-frm-num)

(defn render-event-log
  [buf events]
  (def max-digits (count-digits (max-frame-num events)))
  (buffer/push buf
               "<!doctype html>\n"
               "<html>\n"
               `<body `
               `style="color: ` (txt-color) `; `
               `background-color: ` (bg-color) `">`
               "\n"
               "<pre><u>event log</u></pre>"
               "<pre>"
               ;(map |(let [frm-num (get $ :frame-num)
                            evt-num (get $ :event-num)
                            peg (get $ :peg)
                            n-digits (count-digits frm-num)
                            pad (string/repeat " "
                                               (- max-digits n-digits))
                            filler (string/repeat " " 2)
                            link (string pad
                                         `<a `
                                         `style="color: ` (link-color) `" `
                                         `href="` evt-num ".html" `">`
                                         frm-num
                                         `</a>`)]
                        (string (if (entry? $) "> " filler)
                                link
                                (cond
                                  (exit? $) " >"
                                  (error? $) " E"
                                  filler)
                                " " (escape (string/format "%n" peg))
                                "\n"))
                     events)
               "</pre>\n"
               "</body>\n"
               "</html>\n"))

########################################################################

(defn find-entry-event-num
  [event events]
  (assert (or (exit? event) (error? event))
          (string/format "expected exit or error, got: %n" event))

  (def frm-num (get event :frame-num))
  (def entry
    (find |(and (entry? $)
                (= frm-num (get $ :frame-num)))
          events))
  (assert entry
          (string/format "failed to find entry for: %n" event))
  #
  (get entry :event-num))

(defn find-exit-or-error-event-num
  [event events]
  (assert (entry? event)
          (string/format "expected entry, got: %n" event))

  (def frm-num (get event :frame-num))
  (def exit-or-error
    (find |(and (or (exit? $) (error? $))
                (= frm-num (get $ :frame-num)))
          events))
  # sometimes there won't be a corresponding exit or error
  (when exit-or-error
    (get exit-or-error :event-num)))

(defn render-event
  [event prv nxt stack events]
  (def buf @"")
  (def ret (when (exit? event)
             (get event :ret)))
  (def beg (when (not (first-event? event events))
             0))
  (def end (when (not (last-event? event events))
             (dec (length events))))
  (def entry (when (or (exit? event) (error? event))
               (find-entry-event-num event events)))
  (def exit-or-error (when (entry? event)
                       (find-exit-or-error-event-num event events)))

  (buffer/push buf "<!doctype html>\n")

  (buffer/push buf "<html>\n")

  (buffer/push buf "<head>\n")
  (render-scripts buf)
  (buffer/push buf "</head>\n")

  (buffer/push buf
               `<body `
               `style="color: ` (txt-color) `; `
               `background-color: ` (bg-color) `">`
               "\n")

  (render-nav buf beg entry prv nxt exit-or-error end)
  (buffer/push buf "<hr>")

  (render-match-params buf event ret events)
  (buffer/push buf "<hr>")

  (render-captures-et-al buf event)
  (buffer/push buf "<hr>")

  (render-event-params buf event ret events)
  (buffer/push buf "<hr>")

  (render-backtrace buf stack events)

  (buffer/push buf "</body>\n")

  (buffer/push buf "</html>\n")

  buf)

########################################################################

(defn events?
  [cand]
  (assert (array? cand)
          (string/format "expected array but found %s" (type cand)))
  #
  (each item cand
    (assert (event? item)
            (string/format "invalid event: %n" item)))
  #
  true)

########################################################################

(defn render-events
  [events]
  (def stack @[])
  (eachp [idx event] events
    (when (entry? event)
      (array/push stack event))

    (def prv
      (if (zero? idx) nil (dec idx)))
    (def nxt
      (if (= idx (dec (length events))) nil (inc idx)))

    (spit (string/format "%d.html" idx)
          (render-event event prv nxt stack events))

    (when (exit? event)
      (assert (= (get event :frame-num)
                 (get (array/peek stack) :frame-num))
              (string/format "mismatch - expected: %d, but got: %d"
                             (get event :frame-num)
                             (get (array/peek stack) :frame-num)))
      (array/pop stack))))

########################################################################

(defn render
  ````
  Render HTML files to represent a `meg/match` call.

  Arguments:

  The arguments correpsond to those for `meg/match`:

  * peg
  * text
  * start (optional)
  * args (optional)

  Return value:

  Upon success, returns the trace events.

  Output:

  Resulting HTML files representing individual "events" have names
  like `0.html`, `1.html`, etc.  That is, an integer followed by
  `.html`.

  Each "event" represents a peg "call" in a trace of the execution
  of the "outer" `meg/match` call.  The first event is represented by
  `0.html`, the next event by `1.html`, etc.

  A file with links to all event files is also created with name
  "all.html".

  A raw log of events is also created with name "dump.jdn".

  All files are created in the current directory.

  ````
  [peg text &opt start & args]
  (default start 0)
  (default args [])

  # XXX: check peg, text, start, and args?

  (with [of (file/temp)]
    (os/setenv "VERBOSE" "1")
    (setdyn :meg-trace of)
    (setdyn :meg-color false)

    (try
      (meg/match peg text start ;args)
      ([e]
        (eprin "Match call resulted in an error: ")
        (eprintf e)
        # not an error that is the result of a call to peg-match
        (when (not (dyn :meg-error))
          (error e))))

    (file/seek of :set 0)
    (def content (file/read of :all))
    (assert (not (empty? content)) "trace empty")

    (def [success? events] (protect (parse-all content)))
    (assert success? "failed to parse trace data")
    (assert (events? events) "invalid events")

    # XXX: raw log for debugging
    (spit dump-filename (string/format "%n" events))

    (spit evt-log-fname (render-event-log @"" events))

    (render-events events)

    # make some special-case aliases (actually duplicates)
    (spit first-evt-fname (slurp "0.html"))
    (spit last-evt-fname (slurp (string (dec (length events)) ".html")))

    (spit help-fname
          ``
          <pre><u>help page</u></pre>
          <hr>
          <pre><u>background</u></pre>
          <pre>
          each call to `peg/match` can be thought of
          as consisting of a sequence of events
          corresponding to entries into, exits out of,
          and/or erroring out of a sequence of peg
          "call" frames.  each spt trace consists of
          a series of such events.

          each event has its own html file showing
          information about the event.  there are
          links / shortcuts that can be used to
          navigate to related event files.
          </pre>
          <hr>
          <pre><u>navigation / shortcuts</u></pre>
          <pre>
          <u>u</u>p - navigate up a level
          lo<u>g</u> - view event log for current trace
          <u>?</u> - view help (this page)

          <u>f</u>irst - go to first event
          <u>l</u>ast - go to last event

          <u>p</u>rev - go to previous event
          <u>n</u>ext - go to next event

          en<u>t</u>ry - go to entry event for current frame
          e<u>x</u>it - go to exit event for current frame
          </pre>
          ``)

    events))

########################################################################

(defn args-from-cmd-line
  [& argv]
  (assert (>= (length argv) 2)
          (string/format "at least peg and string required"))

  (def peg
    (let [cand (get argv 0)]
      (assert cand "expected peg, got nothing")

      (def [success? result] (protect (parse cand)))
      (assert success?
              (string/format "failed to parse peg, got:\n  `%s`"
                             result))
      result))

  (assert (meg/analyze peg)
          (string/format "problem with peg: %n" peg))

  (def text
    (let [result (get argv 1)]
      (assert result "expected text, got nothing")
      result))

  (def start
    (let [result (scan-number (get argv 2 "0"))]
      (assert result
              (string/format "expected number or nothing, got: %s"
                             (get argv 2)))
      result))

  # XXX: should check for errors and report here...
  (def args
    (map parse (drop 3 argv)))

  {:peg peg
   :text text
   :start start
   :args args})

########################################################################

(defn main
  ````
  A wrapper function around `render`.

  The arguments are assumed to result from a command line invocation
  and should all be strings.  The first argument will be ignored as it
  represents the "executing" file.  The subsequent arguments should be
  strings representing values (which the code will try to "cast"
  appropriately) that are to be passed to `meg/match`.

  A suitable command line invocation might be:

  ```
  render.janet '(capture "b")' "ab" 1
  ```
  ````
  [& argv]
  (def {:peg peg
        :text text
        :start start
        :args args}
    (args-from-cmd-line ;(drop 1 argv)))
  #
  (render peg text start ;args))

