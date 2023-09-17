
{} (:package |app)
  :configs $ {} (:init-fn |app.server/main!) (:reload-fn |app.server/reload!) (:version |0.8.6)
    :modules $ [] |lilac/ |memof/ |recollect/ |cumulo-util.calcit/ |ws-edn.calcit/ |bisection-key/
  :entries $ {}
    :client $ {} (:init-fn |app.client/main!) (:reload-fn |app.client/reload!)
      :modules $ [] |lilac/ |memof/ |recollect/ |respo.calcit/ |respo-ui.calcit/ |respo-message.calcit/ |cumulo-util.calcit/ |ws-edn.calcit/ |respo-feather.calcit/ |alerts.calcit/ |respo-markdown.calcit/ |bisection-key/
  :files $ {}
    |app.client $ %{} :FileEntry
      :defs $ {}
        |*connecting? $ %{} :CodeEntry (:doc |)
          :code $ quote (defatom *connecting? false)
        |*states $ %{} :CodeEntry (:doc |)
          :code $ quote
            defatom *states $ {}
              :states $ {}
                :cursor $ []
        |*store $ %{} :CodeEntry (:doc |)
          :code $ quote (defatom *store nil)
        |connect! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn connect! () (js/console.info "\"Connecting...") (reset! *connecting? true)
              ws-connect! ws-host $ {}
                :on-open $ fn (event) (simulate-login!) (detect-watching!) (heartbeat!)
                :on-close $ fn (event) (reset! *store nil) (reset! *connecting? false) (js/console.error "\"Lost connection!")
                  dispatch! $ :: :states/clear
                :on-data $ fn (data)
                  tag-match data
                      :patch changes
                      do
                        when config/dev? $ js/console.log "\"Changes" changes
                        reset! *store $ patch-twig @*store changes
                    _ $ eprintln "\"Unknown op:" data
        |detect-watching! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn detect-watching! () $ let
                query $ parse-query!
              when
                some? $ get query "\"watching"
                dispatch! $ :: :router/change
                  {} (:name :watching)
                    :data $ get query "\"watching"
        |dispatch! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op)
              when
                and config/dev? $ not= (nth op 0) :states
                js/console.info |Dispatch op
              tag-match op
                  :states cursor new-state
                  reset! *states $ assoc-in @*states (conj cursor :data) new-state
                (:states/clear)
                  reset! *states $ {}
                    :states $ {}
                      :cursor $ []
                (:manual-state/abstract)
                  reset! *states $ updater/abstract @*states
                (:manual-state/draft-box)
                  reset! *states $ updater/draft-box @*states
                (:effect/save-files)
                  do
                    reset! *states $ updater/clear-editor @*states
                    send-op! op
                (:ir/indent)
                  do
                    reset! *states $ updater/clear-editor @*states
                    send-op! op
                (:ir/unindent)
                  do
                    reset! *states $ updater/clear-editor @*states
                    send-op! op
                (:ir/reset-files)
                  do
                    reset! *states $ updater/clear-editor @*states
                    send-op! op
                _ $ send-op! op
        |heartbeat! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn heartbeat! () $ delay! 30
              fn () $ if (ws-connected?)
                do
                  ws-send! $ :: :ping
                  heartbeat!
                println "\"Disabled heartbeat since connection lost."
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! ()
              when config/dev? $ load-console-formatter!
              println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
              ; reset! *changes-logger $ fn (global-element element changes) (println "\"Changes:" changes)
              render-app!
              connect!
              add-watch *store :changes $ fn (store prev) (render-app!)
                if
                  = :editor $ get-in @*store ([] :router :name)
                  focus!
              add-watch *states :changes $ fn (states prev) (render-app!)
              js/window.addEventListener "\"keydown" $ fn (event)
                on-window-keydown event dispatch! $ :router @*store
              js/window.addEventListener "\"focus" $ fn (event) (retry-connect!)
              js/window.addEventListener "\"visibilitychange" $ fn (event)
                when (= "\"visible" js/document.visibilityState) (retry-connect!)
              println "\"App started!"
        |mount-target $ %{} :CodeEntry (:doc |)
          :code $ quote
            def mount-target $ js/document.querySelector |.app
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (clear-cache!) (render-app!) (remove-watch *states :changes) (remove-watch *store :changes)
                add-watch *states :changes $ fn (states prev) (render-app!)
                add-watch *store :changes $ fn (store prev) (render-app!)
                  if
                    = :editor $ get-in @*store ([] :router :name)
                    focus!
                println "|Code updated."
                tip! "\"ok~" nil
              tip! "\"error" build-errors
        |render-app! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*states @*store) dispatch!
        |retry-connect! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn retry-connect! () $ if
              and (nil? @*store) (not @*connecting?)
              connect!
        |send-op! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn send-op! (op) (ws-send! op)
        |simulate-login! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn simulate-login! () $ let
                raw $ js/window.localStorage.getItem (:storage-key config/site)
              if (some? raw)
                do $ dispatch!
                  :: :user/log-in $ parse-cirru-edn raw
                do $ println "|Found no storage."
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.client $ :require
            respo.core :refer $ render! clear-cache! *changes-logger
            app.comp.container :refer $ comp-container
            app.client-util :refer $ ws-host parse-query!
            app.util.dom :refer $ focus!
            app.util.shortcuts :refer $ on-window-keydown
            app.client-updater :as updater
            ws-edn.client :refer $ ws-connect! ws-send! ws-connected?
            recollect.patch :refer $ patch-twig
            cumulo-util.core :refer $ delay!
            app.config :as config
            "\"bottom-tip" :default tip!
            "\"./calcit.build-errors" :default build-errors
    |app.client-updater $ %{} :FileEntry
      :defs $ {}
        |abstract $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn abstract (states)
              assoc-in states ([] :editor :data :abstract?) true
        |clear-editor $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn clear-editor (states)
              update states :editor $ fn (scope)
                -> scope .to-list
                  filter $ fn (pair)
                    let[] (k v) pair $ tag? k
                  pairs-map
        |draft-box $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn draft-box (states)
              assoc-in states ([] :editor :data :draft-box?) true
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.client-updater)
    |app.client-util $ %{} :FileEntry
      :defs $ {}
        |coord-contains? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn coord-contains? (xs ys)
              if (empty? ys) true $ if (empty? xs) false
                if
                  = (first xs) (first ys)
                  recur (rest xs) (rest ys)
                  , false
        |expr-many-items? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn expr-many-items? (x size)
              if (expr? x)
                let
                    d $ :data x
                  or
                    > (count d) size
                    any? (vals d) expr?
                , false
        |expr? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn expr? (x) (&record:matches? schema/CirruExpr x)
        |leaf? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn leaf? (x) (&record:matches? schema/CirruLeaf x)
        |parse-query! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn parse-query! () $ let
                url-obj $ url-parse js/location.href true
              to-calcit-data $ .-query url-obj
        |ws-host $ %{} :CodeEntry (:doc |)
          :code $ quote
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.client-util $ :require ([] app.config :as config) ([] "\"url-parse" :default url-parse) (app.schema :as schema)
    |app.comp.about $ %{} :FileEntry
      :defs $ {}
        |comp-about $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-about () $ div
              {} $ :class-name css-about
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
                comp-md-block "\"Calcit Editor is a syntax tree editor of [Cirru Project](http://cirru.org). Read more at [Calcit Editor](https://github.com/calcit-lang/editor).\n" $ {}
        |css-about $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-about $ {}
              "\"$0" $ merge ui/global ui/fullscreen ui/column
        |install-commands $ %{} :CodeEntry (:doc |)
          :code $ quote (def install-commands "\"npm install -g @calcit/editor\nct\n")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.about $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> span div pre input button img a br
            respo.css :refer $ defstyle
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            respo-md.comp.md :refer $ comp-md-block
            app.util.dom :refer $ copy-silently!
    |app.comp.abstract $ %{} :FileEntry
      :defs $ {}
        |comp-abstract $ %{} :CodeEntry (:doc |)
          :code $ quote
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.abstract $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            app.comp.modal :refer $ comp-modal
            app.keycode :as keycode
    |app.comp.bookmark $ %{} :FileEntry
      :defs $ {}
        |comp-bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-bookmark (bookmark idx selected?)
              div
                {}
                  :class-name $ str |stack-bookmark (if selected? "\" selected-bookmark" "\"")
                  :draggable true
                  :on-click $ on-pick bookmark idx
                  :on-dragstart $ fn (e d!)
                    -> e :event .-dataTransfer $ .!setData "\"id" idx
                  :on-drop $ fn (e d!)
                    let
                        target-idx $ js/parseInt
                          -> e :event .-dataTransfer $ .!getData "\"id"
                      when (not= target-idx idx)
                        d! :writer/move-order $ {} (:from target-idx) (:to idx)
                  :on-dragover $ fn (e d!) (-> e :event .!preventDefault)
                case-default (:kind bookmark)
                  div
                    {} (:class-name css-bookmark)
                      :style $ {} (:padding "\"8px")
                    <>
                      str $ :kind bookmark
                      , style-kind
                    <> (:ns bookmark)
                      merge style-main $ if selected? style-highlight
                  :def $ div
                    {} $ :class-name css-bookmark
                    div ({})
                      span $ {}
                        :inner-text $ :extra bookmark
                        :style $ merge style-main (if selected? style-highlight)
                    div
                      {} $ :style ui/row-middle
                      =< 4 nil
                      <> (:ns bookmark) style-minor
        |css-bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-bookmark $ {}
              "\"$0" $ {} (:line-height |1.2em) (:padding "|4px 8px") (:cursor :pointer) (:position :relative) (:white-space :nowrap)
        |on-pick $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                    true $ d! :writer/point-to idx
        |style-highlight $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-highlight $ {}
              :color $ hsl 0 0 100
        |style-kind $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-kind $ {}
              :color $ hsl 340 80 60
              :font-family ui/font-normal
              :font-size 12
              :margin-right 4
              :vertical-align :middle
        |style-main $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-main $ {} (:vertical-align :middle)
              :color $ hsl 0 0 70
              :font-family ui/font-normal
        |style-minor $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-minor $ {}
              :color $ hsl 0 0 40
              :font-size 12
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.bookmark $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp <> span div a
            respo.comp.space :refer $ =<
    |app.comp.changed-files $ %{} :FileEntry
      :defs $ {}
        |comp-changed-files $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |style-column $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-column $ {} (:overflow :auto) (:padding-top 24) (:padding-bottom 120)
        |style-nothing $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-nothing $ {} (:font-family "|Josefin Sans")
              :color $ hsl 0 0 100 0.5
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.changed-files $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp list-> <> span div pre input button a
            respo.comp.space :refer $ =<
            app.client-util :as util
            app.style :as style
            app.comp.changed-info :refer $ comp-changed-info
    |app.comp.changed-info $ %{} :FileEntry
      :defs $ {}
        |comp-changed-info $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |on-preview $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-preview (ns-text kind status)
              fn (e d!) (; println |peek ns-text kind status)
                d! :writer/select $ case-default kind
                  {} (:kind :def) (:ns ns-text) (:extra kind)
                  :ns $ {} (:kind :ns) (:ns ns-text) (:extra nil)
        |on-reset-def $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-reset-def (ns-text kind)
              fn (e d!)
                d! :ir/reset-at $ case-default kind
                  {} (:ns ns-text) (:kind :def) (:extra kind)
                  :ns $ {} (:ns ns-text) (:kind :ns)
                d! :states/clear nil
        |render-status $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |style-defs $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-defs $ {} (:padding-left 16)
        |style-info $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-info $ {}
              :background-color $ hsl 0 0 100 0.1
              :padding 8
              :margin-bottom 8
        |style-reset $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-reset $ {} (:text-decoration :underline) (:font-size 12)
              :color $ hsl 220 60 80 0.6
              :cursor :pointer
        |style-status $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-status $ {} (:font-size 12) (:font-family "|Josefin Sans")
              :color $ hsl 160 70 40
        |style-status-card $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-status-card $ {} (:cursor :pointer)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.changed-info $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp list-> >> <> span div pre input button a
            respo.comp.space :refer $ =<
            app.style :as style
            feather.core :refer $ comp-icon
    |app.comp.configs $ %{} :FileEntry
      :defs $ {}
        |comp-configs $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-configs (states configs entries)
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
                  init-fn-plugin $ use-prompt (>> states :init-fn)
                    {} (:text "\"Set a init-fn:")
                      :initial $ :init-fn configs
                      :placeholder "\"a path..."
                      :input-style $ {} (:font-family ui/font-code)
                  reload-fn-plugin $ use-prompt (>> states :reload-fn)
                    {} (:text "\"Set a reload-fn:")
                      :initial $ :reload-fn configs
                      :placeholder "\"a path..."
                      :input-style $ {} (:font-family ui/font-code)
                div
                  {} $ :style
                    merge ui/expand ui/column $ {} (:padding "\"40px 16px 0 16px")
                  =< nil 8
                  div ({}) (render-label "\"Version:") (=< 8 nil)
                    span
                      {} $ :on-click
                        fn (e d!)
                          .show version-plugin d! $ fn (text)
                            d! :configs/update $ {} (:version text)
                      render-field $ :version configs
                  div
                    {} $ :style ui/row
                    render-label "\"Modules:"
                    =< 8 nil
                    span
                      {} $ :on-click
                        fn (e d!)
                          .show modules-plugin d! $ fn (text)
                            d! :configs/update $ {}
                              :modules $ filter-not
                                split (trim text) "\" "
                                , blank?
                      render-field $ -> (:modules configs) (or "\"") (join-str "\" ")
                  div ({}) (render-label "\"init-fn:") (=< 8 nil)
                    span
                      {} $ :on-click
                        fn (e d!)
                          .show init-fn-plugin d! $ fn (text)
                            d! :configs/update $ {} (:init-fn text)
                      render-field $ :init-fn configs
                  div ({}) (render-label "\"reload-fn:") (=< 8 nil)
                    span
                      {} $ :on-click
                        fn (e d!)
                          .show reload-fn-plugin d! $ fn (text)
                            d! :configs/update $ {} (:reload-fn text)
                      render-field $ :reload-fn configs
                  pre
                    {} $ :style
                      merge $ {} (:max-width "\"100%") (:overflow :auto)
                        :color $ hsl 0 0 60
                    code $ {}
                      :innerHTML $ trim (format-cirru-edn configs)
                  comp-entries states entries
                  .render version-plugin
                  .render modules-plugin
                  .render init-fn-plugin
                  .render reload-fn-plugin
        |comp-entries $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-entries (states entries)
              let
                  code-plugin $ use-prompt (>> states :entries-code)
                    {} (:text "\"Update entries:")
                      :initial $ format-cirru-edn entries
                      :placeholder "\"{} ..."
                      :input-style $ {} (:font-family ui/font-code)
                      :multiline? true
                div ({})
                  pre $ {}
                    :style $ merge
                      {} (:max-width "\"100%") (:overflow :auto)
                        :color $ hsl 0 0 60
                    :inner-text $ format-cirru-edn entries
                  button $ {} (:style style/button) (:inner-text "\"Edit")
                    :on-click $ fn (e d!)
                      .show code-plugin d! $ fn (text)
                        d! :configs/update-entries $ [] :reset (parse-cirru-edn text)
                  .render code-plugin
        |render-field $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-field (v)
              <>
                if (blank? v) "\"-" v
                , style-value
        |render-label $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-label (title)
              <> title $ {} (:font-family ui/font-fancy)
        |style-value $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-value $ {} (:cursor :pointer) (:font-family ui/font-code)
              :color $ hsl 200 90 80
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.configs $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div a pre code button
            respo.comp.space :refer $ =<
            cirru-edn.core :as cirru-edn
            respo-alerts.core :refer $ use-prompt
            app.style :as style
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |comp-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (states store)
              let
                  state $ :data states
                  session $ :session store
                  writer $ :writer session
                  router $ :router store
                  theme $ get-in store ([] :user :theme)
                if (nil? store) (comp-about)
                  div
                    {} $ :class-name css-container
                    comp-header (>> states :header) (:name router) (:logged-in? store) (:stats store)
                    div
                      {} $ :style
                        merge ui/row ui/expand $ {} (; :padding-top 32)
                      if (:logged-in? store)
                        case-default (:name router)
                          div ({})
                            <> $ str "\"404 page: " (to-lispy-string router)
                          :profile $ comp-profile (>> states :profile) (:user store)
                          :files $ comp-page-files (>> states :files) (:selected-ns writer) (:data router)
                          :editor $ comp-page-editor (>> states :editor) (:stack writer) (:data router) (:pointer writer)
                            some? $ :picker-mode writer
                            , theme
                          :members $ comp-page-members (:data router) (:id session)
                          :search $ comp-search (>> states :search) (:data router)
                          :watching $ comp-watching (>> states :watching) (:data router) (:theme session)
                          :configs $ let
                              d $ :data router
                            comp-configs (>> states :configs) (:configs d) (:entries d)
                        if
                          = :watching $ :name router
                          comp-watching (>> states :watching) (:data router) (:theme session)
                          comp-login $ >> states :login
                    , 
                      when dev? $ comp-inspect |Session store style-inspector
                      ; when dev? $ comp-inspect "|Router data" states
                        merge style-inspector $ {} (:left 100)
                      comp-messages $ get-in store ([] :session :notifications)
        |css-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-container $ {}
              "\"$0" $ merge ui/global ui/fullscreen ui/column
                {} (:background-color :black) (:color :white)
        |style-inspector $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-inspector $ {} (:bottom 0) (:left 0) (:max-width |100%)
              :background-color $ hsl 0 0 50
              :color :black
              :opacity 1
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> div span
            respo.css :refer $ defstyle
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.comp.header :refer $ comp-header
            app.comp.profile :refer $ comp-profile
            app.comp.login :refer $ comp-login
            app.comp.page-files :refer $ comp-page-files
            app.comp.page-editor :refer $ comp-page-editor
            app.comp.page-members :refer $ comp-page-members
            app.comp.search :refer $ comp-search
            app.comp.messages :refer $ comp-messages
            app.comp.watching :refer $ comp-watching
            app.comp.about :refer $ comp-about
            app.comp.configs :refer $ comp-configs
            app.config :refer $ dev?
    |app.comp.draft-box $ %{} :FileEntry
      :defs $ {}
        |comp-draft-box $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                      span $ {} (:class-name css-wrong) (:inner-text "|Does not edit expression!")
                        :on-click $ fn (e d!) (close-modal! d!)
                      let
                          state $ or (:data states)
                            if (expr? node)
                              format-cirru $ [] (tree->cirru node)
                              :text node
                        div
                          {} $ :style ui/column
                          div
                            {} $ :style style-original
                            if expr? (<> "|Cirru Mode" style-mode)
                              textarea $ {} (:spellcheck false) (:class-name css-text)
                                :value $ if expr?
                                  format-cirru $ tree->cirru node
                                  :text node
                          =< nil 8
                          textarea $ {}
                            :class-name $ str-spaced |el-draft-box css-draft-area
                            :value state
                            :on-input $ fn (e d!)
                              d! cursor $ :value e
                            :on-keydown $ fn (e d!)
                              cond
                                  = keycode/escape $ :keycode e
                                  close-modal! d!
                                (and (= keycode/s (:keycode e)) (.-metaKey (:event e)))
                                  do
                                    .!preventDefault $ :event e
                                    if expr?
                                      d! :ir/draft-expr $ parse-cirru-edn state
                                      d! :ir/update-leaf $ {} (:text state)
                                        :at $ now!
                                    d! cursor nil
                                    close-modal! d!
                          =< nil 8
                          div
                            {} $ :style (merge ui/row style-toolbar)
                            button $ {} (:style style/button) (:inner-text |Apply)
                              :on-click $ on-submit expr? state cursor close-modal! false
                            button $ {} (:style style/button) (:inner-text |Submit)
                              :on-click $ on-submit expr? state cursor close-modal! true
        |css-draft-area $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-draft-area $ {}
              "\"$0" $ {}
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
        |css-text $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-text $ {}
              "\"$0" $ {} (:font-family style/font-code) (:color :white) (:padding "|8px 8px") (:height 60) (:display :block) (:width |100%)
                :background-color $ hsl 0 0 100 0.2
                :outline :none
                :border :none
                :font-size 14
                :padding 8
                :min-width 800
                :vetical-align :top
        |css-wrong $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-wrong $ {}
              "\"$0" $ {} (:color :red) (:font-size 24) (:font-weight 100) (:font-family "|Josefin Sans") (:cursor :pointer)
        |on-submit $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-submit (expr? text cursor close-modal! close?)
              fn (e d!)
                if expr?
                  d! :ir/draft-expr $ first (parse-cirru-list text)
                  d! :ir/update-leaf $ {} (:text text)
                    :at $ now!
                if close? $ do (d! cursor nil) (close-modal! d!)
        |style-mode $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-mode $ {}
              :color $ hsl 0 0 100 0.6
              :background-color $ hsl 300 50 50 0.6
              :padding "|0 8px"
              :font-size 12
              :border-radius |4px
        |style-original $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-original $ {} (:max-height 240) (:overflow :auto)
        |style-toolbar $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-toolbar $ {} (:justify-content :flex-end)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.draft-box $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> span div textarea pre button a
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            app.comp.modal :refer $ comp-modal
            app.style :as style
            app.util :refer $ tree->cirru now! expr?
            app.keycode :as keycode
    |app.comp.expr $ %{} :FileEntry
      :defs $ {}
        |comp-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-expr (states expr focus coord others tail? layout-mode readonly? picker-mode? theme depth)
              let
                  focused? $ = focus coord
                  focus-in? $ coord-contains? focus coord
                  first-id $ get-min-key (:data expr)
                  last-id $ get-max-key (:data expr)
                  sorted-children $ -> (:data expr) (.to-list) (.sort-by first)
                list->
                  {} (:tab-index 0)
                    :class-name $ str-spaced (base-style-expr theme) (if focused? |cirru-focused |)
                    :style $ decide-expr-theme expr (includes? others coord) focused? focus-in? tail? layout-mode (count coord) depth theme
                    :on $ if readonly?
                      {} $ :click
                        fn (e d!)
                          if picker-mode? $ do
                            .!preventDefault $ :event e
                            d! :writer/pick-node $ tree->cirru expr
                      {}
                        :keydown $ on-keydown coord expr picker-mode?
                        :click $ fn (e d!)
                          if picker-mode?
                            do
                              .!preventDefault $ :event e
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
                      if (nil? cursor-key) (js/console.warn "|[Editor] missing cursor key" k child)
                      recur
                        conj result $ [] k
                          if (&record:matches? child CirruLeaf)
                            comp-leaf (>> states cursor-key) child focus child-coord (includes? partial-others child-coord) (= first-id k) readonly? picker-mode? theme
                            comp-expr (>> states cursor-key) child focus child-coord partial-others (= last-id k) mode readonly? picker-mode? theme $ inc depth
                        rest children
                        , mode
        |on-keydown $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                        .!preventDefault event
                    (= code keycode/tab)
                      do
                        d! (if shift? :ir/unindent :ir/indent) nil
                        .!preventDefault event
                    (= code keycode/up)
                      do
                        if
                          not $ empty? coord
                          d! :writer/go-up nil
                        .preventDefault event
                    (= code keycode/down)
                      do
                        d! :writer/go-down $ {} (:tail? shift?)
                        .!preventDefault event
                    (= code keycode/left)
                      do (d! :writer/go-left nil) (.!preventDefault event)
                    (= code keycode/right)
                      do (d! :writer/go-right nil) (.!preventDefault event)
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
                                  el $ js/document.querySelector |.el-abstract
                                if (some? el) (.focus el)
                        .!preventDefault event
                    (and meta? (= code keycode/slash) (not shift?))
                      d! :ir/toggle-comment nil
                    (and picker-mode? (= code keycode/escape))
                      d! :writer/picker-mode nil
                    true $ do
                      ; println |Keydown $ :key-code e
                      on-window-keydown event d! $ {} (:name :editor)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.expr $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp list-> >> <> span div a
            respo.comp.space :refer $ =<
            app.keycode :as keycode
            app.comp.leaf :refer $ comp-leaf
            app.client-util :refer $ coord-contains? leaf? expr? expr-many-items?
            app.util.shortcuts :refer $ on-window-keydown on-paste!
            app.theme :refer $ decide-expr-theme base-style-expr
            app.util :refer $ tree->cirru
            app.util.dom :refer $ do-copy-logics!
            bisection-key.util :refer $ get-min-key get-max-key
            app.schema :refer $ CirruLeaf CirruExpr
    |app.comp.file-replacer $ %{} :FileEntry
      :defs $ {}
        |comp-file-replacer $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-file-replacer (states file)
              let
                  cursor $ :cursor states
                  state $ or (:data states)
                    format-cirru-edn $ file->cirru file
                comp-modal
                  fn (d!) (d! :writer/draft-ns nil)
                  div
                    {} $ :style ui/column
                    textarea $ {} (:value state)
                      :style $ merge style/input
                        {} (:width 800) (:height 400) (:white-space :pre) (:line-height "\"20px")
                      :on-input $ fn (e d!)
                        d! cursor $ :value e
                    =< nil 8
                    div
                      {} $ :style
                        merge ui/row $ {} (:justify-content :flex-end)
                      button $ {} (:inner-text "\"Submit") (:style style/button)
                        :on-click $ fn (e d!)
                          if
                            not= state $ format-cirru-edn file
                            d! :ir/replace-file $ parse-cirru-edn state
                          d! cursor nil
                          d! :writer/draft-ns nil
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.file-replacer $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div pre input button a textarea
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            app.comp.modal :refer $ comp-modal
            app.util :refer $ file->cirru
    |app.comp.header $ %{} :FileEntry
      :defs $ {}
        |comp-header $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-header (states router-name logged-in? stats)
              let
                  broadcast-plugin $ use-prompt (>> states :broadcast)
                    {} $ :text "\"Message to broadcast"
                div
                  {} $ :class-name css-header
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
                      {} (:href |https://github.com/Cirru/calcit-editor/wiki/Keyboard-Shortcuts) (:target |_blank) (:class-name css-entry)
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
        |css-entry $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-entry $ {}
              "\"$0" $ {} (:cursor :pointer) (:padding "\"0 12px")
                :color $ hsl 0 0 100 0.6
                :text-decoration :none
                :vertical-align :middle
        |css-header $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-header $ {}
              "\"$0" $ merge ui/row-center
                {} (:height 30) (:justify-content :space-between) (:padding "|0 16px") (:font-size 15) (:line-height "\"18px") (:color :white) (:font-family "|Josefin Sans") (:font-weight 300) (:position :fixed) (:top 0) (:right 0) (:z-index 100) (:transition-duration "\"240ms") (; :opacity 0.1)
                  :background-color $ hsl 0 0 0 0.2
                  :border-bottom $ str "|1px solid " (hsl 0 0 100 0.2)
              "\"$0 > *" $ {} (:opacity 0.5) (:transition-duration "\"240ms")
              "\"$0:hover" $ {} (:opacity 1)
              "\"$0:hover > *" $ {} (:opacity 1)
        |render-entry $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-entry (page-name this-page router-name on-click)
              div
                {} (:class-name css-entry) (:on-click on-click)
                  :style $ if (= this-page router-name) style-highlight
                <> page-name nil
        |style-highlight $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-highlight $ {}
              :color $ hsl 0 0 100
        |style-link $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-link $ {} (:font-size 14) (:font-weight 100)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.header $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp >> <> span div a
            respo.comp.space :refer $ =<
            app.util.dom :refer $ focus-search!
            feather.core :refer $ comp-icon
            respo-alerts.core :refer $ use-prompt
    |app.comp.leaf $ %{} :FileEntry
      :defs $ {}
        |comp-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  :class-name $ str-spaced (base-style-leaf theme)
                    if (= focus coord) "\"cirru-focused" "\""
                  :read-only readonly?
                  :style $ decide-leaf-theme text focused? first? by-other? theme
                  :on $ if readonly?
                    {} $ :click (on-focus leaf coord picker-mode?)
                    {}
                      :click $ on-focus leaf coord picker-mode?
                      :keydown $ on-keydown state leaf coord picker-mode?
                      :input $ on-input state coord cursor
        |initial-state $ %{} :CodeEntry (:doc |)
          :code $ quote
            def initial-state $ {} (:text |) (:at 0)
        |on-focus $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-focus (leaf coord picker-mode?)
              fn (e d!)
                if picker-mode?
                  do
                    .!preventDefault $ :event e
                    d! :writer/pick-node $ tree->cirru leaf
                  d! :writer/focus coord
        |on-input $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-input (state coord cursor)
              fn (e d!)
                let
                    now $ util/now!
                  d! :ir/update-leaf $ {}
                    :text $ :value e
                    :at now
                  d! cursor $ assoc state :text (:value e) :at now
        |on-keydown $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                      do (d! :ir/leaf-after nil) (.!preventDefault event)
                    (= code keycode/enter)
                      do
                        d! (if shift? :ir/leaf-before :ir/leaf-after) nil
                        .!preventDefault event
                    (= code keycode/tab)
                      do
                        d! (if shift? :ir/unindent-leaf :ir/indent) nil
                        .!preventDefault event
                    (= code keycode/up)
                      do
                        if
                          not $ empty? coord
                          d! :writer/go-up nil
                        .!preventDefault event
                    (and (not selected?) (= code keycode/left))
                      if
                        = 0 $ -> event .-target .-selectionStart
                        do (d! :writer/go-left nil) (.!preventDefault event)
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
                      do (.!preventDefault event)
                        if
                          -> ([] "\"\"" "\"|" "\"#\"")
                            any? $ fn (x)
                              starts-with? (:text leaf) x
                          do (d! :manual-state/draft-box nil)
                            js/setTimeout $ fn ()
                              let
                                  el $ js/document.querySelector |.el-draft-box
                                if (some? el) (.focus el)
                          d! :analyze/goto-def $ {}
                            :text $ :text leaf
                            :forced? shift?
                    (and meta? (= code keycode/slash) (not shift?))
                      do $ js/window.open
                        str |https://apis.calcit-lang.org/?q= $ js/encodeURIComponent
                          last $ split (:text leaf) "\"/"
                    (and picker-mode? (= code keycode/escape))
                      d! :writer/picker-mode nil
                    true $ do (; println "|Keydown leaf" code)
                      on-window-keydown event d! $ {} (:name :editor)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.leaf $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> span div input textarea a
            respo.comp.space :refer $ =<
            polyfill.core :refer $ text-width*
            app.keycode :as keycode
            app.util :as util
            app.util.shortcuts :refer $ on-window-keydown on-paste!
            app.theme :refer $ decide-leaf-theme base-style-leaf
            app.util :refer $ tree->cirru
            app.util.dom :refer $ do-copy-logics!
    |app.comp.login $ %{} :FileEntry
      :defs $ {}
        |comp-login $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-login (states)
              let
                  cursor $ :cursor states
                  state $ or (:data states) initial-state
                div
                  {} $ :style (merge ui/column style-login)
                  div
                    {} $ :style ui/column
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
        |initial-state $ %{} :CodeEntry (:doc |)
          :code $ quote
            def initial-state $ {} (:username |) (:password |)
        |on-input $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-input (state cursor k)
              fn (e dispatch!)
                dispatch! cursor $ assoc state k (:value e)
        |on-submit $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-submit (username password signup?)
              fn (e dispatch!)
                dispatch! (if signup? :user/sign-up :user/log-in) ([] username password)
                js/window.localStorage.setItem (:storage-key config/site)
                  format-cirru-edn $ [] username password
        |style-control $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-control $ merge ui/flex
              {} $ :text-align :right
        |style-login $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-login $ {} (:padding 16)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.login $ :require
            respo.core :refer $ defcomp >> <> div input button span
            respo.comp.space :refer $ =<
            respo.comp.inspect :refer $ comp-inspect
            respo-ui.core :as ui
            app.style :as style
            app.config :as config
    |app.comp.messages $ %{} :FileEntry
      :defs $ {}
        |comp-messages $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-messages (messages)
              list-> ({})
                -> messages
                  drop $ js/Math.max 0
                    - (count messages) 3
                  map-indexed $ fn (idx msg)
                    [] (:id msg)
                      div
                        {} (:class-name css-message)
                          :style $ {}
                            :bottom $ + 8 (* idx 28)
                            :color $ case-default (:kind msg) (hsl 120 80 80)
                              :error $ hsl 0 80 80
                              :warning $ hsl 60 80 80
                              :info $ hsl 240 80 80
                          :on-click $ fn (e d!) (d! :notify/clear nil)
                        <>
                          -> (:time msg) Dayjs $ .!format "\"mm:ss"
                          {} (:font-size 12) (:font-family ui/font-code) (:opacity 0.7)
                        =< 8 nil
                        <> (:text msg) nil
        |css-message $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-message $ {}
              "\"$0" $ {} (:position :absolute) (:left 8) (:cursor :pointer) (:font-weight 100) (:font-family |Hind) (:padding "|0 8px") (:transition-duration |200ms) (:border-radius "\"6px") (:z-index 200)
                :background-color $ hsl 0 0 0 0.5
              "\"$0:hover" $ {} (:transform "\"scale(1.03)")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.messages $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp list-> <> span div pre input button a
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            app.client-util :as util
            app.style :as style
            "\"dayjs" :default Dayjs
    |app.comp.modal $ %{} :FileEntry
      :defs $ {}
        |comp-modal $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-modal (close-modal! inner-tree)
              div
                {} (:style style-backdrop)
                  :on-click $ fn (e d!) (close-modal! d!)
                div
                  {} $ :on-click
                    fn (e d!) (println |nothing!)
                  , inner-tree
        |style-backdrop $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-backdrop $ merge ui/center
              {} (:position :fixed) (:width |100%) (:height |100%) (:top 0) (:left 0)
                :background-color $ hsl 0 0 0 0.6
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.modal $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
    |app.comp.page-editor $ %{} :FileEntry
      :defs $ {}
        |comp-doc $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-doc (states expr-entry bookmark)
              let
                  ns? $ = :ns (:kind bookmark)
                  doc-plugin $ use-prompt (>> states :doc)
                    {}
                      :text $ if ns? "\"Namespace doc:" "\"Function doc:"
                      :initial $ :doc expr-entry
                      :placeholder "\"...some docs..."
                      :input-style $ {}
                  doc $ :doc expr-entry
                  no-doc? $ blank? doc
                div ({})
                  span $ {}
                    :inner-text $ if no-doc? "\"no doc" doc
                    :class-name $ str-spaced style-doc (if no-doc? style-doc-empty)
                    :on-click $ fn (e d!)
                      .show doc-plugin d! $ fn (text)
                        if ns?
                          d! $ :: :writer/doc-set
                            :: :ns $ :ns bookmark
                            , text
                          d! $ :: :writer/doc-set
                            :: :def (:ns bookmark) (:extra bookmark)
                            , text
                  .render doc-plugin
        |comp-page-editor $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-page-editor (states stack router-data pointer picker-mode? theme)
              let
                  cursor $ :cursor states
                  state $ or (:data states) initial-state
                  bookmark $ get stack pointer
                  expr-entry $ :expr router-data
                  expr $ :code expr-entry
                  focus $ :focus router-data
                  readonly? false
                  close-draft-box! $ fn (d!)
                    d! cursor $ assoc state :draft-box? false
                  close-abstract! $ fn (d!)
                    d! cursor $ assoc state :abstract? false
                div
                  {} $ :class-name css-page-editor
                  if (empty? stack)
                    div
                      {} $ :class-name css-stack
                      <> "\"Empty" style-nothing
                    comp-stack stack pointer
                  if (empty? stack)
                    div
                      {} $ :style
                        {} $ :padding "\"12px 0"
                      <> "\"Nothing to edit" style-nothing
                    div
                      {} $ :class-name css-editor
                      let
                          others $ -> (:others router-data) (vals)
                            map $ fn (x) (:focus x)
                        div
                          {} $ :class-name css-area
                          if (some? expr-entry)
                            div ({})
                              comp-doc (>> states :doc) expr-entry bookmark
                              comp-expr
                                >> states $ bookmark-full-str bookmark
                                , expr focus ([]) others false false readonly? picker-mode? theme 0
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
        |comp-stack $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-stack (stack pointer)
              [] (effect-focus-bookmark pointer)
                list->
                  {} $ :class-name css-stack
                  -> stack $ map-indexed
                    fn (idx bookmark)
                      [] idx $ comp-bookmark bookmark idx (= idx pointer)
        |comp-status-bar $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  {} $ :class-name css-status-bar
                  div ({})
                    <>
                      str "|Writers("
                        count $ :others router-data
                        , "|)"
                      , style-hint
                    list->
                      {} $ :style style-watchers
                      -> (:others router-data) (vals) (.to-list)
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
                      -> (:watchers router-data) (.to-list)
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
        |css-area $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-area $ {}
              "\"$0" $ {} (:position :fixed) (:right 0) (:left 80) (:bottom 0) (:top 0) (:overflow :auto) (:padding-bottom "\"60vh") (:padding-top 120) (:flex 1) (:padding-right 8)
                :background-color $ hsl 0 0 0 0.4
        |css-editor $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-editor $ {}
              "\"$0" $ merge ui/flex ui/column
                {} (:position :absolute) (:left 100)
        |css-page-editor $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-page-editor $ {}
              "\"$0" $ merge ui/row ui/flex
                {} $ :z-index 80
        |css-stack $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-stack $ {}
              "\"$0" $ {} (:overflow :auto) (:padding "\"48px 0 80px 0") (:opacity 0.8) (:position :relative) (:box-shadow "\"0 0 4px black")
                :background-color $ hsl 0 0 0 0.6
              "\"$0:hover" $ {} (:opacity 1) (:z-index 100)
        |css-status-bar $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-status-bar $ {}
              "\"$0" $ merge ui/row
                {} (:justify-content :space-between) (:padding "|0 8px") (:position :fixed) (:bottom 0) (:right 0) (:opacity 0.4) (:transition-duration "\"240ms") (:transition-property "\"opacity")
                  :background-color $ hsl 0 0 0 0.5
              "\"$0:hover" $ {} (:opacity 1)
        |effect-focus-bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
            defeffect effect-focus-bookmark (pointer) (action el at?)
              if (= action :update)
                if-let
                  target $ .!querySelector el "\".selected-bookmark"
                  .!scrollIntoViewIfNeeded target
        |initial-state $ %{} :CodeEntry (:doc |)
          :code $ quote
            def initial-state $ {} (:draft-box? false)
        |on-draft-box $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-draft-box (state cursor)
              fn (e d!)
                d! cursor $ update state :draft-box? not
                js/setTimeout $ fn ()
                  let
                      el $ js/document.querySelector |.el-draft-box
                    if (some? el) (.!focus el)
        |on-path-gen! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-path-gen! (bookmark)
              fn (e d!)
                case-default (:kind bookmark)
                  d! :notify/push-message $ [] :warn "\"No op."
                  :def $ let
                      code $ []
                        [] (:ns bookmark) "\":refer" $ [] (:extra bookmark)
                    do-copy-logics! d! (format-cirru code)
                      str "\"Copied path of " $ :extra bookmark
                  :ns $ let
                      the-ns $ :ns bookmark
                      code $ []
                        [] the-ns "\":as" $ last (split the-ns "\".")
                    do-copy-logics! d! (format-cirru code) (str "\"Copied path of " the-ns)
        |on-rename-def $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |on-reset-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-reset-expr (bookmark d!)
              let
                  kind $ :kind bookmark
                  ns-text $ :ns bookmark
                d! :ir/reset-at $ case-default kind (eprintln "\"Unknown" bookmark)
                  :ns $ {} (:ns ns-text) (:kind :ns)
                  :def $ {} (:ns ns-text) (:kind :def)
                    :extra $ :extra bookmark
                d! :states/clear nil
        |style-doc $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-doc $ {}
              "\"&" $ {}
                :color $ hsl 0 0 100 0.6
                :transition-duration "\"200ms"
              "\"&:hover" $ {}
                :color $ hsl 0 0 100 1
        |style-doc-empty $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-doc-empty $ {}
              "\"&" $ {} (:font-style :italic) (:opacity 0.5)
        |style-hint $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-hint $ {}
              :color $ hsl 0 0 100 0.6
              :font-family ui/font-fancy
        |style-link $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-link $ {} (:font-family "|Josefin Sans") (:cursor :pointer) (:font-size 14)
              :color $ hsl 200 50 80
        |style-missing $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-missing $ {} (:font-family "|Josefin Sans")
              :color $ hsl 10 60 50
              :font-size 20
              :font-weight 100
        |style-nothing $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-nothing $ {}
              :color $ hsl 0 0 100 0.4
              :padding "|0 16px"
              :font-family "|Josefin Sans"
        |style-watcher $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-watcher $ {}
              :color $ hsl 0 0 100 0.7
              :margin-left 8
        |style-watchers $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-watchers $ merge ui/row
              {} $ :display :inline-block
        |ui-missing $ %{} :CodeEntry (:doc |)
          :code $ quote
            def ui-missing $ div
              {} $ :style style-missing
              <> "|Expression is missing!" nil
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.page-editor $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp defeffect list-> >> <> span div a pre
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            respo.comp.inspect :refer $ comp-inspect
            app.comp.bookmark :refer $ comp-bookmark
            app.comp.expr :refer $ comp-expr
            app.theme :refer $ base-style-leaf base-style-expr
            app.style :as style
            app.util.dom :refer $ inject-style
            app.comp.draft-box :refer $ comp-draft-box
            app.comp.abstract :refer $ comp-abstract
            app.comp.theme-menu :refer $ comp-theme-menu
            app.comp.peek-def :refer $ comp-peek-def
            app.util :refer $ tree->cirru prepend-data bookmark-full-str
            app.util.dom :refer $ do-copy-logics!
            respo-alerts.core :refer $ use-confirm use-prompt
            app.comp.replace-name :refer $ use-replace-name-modal
            app.comp.picker-notice :refer $ comp-picker-notice
    |app.comp.page-files $ %{} :FileEntry
      :defs $ {}
        |comp-file $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-file (states selected-ns defs-dict highlights configs)
              let
                  cursor $ :cursor states
                  state $ or (:data states)
                    {} $ :def-text "\""
                  duplicate-plugin $ use-prompt (>> states :duplicate)
                    {} (:initial selected-ns) (:text "\"a namespace:")
                  add-plugin $ use-prompt (>> states :add)
                    {} $ :text "\"New definition:"
                div
                  {} $ :class-name css-file
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
                    -> defs-dict keys (.to-list)
                      filter $ fn (def-text)
                        .includes? def-text $ :def-text state
                      sort &compare
                      map $ fn (def-text)
                        [] def-text $ let
                            confirm-remove-plugin $ use-confirm
                              >> states $ str :rm def-text
                              {} $ :text (str "\"Sure to remove def: " def-text "\" ?")
                          div
                            {}
                              :class-name $ str-spaced css/row-parted style-def |hoverable
                              :style $ if
                                includes? highlights $ {} (:ns selected-ns) (:extra def-text) (:kind :def)
                                {} $ :color :white
                              :on-click $ fn (e d!)
                                d! :writer/edit $ {} (:kind :def) (:extra def-text)
                            div ({}) (<> def-text nil) (=< 8 nil)
                              <> (get defs-dict def-text) style-def-doc
                            =< 16 nil
                            span
                              {}
                                :class-name $ str-spaced "\"is-minor" style-remove
                                :on-click $ fn (e d!)
                                  .show confirm-remove-plugin d! $ fn () (d! :ir/remove-def def-text)
                              comp-i :x 12 $ hsl 0 0 80 0.5
                            .render confirm-remove-plugin
                  .render duplicate-plugin
                  .render add-plugin
        |comp-namespace-list $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-namespace-list (states ns-dict selected-ns ns-highlights)
              let
                  cursor $ :cursor states
                  state $ or (:data states)
                    {} $ :ns-text "\""
                  plugin-add-ns $ use-prompt (>> states :add-ns)
                    {} $ :title "\"New namespace:"
                div
                  {} $ :class-name (str-spaced css/column style-list)
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
                    -> ns-dict (.to-list)
                      filter $ fn (pair)
                        let
                            ns-text $ nth pair 0
                          includes?
                            join-str
                              rest $ split ns-text "\"."
                              , "\"."
                            :ns-text state
                      sort $ fn (a b)
                        &compare (first a) (first b)
                      map $ fn (pair)
                        let
                            ns-text $ nth pair 0
                          [] ns-text $ comp-ns-entry (>> states ns-text) ns-text (nth pair 1) (= selected-ns ns-text) ns-highlights
                  .render plugin-add-ns
        |comp-ns-entry $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-ns-entry (states ns-text ns-doc selected? ns-highlights)
              let
                  plugin-rm-ns $ use-confirm (>> states :rm-ns)
                    {} $ :text (str "\"Sure to remove namespace: " ns-text "\" ?")
                  has-highlight? $ includes? ns-highlights ns-text
                div
                  {}
                    :class-name $ str-spaced css/row-parted style-ns (if selected? "|hoverable is-selected" |hoverable)
                    :style $ if has-highlight?
                      {} $ :color :white
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
                      =< 8 nil
                      <> ns-doc style-ns-doc
                  span
                    {}
                      :class-name $ str-spaced "\"is-minor" style-remove
                      :on-click $ fn (e d!)
                        .show plugin-rm-ns d! $ fn () (d! :ir/remove-ns ns-text)
                    comp-i :x 12 $ hsl 0 0 80 0.6
                  .render plugin-rm-ns
        |comp-page-files $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-page-files (states selected-ns router-data)
              let
                  highlights $ -> (:highlights router-data) (vals)
                  ns-highlights $ map highlights
                    fn (x) (:ns x)
                div
                  {} $ :class-name (str-spaced css/flex css/row sytle-container)
                  comp-namespace-list (>> states :ns) (:ns-dict router-data) selected-ns ns-highlights
                  =< 32 nil
                  if (some? selected-ns)
                    comp-file (>> states selected-ns) selected-ns (:defs-dict router-data) highlights $ :file-configs router-data
                    render-empty
                  =< 32 nil
                  comp-changed-files (>> states :files) (:changed-files router-data)
                  ; comp-inspect selected-ns router-data style-inspect
                  if
                    some? $ :peeking-file router-data
                    comp-file-replacer (>> states :replacer) (:peeking-file router-data)
        |css-file $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-file $ {}
              "\"$0" $ merge ui/column
                {} (:width 360) (:overflow :auto) (:padding-top 24) (:padding-bottom 120)
        |render-empty $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-empty () $ div
              {} $ :style
                {} (:width 280) (:font-family ui/font-fancy)
                  :color $ hsl 0 0 100 0.5
              <> |Empty nil
        |style-def $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-def $ {}
              "\"&" $ {} (:padding "|0 8px") (:position :relative)
                :color $ hsl 0 0 74
        |style-def-doc $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-def-doc $ {}
              "\"&" $ {}
                :color $ hsl 0 0 100 0.5
                :max-width "\"120px"
                :overflow :hidden
                :white-space :nowrap
                :text-overflow :ellipsis
                :font-family ui/font-fancy
        |style-input $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-input $ merge style/input
              {} $ :width |100%
        |style-inspect $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-inspect $ {} (:opacity 1)
              :background-color $ hsl 0 0 100
              :color :black
        |style-link $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-link $ {} (:cursor :pointer)
        |style-list $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-list $ {}
              "\"&" $ {} (:width 360) (:overflow :auto) (:padding-top 24) (:padding-bottom 120)
        |style-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-ns $ {}
              "\"&" $ {} (:cursor :pointer) (:vertical-align :middle) (:position :relative) (:padding "|0 8px")
                :color $ hsl 0 0 74
        |style-ns-doc $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-ns-doc $ {}
              "\"&" $ {}
                :color $ hsl 0 0 100 0.5
                :white-space :nowrap
                :max-width "\"120px"
                :display :inline-block
                :overflow :hidden
                :text-overflow :ellipsis
                :vertical-align :middle
                :font-family ui/font-fancy
        |style-remove $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-remove $ {}
              "\"&" $ {}
                :color $ hsl 0 50 90
                :font-size 12
                :cursor :pointer
                :vertical-align :middle
                :line-height "\"12px"
        |sytle-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle sytle-container $ {}
              "\"&" $ {} (:padding "|0px 16px")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.page-files $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp list-> >> <> span div pre input button a
            respo.css :refer $ defstyle
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            app.comp.changed-files :refer $ comp-changed-files
            keycode.core :as keycode
            app.comp.file-replacer :refer $ comp-file-replacer
            app.util.shortcuts :refer $ on-window-keydown
            respo-alerts.core :refer $ use-prompt use-confirm comp-select
            feather.core :refer $ comp-icon comp-i
    |app.comp.page-members $ %{} :FileEntry
      :defs $ {}
        |comp-page-members $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                            str member-name $ if (= k session-id) "| (yourself)" "\""
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
                                  .!toString url-obj
                                :target |_blank
                                :style $ {}
                                  :color $ hsl 240 80 80
                              <> "|Watching url" nil
        |on-watch $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-watch (session-id)
              fn (e d!)
                d! :router/change $ {} (:name :watching) (:data session-id)
        |style-bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-bookmark $ {} (:font-family |Menlo,monospace) (:min-width 200) (:display :inline-block)
        |style-members $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-members $ {} (:padding "|40px 16px 0 16px")
        |style-name $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-name $ {} (:min-width 160) (:display :inline-block)
        |style-page $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-page $ {} (:min-width 160) (:display :inline-block)
        |style-row $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-row $ {} (:cursor :pointer)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.page-members $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> list-> span div a
            respo.comp.space :refer $ =<
            "\"url-parse" :default url-parse
    |app.comp.peek-def $ %{} :FileEntry
      :defs $ {}
        |comp-peek-def $ %{} :CodeEntry (:doc |)
          :code $ quote
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.peek-def $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            app.util :refer $ stringify-s-expr tree->cirru
            feather.core :refer $ comp-icon
    |app.comp.picker-notice $ %{} :FileEntry
      :defs $ {}
        |comp-picker-notice $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-picker-notice (choices target-node)
              let
                  imported-names $ :imported choices
                  defined-names $ :defined choices
                  render-code $ fn (x)
                    span $ {} (:inner-text x) (:class-name css-name-code)
                      :on-click $ fn (e d!) (d! :writer/pick-node x)
                  hint $ if (record? target-node)
                    if (&record:matches? target-node schema/CirruLeaf) (:text target-node) nil
                    , nil
                  hint-func $ fn (x)
                    if (blank? hint) true $ .includes? x hint
                div
                  {} $ :class-name css-picker-container
                  div
                    {} $ :class-name css-picker-tip
                    <> "\"Picker mode..."
                  comp-icon :x
                    {} (:font-size 18) (:cursor :pointer) (:position :absolute) (:top 4) (:right 4)
                      :color $ hsl 200 80 70 0.6
                    fn (e d!) (d! :writer/picker-mode nil)
                  list->
                    {} $ :class-name style-list-container
                    -> imported-names (.to-list)
                      filter $ fn (pair)
                        .any? (nth pair 1) hint-func
                      sort $ fn (a b)
                        let
                            a1 $ &compare
                              count $ nth a 1
                              count $ nth b 1
                          if (= 0 a1)
                            &compare (first a) (first b)
                            , a1
                      map $ fn (xs)
                        let
                            ns $ first xs 
                          [] ns $ list->
                            {} (:title ns) (:class-name style-list-container)
                            -> (nth xs 1)
                              map $ fn (x)
                                [] x $ render-code x
                  =< nil 6
                  let
                      names $ -> defined-names (.to-list) (filter hint-func)
                    if-not (empty? names)
                      list->
                        {} $ :class-name style-list-container
                        -> names (sort)
                          map $ fn (x)
                            [] x $ render-code x
        |css-name-code $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-name-code $ {}
              "\"$0" $ {} (:font-family ui/font-code) (:cursor :pointer) (:font-size 11) (:margin-bottom 4) (:word-break :none) (:line-height "\"12px") (:border-radius "\"4px")
                :color $ hsl 0 0 90
                :background-color $ hsl 0 0 50 0.2
                :padding "\"2px 2px"
                :display :inline-block
              "\"$0:hover" $ {}
                :background-color $ hsl 0 0 30 1
                :color $ hsl 0 0 100
        |css-picker-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-picker-container $ {}
              "\"$0" $ merge ui/column
                {} (:padding "\"2px 4px") (:position :fixed) (:line-height "\"1.6em") (:top 6) (:left "\"50%") (:transform "\"translate(-50%,0)") (:margin "\"auto") (:z-index 100) (:border-radius "\"4px") (:max-width "\"66vw") (:min-height "\"40px") (:min-width "\"200px")
                  :border $ str "\"1px solid " (hsl 0 0 70 0.4)
                  :background-color $ hsl 0 0 20 0.7
        |css-picker-tip $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-picker-tip $ {}
              "\"$0" $ {} (:font-family ui/font-fancy) (:font-size 28) (:font-weight 300) (:line-height "\"21px") (:cursor :pointer) (:position :absolute) (:right 4) (:bottom 4) (:z-index -1)
                :color $ hsl 0 0 90 0.4
        |style-list-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-list-container $ {}
              "\"$0" $ merge ui/row
                {} (:flex-wrap :wrap) (:column-gap "\"4px")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.picker-notice $ :require
            respo.core :refer $ defcomp list-> >> <> span div a pre
            respo-ui.core :as ui
            respo.util.format :refer $ hsl
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            feather.core :refer $ comp-icon
            app.schema :as schema
    |app.comp.profile $ %{} :FileEntry
      :defs $ {}
        |comp-profile $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                    button $ {} (:inner-text "|Log out") (:style style/button) (:on-click on-log-out)
                  .render rename-plugin
        |on-log-out $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-log-out (e dispatch!) (dispatch! :user/log-out nil)
              js/window.localStorage.removeItem $ :storage-key config/site
        |style-greet $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-greet $ {} (:font-family "|Josefin Sans") (:font-size 40) (:font-weight 100)
              :color $ hsl 0 0 100 0.8
        |style-id $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-id $ {} (:font-family "|Josefin Sans") (:font-weight 100)
              :color $ hsl 0 0 60
        |style-profile $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-profile $ {} (:padding "|24px 16px")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.profile $ :require
            respo.util.format :refer $ hsl
            app.schema :as schema
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div button input a
            respo.comp.space :refer $ =<
            app.style :as style
            app.config :as config
            feather.core :refer $ comp-i comp-icon
            respo-alerts.core :refer $ use-prompt
    |app.comp.replace-name $ %{} :FileEntry
      :defs $ {}
        |use-replace-name-modal $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  klass $ %{} ModalShape
                    :render $ fn (self) (:node self)
                    :show $ fn (self d!)
                      d! cursor $ assoc state :old-name "\"" :new-name "\"" :show? true
                      js/setTimeout $ fn ()
                        let
                            el $ js/document.querySelector "\"#replace-input"
                          if (some? el) (.select el)
                    :close $ fn (self d!)
                      d! cursor $ assoc state :show? false
                &record:with-class
                  %{} PluginShape (:name :modal)
                    :node $ comp-modal
                      {} (:title "\"Replace variable")
                        :style $ {} (:width 240)
                        :container-style $ {}
                        :render-body $ fn (? arg)
                          div
                            {} $ :style
                              merge ui/column $ {} (:padding "\"8px 16px")
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
                  , klass
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.replace-name $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> span div pre input button img a br
            respo.comp.space :refer $ =<
            app.style :as style
            respo-alerts.core :refer $ comp-modal ModalShape PluginShape
    |app.comp.search $ %{} :FileEntry
      :defs $ {}
        |bookmark->str $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn bookmark->str (bookmark)
              case-default (:kind bookmark)
                do
                  js/console.warn $ str "\"Unknown" (to-lispy-string bookmark)
                  , "\""
                :def $ :extra bookmark
                :ns $ :ns bookmark
        |comp-no-results $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-no-results () $ div
              {} $ :style
                merge ui/row-middle $ {} (:padding 8) (:font-family ui/font-fancy)
                  :color $ hsl 0 0 60
                  :font-weight 300
              <> "\"No results"
        |comp-search $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  {} $ :class-name css-search
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
        |css-search $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-search $ {}
              "\"$0" $ merge ui/expand ui/row-middle
                {} (:height "\"100%") (:padding "\"40px 16px 0 16px")
        |initial-state $ %{} :CodeEntry (:doc |)
          :code $ quote
            def initial-state $ {} (:query |) (:selection 0)
        |on-input $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-input (state cursor)
              fn (e d!)
                d! cursor $ {}
                  :query $ :value e
                  :selection 0
        |on-keydown $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                      do (.!preventDefault event)
                        if
                          > (:selection state) 0
                          d! cursor $ update state :selection dec
                    (= keycode/escape code)
                      do
                        d! :router/change $ {} (:name :editor)
                        d! cursor $ {} (:query |) (:position 0)
                    (= keycode/down code)
                      do (.!preventDefault event)
                        if
                          < (:selection state)
                            dec $ count candidates
                          d! cursor $ update state :selection inc
                    true $ on-window-keydown (:event e) d!
                      {} $ :name :search
        |on-select $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-select (bookmark cursor)
              fn (e d!) (d! :writer/select bookmark)
                d! cursor $ {} (:position :0) (:query |)
        |query-length $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn query-length (bookmark)
              case-default (:kind bookmark)
                do
                  js/console.warn $ str "\"Unknown" (to-lispy-string bookmark)
                  , 0
                :def $ count (:extra bookmark)
                :ns $ count (:ns bookmark)
        |style-body $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-body $ {} (:overflow :auto) (:padding-bottom 80)
        |style-candidate $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-candidate $ {} (:padding "|0 8px")
              :color $ hsl 0 0 100 0.6
              :cursor :pointer
        |style-highlight $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-highlight $ {} (:color :white)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.search $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp list-> <> span div input a
            respo.comp.space :refer $ =<
            respo.css :refer $ defstyle
            app.polyfill :refer $ text-width*
            app.keycode :as keycode
            app.client-util :as util
            app.style :as style
            app.util.shortcuts :refer $ on-window-keydown
    |app.comp.theme-menu $ %{} :FileEntry
      :defs $ {}
        |comp-theme-menu $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |theme-list $ %{} :CodeEntry (:doc |)
          :code $ quote
            def theme-list $ [] :star-trail :beginner :curves
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.theme-menu $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> list-> <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
    |app.comp.watching $ %{} :FileEntry
      :defs $ {}
        |comp-watching $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                          inject-style |.cirru-expr $ .to-list
                            base-style-expr $ or theme :star-trail
                          inject-style |.cirru-leaf $ .to-list
                            base-style-leaf $ or theme :star-trail
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
        |style-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-container $ {} (:padding "|40px 16px 0 16px")
        |style-tip $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-tip $ {} (:font-family "|Josefin Sans")
              :background-color $ hsl 0 0 100 0.3
              :border-radius |4px
              :padding "|4px 8px"
        |style-title $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-title $ {} (:font-family "|Josefin Sans")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.watching $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div input pre a
            respo.comp.space :refer $ =<
            keycode.core :as keycode
            app.client-util :as util
            app.style :as style
            app.comp.expr :refer $ comp-expr
            app.theme :refer $ base-style-leaf base-style-expr
            app.util.dom :refer $ inject-style
            app.util :refer $ bookmark-full-str
            app.comp.theme-menu :refer $ comp-theme-menu
    |app.config $ %{} :FileEntry
      :defs $ {}
        |cdn? $ %{} :CodeEntry (:doc |)
          :code $ quote
            def cdn? $ cond
                exists? js/window
                , false
              (exists? js/process) (= "\"true" js/process.env.cdn)
              :else false
        |dev? $ %{} :CodeEntry (:doc |)
          :code $ quote
            def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |site $ %{} :CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:port nil) (:title "\"Calcit Editor") (:icon "\"https://cdn.tiye.me/logo/cirru.png") (:theme "\"#eeeeff") (:storage-key "\"calcit-storage") (:storage-file "\"calcit.cirru")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.config $ :require ([] app.schema :as schema)
    |app.keycode $ %{} :FileEntry
      :defs $ {}
        |b $ %{} :CodeEntry (:doc |)
          :code $ quote (def b 66)
        |backspace $ %{} :CodeEntry (:doc |)
          :code $ quote (def backspace 8)
        |c $ %{} :CodeEntry (:doc |)
          :code $ quote (def c 67)
        |d $ %{} :CodeEntry (:doc |)
          :code $ quote (def d 68)
        |down $ %{} :CodeEntry (:doc |)
          :code $ quote (def down 40)
        |e $ %{} :CodeEntry (:doc |)
          :code $ quote (def e 69)
        |enter $ %{} :CodeEntry (:doc |)
          :code $ quote (def enter 13)
        |escape $ %{} :CodeEntry (:doc |)
          :code $ quote (def escape 27)
        |f $ %{} :CodeEntry (:doc |)
          :code $ quote (def f 70)
        |i $ %{} :CodeEntry (:doc |)
          :code $ quote (def i 73)
        |j $ %{} :CodeEntry (:doc |)
          :code $ quote (def j 74)
        |k $ %{} :CodeEntry (:doc |)
          :code $ quote (def k 75)
        |left $ %{} :CodeEntry (:doc |)
          :code $ quote (def left 37)
        |o $ %{} :CodeEntry (:doc |)
          :code $ quote (def o 79)
        |p $ %{} :CodeEntry (:doc |)
          :code $ quote (def p 80)
        |period $ %{} :CodeEntry (:doc |)
          :code $ quote (def period 190)
        |right $ %{} :CodeEntry (:doc |)
          :code $ quote (def right 39)
        |s $ %{} :CodeEntry (:doc |)
          :code $ quote (def s 83)
        |slash $ %{} :CodeEntry (:doc |)
          :code $ quote (def slash 191)
        |space $ %{} :CodeEntry (:doc |)
          :code $ quote (def space 32)
        |tab $ %{} :CodeEntry (:doc |)
          :code $ quote (def tab 9)
        |up $ %{} :CodeEntry (:doc |)
          :code $ quote (def up 38)
        |v $ %{} :CodeEntry (:doc |)
          :code $ quote (def v 86)
        |x $ %{} :CodeEntry (:doc |)
          :code $ quote (def x 88)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.keycode)
    |app.polyfill $ %{} :FileEntry
      :defs $ {}
        |ctx $ %{} :CodeEntry (:doc |)
          :code $ quote
            def ctx $ if
              and (exists? js/document) (exists? js/window)
              .!getContext (.!createElement js/document "\"canvas") "\"2d"
              , nil
        |text-width* $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn text-width* (content font-size font-family)
              if (some? ctx)
                do
                  set! (.-font ctx) (str font-size "\"px " font-family)
                  .-width $ .!measureText ctx content
                , nil
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.polyfill)
    |app.schema $ %{} :FileEntry
      :defs $ {}
        |CirruExpr $ %{} :CodeEntry (:doc |)
          :code $ quote
            def CirruExpr $ new-record :Expr :by :at :data
        |CirruLeaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            def CirruLeaf $ new-record :Leaf :at :by :text
        |CodeEntry $ %{} :CodeEntry (:doc |)
          :code $ quote
            def CodeEntry $ new-record :CodeEntry :doc :code
        |FileEntry $ %{} :CodeEntry (:doc |)
          :code $ quote
            def FileEntry $ new-record :FileEntry :ns :defs
        |bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
            def bookmark $ {} (:kind :def) (:ns nil) (:extra nil)
              :focus $ []
        |configs $ %{} :CodeEntry (:doc |)
          :code $ quote
            def configs $ {} (:port 6001) (:expose-port 6011) (:init-fn "\"app.main/main!") (:reload-fn "\"app.main/reload!")
              :modules $ []
              :version "\"0.0.1"
        |database $ %{} :CodeEntry (:doc |)
          :code $ quote
            def database $ {}
              :sessions $ {}
              :users $ {}
              :package |app
              :files $ {}
              :saved-files $ {}
              :configs configs
              :entries $ {}
        |notification $ %{} :CodeEntry (:doc |)
          :code $ quote
            def notification $ {} (:id nil) (:kind nil) (:text nil) (:time nil)
        |page-data $ %{} :CodeEntry (:doc |)
          :code $ quote
            def page-data $ {}
              :files $ {}
                :ns-dict $ #{}
                :defs-dict $ #{}
                :changed-files $ {}
              :editor $ {}
                :focus $ []
                :others $ #{}
                :expr nil
        |router $ %{} :CodeEntry (:doc |)
          :code $ quote
            def router $ {} (:name nil) (:title nil)
              :data $ {}
              :router nil
        |session $ %{} :CodeEntry (:doc |)
          :code $ quote
            def session $ {} (:user-id nil) (:id nil)
              :router $ {} (:name :files) (:data nil) (:router nil)
              :notifications $ []
              :writer $ {} (:selected-ns nil) (:draft-ns nil) (:peek-def nil) (:pointer 0)
                :stack $ []
                :picker-coord nil
              :theme :star-trail
        |user $ %{} :CodeEntry (:doc |)
          :code $ quote
            def user $ {} (:name nil) (:id nil) (:nickname nil) (:avatar nil) (:password nil) (:theme :star-trail)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.schema)
    |app.server $ %{} :FileEntry
      :defs $ {}
        |*calcit-md5 $ %{} :CodeEntry (:doc |)
          :code $ quote (defatom *calcit-md5 nil)
        |*client-caches $ %{} :CodeEntry (:doc |)
          :code $ quote
            defatom *client-caches $ {}
        |*reader-db $ %{} :CodeEntry (:doc |)
          :code $ quote (defatom *reader-db @*writer-db)
        |*writer-db $ %{} :CodeEntry (:doc |)
          :code $ quote
            defatom *writer-db $ -> initial-db
              assoc :saved-files $ get initial-db :files
              assoc :sessions $ {}
        |compile-all-files! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn compile-all-files! (configs)
              handle-files!
                assoc @*writer-db :saved-files $ {}
                , *calcit-md5 configs
                  fn (op) (println "\"After compile:" op)
                  , false nil
        |dispatch! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op sid)
              when config/dev? $ println "\"Action" (str op) sid
              ; js/console.log "\"Database:" $ to-js-data @*writer-db
              let
                  d2! $ fn (op2) (dispatch! op2 sid)
                  op-id $ id!
                  op-time $ unix-time!
                tag-match op
                    :effect/save-files
                    handle-files! @*writer-db *calcit-md5 (:configs initial-db) d2! true nil
                  (:effect/save-ns ns)
                    handle-files! @*writer-db *calcit-md5 (:configs initial-db) d2! true ns
                  (:ping) nil
                  _ $ reset! *writer-db (updater @*writer-db op sid op-id op-time)
        |expose-files! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn expose-files! (port)
              let
                  server $ createServer
                    fn (req res) (hint-fn async)
                      ; js/console.log (.-url req) (.-headers req)
                      .!setHeader res "\"Access-Control-Allow-Origin" "\"*"
                      .!setHeader res "\"Access-Control-Allow-Headers" "\"*"
                      if
                        = "\"OPTIONS" $ .-method req
                        do (.!writeHead res 200) (.!end res "\"OK")
                        case-default (.-url req)
                          do (.!writeHead res 404) (.!end res "\"not found. check url")
                          "\"/" $ .!end res "\"echo from Calcit Editor"
                          "\"/favicon.ico" $ do (.!writeHead res 404) (.!end res "\"")
                          "\"/load-error" $ readFile "\"./.calcit-error.cirru" "\"utf8" (make-file-response res)
                          "\"/load-compact" $ readFile "\"./compact.cirru" "\"utf8" (make-file-response res)
                          "\"/compact-data" $ readFile "\"./compact.cirru" "\"utf8" (make-file-response res)
                .!listen server port $ fn ()
                  let
                      link $ .!blue chalk (str "\"http://localhost:" port)
                    println $ str "\"port " port "\" ok, local configs exposed on " link
        |initial-db $ %{} :CodeEntry (:doc |)
          :code $ quote
            def initial-db $ merge schema/database
              let
                  found? $ fs/existsSync storage-file
                  configs $ :configs schema/database
                if found?
                  println $ .!gray chalk "\"Loading calcit.cirru"
                  println $ .!yellow chalk "\"Using default schema."
                if found?
                  let
                      started-at $ unix-time!
                      data $ parse-cirru-edn (fs/readFileSync storage-file "\"utf8")
                        {} (:Expr schema/CirruExpr) (:Leaf schema/CirruLeaf) (:CodeEntry schema/CodeEntry)
                      cost $ - (unix-time!) started-at
                    println $ .!gray chalk (str "\"Took " cost "\"ms to load.")
                    , data
                  if (some? configs)
                    {} $ :configs configs
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! () $ let
                configs $ :configs initial-db
                cli-configs $ get-cli-configs!
              case-default (:op cli-configs)
                do (start-server! configs) (check-version!)
                "\"compile" $ compile-all-files! configs
                "\"file-transform" $ transform-compact-to-calcit!
        |make-file-response $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn make-file-response (res)
              fn (err ? content)
                if (some? err)
                  do (.!writeHead res 400)
                    .!end res $ format-cirru-edn
                      {} $ :message (str err)
                  do (.!setHeader res "\"Content-Type" "\"text/plain") (.!writeHead res 200) (.!end res content)
        |on-file-change! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-file-change! () $ let
                file-content $ fs/readFileSync storage-file "\"utf8"
                new-md5 $ md5 file-content
              if (not= new-md5 @*calcit-md5)
                let
                    calcit $ parse-cirru-edn file-content
                  println $ .!blue chalk "\"calcit storage file changed!"
                  reset! *calcit-md5 new-md5
                  dispatch! (:: :watcher/file-change calcit) nil
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reload! ()
              println $ .!gray chalk "|code updated."
              clear-twig-caches!
              sync-clients! @*reader-db
        |render-loop! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-loop! ()
              if (not= @*reader-db @*writer-db)
                do (reset! *reader-db @*writer-db) (; println "\"render loop") (sync-clients! @*reader-db)
              js/setTimeout render-loop! 20
        |run-server! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn run-server! (dispatch! port)
              wss-serve! port $ {}
                :on-open $ fn (sid socket)
                  dispatch! (:: :session/connect) sid
                  println $ .!gray chalk (str "\"client connected: " sid)
                :on-data $ fn (sid action) (dispatch! action sid)
                :on-close $ fn (sid event)
                  println $ .!gray chalk (str "\"client disconnected: " sid)
                  dispatch! (:: :session/disconnect) sid
                :on-error $ fn (error) (js/console.error error)
        |start-server! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn start-server! (configs)
              pick-port! (:port configs)
                fn (unoccupied-port) (run-server! dispatch! unoccupied-port)
              pick-http-port!
                either (:expose-port configs) (:expose-port schema/configs)
                fn (unoccupied-port) (expose-files! unoccupied-port)
              render-loop!
              watch-file!
              js/process.on "\"SIGINT" $ fn (code & args)
                if
                  empty? $ get @*writer-db :files
                  println "\"Not writing empty project."
                  do
                    let
                        started-time $ unix-time!
                      persist! storage-file (db->string @*writer-db) started-time
                    println (str &newline "\"Saved calcit.cirru")
                      str $ if (some? code) (str "|with " code)
                js/process.exit
        |storage-file $ %{} :CodeEntry (:doc |)
          :code $ quote
            def storage-file $ path/join (js/process.cwd) (:storage-file config/site)
        |sync-clients! $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                      wss-send! sid $ :: :patch changes
                      swap! *client-caches assoc sid new-store
              new-twig-loop!
        |transform-compact-to-calcit! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn transform-compact-to-calcit! () $ let
                source $ parse-cirru-edn (fs/readFileSync "\"compact.cirru" "\"utf8")
                next-files $ map-kv (:files source)
                  fn (ns file)
                    [] ns $ file-compact-to-calcit file
                target $ {}
                  :configs $ assoc (:configs source) :port 6001
                  :entries $ :entries source
                  :package $ :package source
                  :files next-files
                  :users $ {}
              ; fs/writeFileSync "\"calcit-draft.cirru" $ format-cirru-edn target
              println "\"TODO need update"
              println "\"transformed compact.cirru into calcit-draft.cirru"
        |watch-file! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn watch-file! () $ if (fs/existsSync storage-file)
              do
                reset! *calcit-md5 $ md5 (fs/readFileSync storage-file |utf8)
                gaze storage-file $ fn (error watcher)
                  if (some? error) (js/console.log error)
                    .!on watcher "\"changed" $ fn (filepath) (delay! 0.02 on-file-change!)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.server $ :require (app.schema :as schema)
            app.updater :refer $ updater
            app.util.compile :refer $ handle-files! persist!
            app.util.env :refer $ pick-port! pick-http-port!
            app.util :refer $ db->string file-compact-to-calcit
            |chalk :default chalk
            |path :as path
            |fs :as fs
            |md5 :default md5
            |gaze :default gaze
            "\"node:http" :refer $ createServer
            "\"node:fs" :refer $ readFile
            ws-edn.server :refer $ wss-serve! wss-send! wss-each!
            recollect.twig :refer $ clear-twig-caches! new-twig-loop!
            recollect.diff :refer $ diff-twig
            app.twig.container :refer $ twig-container
            app.util.env :refer $ check-version!
            app.config :as config
            cumulo-util.file :refer $ write-mildly!
            cumulo-util.core :refer $ unix-time! id! delay!
            app.util.env :refer $ get-cli-configs!
    |app.style $ %{} :FileEntry
      :defs $ {}
        |button $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |font-code $ %{} :CodeEntry (:doc |)
          :code $ quote (def font-code "\"Source Code Pro, monospace")
        |input $ %{} :CodeEntry (:doc |)
          :code $ quote
            def input $ merge ui/input
              {}
                :background-color $ hsl 0 0 100 0.16
                :color $ hsl 0 0 100
                :font-family |Menlo,monospace
                :border :none
        |inspector $ %{} :CodeEntry (:doc |)
          :code $ quote
            def inspector $ {} (:opacity 0.9)
              :background-color $ hsl 0 0 90
              :color :black
        |link $ %{} :CodeEntry (:doc |)
          :code $ quote (def link ui/link)
        |title $ %{} :CodeEntry (:doc |)
          :code $ quote
            def title $ {} (:font-family ui/font-fancy) (:font-size 18) (:font-weight 100)
              :color $ hsl 0 0 80
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.style $ :require (respo-ui.core :as ui)
            respo.util.format :refer $ hsl
    |app.theme $ %{} :FileEntry
      :defs $ {}
        |base-style-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn base-style-expr (theme)
              case-default theme "\"css-expr-unknown" (:star-trail star-trail/css-expr) (:curves curves/css-expr) (:beginner beginner/css-expr)
        |base-style-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn base-style-leaf (theme)
              case-default theme "\"css-leaf-unknown" (:star-trail star-trail/css-leaf) (:curves curves/css-leaf) (:beginner beginner/css-leaf)
        |decide-expr-theme $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-expr-theme (expr has-others? focused? focus-in? tail? layout-mode length depth theme)
              case-default theme ({})
                :star-trail $ star-trail/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth
                :curves $ curves/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth
                :beginner $ beginner/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth
        |decide-leaf-theme $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-leaf-theme (text focused? first? by-other? theme)
              case-default theme ({})
                :star-trail $ star-trail/decide-leaf-style text focused? first? by-other?
                :curves $ curves/decide-leaf-style text focused? first? by-other?
                :beginner $ beginner/decide-leaf-style text focused? first? by-other?
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.theme $ :require (app.theme.star-trail :as star-trail) (app.theme.curves :as curves) (app.theme.beginner :as beginner)
    |app.theme.beginner $ %{} :FileEntry
      :defs $ {}
        |css-expr $ %{} :CodeEntry (:doc |)
          :code $ quote (def css-expr star-trail/css-expr)
        |css-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote (def css-leaf star-trail/css-leaf)
        |decide-expr-style $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-expr-style (expr has-others? focused? focus-in? tail? layout-mode length depth)
              merge (star-trail/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth) style-expr-beginner
        |decide-leaf-style $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-leaf-style (text focused? first? by-other?)
              merge $ star-trail/decide-leaf-style text focused? first? by-other?
        |style-expr-beginner $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-expr-beginner $ {}
              :outline $ str "|1px solid " (hsl 200 80 70 0.2)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.theme.beginner $ :require (app.theme.star-trail :as star-trail)
            respo.util.format :refer $ hsl
    |app.theme.curves $ %{} :FileEntry
      :defs $ {}
        |css-expr $ %{} :CodeEntry (:doc |)
          :code $ quote (def css-expr star-trail/css-expr)
        |css-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote (def css-leaf star-trail/css-leaf)
        |decide-expr-style $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-expr-style (expr has-others? focused? focus-in? tail? layout-mode length depth)
              merge
                {} (:border-radius |16px) (:display :inline-block) (:border-width "|0 1px")
                  :border-color $ hsl 0 0 80 0.5
                  :padding "|4px 8px"
                if focused? $ {}
                  :border-color $ hsl 0 0 100 0.8
        |decide-leaf-style $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-leaf-style (text focused? first? by-other?)
              merge (star-trail/decide-leaf-style text focused? first? by-other?) ({})
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.theme.curves $ :require (app.theme.star-trail :as star-trail)
            respo.util.format :refer $ hsl
            respo.css :refer $ defstyle
    |app.theme.star-trail $ %{} :FileEntry
      :defs $ {}
        |base-style-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn base-style-expr () style-expr
        |base-style-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn base-style-leaf () style-leaf
        |css-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-expr $ {}
              "\"$0" $ {} (:border-width "|0 0 0px 1px") (:border-style :solid) (:min-height 24) (:outline :none) (:padding-left 10) (:font-family |Menlo,monospace) (:font-size 13) (:margin-bottom 2) (:margin-right 1) (:margin-left 8) (:line-height "\"1em") (:border-radius "\"8px")
                :border-color $ hsl 200 100 76 0.5
        |css-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle css-leaf $ {} ("\"$0" style-leaf)
        |decide-expr-style $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-expr-style (expr has-others? focused? focus-in? tail? layout-mode length depth)
              merge ({})
                if has-others? $ {}
                  :border-color $ hsl 0 0 100 0.6
                if focused? $ {}
                  :border-color $ hsl 0 0 100 0.9
                if focus-in? $ {} (:opacity 1)
                if
                  and (> length 0) (not tail?) (not= layout-mode :block)
                  , style-expr-simple
                if tail? style-expr-tail
        |decide-leaf-style $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn decide-leaf-style (text focused? first? by-other?)
              let
                  has-blank? $ or (= text "\"") (.includes? text "\" ")
                  best-width $ + 8
                    text-width* text (:font-size style-leaf) (:font-family style-leaf)
                  max-width 240
                merge
                  {} $ :width
                    js/Math.max 9 $ js/Math.min best-width max-width
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
        |style-big $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-big $ {}
              :border-right $ str "|16px solid " (hsl 0 0 30)
        |style-expr-simple $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-expr-simple $ {} (:display :inline-block) (:border-width "|0 0 1px 0") (:min-width 32) (:padding-left 11) (:padding-right 11) (:padding-bottom -1) (:vertical-align :top)
        |style-expr-tail $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-expr-tail $ {} (:display :inline-block) (:vertical-align :top) (:padding-left 10)
        |style-highlight $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-highlight $ {}
              :background-color $ hsl 0 0 100 0.2
        |style-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-leaf $ {} (:line-height |24px) (:height 24) (:margin "|1px 1px") (:padding "|0px 4px") (:background-color :transparent) (:min-width 8) (:font-family style/font-code) (:font-size 14) (:vertical-align :baseline) (:text-align :left) (:border-width "|1px 1px 1px 1px") (:resize :none) (:white-space :nowrap) (:outline :none) (:border :none) (:border-radius "\"6px")
              :color $ hsl 200 14 60
        |style-number $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-number $ {}
              :color $ hsl 0 70 40
        |style-partial $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-partial $ {}
              :border-right $ str "|8px solid " (hsl 0 0 30)
              :padding-right 0
        |style-space $ %{} :CodeEntry (:doc |)
          :code $ quote
            def style-space $ {}
              :background-color $ hsl 0 0 100 0.12
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.theme.star-trail $ :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            app.polyfill :refer $ text-width*
            app.style :as style
            respo.css :refer $ defstyle
    |app.twig.container $ %{} :FileEntry
      :defs $ {}
        |twig-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn twig-container (db session)
              let
                  logged-in? $ some? (:user-id session)
                  router $ :router session
                  writer $ :writer session
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
                        :files $ twig-page-files (:files db)
                          get-in session $ [] :writer :selected-ns
                          :saved-files db
                          get-in session $ [] :writer :draft-ns
                          :sessions db
                          :id session
                        :editor $ twig-page-editor (:files db) (:saved-files db) (:sessions db) (:users db) writer (:id session)
                        :members $ twig-page-members (:sessions db) (:users db)
                        :search $ twig-search (:files db)
                        :watching $ let
                            sessions $ :sessions db
                            his-sid $ :data router
                          if (contains? sessions his-sid)
                            twig-watching (get sessions his-sid) (:id session) (:files db) (:users db)
                            , nil
                        :configs $ {}
                          :configs $ :configs db
                          :entries $ :entries db
                    :stats $ {}
                      :members-count $ count (:sessions db)
                  {} (:session session) (:logged-in? false)
                    :stats $ {} (:members-count 0)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.container $ :require
            app.twig.user :refer $ twig-user
            app.twig.page-files :refer $ twig-page-files
            app.twig.page-editor :refer $ twig-page-editor
            app.twig.page-members :refer $ twig-page-members
            app.twig.search :refer $ twig-search
            app.twig.watching :refer $ twig-watching
    |app.twig.member $ %{} :FileEntry
      :defs $ {}
        |twig-member $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn twig-member (session user)
              {} (:user user)
                :nickname $ :nickname session
                :bookmark $ let
                    writer $ :writer session
                  get (:stack writer) (:pointer writer)
                :page $ get-in session ([] :router :name)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.member $ :require
    |app.twig.page-editor $ %{} :FileEntry
      :defs $ {}
        |pick-from-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn pick-from-ns (ns-info)
              let
                  var-names $ keys (:defs ns-info)
                  rules $ ->
                    tree->cirru $ :code (:ns ns-info)
                    nth 2
                    rest
                    either $ []
                  import-names $ -> rules
                    map $ fn (rule)
                      let
                          p0 $ first rule
                          p2 $ last rule
                        if (string? p2)
                          [] p0 $ [] p2
                          [] p0 $ filter p2
                            fn (x) (not= x "\"[]")
                    pairs-map
                {} (:imported import-names) (:defined var-names)
        |twig-page-editor $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn twig-page-editor (files old-files sessions users writer session-id)
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
                          :def $ compare-entry
                            get (:defs file) (:extra bookmark)
                            get (:defs old-file) (:extra bookmark)
                  , nil
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.page-editor $ :require
            app.util :refer $ same-buffer? tree->cirru
            app.twig.user :refer $ twig-user
            app.util.list :refer $ compare-entry
    |app.twig.page-files $ %{} :FileEntry
      :defs $ {}
        |keys-set $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn keys-set (x) (keys x)
        |render-changed-files $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                      empty? $ :defs info
                pairs-map
        |twig-page-files $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn twig-page-files (files selected-ns saved-files draft-ns sessions sid)
              {}
                :ns-dict $ -> files
                  map-kv $ fn (k v)
                    [] k $ get-in v ([] :ns :doc)
                :defs-dict $ if (some? selected-ns)
                  ->
                    get-in files $ [] selected-ns :defs
                    or $ {}
                    map-kv $ fn (k v)
                      [] k $ :doc v
                  {}
                :changed-files $ render-changed-files files saved-files
                :peeking-file $ if (some? draft-ns) (get files draft-ns) nil
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.page-files $ :require
            clojure.set :refer $ union
            app.util :refer $ file->cirru
            app.util.list :refer $ compare-entry
    |app.twig.page-members $ %{} :FileEntry
      :defs $ {}
        |twig-page-members $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn twig-page-members (sessions users)
              -> sessions $ map-kv
                fn (k session)
                  [] k $ twig-member session
                    get users $ :user-id session
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.page-members $ :require
            app.twig.member :refer $ twig-member
    |app.twig.search $ %{} :FileEntry
      :defs $ {}
        |twig-search $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn twig-search (files)
              -> files (.to-list)
                mapcat $ fn (entry)
                  let-sugar
                        [] k file
                        , entry
                    concat
                      [] $ {} (:kind :ns) (:ns k)
                      -> (:defs file) (.to-list)
                        map $ fn (f-entry)
                          let-sugar
                                [] f-k file
                                , f-entry
                            {} (:kind :def) (:ns k) (:extra f-k)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.search $ :require
    |app.twig.user $ %{} :FileEntry
      :defs $ {}
        |twig-user $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn twig-user (user)
              -> user $ dissoc :password
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.user $ :require
    |app.twig.watching $ %{} :FileEntry
      :defs $ {}
        |twig-watching $ %{} :CodeEntry (:doc |)
          :code $ quote
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.twig.watching $ :require
            app.util :refer $ to-bookmark
            app.twig.user :refer $ twig-user
    |app.updater $ %{} :FileEntry
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn updater (db op sid op-id op-time)
              tag-match op
                  :session/connect
                  session/connect db sid op-id op-time
                (:session/disconnect) (session/disconnect db sid op-id op-time)
                (:session/select-ns op-data) (session/select-ns db op-data sid op-id op-time)
                (:user/nickname op-data) (user/nickname db op-data sid op-id op-time)
                (:user/log-in op-data) (user/log-in db op-data sid op-id op-time)
                (:user/sign-up op-data) (user/sign-up db op-data sid op-id op-time)
                (:user/log-out op-data) (user/log-out db op-data sid op-id op-time)
                (:user/change-theme op-data) (user/change-theme db op-data sid op-id op-time)
                (:router/change op-data) (router/change db op-data sid op-id op-time)
                (:writer/edit op-data) (writer/edit db op-data sid op-id op-time)
                (:writer/edit-ns) (writer/edit-ns db sid op-id op-time)
                (:writer/select op-data) (writer/select db op-data sid op-id op-time)
                (:writer/point-to op-data) (writer/point-to db op-data sid op-id op-time)
                (:writer/focus op-data) (writer/focus db op-data sid op-id op-time)
                (:writer/go-up op-data) (writer/go-up db op-data sid op-id op-time)
                (:writer/go-down op-data) (writer/go-down db op-data sid op-id op-time)
                (:writer/go-left op-data) (writer/go-left db op-data sid op-id op-time)
                (:writer/go-right op-data) (writer/go-right db op-data sid op-id op-time)
                (:writer/remove-idx op-data) (writer/remove-idx db op-data sid op-id op-time)
                (:writer/paste op-data) (writer/paste db op-data sid op-id op-time)
                (:writer/save-files op-data) (writer/save-files db op-data sid op-id op-time)
                (:writer/collapse op-data) (writer/collapse db op-data sid op-id op-time)
                (:writer/move-next) (writer/move-next db sid op-id op-time)
                (:writer/move-previous) (writer/move-previous db sid op-id op-time)
                (:writer/move-order op-data) (writer/move-order db op-data sid op-id op-time)
                (:writer/finish) (writer/finish db sid op-id op-time)
                (:writer/draft-ns op-data) (writer/draft-ns db op-data sid op-id op-time)
                (:writer/hide-peek op-data) (writer/hide-peek db op-data sid op-id op-time)
                (:writer/picker-mode) (writer/picker-mode db sid op-id op-time)
                (:writer/pick-node op-data) (writer/pick-node db op-data sid op-id op-time)
                (:writer/doc-set path docstring) (writer/doc-set db path docstring sid op-id op-time)
                (:ir/add-ns op-data) (ir/add-ns db op-data sid op-id op-time)
                (:ir/add-def op-data) (ir/add-def db op-data sid op-id op-time)
                (:ir/remove-def op-data) (ir/remove-def db op-data sid op-id op-time)
                (:ir/remove-ns op-data) (ir/remove-ns db op-data sid op-id op-time)
                (:ir/prepend-leaf op-data) (ir/prepend-leaf db op-data sid op-id op-time)
                (:ir/append-leaf op-data) (ir/append-leaf db op-data sid op-id op-time)
                (:ir/delete-node op-data) (ir/delete-node db op-data sid op-id op-time)
                (:ir/leaf-after op-data) (ir/leaf-after db op-data sid op-id op-time)
                (:ir/leaf-before op-data) (ir/leaf-before db op-data sid op-id op-time)
                (:ir/expr-before op-data) (ir/expr-before db op-data sid op-id op-time)
                (:ir/expr-after op-data) (ir/expr-after db op-data sid op-id op-time)
                (:ir/expr-replace op-data) (ir/expr-replace db op-data sid op-id op-time)
                (:ir/indent op-data) (ir/indent db op-data sid op-id op-time)
                (:ir/unindent op-data) (ir/unindent db op-data sid op-id op-time)
                (:ir/unindent-leaf op-data) (ir/unindent-leaf db op-data sid op-id op-time)
                (:ir/update-leaf op-data) (ir/update-leaf db op-data sid op-id op-time)
                (:ir/duplicate op-data) (ir/duplicate db op-data sid op-id op-time)
                (:ir/rename op-data) (ir/rename db op-data sid op-id op-time)
                (:ir/cp-ns op-data) (ir/cp-ns db op-data sid op-id op-time)
                (:ir/mv-ns op-data) (ir/mv-ns db op-data sid op-id op-time)
                (:ir/delete-entry op-data) (ir/delete-entry db op-data sid op-id op-time)
                (:ir/reset-files op-data) (ir/reset-files db op-data sid op-id op-time)
                (:ir/reset-at op-data) (ir/reset-at db op-data sid op-id op-time)
                (:ir/reset-ns op-data) (ir/reset-ns db op-data sid op-id op-time)
                (:ir/draft-expr op-data) (ir/draft-expr db op-data sid op-id op-time)
                (:ir/replace-file op-data) (ir/replace-file db op-data sid op-id op-time)
                (:ir/file-config op-data) (ir/file-config db op-data sid op-id op-time)
                (:ir/clone-ns op-data) (ir/clone-ns db op-data sid op-id op-time)
                (:ir/toggle-comment op-data) (ir/toggle-comment db op-data sid op-id op-time)
                (:notify/push-message op-data) (notify/push-message db op-data sid op-id op-time)
                (:notify/clear op-data) (notify/clear db op-data sid op-id op-time)
                (:notify/broadcast op-data) (notify/broadcast db op-data sid op-id op-time)
                (:analyze/goto-def op-data) (analyze/goto-def db op-data sid op-id op-time)
                (:analyze/abstract-def op-data) (analyze/abstract-def db op-data sid op-id op-time)
                (:analyze/peek-def op-data) (analyze/peek-def db op-data sid op-id op-time)
                (:watcher/file-change op-data) (watcher/file-change db op-data sid op-id op-time)
                (:ping op-data) db
                (:configs/update op-data) (configs/update-configs db op-data sid op-id op-time)
                (:configs/update-entries op-data) (configs/update-entries db op-data sid op-id op-time)
                _ $ do (eprintln "|Unknown op:" op) db
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater $ :require (app.updater.session :as session) (app.updater.user :as user) (app.updater.router :as router) (app.updater.ir :as ir) (app.updater.writer :as writer) (app.updater.notify :as notify) (app.updater.analyze :as analyze) (app.updater.watcher :as watcher) (app.updater.configs :as configs)
    |app.updater.analyze $ %{} :FileEntry
      :defs $ {}
        |abstract-def $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn abstract-def (db op-data sid op-id op-time)
              let
                  writer $ to-writer db sid
                  files $ get db :files
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
                        get-in $ [] ns-text :defs (:extra bookmark) :code
                        get-in target-path
                    -> db
                      update-in ([] :files ns-text :defs)
                        fn (defs)
                          ; println target-path (prepend target-path def-text) (tree->cirru target-expr) (keys defs)
                          -> defs
                            assoc def-text $ %{} schema/CodeEntry (:doc "\"")
                              :code $ cirru->tree
                                [] |def def-text $ tree->cirru target-expr
                                , user-id op-time
                            assoc-in
                              prepend target-path $ :extra bookmark
                              cirru->tree def-text user-id op-time
                      update-in ([] :sessions sid :writer) (push-bookmark new-bookmark)
        |goto-def $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn goto-def (db op-data sid op-id op-time)
              let
                  writer $ to-writer db sid
                  pkg $ get db :package
                  bookmark $ to-bookmark writer
                  ns-text $ :ns bookmark
                  ns-expr $ tree->cirru
                    get-in db $ [] :files ns-text :ns :code
                  deps-info $ parse-deps (.slice ns-expr 2)
                  def-info $ parse-def (:text op-data)
                  forced? $ :forced? op-data
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
                    get-in db $ [] :files (:ns new-bookmark) :defs (:extra new-bookmark)
                  user-id $ get-in db ([] :sessions sid :user-id)
                  warn $ fn (x)
                    -> db $ update-in ([] :sessions sid :notifications) (push-warning op-id op-time x)
                ; println |deps deps-info def-info new-bookmark def-existed?
                if (some? new-bookmark)
                  if
                    or
                      = pkg $ :ns new-bookmark
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
                            target-ns $ :ns new-bookmark
                            target-def $ :extra new-bookmark
                            def-code $ cirru->tree new-expr user-id op-time
                          -> db
                            update-in ([] :files)
                              fn (files)
                                if (contains? files target-ns)
                                  assoc-in files ([] target-ns :defs target-def)
                                    %{} schema/CodeEntry (:doc "\"") (:code def-code)
                                  assoc files target-ns $ {}
                                    :ns $ cirru->tree ([] "\"ns" target-ns) user-id op-time
                                    :defs $ {}
                                      target-def $ %{} schema/CodeEntry (:doc "\"") (:code def-code)
                            update-in ([] :sessions sid :writer) (push-bookmark new-bookmark)
                        warn $ str "|Does not exist: " (:ns new-bookmark) "| " (:extra new-bookmark)
                    warn $ str "|From external ns: " (:ns new-bookmark)
                  warn $ str "|Cannot locate: " def-info
        |peek-def $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn peek-def (db op-data sid op-id op-time)
              let
                  writer $ to-writer db sid
                  pkg $ get db :package
                  bookmark $ to-bookmark writer
                  ns-text $ :ns bookmark
                  ns-expr $ tree->cirru
                    get-in db $ [] :files ns-text :ns
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
                    get-in db $ [] :files (:ns new-bookmark) :defs (:extra new-bookmark)
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater.analyze $ :require
            app.util :refer $ bookmark->path to-writer to-bookmark parse-deps tree->cirru cirru->tree parse-def push-warning
            app.util.stack :refer $ push-bookmark
            app.schema :as schema
    |app.updater.configs $ %{} :FileEntry
      :defs $ {}
        |update-configs $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn update-configs (db op-data session-id op-id op-time)
              update db :configs $ fn (configs) (merge configs op-data)
        |update-entries $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn update-entries (db op-data session-id op-id op-time)
              let
                  operation $ nth op-data 0
                  data $ nth op-data 1
                update db :entries $ fn (d)
                  case-default operation
                    do (eprintln "\"unknown entries operation" operation) d
                    :reset data
                    :merge $ merge d data
                    :dissoc $ dissoc d data
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.updater.configs)
    |app.updater.ir $ %{} :FileEntry
      :defs $ {}
        |add-def $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                assoc-in db ([] :files ns-part :defs def-part)
                  %{} schema/CodeEntry (:doc |)
                    :code $ cirru->tree cirru-expr user-id op-time
        |add-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn add-ns (db op-data session-id op-id op-time)
              let
                  user-id $ get-in db ([] :sessions session-id :user-id)
                  cirru-expr $ [] |ns op-data
                  default-expr $ cirru->tree cirru-expr user-id op-time
                  empty-expr $ cirru->tree ([]) user-id op-time
                -> db
                  assoc-in ([] :files op-data)
                    %{} schema/FileEntry
                      :ns $ %{} schema/CodeEntry (:doc "\"") (:code default-expr)
                      :defs $ {}
                  assoc-in ([] :sessions session-id :writer :selected-ns) op-data
        |append-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn append-leaf (db op-data session-id op-id op-time)
              let-sugar
                  writer $ get-in db ([] :sessions session-id :writer)
                  ({} stack pointer) writer
                  bookmark $ get stack pointer
                  focus $ :focus bookmark
                  user-id $ get-in db ([] :sessions session-id :user-id)
                  new-leaf $ %{} schema/CirruLeaf (:by user-id) (:at op-time) (:text "\"")
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
        |call-replace-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn call-replace-expr (expr from to)
              if (expr? expr)
                update expr :data $ fn (data)
                  -> data (.to-list)
                    map $ fn (pair)
                      let[] (k v) pair $ [] k (call-replace-expr v from to)
                    filter-not $ fn (pair)
                      let[] (k v) pair $ and (leaf? v)
                        blank? $ :text v
                    pairs-map
                cond
                    = (:text expr) from
                    assoc expr :text to
                  (= (:text expr) (str "\"@" from))
                    assoc expr :text $ str "\"@" to
                  true expr
        |clone-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn clone-ns (db op-data sid op-id op-time)
              let
                  writer $ get-in db ([] :sessions sid :writer)
                  selected-ns $ :selected-ns writer
                  files $ get db :files
                  warn $ fn (x)
                    update-in db ([] :sessions sid :notifications) (push-warning op-id op-time x)
                  new-ns op-data
                cond
                    not $ and (string? new-ns) (includes? new-ns "\".")
                    warn "\"Not a valid string!"
                  (contains? files op-data)
                    warn $ str new-ns "\" already existed!"
                  (not (contains? files selected-ns))
                    warn "\"No selected namespace!"
                  true $ -> db
                    update :files $ fn (files)
                      let
                          the-file $ get files selected-ns
                          ns-expr $ :ns the-file
                          new-file $ update the-file :ns
                            fn (expr)
                              let
                                  name-field $ key-nth (:data ns-expr) 1
                                assert (str "\"old namespace to change:" selected-ns "\" " ns-expr)
                                  = selected-ns $ get-in ns-expr ([] :data name-field :text)
                                assoc-in expr ([] :data name-field :text) new-ns
                        assoc files new-ns new-file
                    assoc-in ([] :sessions sid :writer :selected-ns) new-ns
        |cp-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn cp-ns (db op-data session-id op-id op-time)
              update db :files $ fn (files)
                -> files $ assoc (:to op-data)
                  get files $ :from op-data
        |delete-entry $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn delete-entry (db op-data session-id op-id op-time) (; println |delete op-data)
              case-default (:kind op-data)
                do (println "\"[warning] no entry to delete") db
                :def $ -> db
                  update-in
                    [] :files (:ns op-data) :defs
                    fn (defs)
                      dissoc defs $ :extra op-data
                  update-in ([] :sessions session-id :writer)
                    fn (writer)
                      -> writer
                        update :stack $ fn (stack)
                          dissoc-idx stack $ :pointer writer
                        update :pointer dec
                :ns $ -> db
                  update :files $ fn (files)
                    dissoc files $ :ns op-data
                  update-in ([] :sessions session-id :writer)
                    fn (writer)
                      -> writer
                        update :stack $ fn (stack)
                          dissoc-idx stack $ :pointer writer
                        update :pointer dec
        |delete-node $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                if
                  empty? $ :focus bookmark
                  -> db $ update-in ([] :sessions session-id :notifications) (push-warning op-id op-time "\"cannot delete from root")
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
        |draft-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn draft-expr (db op-data session-id op-id op-time)
              let
                  writer $ get-in db ([] :sessions session-id :writer)
                  bookmark $ get (:stack writer) (:pointer writer)
                  data-path $ bookmark->path bookmark
                  user-id $ get-in db ([] :sessions session-id :user-id)
                -> db $ update-in data-path
                  fn (expr) (cirru->tree op-data user-id op-time)
        |duplicate $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |expr-after $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  new-leaf $ %{} schema/CirruLeaf (:at op-time) (:by user-id) (:text "\"")
                  new-expr $ %{} schema/CirruExpr (:at op-time) (:by user-id)
                    :data $ {} (bisection/mid-id new-leaf)
                -> db
                  update-in data-path $ fn (expr)
                    assoc-in expr ([] :data next-id) new-expr
                  update-in
                    [] :sessions session-id :writer :stack (:pointer writer) :focus
                    fn (focus)
                      -> (butlast focus) (conj next-id) (conj bisection/mid-id)
        |expr-before $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  new-leaf $ %{} schema/CirruLeaf (:at op-time) (:by user-id) (:text "\"")
                  new-expr $ %{} schema/CirruExpr (:at op-time) (:by user-id)
                    :data $ {} (bisection/mid-id new-leaf)
                -> db
                  update-in data-path $ fn (expr)
                    assoc-in expr ([] :data next-id) new-expr
                  update-in
                    [] :sessions session-id :writer :stack (:pointer writer) :focus
                    fn (focus)
                      -> (butlast focus) (conj next-id) (conj bisection/mid-id)
        |expr-replace $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn expr-replace (db op-data session-id op-id op-time)
              let
                  from $ :from op-data
                  to $ :to op-data
                  bookmark $ :bookmark op-data
                  data-path $ bookmark->path bookmark
                update-in db data-path $ fn (expr) (call-replace-expr expr from to)
        |file-config $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn file-config (db op-data sid op-id op-time)
              let
                  ns-text $ get-in db ([] :sessions sid :writer :selected-ns)
                if (some? ns-text)
                  update-in db ([] :files ns-text :configs)
                    fn (configs) (merge configs op-data)
                  , db
        |indent $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn indent (db op-data session-id op-id op-time)
              let-sugar
                  writer $ get-in db ([] :sessions session-id :writer)
                  ({} stack pointer) writer
                  bookmark $ get stack pointer
                  data-path $ bookmark->path bookmark
                  user-id $ get-in db ([] :sessions session-id :user-id)
                  new-expr $ %{} schema/CirruExpr (:at op-time) (:by user-id)
                    :data $ {}
                -> db
                  update-in data-path $ fn (node)
                    assoc-in new-expr ([] :data bisection/mid-id) node
                  update-in ([] :sessions session-id :writer :stack pointer :focus)
                    fn (focus)
                      if (empty? focus) ([] bisection/mid-id)
                        concat (butlast focus)
                          [] (last focus) bisection/mid-id
        |leaf-after $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn leaf-after (db op-data session-id op-id op-time)
              let-sugar
                  writer $ get-in db ([] :sessions session-id :writer)
                  ({} stack pointer) writer
                  bookmark $ get stack pointer
                  user-id $ get-in db ([] :sessions session-id :user-id)
                if
                  empty? $ :focus bookmark
                  let
                      data-path $ bookmark->path bookmark
                      target-expr $ get-in db data-path
                      next-id $ key-append (:data target-expr)
                      new-leaf $ %{} schema/CirruLeaf (:at op-time) (:by user-id) (:text "\"")
                    ; "\"append new leaf at tail, this case is special"
                    -> db
                      update-in data-path $ fn (expr)
                        assoc-in expr ([] :data next-id) new-leaf
                      assoc-in
                        [] :sessions session-id :writer :stack (:pointer writer) :focus
                        [] next-id
                  let
                      parent-bookmark $ update bookmark :focus butlast
                      data-path $ bookmark->path parent-bookmark
                      target-expr $ get-in db data-path
                      next-id $ key-after (:data target-expr)
                        last $ :focus bookmark
                      new-leaf $ %{} schema/CirruLeaf (:at op-time) (:by user-id) (:text "\"")
                    -> db
                      update-in data-path $ fn (expr)
                        assoc-in expr ([] :data next-id) new-leaf
                      update-in
                        [] :sessions session-id :writer :stack (:pointer writer) :focus
                        fn (focus)
                          conj (butlast focus) next-id
        |leaf-before $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  new-leaf $ %{} schema/CirruLeaf (:at op-time) (:by user-id) (:text "\"")
                -> db
                  update-in data-path $ fn (expr)
                    assoc-in expr ([] :data next-id) new-leaf
                  update-in
                    [] :sessions session-id :writer :stack (:pointer writer) :focus
                    fn (focus)
                      conj (butlast focus) next-id
        |mv-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn mv-ns (db op-data session-id op-id op-time)
              update db :files $ fn (files)
                -> files
                  dissoc $ :from op-data
                  assoc (:to op-data)
                    get files $ :from op-data
        |prepend-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn prepend-leaf (db op-data session-id op-id op-time)
              let-sugar
                  writer $ get-in db ([] :sessions session-id :writer)
                  ({} stack pointer) writer
                  bookmark $ get stack pointer
                  focus $ :focus bookmark
                  user-id $ get-in db ([] :sessions session-id :user-id)
                  new-leaf $ %{} schema/CirruLeaf (:by user-id) (:at op-time) (:text "\"")
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
        |remove-def $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn remove-def (db op-data session-id op-id op-time)
              let
                  selected-ns $ get-in db ([] :sessions session-id :writer :selected-ns)
                update-in db ([] :files selected-ns :defs)
                  fn (defs) (dissoc defs op-data)
        |remove-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn remove-ns (db op-data session-id op-id op-time)
              -> db
                update :files $ fn (files) (dissoc files op-data)
                update-in ([] :sessions session-id :writer :selected-ns)
                  fn (x)
                    if (= x op-data) nil x
        |rename $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                        expr $ get-in db ([] :files old-ns :ns :code)
                        next-id $ key-nth (:data expr) 1
                      -> db
                        update :files $ fn (files)
                          -> files (dissoc old-ns)
                            assoc new-ns $ get files old-ns
                        assoc-in ([] :sessions session-id :writer :stack idx :ns) new-ns
                        update-in ([] :files new-ns :ns :code :data next-id :text)
                          fn (x) new-ns
                  (= :def kind)
                    let
                        old-ns $ :from ns-info
                        new-ns $ :to ns-info
                        old-def $ :from extra-info
                        new-def $ :to extra-info
                        expr $ get-in db ([] :files old-ns :defs old-def :code)
                        next-id $ key-nth (:data expr) 1
                        files $ get db :files
                      if (contains? files new-ns)
                        -> db
                          update :files $ fn (files)
                            -> files
                              update-in ([] old-ns :defs)
                                fn (file) (dissoc file old-def)
                              assoc-in ([] new-ns :defs new-def)
                                get-in files $ [] old-ns :defs old-def
                          update-in ([] :sessions session-id :writer :stack idx)
                            fn (bookmark)
                              -> bookmark (assoc :ns new-ns) (assoc :extra new-def)
                          update-in ([] :files new-ns :defs new-def :code :data)
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
        |replace-file $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn replace-file (db op-data sid op-id op-time)
              let
                  user-id $ get-in db ([] :sessions sid :user-id)
                  ns-text $ get-in db ([] :sessions sid :writer :draft-ns)
                if (some? ns-text)
                  assoc-in db ([] :files ns-text) (cirru->file op-data user-id op-time)
                  do (println "|undefined draft-ns") db
        |reset-at $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reset-at (db op-data session-id op-id op-time)
              let
                  saved-files $ :saved-files db
                  old-file $ get saved-files (:ns op-data)
                update-in db
                  [] :files $ :ns op-data
                  fn (file)
                    case-default (:kind op-data)
                      raise $ str "|Malformed data: " (to-lispy-string op-data)
                      :ns $ assoc file :ns (:ns old-file)
                      :def $ let
                          def-text $ :extra op-data
                        assoc-in file ([] :defs def-text)
                          get-in old-file $ [] :defs def-text
        |reset-files $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reset-files (db op-data session-id op-id op-time)
              assoc db :files $ :saved-files db
        |reset-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reset-ns (db op-data session-id op-id op-time)
              let
                  ns-text op-data
                assoc-in db ([] :files ns-text)
                  get-in db $ [] :saved-files ns-text
        |toggle-comment $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn toggle-comment (db op-data sid op-id op-time)
              let
                  writer $ to-writer db sid
                  bookmark $ to-bookmark writer
                  data-path $ bookmark->path bookmark
                  user-id $ get-in db ([] :sessions sid :user-id)
                update-in db data-path $ fn (node)
                  if (expr? node)
                    update node :data $ fn (data)
                      let
                          k0 $ get-min-key data
                        if
                          and (some? k0)
                            = "\";" $ get-in data ([] k0 :text)
                          dissoc data k0
                          assoc-prepend data $ cirru->tree "\";" user-id op-time
                    do (println "\"Toggle comment at wrong place," node) node
        |unindent $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn unindent (db op-data session-id op-id op-time)
              let
                  writer $ get-in db ([] :sessions session-id :writer)
                  bookmark $ get (:stack writer) (:pointer writer)
                  parent-bookmark $ update bookmark :focus butlast
                  last-coord $ last (:focus bookmark)
                  parent-path $ bookmark->path parent-bookmark
                if
                  empty? $ :focus bookmark
                  -> db $ update-in (bookmark->path bookmark)
                    fn (expr)
                      if
                        = 1 $ count (:data expr)
                        last $ first (:data expr)
                        , expr
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
        |unindent-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                      tag-match
                        destruct-map $ :data expr
                        (:none) (raise "\"unexpected empty expr")
                        (:some k v ms) v
                    update-in
                      [] :sessions session-id :writer :stack (:pointer writer) :focus
                      fn (focus) (butlast focus)
                  , db
        |update-leaf $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                      %{} schema/CirruLeaf
                        :text $ :text op-data
                        :at $ :at op-data
                        :by user-id
                      do (println "\"invalid updata op:" op-data) leaf
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater.ir $ :require (app.schema :as schema) (bisection-key.core :as bisection)
            app.util :refer $ expr? leaf? bookmark->path to-writer to-bookmark to-keys cirru->tree cirru->file
            app.util.list :refer $ dissoc-idx
            bisection-key.util :refer $ key-before key-after key-prepend key-append assoc-prepend key-nth assoc-nth val-nth get-min-key
            app.util :refer $ push-warning expr? leaf?
    |app.updater.notify $ %{} :FileEntry
      :defs $ {}
        |broadcast $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn broadcast (db op-data sid op-id op-time)
              let
                  user-id $ get-in db ([] :sessions sid :user-id)
                  user-name $ get-in db ([] :users user-id :name)
                update db :sessions $ fn (sessions)
                  -> sessions $ map-kv
                    fn (k session)
                      [] k $ update session :notifications
                        push-info op-id op-time $ str user-name "\": " op-data
        |clear $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn clear (db op-data session-id op-id op-time)
              assoc-in db ([] :sessions session-id :notifications) ([])
        |push-message $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn push-message (db op-data sid op-id op-time)
              let-sugar
                    [] kind text
                    , op-data
                update-in db ([] :sessions sid :notifications)
                  fn (xs)
                    conj xs $ {} (:id op-id) (:kind kind) (:text text) (:time op-time)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater.notify $ :require
            app.util :refer $ push-info
    |app.updater.router $ %{} :FileEntry
      :defs $ {}
        |change $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn change (db op-data session-id op-id op-time)
              assoc-in db ([] :sessions session-id :router) op-data
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.updater.router)
    |app.updater.session $ %{} :FileEntry
      :defs $ {}
        |connect $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn connect (db session-id op-id op-time)
              assoc-in db ([] :sessions session-id)
                merge schema/session $ {} (:id session-id)
        |disconnect $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn disconnect (db session-id op-id op-time)
              update db :sessions $ fn (session) (dissoc session session-id)
        |select-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn select-ns (db op-data session-id op-id op-time)
              assoc-in db ([] :sessions session-id :writer :selected-ns) op-data
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater.session $ :require (app.schema :as schema)
    |app.updater.user $ %{} :FileEntry
      :defs $ {}
        |change-theme $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn change-theme (db op-data sid op-id op-time)
              let
                  user-id $ get-in db ([] :sessions sid :user-id)
                -> db
                  assoc-in ([] :users user-id :theme) op-data
                  assoc-in ([] :sessions sid :theme) op-data
        |log-in $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |log-out $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn log-out (db op-data session-id op-id op-time)
              assoc-in db ([] :sessions session-id :user-id) nil
        |nickname $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn nickname (db op-data sid op-id op-time)
              let
                  user-id $ get-in db ([] :sessions sid :user-id)
                assoc-in db ([] :users user-id :nickname)
                  if (blank? op-data) |Someone op-data
        |sign-up $ %{} :CodeEntry (:doc |)
          :code $ quote
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater.user $ :require
            app.util :refer $ find-first push-warning
            clojure.string :as string
            |md5 :default md5
            app.schema :as schema
    |app.updater.watcher $ %{} :FileEntry
      :defs $ {}
        |file-change $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn file-change (db op-data _ op-id op-time)
              let
                  new-files $ get op-data :files
                if
                  = (get db :files) (:saved-files db)
                  -> db (assoc :saved-files new-files) (assoc :files new-files)
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
                              update :defs $ fn (defs)
                                -> defs $ map-kv
                                  fn (def-text expr)
                                    let
                                        old-expr $ get old-file def-text
                                      [] def-text $ if (= expr old-expr) old-expr expr
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.updater.watcher)
    |app.updater.writer $ %{} :FileEntry
      :defs $ {}
        |collapse $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn collapse (db op-data session-id op-id op-time)
              -> db $ update-in ([] :sessions session-id :writer)
                fn (writer)
                  -> writer
                    update :stack $ fn (stack) (.slice stack op-data)
                    assoc :pointer 0
        |doc-set $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn doc-set (db path docstring sid op-id op-time)
              tag-match path
                  :ns ns-text
                  assoc-in db ([] :files ns-text :ns :doc) docstring
                (:def ns-text def-text)
                  assoc-in db ([] :files ns-text :defs def-text :doc) docstring
        |draft-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn draft-ns (db op-data sid op-id op-time)
              -> db $ update-in ([] :sessions sid :writer)
                fn (writer) (assoc writer :draft-ns op-data)
        |edit $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |edit-ns $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn edit-ns (db sid op-id op-time)
              let
                  writer $ to-writer db sid
                  bookmark $ to-bookmark writer
                  ns-text $ :ns bookmark
                if
                  = :def $ :kind bookmark
                  -> db $ update-in ([] :sessions sid :writer)
                    push-bookmark $ assoc schema/bookmark :kind :ns :ns ns-text
                  , db
        |finish $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn finish (db sid op-id op-time)
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
        |focus $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn focus (db op-data session-id op-id op-time)
              let
                  writer $ get-in db ([] :sessions session-id :writer)
                assoc-in db
                  [] :sessions session-id :writer :stack (:pointer writer) :focus
                  , op-data
        |go-down $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |go-left $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |go-right $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |go-up $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn go-up (db op-data session-id op-id op-time)
              -> db $ update-in ([] :sessions session-id :writer)
                fn (writer)
                  update-in writer
                    [] :stack (:pointer writer) :focus
                    fn (focus)
                      if (empty? focus) focus $ butlast focus
        |hide-peek $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn hide-peek (db op-data sid op-id op-time)
              assoc-in db ([] :sessions sid :writer :peek-def) nil
        |move-next $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn move-next (db sid op-id op-time)
              -> db $ update-in ([] :sessions sid :writer)
                fn (writer)
                  let
                      pointer $ :pointer writer
                    assoc writer :pointer $ if
                      >= pointer $ dec
                        count $ :stack writer
                      , pointer (inc pointer)
        |move-order $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                          (or (< pointer (min ([] from-idx to-idx))) (> pointer (max ([] from-idx to-idx))))
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
        |move-previous $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn move-previous (db sid op-id op-time)
              -> db $ update-in ([] :sessions sid :writer)
                fn (writer)
                  let
                      pointer $ :pointer writer
                    assoc writer :pointer $ if (> pointer 0) (dec pointer) 0
        |paste $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn paste (db op-data sid op-id op-time)
              let
                  writer $ to-writer db sid
                  bookmark $ to-bookmark writer
                  data-path $ bookmark->path bookmark
                  user-id $ get-in db ([] :sessions sid :user-id)
                if (list? op-data)
                  -> db $ assoc-in data-path (cirru->tree op-data user-id op-time)
                  , db
        |pick-node $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |picker-mode $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn picker-mode (db session-id op-id op-time)
              update-in db ([] :sessions session-id :writer)
                fn (writer)
                  if
                    some? $ :picker-mode writer
                    dissoc writer :picker-mode
                    assoc writer :picker-mode $ to-bookmark writer
        |point-to $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn point-to (db op-data session-id op-id op-time)
              assoc-in db ([] :sessions session-id :writer :pointer) op-data
        |remove-idx $ %{} :CodeEntry (:doc |)
          :code $ quote
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
        |save-files $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn save-files (db op-data sid op-id op-time)
              let
                  user-id $ get-in db ([] :sessions sid :user-id)
                  user-name $ get-in db ([] :users user-id :name)
                -> db
                  update :saved-files $ fn (saved-files)
                    if (some? op-data)
                      let
                          target $ get-in db ([] :files op-data)
                        if (some? target) (assoc saved-files op-data target) (dissoc saved-files op-data)
                      get db :files
                  update :sessions $ fn (sessions)
                    -> sessions $ map-kv
                      fn (k session)
                        [] k $ update session :notifications
                          push-info op-id op-time $ str user-name
                            if (some? op-data) (str "\" modified ns " op-data "\"!") "\" saved files!"
        |select $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn select (db op-data session-id op-id op-time)
              let
                  bookmark $ assoc op-data :focus ([])
                -> db
                  update-in ([] :sessions session-id :writer) (push-bookmark bookmark)
                  assoc-in ([] :sessions session-id :router)
                    {} $ :name :editor
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater.writer $ :require
            app.util :refer $ bookmark->path to-writer to-bookmark push-info cirru->tree
            app.util.stack :refer $ push-bookmark
            app.util.list :refer $ dissoc-idx
            app.schema :as schema
            app.util :refer $ push-info
            app.util :refer $ stringify-s-expr
            bisection-key.util :refer $ get-min-key get-max-key
    |app.util $ %{} :FileEntry
      :defs $ {}
        |bookmark->path $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn bookmark->path (bookmark)
              assert (map? bookmark) "|Bookmark should be data"
              assert
                contains? kinds $ :kind bookmark
                , "|invalid bookmark type"
              if
                = :def $ :kind bookmark
                concat
                  [] :files (:ns bookmark) :defs (:extra bookmark) :code
                  mapcat
                    or (:focus bookmark) ([])
                    , prepend-data
                concat
                  [] :files (:ns bookmark) (:kind bookmark) :code
                  mapcat
                    or (:focus bookmark) ([])
                    , prepend-data
        |bookmark-full-str $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn bookmark-full-str (bookmark)
              case-default (:kind bookmark)
                do
                  js/console.warn $ str "\"Unknown" (to-lispy-string bookmark)
                  , "\""
                :def $ str (:ns bookmark) "\"/" (:extra bookmark)
                :ns $ str (:ns bookmark) "\"/"
        |cirru->file $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn cirru->file (file author timestamp)
              -> file
                update :ns $ \ cirru->tree % author timestamp
                update :defs $ fn (defs)
                  -> defs $ map-kv
                    fn (k xs)
                      [] k $ cirru->tree xs author timestamp
        |cirru->tree $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn cirru->tree (xs author timestamp)
              cond
                  tuple? xs
                  if
                    = 'quote $ nth xs 0
                    cirru->tree (nth xs 1) author timestamp
                    do (eprintln "\"unknown tuple from cirru:" xs)
                      cirru->tree (nth xs 1) author timestamp
                (= (type-of xs) :cirru-quote)
                  cirru->tree (&cirru-quote:to-list xs) author timestamp
                (list? xs)
                  %{} schema/CirruExpr (:at timestamp) (:by author)
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
                (string? xs)
                  %{} schema/CirruLeaf (:at timestamp) (:by author) (:text xs)
                true $ do (eprintln "\"unknown data for cirru converting:" xs) nil
        |db->string $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn db->string (db)
              format-cirru-edn $ -> db (dissoc :sessions) (dissoc :saved-files) (dissoc :repl)
        |expr? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn expr? (x) (&record:matches? schema/CirruExpr x)
        |file->cirru $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn file->cirru (file)
              %{} schema/FileEntry
                :ns $ -> (:ns file)
                  update :code $ fn (code)
                    :: 'quote $ tree->cirru code
                :defs $ -> (:defs file)
                  map-kv $ fn (k xs)
                    if (some? xs)
                      [] k $ -> xs
                        update :code $ fn (code)
                          :: 'quote $ tree->cirru code
                      , nil
        |file-compact-to-calcit $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn file-compact-to-calcit (file)
              let
                  now $ js/Date.now
                -> file
                  update :ns $ fn (pair)
                    cirru->tree (nth pair 1) "\"u0" now
                  update :defs $ fn (defs)
                    -> defs $ map-kv
                      fn (k v)
                        [] k $ cirru->tree (nth v 1) "\"u0" now
        |file-tree->cirru $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn file-tree->cirru (file)
              -> file (update :ns tree->cirru)
                update :defs $ fn (defs)
                  -> defs $ map-kv
                    fn (def-text def-tree)
                      [] def-text $ tree->cirru def-tree
        |find-first $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn find-first (f xs)
              find xs $ fn (x) (f x)
        |hide-empty-fields $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn hide-empty-fields (x)
              -> x (.to-list)
                filter-not $ fn (pair)
                  let[] (k v) pair $ nil? v
                pairs-map
        |kinds $ %{} :CodeEntry (:doc |)
          :code $ quote
            def kinds $ #{} :ns :def
        |leaf? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn leaf? (x) (&record:matches? schema/CirruLeaf x)
        |now! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn now! () $ js/Date.now
        |parse-def $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn parse-def (text)
              let
                  clean-text $ -> text (.!replace |@ |)
                if (.includes? clean-text |/)
                  let-sugar
                        [] ns-text def-text
                        split clean-text |/
                    {} (:method :as) (:key ns-text) (:def def-text)
                  {} (:method :refer) (:key clean-text) (:def clean-text)
        |parse-deps $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn parse-deps (require-exprs)
              if-let
                require-rules $ -> require-exprs
                  find $ fn (xs)
                    = |:require $ first xs
                loop
                    result $ {}
                    xs $ rest require-rules
                  ; println |loop result xs
                  if (empty? xs) result $ let
                      rule $ first xs
                    recur
                      merge result $ parse-require
                        if
                          = "\"[]" $ first rule
                          rest rule
                          , rule
                      rest xs
        |parse-require $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn parse-require (piece)
              let[] (ns-text method extra) piece $ case-default method
                do (println "\"Unknown referring:" piece) nil
                "\":as" $ {}
                  extra $ {} (:method :as) (:ns ns-text)
                "\":refer" $ -> extra
                  filter $ fn (def-text) (not= def-text "\"[]")
                  map $ fn (def-text)
                    [] def-text $ {} (:method :refer) (:ns ns-text) (:def def-text)
                  pairs-map
                "\":default" $ {}
                  extra $ {} (:method :refer) (:ns ns-text) (:def extra)
        |prepend-data $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn prepend-data (x) ([] :data x)
        |push-info $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn push-info (op-id op-time text)
              fn (xs)
                conj xs $ merge schema/notification
                  {} (:id op-id) (:kind :info) (:text text) (:time op-time)
        |push-warning $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn push-warning (op-id op-time text)
              fn (xs)
                conj xs $ merge schema/notification
                  {} (:id op-id) (:kind :warning) (:text text) (:time op-time)
        |same-buffer? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn same-buffer? (x y)
              and
                = (:kind x) (:kind y)
                = (:ns x) (:ns y)
                = (:extra x) (:extra y)
        |stringify-s-expr $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn stringify-s-expr (x)
              if (list? x)
                str "|("
                  -> x
                    map $ fn (y)
                      if (list? y) (stringify-s-expr y)
                        if (.includes? y "| ") (to-lispy-string y) y
                    join-str "| "
                  , "|)"
        |to-bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn to-bookmark (writer)
              let
                  stack $ :stack writer
                if (empty? stack) nil $ get stack (:pointer writer)
        |to-keys $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn to-keys (target-expr)
              sort $ .to-list
                keys $ :data target-expr
        |to-writer $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn to-writer (db session-id)
              get-in db $ [] :sessions session-id :writer
        |tree->cirru $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn tree->cirru (x)
              if (&record:matches? schema/CirruLeaf x) (:text x)
                -> (:data x) (.to-list) (.sort-by first)
                  map $ fn (entry)
                    tree->cirru $ last entry
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.util $ :require (app.schema :as schema) (bisection-key.core :as bisection)
    |app.util.compile $ %{} :FileEntry
      :defs $ {}
        |handle-compact-files! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn handle-compact-files! (pkg old-files latest-files added-names removed-names changed-names configs entries filter-ns)
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
                    :entries entries
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
                                  :: 'quote $ tree->cirru
                                    :code $ :ns new-file
                              :removed-defs removed-defs
                              :added-defs $ -> added-defs
                                map $ fn (x)
                                  [] x $ :: 'quote
                                    tree->cirru $ get-in new-defs ([] x :code)
                                hide-empty-fields
                              :changed-defs $ -> changed-defs
                                map $ fn (x)
                                  [] x $ :: 'quote
                                    tree->cirru $ get-in new-defs ([] x :code)
                                hide-empty-fields
                        pairs-map
                fs/writeFile "\"compact.cirru" (format-cirru-edn compact-data)
                  fn (err)
                    if (some? err) (js/console.log "\"Failed to write!" err)
                fs/writeFile "\".compact-inc.cirru" (format-cirru-edn inc-data)
                  fn (err)
                    if (some? err) (js/console.log "\"Failed to write!" err)
        |handle-files! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn handle-files! (db *calcit-md5 configs dispatch! save-ir? filter-ns)
              try
                let
                    new-files $ get db :files
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
                  handle-compact-files! (get db :package) old-files new-files added-names removed-names changed-names (:configs db) (:entries db) filter-ns
                  dispatch! $ :: :writer/save-files filter-ns
                  if save-ir? $ js/setTimeout
                    fn () $ let
                        db-content $ db->string db
                        started-time $ unix-time!
                      reset! *calcit-md5 $ md5 db-content
                      persist-async! (:storage-file config/site) db-content started-time
                fn (e)
                  do
                    println $ .!red chalk e
                    js/console.error e
                    dispatch! $ :: :notify/push-message
                      [] :error $ aget e "\"message"
        |path $ %{} :CodeEntry (:doc |)
          :code $ quote
            def path $ js/require |path
        |persist! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn persist! (storage-path db-str started-time) (fs/writeFileSync storage-path db-str)
              println $ .!gray chalk
                str "|took "
                  - (unix-time!) started-time
                  , "|ms to wrote calcit.cirru"
        |persist-async! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn persist-async! (storage-path db-str started-time)
              fs/writeFile storage-path db-str $ fn (err)
                if (some? err)
                  js/console.log $ .!red chalk "\"Failed to write storage!" err
                  println $ .!gray chalk
                    str "|took "
                      - (unix-time!) started-time
                      , "|ms to wrote calcit.cirru"
        |remove-file! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn remove-file! (file-path output-dir)
              let
                  project-path $ path/join output-dir file-path
                cp/execSync $ str "|rm -rfv " project-path
                println $ .!red chalk (str "|removed " project-path)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.util.compile $ :require
            app.util :refer $ file->cirru db->string tree->cirru now! hide-empty-fields
            "\"chalk" :default chalk
            "\"path" :as path
            "\"fs" :as fs
            "\"child_process" :as cp
            "\"md5" :default md5
            app.config :as config
            cumulo-util.core :refer $ unix-time!
            cirru-edn.core :as cirru-edn
    |app.util.detect $ %{} :FileEntry
      :defs $ {}
        |port-taken? $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                  .!listen port "\"0.0.0.0"
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.util.detect $ :require (|net :as net)
    |app.util.dom $ %{} :FileEntry
      :defs $ {}
        |copy-silently! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn copy-silently! (x)
              -> js/navigator .-clipboard (.!writeText x)
                .!then $ fn () (println "\"Copied.")
                .!catch $ fn (error) (js/console.error "\"Failed to copy:" error)
        |do-copy-logics! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn do-copy-logics! (d! x message)
              -> js/navigator .-clipboard (.!writeText x)
                .!then $ fn (? v)
                  d! :notify/push-message $ [] :info message
                .!catch $ fn (error) (js/console.error "\"Failed to copy:" error)
                  d! :notify/push-message $ [] :error (str "\"Failed to copy! " error)
        |focus! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn focus! () $ js/requestAnimationFrame
              fn (timestamp)
                let
                    current-focused $ .-activeElement js/document
                    cirru-focused $ js/document.querySelector |.cirru-focused
                  if (some? cirru-focused)
                    if
                      not $ identical? current-focused cirru-focused
                      .!focus cirru-focused
                    println "|[Editor] .cirru-focused not found" cirru-focused
        |focus-search! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn focus-search! () $ delay! 0.2
              fn () $ let
                  target $ js/document.querySelector |.search-input
                if (some? target) (.!focus target)
        |inject-style $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn inject-style (class-name styles)
              style $ {}
                :innerHTML $ str class-name "| {" (style->string styles) |}
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.util.dom $ :require
            respo.core :refer $ style
            respo.render.html :refer $ style->string
            cumulo-util.core :refer $ delay!
    |app.util.env $ %{} :FileEntry
      :defs $ {}
        |check-version! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn check-version! () $ let
                __dirname $ path/dirname (url/fileURLToPath js/import.meta.url)
                pkg $ js/JSON.parse
                  fs/readFileSync $ path/join __dirname "\"../package.json"
                version $ .-version pkg
                pkg-name $ .-name pkg
              -> (latest-version pkg-name)
                .!then $ fn (npm-version)
                  println $ if (= version npm-version) (str "\"Running latest version " version)
                    .!yellow chalk $ str "\"Update is available tagged " npm-version "\", current one is " version
                .!catch $ fn (e) (js/console.error "\"failed to request version:" e)
        |get-cli-configs! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn get-cli-configs! () $ {} (:op js/process.env.op)
        |pick-http-port! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn pick-http-port! (port next-fn)
              port-taken? port $ fn (err taken?)
                if (some? err)
                  do (js/console.error err) (js/process.exit 1)
                  if taken?
                    do
                      println $ str "\"port " port "\" in use."
                      pick-http-port! (inc port) next-fn
                    next-fn port
        |pick-port! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn pick-port! (port next-fn)
              port-taken? port $ fn (err taken?)
                if (some? err)
                  do (js/console.error err) (js/process.exit 1)
                  if taken?
                    do
                      println $ str "\"port " port "\" in use."
                      pick-port! (inc port) next-fn
                    do
                      let
                          link $ .!blue chalk (str "\"http://editor.calcit-lang.org?port=" port)
                        println $ str "\"port " port "\" ok, please edit on " link
                      next-fn port
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.util.env $ :require ("\"chalk" :default chalk)
            app.util.detect :refer $ port-taken?
            "\"latest-version" :default latest-version
            "\"path" :as path
            "\"url" :as url
            "\"fs" :as fs
    |app.util.list $ %{} :FileEntry
      :defs $ {}
        |cirru-form? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn cirru-form? (x)
              if (string? x) true $ if (list? x) (map x cirru-form?) false
        |compare-entry $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn compare-entry (new-x old-x)
              cond
                  and (nil? old-x) (some? new-x)
                  , :add
                (and (some? old-x) (nil? new-x))
                  , :remove
                (and (some? old-x) (some? new-x) (not (identical? old-x new-x)))
                  , :changed
                true :same
        |dissoc-idx $ %{} :CodeEntry (:doc |)
          :code $ quote
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
                true $ concat (take xs idx)
                  drop xs $ inc idx
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.util.list)
    |app.util.shortcuts $ %{} :FileEntry
      :defs $ {}
        |on-paste! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-paste! (d!)
              -> js/navigator .-clipboard (.readText)
                .!then $ fn (text) (println "\"read from text...")
                  let
                      cirru-code $ parse-cirru-list text
                    if (cirru-form? cirru-code)
                      d! :writer/paste $ first cirru-code
                      d! :notify/push-message $ [] :error "\"Not valid code"
                .!catch $ fn (error) (js/console.error "\"Not able to read from paste:" error)
                  d! :notify/push-message $ [] :error "\"Failed to paste!"
        |on-window-keydown $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn on-window-keydown (event dispatch! router)
              if (some? router)
                let
                    meta? $ or (.-metaKey event) (.-ctrlKey event)
                    shift? $ .-shiftKey event
                    code $ .-keyCode event
                  cond
                      and meta? $ or (= code keycode/p) (= code keycode/o)
                      do
                        dispatch! $ :: :router/change
                          {} $ :name :search
                        focus-search!
                        .!preventDefault event
                    (and meta? (= code keycode/e))
                      dispatch! $ :: :writer/edit-ns
                    (and meta? (not shift?) (= code keycode/j))
                      do (.!preventDefault event)
                        dispatch! $ :: :writer/move-next
                    (and meta? (not shift?) (= code keycode/i))
                      do $ dispatch! (:: :writer/move-previous)
                    (and meta? (= code keycode/k))
                      do $ dispatch! (:: :writer/finish)
                    (and meta? (= code keycode/s))
                      do (.!preventDefault event)
                        dispatch! $ :: :effect/save-files
                    (and meta? shift? (= code keycode/f))
                      dispatch! :router/change $ {} (:name :files)
                    (and meta? (not shift?) (= code keycode/period))
                      dispatch! $ :: :writer/picker-mode
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.util.shortcuts $ :require (app.keycode :as keycode)
            app.util.dom :refer $ focus-search!
            app.util.list :refer $ cirru-form?
    |app.util.stack $ %{} :FileEntry
      :defs $ {}
        |=bookmark? $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn =bookmark? (x y)
              and
                = (:kind x) (:kind y)
                = (:ns x) (:ns y)
                = (:extra x) (:extra y)
        |index-of-bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn index-of-bookmark (stack bookmark ? idx)
              if (empty? stack) -1 $ let
                  idx $ or idx 0
                if
                  =bookmark? bookmark $ first stack
                  , idx $ recur (rest stack) bookmark (inc idx)
        |push-bookmark $ %{} :CodeEntry (:doc |)
          :code $ quote
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
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.util.stack)
