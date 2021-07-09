
{} (:package |app)
  :configs $ {} (:init-fn |app.server/main!) (:reload-fn |app.server/reload!)
    :modules $ [] |lilac/ |memof/ |recollect/ |respo.calcit/ |respo-ui.calcit/ |respo-ui.calcit/ |respo-message.calcit/ |cumulo-util.calcit/ |ws-edn.calcit/ |respo-feather.calcit/ |alerts.calcit/ |respo-markdown.calcit/ |bisection-key/
    :version |0.6.0-a3
  :files $ {}
    |app.comp.page-members $ {}
      :ns $ quote
        ns app.comp.page-members $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp <> list-> span div a
          [] respo.comp.space :refer $ [] =<
          [] "\"url-parse" :default url-parse
      :defs $ {}
        |comp-page-members $ quote
          defcomp comp-page-members (router-data session-id)
            div
              {} $ :style (merge ui/flex style-members)
              list-> ({})
                -> router-data (.to-list)
                  map $ fn (entry)
                    let-sugar
                          [] k member
                          , entry
                        member-name $ if
                          some? $ :user member
                          get-in member $ [] :user :nickname
                          , |Guest
                      [] k $ div
                        {} (:style style-row)
                          :on $ {}
                            :click $ on-watch k
                        <>
                          str member-name $ if (= k session-id) "| (yourself)"
                          , style-name
                        =< 32 nil
                        <> (:page member) style-page
                        =< 32 nil
                        let
                            bookmark $ :bookmark member
                          if (some? bookmark)
                            <>
                              str (:kind bookmark) "| " (:ns bookmark) "| " (:extra bookmark) "| _"
                                join-str (:focus bookmark) |_
                                , |_
                              , style-bookmark
                        =< 32 nil
                        if (= k session-id)
                          a
                            {}
                              :href $ let
                                  url-obj $ url-parse js/location.href true
                                aset (.-query url-obj) "\"watching" k
                                .toString url-obj
                              :target |_blank
                              :style $ {}
                                :color $ hsl 240 80 80
                            <> "|Watching url" nil
        |on-watch $ quote
          defn on-watch (session-id)
            fn (e d!)
              d! :router/change $ {} (:name :watching) (:data session-id)
        |style-bookmark $ quote
          def style-bookmark $ {} (:font-family |Menlo,monospace) (:min-width 200) (:display :inline-block)
        |style-members $ quote
          def style-members $ {} (:padding "|0 16px")
        |style-name $ quote
          def style-name $ {} (:min-width 160) (:display :inline-block)
        |style-page $ quote
          def style-page $ {} (:min-width 160) (:display :inline-block)
        |style-row $ quote
          def style-row $ {} (:cursor :pointer)
      :proc $ quote ()
    |app.updater.configs $ {}
      :ns $ quote (ns app.updater.configs)
      :defs $ {}
        |update-configs $ quote
          defn update-configs (db op-data session-id op-id op-time)
            update db :configs $ fn (configs) (merge configs op-data)
      :proc $ quote ()
      :configs $ {}
    |app.polyfill $ {}
      :ns $ quote (ns app.polyfill)
      :defs $ {}
        |text-width* $ quote
          defn text-width* (content font-size font-family)
            if (some? ctx)
              do
                set! (.-font ctx) (str font-size "\"px " font-family)
                .-width $ .!measureText ctx content
              , nil
        |ctx $ quote
          def ctx $ if
            and (exists? js/document) (exists? js/window)
            .!getContext (.!createElement js/document "\"canvas") "\"2d"
            , nil
      :proc $ quote ()
      :configs $ {}
    |app.comp.bookmark $ {}
      :ns $ quote
        ns app.comp.bookmark $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp <> span div a
          [] respo.comp.space :refer $ [] =<
      :defs $ {}
        |style-minor $ quote
          def style-minor $ {}
            :color $ hsl 0 0 40
            :font-size 12
        |on-pick $ quote
          defn on-pick (bookmark idx)
            fn (e d!)
              let
                  event $ :original-event e
                  shift? $ .-shiftKey event
                  alt? $ .-altKey event
                  meta? $ .-metaKey event
                cond
                  meta? $ d! :writer/collapse idx
                  alt? $ d! :writer/remove-idx idx
                  :else $ d! :writer/point-to idx
        |style-highlight $ quote
          def style-highlight $ {}
            :color $ hsl 0 0 100
        |style-kind $ quote
          def style-kind $ {}
            :color $ hsl 340 80 60
            :font-family ui/font-normal
            :font-size 12
            :margin-right 4
            :vertical-align :middle
        |style-bookmark $ quote
          def style-bookmark $ {} (:line-height |1.2em) (:padding "|4px 8px") (:cursor :pointer) (:position :relative) (:white-space :nowrap)
        |comp-bookmark $ quote
          defcomp comp-bookmark (bookmark idx selected?)
            div
              {} (:class-name |stack-bookmark) (:draggable true)
                :on-click $ on-pick bookmark idx
                :on-dragstart $ fn (e d!)
                  -> e :event .-dataTransfer $ .setData "\"id" idx
                :on-drop $ fn (e d!)
                  let
                      target-idx $ js/parseInt
                        -> e :event .-dataTransfer $ .getData "\"id"
                    when (not= target-idx idx)
                      d! :writer/move-order $ {} (:from target-idx) (:to idx)
                :on-dragover $ fn (e d!) (-> e :event .preventDefault)
              case-default (:kind bookmark)
                div
                  {} $ :style
                    merge style-bookmark $ {} (:padding "\"8px")
                  <>
                    str $ :kind bookmark
                    , style-kind
                  <> (:ns bookmark)
                    merge style-main $ if selected? style-highlight
                :def $ div
                  {} $ :style (merge style-bookmark)
                  div ({})
                    span $ {}
                      :inner-text $ :extra bookmark
                      :style $ merge style-main (if selected? style-highlight)
                  div
                    {} $ :style ui/row-middle
                    =< 4 nil
                    <> (:ns bookmark) style-minor
        |style-main $ quote
          def style-main $ {} (:vertical-align :middle)
            :color $ hsl 0 0 70
            :font-family ui/font-normal
      :proc $ quote ()
    |app.updater.user $ {}
      :ns $ quote
        ns app.updater.user $ :require
          [] app.util :refer $ [] find-first push-warning
          [] clojure.string :as string
          [] |md5 :default md5
          [] app.schema :as schema
      :defs $ {}
        |change-theme $ quote
          defn change-theme (db op-data sid op-id op-time)
            let
                user-id $ get-in db ([] :sessions sid :user-id)
              -> db
                assoc-in ([] :users user-id :theme) op-data
                assoc-in ([] :sessions sid :theme) op-data
        |log-in $ quote
          defn log-in (db op-data session-id op-id op-time)
            let-sugar
                  [] username password
                  , op-data
                maybe-user $ find-first
                  fn (user)
                    and $ = username (:name user)
                  vals $ :users db
              update-in db ([] :sessions session-id)
                fn (session)
                  if (some? maybe-user)
                    if
                      = (md5 password) (:password maybe-user)
                      -> session $ assoc :user-id (:id maybe-user)
                      update session :notifications $ push-warning op-id op-time (str "|Wrong password for " username)
                    update session :notifications $ push-warning op-id op-time (str "|No user named: " username)
        |log-out $ quote
          defn log-out (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :user-id) nil
        |nickname $ quote
          defn nickname (db op-data sid op-id op-time)
            let
                user-id $ get-in db ([] :sessions sid :user-id)
              assoc-in db ([] :users user-id :nickname)
                if (blank? op-data) |Someone op-data
        |sign-up $ quote
          defn sign-up (db op-data session-id op-id op-time)
            let-sugar
                  [] username password
                  , op-data
                maybe-user $ find-first
                  fn (user)
                    = username $ :name user
                  vals $ :users db
                new-user-id $ str "\"u"
                  count $ :users db
              if (some? maybe-user)
                update-in db ([] :sessions session-id :notifications)
                  push-warning op-id op-time $ str "|Name is token: " username
                -> db
                  assoc-in ([] :sessions session-id :user-id) new-user-id
                  assoc-in ([] :users new-user-id)
                    merge schema/user $ {} (:id new-user-id) (:name username) (:nickname username)
                      :password $ md5 password
      :proc $ quote ()
    |app.comp.watching $ {}
      :ns $ quote
        ns app.comp.watching $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> span div input pre a
          [] respo.comp.space :refer $ [] =<
          [] keycode.core :as keycode
          [] app.client-util :as util
          [] app.style :as style
          [] app.comp.expr :refer $ [] comp-expr
          [] app.theme :refer $ [] base-style-leaf base-style-expr
          [] app.util.dom :refer $ [] inject-style
          [] app.util :refer $ [] bookmark-full-str
          [] app.comp.theme-menu :refer $ [] comp-theme-menu
      :defs $ {}
        |comp-watching $ quote
          defcomp comp-watching (states router-data theme)
            let
                expr $ :expr router-data
                focus $ :focus router-data
                bookmark $ :bookmark router-data
                others $ {}
                member-name $ get-in router-data ([] :member :nickname)
                readonly? true
              if (nil? router-data)
                div
                  {} $ :style style-container
                  <> "|Session is missing!" nil
                if (:self? router-data)
                  div
                    {} $ :style style-container
                    <> "|Watching at yourself :)" style-title
                  div
                    {} $ :style (merge ui/column style-container)
                    when (:working? router-data)
                      div
                        {} $ :style
                          merge ui/flex $ {} (:overflow :auto)
                        inject-style |.cirru-expr $ base-style-expr (or theme :star-trail)
                        inject-style |.cirru-leaf $ base-style-leaf (or theme :star-trail)
                        comp-expr
                          >> states $ bookmark-full-str bookmark
                          , expr focus ([]) others false false readonly? false (or theme :star-trail) 0
                    =< nil 16
                    div ({}) (<> "|Watching mode" style-tip) (=< 16 nil) (<> member-name nil) (=< 16 nil)
                      <> (:kind bookmark) nil
                      =< 16 nil
                      <>
                        str (:ns bookmark) |/ $ :extra bookmark
                        , nil
                      =< 16 nil
                      comp-theme-menu (>> states :theme) (or theme :star-trail)
        |style-container $ quote
          def style-container $ {} (:padding "|0 16px")
        |style-tip $ quote
          def style-tip $ {} (:font-family "|Josefin Sans")
            :background-color $ hsl 0 0 100 0.3
            :border-radius |4px
            :padding "|4px 8px"
        |style-title $ quote
          def style-title $ {} (:font-family "|Josefin Sans")
      :proc $ quote ()
    |app.updater.router $ {}
      :ns $ quote (ns app.updater.router)
      :defs $ {}
        |change $ quote
          defn change (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :router) op-data
      :proc $ quote ()
    |app.comp.replace-name $ {}
      :ns $ quote
        ns app.comp.replace-name $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp <> span div pre input button img a br
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] respo-alerts.core :refer $ [] comp-modal Modal-class
      :defs $ {}
        |use-replace-name-modal $ quote
          defn use-replace-name-modal (states on-replace)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} (:old-name "\"") (:new-name "\"") (:show? false)
                on-submit $ fn (d!) (; "\"special trick to use spaces to remove a leaf")
                  when
                    and
                      not $ blank? (:old-name state)
                      not $ = (:new-name state) "\""
                    on-replace (:old-name state) (:new-name state) d!
                    d! cursor $ assoc state :show? false
              ::
                %{} Modal-class
                  :render $ fn (self) (nth self 1)
                  :show $ fn (self d!)
                    d! cursor $ assoc state :show? true
                  :clonse $ fn (self d!)
                    d! cursor $ assoc state :show? false
                comp-modal
                  {} (:title "\"Replace variable")
                    :style $ {} (:width 240)
                    :container-style $ {}
                    :render-body $ fn (? arg)
                      div
                        {} $ :style
                          {} $ :padding 16
                        div ({})
                          input $ {} (:placeholder "\"from...")
                            :style $ merge ui/input
                              {} $ :font-family ui/font-code
                            :value $ :old-name state
                            :autofocus true
                            :id "\"replace-input"
                            :on-input $ fn (e d!)
                              d! cursor $ assoc state :old-name (:value e)
                        =< nil 8
                        div ({})
                          input $ {} (:placeholder "\"to...")
                            :style $ merge ui/input
                              {} $ :font-family ui/font-code
                            :on-input $ fn (e d!)
                              d! cursor $ assoc state :new-name (:value e)
                            :value $ :new-name state
                            :on-keydown $ fn (e d!)
                              if
                                = 13 $ :key-code e
                                on-submit d!
                        =< nil 8
                        div
                          {} $ :style ui/row-parted
                          span nil
                          button $ {} (:style ui/button) (:inner-text "\"Replace")
                            :on-click $ fn (e d!) (on-submit d!)
                  :show? state
                  fn (d!)
                    d! cursor $ assoc state :show? false
                :show $ fn (d!)
                  d! cursor $ assoc state :old-name "\"" :new-name "\"" :show? true
                  js/setTimeout $ fn ()
                    let
                        el $ js/document.querySelector "\"#replace-input"
                      if (some? el) (.select el)
      :proc $ quote ()
      :configs $ {}
    |app.util.shortcuts $ {}
      :ns $ quote
        ns app.util.shortcuts $ :require ([] app.keycode :as keycode)
          [] app.util.dom :refer $ [] focus-search!
          [] app.util.list :refer $ [] cirru-form?
      :defs $ {}
        |on-paste! $ quote
          defn on-paste! (d!)
            -> js/navigator .-clipboard (.readText)
              .then $ fn (text) (println "\"read from text...")
                let
                    cirru-code $ parse-cirru text
                  if (cirru-form? cirru-code)
                    d! :writer/paste $ first cirru-code
                    d! :notify/push-message $ [] :error "\"Not valid code"
              .catch $ fn (error) (.error js/console "\"Not able to read from paste:" error)
                d! :notify/push-message $ [] :error "\"Failed to paste!"
        |on-window-keydown $ quote
          defn on-window-keydown (event dispatch! router)
            if (some? router)
              let
                  meta? $ or (.-metaKey event) (.-ctrlKey event)
                  shift? $ .-shiftKey event
                  code $ .-keyCode event
                cond
                    and meta? $ or (= code keycode/p) (= code keycode/o)
                    do
                      dispatch! :router/change $ {} (:name :search)
                      focus-search!
                      .!preventDefault event
                  (and meta? (= code keycode/e))
                    if shift?
                      do $ dispatch! :effect/eval-tree
                      dispatch! :writer/edit-ns nil
                  (and meta? (not shift?) (= code keycode/j))
                    do (.preventDefault event) (dispatch! :writer/move-next nil)
                  (and meta? (not shift?) (= code keycode/i))
                    do $ dispatch! :writer/move-previous nil
                  (and meta? (= code keycode/k))
                    do $ dispatch! :writer/finish nil
                  (and meta? (= code keycode/s))
                    do (.preventDefault event) (dispatch! :effect/save-files nil)
                  (and meta? shift? (= code keycode/f))
                    dispatch! :router/change $ {} (:name :files)
                  (and meta? (not shift?) (= code keycode/period))
                    dispatch! :writer/picker-mode nil
      :proc $ quote ()
    |app.comp.login $ {}
      :ns $ quote
        ns app.comp.login $ :require
          [] respo.core :refer $ [] defcomp >> <> div input button span
          [] respo.comp.space :refer $ [] =<
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo-ui.core :as ui
          [] app.style :as style
          [] app.config :as config
      :defs $ {}
        |comp-login $ quote
          defcomp comp-login (states)
            let
                cursor $ :cursor states
                state $ or (:data states) initial-state
              div
                {} $ :style style-login
                div
                  {} $ :style ({})
                  div ({})
                    input $ {} (:placeholder |Username)
                      :value $ :username state
                      :style style/input
                      :on-input $ on-input state cursor :username
                  =< nil 8
                  div ({})
                    input $ {} (:placeholder |Password)
                      :value $ :password state
                      :style style/input
                      :on-input $ on-input state cursor :password
                =< nil 8
                div
                  {} $ :style style-control
                  button $ {} (:inner-text "|Sign up") (:style style/button)
                    :on-click $ on-submit (:username state) (:password state) true
                  =< 8 nil
                  button $ {} (:inner-text "|Log in") (:style style/button)
                    :on-click $ on-submit (:username state) (:password state) false
        |initial-state $ quote
          def initial-state $ {} (:username |) (:password |)
        |on-input $ quote
          defn on-input (state cursor k)
            fn (e dispatch!)
              dispatch! cursor $ assoc state k (:value e)
        |on-submit $ quote
          defn on-submit (username password signup?)
            fn (e dispatch!)
              dispatch! (if signup? :user/sign-up :user/log-in) ([] username password)
              .setItem js/window.localStorage (:storage-key config/site)
                format-cirru-edn $ [] username password
        |style-control $ quote
          def style-control $ merge ui/flex
            {} $ :text-align :right
        |style-login $ quote
          def style-login $ {} (:padding 16)
      :proc $ quote ()
    |app.util.dom $ {}
      :ns $ quote
        ns app.util.dom $ :require
          [] respo.core :refer $ [] style
          [] respo.render.html :refer $ [] style->string
          [] cumulo-util.core :refer $ [] delay!
      :defs $ {}
        |copy-silently! $ quote
          defn copy-silently! (x)
            -> js/navigator .-clipboard (.writeText x)
              .then $ fn () (println "\"Copied.")
              .catch $ fn (error) (.error js/console "\"Failed to copy:" error)
        |do-copy-logics! $ quote
          defn do-copy-logics! (d! x message)
            -> js/navigator .-clipboard (.writeText x)
              .then $ fn (? v)
                d! :notify/push-message $ [] :info message
              .catch $ fn (error) (.error js/console "\"Failed to copy:" error)
                d! :notify/push-message $ [] :error (str "\"Failed to copy! " error)
        |focus! $ quote
          defn focus! () $ js/requestAnimationFrame
            fn (timestamp)
              let
                  current-focused $ .-activeElement js/document
                  cirru-focused $ .querySelector js/document |.cirru-focused
                if (some? cirru-focused)
                  if
                    not $ identical? current-focused cirru-focused
                    .!focus cirru-focused
                  println "|[Editor] .cirru-focused not found" cirru-focused
        |focus-search! $ quote
          defn focus-search! () $ delay! 0.2
            fn () $ let
                target $ .querySelector js/document |.search-input
              if (some? target) (.focus target)
        |inject-style $ quote
          defn inject-style (class-name styles)
            style $ {}
              :innerHTML $ str class-name "| {" (style->string styles) |}
      :proc $ quote ()
    |app.util $ {}
      :ns $ quote
        ns app.util $ :require ([] app.schema :as schema) ([] bisection-key.core :as bisection) ([] |shortid :as shortid)
      :defs $ {}
        |parse-deps $ quote
          defn parse-deps (require-exprs)
            let
                require-rules $ -> require-exprs
                  filter $ fn (xs)
                    = |:require $ first xs
                  first
              if (some? require-rules)
                loop
                    result $ {}
                    xs $ rest require-rules
                  ; println |loop result xs
                  if (empty? xs) result $ let
                      rule $ first xs
                    recur
                      merge result $ parse-require
                        if
                          = (first rule) "\"[]"
                          .slice rule 1
                          , rule
                      rest xs
        |parse-def $ quote
          defn parse-def (text)
            let
                clean-text $ -> text (.replace |@ |)
              if (.includes? clean-text |/)
                let-sugar
                      [] ns-text def-text
                      split clean-text |/
                  {} (:method :as) (:key ns-text) (:def def-text)
                {} (:method :refer) (:key clean-text) (:def clean-text)
        |prepend-data $ quote
          defn prepend-data (x) ([] :data x)
        |push-info $ quote
          defn push-info (op-id op-time text)
            fn (xs)
              conj xs $ merge schema/notification
                {} (:id op-id) (:kind :info) (:text text) (:time op-time)
        |bookmark-full-str $ quote
          defn bookmark-full-str (bookmark)
            case-default (:kind bookmark)
              do
                js/console.warn $ str "\"Unknown" (pr-str bookmark)
                , "\""
              :def $ str (:ns bookmark) "\"/" (:extra bookmark)
              :ns $ str (:ns bookmark) "\"/"
        |db->string $ quote
          defn db->string (db)
            format-cirru-edn $ -> db (dissoc :sessions) (dissoc :saved-files) (dissoc :repl)
        |expr? $ quote
          defn expr? (x)
            = :expr $ :type x
        |parse-require $ quote
          defn parse-require (piece)
            let
                method $ get piece 1
                ns-text $ get piece 0
              case-default method
                do (println "\"Unknown referring:" piece) nil
                "\":as" $ {}
                    get piece 2
                    {} (:method :as) (:ns ns-text)
                "\":refer" $ -> (get piece 2)
                  filter $ fn (def-text) (not= def-text "\"[]")
                  map $ fn (def-text)
                    [] def-text $ {} (:method :refer) (:ns ns-text) (:def def-text)
                  pairs-map
                "\":default" $ {}
                    get piece 2
                    {} (:method :refer) (:ns ns-text)
                      :def $ get piece 2
        |to-bookmark $ quote
          defn to-bookmark (writer)
            get (:stack writer) (:pointer writer)
        |tree->cirru $ quote
          defn tree->cirru (x)
            if
              = :leaf $ :type x
              :text x
              -> (:data x) (.to-list) (.sort-by first)
                map $ fn (entry)
                  tree->cirru $ last entry
        |cirru->tree $ quote
          defn cirru->tree (xs author timestamp)
            if (list? xs)
              merge schema/expr $ {} (:at timestamp) (:by author)
                :data $ loop
                    result $ {}
                    ys xs
                    next-id bisection/mid-id
                  if (empty? ys) result $ let
                      y $ first ys
                    recur
                      assoc result next-id $ cirru->tree y author timestamp
                      rest ys
                      bisection/bisect next-id bisection/max-id
              merge schema/leaf $ {} (:at timestamp) (:by author) (:text xs)
        |cirru->file $ quote
          defn cirru->file (file author timestamp)
            -> file
              update :ns $ \ cirru->tree % author timestamp
              update :proc $ \ cirru->tree % author timestamp
              update :defs $ fn (defs)
                -> defs $ map-kv
                  fn (k xs)
                    [] k $ cirru->tree xs author timestamp
        |kinds $ quote
          def kinds $ #{} :ns :def :proc
        |leaf? $ quote
          defn leaf? (x)
            = :leaf $ :type x
        |file-tree->cirru $ quote
          defn file-tree->cirru (file)
            -> file (update :ns tree->cirru) (update :proc tree->cirru)
              update :defs $ fn (defs)
                -> defs $ map-kv
                  fn (def-text def-tree)
                    [] def-text $ tree->cirru def-tree
        |same-buffer? $ quote
          defn same-buffer? (x y)
            and
              = (:kind x) (:kind y)
              = (:ns x) (:ns y)
              = (:extra x) (:extra y)
        |to-keys $ quote
          defn to-keys (target-expr)
            sort $ .to-list
              keys $ :data target-expr
        |push-warning $ quote
          defn push-warning (op-id op-time text)
            fn (xs)
              conj xs $ merge schema/notification
                {} (:id op-id) (:kind :warning) (:text text) (:time op-time)
        |to-writer $ quote
          defn to-writer (db session-id)
            get-in db $ [] :sessions session-id :writer
        |bookmark->path $ quote
          defn bookmark->path (bookmark)
            assert (map? bookmark) "|Bookmark should be data"
            assert
              contains? kinds $ :kind bookmark
              , "|invalid bookmark type"
            if
              = :def $ :kind bookmark
              concat
                [] :ir :files (:ns bookmark) :defs $ :extra bookmark
                mapcat (:focus bookmark) prepend-data
              concat
                [] :ir :files (:ns bookmark) (:kind bookmark)
                mapcat (:focus bookmark) prepend-data
        |stringify-s-expr $ quote
          defn stringify-s-expr (x)
            if (list? x)
              str "|("
                -> x
                  map $ fn (y)
                    if (list? y) (stringify-s-expr y)
                      if (.includes? y "| ") (pr-str y) y
                  join-str "| "
                , "|)"
        |now! $ quote
          defn now! () $ .now js/Date
        |hide-empty-fields $ quote
          defn hide-empty-fields (x)
            -> x (.to-list)
              filter-not $ fn (pair)
                let[] (k v) pair $ nil? v
              pairs-map
        |file->cirru $ quote
          defn file->cirru (file)
            -> file (update :ns tree->cirru) (update :proc tree->cirru)
              update :defs $ fn (defs)
                -> defs $ map-kv
                  fn (k xs)
                    [] k $ tree->cirru xs
        |find-first $ quote
          defn find-first (f xs)
            find xs $ fn (x) (f x)
      :proc $ quote ()
    |app.twig.search $ {}
      :ns $ quote
        ns app.twig.search $ :require
      :defs $ {}
        |twig-search $ quote
          defn twig-search (files)
            -> files (.to-list)
              mapcat $ fn (entry)
                let-sugar
                      [] k file
                      , entry
                  concat
                    []
                      {} (:kind :ns) (:ns k)
                      {} (:kind :proc) (:ns k)
                    -> (:defs file) (.to-list)
                      map $ fn (f-entry)
                        let-sugar
                              [] f-k file
                              , f-entry
                          {} (:kind :def) (:ns k) (:extra f-k)
      :proc $ quote ()
    |app.comp.changed-files $ {}
      :ns $ quote
        ns app.comp.changed-files $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp list-> <> span div pre input button a
          [] respo.comp.space :refer $ [] =<
          [] app.client-util :as util
          [] app.style :as style
          [] app.comp.changed-info :refer $ [] comp-changed-info
      :defs $ {}
        |comp-changed-files $ quote
          defcomp comp-changed-files (states changed-files)
            div
              {} $ :style style-column
              <> |Changes style/title
              list-> ({})
                -> changed-files (.to-list)
                  map $ fn (pair)
                    let[] (k info) pair $ [] k (comp-changed-info info k)
              if (empty? changed-files)
                div
                  {} $ :style style-nothing
                  <> "|No changes"
                div ({})
                  a $ {} (:inner-text |Save) (:style style/button)
                    :on-click $ fn (e d!) (d! :effect/save-files nil)
                  a $ {} (:inner-text |Reset) (:style style/button)
                    :on-click $ fn (e d!) (d! :ir/reset-files nil) (d! :states/clear nil)
        |style-column $ quote
          def style-column $ {} (:overflow :auto) (:padding-bottom 120)
        |style-nothing $ quote
          def style-nothing $ {} (:font-family "|Josefin Sans")
            :color $ hsl 0 0 100 0.5
      :proc $ quote ()
    |app.updater.session $ {}
      :ns $ quote
        ns app.updater.session $ :require ([] app.schema :as schema)
      :defs $ {}
        |connect $ quote
          defn connect (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id)
              merge schema/session $ {} (:id session-id)
        |disconnect $ quote
          defn disconnect (db op-data session-id op-id op-time)
            update db :sessions $ fn (session) (dissoc session session-id)
        |select-ns $ quote
          defn select-ns (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :writer :selected-ns) op-data
      :proc $ quote ()
    |app.page $ {}
      :ns $ quote
        ns app.page $ :require
          [] respo.render.html :refer $ [] make-string
          [] shell-page.core :refer $ [] make-page spit slurp
          [] app.comp.container :refer $ [] comp-container
          [] cljs.reader :refer $ [] read-string
          [] app.config :as config
          [] cumulo-util.build :refer $ [] get-ip!
      :defs $ {}
        |base-info $ quote
          def base-info $ {}
            :title $ :title config/site
            :icon $ :icon config/site
            :ssr nil
            :inline-styles $ [] (slurp "\"entry/main.css")
        |dev-page $ quote
          defn dev-page () $ make-page "\""
            merge base-info $ {}
              :styles $ []
                str "\"http://" (get-ip!) "\":8100/main-fonts.css"
                , "\"/entry/main.css"
              :scripts $ []
                {} (:src "\"/client.js") (:defer? true)
              :inline-styles $ []
        |main! $ quote
          defn main! () $ if (= js/process.env.release |true)
            spit |dist/index.html $ prod-page
            spit |target/index.html $ dev-page
        |prod-page $ quote
          defn prod-page () $ let
              html-content $ make-string
                comp-container ({}) nil
              assets $ read-string (slurp "\"dist/assets.edn")
              cdn $ if config/cdn? (:cdn-url config/site) "\""
              font-styles $ :release-ui config/site
              prefix-cdn $ fn (x) x
            make-page html-content $ merge base-info
              {}
                :styles $ [] font-styles
                :scripts $ map
                  fn (x)
                    {}
                      :src $ -> x :output-name prefix-cdn
                      :defer? true
                  , assets
      :proc $ quote ()
    |app.style $ {}
      :ns $ quote
        ns app.style $ :require ([] respo-ui.core :as ui)
          [] respo.util.format :refer $ [] hsl
      :defs $ {}
        |button $ quote
          def button $ {}
            :background-color $ hsl 0 0 100 0
            :text-decoration :underline
            :color $ hsl 0 0 100 0.4
            :min-width 40
            :vertical-align :middle
            :border :none
            :min-width 80
            :line-height "\"30px"
            :font-size 14
            :text-align :center
            :padding "\"0 8px"
            :outline :none
            :cursor :pointer
        |font-code $ quote (def font-code "\"Source Code Pro, monospace")
        |input $ quote
          def input $ merge ui/input
            {}
              :background-color $ hsl 0 0 100 0.16
              :color $ hsl 0 0 100
              :font-family |Menlo,monospace
              :border :none
        |inspector $ quote
          def inspector $ {} (:opacity 0.9)
            :background-color $ hsl 0 0 90
            :color :black
        |link $ quote (def link ui/link)
        |title $ quote
          def title $ {} (:font-family ui/font-fancy) (:font-size 20) (:font-weight 100)
            :color $ hsl 0 0 80
      :proc $ quote ()
    |app.comp.search $ {}
      :ns $ quote
        ns app.comp.search $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp list-> <> span div input a
          [] respo.comp.space :refer $ [] =<
          [] app.polyfill :refer $ [] text-width*
          [] app.keycode :as keycode
          [] app.client-util :as util
          [] app.style :as style
          [] app.util.shortcuts :refer $ [] on-window-keydown
      :defs $ {}
        |on-input $ quote
          defn on-input (state cursor)
            fn (e d!)
              d! cursor $ {}
                :query $ :value e
                :selection 0
        |style-body $ quote
          def style-body $ {} (:overflow :auto) (:padding-bottom 80)
        |style-candidate $ quote
          def style-candidate $ {} (:padding "|0 8px")
            :color $ hsl 0 0 100 0.6
            :cursor :pointer
        |style-highlight $ quote
          def style-highlight $ {} (:color :white)
        |on-select $ quote
          defn on-select (bookmark cursor)
            fn (e d!) (d! :writer/select bookmark)
              d! cursor $ {} (:position :0) (:query |)
        |comp-no-results $ quote
          defcomp comp-no-results () $ div
            {} $ :style
              merge ui/row-middle $ {} (:padding 8) (:font-family ui/font-fancy)
                :color $ hsl 0 0 60
                :font-weight 300
            <> "\"No results"
        |comp-search $ quote
          defcomp comp-search (states router-data)
            let
                cursor $ :cursor states
                state $ or (:data states) initial-state
                queries $ ->
                  split (:query state) "| "
                  map trim
                def-candidates $ -> router-data
                  filter $ fn (bookmark)
                    and
                      = :def $ :kind bookmark
                      every? queries $ fn (y)
                        .includes? (:extra bookmark) y
                  .sort-by $ if
                    blank? $ :query state
                    , bookmark->str query-length
                ns-candidates $ -> router-data
                  filter $ fn (bookmark)
                    and
                      = :ns $ :kind bookmark
                      every? queries $ fn (y)
                        .includes? (:ns bookmark) y
                  .sort-by $ if
                    blank? $ :query state
                    , bookmark->str query-length
              div
                {} $ :style
                  merge ui/expand ui/row-middle $ {} (:height "\"100%") (:padding "\"0 16px")
                div
                  {} $ :style
                    merge ui/column $ {} (:width 320) (:height "\"100%")
                  div ({})
                    input $ {} (:placeholder "|Type to search...")
                      :value $ :query state
                      :class-name |search-input
                      :style $ merge style/input
                        {} $ :width "\"100%"
                      :on-input $ on-input state cursor
                      :on-keydown $ on-keydown state def-candidates cursor
                  if (empty? def-candidates) (comp-no-results)
                  list->
                    {} $ :style (merge ui/expand style-body)
                    -> def-candidates (take 20)
                      map-indexed $ fn (idx bookmark)
                        let
                            text $ bookmark->str bookmark
                            selected? $ = idx (:selection state)
                          [] text $ div
                            {} (:class-name |hoverable)
                              :style $ merge style-candidate (if selected? style-highlight)
                              :on-click $ on-select bookmark cursor
                            <> (:extra bookmark) nil
                            =< 8 nil
                            <> (:ns bookmark)
                              merge
                                {} (:font-size 12)
                                  :color $ hsl 0 0 40
                                if selected? style-highlight
                div
                  {} $ :style
                    merge ui/column $ {} (:width 320) (:height "\"100%")
                  =< nil 32
                  if (empty? ns-candidates) (comp-no-results)
                  list->
                    {} $ :style (merge ui/expand style-body)
                    -> ns-candidates (take 20)
                      map-indexed $ fn (idx bookmark)
                        [] (:ns bookmark)
                          let
                              pieces $ split (:ns bookmark) "\"."
                            div
                              {} (:class-name |hoverable)
                                :style $ merge ui/row-middle style-candidate
                                :on-click $ on-select bookmark cursor
                              span ({})
                                <>
                                  str
                                    .join-str (butlast pieces) "\"."
                                    , "\"."
                                  {} $ :color (hsl 0 0 50)
                                <> (last pieces)
                                  {} $ :color (hsl 0 0 80)
        |initial-state $ quote
          def initial-state $ {} (:query |) (:selection 0)
        |bookmark->str $ quote
          defn bookmark->str (bookmark)
            case-default (:kind bookmark)
              do
                js/console.warn $ str "\"Unknown" (pr-str bookmark)
                , "\""
              :def $ :extra bookmark
              :ns $ :ns bookmark
        |on-keydown $ quote
          defn on-keydown (state candidates cursor)
            fn (e d!)
              let
                  code $ :key-code e
                  event $ :original-event e
                cond
                    = keycode/enter code
                    let
                        target $ get candidates (:selection state)
                      if (some? target)
                        do (d! :writer/select target)
                          d! cursor $ {} (:query |) (:position 0)
                  (= keycode/up code)
                    do (.preventDefault event)
                      if
                        > (:selection state) 0
                        d! cursor $ update state :selection dec
                  (= keycode/escape code)
                    do
                      d! :router/change $ {} (:name :editor)
                      d! cursor $ {} (:query |) (:position 0)
                  (= keycode/down code)
                    do (.preventDefault event)
                      if
                        < (:selection state)
                          dec $ count candidates
                        d! cursor $ update state :selection inc
                  :else $ on-window-keydown (:event e) d!
                    {} $ :name :search
        |query-length $ quote
          defn query-length (bookmark)
            case-default (:kind bookmark)
              do
                js/console.warn $ str "\"Unknown" (pr-str bookmark)
                , 0
              :def $ count (:extra bookmark)
              :ns $ count (:ns bookmark)
      :proc $ quote ()
    |app.comp.about $ {}
      :ns $ quote
        ns app.comp.about $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp <> span div pre input button img a br
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] respo-md.comp.md :refer $ [] comp-md-block
          [] app.util.dom :refer $ [] copy-silently!
      :defs $ {}
        |comp-about $ quote
          defcomp comp-about () $ div
            {} $ :style (merge ui/global ui/fullscreen ui/column)
            div
              {} $ :style (merge ui/flex ui/center)
              img $ {} (:src "\"//cdn.tiye.me/logo/cirru.png")
                :style $ {} (:width 64) (:height 64) (:border-radius "\"8px")
              =< nil 16
              <> "\"No connection to server..." $ {} (:font-family "|Josefin Sans") (:font-weight 300) (:font-size 24)
                :color $ hsl 0 80 60
              div
                {} $ :class-name |comp-about
                <> "\"Get editor server running with:"
                pre $ {} (:innerHTML install-commands) (:class-name "\"copy-commands")
                  :style $ {} (:cursor :pointer) (:padding "\"0 8px")
                  :title "\"Click to copy."
                  :on-click $ fn (e d!) (copy-silently! install-commands)
            div
              {} (:class-name "\"comp-about")
                :style $ merge ui/center
                  {} (:padding "\"8px 8px")
                    :color $ hsl 0 0 50
              comp-md-block "\"Calcit Editor is a syntax tree editor of [Cirru Project](http://cirru.org). Read more at [Calcit Editor](https://github.com/Cirru/calcit-editor).\n" $ {}
        |install-commands $ quote (def install-commands "\"npm install -g calcit-editor\ncalcit-editor\n")
      :proc $ quote ()
    |app.util.detect $ {}
      :ns $ quote
        ns app.util.detect $ :require ([] |net :as net)
      :defs $ {}
        |port-taken? $ quote
          defn port-taken? (port next-fn)
            let
                tester $ net/createServer
              -> tester
                .!once |error $ fn (err)
                  if
                    not= (.-code err) |EADDRINUSE
                    next-fn err false
                    next-fn nil true
                .!once |listening $ fn ()
                  -> tester
                    .!once |close $ fn () (next-fn nil false)
                    .!close
                .!listen port
      :proc $ quote ()
    |app.comp.draft-box $ {}
      :ns $ quote
        ns app.comp.draft-box $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp <> span div textarea pre button a
          [] respo.comp.space :refer $ [] =<
          [] app.comp.modal :refer $ [] comp-modal
          [] app.style :as style
          [] app.util :refer $ [] tree->cirru
          [] app.keycode :as keycode
      :defs $ {}
        |style-original $ quote
          def style-original $ {} (:max-height 240) (:overflow :auto)
        |style-toolbar $ quote
          def style-toolbar $ {} (:justify-content :flex-end)
        |style-area $ quote
          def style-area $ {}
            :background-color $ hsl 0 0 100 0.2
            :min-height 320
            :line-height |1.6em
            :min-width 960
            :color :white
            :font-family style/font-code
            :font-size 14
            :outline :none
            :border :none
            :padding 8
            :min-width 800
            :vertical-align :top
        |comp-draft-box $ quote
          defcomp comp-draft-box (states expr focus close-modal!)
            let
                cursor $ :cursor states
              comp-modal
                fn (d!) (d! cursor nil) (close-modal! d!)
                let
                    path $ -> focus
                      mapcat $ fn (x) ([] :data x)
                    node $ get-in expr path
                    missing? $ nil? node
                  if missing?
                    span $ {} (:style style-wrong) (:inner-text "|Does not edit expression!")
                      :on-click $ fn (e d!) (close-modal! d!)
                    let
                        expr? $ = :expr (:type node)
                        state $ or (:data states)
                          if expr?
                            format-cirru $ [] (tree->cirru node)
                            :text node
                      div
                        {} $ :style ui/column
                        div
                          {} $ :style style-original
                          if expr? (<> "|Cirru Mode" style-mode)
                            textarea $ {}
                              :value $ if expr?
                                format-cirru $ tree->cirru node
                                :text node
                              :spellcheck false
                              :style style-text
                        =< nil 8
                        textarea $ {} (:style style-area) (:value state) (:class-name |el-draft-box)
                          :on-input $ fn (e d!)
                            d! cursor $ :value e
                          :on-keydown $ fn (e d!)
                            cond
                                = keycode/escape $ :keycode e
                                close-modal! d!
                              (and (= keycode/s (:keycode e)) (.-metaKey (:event e)))
                                do
                                  .preventDefault $ :event e
                                  if expr?
                                    d! :ir/draft-expr $ parse-cirru-edn state
                                    d! :ir/update-leaf state
                                  d! cursor nil
                                  close-modal! d!
                        =< nil 8
                        div
                          {} $ :style (merge ui/row style-toolbar)
                          button $ {} (:style style/button) (:inner-text |Apply)
                            :on-click $ on-submit expr? state cursor close-modal! false
                          button $ {} (:style style/button) (:inner-text |Submit)
                            :on-click $ on-submit expr? state cursor close-modal! true
        |style-text $ quote
          def style-text $ {} (:font-family style/font-code) (:color :white) (:padding "|8px 8px") (:height 60) (:display :block) (:width |100%)
            :background-color $ hsl 0 0 100 0.2
            :outline :none
            :border :none
            :font-size 14
            :padding 8
            :min-width 800
            :vetical-align :top
        |style-wrong $ quote
          def style-wrong $ {} (:color :red) (:font-size 24) (:font-weight 100) (:font-family "|Josefin Sans") (:cursor :pointer)
        |style-mode $ quote
          def style-mode $ {}
            :color $ hsl 0 0 100 0.6
            :background-color $ hsl 300 50 50 0.6
            :padding "|0 8px"
            :font-size 12
            :border-radius |4px
        |on-submit $ quote
          defn on-submit (expr? text cursor close-modal! close?)
            fn (e d!)
              if expr?
                d! :ir/draft-expr $ first (parse-cirru text)
                d! :ir/update-leaf text
              if close? $ do (d! cursor nil) (close-modal! d!)
      :proc $ quote ()
    |app.updater.analyze $ {}
      :ns $ quote
        ns app.updater.analyze $ :require ([] clojure.string :as string)
          [] app.util :refer $ [] bookmark->path to-writer to-bookmark parse-deps tree->cirru cirru->tree parse-def push-warning
          [] app.util.stack :refer $ [] push-bookmark
          [] app.schema :as schema
      :defs $ {}
        |abstract-def $ quote
          defn abstract-def (db op-data sid op-id op-time)
            let
                writer $ to-writer db sid
                files $ get-in db ([] :ir :files)
                bookmark $ to-bookmark writer
                ns-text $ :ns bookmark
                def-text op-data
                def-existed? $ some?
                  get-in files $ [] (:ns bookmark) :defs def-text
                user-id $ get-in db ([] :sessions sid :user-id)
                new-bookmark $ merge schema/bookmark
                  {} (:ns ns-text) (:kind :def) (:extra def-text)
              if def-existed?
                -> db
                  update-in ([] :sessions sid :notifications)
                    push-warning op-id op-time $ str def-text "| already defined!"
                  update-in ([] :sessions sid :writer) (push-bookmark new-bookmark)
                let
                    target-path $ -> (:focus bookmark)
                      mapcat $ fn (x) ([] :data x)
                    target-expr $ -> files
                      get-in $ [] ns-text :defs (:extra bookmark)
                      get-in target-path
                  -> db
                    update-in ([] :ir :files ns-text :defs)
                      fn (defs)
                        ; println target-path (prepend target-path def-text) (tree->cirru target-expr) (keys defs)
                        -> defs
                          assoc def-text $ cirru->tree
                            [] |def def-text $ tree->cirru target-expr
                            , user-id op-time
                          assoc-in
                            prepend target-path $ :extra bookmark
                            cirru->tree def-text user-id op-time
                    update-in ([] :sessions sid :writer) (push-bookmark new-bookmark)
        |goto-def $ quote
          defn goto-def (db op-data sid op-id op-time)
            let
                writer $ to-writer db sid
                pkg $ get-in db ([] :ir :package)
                bookmark $ to-bookmark writer
                ns-text $ :ns bookmark
                ns-expr $ tree->cirru
                  get-in db $ [] :ir :files ns-text :ns
                deps-info $ parse-deps (.slice ns-expr 2)
                def-info $ parse-def (:text op-data)
                forced? $ :forced? op-data
                new-bookmark $ merge schema/bookmark
                  {} $ :focus ([] "\"r")
                  if
                    and
                      contains? deps-info $ :key def-info
                      = (:method def-info)
                        :method $ get deps-info (:key def-info)
                    let
                        rule $ get deps-info (:key def-info)
                      if
                        = :refer $ :method def-info
                        {} (:kind :def)
                          :ns $ :ns rule
                          :extra $ :key def-info
                        {} (:kind :def)
                          :ns $ :ns rule
                          :extra $ :def def-info
                    {} (:kind :def)
                      :ns $ :ns bookmark
                      :extra $ :def def-info
                def-existed? $ some?
                  get-in db $ [] :ir :files (:ns new-bookmark) :defs (:extra new-bookmark)
                user-id $ get-in db ([] :sessions sid :user-id)
                warn $ fn (x)
                  -> db $ update-in ([] :sessions sid :notifications) (push-warning op-id op-time x)
              ; println |deps deps-info def-info new-bookmark def-existed?
              if (some? new-bookmark)
                if
                  starts-with? (:ns new-bookmark) (str pkg |.)
                  if def-existed?
                    -> db $ update-in ([] :sessions sid :writer) (push-bookmark new-bookmark true)
                    if forced?
                      let
                          new-expr $ if
                            list? $ :args op-data
                            [] "\"defn" (:extra new-bookmark)
                              [] & $ :args op-data
                            [] "\"def" (:extra new-bookmark) ([])
                        -> db
                          assoc-in
                            [] :ir :files (:ns new-bookmark) :defs $ :extra new-bookmark
                            cirru->tree new-expr user-id op-time
                          update-in ([] :sessions sid :writer) (push-bookmark new-bookmark)
                      warn $ str "|Does not exist: " (:ns new-bookmark) "| " (:extra new-bookmark)
                  warn $ str "|From external ns: " (:ns new-bookmark)
                warn $ str "|Cannot locate: " def-info
        |peek-def $ quote
          defn peek-def (db op-data sid op-id op-time)
            let
                writer $ to-writer db sid
                pkg $ get-in db ([] :ir :package)
                bookmark $ to-bookmark writer
                ns-text $ :ns bookmark
                ns-expr $ tree->cirru
                  get-in db $ [] :ir :files ns-text :ns
                deps-info $ parse-deps (.slice ns-expr 2)
                def-info $ parse-def op-data
                new-bookmark $ merge schema/bookmark
                  if
                    and
                      contains? deps-info $ :key def-info
                      = (:method def-info)
                        :method $ get deps-info (:key def-info)
                    let
                        rule $ get deps-info (:key def-info)
                      if
                        = :refer $ :method def-info
                        {} (:kind :def)
                          :ns $ :ns rule
                          :extra $ :key def-info
                        {} (:kind :def)
                          :ns $ :ns rule
                          :extra $ :def def-info
                    {} (:kind :def)
                      :ns $ :ns bookmark
                      :extra $ :def def-info
                def-existed? $ some?
                  get-in db $ [] :ir :files (:ns new-bookmark) :defs (:extra new-bookmark)
                user-id $ get-in db ([] :sessions sid :user-id)
                warn $ fn (x)
                  update-in db ([] :sessions sid :notifications) (push-warning op-id op-time x)
              ; println |deps deps-info def-info new-bookmark def-existed?
              if (some? new-bookmark)
                if
                  starts-with? (:ns new-bookmark) (str pkg |.)
                  if def-existed?
                    -> db $ assoc-in ([] :sessions sid :writer :peek-def)
                      {}
                        :ns $ :ns new-bookmark
                        :def $ :extra new-bookmark
                    warn $ str "|Does not exist: " (:ns new-bookmark) "| " (:extra new-bookmark)
                  warn $ str "|External dep:" (:ns new-bookmark)
                warn $ str "|Cannot locate:" def-info
      :proc $ quote ()
    |app.comp.picker-notice $ {}
      :ns $ quote
        ns app.comp.picker-notice $ :require
          [] respo.core :refer $ [] defcomp list-> >> <> span div a pre
          [] respo-ui.core :as ui
          [] respo.util.format :refer $ [] hsl
          [] respo.comp.space :refer $ [] =<
      :defs $ {}
        |comp-picker-notice $ quote
          defcomp comp-picker-notice (choices target-node)
            let
                imported-names $ :imported choices
                defined-names $ :defined choices
                render-code $ fn (x)
                  span $ {} (:inner-text x) (:style style-name)
                    :on-click $ fn (e d!) (d! :writer/pick-node x)
                hint $ if (some? target-node) (:text target-node) nil
                hint-fn $ fn (x)
                  if (blank? hint) false $ .includes? x hint
              div
                {} $ :style style-container
                div
                  {}
                    :style $ {} (:font-family ui/font-fancy) (:font-size 16) (:font-weight 300)
                      :color $ hsl 0 0 80
                      :cursor :pointer
                    :on-click $ fn (e d!) (d! :writer/picker-mode nil)
                  <> "\"Picker mode: pick a target..."
                let
                    possible-names $ ->
                      concat (.to-list imported-names) (.to-list defined-names)
                      .distinct
                      filter hint-fn
                  if-not (empty? possible-names)
                    div ({})
                      list-> ({})
                        -> possible-names
                          .sort-by $ fn (x) (.index-of x hint)
                          map $ fn (x)
                            [] x $ render-code x
                      =< nil 8
                let
                    filtered-names $ -> imported-names (filter-not hint-fn)
                  if-not (empty? filtered-names)
                    div ({})
                      list-> ({})
                        -> filtered-names (.to-list) (sort &compare)
                          map $ fn (x)
                            [] x $ render-code x
                      =< nil 8
                list-> ({})
                  -> defined-names (.to-list) (filter-not hint-fn) (sort)
                    map $ fn (x)
                      [] x $ render-code x
        |style-name $ quote
          def style-name $ {} (:font-family ui/font-code) (:cursor :pointer) (:font-size 11) (:margin-right 3) (:margin-bottom 3) (:word-break :none) (:line-height "\"14px")
            :background-color $ hsl 0 0 30
            :padding "\"1px 3px"
            :display :inline-block
        |style-container $ quote
          def style-container $ {} (:padding "\"4px 8px") (:margin "\"8px 0")
            :background-color $ hsl 0 0 30 0.5
            :position :fixed
            :top 8
            :right 20
            :z-index 100
            :border-radius "\"4px"
            :max-width "\"32vw"
      :proc $ quote ()
      :configs $ {}
    |app.client-updater $ {}
      :ns $ quote (ns app.client-updater)
      :defs $ {}
        |abstract $ quote
          defn abstract (states)
            assoc-in states ([] :editor :data :abstract?) true
        |clear-editor $ quote
          defn clear-editor (states)
            update states :editor $ fn (scope)
              -> scope .to-list
                filter $ fn (pair)
                  let[] (k v) pair $ keyword? k
                pairs-map
        |draft-box $ quote
          defn draft-box (states)
            assoc-in states ([] :editor :data :draft-box?) true
      :proc $ quote ()
    |app.comp.page-editor $ {}
      :ns $ quote
        ns app.comp.page-editor $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp list-> >> <> span div a pre
          [] respo.comp.space :refer $ [] =<
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] app.comp.bookmark :refer $ [] comp-bookmark
          [] app.comp.expr :refer $ [] comp-expr
          [] app.theme :refer $ [] base-style-leaf base-style-expr
          [] app.style :as style
          [] app.util.dom :refer $ [] inject-style
          [] app.comp.draft-box :refer $ [] comp-draft-box
          [] app.comp.abstract :refer $ [] comp-abstract
          [] app.comp.theme-menu :refer $ [] comp-theme-menu
          [] app.comp.peek-def :refer $ [] comp-peek-def
          [] app.util :refer $ [] tree->cirru prepend-data bookmark-full-str
          [] app.util.dom :refer $ [] do-copy-logics!
          [] respo-alerts.core :refer $ [] use-confirm use-prompt
          [] app.comp.replace-name :refer $ [] use-replace-name-modal
          [] app.comp.picker-notice :refer $ [] comp-picker-notice
      :defs $ {}
        |comp-page-editor $ quote
          defcomp comp-page-editor (states stack router-data pointer picker-mode? theme)
            let
                cursor $ :cursor states
                state $ or (:data states) initial-state
                bookmark $ get stack pointer
                expr $ :expr router-data
                focus $ :focus router-data
                readonly? false
                close-draft-box! $ fn (d!)
                  d! cursor $ assoc state :draft-box? false
                close-abstract! $ fn (d!)
                  d! cursor $ assoc state :abstract? false
              div
                {} $ :style (merge ui/row ui/flex style-container)
                if (empty? stack)
                  div
                    {} $ :style style-stack
                    <> "\"Empty" style-nothing
                  list->
                    {} $ :style style-stack
                    -> stack $ map-indexed
                      fn (idx bookmark)
                        [] idx $ comp-bookmark bookmark idx (= idx pointer)
                if (empty? stack)
                  div ({}) (<> "\"Nothing to edit" style-nothing)
                  div
                    {} $ :style style-editor
                    let
                        others $ -> (:others router-data) (vals) (map :focus)
                      div
                        {} $ :style style-area
                        inject-style "\".cirru-expr" $ .to-list (base-style-expr theme)
                        inject-style "\".cirru-leaf" $ .to-list (base-style-leaf theme)
                        if (some? expr)
                          comp-expr
                            >> states $ bookmark-full-str bookmark
                            , expr focus ([]) others false false readonly? picker-mode? theme 0
                          , ui-missing
                    let
                        peek-def $ :peek-def router-data
                      if (some? peek-def) (comp-peek-def peek-def)
                    comp-status-bar states router-data bookmark theme
                    if (:draft-box? state)
                      comp-draft-box (>> states :draft-box) expr focus close-draft-box!
                    if (:abstract? state)
                      comp-abstract (>> states :abstract) close-abstract!
                    ; comp-inspect "\"Expr" router-data style/inspector
                if picker-mode? $ comp-picker-notice (:picker-choices router-data)
                  get-in expr $ mapcat focus prepend-data
        |style-status $ quote
          def style-status $ merge ui/row
            {} (:justify-content :space-between) (:padding "|0 8px")
        |comp-status-bar $ quote
          defcomp comp-status-bar (states router-data bookmark theme)
            let
                cursor $ :cursor states
                state $ or (:data states) initial-state
                old-name $ if
                  = :def $ :kind bookmark
                  str (:ns bookmark) "\"/" $ :extra bookmark
                  :ns bookmark
                confirm-delete-plugin $ use-confirm (>> states :delete)
                  {} $ :text
                    str "\"Confirm deleting current path: " (:ns bookmark) "\"/" $ or (:extra bookmark) (:kind bookmark)
                confirm-reset-plugin $ use-confirm (>> states :reset)
                  {} $ :text "\"Confirm reset changes to this expr?"
                rename-plugin $ use-prompt (>> states :rename)
                  {}
                    :text $ str "\"Renaming: " old-name
                    :initial old-name
                add-plugin $ use-prompt (>> states :add)
                  {}
                    :text $ str "\"Add function name:"
                    :initial "\""
                replace-plugin $ use-replace-name-modal (>> states :replace)
                  fn (from to d!)
                    d! :ir/expr-replace $ {} (:bookmark bookmark) (:from from) (:to to)
              div
                {} $ :style style-status
                div ({})
                  <>
                    str "|Writers("
                      count $ :others router-data
                      , "|)"
                    , style-hint
                  list->
                    {} $ :style style-watchers
                    -> (:others router-data) (vals)
                      map $ fn (info)
                        [] (:session-id info)
                          <> (:nickname info) style-watcher
                  =< 16 nil
                  <>
                    str "|Watchers("
                      count $ :watchers router-data
                      , "|)"
                    , style-hint
                  list->
                    {} $ :style style-watchers
                    -> (:watchers router-data)
                      map $ fn (entry)
                        let-sugar
                              [] sid member
                              , entry
                          [] sid $ <> (:nickname member) style-watcher
                  =< 16 nil
                  if
                    = :same $ :changed router-data
                    <>
                      str $ :changed router-data
                      {} (:font-family ui/font-fancy)
                        :color $ hsl 260 80 70
                    span $ {} (:style style-link) (:inner-text "\"Reset")
                      :on-click $ fn (e d!)
                        .show confirm-reset-plugin d! $ fn () (on-reset-expr bookmark d!)
                  =< 8 nil
                  span $ {} (:inner-text |Delete) (:style style-link)
                    :on-click $ fn (e d!)
                      .show confirm-delete-plugin d! $ fn ()
                        if (some? bookmark)
                          d! :ir/delete-entry $ dissoc bookmark :focus
                          js/console.warn "\"No entry to delete"
                  =< 8 nil
                  span $ {} (:inner-text |Rename) (:style style-link)
                    :on-click $ fn (e d!)
                      .show rename-plugin d! $ fn (result) (on-rename-def result bookmark d!)
                  =< 8 nil
                  span $ {} (:inner-text |Add) (:style style-link)
                    :on-click $ fn (e d!)
                      .show add-plugin d! $ fn (result)
                        let
                            text $ trim result
                          when-not (blank? text)
                            d! :ir/add-def $ [] (:ns bookmark) text
                            d! :writer/edit $ {} (:kind :def)
                              :ns $ :ns bookmark
                              :extra text
                  =< 8 nil
                  span $ {} (:inner-text |Draft-box) (:style style-link)
                    :on-click $ on-draft-box state cursor
                  =< 8 nil
                  span $ {} (:inner-text |Replace) (:style style-link)
                    :on-click $ fn (e d!) (.show replace-plugin d!)
                  =< 8 nil
                  span $ {} (:inner-text |Exporting) (:style style-link)
                    :on-click $ on-path-gen! bookmark
                  =< 8 nil
                  span $ {} (:inner-text "\"Picker-mode") (:style style-link)
                    :on-click $ fn (e d!) (d! :writer/picker-mode nil)
                div
                  {} $ :style ui/row
                  comp-theme-menu (>> states :theme) theme
                .render confirm-delete-plugin
                .render confirm-reset-plugin
                .render rename-plugin
                .render add-plugin
                .render replace-plugin
        |style-watchers $ quote
          def style-watchers $ merge ui/row
            {} $ :display :inline-block
        |style-nothing $ quote
          def style-nothing $ {}
            :color $ hsl 0 0 100 0.4
            :padding "|0 16px"
            :font-family "|Josefin Sans"
        |ui-missing $ quote
          def ui-missing $ div
            {} $ :style style-missing
            <> "|Expression is missing!" nil
        |style-stack $ quote
          def style-stack $ {} (:max-width 200) (:overflow :auto) (:padding-bottom 120)
        |style-hint $ quote
          def style-hint $ {}
            :color $ hsl 0 0 100 0.6
            :font-family ui/font-fancy
        |style-area $ quote
          def style-area $ {} (:overflow :auto) (:padding-bottom 240) (:padding-top 80) (:flex 1)
        |style-container $ quote
          def style-container $ {} (:position :relative)
        |style-editor $ quote
          def style-editor $ merge ui/flex ui/column
        |style-watcher $ quote
          def style-watcher $ {}
            :color $ hsl 0 0 100 0.7
            :margin-left 8
        |style-missing $ quote
          def style-missing $ {} (:font-family "|Josefin Sans")
            :color $ hsl 10 60 50
            :font-size 20
            :font-weight 100
        |initial-state $ quote
          def initial-state $ {} (:draft-box? false)
        |on-draft-box $ quote
          defn on-draft-box (state cursor)
            fn (e d!)
              d! cursor $ update state :draft-box? not
              js/setTimeout $ fn ()
                let
                    el $ js/document.querySelector |.el-draft-box
                  if (some? el) (.!focus el)
        |on-reset-expr $ quote
          defn on-reset-expr (bookmark d!)
            let
                kind $ :kind bookmark
                ns-text $ :ns bookmark
              d! :ir/reset-at $ case kind
                :ns $ {} (:ns ns-text) (:kind :ns)
                :proc $ {} (:ns ns-text) (:kind :proc)
                :def $ {} (:ns ns-text) (:kind :def)
                  :extra $ :extra bookmark
                do $ println "\"Unknown" bookmark
              d! :states/clear nil
        |style-link $ quote
          def style-link $ {} (:font-family "|Josefin Sans") (:cursor :pointer) (:font-size 14)
            :color $ hsl 200 50 80
        |on-path-gen! $ quote
          defn on-path-gen! (bookmark)
            fn (e d!)
              case-default (:kind bookmark)
                d! :notify/push-message $ [] :warn "\"No op."
                :def $ let
                    code $ [] (:ns bookmark) "\":refer"
                      [] $ :extra bookmark
                  do-copy-logics! d! (pr-str code)
                    str "\"Copied path of " $ :extra bookmark
                :ns $ let
                    the-ns $ :ns bookmark
                    code $ [] the-ns "\":as"
                      last $ split the-ns "\"."
                  do-copy-logics! d! (pr-str code) (str "\"Copied path of " the-ns)
        |on-rename-def $ quote
          defn on-rename-def (new-name bookmark d!)
            when
              not $ blank? new-name
              let-sugar
                    [] ns-text def-text
                    split new-name |/
                d! :ir/rename $ {}
                  :kind $ :kind bookmark
                  :ns $ {}
                    :from $ :ns bookmark
                    :to ns-text
                  :extra $ {}
                    :from $ :extra bookmark
                    :to def-text
      :proc $ quote ()
    |app.twig.page-files $ {}
      :ns $ quote
        ns app.twig.page-files $ :require
          [] clojure.set :refer $ [] union
          [] app.util :refer $ [] file->cirru
          [] app.util.list :refer $ [] compare-entry
      :defs $ {}
        |keys-set $ quote
          defn keys-set (x) (keys x)
        |render-changed-files $ quote
          defn render-changed-files (files saved-files)
            ->
              union (keys-set files) (keys-set saved-files)
              filter $ fn (ns-text)
                not $ identical? (get files ns-text) (get saved-files ns-text)
              map $ fn (ns-text)
                let
                    file $ get files ns-text
                    saved-file $ get saved-files ns-text
                  [] ns-text $ {}
                    :ns $ compare-entry (:ns file) (:ns saved-file)
                    :proc $ compare-entry (:proc file) (:proc saved-file)
                    :defs $ let
                        all-defs $ union
                          keys $ or (:defs file) ({})
                          keys $ or (:defs saved-file) ({})
                        defs $ :defs file
                        saved-defs $ :defs saved-file
                      -> all-defs
                        filter $ fn (def-text)
                          not= (get defs def-text) (get saved-defs def-text)
                        map $ fn (def-text)
                          [] def-text $ compare-entry (get defs def-text) (get saved-defs def-text)
                        pairs-map
              filter $ fn (pair)
                let[] (k info) pair $ not
                  and
                    = :same $ :ns info
                    = :same $ :proc info
                    empty? $ :defs info
              pairs-map
        |twig-page-files $ quote
          defn twig-page-files (files selected-ns saved-files draft-ns sessions sid)
            {}
              :ns-set $ keys files
              :defs-set $ if (some? selected-ns)
                do $ ->
                  get-in files $ [] selected-ns :defs
                  keys
                #{}
              :file-configs $ if (some? selected-ns)
                get-in files $ [] selected-ns :configs
                , nil
              :changed-files $ render-changed-files files saved-files
              :peeking-file $ if (some? draft-ns)
                file->cirru $ get files draft-ns
                , nil
              :highlights $ -> sessions (.to-list)
                map $ fn (pair)
                  let[] (k session) pair $ [] k
                    let
                        writer $ :writer session
                        stack $ :stack writer
                      if (empty? stack) nil $ dissoc
                        get stack $ :pointer writer
                        , :focus
                filter $ fn (pair)
                  let[] (k session) pair $ if (= sid k) false (some? session)
                pairs-map
      :proc $ quote ()
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |ir-file $ quote
          def ir-file $ {} (:package |app)
            :files $ {}
        |expr $ quote
          def expr $ {} (:type :expr) (:by nil) (:at nil)
            :data $ {}
        |configs $ quote
          def configs $ {} (:port 6001) (:init-fn "\"app.main/main!") (:reload-fn "\"app.main/reload!")
            :modules $ []
            :version "\"0.0.1"
        |user $ quote
          def user $ {} (:name nil) (:id nil) (:nickname nil) (:avatar nil) (:password nil) (:theme :star-trail)
        |bookmark $ quote
          def bookmark $ {} (:kind :def) (:ns nil) (:extra nil)
            :focus $ []
        |leaf $ quote
          def leaf $ {} (:type :leaf) (:by nil) (:at nil) (:text |)
        |database $ quote
          def database $ {}
            :sessions $ {}
            :users $ {}
            :ir ir-file
            :saved-files $ {}
            :configs configs
            :repl $ {} (:alive? false)
              :logs $ {}
        |repl-log $ quote
          def repl-log $ {} (:id nil) (:type nil) (:text |) (:time nil)
        |router $ quote
          def router $ {} (:name nil) (:title nil)
            :data $ {}
            :router nil
        |file $ quote
          def file $ {}
            :ns $ {}
            :defs $ {}
            :proc $ {}
            :configs $ {}
        |session $ quote
          def session $ {} (:user-id nil) (:id nil)
            :router $ {} (:name :files) (:data nil) (:router nil)
            :notifications $ []
            :writer $ {} (:selected-ns nil) (:draft-ns nil) (:peek-def nil) (:pointer 0)
              :stack $ []
              :picker-coord nil
            :theme :star-trail
        |notification $ quote
          def notification $ {} (:id nil) (:kind nil) (:text nil) (:time nil)
        |page-data $ quote
          def page-data $ {}
            :files $ {}
              :ns-set $ #{}
              :defs-set $ #{}
              :changed-files $ {}
            :editor $ {}
              :focus $ []
              :others $ #{}
              :expr nil
      :proc $ quote ()
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require ([] app.updater.session :as session) ([] app.updater.user :as user) ([] app.updater.router :as router) ([] app.updater.ir :as ir) ([] app.updater.writer :as writer) ([] app.updater.notify :as notify) ([] app.updater.analyze :as analyze) ([] app.updater.watcher :as watcher) ([] app.updater.configs :as configs)
      :defs $ {}
        |updater $ quote
          defn updater (db op op-data sid op-id op-time)
            let
                f $ case-default op
                  do (println "|Unknown op:" op)
                    fn (& args) db
                  :session/connect session/connect
                  :session/disconnect session/disconnect
                  :session/select-ns session/select-ns
                  :user/nickname user/nickname
                  :user/log-in user/log-in
                  :user/sign-up user/sign-up
                  :user/log-out user/log-out
                  :user/change-theme user/change-theme
                  :router/change router/change
                  :writer/edit writer/edit
                  :writer/edit-ns writer/edit-ns
                  :writer/select writer/select
                  :writer/point-to writer/point-to
                  :writer/focus writer/focus
                  :writer/go-up writer/go-up
                  :writer/go-down writer/go-down
                  :writer/go-left writer/go-left
                  :writer/go-right writer/go-right
                  :writer/remove-idx writer/remove-idx
                  :writer/paste writer/paste
                  :writer/save-files writer/save-files
                  :writer/collapse writer/collapse
                  :writer/move-next writer/move-next
                  :writer/move-previous writer/move-previous
                  :writer/move-order writer/move-order
                  :writer/finish writer/finish
                  :writer/draft-ns writer/draft-ns
                  :writer/hide-peek writer/hide-peek
                  :writer/picker-mode writer/picker-mode
                  :writer/pick-node writer/pick-node
                  :ir/add-ns ir/add-ns
                  :ir/add-def ir/add-def
                  :ir/remove-def ir/remove-def
                  :ir/remove-ns ir/remove-ns
                  :ir/prepend-leaf ir/prepend-leaf
                  :ir/append-leaf ir/append-leaf
                  :ir/delete-node ir/delete-node
                  :ir/leaf-after ir/leaf-after
                  :ir/leaf-before ir/leaf-before
                  :ir/expr-before ir/expr-before
                  :ir/expr-after ir/expr-after
                  :ir/expr-replace ir/expr-replace
                  :ir/indent ir/indent
                  :ir/unindent ir/unindent
                  :ir/unindent-leaf ir/unindent-leaf
                  :ir/update-leaf ir/update-leaf
                  :ir/duplicate ir/duplicate
                  :ir/rename ir/rename
                  :ir/cp-ns ir/cp-ns
                  :ir/mv-ns ir/mv-ns
                  :ir/delete-entry ir/delete-entry
                  :ir/reset-files ir/reset-files
                  :ir/reset-at ir/reset-at
                  :ir/reset-ns ir/reset-ns
                  :ir/draft-expr ir/draft-expr
                  :ir/replace-file ir/replace-file
                  :ir/file-config ir/file-config
                  :ir/clone-ns ir/clone-ns
                  :ir/toggle-comment ir/toggle-comment
                  :notify/push-message notify/push-message
                  :notify/clear notify/clear
                  :notify/broadcast notify/broadcast
                  :analyze/goto-def analyze/goto-def
                  :analyze/abstract-def analyze/abstract-def
                  :analyze/peek-def analyze/peek-def
                  :watcher/file-change watcher/file-change
                  :ping identity
                  :configs/update configs/update-configs
              f db op-data sid op-id op-time
      :proc $ quote ()
    |app.config $ {}
      :ns $ quote
        ns app.config $ :require ([] app.schema :as schema)
      :defs $ {}
        |cdn? $ quote
          def cdn? $ cond
              exists? js/window
              , false
            (exists? js/process) (= "\"true" js/process.env.cdn)
            :else false
        |dev? $ quote
          def dev? $ = "\"dev" (get-env "\"mode")
        |site $ quote
          def site $ {} (:port nil) (:title "\"Calcit Editor") (:icon "\"https://cdn.tiye.me/logo/cirru.png") (:dev-ui "\"http://localhost:8100/main-fonts.css") (:release-ui "\"//cdn.tiye.me/favored-fonts/main-fonts.css") (:cdn-url "\"https://cdn.tiye.me/calcit-editor/") (:theme "\"#eeeeff") (:storage-key "\"calcit-storage") (:storage-file "\"calcit.cirru")
      :proc $ quote ()
    |app.comp.changed-info $ {}
      :ns $ quote
        ns app.comp.changed-info $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp list-> >> <> span div pre input button a
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] feather.core :refer $ [] comp-icon
      :defs $ {}
        |style-reset $ quote
          def style-reset $ {} (:text-decoration :underline) (:font-size 12)
            :color $ hsl 220 60 80 0.6
            :cursor :pointer
        |style-status $ quote
          def style-status $ {} (:font-size 12) (:font-family "|Josefin Sans")
            :color $ hsl 160 70 40
        |style-status-card $ quote
          def style-status-card $ {} (:cursor :pointer)
        |on-reset-def $ quote
          defn on-reset-def (ns-text kind)
            fn (e d!)
              d! :ir/reset-at $ case-default kind
                {} (:ns ns-text) (:kind :def) (:extra kind)
                :ns $ {} (:ns ns-text) (:kind :ns)
                :proc $ {} (:ns ns-text) (:kind :proc)
              d! :states/clear nil
        |comp-changed-info $ quote
          defcomp comp-changed-info (info ns-text)
            div
              {} $ :style style-info
              div ({}) (<> ns-text) (=< 8 nil)
                span
                  {} $ :class-name "\"is-minor"
                  comp-icon :corner-up-left style-reset $ fn (e d!) (d! :ir/reset-ns ns-text) (d! :states/clear nil)
                =< 24 nil
                if
                  not= :same $ :ns info
                  render-status ns-text :ns $ :ns info
                =< 8 nil
                if
                  not= :same $ :proc info
                  render-status ns-text :proc $ :proc info
              div
                {} $ :style
                  merge ui/row-parted $ {} (:align-items :flex-end)
                list->
                  {} $ :style style-defs
                  -> (:defs info) (.to-list)
                    map $ fn (entry)
                      let-sugar
                            [] def-text status
                            , entry
                        [] def-text $ div ({}) (render-status ns-text def-text status)
                div ({})
                  comp-icon :save style-reset $ fn (e d!) (d! :effect/save-ns ns-text)
        |render-status $ quote
          defn render-status (ns-text kind status)
            span
              {} (:style style-status-card)
                :title $ str "|Browse " kind
                :on-click $ on-preview ns-text kind status
              <> kind
              =< 8 nil
              <> (turn-string status) style-status
              =< 4 nil
              span
                {} $ :class-name "\"is-minor"
                comp-icon :corner-up-left style-reset $ on-reset-def ns-text kind
        |style-info $ quote
          def style-info $ {}
            :background-color $ hsl 0 0 100 0.1
            :padding 8
            :margin-bottom 8
        |style-defs $ quote
          def style-defs $ {} (:padding-left 16)
        |on-preview $ quote
          defn on-preview (ns-text kind status)
            fn (e d!) (; println |peek ns-text kind status)
              d! :writer/select $ case-default kind
                {} (:kind :def) (:ns ns-text) (:extra kind)
                :ns $ {} (:kind :ns) (:ns ns-text) (:extra nil)
                :proc $ {} (:kind :proc) (:ns ns-text) (:extra nil)
      :proc $ quote ()
    |app.twig.page-editor $ {}
      :ns $ quote
        ns app.twig.page-editor $ :require
          [] app.util :refer $ [] same-buffer? tree->cirru
          [] app.twig.user :refer $ [] twig-user
          [] app.util.list :refer $ [] compare-entry
      :defs $ {}
        |twig-page-editor $ quote
          defn twig-page-editor (files old-files sessions users writer session-id repl)
            let
                pointer $ :pointer writer
                stack $ :stack writer
                bookmark $ if (empty? stack) nil (get stack pointer)
              if (some? bookmark)
                let
                    ns-text $ :ns bookmark
                  {}
                    :focus $ :focus bookmark
                    :others $ dissoc
                      -> sessions
                        map $ fn (entry)
                          let
                              session $ last entry
                              writer $ :writer session
                              router $ :router session
                              a-bookmark $ get (:stack writer) (:pointer writer)
                            [] (first entry)
                              if
                                and
                                  = :editor $ :name router
                                  same-buffer? bookmark a-bookmark
                                {}
                                  :focus $ :focus a-bookmark
                                  :nickname $ get-in users
                                    [] (:user-id session) :nickname
                                  :session-id $ :id session
                                , nil
                        filter $ fn (pair)
                          some? $ last pair
                        pairs-map
                      , session-id
                    :watchers $ -> sessions
                      filter $ fn (entry)
                        let-sugar
                              [] k other-session
                              , entry
                            router $ :router other-session
                          and
                            = :watching $ :name router
                            = (:data router) session-id
                      map $ fn (entry)
                        let-sugar
                              [] k other-session
                              , entry
                          [] k $ twig-user
                            get users $ :user-id other-session
                      pairs-map
                    :expr $ case-default (:kind bookmark) nil
                      :ns $ get-in files ([] ns-text :ns)
                      :proc $ get-in files ([] ns-text :proc)
                      :def $ get-in files
                        [] ns-text :defs $ :extra bookmark
                    :peek-def $ let
                        peek-def $ :peek-def writer
                      if (some? peek-def)
                        get-in files $ [] (:ns peek-def) :defs (:def peek-def)
                        , nil
                    :picker-choices $ if
                      some? $ :picker-mode writer
                      pick-from-ns $ get files (:ns bookmark)
                    :changed $ let
                        file $ get files ns-text
                        old-file $ get old-files ns-text
                      case-default (:kind bookmark) (do :unknown)
                        :ns $ compare-entry (:ns file) (:ns old-file)
                        :proc $ compare-entry (:proc file) (:proc old-file)
                        :def $ compare-entry
                          get (:defs file) (:extra bookmark)
                          get (:defs old-file) (:extra bookmark)
                    :repl repl
                , nil
        |pick-from-ns $ quote
          defn pick-from-ns (ns-info)
            let
                var-names $ keys (:defs ns-info)
                rules $ ->
                  tree->cirru $ :ns ns-info
                  drop 2
                  mapcat $ fn (rule)
                    if
                      and (list? rule)
                        contains? (#{} "\":require" "\":require-macros") (first rule)
                      rest rule
                      , nil
                import-names $ #{} &
                  -> rules $ mapcat
                    fn (rule)
                      filter
                        fn (x) (not= x "\"[]")
                        if
                          string? $ last rule
                          [] $ last rule
                          last rule
              {} (:imported import-names) (:defined var-names)
      :proc $ quote ()
    |app.theme $ {}
      :ns $ quote
        ns app.theme $ :require ([] app.theme.star-trail :as star-trail) ([] app.theme.curves :as curves) ([] app.theme.beginner :as beginner)
      :defs $ {}
        |base-style-expr $ quote
          defn base-style-expr (theme)
            case-default theme ({}) (:star-trail star-trail/style-expr) (:curves curves/style-expr) (:beginner beginner/style-expr)
        |base-style-leaf $ quote
          defn base-style-leaf (theme)
            case-default theme ({}) (:star-trail star-trail/style-leaf) (:curves curves/style-leaf) (:beginner beginner/style-leaf)
        |decide-expr-theme $ quote
          defn decide-expr-theme (expr has-others? focused? tail? layout-mode length depth theme)
            case-default theme ({})
              :star-trail $ star-trail/decide-expr-style expr has-others? focused? tail? layout-mode length depth
              :curves $ curves/decide-expr-style expr has-others? focused? tail? layout-mode length depth
              :beginner $ beginner/decide-expr-style expr has-others? focused? tail? layout-mode length depth
        |decide-leaf-theme $ quote
          defn decide-leaf-theme (text focused? first? by-other? theme)
            case-default theme ({})
              :star-trail $ star-trail/decide-leaf-style text focused? first? by-other?
              :curves $ curves/decide-leaf-style text focused? first? by-other?
              :beginner $ beginner/decide-leaf-style text focused? first? by-other?
      :proc $ quote ()
    |app.updater.watcher $ {}
      :ns $ quote (ns app.updater.watcher)
      :defs $ {}
        |file-change $ quote
          defn file-change (db op-data _ op-id op-time)
            let
                new-files $ get-in op-data ([] :ir :files)
              if
                =
                  get-in db $ [] :ir :files
                  :saved-files db
                -> db (assoc :saved-files new-files)
                  assoc-in ([] :ir :files) new-files
                update db :saved-files $ fn (old-files)
                  -> new-files $ map-kv
                    fn (ns-text file)
                      let-sugar
                          old-file $ get old-files ns-text
                          old-defs $ :defs old-file
                        [] ns-text $ if (= file old-file) old-file
                          -> file
                            update :ns $ fn (expr)
                              let
                                  old-expr $ :ns old-file
                                if (= expr old-expr) old-expr expr
                            update :proc $ fn (expr)
                              let
                                  old-expr $ :proc old-file
                                if (= expr old-expr) old-expr expr
                            update :defs $ fn (defs)
                              -> defs $ map-kv
                                fn (def-text expr)
                                  let
                                      old-expr $ get old-file def-text
                                    [] def-text $ if (= expr old-expr) old-expr expr
      :proc $ quote ()
    |app.twig.user $ {}
      :ns $ quote
        ns app.twig.user $ :require
      :defs $ {}
        |twig-user $ quote
          defn twig-user (user)
            -> user $ dissoc :password
      :proc $ quote ()
    |app.theme.star-trail $ {}
      :ns $ quote
        ns app.theme.star-trail $ :require
          [] respo.util.format :refer $ [] hsl
          [] clojure.string :as string
          [] respo-ui.core :as ui
          [] app.polyfill :refer $ [] text-width*
          [] app.style :as style
      :defs $ {}
        |style-expr-simple $ quote
          def style-expr-simple $ {} (:display :inline-block) (:border-width "|0 0 1px 0") (:min-width 32) (:padding-left 11) (:padding-right 11) (:vertical-align :top)
        |decide-leaf-style $ quote
          defn decide-leaf-style (text focused? first? by-other?)
            let
                has-blank? $ or (= text "\"") (.includes? text "\" ")
                best-width $ + 10
                  text-width* text (:font-size style-leaf) (:font-family style-leaf)
                max-width 240
              merge
                {} $ :width (js/Math.min best-width max-width)
                if first? $ {}
                  :color $ hsl 40 85 60
                if (.starts-with? text |:)
                  {} $ :color (hsl 240 30 64)
                if
                  or (.starts-with? text ||) (.starts-with? text "|\"")
                  {} $ :color (hsl 120 60 56)
                if (.starts-with? text "|#\"")
                  {} $ :color (hsl 300 60 56)
                if
                  or (= text "\"true") (= text "\"false")
                  {} $ :color (hsl 250 50 60)
                if (= text "\"nil")
                  {} $ :color (hsl 310 60 40)
                if (> best-width max-width) style-partial
                if (.includes? text &newline) style-big
                if
                  .!test (new js/RegExp |^-?\d) text
                  , style-number
                if has-blank? style-space
                if (or focused? by-other?) style-highlight
        |style-space $ quote
          def style-space $ {}
            :background-color $ hsl 0 0 100 0.12
        |style-number $ quote
          def style-number $ {}
            :color $ hsl 0 70 40
        |style-highlight $ quote
          def style-highlight $ {}
            :background-color $ hsl 0 0 100 0.2
        |style-big $ quote
          def style-big $ {}
            :border-right $ str "|16px solid " (hsl 0 0 30)
        |decide-expr-style $ quote
          defn decide-expr-style (expr has-others? focused? tail? layout-mode length depth)
            merge ({})
              if has-others? $ {}
                :border-color $ hsl 0 0 100 0.6
              if focused? $ {}
                :border-color $ hsl 0 0 100 0.9
              if
                and (> length 0) (not tail?) (not= layout-mode :block)
                , style-expr-simple
              if tail? style-expr-tail
        |style-leaf $ quote
          def style-leaf $ {} (:line-height |24px) (:height 24) (:margin "|2px 2px") (:padding "|0px 4px") (:background-color :transparent) (:min-width 8)
            :color $ hsl 200 14 60
            :font-family style/font-code
            :font-size 15
            :vertical-align :baseline
            :text-align :left
            :border-width "|1px 1px 1px 1px"
            :resize :none
            :white-space :nowrap
            :outline :none
            :border :none
        |base-style-expr $ quote
          defn base-style-expr () style-expr
        |style-expr-tail $ quote
          def style-expr-tail $ {} (:display :inline-block) (:vertical-align :top) (:padding-left 10)
        |style-partial $ quote
          def style-partial $ {}
            :border-right $ str "|8px solid " (hsl 0 0 30)
            :padding-right 0
        |base-style-leaf $ quote
          defn base-style-leaf () style-leaf
        |style-expr $ quote
          def style-expr $ {} (:border-width "|0 0 0px 1px") (:border-style :solid)
            :border-color $ hsl 0 0 100 0.3
            :min-height 24
            :outline :none
            :padding-left 10
            :font-family |Menlo,monospace
            :font-size 14
            :margin-bottom 4
            :margin-right 2
            :margin-left 12
            :margin-top 0
            :line-height "\"1em"
      :proc $ quote ()
    |app.client $ {}
      :ns $ quote
        ns app.client $ :require
          [] respo.core :refer $ [] render! clear-cache! realize-ssr! *changes-logger
          [] app.comp.container :refer $ [] comp-container
          [] app.client-util :refer $ [] ws-host parse-query!
          [] app.util.dom :refer $ [] focus!
          [] app.util.shortcuts :refer $ [] on-window-keydown
          [] app.client-updater :as updater
          [] ws-edn.client :refer $ [] ws-connect! ws-send! ws-connected?
          [] recollect.patch :refer $ [] patch-twig
          [] cumulo-util.core :refer $ [] delay!
          [] app.config :as config
      :defs $ {}
        |ssr? $ quote
          def ssr? $ some? (.querySelector js/document |meta.respo-ssr)
        |retry-connect! $ quote
          defn retry-connect! () $ if
            and (nil? @*store) (not @*connecting?)
            connect!
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              .info js/console |Dispatch (str op) (to-js-data op-data)
            case-default op (send-op! op op-data)
              :states $ reset! *states
                let-sugar
                      [] cursor new-state
                      , op-data
                  assoc-in @*states (conj cursor :data) new-state
              :states/clear $ reset! *states
                {} $ :states
                  {} $ :cursor ([])
              :manual-state/abstract $ reset! *states (updater/abstract @*states)
              :manual-state/draft-box $ reset! *states (updater/draft-box @*states)
              :effect/save-files $ do
                reset! *states $ updater/clear-editor @*states
                send-op! op op-data
              :ir/indent $ do
                reset! *states $ updater/clear-editor @*states
                send-op! op op-data
              :ir/unindent $ do
                reset! *states $ updater/clear-editor @*states
                send-op! op op-data
              :ir/reset-files $ do
                reset! *states $ updater/clear-editor @*states
                send-op! op op-data
        |*connecting? $ quote (defatom *connecting? false)
        |*store $ quote (defatom *store nil)
        |main! $ quote
          defn main! () (load-console-formatter!)
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            if ssr? $ render-app! realize-ssr!
            ; reset! *changes-logger $ fn (global-element element changes) (println "\"Changes:" changes)
            render-app! render!
            connect!
            add-watch *store :changes $ fn (store prev) (render-app! render!)
              if
                = :editor $ get-in @*store ([] :router :name)
                focus!
            add-watch *states :changes $ fn (states prev) (render-app! render!)
            .addEventListener js/window "\"keydown" $ fn (event)
              on-window-keydown event dispatch! $ :router @*store
            .addEventListener js/window "\"focus" $ fn (event) (retry-connect!)
            .addEventListener js/window "\"visibilitychange" $ fn (event)
              when (= "\"visible" js/document.visibilityState) (retry-connect!)
            println "\"App started!"
        |*states $ quote
          defatom *states $ {}
            :states $ {}
              :cursor $ []
        |connect! $ quote
          defn connect! () (js/console.info "\"Connecting...") (reset! *connecting? true)
            ws-connect! (w-log ws-host)
              {}
                :on-open $ fn (event) (simulate-login!) (detect-watching!) (heartbeat!)
                :on-close $ fn (event) (reset! *store nil) (reset! *connecting? false) (js/console.error "\"Lost connection!") (dispatch! :states/clear nil)
                :on-data $ fn (data)
                  case-default (:kind data) (println "\"unknown kind:" data)
                    :patch $ let
                        changes $ :data data
                      when config/dev? $ js/console.log "\"Changes" changes
                      reset! *store $ patch-twig @*store changes
        |simulate-login! $ quote
          defn simulate-login! () $ let
              raw $ .getItem js/window.localStorage (:storage-key config/site)
            if (some? raw)
              do $ dispatch! :user/log-in (parse-cirru-edn raw)
              do $ println "|Found no storage."
        |detect-watching! $ quote
          defn detect-watching! () $ let
              query $ parse-query!
            when
              some? $ :watching query
              dispatch! :router/change $ {} (:name :watching)
                :data $ :watching query
        |heartbeat! $ quote
          defn heartbeat! () $ delay! 30
            fn () $ if (ws-connected?)
              do
                ws-send! $ {} (:kind :ping)
                heartbeat!
              println "\"Disabled heartbeat since connection lost."
        |render-app! $ quote
          defn render-app! (renderer)
            renderer mount-target (comp-container @*states @*store) dispatch!
        |reload! $ quote
          defn reload! () (clear-cache!) (render-app! render!) (println "|Code updated.")
        |send-op! $ quote
          defn send-op! (op op-data)
            ws-send! $ {} (:kind :op) (:op op) (:data op-data)
        |mount-target $ quote
          def mount-target $ .querySelector js/document |.app
      :proc $ quote ()
    |app.comp.theme-menu $ {}
      :ns $ quote
        ns app.comp.theme-menu $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> list-> <> span div pre input button a
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
      :defs $ {}
        |comp-theme-menu $ quote
          defcomp comp-theme-menu (states theme)
            let
                cursor $ :cursor states
                state $ if
                  some? $ :data states
                  :data states
                  , false
              div
                {}
                  :style $ {} (:position :relative) (:width 60)
                    :color $ hsl 0 0 80 0.4
                    :font-family "|Josefin Sans,sans-serif"
                    :cursor :pointer
                    :display :inline-block
                  :on-click $ fn (e d!)
                    d! cursor $ not state
                <> $ or theme "|no theme"
                if state $ list->
                  {}
                    :style $ {} (:position :absolute) (:bottom |100%) (:right 0) (:background-color :black)
                      :border $ str "\"1px solid " (hsl 0 0 100 0.2)
                    :on-click $ fn (e d!)
                  -> theme-list $ map
                    fn (theme-name)
                      [] theme-name $ div
                        {}
                          :style $ merge
                            {}
                              :color $ hsl 0 0 70
                              :padding "\"0 8px"
                            when (= theme theme-name)
                              {} $ :color :white
                          :on-click $ fn (e d!) (d! :user/change-theme theme-name) (d! cursor false)
                        <> theme-name
        |theme-list $ quote
          def theme-list $ [] :star-trail :beginner :curves
      :proc $ quote ()
    |app.twig.page-members $ {}
      :ns $ quote
        ns app.twig.page-members $ :require
          [] app.twig.member :refer $ [] twig-member
      :defs $ {}
        |twig-page-members $ quote
          defn twig-page-members (sessions users)
            -> sessions $ map-kv
              fn (k session)
                [] k $ twig-member session
                  get users $ :user-id session
      :proc $ quote ()
    |app.comp.abstract $ {}
      :ns $ quote
        ns app.comp.abstract $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp <> span div pre input button a
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] app.comp.modal :refer $ [] comp-modal
          [] app.keycode :as keycode
      :defs $ {}
        |comp-abstract $ quote
          defcomp comp-abstract (states close-modal!)
            comp-modal close-modal! $ let
                cursor $ :cursor states
                state $ or (:data states) |style-
              div ({})
                input $ {} (:style style/input) (:class-name |el-abstract) (:value state)
                  :on-input $ fn (e d!)
                    d! cursor $ :value e
                  :on-keydown $ fn (e d!)
                    cond
                        = keycode/enter $ :key-code e
                        if
                          not $ blank? state
                          do (d! :analyze/abstract-def state) (d! cursor nil) (close-modal! d!)
                      (= (:keycode e) keycode/escape)
                        close-modal! d!
                =< nil 8
                button $ {} (:style style/button) (:inner-text |Submit)
                  :on-click $ fn (e d!)
                    if
                      not $ blank? state
                      do (d! :analyze/abstract-def state) (d! cursor nil) (close-modal! d!)
      :proc $ quote ()
    |app.comp.expr $ {}
      :ns $ quote
        ns app.comp.expr $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp list-> >> <> span div a
          [] respo.comp.space :refer $ [] =<
          [] app.keycode :as keycode
          [] app.comp.leaf :refer $ [] comp-leaf
          [] app.client-util :refer $ [] coord-contains? leaf? expr? expr-many-items?
          [] app.util.shortcuts :refer $ [] on-window-keydown on-paste!
          [] app.theme :refer $ [] decide-expr-theme
          [] app.util :refer $ [] tree->cirru
          [] app.util.dom :refer $ [] do-copy-logics!
          bisection-key.util :refer $ get-min-key get-max-key
      :defs $ {}
        |comp-expr $ quote
          defcomp comp-expr (states expr focus coord others tail? layout-mode readonly? picker-mode? theme depth)
            let
                focused? $ = focus coord
                first-id $ get-min-key (:data expr)
                last-id $ get-max-key (:data expr)
                sorted-children $ -> (:data expr) (.to-list) (.sort-by first)
              list->
                {} (:tab-index 0)
                  :class-name $ str |cirru-expr (if focused? "| cirru-focused" |)
                  :style $ decide-expr-theme expr (includes? others coord) focused? tail? layout-mode (count coord) depth theme
                  :on $ if readonly?
                    {} $ :click
                      fn (e d!)
                        if picker-mode? $ do
                          .preventDefault $ :event e
                          d! :writer/pick-node $ tree->cirru expr
                    {}
                      :keydown $ on-keydown coord expr picker-mode?
                      :click $ fn (e d!)
                        if picker-mode?
                          do
                            .preventDefault $ :event e
                            d! :writer/pick-node $ tree->cirru expr
                          d! :writer/focus coord
                loop
                    result $ []
                    children sorted-children
                    prev-mode :inline
                  if (empty? children) result $ let-sugar
                        [] k child
                        first children
                      child-coord $ conj coord k
                      partial-others $ -> others
                        filter $ fn (x) (coord-contains? x child-coord)
                      cursor-key k
                      mode $ if (leaf? child) :inline
                        if (expr-many-items? child 6) :block $ case-default prev-mode :block (:inline :inline-block)
                          :inline-block $ if (expr-many-items? child 2) :block :inline-block
                    if (nil? cursor-key) (.warn js/console "|[Editor] missing cursor key" k child)
                    recur
                      conj result $ [] k
                        if
                          = :leaf $ :type child
                          comp-leaf (>> states cursor-key) child focus child-coord (includes? partial-others child-coord) (= first-id k) readonly? picker-mode? theme
                          comp-expr (>> states cursor-key) child focus child-coord partial-others (= last-id k) mode readonly? picker-mode? theme $ inc depth
                      rest children
                      , mode
        |on-keydown $ quote
          defn on-keydown (coord expr picker-mode?)
            fn (e d!)
              let
                  event $ :original-event e
                  shift? $ .-shiftKey event
                  meta? $ or (.-metaKey event) (.-ctrlKey event)
                  code $ :key-code e
                cond
                    and meta? $ = code keycode/enter
                    d! (if shift? :ir/append-leaf :ir/prepend-leaf) nil
                  (and meta? (= code keycode/enter))
                    d! :ir/prepend-leaf nil
                  (= code keycode/enter)
                    if (empty? coord) (d! :ir/prepend-leaf nil)
                      d! (if shift? :ir/expr-before :ir/expr-after) nil
                  (= code keycode/backspace) (d! :ir/delete-node nil)
                  (= code keycode/space)
                    do
                      d! (if shift? :ir/leaf-before :ir/leaf-after) nil
                      .preventDefault event
                  (= code keycode/tab)
                    do
                      d! (if shift? :ir/unindent :ir/indent) nil
                      .preventDefault event
                  (= code keycode/up)
                    do
                      if
                        not $ empty? coord
                        d! :writer/go-up nil
                      .preventDefault event
                  (= code keycode/down)
                    do
                      d! :writer/go-down $ {} (:tail? shift?)
                      .preventDefault event
                  (= code keycode/left)
                    do (d! :writer/go-left nil) (.preventDefault event)
                  (= code keycode/right)
                    do (d! :writer/go-right nil) (.preventDefault event)
                  (and meta? (= code keycode/c))
                    do-copy-logics! d!
                      format-cirru $ [] (tree->cirru expr)
                      , "\"Copied!"
                  (and meta? (= code keycode/x))
                    do
                      do-copy-logics! d!
                        format-cirru $ [] (tree->cirru expr)
                        , "\"Copied!"
                      d! :ir/delete-node nil
                  (and meta? (= code keycode/v))
                    on-paste! d!
                  (and meta? (= code keycode/b))
                    d! :ir/duplicate nil
                  (and meta? (= code keycode/d))
                    do
                      if shift?
                        let
                            tree $ tree->cirru expr
                          do $ if
                            and
                              >= (count tree) 1
                              string? $ first tree
                            d! :analyze/goto-def $ {}
                              :text $ first tree
                              :forced? true
                              :args $ .slice tree 1
                            d! :notify/push-message $ [] :warn "\"Can not create a function!"
                        do (d! :manual-state/abstract nil)
                          js/setTimeout $ fn ()
                            let
                                el $ .querySelector js/document |.el-abstract
                              if (some? el) (.focus el)
                      .preventDefault event
                  (and meta? (= code keycode/slash) (not shift?))
                    d! :ir/toggle-comment nil
                  (and picker-mode? (= code keycode/escape))
                    d! :writer/picker-mode nil
                  :else $ do
                    ; println |Keydown $ :key-code e
                    on-window-keydown event d! $ {} (:name :editor)
      :proc $ quote ()
    |app.twig.watching $ {}
      :ns $ quote
        ns app.twig.watching $ :require
          [] app.util :refer $ [] to-bookmark
          [] app.twig.user :refer $ [] twig-user
      :defs $ {}
        |twig-watching $ quote
          defn twig-watching (session my-sid files users)
            let
                writer $ :writer session
                bookmark $ to-bookmark writer
                self? $ = my-sid (:id session)
                working? $ some? bookmark
              {}
                :member $ twig-user
                  get users $ :user-id session
                :bookmark bookmark
                :router $ :router session
                :self? self?
                :working? $ and working? (not self?)
                :focus $ :focus bookmark
                :expr $ if working?
                  let
                      path $ if
                        = :def $ :kind bookmark
                        [] (:ns bookmark) :defs $ :extra bookmark
                        [] (:ns bookmark) (:kind bookmark)
                    get-in files path
      :proc $ quote ()
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> div span
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] app.comp.header :refer $ [] comp-header
          [] app.comp.profile :refer $ [] comp-profile
          [] app.comp.login :refer $ [] comp-login
          [] app.comp.page-files :refer $ [] comp-page-files
          [] app.comp.page-editor :refer $ [] comp-page-editor
          [] app.comp.page-members :refer $ [] comp-page-members
          [] app.comp.search :refer $ [] comp-search
          [] app.comp.messages :refer $ [] comp-messages
          [] app.comp.watching :refer $ [] comp-watching
          [] app.comp.about :refer $ [] comp-about
          [] app.comp.configs :refer $ [] comp-configs
          [] app.config :refer $ [] dev?
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (states store)
            let
                state $ :data states
                session $ :session store
                writer $ :writer session
                router $ :router store
                theme $ get-in store ([] :user :theme)
              if (nil? store) (comp-about)
                div
                  {} $ :style (merge ui/global ui/fullscreen ui/column style-container)
                  comp-header (>> states :header) (:name router) (:logged-in? store) (:stats store)
                  div
                    {} $ :style (merge ui/row ui/expand style-body)
                    if (:logged-in? store)
                      case-default (:name router)
                        div ({})
                          <> $ str "\"404 page: " (pr-str router)
                        :profile $ comp-profile (>> states :profile) (:user store)
                        :files $ comp-page-files (>> states :files) (:selected-ns writer) (:data router)
                        :editor $ comp-page-editor (>> states :editor) (:stack writer) (:data router) (:pointer writer)
                          some? $ :picker-mode writer
                          , theme
                        :members $ comp-page-members (:data router) (:id session)
                        :search $ comp-search (>> states :search) (:data router)
                        :watching $ comp-watching (>> states :watching) (:data router) (:theme session)
                        :configs $ comp-configs (>> states :configs) (:data router)
                      if
                        = :watching $ :name router
                        comp-watching (>> states :watching) (:data router) (:theme session)
                        comp-login $ >> states :login
                  when dev? $ comp-inspect |Session store style-inspector
                  ; when dev? $ comp-inspect "|Router data" states
                    merge style-inspector $ {} (:left 100)
                  comp-messages $ get-in store ([] :session :notifications)
        |style-body $ quote
          def style-body $ {} (:padding-top 12)
        |style-container $ quote
          def style-container $ {} (:background-color :black) (:color :white)
        |style-inspector $ quote
          def style-inspector $ {} (:bottom 0) (:left 0) (:max-width |100%)
            :background-color $ hsl 0 0 50
            :color :black
            :opacity 1
      :proc $ quote ()
    |app.util.stack $ {}
      :ns $ quote (ns app.util.stack)
      :defs $ {}
        |=bookmark? $ quote
          defn =bookmark? (x y)
            and
              = (:kind x) (:kind y)
              = (:ns x) (:ns y)
              = (:extra x) (:extra y)
        |index-of-bookmark $ quote
          defn index-of-bookmark (stack bookmark ? idx)
            if (empty? stack) -1 $ let
                idx $ or idx 0
              if
                =bookmark? bookmark $ first stack
                , idx $ recur (rest stack) bookmark (inc idx)
        |push-bookmark $ quote
          defn push-bookmark (bookmark ? forced?)
            fn (writer)
              let-sugar
                    {} pointer stack
                    , writer
                  idx $ index-of-bookmark stack bookmark
                if
                  or forced? (nil? idx) (< idx 0)
                  -> writer
                    update :stack $ fn (stack)
                      cond
                          empty? stack
                          [] bookmark
                        (= pointer (dec (count stack)))
                          conj stack bookmark
                        (=bookmark? bookmark (get stack (inc pointer)))
                          , stack
                        true $ concat
                          take stack $ inc pointer
                          [] bookmark
                          drop stack $ inc pointer
                    update :pointer $ fn (p)
                      if (empty? stack) 0 $ inc p
                  -> writer $ assoc :pointer idx
      :proc $ quote ()
    |app.theme.beginner $ {}
      :ns $ quote
        ns app.theme.beginner $ :require ([] app.theme.star-trail :as star-trail)
          [] respo.util.format :refer $ [] hsl
      :defs $ {}
        |decide-expr-style $ quote
          defn decide-expr-style (expr has-others? focused? tail? layout-mode length depth)
            merge (star-trail/decide-expr-style expr has-others? focused? tail? layout-mode length depth) style-expr-beginner
        |decide-leaf-style $ quote
          defn decide-leaf-style (text focused? first? by-other?)
            merge $ star-trail/decide-leaf-style text focused? first? by-other?
        |style-expr $ quote (def style-expr star-trail/style-expr)
        |style-expr-beginner $ quote
          def style-expr-beginner $ {}
            :outline $ str "|1px solid " (hsl 200 80 70 0.2)
        |style-leaf $ quote (def style-leaf star-trail/style-leaf)
      :proc $ quote ()
    |app.util.env $ {}
      :ns $ quote
        ns app.util.env $ :require ([] "\"chalk" :as chalk)
          [] app.util.detect :refer $ [] port-taken?
          [] "\"latest-version" :default latest-version
          [] "\"path" :as path
          [] "\"fs" :as fs
      :defs $ {}
        |check-version! $ quote
          defn check-version! () $ let
              pkg $ js/JSON.parse
                fs/readFileSync $ path/join js/__dirname "\"../package.json"
              version $ aget pkg "\"version"
              pkg-name $ aget pkg "\"name"
            -> (latest-version pkg-name)
              .then $ fn (npm-version)
                println $ if (= version npm-version) (str "\"Running latest version " version)
                  chalk/yellow $ str "\"Update is available tagged " npm-version "\", current one is " version
              .catch $ fn (e) (js/console.log "\"failed to request version:" e)
        |get-cli-configs! $ quote
          defn get-cli-configs! () $ let
              env js/process.env
            {} $ :compile?
              = "\"compile" $ aget env "\"op"
        |pick-port! $ quote
          defn pick-port! (port next-fn)
            port-taken? port $ fn (err taken?)
              if (some? err)
                do (js/console.error err) (js/process.exit 1)
                if taken?
                  do
                    println $ str "\"port " port "\" is in use."
                    pick-port! (inc port) next-fn
                  do
                    let
                        link $ chalk/blue (str "\"http://calcit-editor.cirru.org?port=" port)
                      println $ str "\"port " port "\" is ok, please edit on " link
                    next-fn port
      :proc $ quote ()
    |app.util.compile $ {}
      :ns $ quote
        ns app.util.compile $ :require
          [] app.util :refer $ [] file->cirru db->string tree->cirru now! hide-empty-fields
          [] "\"chalk" :as chalk
          [] "\"path" :as path
          [] "\"fs" :as fs
          [] "\"child_process" :as cp
          [] "\"md5" :default md5
          [] app.config :as config
          [] cumulo-util.core :refer $ [] unix-time!
          [] applied-science.js-interop :as j
          [] cirru-edn.core :as cirru-edn
      :defs $ {}
        |handle-files! $ quote
          defn handle-files! (db *calcit-md5 configs dispatch! save-ir? filter-ns)
            try
              let
                  new-files $ get-in db ([] :ir :files)
                  old-files $ get db :saved-files
                  new-names $ keys new-files
                  old-names $ keys old-files
                  filter-by-ns $ fn (xs)
                    if (some? filter-ns)
                      if (contains? xs filter-ns) ([] filter-ns) nil
                      , xs
                  added-names $ filter-by-ns (difference new-names old-names)
                  removed-names $ filter-by-ns (difference old-names new-names)
                  changed-names $ -> (intersection new-names old-names)
                    filter $ fn (ns-text)
                      not= (get new-files ns-text) (get old-files ns-text)
                    filter-by-ns
                handle-compact-files!
                  get-in db $ [] :ir :package
                  , old-files new-files added-names removed-names changed-names (:configs db) filter-ns
                dispatch! :writer/save-files filter-ns
                if save-ir? $ js/setTimeout
                  fn () $ let
                      db-content $ db->string db
                      started-time $ unix-time!
                    reset! *calcit-md5 $ md5 db-content
                    persist-async! (:storage-file config/site) db-content started-time
              fn (e)
                do
                  println $ chalk/red e
                  js/console.error e
                  dispatch! :notify/push-message $ [] :error (aget e "\"message")
        |path $ quote
          def path $ js/require |path
        |persist! $ quote
          defn persist! (storage-path db-str started-time) (fs/writeFileSync storage-path db-str)
            println $ chalk/gray
              str "|took "
                - (unix-time!) started-time
                , "|ms to wrote calcit.cirru"
        |remove-file! $ quote
          defn remove-file! (file-path output-dir)
            let
                project-path $ path/join output-dir file-path
              cp/execSync $ str "|rm -rfv " project-path
              println $ chalk/red (str "|removed " project-path)
        |handle-compact-files! $ quote
          defn handle-compact-files! (pkg old-files latest-files added-names removed-names changed-names configs filter-ns)
            let
                new-files $ if (some? filter-ns)
                  let
                      target $ get latest-files filter-ns
                    if (some? target) (assoc old-files filter-ns target) (dissoc old-files filter-ns)
                  , latest-files
                compact-data $ {} (:package pkg)
                  :configs $ {}
                    :init-fn $ :init-fn configs
                    :reload-fn $ :reload-fn configs
                    :modules $ :modules configs
                    :version $ :version configs
                  :files $ -> new-files
                    map-kv $ fn (k v)
                      [] k $ file->cirru v
                inc-data $ hide-empty-fields
                  {} (:removed removed-names)
                    :added $ -> added-names
                      map $ fn (ns-text)
                        [] ns-text $ file->cirru (get new-files ns-text)
                      pairs-map
                    :changed $ -> changed-names
                      map $ fn (ns-text)
                        [] ns-text $ let
                            old-file $ get old-files ns-text
                            new-file $ get new-files ns-text
                            old-defs $ :defs old-file
                            new-defs $ :defs new-file
                            old-def-names $ keys old-defs
                            new-def-names $ keys new-defs
                            added-defs $ difference new-def-names old-def-names
                            removed-defs $ difference old-def-names new-def-names
                            changed-defs $ -> (intersection old-def-names new-def-names)
                              filter $ fn (x)
                                not= (get old-defs x) (get new-defs x)
                          hide-empty-fields $ {}
                            :ns $ if
                              = (:ns old-file) (:ns new-file)
                              , nil
                                :: 'quote $ tree->cirru (:ns new-file)
                            :proc $ if
                              = (:proc old-file) (:proc new-file)
                              , nil
                                :: 'quote $ tree->cirru (:proc new-file)
                            :removed-defs removed-defs
                            :added-defs $ -> added-defs
                              map $ fn (x)
                                [] x $ :: 'quote
                                  tree->cirru $ get new-defs x
                              hide-empty-fields
                            :changed-defs $ -> changed-defs
                              map $ fn (x)
                                [] x $ :: 'quote
                                  tree->cirru $ get new-defs x
                              hide-empty-fields
                      pairs-map
              fs/writeFile "\"compact.cirru" (format-cirru-edn compact-data)
                fn (err)
                  if (some? err) (js/console.log "\"Failed to write!" err)
              fs/writeFile "\".compact-inc.cirru" (format-cirru-edn inc-data)
                fn (err)
                  if (some? err) (js/console.log "\"Failed to write!" err)
        |persist-async! $ quote
          defn persist-async! (storage-path db-str started-time)
            fs/writeFile storage-path db-str $ fn (err)
              if (some? err)
                js/console.log $ chalk/red "\"Failed to write storage!" err
                println $ chalk/gray
                  str "|took "
                    - (unix-time!) started-time
                    , "|ms to wrote calcit.cirru"
      :proc $ quote ()
    |app.updater.notify $ {}
      :ns $ quote
        ns app.updater.notify $ :require
          [] app.util :refer $ [] push-info
      :defs $ {}
        |broadcast $ quote
          defn broadcast (db op-data sid op-id op-time)
            let
                user-id $ get-in db ([] :sessions sid :user-id)
                user-name $ get-in db ([] :users user-id :name)
              update db :sessions $ fn (sessions)
                -> sessions $ map-kv
                  fn (k session)
                    [] k $ update session :notifications
                      push-info op-id op-time $ str user-name "\": " op-data
        |clear $ quote
          defn clear (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :notifications) ([])
        |push-message $ quote
          defn push-message (db op-data sid op-id op-time)
            let-sugar
                  [] kind text
                  , op-data
              update-in db ([] :sessions sid :notifications)
                fn (xs)
                  conj xs $ {} (:id op-id) (:kind kind) (:text text) (:time op-time)
      :proc $ quote ()
    |app.twig.member $ {}
      :ns $ quote
        ns app.twig.member $ :require
      :defs $ {}
        |twig-member $ quote
          defn twig-member (session user)
            {} (:user user)
              :nickname $ :nickname session
              :bookmark $ let
                  writer $ :writer session
                get (:stack writer) (:pointer writer)
              :page $ get-in session ([] :router :name)
      :proc $ quote ()
    |app.comp.file-replacer $ {}
      :ns $ quote
        ns app.comp.file-replacer $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> span div pre input button a textarea
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] app.comp.modal :refer $ [] comp-modal
          [] cljs.reader :refer $ [] read-string
      :defs $ {}
        |comp-file-replacer $ quote
          defcomp comp-file-replacer (states file)
            let
                cursor $ :cursor states
                state $ or (:data states) (format-cirru file)
              comp-modal
                fn (d!) (d! :writer/draft-ns nil)
                div
                  {} $ :style ui/column
                  textarea $ {} (:value state)
                    :style $ merge style/input
                      {} (:width 800) (:height 400)
                    :on-input $ fn (e d!)
                      d! cursor $ :value e
                  =< nil 8
                  div
                    {} $ :style
                      merge ui/row $ {} (:justify-content :flex-end)
                    button $ {} (:inner-text "\"Submit") (:style style/button)
                      :on-click $ fn (e d!)
                        if
                          not= state $ format-cirru file
                          d! :ir/replace-file $ parse-cirru state
                        d! cursor nil
                        d! :writer/draft-ns nil
      :proc $ quote ()
    |app.comp.leaf $ {}
      :ns $ quote
        ns app.comp.leaf $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp <> span div input textarea a
          [] respo.comp.space :refer $ [] =<
          [] polyfill.core :refer $ [] text-width*
          [] app.keycode :as keycode
          [] app.util :as util
          [] app.util.shortcuts :refer $ [] on-window-keydown on-paste!
          [] app.theme :refer $ [] decide-leaf-theme
          [] app.util :refer $ [] tree->cirru
          [] app.util.dom :refer $ [] do-copy-logics!
      :defs $ {}
        |comp-leaf $ quote
          defcomp comp-leaf (states leaf focus coord by-other? first? readonly? picker-mode? theme)
            let
                cursor $ :cursor states
                state $ or (:data states) initial-state
                text $ or
                  if
                    > (:at state) (:at leaf)
                    :text state
                    :text leaf
                  , "\""
                focused? $ = focus coord
              textarea $ {} (:value text) (:spellcheck false)
                :class-name $ str "\"cirru-leaf"
                  if (= focus coord) "\" cirru-focused" "\""
                :read-only readonly?
                :style $ decide-leaf-theme text focused? first? by-other? theme
                :on $ if readonly?
                  {} $ :click (on-focus leaf coord picker-mode?)
                  {}
                    :click $ on-focus leaf coord picker-mode?
                    :keydown $ on-keydown state leaf coord picker-mode?
                    :input $ on-input state coord cursor
        |initial-state $ quote
          def initial-state $ {} (:text |) (:at 0)
        |on-focus $ quote
          defn on-focus (leaf coord picker-mode?)
            fn (e d!)
              if picker-mode?
                do
                  .preventDefault $ :event e
                  d! :writer/pick-node $ tree->cirru leaf
                d! :writer/focus coord
        |on-input $ quote
          defn on-input (state coord cursor)
            fn (e d!)
              let
                  now $ util/now!
                d! :ir/update-leaf $ {}
                  :text $ :value e
                  :at now
                d! cursor $ assoc state :text (:value e) :at now
        |on-keydown $ quote
          defn on-keydown (state leaf coord picker-mode?)
            fn (e d!)
              let
                  event $ :original-event e
                  code $ :key-code e
                  shift? $ .-shiftKey event
                  meta? $ or (.-metaKey event) (.-ctrlKey event)
                  selected? $ not= (-> event .-target .-selectionStart) (-> event .-target .-selectionEnd)
                  text $ if
                    > (:at state) (:at leaf)
                    :text state
                    :text leaf
                  text-length $ count text
                cond
                    = code keycode/backspace
                    if
                      and $ = | text
                      d! :ir/delete-node nil
                  (and (= code keycode/space) (not shift?))
                    do (d! :ir/leaf-after nil) (.preventDefault event)
                  (= code keycode/enter)
                    do
                      d! (if shift? :ir/leaf-before :ir/leaf-after) nil
                      .preventDefault event
                  (= code keycode/tab)
                    do
                      d! (if shift? :ir/unindent-leaf :ir/indent) nil
                      .preventDefault event
                  (= code keycode/up)
                    do
                      if
                        not $ empty? coord
                        d! :writer/go-up nil
                      .preventDefault event
                  (and (not selected?) (= code keycode/left))
                    if
                      = 0 $ -> event .-target .-selectionStart
                      do (d! :writer/go-left nil) (.preventDefault event)
                  (and meta? (= code keycode/b))
                    d! :analyze/peek-def $ :text leaf
                  (and (not selected?) (= code keycode/right))
                    if
                      = text-length $ -> event .-target .-selectionEnd
                      do (d! :writer/go-right nil) (.!preventDefault event)
                  (and meta? (= code keycode/c) (= (.-selectionStart (.-target event)) (.-selectionEnd (.-target event))))
                    do-copy-logics! d! (tree->cirru leaf) "\"Copied!"
                  (and meta? shift? (= code keycode/v))
                    do (on-paste! d!) (.preventDefault event)
                  (and meta? (= code keycode/d))
                    do (.preventDefault event)
                      if
                        -> ([] "\"\"" "\"|" "\"#\"")
                          any? $ fn (x)
                            starts-with? (:text leaf) x
                        do (d! :manual-state/draft-box nil)
                          js/setTimeout $ fn ()
                            let
                                el $ .querySelector js/document |.el-draft-box
                              if (some? el) (.focus el)
                        d! :analyze/goto-def $ {}
                          :text $ :text leaf
                          :forced? shift?
                  (and meta? (= code keycode/slash) (not shift?))
                    do $ .open js/window
                      str |https://clojuredocs.org/search?q= $ last
                        split (:text leaf) "\"/"
                  (and picker-mode? (= code keycode/escape))
                    d! :writer/picker-mode nil
                  true $ do (; println "|Keydown leaf" code)
                    on-window-keydown event d! $ {} (:name :editor)
      :proc $ quote ()
    |app.comp.messages $ {}
      :ns $ quote
        ns app.comp.messages $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp list-> <> span div pre input button a
          [] respo.comp.space :refer $ [] =<
          [] app.client-util :as util
          [] app.style :as style
          [] "\"dayjs" :default Dayjs
      :defs $ {}
        |comp-messages $ quote
          defcomp comp-messages (messages)
            list-> ({})
              -> messages
                drop $ js/Math.max
                  - (count messages) 4
                  , 0
                map-indexed $ fn (idx msg)
                  [] (:id msg)
                    div
                      {}
                        :style $ merge style-message
                          {}
                            :bottom $ + 12 (* idx 40)
                            :color $ case-default (:kind msg) (hsl 120 80 80)
                              :error $ hsl 0 80 80
                              :warning $ hsl 60 80 80
                              :info $ hsl 240 80 80
                        :on-click $ fn (e d!) (d! :notify/clear nil)
                      <>
                        -> (:time msg) Dayjs $ .format "\"mm:ss"
                        {} (:font-size 12) (:font-family ui/font-code) (:opacity 0.7)
                      =< 8 nil
                      <> (:text msg) nil
        |style-message $ quote
          def style-message $ {} (:position :absolute) (:right 8) (:cursor :pointer) (:font-weight 100) (:font-family |Hind)
            :background-color $ hsl 0 0 0 0.7
            :border $ str "|1px solid " (hsl 0 0 100 0.2)
            :padding "|0 8px"
            :transition-duration |200ms
      :proc $ quote ()
    |app.util.list $ {}
      :ns $ quote (ns app.util.list)
      :defs $ {}
        |cirru-form? $ quote
          defn cirru-form? (x)
            if (string? x) true $ if (list? x) (map x cirru-form?) false
        |dissoc-idx $ quote
          defn dissoc-idx (xs idx)
            if
              or (< idx 0)
                > idx $ dec (count xs)
              raise "|Index out of bound!"
            cond
                = 0 idx
                .slice xs 1
              (= idx (dec (count xs)))
                butlast xs
              true $ concat (take idx xs)
                drop (inc idx) xs
        |compare-entry $ quote
          defn compare-entry (new-x old-x)
            cond
                and (nil? old-x) (some? new-x)
                , :add
              (and (some? old-x) (nil? new-x))
                , :remove
              (and (some? old-x) (some? new-x) (not (identical? old-x new-x)))
                , :changed
              :else :same
      :proc $ quote ()
    |app.updater.ir $ {}
      :ns $ quote
        ns app.updater.ir $ :require ([] app.schema :as schema) ([] bisection-key.core :as bisection)
          [] app.util :refer $ [] expr? leaf? bookmark->path to-writer to-bookmark to-keys cirru->tree cirru->file
          [] app.util.list :refer $ [] dissoc-idx
          [] bisection-key.util :refer $ [] key-before key-after key-prepend key-append assoc-prepend key-nth assoc-nth val-nth
          [] clojure.string :as string
          [] app.util :refer $ [] push-warning
      :defs $ {}
        |rename $ quote
          defn rename (db op-data session-id op-id op-time)
            let
                kind $ :kind op-data
                ns-info $ :ns op-data
                extra-info $ :extra op-data
                idx $ get-in db ([] :sessions session-id :writer :pointer)
                user-id $ get-in db ([] :sessions session-id :user-id)
              cond
                  = :ns kind
                  let
                      old-ns $ :from ns-info
                      new-ns $ :to ns-info
                      expr $ get-in db ([] :ir :files old-ns :ns)
                      next-id $ key-nth (:data expr) 1
                    -> db
                      update-in ([] :ir :files)
                        fn (files)
                          -> files (dissoc old-ns)
                            assoc new-ns $ get files old-ns
                      assoc-in ([] :sessions session-id :writer :stack idx :ns) new-ns
                      update-in ([] :ir :files new-ns :ns :data next-id :text)
                        fn (x) new-ns
                (= :def kind)
                  let
                      old-ns $ :from ns-info
                      new-ns $ :to ns-info
                      old-def $ :from extra-info
                      new-def $ :to extra-info
                      expr $ get-in db ([] :ir :files old-ns :defs old-def)
                      next-id $ key-nth (:data expr) 1
                      files $ get-in db ([] :ir :files)
                    if (contains? files new-ns)
                      -> db
                        update-in ([] :ir :files)
                          fn (files)
                            -> files
                              update-in ([] old-ns :defs)
                                fn (file) (dissoc file old-def)
                              assoc-in ([] new-ns :defs new-def)
                                get-in files $ [] old-ns :defs old-def
                        update-in ([] :sessions session-id :writer :stack idx)
                          fn (bookmark)
                            -> bookmark (assoc :ns new-ns) (assoc :extra new-def)
                        update-in ([] :ir :files new-ns :defs new-def :data)
                          fn (def-data)
                            let
                                try-1 $ :text (val-nth def-data 1)
                              if
                                and (string? try-1)
                                  = "\"^" $ first try-1
                                assoc-nth def-data 2 $ cirru->tree new-def user-id op-time
                                assoc-nth def-data 1 $ cirru->tree new-def user-id op-time
                      -> db $ update-in ([] :sessions session-id :notifications)
                        push-warning op-id op-time $ str "\"no namespace: " new-ns
                true $ do (println "|Unexpected kind:" kind) db
        |add-def $ quote
          defn add-def (db op-data session-id op-id op-time)
            assert (list? op-data) "\"expects op-data of [ns text]"
            let-sugar
                  [] ns-part def-part
                  , op-data
                user-id $ get-in db ([] :sessions session-id :user-id)
                cirru-expr $ [] |defn def-part ([])
              when (nil? ns-part)
                println $ get-in db ([] :sessions session-id :writer)
                raise "\"Empty ns target."
              assoc-in db ([] :ir :files ns-part :defs def-part) (cirru->tree cirru-expr user-id op-time)
        |leaf-before $ quote
          defn leaf-before (db op-data session-id op-id op-time)
            let
                writer $ to-writer db session-id
                bookmark $ to-bookmark writer
                parent-bookmark $ update bookmark :focus butlast
                data-path $ bookmark->path parent-bookmark
                target-expr $ get-in db data-path
                next-id $ key-before (:data target-expr)
                  last $ :focus bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
                new-leaf $ assoc schema/leaf :at op-time :by user-id
              -> db
                update-in data-path $ fn (expr)
                  assoc-in expr ([] :data next-id) new-leaf
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus)
                    conj (butlast focus) next-id
        |reset-at $ quote
          defn reset-at (db op-data session-id op-id op-time)
            let
                saved-files $ :saved-files db
                old-file $ get saved-files (:ns op-data)
              update-in db
                [] :ir :files $ :ns op-data
                fn (file)
                  case-default (:kind op-data)
                    raise $ str "|Malformed data: " (pr-str op-data)
                    :ns $ assoc file :ns (:ns old-file)
                    :proc $ assoc file :proc (:proc old-file)
                    :def $ let
                        def-text $ :extra op-data
                      assoc-in file ([] :defs def-text)
                        get-in old-file $ [] :defs def-text
        |leaf-after $ quote
          defn leaf-after (db op-data session-id op-id op-time)
            let-sugar
                writer $ get-in db ([] :sessions session-id :writer)
                ({} stack pointer) writer
                bookmark $ get stack pointer
                parent-bookmark $ update bookmark :focus butlast
                data-path $ bookmark->path parent-bookmark
                target-expr $ get-in db data-path
                next-id $ key-after (:data target-expr)
                  last $ :focus bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
                new-leaf $ assoc schema/leaf :at op-time :by user-id
              -> db
                update-in data-path $ fn (expr)
                  assoc-in expr ([] :data next-id) new-leaf
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus)
                    conj (butlast focus) next-id
        |expr-replace $ quote
          defn expr-replace (db op-data session-id op-id op-time)
            let
                from $ :from op-data
                to $ :to op-data
                bookmark $ :bookmark op-data
                data-path $ bookmark->path bookmark
              update-in db data-path $ fn (expr) (call-replace-expr expr from to)
        |call-replace-expr $ quote
          defn call-replace-expr (expr from to)
            case-default (:type expr)
              do $ println "\"Unknown expr" expr
              :expr $ update expr :data
                fn (data)
                  -> data (.to-list)
                    map $ fn (pair)
                      let[] (k v) pair $ [] k (call-replace-expr v from to)
                    filter-not $ fn (pair)
                      let[] (k v) pair $ and
                        = (:type v) :leaf
                        blank? $ :text v
                    pairs-map
              :leaf $ cond
                  = (:text expr) from
                  assoc expr :text to
                (= (:text expr) (str "\"@" from))
                  assoc expr :text $ str "\"@" to
                true expr
        |reset-ns $ quote
          defn reset-ns (db op-data session-id op-id op-time)
            let
                ns-text op-data
              assoc-in db ([] :ir :files ns-text)
                get-in db $ [] :saved-files ns-text
        |reset-files $ quote
          defn reset-files (db op-data session-id op-id op-time)
            assoc-in db ([] :ir :files) (:saved-files db)
        |remove-ns $ quote
          defn remove-ns (db op-data session-id op-id op-time)
            -> db
              update-in ([] :ir :files)
                fn (files) (dissoc files op-data)
              update-in ([] :sessions session-id :writer :selected-ns)
                fn (x)
                  if (= x op-data) nil x
        |prepend-leaf $ quote
          defn prepend-leaf (db op-data session-id op-id op-time)
            let-sugar
                writer $ get-in db ([] :sessions session-id :writer)
                ({} stack pointer) writer
                bookmark $ get stack pointer
                focus $ :focus bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
                new-leaf $ assoc schema/leaf :by user-id :at op-time
                expr-path $ bookmark->path bookmark
                target-expr $ get-in db expr-path
                new-id $ key-prepend (:data target-expr)
              -> db
                update-in expr-path $ fn (expr)
                  if (expr? expr)
                    assoc-in expr ([] :data new-id) new-leaf
                    , expr
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus) (conj focus new-id)
        |duplicate $ quote
          defn duplicate (db op-data session-id op-id op-time)
            let
                writer $ to-writer db session-id
                bookmark $ to-bookmark writer
                target-expr $ get-in db (bookmark->path bookmark)
                parent-path $ bookmark->path (update bookmark :focus butlast)
                parent-expr $ get-in db parent-path
                next-id $ key-after (:data parent-expr)
                  last $ :focus bookmark
              -> db
                update-in parent-path $ fn (expr)
                  update expr :data $ fn (data) (assoc data next-id target-expr)
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus)
                    conj (butlast focus) next-id
        |expr-before $ quote
          defn expr-before (db op-data session-id op-id op-time)
            let
                writer $ to-writer db session-id
                bookmark $ to-bookmark writer
                parent-bookmark $ update bookmark :focus butlast
                data-path $ bookmark->path parent-bookmark
                target-expr $ get-in db data-path
                next-id $ key-before (:data target-expr)
                  last $ :focus bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
                new-leaf $ assoc schema/leaf :at op-time :by user-id
                new-expr $ -> schema/expr (assoc :at op-time :by user-id)
                  assoc-in ([] :data bisection/mid-id) new-leaf
              -> db
                update-in data-path $ fn (expr)
                  assoc-in expr ([] :data next-id) new-expr
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus)
                    conj (butlast focus) next-id bisection/mid-id
        |update-leaf $ quote
          defn update-leaf (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                bookmark $ get (:stack writer) (:pointer writer)
                data-path $ bookmark->path bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
              -> db $ update-in data-path
                fn (leaf)
                  if
                    and
                      some? $ :at op-data
                      some? $ :text op-data
                      > (:at op-data) (:at leaf)
                    assoc leaf :text (:text op-data) :at (:at op-data) :by user-id
                    do (println "\"invalid updata op:" op-data) leaf
        |unindent $ quote
          defn unindent (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                bookmark $ get (:stack writer) (:pointer writer)
                parent-bookmark $ update bookmark :focus butlast
                last-coord $ last (:focus bookmark)
                parent-path $ bookmark->path parent-bookmark
              -> db
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus) (butlast focus)
                update-in parent-path $ fn (base-expr)
                  let
                      expr $ get-in base-expr ([] :data last-coord)
                      child-keys $ sort
                        .to-list $ keys (:data base-expr)
                      children $ -> (:data expr) (.to-list) (.sort-by first) (map last)
                      idx $ .index-of child-keys last-coord
                      limit-id $ if
                        = idx $ dec (count child-keys)
                        , bisection/max-id
                          get child-keys $ inc idx
                    loop
                        result base-expr
                        xs children
                        next-id last-coord
                      if (empty? xs) result $ recur
                        assoc-in result ([] :data next-id) (first xs)
                        rest xs
                        bisection/bisect next-id limit-id
        |file-config $ quote
          defn file-config (db op-data sid op-id op-time)
            let
                ns-text $ get-in db ([] :sessions sid :writer :selected-ns)
              if (some? ns-text)
                update-in db ([] :ir :files ns-text :configs)
                  fn (configs) (merge configs op-data)
                , db
        |indent $ quote
          defn indent (db op-data session-id op-id op-time)
            let-sugar
                writer $ get-in db ([] :sessions session-id :writer)
                ({} stack pointer) writer
                bookmark $ get stack pointer
                data-path $ bookmark->path bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
                new-expr $ assoc schema/expr :at op-time :by user-id
              -> db
                update-in data-path $ fn (node)
                  assoc-in new-expr ([] :data bisection/mid-id) node
                update-in ([] :sessions session-id :writer :stack pointer :focus)
                  fn (focus)
                    if (empty? focus) ([] bisection/mid-id)
                      concat (butlast focus)
                        [] (last focus) bisection/mid-id
        |remove-def $ quote
          defn remove-def (db op-data session-id op-id op-time)
            let
                selected-ns $ get-in db ([] :sessions session-id :writer :selected-ns)
              update-in db ([] :ir :files selected-ns :defs)
                fn (defs) (dissoc defs op-data)
        |replace-file $ quote
          defn replace-file (db op-data sid op-id op-time)
            let
                user-id $ get-in db ([] :sessions sid :user-id)
                ns-text $ get-in db ([] :sessions sid :writer :draft-ns)
              if (some? ns-text)
                assoc-in db ([] :ir :files ns-text) (cirru->file op-data user-id op-time)
                do (println "|undefined draft-ns") db
        |append-leaf $ quote
          defn append-leaf (db op-data session-id op-id op-time)
            let-sugar
                writer $ get-in db ([] :sessions session-id :writer)
                ({} stack pointer) writer
                bookmark $ get stack pointer
                focus $ :focus bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
                new-leaf $ assoc schema/leaf :by user-id :at op-time
                expr-path $ bookmark->path bookmark
                target-expr $ get-in db expr-path
                new-id $ key-append (:data target-expr)
              -> db
                update-in expr-path $ fn (expr)
                  if (expr? expr)
                    assoc-in expr ([] :data new-id) new-leaf
                    , expr
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus) (conj focus new-id)
        |cp-ns $ quote
          defn cp-ns (db op-data session-id op-id op-time)
            update-in db ([] :ir :files)
              fn (files)
                -> files $ assoc (:to op-data)
                  get files $ :from op-data
        |mv-ns $ quote
          defn mv-ns (db op-data session-id op-id op-time)
            update-in db ([] :ir :files)
              fn (files)
                -> files
                  dissoc $ :from op-data
                  assoc (:to op-data)
                    get files $ :from op-data
        |delete-node $ quote
          defn delete-node (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                bookmark $ get (:stack writer) (:pointer writer)
                parent-bookmark $ update bookmark :focus butlast
                data-path $ bookmark->path parent-bookmark
                child-keys $ sort
                  .to-list $ keys
                    :data $ get-in db data-path
                deleted-key $ last (:focus bookmark)
                idx $ .index-of child-keys deleted-key
              -> db
                update-in data-path $ fn (expr)
                  update expr :data $ fn (children) (dissoc children deleted-key)
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus)
                    if (= 0 idx) (butlast focus)
                      assoc focus
                        dec $ count focus
                        get child-keys $ dec idx
        |expr-after $ quote
          defn expr-after (db op-data session-id op-id op-time)
            let
                writer $ to-writer db session-id
                bookmark $ to-bookmark writer
                parent-bookmark $ update bookmark :focus butlast
                data-path $ bookmark->path parent-bookmark
                target-expr $ get-in db data-path
                next-id $ key-after (:data target-expr)
                  last $ :focus bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
                new-leaf $ assoc schema/leaf :at op-time :by user-id
                new-expr $ -> schema/expr (assoc :at op-time :by user-id)
                  assoc-in ([] :data bisection/mid-id) new-leaf
              -> db
                update-in data-path $ fn (expr)
                  assoc-in expr ([] :data next-id) new-expr
                update-in
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  fn (focus)
                    -> (butlast focus) (conj next-id) (conj bisection/mid-id)
        |toggle-comment $ quote
          defn toggle-comment (db op-data sid op-id op-time)
            let
                writer $ to-writer db sid
                bookmark $ to-bookmark writer
                data-path $ bookmark->path bookmark
                user-id $ get-in db ([] :sessions sid :user-id)
              update-in db data-path $ fn (node)
                if
                  = :expr $ :type node
                  update node :data $ fn (data)
                    let
                        k0 $ apply min (keys data)
                      if
                        and (some? k0)
                          = "\";" $ get-in data ([] k0 :text)
                        dissoc data k0
                        assoc-prepend data $ cirru->tree "\";" user-id op-time
                  do (println "\"Toggle comment at wrong place," node) node
        |draft-expr $ quote
          defn draft-expr (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                bookmark $ get (:stack writer) (:pointer writer)
                data-path $ bookmark->path bookmark
                user-id $ get-in db ([] :sessions session-id :user-id)
              -> db $ update-in data-path
                fn (expr) (cirru->tree op-data user-id op-time)
        |add-ns $ quote
          defn add-ns (db op-data session-id op-id op-time)
            let
                user-id $ get-in db ([] :sessions session-id :user-id)
                cirru-expr $ [] |ns op-data
                default-expr $ cirru->tree cirru-expr user-id op-time
                empty-expr $ cirru->tree ([]) user-id op-time
              -> db
                assoc-in ([] :ir :files op-data)
                  -> schema/file (assoc :ns default-expr) (assoc :proc empty-expr)
                assoc-in ([] :sessions session-id :writer :selected-ns) op-data
        |delete-entry $ quote
          defn delete-entry (db op-data session-id op-id op-time) (; println |delete op-data)
            case-default (:kind op-data)
              do (println "\"[warning] no entry to delete") db
              :def $ -> db
                update-in
                  [] :ir :files (:ns op-data) :defs
                  fn (defs)
                    dissoc defs $ :extra op-data
                update-in ([] :sessions session-id :writer)
                  fn (writer)
                    -> writer
                      update :stack $ fn (stack)
                        dissoc-idx stack $ :pointer writer
                      update :pointer dec
              :ns $ -> db
                update-in ([] :ir :files)
                  fn (files)
                    dissoc files $ :ns op-data
                update-in ([] :sessions session-id :writer)
                  fn (writer)
                    -> writer
                      update :stack $ fn (stack)
                        dissoc-idx stack $ :pointer writer
                      update :pointer dec
        |unindent-leaf $ quote
          defn unindent-leaf (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                bookmark $ get (:stack writer) (:pointer writer)
                parent-bookmark $ update bookmark :focus butlast
                parent-path $ bookmark->path parent-bookmark
                parent-expr $ get-in db parent-path
              if
                = 1 $ count (:data parent-expr)
                -> db
                  update-in parent-path $ fn (expr)
                    first $ vals (:data expr)
                  update-in
                    [] :sessions session-id :writer :stack (:pointer writer) :focus
                    fn (focus) (butlast focus)
                , db
        |clone-ns $ quote
          defn clone-ns (db op-data sid op-id op-time)
            let
                writer $ get-in db ([] :sessions sid :writer)
                selected-ns $ :selected-ns writer
                files $ get-in db ([] :ir :files)
                warn $ fn (x)
                  update-in db ([] :sessions sid :notifications) (push-warning op-id op-time x)
                new-ns op-data
              cond
                  not $ and (string? new-ns) (includes? new-ns "\".")
                  warn "\"Not a valid string!"
                (contains? files op-data)
                  warn $ str new-ns "\" already existed!"
                (not (contains? files selected-ns))
                  warn $ warn "\"No selected namespace!"
                :else $ -> db
                  update-in ([] :ir :files)
                    fn (files)
                      let
                          the-file $ get files selected-ns
                          ns-expr $ :ns the-file
                          new-file $ update the-file :ns
                            fn (expr)
                              let
                                  name-field $ key-nth (:data ns-expr) 1
                                assert
                                  = selected-ns $ get-in ns-expr ([] :data name-field :text)
                                  str "\"old namespace to change:" selected-ns "\" " ns-expr
                                assoc-in expr ([] :data name-field :text) new-ns
                        assoc files new-ns new-file
                  assoc-in ([] :sessions sid :writer :selected-ns) new-ns
      :proc $ quote ()
    |app.comp.profile $ {}
      :ns $ quote
        ns app.comp.profile $ :require
          [] respo.util.format :refer $ [] hsl
          [] app.schema :as schema
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> span div button input a
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] app.config :as config
          [] feather.core :refer $ [] comp-i comp-icon
          [] respo-alerts.core :refer $ [] use-prompt
      :defs $ {}
        |comp-profile $ quote
          defcomp comp-profile (states user)
            let
                rename-plugin $ use-prompt (>> states :rename)
                  {}
                    :initial $ :nickname user
                    :text "\"Pick a nickname:"
              div
                {} $ :style (merge ui/flex style-profile)
                div ({})
                  <>
                    str "|Hello! " $ :nickname user
                    , style-greet
                  =< 4 nil
                  comp-icon :edit-2
                    {} (:font-size 14)
                      :color $ hsl 0 0 40
                      :cursor :pointer
                    fn (e d!)
                      .show rename-plugin d! $ fn (result)
                        d! :user/nickname $ trim result
                  =< 8 nil
                  <>
                    str "|id: " $ :name user
                    , style-id
                =< nil 80
                div ({})
                  button $ {} (:inner-text "|Log out") (:style style/button)
                    :on $ {} (:click on-log-out)
                .render rename-plugin
        |on-log-out $ quote
          defn on-log-out (e dispatch!) (dispatch! :user/log-out nil)
            .removeItem js/window.localStorage $ :storage-key config/site
        |style-greet $ quote
          def style-greet $ {} (:font-family "|Josefin Sans") (:font-size 40) (:font-weight 100)
            :color $ hsl 0 0 100 0.8
        |style-id $ quote
          def style-id $ {} (:font-family "|Josefin Sans") (:font-weight 100)
            :color $ hsl 0 0 60
        |style-profile $ quote
          def style-profile $ {} (:padding "|0 16px")
      :proc $ quote ()
    |app.client-util $ {}
      :defs $ {}
        |expr? $ quote
          defn expr? (x)
            = :expr $ :type x
        |parse-query! $ quote
          defn parse-query! () $ let
              url-obj $ url-parse js/location.href true
            to-calcit-data $ .-query url-obj
        |coord-contains? $ quote
          defn coord-contains? (xs ys)
            if (empty? ys) true $ if
              = (first xs) (first ys)
              recur (rest xs) (rest ys)
              , false
        |leaf? $ quote
          defn leaf? (x)
            = :leaf $ :type x
        |ws-host $ quote
          def ws-host $ if
            and (exists? js/location)
              not $ blank? (.-search js/location)
            let
                query $ parse-query!
              println "|Loading from url" query
              str |ws://
                or (get query "\"host") |localhost
                , |: $ or (get query "\"port") (:port schema/configs)
            , |ws://localhost:6001
        |expr-many-items? $ quote
          defn expr-many-items? (x size)
            if (expr? x)
              let
                  d $ :data x
                or
                  > (count d) size
                  any? (vals d) expr?
              , false
      :ns $ quote
        ns app.client-util $ :require ([] clojure.string :as string) ([] app.config :as config) ([] "\"url-parse" :default url-parse) ([] app.schema :as schema)
      :proc $ quote ()
    |app.theme.curves $ {}
      :ns $ quote
        ns app.theme.curves $ :require ([] app.theme.star-trail :as star-trail)
          [] respo.util.format :refer $ [] hsl
      :defs $ {}
        |decide-expr-style $ quote
          defn decide-expr-style (expr has-others? focused? tail? layout-mode length depth)
            merge
              {} (:border-radius |16px) (:display :inline-block) (:border-width "|0 1px")
                :border-color $ hsl 0 0 80 0.5
                :padding "|4px 8px"
              if focused? $ {}
                :border-color $ hsl 0 0 100 0.8
        |decide-leaf-style $ quote
          defn decide-leaf-style (text focused? first? by-other?)
            merge (star-trail/decide-leaf-style text focused? first? by-other?) ({})
        |style-expr $ quote (def style-expr star-trail/style-expr)
        |style-leaf $ quote (def style-leaf star-trail/style-leaf)
      :proc $ quote ()
    |app.comp.configs $ {}
      :ns $ quote
        ns app.comp.configs $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> span div a pre code
          [] respo.comp.space :refer $ [] =<
          [] cirru-edn.core :as cirru-edn
          [] respo-alerts.core :refer $ [] use-prompt
      :defs $ {}
        |comp-configs $ quote
          defcomp comp-configs (states configs)
            let
                version-plugin $ use-prompt (>> states :version)
                  {} (:text "\"Set a version:")
                    :initial $ :version configs
                    :placeholder "\"a version number..."
                    :input-style $ {} (:font-family ui/font-code)
                modules-plugin $ use-prompt (>> states :modules)
                  {} (:text "\"Add modules:")
                    :initial $ .join-str (:modules configs) "\" "
                    :placeholder "\"module/compact.cirru etc."
                    :input-style $ {} (:font-family ui/font-code)
                    :multiline? true
              div
                {} $ :style
                  merge ui/expand ui/column $ {} (:padding "\"0 16px")
                =< nil 8
                div ({})
                  <> "\"Version:" $ {} (:font-family ui/font-fancy)
                  =< 8 nil
                  span
                    {} $ :on-click
                      fn (e d!)
                        .show version-plugin d! $ fn (text)
                          d! :configs/update $ {} (:version text)
                    <>
                      if
                        blank? $ :version configs
                        , "\"-" $ :version configs
                      , style-value
                div ({})
                  <> "\"Modules:" $ {} (:font-family ui/font-fancy)
                  =< 8 nil
                  span
                    {} $ :on-click
                      fn (e d!)
                        .show modules-plugin d! $ fn (text)
                          d! :configs/update $ {}
                            :modules $ filter-not
                              split (trim text) "\" "
                              , blank?
                    <>
                      let
                          content $ join-str (:modules configs) "\" "
                        if (blank? content) "\"-" content
                      , style-value
                pre
                  {} $ :style
                    merge $ {} (:max-width "\"100%") (:overflow :auto)
                      :color $ hsl 0 0 60
                  code $ {}
                    :innerHTML $ trim (format-cirru-edn configs)
                .render version-plugin
                .render modules-plugin
        |style-value $ quote
          def style-value $ {} (:cursor :pointer) (:font-family ui/font-code)
            :color $ hsl 200 90 80
      :proc $ quote ()
      :configs $ {}
    |app.twig.container $ {}
      :ns $ quote
        ns app.twig.container $ :require
          [] app.twig.user :refer $ [] twig-user
          [] app.twig.page-files :refer $ [] twig-page-files
          [] app.twig.page-editor :refer $ [] twig-page-editor
          [] app.twig.page-members :refer $ [] twig-page-members
          [] app.twig.search :refer $ [] twig-search
          [] app.twig.watching :refer $ [] twig-watching
      :defs $ {}
        |twig-container $ quote
          defn twig-container (db session)
            let
                logged-in? $ some? (:user-id session)
                router $ :router session
                writer $ :writer session
                ir $ :ir db
              if
                or logged-in? $ = :watching (:name router)
                {}
                  :session $ dissoc session :router
                  :logged-in? logged-in?
                  :user $ if logged-in?
                    twig-user $ get-in db
                      [] :users $ :user-id session
                  :router $ assoc router :data
                    case-default (:name router) ({})
                      :files $ twig-page-files (:files ir)
                        get-in session $ [] :writer :selected-ns
                        :saved-files db
                        get-in session $ [] :writer :draft-ns
                        :sessions db
                        :id session
                      :editor $ twig-page-editor (:files ir) (:saved-files db) (:sessions db) (:users db) writer (:id session) (:repl db)
                      :members $ twig-page-members (:sessions db) (:users db)
                      :search $ twig-search (:files ir)
                      :watching $ let
                          sessions $ :sessions db
                          his-sid $ :data router
                        if (contains? sessions his-sid)
                          twig-watching (get sessions his-sid) (:id session) (:files ir) (:users db)
                          , nil
                      :repl $ :repl db
                      :configs $ :configs db
                  :stats $ {}
                    :members-count $ count (:sessions db)
                {} (:session session) (:logged-in? false)
                  :stats $ {} (:members-count 0)
      :proc $ quote ()
    |app.updater.writer $ {}
      :ns $ quote
        ns app.updater.writer $ :require
          [] app.util :refer $ [] bookmark->path to-writer to-bookmark push-info cirru->tree
          [] app.util.stack :refer $ [] push-bookmark
          [] app.util.list :refer $ [] dissoc-idx
          [] app.schema :as schema
          [] app.util :refer $ [] push-info
          [] app.util :refer $ [] stringify-s-expr
          bisection-key.util :refer $ get-min-key get-max-key
      :defs $ {}
        |collapse $ quote
          defn collapse (db op-data session-id op-id op-time)
            -> db $ update-in ([] :sessions session-id :writer)
              fn (writer)
                -> writer
                  update :stack $ fn (stack) (.slice stack op-data)
                  assoc :pointer 0
        |go-up $ quote
          defn go-up (db op-data session-id op-id op-time)
            -> db $ update-in ([] :sessions session-id :writer)
              fn (writer)
                update-in writer
                  [] :stack (:pointer writer) :focus
                  fn (focus)
                    if (empty? focus) focus $ butlast focus
        |move-next $ quote
          defn move-next (db op-data sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer)
                let
                    pointer $ :pointer writer
                  assoc writer :pointer $ if
                    >= pointer $ dec
                      count $ :stack writer
                    , pointer (inc pointer)
        |remove-idx $ quote
          defn remove-idx (db op-data session-id op-id op-time)
            -> db $ update-in ([] :sessions session-id :writer)
              fn (writer)
                -> writer
                  update :stack $ fn (stack) (dissoc-idx stack op-data)
                  update :pointer $ fn (pointer)
                    if
                      and (> pointer 0) (<= op-data pointer)
                      dec pointer
                      , pointer
        |move-previous $ quote
          defn move-previous (db op-data sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer)
                let
                    pointer $ :pointer writer
                  assoc writer :pointer $ if (> pointer 0) (dec pointer) 0
        |draft-ns $ quote
          defn draft-ns (db op-data sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer) (assoc writer :draft-ns op-data)
        |paste $ quote
          defn paste (db op-data sid op-id op-time)
            let
                writer $ to-writer db sid
                bookmark $ to-bookmark writer
                data-path $ bookmark->path bookmark
                user-id $ get-in db ([] :sessions sid :user-id)
              if (list? op-data)
                -> db $ assoc-in data-path (cirru->tree op-data user-id op-time)
                , db
        |move-order $ quote
          defn move-order (db op-data sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer)
                let
                    from-idx $ :from op-data
                    to-idx $ :to op-data
                  -> writer
                    update :pointer $ fn (pointer)
                      cond
                          = pointer from-idx
                          , to-idx
                        (or (< pointer (min from-idx to-idx)) (> pointer (max from-idx to-idx)))
                          , pointer
                        true $ if (> from-idx to-idx) (inc pointer) (dec pointer)
                    update :stack $ fn (stack)
                      if (< from-idx to-idx)
                        concat (.slice stack 0 from-idx)
                          .slice stack (inc from-idx) (inc to-idx)
                          [] $ get stack from-idx
                          .slice stack $ inc to-idx
                        concat (.slice stack 0 to-idx)
                          [] $ get stack from-idx
                          .slice stack to-idx from-idx
                          if
                            >= (inc from-idx) (count stack)
                            []
                            .slice stack $ inc from-idx
        |focus $ quote
          defn focus (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
              assoc-in db
                [] :sessions session-id :writer :stack (:pointer writer) :focus
                , op-data
        |go-down $ quote
          defn go-down (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                tail? $ :tail? op-data
                bookmark $ get (:stack writer) (:pointer writer)
                target-expr $ get-in db (bookmark->path bookmark)
              if
                = 0 $ count (:data target-expr)
                , db $ -> db
                  update-in
                    [] :sessions session-id :writer :stack (:pointer writer) :focus
                    fn (focus)
                      conj focus $ if tail?
                        get-max-key $ :data target-expr
                        get-min-key $ :data target-expr
        |edit $ quote
          defn edit (db op-data session-id op-id op-time)
            let
                ns-text $ if
                  some? $ :ns op-data
                  :ns op-data
                  do (; "\"in old behavoir there's a default ns, could be misleading. need to be compatible..")
                    get-in db $ [] :sessions session-id :writer :selected-ns
                bookmark $ -> op-data (assoc :ns ns-text)
                  assoc :focus $ []
              -> db
                update-in ([] :sessions session-id :writer) (push-bookmark bookmark)
                assoc-in ([] :sessions session-id :router)
                  {} $ :name :editor
        |select $ quote
          defn select (db op-data session-id op-id op-time)
            let
                bookmark $ assoc op-data :focus ([])
              -> db
                update-in ([] :sessions session-id :writer) (push-bookmark bookmark)
                assoc-in ([] :sessions session-id :router)
                  {} $ :name :editor
        |finish $ quote
          defn finish (db op-data sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer)
                let
                    pointer $ :pointer writer
                  -> writer
                    update :stack $ fn (stack)
                      if
                        > (count stack) pointer
                        dissoc-idx stack pointer
                        , stack
                    assoc :pointer $ if (> pointer 0) (dec pointer) pointer
        |hide-peek $ quote
          defn hide-peek (db op-data sid op-id op-time)
            assoc-in db ([] :sessions sid :writer :peek-def) nil
        |pick-node $ quote
          defn pick-node (db op-data sid op-id op-time)
            let
                user-id $ get-in db ([] :sessions sid :user-id)
                writer $ get-in db ([] :sessions sid :writer)
                bookmark $ :picker-mode writer
                data-path $ bookmark->path bookmark
              -> db
                assoc-in data-path $ cirru->tree op-data user-id op-time
                update-in ([] :sessions sid :writer)
                  fn (writer) (assoc writer :picker-mode nil)
                update-in ([] :sessions sid :notifications)
                  push-info op-id op-time $ str "\"picked "
                    if (string? op-data) op-data $ let
                        code $ stringify-s-expr op-data
                      if
                        > (count code) 40
                        str (.slice code 0 40) "\"..."
                        , code
        |picker-mode $ quote
          defn picker-mode (db op-data session-id op-id op-time)
            update-in db ([] :sessions session-id :writer)
              fn (writer)
                if
                  some? $ :picker-mode writer
                  dissoc writer :picker-mode
                  assoc writer :picker-mode $ to-bookmark writer
        |go-right $ quote
          defn go-right (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                bookmark $ get (:stack writer) (:pointer writer)
                parent-bookmark $ update bookmark :focus butlast
                parent-path $ bookmark->path parent-bookmark
                last-coord $ last (:focus bookmark)
                base-expr $ get-in db parent-path
                child-keys $ sort
                  .to-list $ keys (:data base-expr)
                idx $ .index-of child-keys last-coord
              if
                empty? $ :focus bookmark
                , db $ -> db
                  update-in
                    [] :sessions session-id :writer :stack (:pointer writer) :focus
                    fn (focus)
                      conj (butlast focus)
                        if
                          = idx $ dec (count child-keys)
                          , last-coord $ get child-keys (inc idx)
        |edit-ns $ quote
          defn edit-ns (db op-data sid op-id op-time)
            let
                writer $ to-writer db sid
                bookmark $ to-bookmark writer
                ns-text $ :ns bookmark
              if
                contains? (#{} :def :proc) (:kind bookmark)
                -> db $ update-in ([] :sessions sid :writer)
                  push-bookmark $ assoc schema/bookmark :kind :ns :ns ns-text
                , db
        |point-to $ quote
          defn point-to (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :writer :pointer) op-data
        |save-files $ quote
          defn save-files (db op-data sid op-id op-time)
            let
                user-id $ get-in db ([] :sessions sid :user-id)
                user-name $ get-in db ([] :users user-id :name)
              -> db
                update :saved-files $ fn (saved-files)
                  if (some? op-data)
                    let
                        target $ get-in db ([] :ir :files op-data)
                      if (some? target) (assoc saved-files op-data target) (dissoc saved-files op-data)
                    get-in db $ [] :ir :files
                update :sessions $ fn (sessions)
                  -> sessions $ map-kv
                    fn (k session)
                      [] k $ update session :notifications
                        push-info op-id op-time $ str user-name
                          if (some? op-data) (str "\" modified ns " op-data "\"!") "\" saved files!"
        |go-left $ quote
          defn go-left (db op-data session-id op-id op-time)
            let
                writer $ get-in db ([] :sessions session-id :writer)
                bookmark $ get (:stack writer) (:pointer writer)
                parent-bookmark $ update bookmark :focus butlast
                parent-path $ bookmark->path parent-bookmark
                last-coord $ last (:focus bookmark)
                base-expr $ get-in db parent-path
                child-keys $ sort
                  .to-list $ keys (:data base-expr)
                idx $ .index-of child-keys last-coord
              if
                empty? $ :focus bookmark
                , db $ -> db
                  update-in
                    [] :sessions session-id :writer :stack (:pointer writer) :focus
                    fn (focus)
                      conj (butlast focus)
                        if (= 0 idx) last-coord $ get child-keys (dec idx)
      :proc $ quote ()
    |app.comp.header $ {}
      :ns $ quote
        ns app.comp.header $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> span div a
          [] respo.comp.space :refer $ [] =<
          [] app.util.dom :refer $ [] focus-search!
          [] feather.core :refer $ [] comp-icon
          [] respo-alerts.core :refer $ [] use-prompt
      :defs $ {}
        |style-header $ quote
          def style-header $ {} (:height 32) (:justify-content :space-between) (:padding "|0 16px") (:font-size 16) (:color :white)
            :border-bottom $ str "|1px solid " (hsl 0 0 100 0.2)
            :font-family "|Josefin Sans"
            :font-weight 300
        |render-entry $ quote
          defn render-entry (page-name this-page router-name on-click)
            div
              {} (:on-click on-click)
                :style $ merge style-entry
                  if (= this-page router-name) style-highlight
              <> page-name nil
        |style-highlight $ quote
          def style-highlight $ {}
            :color $ hsl 0 0 100
        |comp-header $ quote
          defcomp comp-header (states router-name logged-in? stats)
            let
                broadcast-plugin $ use-prompt (>> states :broadcast)
                  {} $ :text "\"Message to broadcast"
              div
                {} $ :style (merge ui/row-center style-header)
                div
                  {} $ :style ui/row-center
                  render-entry |Files :files router-name $ fn (e d!)
                    d! :router/change $ {} (:name :files)
                  render-entry |Editor :editor router-name $ fn (e d!)
                    d! :router/change $ {} (:name :editor)
                  render-entry |Search :search router-name $ fn (e d!)
                    d! :router/change $ {} (:name :search)
                    focus-search!
                  render-entry
                    str |Members: $ :members-count stats
                    , :members router-name $ fn (e d!)
                      d! :router/change $ {} (:name :members)
                  render-entry |Configs :configs router-name $ fn (e d!)
                    d! :router/change $ {} (:name :configs)
                  a
                    {} (:href "\"http://snippets.cirru.org") (:target "\"_blank") (:style style-entry)
                    <> "\"Snippets" style-link
                    <> "\"↗" $ {} (:font-family ui/font-code)
                  a
                    {} (:href |https://github.com/Cirru/calcit-editor/wiki/Keyboard-Shortcuts) (:target |_blank) (:style style-entry)
                    <> "\"Shortcuts" style-link
                    <> "\"↗" $ {} (:font-family ui/font-code)
                div
                  {} $ :style ui/row-middle
                  comp-icon :radio
                    {} (:font-size 18)
                      :color $ hsl 200 80 70 0.6
                      :cursor :pointer
                    fn (e d!)
                      .show broadcast-plugin d! $ fn (result)
                        if (some? result) (d! :notify/broadcast result)
                  =< 12 nil
                  render-entry (if logged-in? |Profile |Guest) :profile router-name $ fn (e d!)
                    d! :router/change $ {} (:name :profile) (:data nil) (:router nil)
                .render broadcast-plugin
        |style-link $ quote
          def style-link $ {} (:font-size 14) (:font-weight 100)
        |style-entry $ quote
          def style-entry $ {} (:cursor :pointer) (:padding "\"0 12px")
            :color $ hsl 0 0 100 0.6
            :text-decoration :none
            :vertical-align :middle
      :proc $ quote ()
    |app.comp.modal $ {}
      :ns $ quote
        ns app.comp.modal $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> span div pre input button a
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo.comp.space :refer $ [] =<
      :defs $ {}
        |comp-modal $ quote
          defcomp comp-modal (close-modal! inner-tree)
            div
              {} (:style style-backdrop)
                :on-click $ fn (e d!) (close-modal! d!)
              div
                {} $ :on-click
                  fn (e d!) (println |nothing!)
                , inner-tree
        |style-backdrop $ quote
          def style-backdrop $ merge ui/center
            {} (:position :fixed) (:width |100%) (:height |100%) (:top 0) (:left 0)
              :background-color $ hsl 0 0 0 0.6
      :proc $ quote ()
    |app.keycode $ {}
      :ns $ quote (ns app.keycode)
      :defs $ {}
        |d $ quote (def d 68)
        |space $ quote (def space 32)
        |s $ quote (def s 83)
        |tab $ quote (def tab 9)
        |right $ quote (def right 39)
        |f $ quote (def f 70)
        |e $ quote (def e 69)
        |up $ quote (def up 38)
        |p $ quote (def p 80)
        |j $ quote (def j 74)
        |x $ quote (def x 88)
        |v $ quote (def v 86)
        |backspace $ quote (def backspace 8)
        |escape $ quote (def escape 27)
        |slash $ quote (def slash 191)
        |i $ quote (def i 73)
        |k $ quote (def k 75)
        |down $ quote (def down 40)
        |b $ quote (def b 66)
        |period $ quote (def period 190)
        |enter $ quote (def enter 13)
        |o $ quote (def o 79)
        |c $ quote (def c 67)
        |left $ quote (def left 37)
      :proc $ quote ()
      :configs $ {}
    |app.comp.page-files $ {}
      :ns $ quote
        ns app.comp.page-files $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp list-> >> <> span div pre input button a
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] app.comp.changed-files :refer $ [] comp-changed-files
          [] keycode.core :as keycode
          [] app.comp.file-replacer :refer $ [] comp-file-replacer
          [] app.util.shortcuts :refer $ [] on-window-keydown
          [] respo-alerts.core :refer $ [] use-prompt use-confirm comp-select
          [] feather.core :refer $ [] comp-icon comp-i
      :defs $ {}
        |comp-file $ quote
          defcomp comp-file (states selected-ns defs-set highlights configs)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} $ :def-text "\""
                duplicate-plugin $ use-prompt (>> states :duplicate)
                  {} (:initial selected-ns) (:text "\"a namespace:")
                add-plugin $ use-prompt (>> states :add)
                  {} $ :text "\"New definition:"
              div
                {} $ :style style-file
                div ({}) (<> "\"File" style/title) (=< 16 nil)
                  span $ {} (:inner-text |Draft) (:style style/button)
                    :on-click $ fn (e d!) (d! :writer/draft-ns selected-ns)
                  span $ {} (:inner-text |Clone) (:style style/button)
                    :on-click $ fn (e d!)
                      .show duplicate-plugin d! $ fn (result)
                        if (.includes? result "\".") (d! :ir/clone-ns result)
                          d! :notify/push-message $ [] :warn (str "\"Not a good name: " result)
                div ({})
                  span $ {} (:inner-text selected-ns) (:style style-link)
                    :on-click $ fn (e d!)
                      d! :writer/edit $ {} (:kind :ns)
                  =< 16 nil
                  span $ {} (:inner-text |proc) (:style style-link)
                    :on-click $ fn (e d!)
                      d! :writer/edit $ {} (:kind :proc)
                  =< 16 nil
                  comp-icon :plus
                    {} (:font-size 14)
                      :color $ hsl 0 0 70
                      :cursor :pointer
                    fn (e d!)
                      .show add-plugin d! $ fn (result)
                        let
                            text $ trim result
                          when-not (blank? text)
                            d! :ir/add-def $ [] selected-ns text
                ; div ({})
                  input $ {}
                    :value $ :def-text state
                    :placeholder "\"filter..."
                    :style style-input
                    :on-input $ fn (e d!)
                      d! cursor $ assoc state :def-text (:value e)
                =< nil 8
                list-> ({})
                  -> defs-set (.to-list)
                    filter $ fn (def-text)
                      .includes? def-text $ :def-text state
                    sort &compare
                    map $ fn (def-text)
                      [] def-text $ let
                          confirm-remove-plugin $ use-confirm
                            >> states $ str :rm def-text
                            {} $ :text (str "\"Sure to remove def: " def-text "\" ?")
                        div
                          {} (:class-name |hoverable)
                            :style $ merge style-def
                              if
                                includes? highlights $ {} (:ns selected-ns) (:extra def-text) (:kind :def)
                                {} $ :color :white
                            :on-click $ fn (e d!)
                              d! :writer/edit $ {} (:kind :def) (:extra def-text)
                          <> def-text nil
                          =< 16 nil
                          span
                            {} (:class-name "\"is-minor") (:style style-remove)
                              :on-click $ fn (e d!)
                                .show confirm-remove-plugin d! $ fn () (d! :ir/remove-def def-text)
                            comp-i :x 12 $ hsl 0 0 80 0.5
                          .render confirm-remove-plugin
                .render duplicate-plugin
                .render add-plugin
        |sytle-container $ quote
          def sytle-container $ {} (:padding "|0 16px")
        |comp-namespace-list $ quote
          defcomp comp-namespace-list (states ns-set selected-ns ns-highlights)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} $ :ns-text "\""
                plugin-add-ns $ use-prompt (>> states :add-ns)
                  {} $ :title "\"New namespace:"
              div
                {} $ :style (merge ui/column style-list)
                div
                  {} $ :style style/title
                  <> |Namespaces
                  =< 8 nil
                  comp-icon :plus
                    {}
                      :color $ hsl 0 0 70
                      :font-size 14
                      :cursor :pointer
                    fn (e d!)
                      .show plugin-add-ns d! $ fn (result)
                        let
                            text $ trim result
                          when-not (blank? text) (d! :ir/add-ns text)
                ; div ({})
                  input $ {}
                    :value $ :ns-text state
                    :placeholder |filter...
                    :style style-input
                    :on-input $ fn (e d!)
                      d! cursor $ assoc state :ns-text (:value e)
                =< nil 8
                list-> ({})
                  -> ns-set (.to-list)
                    filter $ fn (ns-text)
                      includes?
                        join-str
                          rest $ split ns-text "\"."
                          , "\"."
                        :ns-text state
                    sort &compare
                    map $ fn (ns-text)
                      [] ns-text $ comp-ns-entry (>> states ns-text) ns-text (= selected-ns ns-text) ns-highlights
                .render plugin-add-ns
        |style-ns $ quote
          def style-ns $ {} (:cursor :pointer) (:vertical-align :middle) (:position :relative) (:padding "|0 8px")
            :color $ hsl 0 0 74
        |style-list $ quote
          def style-list $ {} (:width 280) (:overflow :auto) (:padding-bottom 120)
        |comp-ns-entry $ quote
          defcomp comp-ns-entry (states ns-text selected? ns-highlights)
            let
                plugin-rm-ns $ use-confirm (>> states :rm-ns)
                  {} $ :text (str "\"Sure to remove namespace: " ns-text "\" ?")
                has-highlight? $ includes? ns-highlights ns-text
              div
                {}
                  :class-name $ if selected? "|hoverable is-selected" |hoverable
                  :style $ merge style-ns
                    if has-highlight? $ {} (:color :white)
                  :on-click $ fn (e d!) (d! :session/select-ns ns-text)
                let
                    pieces $ split ns-text "\"."
                  span ({})
                    <>
                      str
                        join-str (butlast pieces) "\"."
                        , "\"."
                      {} $ :color
                        if has-highlight? (hsl 0 0 76) (hsl 0 0 50)
                    <> $ last pieces
                span
                  {} (:class-name "\"is-minor") (:style style-remove)
                    :on-click $ fn (e d!)
                      .show plugin-rm-ns d! $ fn () (d! :ir/remove-ns ns-text)
                  comp-i :x 12 $ hsl 0 0 80 0.6
                .render plugin-rm-ns
        |style-input $ quote
          def style-input $ merge style/input
            {} $ :width |100%
        |comp-page-files $ quote
          defcomp comp-page-files (states selected-ns router-data)
            let
                highlights $ -> (:highlights router-data) (vals)
                ns-highlights $ map highlights :ns
              div
                {} $ :style (merge ui/flex ui/row sytle-container)
                comp-namespace-list (>> states :ns) (:ns-set router-data) selected-ns ns-highlights
                =< 32 nil
                if (some? selected-ns)
                  comp-file (>> states selected-ns) selected-ns (:defs-set router-data) highlights $ :file-configs router-data
                  render-empty
                =< 32 nil
                comp-changed-files (>> states :files) (:changed-files router-data)
                ; comp-inspect selected-ns router-data style-inspect
                if
                  some? $ :peeking-file router-data
                  comp-file-replacer (>> states :replacer) (:peeking-file router-data)
        |render-empty $ quote
          defn render-empty () $ div
            {} $ :style
              {} (:width 280) (:font-family ui/font-fancy)
                :color $ hsl 0 0 100 0.5
            <> |Empty nil
        |style-inspect $ quote
          def style-inspect $ {} (:opacity 1)
            :background-color $ hsl 0 0 100
            :color :black
        |style-def $ quote
          def style-def $ {} (:padding "|0 8px") (:position :relative)
            :color $ hsl 0 0 74
        |style-remove $ quote
          def style-remove $ {}
            :color $ hsl 0 0 80 0.5
            :font-size 12
            :cursor :pointer
            :vertical-align :middle
            :position :absolute
            :top 8
            :right 8
        |style-link $ quote
          def style-link $ {} (:cursor :pointer)
        |style-file $ quote
          def style-file $ {} (:width 280) (:overflow :auto) (:padding-bottom 120)
      :proc $ quote ()
    |app.comp.peek-def $ {}
      :ns $ quote
        ns app.comp.peek-def $ :require
          [] respo.util.format :refer $ [] hsl
          [] respo-ui.core :as ui
          [] respo.core :refer $ [] defcomp >> <> span div pre input button a
          [] respo.comp.inspect :refer $ [] comp-inspect
          [] respo.comp.space :refer $ [] =<
          [] app.style :as style
          [] app.util :refer $ [] stringify-s-expr tree->cirru
          [] feather.core :refer $ [] comp-icon
      :defs $ {}
        |comp-peek-def $ quote
          defcomp comp-peek-def (simple-expr)
            div
              {} $ :style
                merge ui/row $ {} (:align-items :center)
                  :color $ hsl 0 0 50
                  :font-size 12
                  :line-height "\"1.5em"
              <>
                stringify-s-expr $ tree->cirru simple-expr
                {} (:font-family "|Source Code Pro, Iosevka,Consolas,monospace") (:white-space :nowrap) (:overflow :hidden) (:text-overflow :ellipsis) (:max-width 480)
              comp-icon :delete
                {} (:font-size 12)
                  :color $ hsl 0 0 50
                  :cursor :pointer
                  :margin-left 8
                fn (e d!) (d! :writer/hide-peek nil)
      :proc $ quote ()
    |app.server $ {}
      :ns $ quote
        ns app.server $ :require ([] app.schema :as schema)
          [] app.updater :refer $ [] updater
          [] cljs.core.async :refer $ [] <! >!
          [] cljs.reader :refer $ [] read-string
          [] app.util.compile :refer $ [] handle-files! persist!
          [] app.util.env :refer $ [] pick-port!
          [] app.util :refer $ [] db->string
          [] |chalk :as chalk
          [] |path :as path
          [] |shortid :as shortid
          [] |fs :as fs
          [] |md5 :default md5
          [] |gaze :default gaze
          [] ws-edn.server :refer $ [] wss-serve! wss-send! wss-each!
          [] |shortid :as shortid
          [] recollect.twig :refer $ [] clear-twig-caches! new-twig-loop!
          [] recollect.diff :refer $ [] diff-twig
          [] app.twig.container :refer $ [] twig-container
          [] app.util.env :refer $ [] check-version!
          [] app.config :as config
          [] cumulo-util.file :refer $ [] write-mildly!
          [] cumulo-util.core :refer $ [] unix-time! id! delay!
          [] app.util.env :refer $ [] get-cli-configs!
      :defs $ {}
        |start-server! $ quote
          defn start-server! (configs)
            pick-port! (:port configs)
              fn (unoccupied-port) (run-server! dispatch! unoccupied-port)
            render-loop!
            watch-file!
            .on js/process "\"SIGINT" $ fn (code & args)
              if
                empty? $ get-in @*writer-db ([] :ir :files)
                println "\"Not writing empty project."
                do
                  let
                      started-time $ unix-time!
                    persist! storage-file (db->string @*writer-db) started-time
                  println (str &newline "\"Saved calcit.cirru")
                    str $ if (some? code) (str "|with " code)
              .exit js/process
        |dispatch! $ quote
          defn dispatch! (op op-data sid)
            when config/dev? $ js/console.log "\"Action" (str op) (to-js-data op-data) sid
            ; js/console.log "\"Database:" $ to-js-data @*writer-db
            let
                d2! $ fn (op2 op-data2) (dispatch! op2 op-data2 sid)
                op-id $ id!
                op-time $ unix-time!
              case-default op
                reset! *writer-db $ updater @*writer-db op op-data sid op-id op-time
                :effect/save-files $ handle-files! @*writer-db *calcit-md5 (:configs initial-db) d2! true nil
                :effect/save-ns $ handle-files! @*writer-db *calcit-md5 (:configs initial-db) d2! true op-data
        |*calcit-md5 $ quote (defatom *calcit-md5 nil)
        |main! $ quote
          defn main! () $ let
              configs $ :configs initial-db
              cli-configs $ get-cli-configs!
            if (:compile? cli-configs) (compile-all-files! configs)
              do (start-server! configs) (check-version!)
        |run-server! $ quote
          defn run-server! (dispatch! port)
            wss-serve! port $ {}
              :on-open $ fn (sid socket) (dispatch! :session/connect nil sid)
                println $ chalk/gray (str "\"client connected: " sid)
              :on-data $ fn (sid action)
                case-default (:kind action) (println "\"unknown data" action)
                  :op $ dispatch! (:op action) (:data action) sid
                  :ping nil
              :on-close $ fn (sid event)
                println $ chalk/gray (str "\"client disconnected: " sid)
                dispatch! :session/disconnect nil sid
              :on-error $ fn (error) (js/console.error error)
        |sync-clients! $ quote
          defn sync-clients! (db)
            wss-each! $ fn (sid socket)
              let
                  session $ get-in db ([] :sessions sid)
                  old-store $ or (get @*client-caches sid) nil
                  new-store $ twig-container db session
                  changes $ diff-twig old-store new-store
                    {} $ :key :id
                when config/dev? $ println "\"Changes for" sid "\":" (count changes)
                if
                  not= changes $ []
                  do
                    wss-send! sid $ {} (:kind :patch) (:data changes)
                    swap! *client-caches assoc sid new-store
            new-twig-loop!
        |*client-caches $ quote
          defatom *client-caches $ {}
        |storage-file $ quote
          def storage-file $ path/join (-> js/process .-env .-PWD) (:storage-file config/site)
        |initial-db $ quote
          def initial-db $ merge schema/database
            let
                found? $ fs/existsSync storage-file
                configs $ :configs schema/database
              if found?
                println $ chalk/gray "\"Loading calcit.cirru"
                println $ chalk/yellow "\"Using default schema."
              if found?
                let
                    started-at $ unix-time!
                    data $ parse-cirru-edn (fs/readFileSync storage-file "\"utf8")
                    cost $ - (unix-time!) started-at
                  println $ chalk/gray (str "\"Took " cost "\"ms to load.")
                  , data
                if (some? configs)
                  {} $ :configs configs
        |*reader-db $ quote (defatom *reader-db @*writer-db)
        |compile-all-files! $ quote
          defn compile-all-files! (configs)
            handle-files!
              assoc @*writer-db :saved-files $ {}
              , *calcit-md5 configs
                fn (op op-data) (println "\"After compile:" op op-data)
                , false nil
        |reload! $ quote
          defn reload! ()
            println $ chalk/gray "|code updated."
            clear-twig-caches!
            sync-clients! @*reader-db
        |watch-file! $ quote
          defn watch-file! () $ if (fs/existsSync storage-file)
            do
              reset! *calcit-md5 $ md5 (fs/readFileSync storage-file |utf8)
              gaze storage-file $ fn (error watcher)
                if (some? error) (js/console.log error)
                  .!on watcher "\"changed" $ fn (filepath) (delay! 0.02 on-file-change!)
        |*writer-db $ quote
          defatom *writer-db $ -> initial-db
            assoc :repl $ {} (:alive? false)
              :logs $ {}
            assoc :saved-files $ get-in initial-db ([] :ir :files)
            assoc :sessions $ {}
        |on-file-change! $ quote
          defn on-file-change! () $ let
              file-content $ fs/readFileSync storage-file "\"utf8"
              new-md5 $ md5 file-content
            if (not= new-md5 @*calcit-md5)
              let
                  calcit $ parse-cirru-edn file-content
                println $ chalk/blue "\"calcit storage file changed!"
                reset! *calcit-md5 new-md5
                dispatch! :watcher/file-change calcit nil
        |render-loop! $ quote
          defn render-loop! ()
            if (not= @*reader-db @*writer-db)
              do (reset! *reader-db @*writer-db) (; println "\"render loop") (sync-clients! @*reader-db)
            js/setTimeout render-loop! 20
      :proc $ quote ()
