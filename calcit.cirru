
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {}
    :client $ {} (:description |) (:init-fn 'app.client/main!) (:mode :js) (:reload-fn 'app.client/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |recollect/ |respo.calcit/ |respo-ui.calcit/ |respo-message.calcit/ |cumulo-util.calcit/ |ws-edn.calcit/ |respo-feather.calcit/ |alerts.calcit/ |respo-markdown.calcit/ |bisection-key/ |gen-code/ |js-ffi/
      :type-slots $ {} $ :dispatch-op 'app.schema/DispatchOp
    :default $ {} (:description |) (:init-fn 'app.server/main!) (:mode :js) (:reload-fn 'app.server/reload!) (:target :node)
      :feature-policy $ {}
      :modules $ [] |recollect/ |cumulo-util.calcit/ |ws-edn.calcit/ |bisection-key/ |respo-markdown.calcit/ |js-ffi/
      :type-slots $ {}
  :files $ {}
    'app.bookmark $ %{} 'FileEntry
      :defs $ {}
        '%bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def %bookmark
            impl-traits
              defenum %bookmark
                :def String String $ List String
                :ns String $ List String
              , BookmarkImpl
          :examples $ []
          :schema $ quote EnumDef
        'Bookmark $ %{} 'CodeEntry
          :doc "|Normalize an already local %bookmark value. Construct new local values with `%:: app.bookmark/%bookmark :def ns-text def-text focus` or the :ns variant. Serialized or anonymous input requires checked boundary conversion before this nominal API."
          :code $ quote $ defn Bookmark (b)
            match b
              (:def ns' def' f) (%:: %bookmark :def ns' def' f)
              (:ns ns' f) (%:: %bookmark :ns ns' f)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (-> app.bookmark/%bookmark)
        'BookmarkImpl $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defimpl BookmarkImpl BookmarkTrait
            .get-focus $ fn (self)
              hint-fn $ Fn app.bookmark/%bookmark $ -> (List String)
              match self
                (:def ns' def' f) f
                (:ns ns' f) f
            .get-ns $ fn (self)
              hint-fn $ Fn app.bookmark/%bookmark $ -> String
              match self
                (:def ns' def' f) ns'
                (:ns ns' f) ns'
            .is-ns? $ fn (self)
              hint-fn $ Fn app.bookmark/%bookmark $ -> Bool
              match self
                (:def _ns _def _f) false
                (:ns _ns _f) true
            .is-def? $ fn (self)
              hint-fn $ Fn app.bookmark/%bookmark $ -> Bool
              match self
                (:def _ns _def _f) true
                (:ns _ns _f) false
            .update-focus $ fn (self updater)
              hint-fn $ Fn app.bookmark/%bookmark
                Fn (List String)
                  -> $ List String
                -> app.bookmark/%bookmark
              match self
                (:def ns' def' f)
                  %:: %bookmark :def ns' def' $ updater f
                (:ns ns' f)
                  %:: %bookmark :ns ns' $ updater f
            .to-path $ fn (self)
              hint-fn $ Fn app.bookmark/%bookmark $ -> (List PathSegment)
              match self
                (:def ns' def' f)
                  ->
                    mapcat f $ fn (x)
                      hint-fn $ Fn String $ -> (List PathSegment)
                      [] :data x
                    prepend :code
                    prepend def'
                    prepend :defs
                    prepend ns'
                    prepend :files
                (:ns ns' f)
                  ->
                    mapcat f $ fn (x)
                      hint-fn $ Fn String $ -> (List PathSegment)
                      [] :data x
                    prepend :code
                    prepend :ns
                    prepend ns'
                    prepend :files
            .preview $ fn (self)
              hint-fn $ Fn app.bookmark/%bookmark $ -> String
              match self
                (:def ns' def' f) (str ns' |/ def')
                (:ns ns' f) (str ns' |/)
            .get-parent $ fn (self)
              hint-fn $ Fn app.bookmark/%bookmark $ -> (Option app.bookmark/%bookmark)
              match self
                (:def ns' def' f)
                  if (empty? f) None $ Some $ %:: %bookmark :def ns' def' (butlast f)
                (:ns ns' f)
                  if (empty? f) None $ Some $ %:: %bookmark :ns ns' (butlast f)
          :examples $ []
          :schema $ quote Impl
        'BookmarkTrait $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait BookmarkTrait
            .get-focus $ Fn app.bookmark/%bookmark $ -> (List String)
            .get-ns $ Fn app.bookmark/%bookmark $ -> String
            .is-ns? $ Fn app.bookmark/%bookmark $ -> Bool
            .is-def? $ Fn app.bookmark/%bookmark $ -> Bool
            .update-focus $ Fn app.bookmark/%bookmark
              Fn (List String)
                -> $ List String
              -> app.bookmark/%bookmark
            .to-path $ Fn app.bookmark/%bookmark $ -> (List app.bookmark/PathSegment)
            .preview $ Fn app.bookmark/%bookmark $ -> String
            .get-parent $ Fn app.bookmark/%bookmark $ -> (Option app.bookmark/%bookmark)
          :examples $ []
          :schema $ quote Trait
        'PathSegment $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion PathSegment Tag String
          :examples $ []
          :schema $ quote UnionDef
        'get-focus $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-focus (bookmark) (.get-focus bookmark)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark
            -> $ List String
        'get-namespace $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-namespace (bookmark) (.get-ns bookmark)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (-> String)
        'get-parent $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-parent (bookmark) (.get-parent bookmark)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark
            -> $ Option app.bookmark/%bookmark
        'preview $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn preview (bookmark) (.preview bookmark)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (-> String)
        'read-bookmark $ %{} 'CodeEntry
          :doc "|Checked wire recovery: treat incoming enum names/origins as data, check exact ns/def payload arity plus String fields and String focus paths, then construct the local %bookmark. This restores local methods without trusting serialized nominal identity."
          :code $ quote $ defn read-bookmark (raw)
            if (enum? raw)
              match raw
                (:ns namespace focus)
                  %:: %bookmark :ns (decode-map-as namespace 'String)
                    decode-map-as focus $ List String
                (:def namespace definition focus)
                  %:: %bookmark :def (decode-map-as namespace 'String) (decode-map-as definition 'String)
                    decode-map-as focus $ List String
                _ $ raise |Unknown-bookmark-wire-variant
              raise |Expected-bookmark-wire-enum
          :examples $ []
          :schema $ quote $ Fn Input (-> app.bookmark/%bookmark) (:generics Input)
        'read-bookmarks $ %{} 'CodeEntry
          :doc "|Check the incoming list once and recover each bookmark through read-bookmark; keep the existing wire shape while returning a closed local bookmark list."
          :code $ quote $ defn read-bookmarks (raw)
            map
              decode-map-as raw $ List Dynamic
              , read-bookmark
          :examples $ []
          :schema $ quote $ Fn Input
            -> $ List app.bookmark/%bookmark
            :generics Input
          :tests $ [] $ %{} 'TestEntry (:name |wire-recovery-keeps-local-bookmarks)
            :code $ quote $ let
                original $ []
                  %:: %bookmark :ns |demo.main $ []
                  %:: %bookmark :def |demo.main |keep $ [] |b "|中文"
                restored $ read-bookmarks $ parse-cirru-edn (format-cirru-edn original)
              assert= original restored
              assert= original $ read-bookmarks $ parse-cirru-edn "|[] (:: :ns |demo.main ([])) (:: :def |demo.main |keep ([] |b |中文))"
              assert= ([] |b "|中文")
                get-focus $ .unwrap $ last restored
            :tags $ #{} :unit
        'read-optional-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-optional-bookmark (raw)
            if (enum? raw)
              match raw
                (:some bookmark)
                  Some $ read-bookmark bookmark
                (:none) None
                _ $ raise |Expected-optional-bookmark
              raise |Expected-optional-bookmark
          :examples $ []
          :schema $ quote $ Fn Input
            -> $ Option app.bookmark/%bookmark
            :generics Input
        'to-path $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn to-path (bookmark) (.to-path bookmark)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark
            -> $ List PathSegment
          :tests $ [] $ %{} 'TestEntry (:name |typed-paths-focus-and-parent)
            :code $ quote $ let
                root $ %:: %bookmark :ns |demo.main $ []
                nested $ %:: %bookmark :def |demo.main |keep $ [] |a |b
              assert= ([] :files |demo.main :ns :code) (to-path root)
              assert=
                [] :files |demo.main :defs |keep :code :data |a :data |b
                to-path nested
              assert= None $ get-parent root
              assert= |demo.main $ .get-ns nested
              assert= true $ .is-ns? root
              assert= true $ .is-def? nested
              assert= |demo.main/keep $ preview nested
              match (get-parent nested)
                (:some parent)
                  do
                    assert= ([] |a) (get-focus parent)
                    assert= |demo.main/keep $ preview parent
                (:none) (raise |Expected-parent-bookmark)
              assert= ([] |a |b |c)
                get-focus $ update-focus nested $ fn (focus)
                  hint-fn $ Fn (List String)
                    -> $ List String
                  conj focus |c
            :tags $ #{} :unit
        'update-focus $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-focus (bookmark updater) (.update-focus bookmark updater)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark
            Fn (List String)
              -> $ List String
            -> app.bookmark/%bookmark
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.bookmark
    'app.client $ %{} 'FileEntry
      :defs $ {}
        '*connecting? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *connecting? false
          :examples $ []
          :schema $ quote $ Ref Bool
        '*states $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *states
            {} $ :states $ {}
              :cursor $ []
          :examples $ []
          :schema $ quote $ Ref (Map Tag Dynamic)
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store None
          :examples $ []
          :schema $ quote $ Ref
            Option $ Map Tag Dynamic
        'connect! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn connect! () (js/console.info |Connecting...) (reset! *connecting? true)
            ws-connect! (ws-host)
              {}
                :on-open $ fn (event) (simulate-login!) (detect-watching!) (heartbeat!)
                :on-close $ fn (event) (reset! *store None) (reset! *connecting? false) (js/console.error "|Lost connection!")
                  dispatch! $ app.client-updater/UiStateOp :states/clear
                :on-data $ fn (data)
                  match data
                    (:patch changes)
                      do
                        when config/dev? $ js/console.log |Changes changes
                        let
                            patches $ recollect.schema/decode-changes changes
                          match
                            match @*store
                              (:some current) (recollect.patch/try-patch-twig current patches)
                              (:none) (recollect.patch/try-patch-twig nil patches)
                            (:ok next)
                              do
                                reset! *store $ Some $ decode-map-as next (Map Tag Dynamic)
                                , &unit
                            (:err error)
                              do (eprintln |Rejected-Editor-patch: error) &unit
                    _ $ eprintln "|Unknown op:" data
                :class-mapper $ {} (:Expr schema/CirruExpr) (:Leaf schema/CirruLeaf)
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'detect-watching! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn detect-watching! ()
            match
              get (parse-query!) |watching
              (:none) &unit
              (:some raw)
                dispatch! $ app.updater.router/route-op $ app.updater.router/Route :watching (decode-map-as raw String)
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi :state)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when
              and config/dev? $ not= (&enum:nth op 0) :states
              js/console.info |Dispatch op
            match (updater/read-ui-state-op op)
              (:some action) (swap! *states updater/apply-ui-state action)
              (:none)
                do
                  when
                    contains? (#{} :effect/save-files :ir/indent :ir/unindent :ir/reset-files) (&enum:nth op 0)
                    reset! *states $ updater/clear-editor @*states
                  send-op! op
            , &unit
          :examples $ []
          :schema $ quote $ Fn AnyEnum (-> Unit) (:features :js-ffi :state) (:open :decode)
        'heartbeat! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn heartbeat! ()
            js/setTimeout
              fn () $ if (ws-connected?)
                do
                  ws-send! $ :: :ping
                  heartbeat!
                println "|Disabled heartbeat since connection lost."
              , 3000
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi)
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if config/dev? (load-console-formatter!) (disable-list-structure-check!)
            println "|Running mode:" $ if config/dev? |dev |release
            ; reset! *changes-logger $ fn (global-element element changes) (println |Changes: changes)
            render-app!
            connect!
            add-watch! *store :changes on-store-change!
            add-watch! *states :changes $ fn (states prev) (render-app!)
            js/window.addEventListener |keydown $ fn (event)
              match @*store
                (:some store)
                  on-window-keydown event dispatch! $ .unwrap-or (get store :router) ({})
                (:none) &unit
            js/window.addEventListener |focus $ fn (event) (retry-connect!)
            js/window.addEventListener |visibilitychange $ fn (_event)
              match (js-ffi.browser/visibility-state)
                (:visible)
                  do (retry-connect!) &unit
                _ &unit
            println "|App started!"
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn mount-target ()
            .query-selector (unsafe-coerce js/document 'respo.dom/DomDocument) |.app
          :examples $ []
          :schema $ quote $ Fn
            -> $ JsNullish respo.dom/DomElement
            :features :js-ffi
        'on-store-change! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-store-change! (store _previous) (render-app!)
            match store
              (:some fields)
                match (get fields :router)
                  (:some router)
                    when
                      and (enum? router)
                        = :editor $ decode-map-as (&enum:nth router 0) Tag
                      focus!
                  (:none) &unit
              (:none) &unit
            , &unit
          :examples $ []
          :schema $ quote $ Fn
            Option $ Map Tag Dynamic
            Option $ Map Tag Dynamic
            -> Unit
            :features :io :js-ffi :state
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (clear-cache!) (render-app!) (remove-watch! *states :changes) (remove-watch! *store :changes)
                add-watch! *states :changes $ fn (states prev) (render-app!)
                add-watch! *store :changes on-store-change!
                println "|Code updated."
                tip! |ok~ nil
              tip! |error build-errors
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            respo.core/render-with! (mount-target)
              fn ()
                hint-fn $ Fn $ -> respo.schema/Component
                comp-container @*states @*store
              , dispatch!
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'retry-connect! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn retry-connect! ()
            if
              and (.none? @*store) (not @*connecting?)
              connect!
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'send-op! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn send-op! (op) (ws-send! op)
          :examples $ []
          :schema $ quote $ Fn AnyEnum (-> Unit) (:open :reflect)
        'simulate-login! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn simulate-login! ()
            let
                key $ :storage-key config/site
              match (js-ffi.browser/storage-get key)
                (:some raw)
                  dispatch! $ :: :user/log-in $ parse-cirru-edn raw
                (:none) (println "|Found no storage.")
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
      :ns $ %{} 'NsEntry (:doc "|browser side main file")
        :code $ quote $ ns app.client
          :require
            respo.core :refer $ render! clear-cache! *changes-logger
            app.comp.container :refer $ comp-container
            app.client-util :refer $ ws-host parse-query!
            app.util.dom :refer $ focus!
            app.util.shortcuts :refer $ on-window-keydown
            app.client-updater :as updater
            ws-edn.client :refer $ ws-connect! ws-send! ws-connected?
            recollect.patch :refer $ patch-twig
            app.config :as config
            |bottom-tip :default tip!
            |./calcit.build-errors :default build-errors
            app.schema :as schema
            |@calcit/procs :refer $ disable-list-structure-check!
    'app.client-updater $ %{} 'FileEntry
      :defs $ {}
        'UiStateOp $ %{} 'CodeEntry
          :doc "|Local Respo state changes. Widget data stays open, while cursor keys and merge patch structure are checked."
          :code $ quote $ defenum UiStateOp
            :states (List respo.schema/CoordKey) Dynamic
            :states-merge (List respo.schema/CoordKey) Dynamic $ Map Tag Dynamic
            :states/clear
            :manual-state/abstract
            :manual-state/draft-box
          :examples $ []
          :schema $ quote EnumDef
        'abstract $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn abstract (states)
            assoc-in states ([] :editor :data :abstract?) true
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
        'apply-ui-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn apply-ui-state (states op)
            match op
              (:states cursor value)
                decode-map-as
                  assoc-in states (conj cursor :data) value
                  Map Tag Dynamic
              (:states-merge cursor initial changes)
                decode-map-as
                  .unwrap-or
                    get
                      respo.cursor/update-states-merge (&{} :states states) cursor initial changes
                      , :states
                    {}
                  Map Tag Dynamic
              (:states/clear)
                {} $ :states $ {}
                  :cursor $ []
              (:manual-state/abstract) (abstract states)
              (:manual-state/draft-box) (draft-box states)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) UiStateOp
            -> $ Map Tag Dynamic
        'clear-editor $ %{} 'CodeEntry
          :doc "|Clear per-bookmark String/Number state branches after checking the actual CoordKey map. Preserve Tag-scoped editor/plugin payloads, including false; absent editor scope is a no-op."
          :code $ quote $ defn clear-editor (states)
            match (app.schema/map-field states :editor)
              (:none) states
              (:some raw-scope)
                let
                    scope $ decode-map-as raw-scope $ Map respo.schema/CoordKey Dynamic
                    kept $ filter-map-kv scope $ fn (key value)
                      hint-fn $ Fn respo.schema/CoordKey Dynamic $ -> (MapEntryDecision respo.schema/CoordKey Dynamic)
                      match key
                        (Tag tag) (MapEntryDecision :keep tag value)
                        (String _name) (MapEntryDecision :drop)
                        (Number _index) (MapEntryDecision :drop)
                  assoc states :editor kept
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |mixed-key-editor-reset)
            :code $ quote $ do
              let
                  states $ {}
                    :editor $ {} (:data false)
                      :plugin $ {} $ :kept true
                      |demo.main/old $ {} $ :data |draft
                      2 $ {} $ :data |numeric
                    :other |kept
                assert=
                  {}
                    :editor $ {} (:data false)
                      :plugin $ {} $ :kept true
                    :other |kept
                  clear-editor states
              let
                  states $ {} $ :other |untouched
                assert= states $ clear-editor states
            :tags $ #{} :unit
        'dispatch-ui! $ %{} 'CodeEntry
          :doc "|Send a typed client-state operation through the Respo dispatcher, which also accepts legacy wire events."
          :code $ quote $ defn dispatch-ui! (dispatch! op) (dispatch! op)
          :examples $ []
          :schema $ quote $ Fn
            Fn AnyEnum $ -> Unit
            , UiStateOp (-> Unit) (:open :decode)
        'draft-box $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn draft-box (states)
            assoc-in states ([] :editor :data :draft-box?) true
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
        'read-ui-state-op $ %{} 'CodeEntry
          :doc "|Adapt the anonymous state events still emitted by Respo plugins."
          :code $ quote $ defn read-ui-state-op (op)
            if (enum? op)
              if
                = (enum-definition op) (Some UiStateOp)
                Some $ decode-map-as op 'app.client-updater/UiStateOp
                match op
                  (:states cursor value)
                    Some $ UiStateOp :states
                      decode-map-as cursor $ List respo.schema/CoordKey
                      , value
                  (:states-merge cursor initial changes)
                    Some $ UiStateOp :states-merge
                      decode-map-as cursor $ List respo.schema/CoordKey
                      , initial $ decode-map-as changes (Map Tag Dynamic)
                  (:states/clear)
                    Some $ UiStateOp :states/clear
                  (:manual-state/abstract)
                    Some $ UiStateOp :manual-state/abstract
                  (:manual-state/draft-box)
                    Some $ UiStateOp :manual-state/draft-box
                  _ None
              , None
          :examples $ []
          :schema $ quote $ Fn Input
            -> $ Option UiStateOp
            :generics Input
            :open :decode
          :tests $ [] $ %{} 'TestEntry (:name |typed-state-and-legacy-plugin)
            :code $ quote $ let
                cursor $ [] :panel 2
                action $ UiStateOp :states cursor $ {} (:keep? false) (:text |old)
                updated $ apply-ui-state ({}) action
                merged $ apply-ui-state updated $ UiStateOp :states-merge cursor ({})
                  {} $ :text |next
              assert= (Some action) (read-ui-state-op action)
              assert= (Some action)
                read-ui-state-op $ :: :states cursor $ {} (:keep? false) (:text |old)
              assert=
                Result :ok $ {} (:keep? false) (:text |next)
                get-in merged $ [] :panel 2 :data
              assert= None $ read-ui-state-op $ :: :writer/finish
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.client-updater
    'app.client-util $ %{} 'FileEntry
      :defs $ {}
        'UrlParseResultHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait UrlParseResultHost (:query 'Dynamic)
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :query |query
          :schema $ quote Trait
        'coord-contains? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn coord-contains? (xs ys)
            if (empty? ys) true $ if (empty? xs) false $ if
              = (first xs) (first ys)
              recur (rest xs) (rest ys)
              , false
          :examples $ []
          :schema $ quote $ Fn (List T) (List T) (-> Bool) (:generics T)
        'expr-many-items? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expr-many-items? (node size)
            match node
              (app.schema/CirruLeafShape _leaf) false
              (app.schema/CirruExprShape expr)
                or
                  >
                    .len $ :data expr
                    , size
                  any?
                    distinct-values $ :data expr
                    fn (child)
                      hint-fn $ Fn schema/CirruNode $ -> Bool
                      match child
                        (app.schema/CirruLeafShape _child) false
                        (app.schema/CirruExprShape _child) true
          :examples $ []
          :schema $ quote $ Fn schema/CirruNode Number (-> Bool)
        'expr? $ %{} 'CodeEntry
          :doc "|a function to detect expression,\nan expression is represented with a record with `CirruExpr`\n"
          :code $ quote $ defn expr? (x)
            and (struct? x)
              = :Expr $ &struct:get-name x
          :examples $ []
          :schema $ quote $ Fn Input (-> Bool) (:generics Input)
        'leaf? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn leaf? (x)
            and (struct? x) (&struct:matches? x schema/CirruLeafShape)
          :examples $ []
          :schema $ quote $ Fn Input (-> Bool) (:generics Input)
        'parse-query! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-query! ()
            let
                url-obj $ unsafe-coerce
                  url-parse (location-href) true
                  , 'app.client-util/UrlParseResultHost
              to-calcit-data $ url-obj :query
          :examples $ []
          :schema $ quote $ Fn (-> Dynamic) (:features :js-ffi)
        'ws-host $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn ws-host ()
            if
              and (js-present? js/location)
                not $ blank? $
                  unsafe-coerce js/location 'js-ffi.browser/LocationHost
                  , :search
              let
                  query $ parse-query!
                println "|Loading from url" query
                str |ws://
                  .unwrap-or (get query |host) |localhost
                  , |: $ .unwrap-or (get query |port)
                    .unwrap-or (get schema/configs :port) 6001
              , |ws://localhost:6001
          :examples $ []
          :schema $ quote $ Fn (-> String) (:features :io :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.client-util
          :require (app.config :as config) (|url-parse :default url-parse) (app.schema :as schema)
            js-ffi.browser :refer $ location-href
    'app.comp.about $ %{} 'FileEntry
      :defs $ {}
        'comp-about $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-about ()
            div
              {} $ :class-name $ str-spaced css/global css/fullscreen css/column
              div
                {} $ :class-name $ str-spaced css/flex css/center
                img $ {} (:src |//cdn.tiye.me/logo/cirru.png)
                  :style $ {} (:width 64) (:height 64) (:border-radius |8px)
                =< nil 16
                <> "|No connection to server..." $ {} (:font-family "|Josefin Sans") (:font-weight 300) (:font-size 24)
                  :color $ hsl 0 80 60
                div
                  {} $ :style $ {}
                    :color $ hsl 0 0 80
                  <> "|Get editor server running with:"
                  pre $ {} (:innerHTML install-commands) (:class-name |copy-commands)
                    :style $ {} (:cursor :pointer) (:padding "|0 8px")
                    :title "|Click to copy."
                    :on-click $ fn (e d!)
                      copy-silently! $ &str:replace install-commands "|$ " |
              div
                {} (:class-name css/center)
                  :style $ {} (:padding "|8px 8px")
                    :color $ hsl 0 0 50
                comp-md-block "|Calcit Editor is a syntax tree editor of [Cirru Project](http://cirru.org). Read more at [Calcit Editor](https://github.com/calcit-lang/editor).\n" $ {}
          :examples $ []
          :schema $ quote $ Fn (-> respo.schema/Component) (:features :io)
        'install-commands $ %{} 'CodeEntry (:doc "|copy the commands to use")
          :code $ quote $ def install-commands "|$ npm install -g @calcit/editor\n$ ct\n"
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.about
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp <> span div pre input button img a br
            respo.css :refer $ defstyle
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            respo-md.comp.md :refer $ comp-md-block
            app.util.dom :refer $ copy-silently!
    'app.comp.abstract $ %{} 'FileEntry
      :defs $ {} $ 'comp-abstract
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-abstract (states close-modal!)
            comp-modal close-modal! $ let
                cursor $ decode-map-as
                  .unwrap-or (app.schema/map-field states :cursor) ([])
                  List respo.schema/CoordKey
                state $ .unwrap-or
                  app.schema/read-optional-text $ app.schema/map-field states :data
                  , |
                submit! $ fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  when
                    not $ blank? state
                    d! $ :: :analyze/abstract-def state
                    app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor nil
                    close-modal! d!
                  , &unit
              div ({})
                input $ {}
                  :class-name $ str-spaced style/input |el-abstract
                  :value state
                  :on-input $ fn (event d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ respo.core/event-value event
                  :on-keydown $ fn (event d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    match
                      :key $ respo.core/keyboard-info event
                      |Enter $ submit! d!
                      |Escape $ close-modal! d!
                      _ &unit
                =< nil 8
                button $ {} (:class-name style/button) (:inner-text |Submit)
                  :on-click $ fn (_event d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    submit! d!
          :examples $ []
          :schema $ quote $ Fn respo.schema/States
            Fn
              Fn *dispatch-op $ -> Unit
              -> Unit
            -> respo.schema/Component
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.abstract
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            app.comp.modal :refer $ comp-modal
            app.keycode :as keycode
    'app.comp.bookmark $ %{} 'FileEntry
      :defs $ {}
        'DataTransferHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait DataTransferHost
            .set-data! $ Fn app.comp.bookmark/DataTransferHost String String $ -> Unit
            .get-data $ Fn app.comp.bookmark/DataTransferHost String $ -> String
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:get-data |getData) (:set-data! |setData)
          :schema $ quote Trait
        'DragEventHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait DragEventHost (:data-transfer 'app.comp.bookmark/DataTransferHost)
            .prevent-default! $ Fn app.comp.bookmark/DragEventHost $ -> Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:data-transfer |dataTransfer) (:prevent-default! |preventDefault)
          :schema $ quote Trait
        'comp-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-bookmark (bookmark idx selected?)
            div
              {}
                :class-name $ str |stack-bookmark $ if selected? "| selected-bookmark" |
                :draggable true
                :on-click $ on-pick bookmark idx
                :on-dragstart $ fn (e d!)
                  hint-fn $ Fn respo.schema/RespoEvent
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  drag-set-data! (:event e) idx
                :on-drop $ fn (e d!)
                  hint-fn $ Fn respo.schema/RespoEvent
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  match
                    drag-get-index $ :event e
                    (:some target-idx)
                      if (not= target-idx idx)
                        d! $ :: :writer/move-order $ {} (:from target-idx) (:to idx)
                        , &unit
                    (:none) &unit
                :on-dragover $ fn (e d!)
                  hint-fn $ Fn respo.schema/RespoEvent
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  drag-prevent-default! $ :event e
              match bookmark
                (:ns the-ns focus)
                  div
                    {} (:class-name css-bookmark)
                      :style $ {} $ :padding |8px
                    <> |ns style-kind
                    span $ {} (:inner-text the-ns)
                      :class-name $ str-spaced css/font-normal
                      :style $ if selected? style-highlight $ {}
                (:def the-ns the-def focus)
                  div
                    {} $ :class-name css-bookmark
                    div ({})
                      span $ {} (:inner-text the-def)
                        :class-name $ str-spaced css/font-normal
                        :style $ if selected? style-highlight $ {}
                    div
                      {} $ :class-name css/row-middle
                      =< 4 nil
                      <> the-ns style-minor
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark Number Bool (-> respo.schema/Component) (:features :js-ffi)
        'css-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-bookmark
            {} $ |$0 $ {} (:line-height |1.2em) (:padding "|4px 8px") (:cursor :pointer) (:position :relative)
              :color $ hsl 0 0 70
              :white-space :nowrap
          :examples $ []
          :schema $ quote String
        'drag-get-index $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn drag-get-index (raw-event)
            let
                event $ js-cast raw-event 'app.comp.bookmark/DragEventHost
                transfer $ .-data-transfer event
              match
                parse-float $ .get-data transfer |id
                (:ok index)
                  if
                    and (integer? index) (>= index 0)
                    Some index
                    , None
                (:err _message) None
          :examples $ []
          :schema $ quote $ Fn respo.dom/DomEvent
            -> $ Option Number
            :features :js-ffi
        'drag-prevent-default! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn drag-prevent-default! (raw-event) (.prevent-default! raw-event) &unit
          :examples $ []
          :schema $ quote $ Fn respo.dom/DomEvent (-> Unit) (:features :js-ffi)
        'drag-set-data! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn drag-set-data! (raw-event idx)
            let
                event $ js-cast raw-event 'app.comp.bookmark/DragEventHost
                transfer $ .-data-transfer event
              .set-data! transfer |id $ str idx
              , &unit
          :examples $ []
          :schema $ quote $ Fn respo.dom/DomEvent Number (-> Unit) (:features :js-ffi)
        'on-pick $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-pick (bookmark idx)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              let
                  event $ js-ffi.browser/mouse-event-host $ :original-event e
                  meta? $ .-meta-key? event
                  alt? $ .-alt-key? event
                cond
                  meta? $ d! $ :: :writer/collapse idx
                  alt? $ d! $ :: :writer/remove-idx idx
                  true $ d! $ :: :writer/point-to idx
              , &unit
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark Number (-> respo.schema/EventHandler) (:features :js-ffi)
        'style-highlight $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-highlight
            {} $ :color $ hsl 0 0 100
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-kind $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-kind
            {}
              :color $ hsl 340 80 60
              :font-family ui/font-normal
              :font-size 12
              :margin-right 4
              :vertical-align :middle
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-main $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-main
            {} $ |& $ {} (:vertical-align :middle)
              :color $ hsl 0 0 70
          :examples $ []
          :schema $ quote String
        'style-minor $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-minor
            {} $ |& $ {}
              :color $ hsl 0 0 40
              :font-size 12
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.bookmark
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp <> span div a
            respo.comp.space :refer $ =<
    'app.comp.changed-files $ %{} 'FileEntry
      :defs $ {}
        'comp-changed-files $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-changed-files (states changed-files)
            div
              {} $ :class-name style-column
              <> |Changes style/title
              respo.core/data-list-> ({})
                -> changed-files (&map:to-list)
                  map $ fn (pair)
                    hint-fn $ Fn (Tuple String Dynamic)
                      -> $ Tuple String respo.schema/Component
                    let[] (k info) pair $ [] k $ comp-changed-info (app.comp.changed-info/read-change-info info) (assert-type k String)
              if (empty? changed-files)
                div
                  {} $ :class-name $ str-spaced css/font-fancy style-nothing
                  <> "|No changes"
                div ({})
                  a $ {} (:inner-text |Save) (:class-name style/button)
                    :on-click $ fn (e d!)
                      d! $ :: :effect/save-files
                  a $ {} (:inner-text |Reset) (:class-name style/button)
                    :on-click $ fn (e d!)
                      d! $ :: :ir/reset-files
                      d! $ app.client-updater/UiStateOp :states/clear
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Map String Dynamic) (-> respo.schema/Component)
        'style-column $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-column
            {} $ |& $ {} (:overflow :auto) (:padding-top 24) (:padding-bottom 120)
          :examples $ []
          :schema $ quote String
        'style-nothing $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nothing
            {} $ |& $ {}
              :color $ hsl 0 0 100 0.5
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.changed-files
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp list-> <> span div pre input button a
            respo.comp.space :refer $ =<
            app.client-util :as util
            app.style :as style
            app.comp.changed-info :refer $ comp-changed-info
    'app.comp.changed-info $ %{} 'FileEntry
      :defs $ {}
        'ChangeInfo $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def ChangeInfo
            defstruct :ChangeInfo (:ns Tag)
              :defs $ Map String Tag
          :examples $ []
          :schema $ quote StructDef
        'ChangeKind $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion ChangeKind Tag String
          :examples $ []
          :schema $ quote UnionDef
        'change-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn change-label (kind)
            match kind
              (String name) name
              (Tag namespace-kind)
                if (= namespace-kind :ns) |ns $ raise |Unknown-change-kind
          :examples $ []
          :schema $ quote $ Fn ChangeKind (-> String)
        'comp-changed-info $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-changed-info (info ns-text)
            div
              {} $ :style style-info
              div ({}) (<> ns-text) (=< 8 nil)
                span
                  {} $ :class-name |is-minor
                  comp-icon :corner-up-left style-reset $ fn (e d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    d! $ :: :ir/reset-ns ns-text
                    app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states/clear
                =< 24 nil
                respo.core/show
                  not= :same $ :ns info
                  render-status ns-text :ns $ :ns info
              div
                {} (:class-name css/row-parted)
                  :style $ {} $ :align-items :flex-end
                respo.core/data-list->
                  {} $ :style style-defs
                  map
                    &map:to-list $ :defs info
                    fn (entry)
                      hint-fn $ Fn (Tuple String Tag)
                        -> $ Tuple String respo.schema/Element
                      let[] (name status) entry $ [] name $ div ({}) (render-status ns-text name status)
                div ({})
                  comp-icon :save style-reset $ fn (e d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    d! $ :: :effect/save-ns ns-text
          :examples $ []
          :schema $ quote $ Fn ChangeInfo String (-> respo.schema/Component)
        'on-preview $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-preview (ns-text kind status)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              match kind
                (Tag namespace-kind)
                  if (= namespace-kind :ns)
                    d! $ :: :writer/select $ :: :ns ns-text
                    raise |Unknown-change-kind
                (String name)
                  d! $ :: :writer/select $ :: :def ns-text name
          :examples $ []
          :schema $ quote $ Fn String ChangeKind Tag (-> respo.schema/EventHandler)
        'on-reset-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-reset-def (ns-text kind)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              match kind
                (Tag namespace-kind)
                  if (= namespace-kind :ns)
                    d! $ :: :ir/reset-at $ :: :ns ns-text
                    raise |Unknown-change-kind
                (String name)
                  d! $ :: :ir/reset-at $ :: :def ns-text name
              app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states/clear
          :examples $ []
          :schema $ quote $ Fn String ChangeKind (-> respo.schema/EventHandler)
        'read-change-info $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-change-info (raw)
            let
                fields $ decode-map-as raw $ Map Tag Dynamic
              %{} ChangeInfo
                :ns $ decode-map-as
                  .unwrap-or (get fields :ns) :same
                  , 'Tag
                :defs $ decode-map-as
                  .unwrap-or (get fields :defs) ({})
                  Map String Tag
          :examples $ []
          :schema $ quote $ Fn Input (-> ChangeInfo) (:generics Input)
          :tests $ [] $ %{} 'TestEntry (:name |wire-changes-and-kind-union)
            :code $ quote $ let
                source $ {} (:ns :changed)
                  :defs $ {} (|keep :added) ("|中文🐈" :removed)
                info $ read-change-info $ parse-cirru-edn (format-cirru-edn source)
              assert= :changed $ :ns info
              assert=
                {} (|keep :added) ("|中文🐈" :removed)
                :defs info
              assert= |ns $ change-label :ns
              assert= "|中文🐈" $ change-label "|中文🐈"
              assert= :same $ :ns $ read-change-info ({})
              assert= ({})
                :defs $ read-change-info $ {}
            :tags $ #{} :unit
        'render-status $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-status (ns-text kind status)
            span
              {} (:style style-status-card)
                :title $ str "|Browse " $ change-label kind
                :on-click $ on-preview ns-text kind status
              <> $ change-label kind
              =< 8 nil
              <> (to-string status) style-status
              =< 4 nil
              span
                {} $ :class-name |is-minor
                comp-icon :corner-up-left style-reset $ on-reset-def ns-text kind
          :examples $ []
          :schema $ quote $ Fn String ChangeKind Tag (-> respo.schema/Element)
        'style-defs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-defs
            {} $ :padding-left 16
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-info $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-info
            {}
              :background-color $ hsl 0 0 100 0.1
              :padding 8
              :margin-bottom 8
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-reset $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-reset
            {} (:text-decoration :underline) (:font-size 12)
              :color $ hsl 220 60 80 0.6
              :cursor :pointer
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-status $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-status
            {} (:font-size 12) (:font-family "|Josefin Sans")
              :color $ hsl 160 70 40
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-status-card $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-status-card
            {} $ :cursor :pointer
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.changed-info
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp list-> >> <> span div pre input button a
            respo.comp.space :refer $ =<
            app.style :as style
            feather.core :refer $ comp-icon
    'app.comp.configs $ %{} 'FileEntry
      :defs $ {}
        'comp-configs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-configs (states configs entries)
            let
                version $ config-text configs :version
                modules $ decode-map-as
                  .unwrap-or (get configs :modules) ([])
                  List String
                modules-plugin $ use-prompt (>> states :modules)
                  {} (:text "|编辑 modules（空格或换行分隔）") (:placeholder |module/calcit.cirru) (:input-class css/font-code) (:multiline? true)
                    :initial $ join-string modules &newline
                init-fn-plugin $ use-prompt (>> states :init-fn)
                  {} (:text "|Set init-fn:")
                    :initial $ config-text configs :init-fn
                    :input-class css/font-code
                reload-fn-plugin $ use-prompt (>> states :reload-fn)
                  {} (:text "|Set reload-fn:")
                    :initial $ config-text configs :reload-fn
                    :input-class css/font-code
              div
                {}
                  :class-name $ str-spaced css/expand css/column
                  :style $ {} $ :padding "|40px 16px 0 16px"
                =< nil 8
                div ({}) (render-label "|版本（deps.cirru）:") (=< 8 nil)
                  <>
                    if (blank? version) "|未声明" version
                    , css/font-code
                  =< 16 nil
                  <> "|通过 caps version set 更新版本" css/font-code
                div
                  {} $ :class-name css/row
                  render-label |Modules:
                  =< 8 nil
                  span
                    {} $ :on-click $ fn (event dispatch!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show modules-plugin dispatch! $ fn (raw)
                        hint-fn $ Fn Dynamic $ -> Unit
                        dispatch! $ :: :configs/update $ {}
                          :modules $ parse-modules $ decode-map-as raw 'String
                        , &unit
                      , &unit
                    render-field $ join-string modules "| "
                div ({}) (render-label |init-fn:) (=< 8 nil)
                  span
                    {} $ :on-click $ fn (event dispatch!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show init-fn-plugin dispatch! $ fn (raw)
                        hint-fn $ Fn Dynamic $ -> Unit
                        dispatch! $ :: :configs/update $ {}
                          :init-fn $ decode-map-as raw 'String
                        , &unit
                      , &unit
                    render-field $ config-text configs :init-fn
                div ({}) (render-label |reload-fn:) (=< 8 nil)
                  span
                    {} $ :on-click $ fn (event dispatch!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show reload-fn-plugin dispatch! $ fn (raw)
                        hint-fn $ Fn Dynamic $ -> Unit
                        dispatch! $ :: :configs/update $ {}
                          :reload-fn $ decode-map-as raw 'String
                        , &unit
                      , &unit
                    render-field $ config-text configs :reload-fn
                pre
                  {} $ :style $ {} (:max-width |100%) (:overflow :auto)
                    :color $ hsl 0 0 60
                  code $ {} $ :inner-text (format-cirru-edn configs)
                comp-entries states entries
                .render modules-plugin
                .render init-fn-plugin
                .render reload-fn-plugin
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Map Tag Dynamic)
            Map String $ Map Tag Dynamic
            -> respo.schema/Component
            :features :js-ffi
        'comp-entries $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-entries (states entries)
            let
                plugin $ use-prompt (>> states :entries-code)
                  {} (:text "|编辑命名入口（已有入口未展示的元数据会保留）")
                    :initial $ format-cirru-edn entries
                    :placeholder "|{} ..."
                    :input-style $ {} $ :font-family ui/font-code
                    :multiline? true
              div ({})
                pre $ {}
                  :style $ {} (:max-width |100%) (:overflow :auto)
                    :color $ hsl 0 0 60
                  :inner-text $ format-cirru-edn entries
                button $ {} (:class-name style/button) (:inner-text |Edit)
                  :on-click $ fn (event dispatch!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    .show plugin dispatch! $ fn (raw)
                      hint-fn $ Fn Dynamic $ -> Unit
                      dispatch! $ :: :configs/update-entries $ [] :reset
                        parse-cirru-edn $ decode-map-as raw 'String
                      , &unit
                    , &unit
                .render plugin
          :examples $ []
          :schema $ quote $ Fn respo.schema/States
            Map String $ Map Tag Dynamic
            -> respo.schema/Component
            :features :js-ffi
        'config-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn config-text (configs key)
            .unwrap-or
              app.schema/read-optional-text $ get configs key
              , |
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Tag (-> String)
        'parse-modules $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-modules (text)
            filter-not
              mapcat (split-lines text)
                fn (line)
                  hint-fn $ Fn String $ -> (List String)
                  map
                    split (&str:replace line "|\t" "| ") "| "
                    , trim
              , blank?
          :examples $ []
          :schema $ quote $ Fn String
            -> $ List String
          :tests $ [] $ %{} 'TestEntry (:name |module-lines-and-whitespace)
            :code $ quote $ assert= ([] |one/ |two/ |three/) (parse-modules "|  one/\n two/\tthree/\n")
            :tags $ #{} :unit
        'render-field $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-field (value)
            <>
              if (blank? value) |- value
              str-spaced css/font-code style-value
          :examples $ []
          :schema $ quote $ Fn String (-> respo.schema/Element)
        'render-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-label (title) (<> title css/font-fancy)
          :examples $ []
          :schema $ quote $ Fn String (-> respo.schema/Element)
        'style-value $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-value
            {} $ |& $ {} (:cursor :pointer)
              :color $ hsl 200 90 80
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.configs
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp >> <> span div a pre code button
            respo.comp.space :refer $ =<
            cirru-edn.core :as cirru-edn
            respo-alerts.core :refer $ use-prompt
            app.style :as style
            respo.css :refer $ defstyle
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc "|respo UI main entry")
          :code $ quote $ defcomp comp-container (states maybe-store)
            match maybe-store
              (:none) (comp-about)
              (:some store)
                let
                    state $ .unwrap-or (app.schema/map-field states :data) {}
                    session $ .unwrap-or (get store :session) {}
                    writer $ .unwrap-or (get session :writer) {}
                    router $ match (get store :router)
                      (:none) (:: :login)
                      (:some value)
                        if (nil? value) (:: :login)
                          if (enum? value) value $ raise "|Expected an editor route enum"
                    theme $ match
                      get-in store $ [] :user :theme
                      (:ok value) (app.comp.theme-menu/read-theme value)
                      (:err error)
                        match error
                          (:missing) None
                          (:shape message) (raise message)
                    picker-mode? $ .some? $ get writer :picker-mode
                  div
                    {} $ :class-name $ str-spaced css/global css/fullscreen css/column style-container
                    if (not picker-mode?)
                      Some $ comp-header (>> states :header)
                        decode-map-as (&enum:nth router 0) Tag
                        decode-map-as
                          .unwrap-or (get store :logged-in?) false
                          , Bool
                        decode-map-as
                          .unwrap-or (get store :stats) ({})
                          Map Tag Dynamic
                      , None
                    div
                      {} $ :class-name $ str-spaced css/row css/expand
                      if
                        .unwrap-or (get store :logged-in?) false
                        match router
                          (:profile d)
                            comp-profile (>> states :profile)
                              decode-map-as
                                .unwrap-or (get store :user) {}
                                Map Tag Dynamic
                              decode-map-as
                                .unwrap $ get session :id
                                , String
                              decode-map-as d $ Map Tag Dynamic
                          (:files d)
                            comp-page-files (>> states :files)
                              app.schema/read-optional-text $ get writer :selected-ns
                              decode-map-as d $ Map Tag Dynamic
                          (:graph d)
                            let
                                fields $ decode-map-as d $ Map Tag Dynamic
                              comp-deps-graph (>> states :graph)
                                decode-map-as
                                  .unwrap-or (get fields :package) |
                                  , String
                                decode-map-as
                                  .unwrap-or (get fields :configs) ({})
                                  Map Tag Dynamic
                                decode-map-as
                                  .unwrap-or (get fields :entries) ({})
                                  Map String Dynamic
                                app.schema/read-dependency-map $ .unwrap-or (get fields :deps-dict) ({})
                                decode-map-as
                                  .unwrap-or (get fields :writer) ({})
                                  Map Tag Dynamic
                          (:editor d)
                            comp-page-editor (>> states :editor)
                              app.bookmark/read-bookmarks $ .unwrap-or (get writer :stack) []
                              decode-map-as d $ Map Tag Dynamic
                              decode-map-as
                                .unwrap-or (get writer :pointer) 0
                                , Number
                              , picker-mode? theme
                          (:search d)
                            comp-search (>> states :search) (app.bookmark/read-bookmarks d)
                          (:watching d)
                            comp-watching (>> states :watching) (app.comp.watching/read-watching-frame d)
                              app.comp.theme-menu/read-theme $ .unwrap-or (get session :theme) :star-trail
                          (:configs d)
                            comp-configs (>> states :configs)
                              decode-map-as
                                .unwrap-or (get d :configs) {}
                                Map Tag Dynamic
                              decode-map-as
                                .unwrap-or (get d :entries) {}
                                Map String $ Map Tag Dynamic
                          _ $ div ({})
                            <> $ str "|404 page: " $ to-lispy-string router
                        match router
                          (:watching d)
                            comp-watching (>> states :watching) (app.comp.watching/read-watching-frame d)
                              app.comp.theme-menu/read-theme $ .unwrap-or (get session :theme) :star-trail
                          _ $ comp-login $ >> states :login
                    if dev?
                      Some $ comp-inspect |Session store style-inspector
                      , None
                    ; when dev? $ comp-inspect "|Router data" states $ merge style-inspector
                      {} $ :left 100
                    comp-messages $ decode-map-as
                      .unwrap-or (get session :notifications) ([])
                      List $ Map Tag app.schema/NotificationField
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            Option $ Map Tag Dynamic
            -> respo.schema/Component
            :features :io
        'style-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-container
            {} $ |& $ {} (:background-color :black) (:color :white)
          :examples $ []
          :schema $ quote String
        'style-inspector $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-inspector
            {} (:bottom 40) (:left 0) (:max-width |100%)
              :background-color $ hsl 0 0 50
              :color :black
              :opacity 1
              :z-index 100
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
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
            app.comp.about :as about
            app.comp.graph :refer $ comp-deps-graph
    'app.comp.draft-box $ %{} 'FileEntry
      :defs $ {}
        'comp-draft-box $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-draft-box (states expr focus close-modal!)
            let
                cursor $ respo.core/state-cursor states
                close! $ fn (dispatch!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  app.client-updater/dispatch-ui! dispatch! $ app.client-updater/UiStateOp :states cursor nil
                  close-modal! dispatch!
                  , &unit
              comp-modal close! $ match (app.schema/node-at-path expr focus)
                (:none)
                  span $ {} (:class-name css-wrong) (:inner-text "|The selected source node no longer exists.")
                    :on-click $ fn (_event dispatch!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      close! dispatch!
                (:some node)
                  let
                      expression? $ match node
                        (app.schema/CirruExprShape _expr) true
                        (app.schema/CirruLeafShape _leaf) false
                      state $ read-draft-state states node
                    div
                      {} $ :class-name css/column
                      div
                        {} $ :style style-original
                        if expression? (<> "|Cirru Mode" style-mode)
                          textarea $ {} (:spellcheck false) (:class-name css-text)
                            :value $ draft-text node
                      =< nil 8
                      textarea $ {}
                        :class-name $ str-spaced |el-draft-box css-draft-area
                        :value state
                        :on-input $ fn (event dispatch!)
                          hint-fn $ Fn respo.schema/RespoEvent
                            Fn *dispatch-op $ -> Unit
                            -> Unit
                          app.client-updater/dispatch-ui! dispatch! $ app.client-updater/UiStateOp :states cursor $ respo.core/event-value event
                          , &unit
                        :on-keydown $ fn (event dispatch!)
                          hint-fn $ Fn respo.schema/RespoEvent
                            Fn *dispatch-op $ -> Unit
                            -> Unit
                          let
                              keyboard $ respo.core/keyboard-info event
                              key $ :key keyboard
                            cond
                                = key |Escape
                                close! dispatch!
                              (and (:meta? keyboard) (or (= key |s) (= key |S)))
                                do
                                  .prevent-default! $ :event event
                                  submit-draft! expression? state cursor close-modal! true dispatch!
                              true &unit
                          , &unit
                      =< nil 8
                      div
                        {} $ :class-name $ str-spaced css/row style-toolbar
                        button $ {} (:class-name style/button) (:inner-text |Apply)
                          :on-click $ on-submit expression? state cursor close-modal! false
                        button $ {} (:class-name style/button) (:inner-text |Submit)
                          :on-click $ on-submit expression? state cursor close-modal! true
          :examples $ []
          :schema $ quote $ Fn respo.schema/States app.schema/CirruNode (List String)
            Fn
              Fn *dispatch-op $ -> Unit
              -> Unit
            -> respo.schema/Component
            :features :js-ffi
        'css-draft-area $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-draft-area
            {} $ |$0 $ {}
              :background-color $ hsl 0 0 100 0.2
              :min-height 320
              :line-height |1.6em
              :min-width 960
              :color :white
              :font-family ui/font-code
              :font-size 14
              :outline :none
              :border :none
              :padding 8
              :min-width 800
              :vertical-align :top
          :examples $ []
          :schema $ quote String
        'css-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-text
            {} $ |$0 $ {} (:font-family ui/font-code) (:color :white) (:padding "|8px 8px") (:height 60) (:display :block) (:width |100%)
              :background-color $ hsl 0 0 100 0.2
              :outline :none
              :border :none
              :font-size 14
              :padding 8
              :min-width 800
              :vetical-align :top
          :examples $ []
          :schema $ quote String
        'css-wrong $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-wrong
            {} $ |$0 $ {} (:color :red) (:font-size 24) (:font-weight 100) (:font-family "|Josefin Sans") (:cursor :pointer)
          :examples $ []
          :schema $ quote String
        'draft-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn draft-text (node)
            match node
              (app.schema/CirruExprShape expr)
                format-cirru
                  [] $ app.schema/expr->syntax expr
                  , false
              (app.schema/CirruLeafShape leaf) (:text leaf)
          :examples $ []
          :schema $ quote $ Fn app.schema/CirruNode (-> String)
        'on-submit $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-submit (expression? text cursor close-modal! close?)
            fn (_event dispatch!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              submit-draft! expression? text cursor close-modal! close? dispatch!
              , &unit
          :examples $ []
          :schema $ quote $ Fn Bool String (List respo.schema/CoordKey)
            Fn
              Fn *dispatch-op $ -> Unit
              -> Unit
            , Bool (-> respo.schema/EventHandler) (:features :js-ffi)
        'parse-draft-expression $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-draft-expression (text)
            let
                forms $ decode-map-as (parse-cirru-list text)
                  List $ List app.schema/CirruSyntax
              if
                not= 1 $ .len forms
                raise "|Draft requires exactly one Cirru expression; other forms were not saved."
                .unwrap $ first forms
          :examples $ []
          :schema $ quote $ Fn String
            -> $ List app.schema/CirruSyntax
          :tests $ [] $ %{} 'TestEntry (:name |one-expression-roundtrip-and-empty-draft-state)
            :code $ quote $ let
                syntax $ [] |defn |run ([]) |true
                node $ app.schema/syntax->node syntax |source 0
                text $ draft-text node
              assert= syntax $ parse-draft-expression text
              assert= text $ read-draft-state
                {} $ :data nil
                , node
              assert= | $ read-draft-state
                {} $ :data |
                , node
              assert= true $ try
                do (parse-draft-expression "|a\nb") false
                fn (_error) true
            :tags $ #{} :unit
        'read-draft-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-draft-state (states node)
            match
              app.schema/read-optional-text $ app.schema/map-field states :data
              (:none) (draft-text node)
              (:some text) text
          :examples $ []
          :schema $ quote $ Fn respo.schema/States app.schema/CirruNode (-> String)
        'style-mode $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-mode
            {}
              :color $ hsl 0 0 100 0.6
              :background-color $ hsl 300 50 50 0.6
              :padding "|0 8px"
              :font-size 12
              :border-radius |4px
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-original $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-original
            {} (:max-height 240) (:overflow :auto)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-toolbar $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-toolbar
            {} $ |& $ {} (:justify-content :flex-end)
          :examples $ []
          :schema $ quote String
        'submit-draft! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn submit-draft! (expression? text cursor close-modal! close? dispatch!)
            if expression?
              dispatch! $ :: :ir/draft-expr $ parse-draft-expression text
              dispatch! $ :: :ir/update-leaf $ {} (:text text)
                :at $ now!
            when close?
              app.client-updater/dispatch-ui! dispatch! $ app.client-updater/UiStateOp :states cursor nil
              close-modal! dispatch!
            , &unit
          :examples $ []
          :schema $ quote $ Fn Bool String (List respo.schema/CoordKey)
            Fn
              Fn *dispatch-op $ -> Unit
              -> Unit
            , Bool
              Fn *dispatch-op $ -> Unit
              -> Unit
              :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.draft-box
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp <> span div textarea pre button a
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            app.comp.modal :refer $ comp-modal
            app.style :as style
            app.util :refer $ tree->cirru now! expr?
            app.keycode :as keycode
    'app.comp.expr $ %{} 'FileEntry
      :defs $ {}
        'comp-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-expr
            states expr focus coord others tail? layout-mode readonly? picker-mode? theme depth
            let
                focused? $ = focus coord
                focus-in? $ coord-contains? focus coord
                sorted-children $ sort
                  &map:to-list $ :data expr
                  fn (a b)
                    hint-fn $ Fn (Tuple String app.schema/CirruNode) (Tuple String app.schema/CirruNode) (-> Number)
                    &compare (nth a 0) (nth b 0)
                first-id $ .map (first sorted-children)
                  fn (pair)
                    hint-fn $ Fn (Tuple String app.schema/CirruNode) (-> String)
                    nth pair 0
                last-id $ .map (last sorted-children)
                  fn (pair)
                    hint-fn $ Fn (Tuple String app.schema/CirruNode) (-> String)
                    nth pair 0
              respo.core/data-list->
                {} (:tab-index 0)
                  :class-name $ str-spaced |comp-expr style-expr (base-style-expr theme) (if focused? |cirru-focused |)
                  :style $ decide-expr-theme expr (includes? others coord) focused? focus-in? tail? layout-mode (.len coord) depth theme
                  :on $ if readonly?
                    {} $ :click $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      when picker-mode?
                        app.util.dom/prevent-default! $ :event e
                        d! $ :: :writer/pick-node $ tree->cirru expr
                      , &unit
                    {}
                      :keydown $ on-keydown coord expr picker-mode?
                      :click $ fn (e d!)
                        hint-fn $ Fn respo.schema/RespoEvent
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        if picker-mode?
                          do
                            app.util.dom/prevent-default! $ :event e
                            d! $ :: :writer/pick-node $ tree->cirru expr
                          d! $ :: :writer/focus coord
                loop
                    result $ assert-type ([])
                      List $ Tuple String respo.schema/Component
                    children sorted-children
                    prev-mode :inline
                  if (empty? children) result $ let[] (k child)
                    .unwrap $ first children
                    let
                        child-coord $ conj coord k
                        partial-others $ filter others $ fn (x) (coord-contains? x child-coord)
                        mode $ match child
                          (app.schema/CirruLeafShape _leaf) :inline
                          (app.schema/CirruExprShape nested)
                            if (expr-many-items? nested 6) :block $ match prev-mode (:inline :inline-block)
                              :inline-block $ if (expr-many-items? nested 2) :block :inline-block
                              _ :block
                        rendered $ match child
                          (app.schema/CirruLeafShape leaf)
                            comp-leaf (>> states k) leaf focus child-coord (includes? partial-others child-coord)
                              = first-id $ Some k
                              , readonly? picker-mode? theme
                          (app.schema/CirruExprShape nested)
                            comp-expr (>> states k) nested focus child-coord partial-others
                              = last-id $ Some k
                              , mode readonly? picker-mode? theme $ inc depth
                      recur
                        conj result $ assert-type ([] k rendered) (Tuple String respo.schema/Component)
                        rest children
                        , mode
          :examples $ []
          :schema $ quote $ Fn respo.schema/States app.schema/CirruExprShape (List String) (List String)
            Set $ List String
            , Bool Tag Bool Bool Tag Number (-> respo.schema/Component) (:features :io :js-ffi)
        'on-keydown $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-keydown (coord expr picker-mode?)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              let
                  event $ js-ffi.browser/keyboard-event-host $ :original-event e
                  shift? $ .unwrap-or
                    js-nullish->option $ :shift? e
                    , false
                  meta? $ or
                    .unwrap-or
                      js-nullish->option $ :meta? e
                      , false
                    .unwrap-or
                      js-nullish->option $ :ctrl? e
                      , false
                  alt? $ .unwrap-or
                    js-nullish->option $ :alt? e
                    , false
                  code $ .unwrap-or
                    js-nullish->option $ :key-code e
                    , 0
                cond
                    and meta? $ = code keycode/enter
                    d! $ :: (if shift? :ir/append-leaf :ir/prepend-leaf) nil
                  (and meta? (= code keycode/enter))
                    d! $ :: :ir/prepend-leaf nil
                  (= code keycode/enter)
                    if (empty? coord)
                      d! $ :: :ir/prepend-leaf nil
                      d! $ :: (if shift? :ir/expr-before :ir/expr-after) nil
                  (= code keycode/backspace)
                    d! $ :: :ir/delete-node nil
                  (= code keycode/space)
                    do
                      d! $ :: (if shift? :ir/leaf-before :ir/leaf-after) nil
                      .prevent-default! event
                  (= code keycode/tab)
                    do
                      d! $ :: $ if shift? :ir/unindent :ir/indent
                      .prevent-default! event
                  (= code keycode/up)
                    do
                      if
                        not $ empty? coord
                        d! $ :: :writer/go-up
                      .prevent-default! event
                  (= code keycode/down)
                    do
                      d! $ :: :writer/go-down $ {} (:tail? shift?)
                      .prevent-default! event
                  (and meta? alt? (= code keycode/left))
                    do
                      d! $ :: :ir/swap-left
                      .prevent-default! event
                  (= code keycode/left)
                    do
                      d! $ :: :writer/go-left
                      .prevent-default! event
                  (= code keycode/right)
                    do
                      d! $ :: :writer/go-right
                      .prevent-default! event
                  (and meta? (= code keycode/c))
                    do-copy-logics! d!
                      format-cirru $ [] $ app.schema/expr->syntax expr
                      , |Copied!
                  (and meta? (= code keycode/x))
                    do
                      do-copy-logics! d!
                        format-cirru $ [] $ app.schema/expr->syntax expr
                        , |Copied!
                      d! $ :: :ir/delete-node nil
                  (and meta? (= code keycode/v))
                    on-paste! d!
                  (and meta? (= code keycode/b))
                    d! $ :: :ir/duplicate nil
                  (and meta? (= code keycode/d))
                    do
                      if shift?
                        let
                            tree $ app.schema/expr->syntax expr
                          match
                              first tree
                              , .and-then $ fn (head)
                                hint-fn $ Fn app.schema/CirruSyntax $ -> (Option String)
                                match head
                                  (String name) (Some name)
                                  (List _children) None
                            (:some name)
                              d! $ :: :analyze/goto-def $ {} (:text name) (:forced? true)
                                :args $ slice tree 1
                            (:none)
                              d! $ :: :notify/push-message $ [] :warn "|Can not create a function!"
                        do
                          app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :manual-state/abstract
                          js/setTimeout $ fn () $ match (js-ffi.browser/query-selector |.el-abstract)
                            (:some el) (js-ffi.browser/element-focus! el)
                            (:none) &unit
                      .prevent-default! event
                  (and meta? (= code keycode/slash) (not shift?))
                    d! $ :: :ir/toggle-comment
                  (and picker-mode? (= code keycode/escape))
                    d! $ :: :writer/picker-mode
                  (and meta? alt? (= code keycode/num-4))
                    d! $ :: :ir/fold-to-end
                  true $ do
                    ; println |Keydown $ :key-code e
                    on-window-keydown event d! $ {} $ :name :editor
              , &unit
          :examples $ []
          :schema $ quote $ Fn (List String) app.schema/CirruExprShape Bool (-> respo.schema/EventHandler) (:features :io :js-ffi)
        'style-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-expr
            {}
              |& $ {}
              |&.cirru-focused $ {} $ :animation "|border-blinking 1s ease infinite normal"
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.expr
          :require
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
            respo.css :refer $ defstyle
    'app.comp.file-replacer $ %{} 'FileEntry
      :defs $ {} $ 'comp-file-replacer
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-file-replacer (states file templates)
            let
                cursor $ respo.core/state-cursor states
                initial-view $ app.source/export-cli-file file templates
                state $ respo.core/pick-state states 'String initial-view
              comp-modal
                fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  d! $ :: :writer/draft-ns nil
                div
                  {} $ :style ui/column
                  textarea $ {} (:value state) (:class-name style/input)
                    :style $ {} (:width 800) (:height 400) (:white-space :pre) (:line-height |20px)
                    :on-input $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ decode-map-as (:value e) 'String
                  =< nil 8
                  div
                    {} (:class-name css/row)
                      :style $ {} $ :justify-content :flex-end
                    button $ {} (:inner-text |Submit) (:class-name style/button)
                      :on-click $ fn (e d!)
                        hint-fn $ Fn respo.schema/RespoEvent
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        when (not= state initial-view)
                          let
                              imported $ app.source/import-cli-file state | 0
                            d! $ :: :ir/replace-file $ :source-view imported
                        app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor nil
                        d! $ :: :writer/draft-ns nil
          :examples $ []
          :schema $ quote $ Fn respo.schema/States app.schema/FileEntry (Map Tag String) (-> respo.schema/Component) (:features :io)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.file-replacer
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp >> <> span div pre input button a textarea
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            app.comp.modal :refer $ comp-modal
    'app.comp.gen-code-box $ %{} 'FileEntry
      :defs $ {}
        '%gen-code-box-action $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def %gen-code-box-action (impl-traits %gen-code-box-action0 GenCodeBoxActionImpl)
          :examples $ []
          :schema $ quote EnumDef
        '%gen-code-box-action0 $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def %gen-code-box-action0
            defenum %gen-code-box-action0 $ :plugin
              Fn $ -> $ Option respo.schema/Component
              Fn
                Fn *dispatch-op $ -> Unit
                -> Unit
              Fn
                Fn *dispatch-op $ -> Unit
                -> Unit
          :examples $ []
          :schema $ quote EnumDef
        'CodeBoxState $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct CodeBoxState (:show? Bool)
          :examples $ []
          :schema $ quote StructDef
        'GenCodeBoxActionImpl $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defimpl GenCodeBoxActionImpl GenCodeBoxActionTrait
            .render $ fn (self)
              hint-fn $ Fn app.comp.gen-code-box/%gen-code-box-action0 $ -> (Option respo.schema/Component)
              match self $
                :plugin render open reset-state
                render
            .open $ fn (self d!)
              hint-fn $ Fn app.comp.gen-code-box/%gen-code-box-action0
                Fn *dispatch-op $ -> Unit
                -> Unit
              match self $
                :plugin render open reset-state
                open d!
            .reset-state $ fn (self d!)
              hint-fn $ Fn app.comp.gen-code-box/%gen-code-box-action0
                Fn *dispatch-op $ -> Unit
                -> Unit
              match self $
                :plugin render open reset-state
                reset-state d!
          :examples $ []
          :schema $ quote Impl
        'GenCodeBoxActionTrait $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait GenCodeBoxActionTrait
            .render $ Fn app.comp.gen-code-box/%gen-code-box-action0 $ -> (Option respo.schema/Component)
            .open $ Fn app.comp.gen-code-box/%gen-code-box-action0
              Fn *dispatch-op $ -> Unit
              -> Unit
            .reset-state $ Fn app.comp.gen-code-box/%gen-code-box-action0
              Fn *dispatch-op $ -> Unit
              -> Unit
          :examples $ []
          :schema $ quote Trait
        'open-gen-code-box! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn open-gen-code-box! (plugin d!) (.open plugin d!)
          :examples $ []
          :schema $ quote $ Fn app.comp.gen-code-box/%gen-code-box-action
            Fn *dispatch-op $ -> Unit
            -> Unit
        'render-gen-code-box $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-gen-code-box (plugin) (.render plugin)
          :examples $ []
          :schema $ quote $ Fn app.comp.gen-code-box/%gen-code-box-action
            -> $ Option respo.schema/Component
        'reset-gen-code-box! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reset-gen-code-box! (plugin d!) (.reset-state plugin d!)
          :examples $ []
          :schema $ quote $ Fn app.comp.gen-code-box/%gen-code-box-action
            Fn *dispatch-op $ -> Unit
            -> Unit
        'style-panel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-panel
            {} $ |& $ {} (:width 600)
              :background-color $ hsl 0 0 100
              :border-radius |6px
          :examples $ []
          :schema $ quote String
        'use-gen-code-box $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn use-gen-code-box (states expr focus)
            let
                cursor $ decode-map-as
                  .unwrap-or (app.schema/map-field states :cursor) ([])
                  List respo.schema/CoordKey
                state $ decode-map-as
                  merge
                    {} $ :show? false
                    app.schema/open-state-fields $ .unwrap-or (app.schema/map-field states :data) ({})
                  , CodeBoxState
                selected $ app.schema/node-at-path (app.schema/read-node expr) focus
                close-modal! $ fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :show? false
                plugin-code-gen $ use-gen-code (>> states :gen-code)
                  fn ()
                    hint-fn $ Fn $ -> String
                    match selected
                      (:some node)
                        format-cirru $ [] $ app.schema/node->syntax node
                      (:none) |
                  fn (code d!)
                    hint-fn $ Fn String
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    match
                      first $ parse-cirru-list code
                      (:some syntax)
                        do
                          d! $ :: :ir/draft-expr $ app.util/normalize-cirru syntax
                          close-modal! d!
                      (:none) (raise |Expected-generated-expression)
              %:: %gen-code-box-action :plugin
                fn ()
                  hint-fn $ Fn $ -> (Option respo.schema/Component)
                  if (:show? state)
                    Some $ comp-modal
                      fn (d!)
                        hint-fn $ Fn
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        .reset-state plugin-code-gen d!
                        close-modal! d!
                      match selected
                        (:none)
                          span $ {} (:class-name |) (:inner-text "|Does not edit expression!")
                            :on-click $ fn (_event d!)
                              hint-fn $ Fn respo.schema/RespoEvent
                                Fn *dispatch-op $ -> Unit
                                -> Unit
                              close-modal! d!
                        (:some _node)
                          div
                            {} $ :class-name $ str-spaced css/column style-panel
                            .render plugin-code-gen
                    , None
                fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :show? true
                fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  .reset-state plugin-code-gen d!
          :examples $ []
          :schema $ quote $ Fn respo.schema/States Dynamic (List String) (-> app.comp.gen-code-box/%gen-code-box-action) (:features :io :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.gen-code-box
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp <> >> span div textarea pre button a
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            app.comp.modal :refer $ comp-modal
            app.style :as style
            app.util :refer $ tree->cirru now! expr?
            app.keycode :as keycode
            gen-code.core :refer $ use-gen-code
    'app.comp.graph $ %{} 'FileEntry
      :defs $ {}
        'GraphElementHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait GraphElementHost (:style 'app.comp.graph/GraphStyleHost)
            .query-selector $ Fn app.comp.graph/GraphElementHost String $ -> (JsNullish app.comp.graph/GraphElementHost)
            .scroll-into-view $ Fn app.comp.graph/GraphElementHost $ -> Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:query-selector |querySelector) (:scroll-into-view |scrollIntoView)
          :schema $ quote Trait
        'GraphStyleHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait GraphStyleHost (:opacity 'String) (:background-color 'String) (:padding 'String) (:transition-duration 'String)
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:background-color |backgroundColor) (:transition-duration |transitionDuration)
            :writable $ #{} :background-color :opacity :padding :transition-duration
          :schema $ quote Trait
        'comp-deps-graph $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-deps-graph (states pkg configs entries deps-dict writer)
            let
                init-fn $ .unwrap-or
                  app.schema/read-optional-text $ get configs :init-fn
                  , |
                pair $ split init-fn |/
                that-ns $ .unwrap-or (.get pair 0) |
                that-def $ .unwrap-or (.get pair 1) |
                cursor $ decode-map-as
                  .unwrap $ app.schema/map-field states :cursor
                  List respo.schema/CoordKey
                state $ decode-map-as
                  either
                    .unwrap-or (app.schema/map-field states :data) {}
                    {}
                      :ns $ .unwrap-or (.get pair 0) |
                      :def $ .unwrap-or (.get pair 1) |
                  Map Tag String
                selected-ns $ decode-map-as
                  .unwrap-or (get state :ns) |
                  , String
                selected-def $ decode-map-as
                  .unwrap-or (get state :def) |
                  , String
                plugin-entries $ use-modal-menu (>> states :entries-menu)
                  {} (:title |Entries)
                    :style $ {} $ :width 300
                    :backdrop-style $ {}
                    :items $ concat
                      [] $ :: :item (:: :def that-ns that-def) init-fn
                      -> entries
                        either $ {}
                        , distinct-values &set:to-list $ map $ fn (conf)
                          let
                              pair $ split
                                decode-map-as
                                  .unwrap-or (get conf :init-fn) |
                                  , String
                                , |/
                            :: :item
                              :: :def
                                .unwrap-or (.get pair 0) |
                                .unwrap-or (.get pair 1) |
                              .unwrap-or (get conf :init-fn) |
                    :on-result $ fn (result d!)
                      match
                        .unwrap $ nth result 1
                        (:def a-ns a-def)
                          d! $ app.client-updater/UiStateOp :states cursor $ {} (:ns a-ns) (:def a-def)
                bookmark $ app.util/to-bookmark $ Some writer
              [] (effect-navigate bookmark)
                div
                  {} $ :style $ {} (:padding-right 24)
                  div
                    {} $ :style $ {} (:padding "|4px 16px")
                    span $ {}
                      :inner-text $ str selected-ns |/ selected-def
                      :on-click $ fn (e d!)
                        hint-fn $ Fn respo.schema/RespoEvent
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        .show plugin-entries d!
                      :class-name style-def-entry
                    .render plugin-entries
                  comp-entry-deps selected-ns selected-def deps-dict pkg $ []
          :examples $ []
          :schema $ quote $ Fn respo.schema/States String (Map Tag Dynamic) (Map String Dynamic)
            Map app.schema/DependencyKey $ Set app.schema/DependencyKey
            Map Tag Dynamic
            -> respo.schema/Component
        'comp-entry-deps $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn comp-entry-deps (that-ns that-def deps-dict pkg footprints)
            let
                entry $ app.schema/DependencyKey :def that-ns that-def
                this-deps $
                  get deps-dict entry
                  , .unwrap-or $ #{}
                internal-deps $ -> this-deps (&set:to-list)
                  filter $ fn (item)
                    match item
                      (:reference child-ns child-def)
                        starts-with? child-ns $ str pkg |.
                      _ false
                root? $ empty? footprints
                show-ns? $ and (not root?)
                  match (last footprints)
                    (:none) false
                    (:some parent)
                      match parent
                        (:def namespace _name) (not= that-ns namespace)
                        (:reference namespace _name) (not= that-ns namespace)
                has-children? $ not $ empty? internal-deps
              div
                {} $ :class-name $ str-spaced css/row-middle style-entry
                if (not root?)
                  Some $ div
                    {} $ :class-name $ str-spaced style-def-ns
                      if (and show-ns? has-children?) css/column |
                    span $ {}
                      :class-name $ str-spaced css/font-code! style-def
                      :id $ gen-def-id that-ns that-def
                      :inner-text that-def
                      :on-click $ fn (e d!)
                        d! $ :: :writer/edit $ :: :def that-ns that-def
                    if show-ns?
                      Some $ <> that-ns $ str-spaced style-ns (if has-children? | style-ns-pad)
                      , None
                  , None
                if (includes? footprints entry)
                  div ({})
                    <> |Recur $ str-spaced css/font-fancy style-recur
                  if has-children?
                    Some $ keyed->
                      {} $ :class-name style-deps-area
                      .map internal-deps $ fn (item)
                        hint-fn $ Fn app.schema/DependencyKey $ -> respo.schema/ChildPair
                        match item
                          (:reference child-ns child-def)
                            keyed-component (str item)
                              memo-comp-by (str child-ns |/ child-def) comp-entry-deps child-ns child-def deps-dict pkg $ conj footprints entry
                          (:def _namespace _name)
                            keyed-element (str item)
                              div ({})
                                <> $ str "|Unknown data: " item
                    , None
          :examples $ []
          :schema $ quote $ Fn String String
            Map app.schema/DependencyKey $ Set app.schema/DependencyKey
            , String (List app.schema/DependencyKey) (-> respo.schema/Element)
        'effect-navigate $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defeffect effect-navigate (bookmark) (action el at?)
            if (= action :mount)
              match (app.bookmark/read-optional-bookmark bookmark)
                (:some selected)
                  match selected
                    (:def the-ns the-def _coord)
                      try
                        let
                            id $ str |# $ gen-def-id the-ns the-def
                            host-el $ unsafe-coerce el 'app.comp.graph/GraphElementHost
                            target-opt $ js-nullish->option $ .query-selector host-el id
                          match target-opt
                            (:some target)
                              do (.scroll-into-view target)
                                let
                                    s $ .-style target
                                  -> s .-opacity $ set! |1
                                  -> s .-background-color $ set! $ hsl 0 0 100 0.4
                                  -> s .-padding $ set! "|0px 8px"
                                  js/setTimeout
                                    fn ()
                                      -> s .-background-color $ set! $ hsl 0 0 100 0
                                      -> s .-transition-duration $ set! |1000ms
                                    , 100
                            (:none) (js/console.warn "|found no target for:" id)
                        fn (error) (js/console.error error)
                    (:ns _ns _coord) &unit
                (:none) &unit
              , &unit
          :examples $ []
          :schema $ quote $ Fn (Option app.bookmark/%bookmark) (-> respo.schema/Effect) (:features :js-ffi)
        'gen-def-id $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn gen-def-id (that-ns that-def)
            -> (str |def__ that-ns |__ that-def) (&str:replace |. |_DOT_) (&str:replace |! |_EXP_) (&str:replace |# |_SHA_) (&str:replace |* |_STAR_) (&str:replace |? |_QUE_) (&str:replace |% |_PCT_)
          :examples $ []
          :schema $ quote $ Fn String String (-> String)
        'style-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-def
            {} $ |& $ {} (:white-space :pre)
              :color $ hsl 0 0 100
              :cursor :pointer
              :line-height |20px
              ; :transition-duration |400ms
              ; :transition-property |background-color
              :border-radius |8px
          :examples $ []
          :schema $ quote String
        'style-def-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-def-entry
            {}
              |& $ {} (:cursor :pointer)
                :color $ hsl 0 0 80
              |&:hover $ {} $ :color (hsl 0 0 100)
          :examples $ []
          :schema $ quote String
        'style-def-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-def-ns
            {}
              |& $ {} (:top 0) (:position :sticky) (:opacity 0.6) (:margin-right |12px)
              |&:hover $ {} $ :opacity 1
          :examples $ []
          :schema $ quote String
        'style-deps-area $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-deps-area
            {}
              |& $ {} (:max-height |96vh) (:overflow :auto)
                :border-color $ hsl 0 0 100 0.3
                :border-style :solid
                :border-width "|1px 0 0px 1px"
                :border-radius |16px
                :padding "|4px 0px 4px 0"
                :transition |300ms
                :transition-property |border-color
              |&:hover $ {} $ :border-color (hsl 0 0 100 0.5)
          :examples $ []
          :schema $ quote String
        'style-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-entry
            {} $ |& $ {}
              ; :border-left $ str "|1px solid " $ hsl 0 0 90 0.4
              :padding-left |8px
              :margin-left |8px
              :border-radius |8px
              ; :box-shadow "|0 0 2px #888"
          :examples $ []
          :schema $ quote String
        'style-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-ns
            {} $ |& $ {} (:font-size 12) (:vertical-align :middle) (; :margin-left 8) (:white-space :nowrap)
              :color $ hsl 0 0 50
              :line-height |12px
              :margin-bottom 4
          :examples $ []
          :schema $ quote String
        'style-ns-pad $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-ns-pad
            {} $ |& $ {} (:margin-left 8)
          :examples $ []
          :schema $ quote String
        'style-recur $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-recur
            {} $ |& $ {}
              :color $ hsl 0 0 60
              :border-radius |8px
              :background-color $ hsl 300 10 100 0.2
              :margin "|2px 8px"
              :padding "|0 8px"
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.graph
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp >> <> div span create-element keyed-> keyed-component keyed-element defeffect memo-comp-by
            respo.css :refer $ defstyle
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.config :refer $ dev?
            respo-alerts.core :refer $ use-alert use-prompt use-confirm use-modal-menu
    'app.comp.header $ %{} 'FileEntry
      :defs $ {}
        'comp-header $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-header (states router-name logged-in? stats)
            let
                broadcast-plugin $ use-prompt (>> states :broadcast)
                  {} $ :text "|Message to broadcast"
              div
                {} $ :class-name $ str-spaced css/row-center css/font-fancy style-header
                div
                  {} $ :class-name css/row-center
                  render-entry |Files :files router-name $ fn (e d!)
                    d! $ app.updater.router/route-op $ app.updater.router/Route :files
                  render-entry |Graph :graph router-name $ fn (e d!)
                    d! $ app.updater.router/route-op $ app.updater.router/Route :graph
                  render-entry |Editor :editor router-name $ fn (e d!)
                    d! $ app.updater.router/route-op $ app.updater.router/Route :editor
                  render-entry |Search :search router-name $ fn (e d!)
                    d! $ app.updater.router/route-op $ app.updater.router/Route :search
                    focus-search!
                  render-entry |Configs :configs router-name $ fn (e d!)
                    d! $ app.updater.router/route-op $ app.updater.router/Route :configs
                  a
                    {}
                      :href |https://github.com/Cirru/calcit-editor/wiki/Keyboard-Shortcuts
                      :target |_blank
                      :class-name css-entry
                    <> |Shortcuts style-link
                    <> "|↗" css/font-code
                div
                  {} $ :class-name css/row-middle
                  comp-icon :radio
                    {} (:font-size 18)
                      :color $ hsl 200 80 70 0.6
                      :cursor :pointer
                    fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show broadcast-plugin d! $ fn (result)
                        hint-fn $ Fn String $ -> Unit
                        d! $ :: :notify/broadcast result
                  respo.comp.space/space-x 12
                  render-entry
                    if logged-in?
                      str |Profile: $ .unwrap-or (get stats :members-count) 0
                      , |Guest
                    , :profile router-name $ fn (e d!)
                      d! $ app.updater.router/route-op $ app.updater.router/Route :profile
                .render broadcast-plugin
          :examples $ []
          :schema $ quote $ Fn respo.schema/States Tag Bool (Map Tag Dynamic) (-> respo.schema/Component)
        'css-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-entry
            {}
              |$0 $ {} (:cursor :pointer) (:padding "|0 12px")
                :color $ hsl 0 0 100 0.6
                :text-decoration :none
                :vertical-align :middle
              |&:hover $ {} $ :color (hsl 0 0 100 0.7)
              |&:active $ {} $ :transform "|scale(1.02)"
          :examples $ []
          :schema $ quote String
        'render-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-entry (page-name this-page router-name on-click)
            div
              {} (:class-name css-entry) (:on-click on-click)
                :style $ if (= this-page router-name) style-highlight $ {}
              <> page-name
          :examples $ []
          :schema $ quote $ Fn String Tag Tag respo.schema/EventHandler (-> respo.schema/Element)
        'style-header $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-header
            {}
              |$0 $ {} (:height 30) (:justify-content :space-between) (:padding "|0 16px") (:font-size 15) (:line-height |18px) (:color :white) (:font-weight 300) (:position :fixed) (:top 0) (:right 0) (:z-index 100) (:transition-duration |240ms) (; :opacity 0.1)
                :background-color $ hsl 0 0 0 0.2
                :border-bottom $ str "|1px solid " $ hsl 0 0 100 0.2
              "|$0 > *" $ {} (:opacity 0.5) (:transition-duration |240ms)
              |$0:hover $ {} $ :opacity 1
              "|$0:hover > *" $ {} $ :opacity 1
          :examples $ []
          :schema $ quote String
        'style-highlight $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-highlight
            {} $ :color $ hsl 0 0 100
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-link $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-link
            {} (:font-size 14) (:font-weight 100)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.header
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp >> <> span div a
            respo.comp.space :refer $ =<
            app.util.dom :refer $ focus-search!
            feather.core :refer $ comp-icon
            respo-alerts.core :refer $ use-prompt
    'app.comp.leaf $ %{} 'FileEntry
      :defs $ {}
        'LeafInputTargetHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait LeafInputTargetHost (:selection-start 'Number) (:selection-end 'Number) (:text-length 'Number)
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:selection-end |selectionEnd) (:selection-start |selectionStart)
          :schema $ quote Trait
        'LeafState $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def LeafState
            defstruct :LeafState (:text String) (:at Number)
          :examples $ []
          :schema $ quote StructDef
        'comp-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-leaf
            states leaf focus coord by-other? first? readonly? picker-mode? theme
            let
                cursor $ respo.core/state-cursor states
                state $ respo.core/pick-state states 'app.comp.leaf/LeafState initial-state
                text $ if
                  > (:at state) (:at leaf)
                  :text state
                  :text leaf
                focused? $ = focus coord
              textarea $ {} (:value text) (:spellcheck false)
                :class-name $ str-spaced |comp-leaf (base-style-leaf theme) (if focused? |cirru-focused |)
                :read-only readonly?
                :style $ decide-leaf-theme text focused? first? by-other? theme
                :on $ if readonly?
                  {} $ :click $ on-focus leaf coord picker-mode?
                  {}
                    :click $ on-focus leaf coord picker-mode?
                    :keydown $ on-keydown state leaf coord picker-mode?
                    :input $ on-input state coord cursor
          :examples $ []
          :schema $ quote $ Fn respo.schema/States app.schema/CirruLeafShape (List String) (List String) Bool Bool Bool Bool Tag (-> respo.schema/Component) (:features :io)
        'initial-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def initial-state
            %{} LeafState (:text |) (:at 0)
          :examples $ []
          :schema $ quote LeafState
        'on-focus $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-focus (leaf coord picker-mode?)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              if picker-mode?
                do
                  app.util.dom/prevent-default! $ :event e
                  d! $ :: :writer/pick-node $ tree->cirru leaf
                d! $ :: :writer/focus coord
          :examples $ []
          :schema $ quote $ Fn app.schema/CirruLeafShape (List String) Bool (-> respo.schema/EventHandler) (:features :js-ffi)
        'on-input $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-input (state coord cursor)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              let
                  now $ util/now!
                  text $ decode-map-as (:value e) 'String
                d! $ :: :ir/update-leaf $ {} (:text text) (:at now)
                app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ -> state (assoc :text text) (assoc :at now)
              , &unit
          :examples $ []
          :schema $ quote $ Fn LeafState (List String) (List respo.schema/CoordKey) (-> respo.schema/EventHandler) (:features :js-ffi)
        'on-keydown $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-keydown (state leaf coord picker-mode?)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              let
                  event $ js-ffi.browser/keyboard-event-host $ :original-event e
                  code $ .unwrap-or
                    js-nullish->option $ :key-code e
                    , 0
                  shift? $ .unwrap-or
                    js-nullish->option $ :shift? e
                    , false
                  meta? $ or
                    .unwrap-or
                      js-nullish->option $ :meta? e
                      , false
                    .unwrap-or
                      js-nullish->option $ :ctrl? e
                      , false
                  alt? $ .unwrap-or
                    js-nullish->option $ :alt? e
                    , false
                  event-target $ unsafe-coerce (.-target event) 'app.comp.leaf/LeafInputTargetHost
                  selection-start $ .-selection-start event-target
                  selection-end $ .-selection-end event-target
                  selected? $ not= selection-start selection-end
                  text $ if
                    > (:at state) (:at leaf)
                    :text state
                    :text leaf
                  text-length $ .-text-length event-target
                cond
                    = code keycode/backspace
                    if
                      and $ = | text
                      d! $ :: :ir/delete-node nil
                  (and (= code keycode/space) (not shift?))
                    do
                      d! $ :: :ir/leaf-after nil
                      .prevent-default! event
                  (= code keycode/enter)
                    do
                      d! $ :: (if shift? :ir/leaf-before :ir/leaf-after) nil
                      .prevent-default! event
                  (= code keycode/tab)
                    do
                      d! $ :: $ if shift? :ir/unindent-leaf :ir/indent
                      .prevent-default! event
                  (= code keycode/up)
                    do
                      if
                        not $ empty? coord
                        d! $ :: :writer/go-up
                      .prevent-default! event
                  (and meta? alt? (= code keycode/left))
                    do
                      d! $ :: :ir/swap-left
                      .prevent-default! event
                  (and (not selected?) (= code keycode/left))
                    if (= 0 selection-start)
                      do
                        d! $ :: :writer/go-left
                        .prevent-default! event
                  (and meta? (= code keycode/b))
                    d! $ :: :analyze/peek-def $ :text leaf
                  (and (not selected?) (= code keycode/right))
                    if (= text-length selection-end)
                      do
                        d! $ :: :writer/go-right
                        .prevent-default! event
                  (and meta? (= code keycode/c) (= selection-start selection-end))
                    do-copy-logics! d! (:text leaf) |Copied!
                  (and meta? shift? (= code keycode/v))
                    do (on-paste! d!) (.prevent-default! event)
                  (and meta? (= code keycode/d))
                    do (.prevent-default! event)
                      if
                        -> ([] "|\"" || "|#\"")
                          any? $ fn (x)
                            starts-with? (:text leaf) x
                        do
                          app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :manual-state/draft-box
                          js/setTimeout $ fn () $ match (js-ffi.browser/query-selector |.el-draft-box)
                            (:some el) (js-ffi.browser/element-focus! el)
                            (:none) &unit
                        d! $ :: :analyze/goto-def $ {}
                          :text $ :text leaf
                          :forced? shift?
                  (and meta? (= code keycode/slash) (not shift?))
                    js/window.open $ str |https://apis.calcit-lang.org/?q= $ js/encodeURIComponent
                      last $ split (:text leaf) |/
                  (and picker-mode? (= code keycode/escape))
                    d! $ :: :writer/picker-mode
                  (and meta? alt? (= code keycode/num-4))
                    d! $ :: :ir/fold-to-end
                  true $ do (; println "|Keydown leaf" code)
                    on-window-keydown event d! $ {} $ :name :editor
              , &unit
          :examples $ []
          :schema $ quote $ Fn LeafState app.schema/CirruLeafShape (List String) Bool (-> respo.schema/EventHandler) (:features :io :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.leaf
          :require
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
    'app.comp.login $ %{} 'FileEntry
      :defs $ {}
        'comp-login $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-login (states)
            let
                cursor $ decode-map-as
                  .unwrap-or (app.schema/map-field states :cursor) ([])
                  List respo.schema/CoordKey
                state $ match (app.schema/map-field states :data)
                  (:none) initial-state
                  (:some raw)
                    if (nil? raw) initial-state $ decode-map-as raw $ Map Tag String
              div
                {} (:class-name css/column) (:style style-login)
                div
                  {} $ :class-name css/column
                  div ({})
                    input $ {} (:placeholder |Username)
                      :value $ .unwrap-or (get state :username) |
                      :class-name style/input
                      :on-input $ on-input state cursor :username
                  respo.comp.space/space-y 8
                  div ({})
                    input $ {} (:placeholder |Password)
                      :value $ .unwrap-or (get state :password) |
                      :class-name style/input
                      :on-input $ on-input state cursor :password
                respo.comp.space/space-y 8
                div
                  {} $ :style style-control
                  button $ {} (:inner-text "|Sign up") (:class-name style/button)
                    :on-click $ on-submit
                      .unwrap-or (get state :username) |
                      .unwrap-or (get state :password) |
                      , true
                  respo.comp.space/space-x 8
                  button $ {} (:inner-text "|Log in") (:class-name style/button)
                    :on-click $ on-submit
                      .unwrap-or (get state :username) |
                      .unwrap-or (get state :password) |
                      , false
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (-> respo.schema/Component)
        'initial-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def initial-state
            {} (:username |) (:password |)
          :examples $ []
          :schema $ quote $ Map Tag String
        'on-input $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-input (state cursor k)
            fn (e dispatch!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              app.client-updater/dispatch-ui! dispatch! $ app.client-updater/UiStateOp :states cursor $ assoc state k (respo.core/event-value e)
          :examples $ []
          :schema $ quote $ Fn (Map Tag String) (List respo.schema/CoordKey) Tag (-> respo.schema/EventHandler)
        'on-submit $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-submit (username password signup?)
            fn (e dispatch!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              dispatch! $ if signup?
                :: :user/sign-up $ [] username password
                :: :user/log-in $ [] username password
              js/window.localStorage.setItem (:storage-key config/site)
                format-cirru-edn $ [] username password
              , &unit
          :examples $ []
          :schema $ quote $ Fn String String Bool (-> respo.schema/EventHandler) (:features :js-ffi)
        'style-control $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-control
            merge ui/flex $ {} $ :text-align :right
          :examples $ []
          :schema $ quote $ Map Tag respo-ui.schema/StyleValue
        'style-login $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-login
            {} $ :padding 16
          :examples $ []
          :schema $ quote $ Map Tag respo-ui.schema/StyleValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.login
          :require
            respo.core :refer $ defcomp >> <> div input button span
            respo.comp.space :refer $ =<
            respo.comp.inspect :refer $ comp-inspect
            respo-ui.core :as ui
            respo-ui.css :as css
            app.style :as style
            app.config :as config
    'app.comp.messages $ %{} 'FileEntry
      :defs $ {}
        'DayjsFormatHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait DayjsFormatHost
            .format $ Fn app.comp.messages/DayjsFormatHost String $ -> String
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :format |format
          :schema $ quote Trait
        'comp-messages $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-messages (messages)
            list-> ({})
              -> messages
                drop $ &max 0 $ - (count messages) 3
                map-indexed $ fn (idx msg)
                  hint-fn $ Fn Number (Map Tag app.schema/NotificationField)
                    -> $ List Dynamic
                  let
                      id $ decode-map-as
                        .unwrap $ get msg :id
                        , String
                      text $ decode-map-as
                        .unwrap-or (get msg :text) |
                        , String
                      time $ decode-map-as
                        .unwrap $ get msg :time
                        , Number
                      formatted $ let
                          clock $ js-cast (Dayjs time) app.comp.messages/DayjsFormatHost
                        clock .format |mm:ss
                    [] id $ div
                      {} (:class-name css-message)
                        :style $ {}
                          :bottom $ + 8 $ * idx 28
                          :color $ match
                            .unwrap-or (get msg :kind) :info
                            (Tag kind)
                              match kind
                                :error $ hsl 0 80 80
                                :warning $ hsl 60 80 80
                                :info $ hsl 240 80 80
                                _ $ hsl 120 80 80
                            _ $ hsl 120 80 80
                        :on-click $ fn (_event d!)
                          hint-fn $ Fn respo.schema/RespoEvent
                            Fn *dispatch-op $ -> Unit
                            -> Unit
                          d! $ :: :notify/clear nil
                      span $ {}
                        :class-name $ str-spaced css/font-code style-time-short
                        :inner-text formatted
                      =< 8 nil
                      <> text
          :examples $ []
          :schema $ quote $ Fn
            List $ Map Tag app.schema/NotificationField
            -> respo.schema/Component
            :features :js-ffi
        'css-message $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-message
            {}
              |$0 $ {} (:position :absolute) (:left 8) (:cursor :pointer) (:font-weight 100) (:font-family |Hind) (:padding "|0 8px") (:transition-duration |200ms) (:border-radius |6px) (:z-index 200)
                :background-color $ hsl 0 0 0 0.5
              |$0:hover $ {} $ :transform "|scale(1.03)"
          :examples $ []
          :schema $ quote String
        'style-time-short $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-time-short
            {} $ |& $ {} (:font-size 12) (:opacity 0.7)
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.messages
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp list-> <> span div pre input button a
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            app.client-util :as util
            app.style :as style
            |dayjs :default Dayjs
    'app.comp.modal $ %{} 'FileEntry
      :defs $ {}
        'comp-modal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-modal (close-modal! inner-tree)
            div
              {}
                :class-name $ str-spaced css/center style-backdrop
                :on-click $ fn (e d!)
                  hint-fn $ Fn respo.schema/RespoEvent
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  close-modal! d!
                  , &unit
              div
                {} $ :on-click $ fn (e d!)
                  hint-fn $ Fn respo.schema/RespoEvent
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  , &unit
                , inner-tree
          :examples $ []
          :schema $ quote $ Fn
            Fn
              Fn *dispatch-op $ -> Unit
              -> Unit
            , respo.schema/Element (-> respo.schema/Component)
        'style-backdrop $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-backdrop
            {} $ |& $ {} (:position :fixed) (:width |100%) (:height |100%) (:top 0) (:left 0)
              :background-color $ hsl 0 0 0 0.6
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.modal
          :require
            respo.css :refer $ defstyle
            respo-ui.css :as css
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
    'app.comp.page-editor $ %{} 'FileEntry
      :defs $ {}
        'BookmarkElementHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait BookmarkElementHost
            .query-selector $ Fn app.comp.page-editor/BookmarkElementHost String $ -> (JsNullish app.comp.page-editor/BookmarkElementHost)
            .scroll-into-view-if-needed $ Fn app.comp.page-editor/BookmarkElementHost $ -> Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:query-selector |querySelector) (:scroll-into-view-if-needed |scrollIntoViewIfNeeded)
          :schema $ quote Trait
        'comp-doc $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-doc (states entry bookmark)
            let
                ns? $ match bookmark
                  (:ns _namespace _focus) true
                  (:def _namespace _name _focus) false
                doc $ :doc entry
                no-doc? $ blank? doc
                plugin $ use-prompt (>> states :doc)
                  {}
                    :text $ if ns? "|Namespace doc:" "|Function doc:"
                    :initial doc
                    :placeholder "|...some docs..."
                    :input-style $ {} (:height 600) (:resize :vertical) (:font-family ui/font-code) (:font-size 13)
                    :class-name css/font-code!
                    :multiline? true
              div
                {} $ :style $ {} (:margin-left 32)
                div
                  {}
                    :class-name $ str-spaced style-doc $ if no-doc? style-doc-empty |
                    :on-click $ fn (_event dispatch!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show plugin dispatch! $ fn (doc-text)
                        hint-fn $ Fn String $ -> Unit
                        dispatch! $ :: :writer/doc-set
                          match bookmark
                            (:def namespace name _focus) (:: :def namespace name)
                            (:ns namespace _focus) (:: :ns namespace)
                          , doc-text
                        , &unit
                      , &unit
                  if no-doc? (<> "|no doc")
                    comp-md-block doc $ {}
                .render plugin
          :examples $ []
          :schema $ quote $ Fn respo.schema/States app.schema/CodeEntry app.bookmark/%bookmark (-> respo.schema/Component)
        'comp-local-link $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-local-link (ns-name def-name)
            span
              {}
                :class-name $ str-spaced css/link-slight css/font-code style-local-link
                :on-click $ fn (e d!)
                  d! $ :: :writer/edit $ :: :def ns-name def-name
              <> def-name
          :examples $ []
          :schema $ quote $ Fn String String (-> respo.schema/Component)
        'comp-page-editor $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-page-editor (states stack router-data pointer picker-mode? theme)
            if (empty? stack)
              div
                {} $ :class-name css-page-editor
                div
                  {} $ :class-name css-stack
                  <> |Empty style-nothing
                div
                  {} $ :style $ {} (:padding "|12px 0")
                  <> "|Nothing to edit" style-nothing
              match
                app.schema/read-optional-code-entry $ .unwrap-or (get router-data :expr) None
                (:some entry)
                  match (nth stack pointer)
                    (:some bookmark)
                      comp-selected-editor states stack router-data pointer picker-mode? theme entry bookmark
                    (:none)
                      div ({}) (<> "|The selected bookmark no longer exists." style-nothing)
                (:none)
                  div
                    {} $ :class-name css-page-editor
                    comp-stack stack pointer
                    div
                      {} $ :style $ {} (:padding "|12px 0")
                      <> "|The selected source entry no longer exists." style-nothing
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (List app.bookmark/%bookmark) (Map Tag Dynamic) Number Bool (Option Tag) (-> respo.schema/Component) (:features :io)
        'comp-selected-editor $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-selected-editor (states stack router-data pointer picker-mode? theme expr-entry bookmark)
            let
                cursor $ decode-map-as
                  .unwrap-or (app.schema/map-field states :cursor) ([])
                  List respo.schema/CoordKey
                state $ decode-map-as
                  or
                    .unwrap-or (app.schema/map-field states :data) initial-state
                    , initial-state
                  Map Tag Bool
                expr $ match
                  app.schema/read-node $ :code expr-entry
                  (app.schema/CirruExprShape root) root
                  (app.schema/CirruLeafShape _leaf) (raise |Expected-root-code-expression)
                focus $ decode-map-as
                  .unwrap-or (get router-data :focus) ([])
                  List String
                readonly? false
                close-draft-box! $ fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :draft-box? false
                  , &unit
                close-abstract! $ fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :abstract? false
                  , &unit
                plugin-gen-code-box $ use-gen-code-box (>> states :gen-code-plugin) expr focus
              div
                {} $ :class-name css-page-editor
                if (empty? stack)
                  div
                    {} $ :class-name css-stack
                    <> |Empty style-nothing
                  comp-stack stack pointer
                if (empty? stack)
                  div
                    {} $ :style $ {} (:padding "|12px 0")
                    <> "|Nothing to edit" style-nothing
                  div
                    {} $ :class-name css-editor
                    let
                        others $ ->
                          decode-map-as
                            .unwrap-or (get router-data :others) ({})
                            Map String $ Map Tag Dynamic
                          , distinct-values $ map
                            fn (info)
                              hint-fn $ Fn (Map Tag Dynamic)
                                -> $ List String
                              decode-map-as
                                .unwrap-or (get info :focus) ([])
                                List String
                      div
                        {} $ :class-name css-area
                        div ({})
                          div
                            {} $ :class-name $ str-spaced css/row-parted
                            comp-doc (>> states :doc) expr-entry bookmark
                          comp-expr
                            >> states $ bookmark-full-str bookmark
                            assert-type expr 'app.schema/CirruExprShape
                            , focus ([]) others false :inline readonly? picker-mode? (.unwrap-or theme :star-trail) 0
                        div
                          {}
                            :class-name $ str-spaced css/row-parted
                            :style $ {} $ :margin-top 66
                          span $ {}
                          comp-usages $ match (get router-data :usages)
                            (:none) None
                            (:some raw)
                              if (nil? raw) None $ Some $ app.schema/read-dependency-set raw
                        if-let
                          locals $ match (get router-data :preview-locals)
                            (:none) None
                            (:some raw) (read-preview-locals raw)
                          list->
                            {}
                              :class-name $ str-spaced css/row css/gap8
                              :style $ {} (:margin "|32px 48px") (:flex-wrap :wrap)
                            -> locals &set:to-list (sort &compare)
                              map $ fn (def-name)
                                [] def-name $ comp-local-link
                                  match bookmark
                                    (:ns ns' _f) ns'
                                    (:def ns' _def _f) ns'
                                  , def-name
                          div $ {}
                    let
                        peek-def $ app.schema/read-optional-code-entry $ .unwrap-or (get router-data :peek-def) None
                      match peek-def
                        (:some entry) (comp-peek-def entry)
                        (:none)
                          span $ {}
                    comp-status-bar cursor state states router-data bookmark theme $ fn (d!)
                      hint-fn $ Fn
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      reset-gen-code-box! plugin-gen-code-box d!
                      open-gen-code-box! plugin-gen-code-box d!
                      , &unit
                    if
                      .unwrap-or (get state :draft-box?) false
                      comp-draft-box (>> states :draft-box) expr focus close-draft-box!
                      span $ {}
                    render-gen-code-box plugin-gen-code-box
                    if
                      .unwrap-or (get state :abstract?) false
                      comp-abstract (>> states :abstract) close-abstract!
                      span $ {}
                    ; comp-inspect |Expr router-data style/inspector
                respo.core/show picker-mode? $ comp-picker-notice
                  decode-map-as
                    .unwrap-or (get router-data :picker-choices) ({})
                    Map Tag Dynamic
                  if (struct? expr)
                    app.schema/node-at-path (app.schema/read-node expr)
                      decode-map-as focus $ List String
                    , None
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (List app.bookmark/%bookmark) (Map Tag Dynamic) Number Bool (Option Tag) app.schema/CodeEntry app.bookmark/%bookmark (-> respo.schema/Component) (:features :io)
        'comp-stack $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-stack (stack pointer)
            [] (effect-focus-bookmark pointer)
              respo.core/data-list->
                {} $ :class-name css-stack
                -> stack $ map-indexed $ fn (idx bookmark)
                  hint-fn $ Fn Number app.bookmark/%bookmark $ -> (Tuple Number respo.schema/Component)
                  [] idx $ comp-bookmark bookmark idx $ = idx pointer
          :examples $ []
          :schema $ quote $ Fn (List app.bookmark/%bookmark) Number (-> respo.schema/Component)
        'comp-status-bar $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-status-bar (cursor state states router-data bookmark theme open-gen-code-box)
            let
                old-name $ match bookmark
                  (:def ns' def' f) (str ns' |/ def')
                  (:ns ns' f) (str ns')
                confirm-delete-plugin $ use-confirm (>> states :delete)
                  {} $ :text $ str "|Confirm deleting current path: "
                    match bookmark
                      (:def ns' def' f) (str ns' |/ def')
                      (:ns ns' f) (str "|ns: " ns')
                confirm-reset-plugin $ use-confirm (>> states :reset)
                  {} $ :text "|Confirm reset changes to this expr?"
                rename-plugin $ use-prompt (>> states :rename)
                  {}
                    :text $ str "|Renaming: " old-name
                    :initial old-name
                add-plugin $ use-prompt (>> states :add)
                  {}
                    :text $ str "|Add function name:"
                    :initial |
                replace-plugin $ use-replace-name-modal (>> states :replace)
                  fn (from to d!)
                    hint-fn $ Fn String String
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    d! $ :: :ir/expr-replace $ {} (:bookmark bookmark) (:from from) (:to to)
                others $ decode-map-as
                  .unwrap-or (get router-data :others) ({})
                  Map String $ Map Tag Dynamic
                watchers $ decode-map-as
                  .unwrap-or (get router-data :watchers) ({})
                  Map String $ Map Tag Dynamic
              div
                {} $ :class-name $ str-spaced css/row css/gap8 css-status-bar
                div
                  {} $ :class-name $ str-spaced css/row css/gap8
                  span $ {} (:inner-text |Add)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ fn (_event d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show add-plugin d! $ fn (result)
                        hint-fn $ Fn String $ -> Unit
                        let
                            text $ trim result
                            namespace $ app.bookmark/get-namespace bookmark
                          when-not (blank? text)
                            d! $ :: :ir/add-def $ [] namespace text
                            d! $ :: :writer/edit $ :: :def namespace text
                          , &unit
                        , &unit
                      , &unit
                  if
                    = :same $ .unwrap-or (get router-data :changed) :unknown
                    <>
                      match (get router-data :changed)
                        (:none) (str nil)
                        (:some value) (str value)
                      {} (:font-family ui/font-fancy) (:margin "|0 8px")
                        :color $ hsl 260 60 70
                    span $ {}
                      :class-name $ str-spaced css/font-fancy style-link
                      :inner-text |Reset
                      :on-click $ fn (_event d!)
                        hint-fn $ Fn respo.schema/RespoEvent
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        .show confirm-reset-plugin d! $ fn ()
                          hint-fn $ Fn $ -> Unit
                          on-reset-expr bookmark d!
                          , &unit
                        , &unit
                  span $ {} (:inner-text |Picker-mode)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ fn (_event d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      d! $ :: :writer/picker-mode
                      , &unit
                  span $ {} (:inner-text |Delete)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ fn (_event d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show confirm-delete-plugin d! $ fn ()
                        hint-fn $ Fn $ -> Unit
                        d! $ :: :ir/delete-entry bookmark
                        , &unit
                      , &unit
                  span $ {} (:inner-text |Rename)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ fn (_event d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show rename-plugin d! $ fn (result)
                        hint-fn $ Fn String $ -> Unit
                        on-rename-def result bookmark d!
                        , &unit
                      , &unit
                  span $ {} (:inner-text |Replace)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ fn (_event d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      show-replace-plugin! replace-plugin d!
                      , &unit
                  span $ {} (:inner-text |Draft-box)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ on-draft-box state cursor
                  span $ {} (:inner-text |Gen-code)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ fn (_event d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      open-gen-code-box d!
                      , &unit
                  span $ {} (:inner-text |Exporting)
                    :class-name $ str-spaced css/font-fancy style-link
                    :on-click $ on-path-gen! bookmark
                div
                  {} $ :class-name css/row
                  comp-theme-menu (>> states :theme) theme
                div
                  {} $ :class-name $ str-spaced css/row-middle css/gap8
                  <>
                    str "|Writers(" (count others) "|)"
                    , style-hint
                  list->
                    {} $ :style style-watchers
                    map (&map:to-list others)
                      fn (entry)
                        hint-fn $ Fn
                          Tuple String $ Map Tag Dynamic
                          -> $ List Dynamic
                        let[] (sid member) entry $ [] sid $ <>
                          .unwrap-or
                            app.schema/read-optional-text $ get member :nickname
                            , |
                          , style-watcher
                  <>
                    str "|Watchers(" (count watchers) "|)"
                    , style-hint
                  list->
                    {} $ :style style-watchers
                    map (&map:to-list watchers)
                      fn (entry)
                        hint-fn $ Fn
                          Tuple String $ Map Tag Dynamic
                          -> $ List Dynamic
                        let[] (sid member) entry $ [] sid $ <>
                          .unwrap-or
                            app.schema/read-optional-text $ get member :nickname
                            , |
                          , style-watcher
                .render confirm-delete-plugin
                .render confirm-reset-plugin
                .render rename-plugin
                .render add-plugin
                render-replace-plugin replace-plugin
          :examples $ []
          :schema $ quote $ Fn (List respo.schema/CoordKey) (Map Tag Bool) respo.schema/States (Map Tag Dynamic) app.bookmark/%bookmark (Option Tag)
            Fn
              Fn *dispatch-op $ -> Unit
              -> Unit
            -> respo.schema/Component
            :features :js-ffi
        'comp-usages $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-usages (usages)
            match usages
              (:none)
                span $ {} (:class-name style-placeholder) (:inner-text |orphin)
              (:some entries)
                keyed->
                  {} $ :class-name $ str-spaced css/row style-usages
                  map (&set:to-list entries)
                    fn (usage)
                      hint-fn $ Fn app.schema/DependencyKey $ -> respo.schema/ChildPair
                      match usage
                        (:def namespace name)
                          keyed-element (str namespace |/ name)
                            div
                              {}
                                :class-name $ str-spaced css/column style-usage
                                :on-click $ fn (_event d!)
                                  hint-fn $ Fn respo.schema/RespoEvent
                                    Fn *dispatch-op $ -> Unit
                                    -> Unit
                                  d! $ :: :writer/select $ :: :def namespace name
                              span $ {} (:class-name style-usage-def) (:inner-text name)
                              span $ {} (:class-name style-tiny) (:inner-text namespace)
                        (:reference _namespace _name) (raise "|Expected a dependency usage definition")
          :examples $ []
          :schema $ quote $ Fn
            Option $ Set app.schema/DependencyKey
            -> respo.schema/Component
        'css-area $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-area
            {} $ |$0 $ {} (:position :fixed) (:right 0) (:left 100) (:bottom 0) (:top 0) (:overflow :auto) (:padding-bottom |60vh) (:padding-top 120) (:flex 1) (:padding-right 8)
              :background-color $ hsl 0 0 0 0.4
          :examples $ []
          :schema $ quote String
        'css-editor $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-editor
            {} $ |$0 $ merge
              assert-type ui/flex $ Map Tag Dynamic
              assert-type ui/column $ Map Tag Dynamic
              {} (:position :absolute) (:left 100)
          :examples $ []
          :schema $ quote String
        'css-page-editor $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-page-editor
            {} $ |$0 $ merge
              assert-type ui/row $ Map Tag Dynamic
              assert-type ui/flex $ Map Tag Dynamic
              {} $ :z-index 80
          :examples $ []
          :schema $ quote String
        'css-stack $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-stack
            {}
              |$0 $ {} (:overflow :auto) (:padding "|48px 0 80px 0") (:opacity 0.8) (:position :relative) (:box-shadow "|0 0 4px black")
                :background-color $ hsl 0 0 0 0.6
              |$0:hover $ {} (:opacity 1) (:z-index 100)
          :examples $ []
          :schema $ quote String
        'css-status-bar $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-status-bar
            {}
              |$0 $ merge ui/row $ {} (:justify-content :space-between) (:padding "|0 8px") (:position :fixed) (:bottom 0) (:right 0) (:opacity 0.4) (:transition-duration |240ms) (:transition-property |opacity)
                :background-color $ hsl 0 0 0 0.5
              |$0:hover $ {} $ :opacity 1
          :examples $ []
          :schema $ quote String
        'effect-focus-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defeffect effect-focus-bookmark (pointer) (action el at?)
            if (= action :update)
              let
                  host-el $ unsafe-coerce el 'app.comp.page-editor/BookmarkElementHost
                  target-opt $ js-nullish->option $ .query-selector host-el |.selected-bookmark
                match target-opt
                  (:some target) (.scroll-into-view-if-needed target)
                  (:none) &unit
          :examples $ []
          :schema $ quote $ Fn Number (-> respo.schema/Effect) (:features :js-ffi)
        'initial-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def initial-state
            {} $ :draft-box? false
          :examples $ []
          :schema $ quote $ Map Tag Bool
        'on-draft-box $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-draft-box (state cursor)
            fn (_event dispatch!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              app.client-updater/dispatch-ui! dispatch! $ app.client-updater/UiStateOp :states cursor $ assoc state :draft-box?
                not $ .unwrap-or (get state :draft-box?) false
              js-ffi.browser/set-timeout!
                fn () $ match (js-ffi.browser/query-selector |.el-draft-box)
                  (:some element) (js-ffi.browser/element-focus! element)
                  (:none) &unit
                , 0
              , &unit
          :examples $ []
          :schema $ quote $ Fn (Map Tag Bool) (List respo.schema/CoordKey) (-> respo.schema/EventHandler)
        'on-path-gen! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-path-gen! (bookmark)
            fn (_event d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              match bookmark
                (:def ns' def' f)
                  let
                      code $ [] $ [] ns' |:refer ([] def')
                    do-copy-logics! d! (format-cirru code) (str "|Copied path of " def')
                (:ns the-ns f)
                  let
                      code $ [] $ [] the-ns |:as
                        .unwrap-or
                          last $ split the-ns |.
                          , the-ns
                    do-copy-logics! d! (format-cirru code) (str "|Copied path of " the-ns)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (-> respo.schema/EventHandler)
        'on-rename-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-rename-def (new-name bookmark d!)
            when-not (blank? new-name)
              d! $ :: :ir/rename $ match bookmark
                (:def ns' def' f)
                  let[] (ns-text def-text) (split new-name |/)
                    {} (:kind :def)
                      :ns $ {} (:from ns') (:to ns-text)
                      :extra $ {} (:from def') (:to def-text)
                (:ns ns' f)
                  {} (:kind :ns)
                    :ns $ {} (:from ns') (:to new-name)
            , &unit
          :examples $ []
          :schema $ quote $ Fn String app.bookmark/%bookmark
            Fn *dispatch-op $ -> Unit
            -> Unit
        'on-reset-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-reset-expr (bookmark d!)
            d! $ :: :ir/reset-at $ match bookmark
              (:ns ns' f) (:: :ns ns')
              (:def ns' def' f) (:: :def ns' def')
            app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states/clear
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark
            Fn *dispatch-op $ -> Unit
            -> Unit
        'read-preview-locals $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-preview-locals (raw)
            if (nil? raw) None $ if (set? raw)
              Some $ decode-map-as raw $ Set String
              match raw
                (:some locals)
                  Some $ decode-map-as locals $ Set String
                (:none) None
                _ $ raise |Expected-optional-preview-locals
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ Option $ Set String
        'style-doc $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-doc
            {}
              |& $ {}
                :color $ hsl 0 0 100 0.6
                :transition-duration |200ms
                :line-height |20px
              "|& .md-p" $ {} $ :margin-bottom 12
              "|& div>code" $ {} (:font-family ui/font-code) (:border-radius |6px) (:margin "|0 2px") (:padding "|2px 6px") (:font-size 12)
                :border $ str "|1px solid " $ hsl 0 0 98 0.25
              "|& .md-code-block" $ {} (:font-family ui/font-code) (:border-radius |6px) (:margin "|0 0 8px 8px") (:padding "|6px 24px 6px 8px") (:width :fit-content) (:font-size 12)
                :color $ hsl 0 0 50
                :border $ str "|1px solid " $ hsl 0 0 98 0.18
              "|& a[href]" $ {} (:pointer-events :none)
                :color $ hsl 230 80 70
              "|& img" $ {} (:max-height 400) (:max-width 400) (:transform "|scale(1)") (:border-radius |34x)
                :box-shadow $ str "|0 0 3px " $ hsl 0 0 100 0.5
              |&:hover $ {} $ :color (hsl 0 0 100 1)
          :examples $ []
          :schema $ quote String
        'style-doc-empty $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-doc-empty
            {} $ |& $ {} (:font-style :italic) (:opacity 0.5)
          :examples $ []
          :schema $ quote String
        'style-hint $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-hint
            {}
              :color $ hsl 0 0 100 0.6
              :font-family ui/font-fancy
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-link $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-link
            {} $ |& $ {} (:cursor :pointer) (:font-size 14)
              :color $ hsl 200 50 80
          :examples $ []
          :schema $ quote String
        'style-local-link $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-local-link
            {}
              |& $ {} (:white-space :nowrap) (:margin "|0 2px")
              |span& $ {} $ :color (hsl 200 40 64)
              |span&:hover $ {} $ :color (hsl 200 60 76)
          :examples $ []
          :schema $ quote String
        'style-missing $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-missing
            {} (:font-family "|Josefin Sans")
              :color $ hsl 10 60 50
              :font-size 20
              :font-weight 100
          :examples $ []
          :schema $ quote $ Map Tag respo-ui.schema/StyleValue
        'style-nothing $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-nothing
            {}
              :color $ hsl 0 0 100 0.4
              :padding "|0 16px"
              :font-family "|Josefin Sans"
          :examples $ []
          :schema $ quote respo.schema/TextStyle
        'style-placeholder $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-placeholder
            {} $ :& $ {} (:font-size 12) (:font-style :italic)
              :color $ hsl 0 0 36
              :line-height |1
          :examples $ []
          :schema $ quote String
        'style-tiny $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-tiny
            {} $ :& $ {} (:font-size 12)
              :color $ hsl 0 0 36
              :line-height |1
          :examples $ []
          :schema $ quote String
        'style-usage $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-usage
            {}
              :& $ {} (:margin-right 8) (:opacity 0.8) (:cursor :pointer)
                :color $ hsl 0 0 80
              :&:hover $ {} $ :opacity 1
          :examples $ []
          :schema $ quote String
        'style-usage-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-usage-def
            {} $ :& $ {} (:line-height |20px)
          :examples $ []
          :schema $ quote String
        'style-usages $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-usages
            {} $ |& $ {} (:max-width |80%) (:justify-content :flex-end) (:flex-wrap :wrap) (:row-gap 12)
          :examples $ []
          :schema $ quote String
        'style-watcher $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-watcher
            {}
              :color $ hsl 0 0 100 0.7
              :margin-left 8
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-watchers $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-watchers
            {} (:display |inline-block) (:align-items |stretch) (:flex-direction |row)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'ui-missing $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def ui-missing
            div
              {} $ :style style-missing
              <> "|Expression is missing!"
          :examples $ []
          :schema $ quote Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.page-editor
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp defeffect list-> >> <> span div a pre keyed-> keyed-element
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
            app.comp.replace-name :refer $ use-replace-name-modal show-replace-plugin! render-replace-plugin
            app.comp.picker-notice :refer $ comp-picker-notice
            respo-md.comp.md :refer $ comp-md-block
            app.comp.gen-code-box :refer $ use-gen-code-box reset-gen-code-box! open-gen-code-box! render-gen-code-box
    'app.comp.page-files $ %{} 'FileEntry
      :defs $ {}
        'comp-file $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-file (states selected-ns defs-dict highlights configs)
            let
                cursor $ respo.core/state-cursor states
                state $ respo.core/pick-state states
                  quote $ Map Tag String
                  {} $ :def-text |
                duplicate-plugin $ use-prompt (>> states :duplicate)
                  {} (:initial selected-ns) (:text "|a namespace:")
                add-plugin $ use-prompt (>> states :add)
                  {} $ :text "|New definition:"
              div
                {} $ :class-name $ str-spaced css/column css-file
                div ({}) (<> |File style/title) (=< 16 nil)
                  span $ {} (:inner-text |Draft) (:class-name style/button)
                    :on-click $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      d! $ :: :writer/draft-ns selected-ns
                      , &unit
                  span $ {} (:inner-text |Clone) (:class-name style/button)
                    :on-click $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show duplicate-plugin d! $ fn (raw-result)
                        hint-fn $ Fn Dynamic $ -> Unit
                        let
                            result $ decode-map-as raw-result 'String
                          if
                            &str:includes? (decode-map-as result 'String) |.
                            d! $ :: :ir/clone-ns result
                            d! $ :: :notify/push-message $ [] :warn (str "|Not a good name: " result)
                        , &unit
                      , &unit
                div ({})
                  span $ {} (:inner-text selected-ns) (:style style-link)
                    :on-click $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      d! $ :: :writer/edit $ :: :ns selected-ns
                      , &unit
                  =< 16 nil
                  comp-icon :plus
                    {} (:font-size 14)
                      :color $ hsl 0 0 70
                      :cursor :pointer
                    fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show add-plugin d! $ fn (raw-result)
                        hint-fn $ Fn Dynamic $ -> Unit
                        let
                            result $ decode-map-as raw-result 'String
                          let
                              text $ trim result
                            when-not (blank? text)
                              d! $ :: :ir/add-def $ [] selected-ns text
                        , &unit
                      , &unit
                ; div ({})
                  input $ {}
                    :value $ .unwrap-or (get state :def-text) |
                    :placeholder |filter...
                    :style style-input
                    :on-input $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      d! $ app.client-updater/UiStateOp :states cursor $ assoc state :def-text (:value e)
                      , &unit
                =< nil 8
                list->
                  {} (:class-name css/expand)
                    :style $ {} $ :padding-bottom 120
                  -> defs-dict keys (&set:to-list)
                    filter $ fn (def-text)
                      &str:includes? (assert-type def-text String)
                        .unwrap-or (get state :def-text) |
                    sort &compare
                    map $ fn (def-text)
                      [] def-text $ let
                          confirm-remove-plugin $ use-confirm
                            >> states $ str :rm def-text
                            {} $ :text $ str "|Sure to remove def: " def-text "| ?"
                        div
                          {}
                            :class-name $ str-spaced css/row-parted style-def |hoverable
                            :style $ if
                              any? (&set:to-list highlights)
                                fn (bookmark)
                                  hint-fn $ Fn app.bookmark/%bookmark $ -> Bool
                                  match bookmark
                                    (:def namespace definition focus)
                                      and (= namespace selected-ns) (= definition def-text)
                                    (:ns namespace focus) false
                              {} $ :color :white
                              {}
                            :on-click $ fn (e d!)
                              hint-fn $ Fn respo.schema/RespoEvent
                                Fn *dispatch-op $ -> Unit
                                -> Unit
                              d! $ :: :writer/edit $ :: :def selected-ns def-text
                              , &unit
                          div
                            {} $ :class-name css/row
                            <> def-text
                            =< 8 nil
                            <>
                              &str:replace
                                .unwrap-or (get defs-dict def-text) |
                                , &newline |
                              , style-def-doc
                          =< 16 nil
                          span
                            {}
                              :class-name $ str-spaced |is-minor style-remove
                              :on-click $ fn (e d!)
                                hint-fn $ Fn respo.schema/RespoEvent
                                  Fn *dispatch-op $ -> Unit
                                  -> Unit
                                .show confirm-remove-plugin d! $ fn () $ d! (:: :ir/remove-def def-text)
                                , &unit
                            comp-i :x 12 $ hsl 0 0 80 0.5
                          .render confirm-remove-plugin
                .render duplicate-plugin
                .render add-plugin
          :examples $ []
          :schema $ quote $ Fn respo.schema/States String (Map String String) (Set app.bookmark/%bookmark) (Map Tag Dynamic) (-> respo.schema/Component)
        'comp-namespace-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-namespace-list (states ns-dict selected-ns ns-highlights)
            let
                state $ respo.core/pick-state states
                  quote $ Map Tag Dynamic
                  {}
                filter-text $ decode-map-as
                  .unwrap-or (get state :ns-text) |
                  , 'String
                plugin-add-ns $ use-prompt (>> states :add-ns)
                  {} $ :text "|New namespace:"
              div
                {} $ :class-name $ str-spaced css/column style-list
                div
                  {} $ :class-name style/title
                  <> |Namespaces
                  =< 8 nil
                  comp-icon :plus
                    {} (:size 14)
                      :color $ hsl 0 0 70
                      :style $ {} $ :cursor :pointer
                    fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .show plugin-add-ns d! $ fn (result)
                        hint-fn $ Fn Dynamic $ -> Unit
                        let
                            text $ trim $ decode-map-as result 'String
                          when-not (blank? text)
                            d! $ :: :ir/add-ns text
                          , &unit
                      , &unit
                =< nil 8
                respo.core/data-list->
                  {} (:class-name css/expand)
                    :style $ {} $ :padding-bottom 120
                  map (namespace-entries ns-dict filter-text)
                    fn (pair)
                      hint-fn $ Fn (Tuple String String)
                        -> $ Tuple String respo.schema/Component
                      let[] (ns-text ns-doc) pair $ [] ns-text $ comp-ns-entry (>> states ns-text) ns-text ns-doc
                        = selected-ns $ Some ns-text
                        , ns-highlights
                .render plugin-add-ns
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Map String String) (Option String) (Set String) (-> respo.schema/Component)
        'comp-ns-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-ns-entry (states ns-text ns-doc selected? ns-highlights)
            let
                plugin-rm-ns $ use-confirm (>> states :rm-ns)
                  {} $ :text $ str "|Sure to remove namespace: " ns-text "| ?"
                has-highlight? $ includes? ns-highlights ns-text
              div
                {}
                  :class-name $ str-spaced css/row-parted style-ns $ if selected? "|hoverable is-selected" |hoverable
                  :style $ if has-highlight?
                    {} $ :color :white
                    {}
                  :on-click $ fn (e d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    d! $ :: :session/select-ns ns-text
                    , &unit
                let
                    pieces $ split ns-text |.
                  span ({})
                    <>
                      str
                        join-string (butlast pieces) |.
                        , |.
                      {} $ :color $ if has-highlight? (hsl 0 0 76) (hsl 0 0 50)
                    <> $ .unwrap-or (last pieces) |
                    =< 8 nil
                    <> ns-doc style-ns-doc
                span
                  {}
                    :class-name $ str-spaced |is-minor style-remove
                    :on-click $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      .prevent-default! $ js-ffi.browser/mouse-event-host $ :original-event e
                      .show plugin-rm-ns d! $ fn () $ d! (:: :ir/remove-ns ns-text)
                      , &unit
                  comp-i :x 12 $ hsl 0 0 80 0.6
                .render plugin-rm-ns
          :examples $ []
          :schema $ quote $ Fn respo.schema/States String String Bool (Set String) (-> respo.schema/Component) (:features :js-ffi)
        'comp-page-files $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-page-files (states selected-ns router-data)
            let
                highlights $ distinct-values $ filter-map-kv
                  decode-map-as
                    .unwrap-or (get router-data :highlights) ({})
                    Map String Dynamic
                  fn (sid raw)
                    hint-fn $ Fn String Dynamic $ -> (MapEntryDecision String app.bookmark/%bookmark)
                    MapEntryDecision :keep sid $ app.bookmark/read-bookmark raw
                ns-highlights $ map highlights $ fn (bookmark)
                  hint-fn $ Fn app.bookmark/%bookmark $ -> String
                  match bookmark
                    (:ns namespace focus) namespace
                    (:def namespace definition focus) namespace
                peeking-file $ app.schema/read-optional-file-entry $ .unwrap-or (get router-data :peeking-file) None
              div
                {} $ :class-name $ str-spaced css/flex css/row style-container
                comp-namespace-list (>> states :ns)
                  decode-map-as
                    .unwrap-or (get router-data :ns-dict) {}
                    Map String String
                  , selected-ns ns-highlights
                =< 24 nil
                if (.some? selected-ns)
                  comp-file
                    >> states $ .unwrap selected-ns
                    .unwrap selected-ns
                    decode-map-as
                      .unwrap-or (get router-data :defs-dict) {}
                      Map String String
                    , highlights $ decode-map-as
                      .unwrap-or (get router-data :file-configs) {}
                      Map Tag Dynamic
                  render-empty
                =< 32 nil
                comp-changed-files (>> states :files)
                  decode-map-as
                    .unwrap-or (get router-data :changed-files) {}
                    Map String Dynamic
                ; comp-inspect selected-ns router-data style-inspect
                match peeking-file
                  (:some file)
                    comp-file-replacer (>> states :replacer) file $ decode-map-as
                      .unwrap-or (get router-data :source-templates) ({})
                      Map Tag String
                  (:none) (render-empty)
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Option String) (Map Tag Dynamic) (-> respo.schema/Component) (:features :io)
        'css-file $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-file
            {} $ |$0 $ {} (:width 360) (:overflow :auto) (:padding-top 24)
          :examples $ []
          :schema $ quote String
        'namespace-entries $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn namespace-entries (ns-dict filter-text)
            -> ns-dict (&map:to-list)
              filter $ fn (pair)
                hint-fn $ Fn (Tuple String String) (-> Bool)
                includes?
                  join-string
                    rest $ split (nth pair 0) |.
                    , |.
                  , filter-text
              sort $ fn (a b)
                hint-fn $ Fn (Tuple String String) (Tuple String String) (-> Number)
                &compare (nth a 0) (nth b 0)
          :examples $ []
          :schema $ quote $ Fn (Map String String) String
            -> $ List $ Tuple String String
          :tests $ [] $ %{} 'TestEntry (:name |typed-namespace-order-doc-and-filter)
            :code $ quote $ let
                entries $ {} (|z.main "|末尾🐈") (|a.other |Other) (|a.main |Main) (|solo |Single)
              assert=
                [] ([] |a.main |Main) ([] |a.other |Other) ([] |solo |Single) ([] |z.main "|末尾🐈")
                namespace-entries entries |
              assert=
                [] ([] |a.main |Main) ([] |z.main "|末尾🐈")
                namespace-entries entries |main
              assert= ([]) (namespace-entries entries |missing)
              assert= ([])
                namespace-entries ({}) |
            :tags $ #{} :unit
        'render-empty $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-empty ()
            div
              {} (:class-name css/font-fancy)
                :style $ {} (:width 280)
                  :color $ hsl 0 0 100 0.5
                  :padding "|60px 0"
              <> |Empty
          :examples $ []
          :schema $ quote $ Fn (-> respo.schema/Element)
        'style-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-container
            {} $ |& $ {} (:padding "|0px 16px")
          :examples $ []
          :schema $ quote String
        'style-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-def
            {}
              |& $ {} (:padding "|0 8px") (:position :relative)
                :color $ hsl 0 0 74
                :border-radius |8px
              (str "|& ." style-remove)
                {} (:opacity 0) (:transition-duration |200ms)
              (str "|&:hover ." style-remove)
                {} $ :opacity 1
          :examples $ []
          :schema $ quote String
        'style-def-doc $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-def-doc
            {} $ |& $ {}
              :color $ hsl 0 0 100 0.5
              :max-width |120px
              :overflow :hidden
              :white-space :nowrap
              :text-overflow :ellipsis
              :font-family ui/font-fancy
              :white-space :nowrap
          :examples $ []
          :schema $ quote String
        'style-inspect $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-inspect
            {} (:opacity 1)
              :background-color $ hsl 0 0 100
              :color :black
          :examples $ []
          :schema $ quote $ Map Tag respo-ui.schema/StyleValue
        'style-link $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-link
            {} $ :cursor :pointer
          :examples $ []
          :schema $ quote $ Map Tag respo-ui.schema/StyleValue
        'style-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-list
            {} $ |& $ {} (:width 360) (:overflow :auto) (:padding-top 24)
          :examples $ []
          :schema $ quote String
        'style-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-ns
            {}
              |& $ {} (:cursor :pointer) (:vertical-align :middle) (:position :relative) (:padding "|0 8px")
                :color $ hsl 0 0 74 1
                :border-radius |8px
              (str "|& ." style-remove)
                {} (:opacity 0) (:transition-duration |200ms)
              (str "|&:hover ." style-remove)
                {} $ :opacity 1
          :examples $ []
          :schema $ quote String
        'style-ns-doc $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-ns-doc
            {} $ |& $ {}
              :color $ hsl 0 0 100 0.5
              :white-space :nowrap
              :max-width |120px
              :display :inline-block
              :overflow :hidden
              :text-overflow :ellipsis
              :vertical-align :middle
              :font-family ui/font-fancy
          :examples $ []
          :schema $ quote String
        'style-remove $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-remove
            {}
              |& $ {}
                :color $ hsl 0 50 70
                :font-size 12
                :cursor :pointer
                :vertical-align :middle
                :line-height |12px
              |&:hover $ {}
                :color $ hsl 0 50 90
                :transform "|scale(1.1)"
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.page-files
          :require
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
    'app.comp.page-members $ %{} 'FileEntry
      :defs $ {}
        'comp-page-members $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-page-members (router-data session-id)
            div
              {} (:class-name css/flex) (:style style-members)
              respo.core/data-list-> ({})
                -> (&map:to-list router-data)
                  map $ fn (entry)
                    hint-fn $ Fn (Tuple String Dynamic)
                      -> $ Tuple String respo.schema/Element
                    let[] (id raw-member) entry $ let
                        member $ decode-map-as raw-member $ Map Tag Dynamic
                        user $ decode-map-as
                          .unwrap-or (get member :user) ({})
                          Map Tag Dynamic
                        name $ .unwrap-or
                          app.schema/read-optional-text $ get user :nickname
                          , |Guest
                        bookmark $ app.bookmark/read-optional-bookmark $ .unwrap-or (get member :bookmark) None
                        page $ decode-map-as
                          .unwrap-or (get member :page) :unknown
                          , 'Tag
                      [] id $ div
                        {} (:class-name style-row)
                          :on-click $ on-watch id
                        <>
                          str name $ if (= id session-id) "| (yourself)" |
                          , style-name
                        =< 32 nil
                        <> (str page) style-page-name
                        =< 32 nil
                        match bookmark
                          (:some value)
                            <> (app.bookmark/preview value) style-bookmark
                          (:none)
                            div $ {}
                        =< 32 nil
                        respo.core/show (= id session-id)
                          a
                            {}
                              :href $ watching-url (js-ffi.browser/location-href) id
                              :target |_blank
                              :style $ {} $ :color (hsl 240 80 80)
                            <> "|Watching url"
          :examples $ []
          :schema $ quote $ Fn (Map String Dynamic) String (-> respo.schema/Component) (:features :js-ffi)
        'on-watch $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-watch (session-id)
            fn (event dispatch!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              dispatch! $ app.updater.router/route-op $ app.updater.router/Route :watching session-id
          :examples $ []
          :schema $ quote $ Fn String
            -> $ Fn respo.schema/RespoEvent
              Fn *dispatch-op $ -> Unit
              -> Unit
        'style-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-bookmark
            {} (:font-family |Menlo,monospace) (:min-width 200) (:display :inline-block)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-members $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-members
            {} $ :padding "|40px 16px 0 16px"
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-name $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-name
            {} (:min-width 160) (:display :inline-block)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-page-name $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-page-name
            {} $ |& $ {} (:min-width 160) (:display :inline-block)
          :examples $ []
          :schema $ quote String
        'style-row $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-row
            {}
              |& $ {} (:cursor :pointer) (:padding "|0 8px") (:border-radius |4px) (:transition-duration |300ms)
              |&:hover $ {} $ :background-color (hsl 0 0 100 0.14)
          :examples $ []
          :schema $ quote String
        'watching-url $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn watching-url (href session-id)
            let
                url $ js-ffi.shared/url-snapshot $ js-ffi.shared/url-create href href
                params $ js-ffi.shared/search-params-create $ :search url
              .set! params |watching session-id
              .to-string $ js-ffi.shared/url-create
                str (:pathname url) |? (.to-string params) (:hash url)
                :href url
          :examples $ []
          :schema $ quote $ Fn String String (-> String) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.page-members
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp <> list-> span div a
            respo.comp.space :refer $ =<
            app.bookmark :refer $ Bookmark
    'app.comp.peek-def $ %{} 'FileEntry
      :defs $ {}
        'comp-peek-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-peek-def (entry)
            let
                doc $ :doc entry
                simple-expr $ app.schema/read-node $ :code entry
              div
                {} $ :class-name $ str-spaced css/row style-peek-def
                <>
                  stringify-s-expr $ tree->cirru simple-expr
                  {} (:font-family "|Source Code Pro, Iosevka,Consolas,monospace") (:white-space :nowrap) (:overflow :hidden) (:text-overflow :ellipsis) (:max-width 480)
                =< 8 nil
                if (blank? doc) (<> |...doc... style-empty-doc) (<> doc style-doc)
                comp-icon :delete
                  {} (:font-size 14)
                    :color $ hsl 0 90 70
                    :cursor :pointer
                    :margin-left 8
                  fn (_event dispatch!)
                    dispatch! $ :: :writer/hide-peek nil
                    , &unit
          :examples $ []
          :schema $ quote $ Fn app.schema/CodeEntry (-> respo.schema/Component)
        'style-doc $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-doc
            {} $ |& $ {} (:font-family ui/font-fancy)
          :examples $ []
          :schema $ quote String
        'style-empty-doc $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-empty-doc
            {} $ |& $ {} (:font-style :italic) (:opacity 0.6)
          :examples $ []
          :schema $ quote String
        'style-peek-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-peek-def
            {}
              |& $ {} (:align-items :center) (:font-size 12) (:line-height |1.5em) (:position :fixed) (:bottom 4) (:opacity 0.5)
              |&:hover $ {} $ :opacity 1
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.peek-def
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp >> <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            app.util :refer $ stringify-s-expr tree->cirru
            feather.core :refer $ comp-icon
            respo-ui.css :as css
            respo.css :refer $ defstyle
    'app.comp.picker-notice $ %{} 'FileEntry
      :defs $ {}
        'comp-picker-notice $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-picker-notice (choices target-node)
            let
                imported-names $ decode-map-as
                  .unwrap-or (get choices :imported) ({})
                  Map String $ List String
                defined-names $ decode-map-as
                  .unwrap-or (get choices :defined) (#{})
                  Set String
                render-code $ fn (text)
                  hint-fn $ Fn String $ -> respo.schema/Element
                  span $ {} (:inner-text text) (:class-name css-name-code)
                    :on-click $ fn (e d!)
                      hint-fn $ Fn respo.schema/RespoEvent
                        Fn *dispatch-op $ -> Unit
                        -> Unit
                      d! $ :: :writer/pick-node text
                hint $ match target-node
                  (:none) |
                  (:some node)
                    match node
                      (app.schema/CirruLeafShape leaf) (:text leaf)
                      (app.schema/CirruExprShape _expr) |
                hint-func $ fn (text)
                  hint-fn $ Fn String $ -> Bool
                  if (blank? hint) true $ includes? text hint
              div
                {} $ :class-name css-picker-container
                div
                  {} $ :class-name css-picker-tip
                  <> "|Picker mode..."
                comp-icon :x
                  {} (:size 18)
                    :color $ hsl 200 80 70 0.6
                    :style $ {} (:cursor :pointer) (:position :absolute) (:top 4) (:right 4)
                  fn (e d!)
                    hint-fn $ Fn respo.schema/RespoEvent
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    d! $ :: :writer/picker-mode
                respo.core/data-list->
                  {} $ :class-name style-list-container
                  -> imported-names (&map:to-list)
                    filter $ fn (pair)
                      hint-fn $ Fn
                        Tuple String $ List String
                        -> Bool
                      any? (nth pair 1) hint-func
                    sort $ fn (a b)
                      hint-fn $ Fn
                        Tuple String $ List String
                        Tuple String $ List String
                        -> Number
                      let
                          compared $ &compare
                            .len $ nth a 1
                            .len $ nth b 1
                        if (= 0 compared)
                          &compare (nth a 0) (nth b 0)
                          , compared
                    map $ fn (pair)
                      hint-fn $ Fn
                        Tuple String $ List String
                        -> $ Tuple String respo.schema/Element
                      let[] (namespace names) pair $ [] namespace $ respo.core/data-list->
                        {} (:title namespace) (:class-name style-list-container)
                        map names $ fn (text)
                          hint-fn $ Fn String $ -> (Tuple String respo.schema/Element)
                          [] text $ render-code text
                =< nil 6
                let
                    names $ -> defined-names (&set:to-list) (filter hint-func) (sort)
                  respo.core/show
                    not $ empty? names
                    respo.core/data-list->
                      {} $ :class-name style-list-container
                      map names $ fn (text)
                        hint-fn $ Fn String $ -> (Tuple String respo.schema/Element)
                        [] text $ render-code text
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Option schema/CirruNode) (-> respo.schema/Component) (:features :js-ffi)
        'css-name-code $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-name-code
            {}
              |$0 $ {} (:font-family ui/font-code) (:cursor :pointer) (:font-size 11) (:margin-bottom 4) (:word-break :none) (:line-height |12px) (:border-radius |4px)
                :color $ hsl 0 0 90
                :background-color $ hsl 0 0 50 0.2
                :padding "|2px 2px"
                :display :inline-block
              |$0:hover $ {}
                :background-color $ hsl 0 0 30 1
                :color $ hsl 0 0 100
          :examples $ []
          :schema $ quote String
        'css-picker-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-picker-container
            {} $ |$0 $ merge ui/column
              {} (:padding "|2px 4px") (:position :fixed) (:line-height |1.6em) (:top 6) (:left |50%) (:transform "|translate(-50%,0)") (:margin |auto) (:z-index 100) (:border-radius |4px) (:max-width |66vw) (:min-height |40px) (:min-width |200px)
                :border $ str "|1px solid " $ hsl 0 0 70 0.4
                :background-color $ hsl 0 0 20 0.7
          :examples $ []
          :schema $ quote String
        'css-picker-tip $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-picker-tip
            {} $ |$0 $ {} (:font-family ui/font-fancy) (:font-size 28) (:font-weight 300) (:line-height |21px) (:cursor :pointer) (:position :absolute) (:right 4) (:bottom 4) (:z-index -1)
              :color $ hsl 0 0 90 0.4
          :examples $ []
          :schema $ quote String
        'style-list-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-list-container
            {} $ |$0 $ merge ui/row
              {} (:flex-wrap :wrap) (:column-gap |4px)
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.picker-notice
          :require
            respo.core :refer $ defcomp list-> >> <> span div a pre
            respo-ui.core :as ui
            respo.util.format :refer $ hsl
            respo.css :refer $ defstyle
            respo.comp.space :refer $ =<
            feather.core :refer $ comp-icon
            app.schema :as schema
    'app.comp.profile $ %{} 'FileEntry
      :defs $ {}
        'comp-profile $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-profile (states user sid router-data)
            let
                rename-plugin $ use-prompt (>> states :rename)
                  {}
                    :initial $ .unwrap-or (get user :nickname) |
                    :text "|Pick a nickname:"
              div
                {}
                  :class-name $ str-spaced css/row css/flex
                  :style $ {} $ :padding "|24px 16px"
                div
                  {} $ :class-name css/flex
                  div ({})
                    <>
                      str "|Hello! " $ .unwrap-or (get user :nickname) |
                      str-spaced css/font-fancy style-greet
                    =< 4 nil
                    comp-icon :edit-2
                      {} (:font-size 14)
                        :color $ hsl 0 0 40
                        :cursor :pointer
                      fn (e d!)
                        hint-fn $ Fn respo.schema/RespoEvent
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        .show rename-plugin d! $ fn (raw-result)
                          hint-fn $ Fn Dynamic $ -> Unit
                          let
                              result $ decode-map-as raw-result 'String
                            d! $ :: :user/nickname $ trim result
                          , &unit
                        , &unit
                    =< 8 nil
                    <>
                      str "|id: " $ .unwrap-or (get user :name) |
                      , style-id
                  =< nil 80
                  div ({})
                    button $ {} (:inner-text "|Log out") (:class-name style/button) (:on-click on-log-out)
                  .render rename-plugin
                div
                  {} (:class-name css/flex)
                    :style $ {} $ :flex 3
                  comp-page-members
                    decode-map-as
                      .unwrap-or (get router-data :members) {}
                      Map String Dynamic
                    , sid
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Map Tag Dynamic) String (Map Tag Dynamic) (-> respo.schema/Component)
        'on-log-out $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-log-out (e dispatch!)
            dispatch! $ :: :user/log-out nil
            js-ffi.browser/storage-remove! $ :storage-key config/site
            , &unit
          :examples $ []
          :schema $ quote $ Fn respo.schema/RespoEvent
            Fn *dispatch-op $ -> Unit
            -> Unit
            :features :js-ffi
        'style-greet $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-greet
            {} $ |& $ {} (:font-size 40) (:font-weight 100)
              :color $ hsl 0 0 100 0.8
          :examples $ []
          :schema $ quote String
        'style-id $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-id
            {} (:font-family "|Josefin Sans") (:font-weight 100)
              :color $ hsl 0 0 60
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.profile
          :require
            respo.util.format :refer $ hsl
            app.schema :as schema
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp >> <> span div button input a
            respo.comp.space :refer $ =<
            app.style :as style
            app.config :as config
            feather.core :refer $ comp-i comp-icon
            respo-alerts.core :refer $ use-prompt
            respo.css :refer $ defstyle
            app.comp.page-members :refer $ comp-page-members
    'app.comp.replace-name $ %{} 'FileEntry
      :defs $ {}
        '%rename-plugin $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def %rename-plugin (impl-traits %rename-plugin0 RenamePluginImpl)
          :examples $ []
          :schema $ quote EnumDef
        '%rename-plugin0 $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def %rename-plugin0
            defenum %rename-plugin0 $ :rename-plugin respo.schema/Component (List Tag) RenameState
          :examples $ []
          :schema $ quote EnumDef
        'RenamePluginImpl $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defimpl RenamePluginImpl RenamePluginTrait
            .render $ fn (self)
              hint-fn $ Fn app.comp.replace-name/%rename-plugin0 $ -> respo.schema/Component
              match self $
                :rename-plugin node cursor s
                , node
            .show $ fn (self d!)
              hint-fn $ Fn app.comp.replace-name/%rename-plugin0
                Fn *dispatch-op $ -> Unit
                -> Unit
              match self $
                :rename-plugin node cursor state
                do
                  app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc
                    assoc (assoc state :old-name |) :new-name |
                    , :show? true
                  js-ffi.browser/set-timeout!
                    fn ()
                      hint-fn $ Fn $ -> Unit
                      select-replace-input!
                    , 0
                  , &unit
            .close $ fn (self d!)
              hint-fn $ Fn app.comp.replace-name/%rename-plugin0
                Fn *dispatch-op $ -> Unit
                -> Unit
              match self $
                :rename-plugin node cursor state
                app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :show? false
          :examples $ []
          :schema $ quote Impl
        'RenamePluginTrait $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait RenamePluginTrait
            .render $ Fn app.comp.replace-name/%rename-plugin0 $ -> respo.schema/Component
            .show $ Fn app.comp.replace-name/%rename-plugin0
              Fn *dispatch-op $ -> Unit
              -> Unit
            .close $ Fn app.comp.replace-name/%rename-plugin0
              Fn *dispatch-op $ -> Unit
              -> Unit
          :examples $ []
          :schema $ quote Trait
        'RenameState $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct RenameState (:old-name String) (:new-name String) (:show? Bool)
          :examples $ []
          :schema $ quote StructDef
        'ReplaceInputHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait ReplaceInputHost
            .select! $ Fn app.comp.replace-name/ReplaceInputHost $ -> Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :select! |select
          :schema $ quote Trait
        'render-replace-plugin $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-replace-plugin (plugin) (.render plugin)
          :examples $ []
          :schema $ quote $ Fn app.comp.replace-name/%rename-plugin (-> respo.schema/Component)
        'select-replace-input! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn select-replace-input! ()
            match (js-ffi.browser/query-selector |#replace-input)
              (:some el)
                .select! $ js-ffi.browser/selectable-element-host el
              (:none) &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'show-replace-plugin! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn show-replace-plugin! (plugin d!) (.show plugin d!)
          :examples $ []
          :schema $ quote $ Fn app.comp.replace-name/%rename-plugin
            Fn *dispatch-op $ -> Unit
            -> Unit
        'use-replace-name-modal $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn use-replace-name-modal (states on-replace)
            let
                cursor $ decode-map-as
                  .unwrap-or (app.schema/map-field states :cursor) ([])
                  List Tag
                state $ decode-map-as
                  merge
                    {} (:old-name |) (:new-name |) (:show? false)
                    match (app.schema/map-field states :data)
                      (:none) ({})
                      (:some raw) (app.schema/open-state-fields raw)
                  , RenameState
                on-submit $ fn (d!)
                  hint-fn $ Fn
                    Fn *dispatch-op $ -> Unit
                    -> Unit
                  when
                    and
                      not $ blank? $ :old-name state
                      not $ = (:new-name state) |
                    on-replace (:old-name state) (:new-name state) d!
                    app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :show? false
                  , &unit
                node $ comp-modal
                  {} (:title "|Replace variable")
                    :style $ {} $ :width 240
                    :container-style $ {}
                    :render-body $ fn (on-close)
                      hint-fn $ Fn
                        Fn
                          Fn *dispatch-op $ -> Unit
                          -> Unit
                        -> respo.schema/Element
                      div
                        {} $ :style $ merge ui/column
                          {} $ :padding "|8px 16px"
                        div ({})
                          input $ {} (:placeholder |from...)
                            :style $ merge ui/input $ {} (:font-family ui/font-code)
                            :value $ :old-name state
                            :autofocus true
                            :id |replace-input
                            :on-input $ fn (e d!)
                              hint-fn $ Fn respo.schema/RespoEvent
                                Fn *dispatch-op $ -> Unit
                                -> Unit
                              app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :old-name (respo.core/event-value e)
                        respo.comp.space/space-y 8
                        div ({})
                          input $ {} (:placeholder |to...)
                            :style $ merge ui/input $ {} (:font-family ui/font-code)
                            :on-input $ fn (e d!)
                              hint-fn $ Fn respo.schema/RespoEvent
                                Fn *dispatch-op $ -> Unit
                                -> Unit
                              app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :new-name (respo.core/event-value e)
                            :value $ :new-name state
                            :on-keydown $ fn (e d!)
                              hint-fn $ Fn respo.schema/RespoEvent
                                Fn *dispatch-op $ -> Unit
                                -> Unit
                              when
                                = |Enter $ :key $ respo.core/keyboard-info e
                                on-submit d!
                              , &unit
                        respo.comp.space/space-y 8
                        div
                          {} $ :style ui/row-parted
                          span $ {}
                          button $ {} (:style ui/button) (:inner-text |Replace)
                            :on-click $ fn (e d!)
                              hint-fn $ Fn respo.schema/RespoEvent
                                Fn *dispatch-op $ -> Unit
                                -> Unit
                              on-submit d!
                  :show? state
                  fn (d!)
                    hint-fn $ Fn
                      Fn *dispatch-op $ -> Unit
                      -> Unit
                    app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :show? false
              %:: %rename-plugin :rename-plugin node cursor state
          :examples $ []
          :schema $ quote $ Fn respo.schema/States
            Fn String String
              Fn *dispatch-op $ -> Unit
              -> Unit
            -> app.comp.replace-name/%rename-plugin
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.replace-name
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo.core :refer $ defcomp <> span div pre input button img a br
            respo.comp.space :refer $ =<
            app.style :as style
            respo-alerts.core :refer $ comp-modal
    'app.comp.search $ %{} 'FileEntry
      :defs $ {}
        'SearchState $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def SearchState
            defstruct :SearchState (:query String) (:selection Number) (:mode Tag)
          :examples $ []
          :schema $ quote StructDef
        'bookmark->str $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn bookmark->str (bookmark)
            match bookmark
              (:def ns' def' f) (str ns' |/ def')
              (:ns ns' f) ns'
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (-> String)
        'comp-no-results $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-no-results ()
            div
              {} $ :style $ merge ui/row-middle
                {} (:padding 8) (:font-family ui/font-fancy)
                  :color $ hsl 0 0 60
                  :font-weight 300
              <> "|No results"
          :examples $ []
          :schema $ quote $ Fn (-> respo.schema/Component)
        'comp-search $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-search (states router-data)
            let
                cursor $ decode-map-as
                  .unwrap-or (app.schema/map-field states :cursor) ([])
                  List respo.schema/CoordKey
                state $ respo.core/pick-state states 'app.comp.search/SearchState initial-state
                def-candidates $ search-candidates router-data (:query state) :def
                ns-candidates $ search-candidates router-data (:query state) :ns
              div
                {} $ :class-name $ str-spaced css/expand css/row css-search
                div
                  {} (:class-name css/column)
                    :style $ {} (:width 320) (:height |100%)
                  div ({})
                    input $ {} (:placeholder "|Type to search...")
                      :value $ :query state
                      :class-name $ str-spaced style/input |search-input
                      :style $ {} $ :width |100%
                      :on-input $ on-input state cursor
                      :on-keydown $ on-keydown state
                        if
                          = :ns $ :mode state
                          , ns-candidates def-candidates
                        , cursor
                  respo.core/show (empty? def-candidates) (comp-no-results)
                  respo.core/data-list->
                    {} $ :class-name $ str-spaced css/expand style-body
                    -> def-candidates (take 20)
                      map-indexed $ fn (idx bookmark)
                        hint-fn $ Fn Number app.bookmark/%bookmark $ -> (Tuple String respo.schema/Element)
                        let
                            text $ bookmark->str bookmark
                            selected? $ and
                              = :def $ :mode state
                              = idx $ :selection state
                          [] text $ match bookmark
                            (:def ns' def' f)
                              div
                                {}
                                  :class-name $ str-spaced |hoverable style-candidate $ if selected? style-highlight |
                                  :on-click $ on-select bookmark cursor
                                <> def'
                                =< 8 nil
                                <> ns' $ str-spaced style-candidate-ns $ if selected? style-highlight |
                            _ $ div $ {}
                div
                  {} (:class-name css/column)
                    :style $ {} (:width 320) (:height |100%)
                  =< nil 32
                  respo.core/show (empty? ns-candidates) (comp-no-results)
                  respo.core/data-list->
                    {} $ :class-name $ str-spaced css/expand style-body
                    -> ns-candidates (take 20)
                      map-indexed $ fn (idx bookmark)
                        hint-fn $ Fn Number app.bookmark/%bookmark $ -> (Tuple String respo.schema/Element)
                        match bookmark
                          (:ns namespace focus)
                            [] namespace $ let
                                pieces $ split namespace |.
                                selected? $ and
                                  = :ns $ :mode state
                                  = idx $ :selection state
                              div
                                {}
                                  :class-name $ str-spaced |hoverable css/row-middle style-candidate $ if selected? style-highlight |
                                  :on-click $ on-select bookmark cursor
                                span ({})
                                  <>
                                    str
                                      join-string (butlast pieces) |.
                                      , |.
                                    {} $ :color $ hsl 0 0 50
                                  <>
                                    .unwrap-or (last pieces) |
                                    , style-last-piece
                                =< 8 nil
                                span $ {} (:inner-text |import) (:class-name style-use-ns)
                                  :on-click $ fn (e d!)
                                    d! $ :: :analyze/use-import-def bookmark
                                    d! $ app.client-updater/UiStateOp :states cursor initial-state
                          (:def _namespace _name _focus) (raise |Expected-namespace-search-candidate)
                div $ {} $ :class-name css/flex
                div
                  {} (:class-name css/column-parted)
                    :style $ {} $ :padding 16
                  a $ {}
                    :href |https://repo.cirru.org/hovenia-editor/?port=6011
                    :inner-text "|Hovenia Editor"
                    :class-name css/link
                    :style $ {} $ :color (hsl 200 40 50)
                    :target |_blank
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (List app.bookmark/%bookmark) (-> respo.schema/Component)
        'css-search $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-search
            {} $ |$0 $ {} (:height |100%) (:padding "|40px 16px 0 16px")
          :examples $ []
          :schema $ quote String
        'initial-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def initial-state
            %{} SearchState (:query |) (:selection 0) (:mode :def)
          :examples $ []
          :schema $ quote SearchState
        'on-input $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-input (state cursor)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ -> state
                assoc :query $ decode-map-as (:value e) 'String
                assoc :selection 0
          :examples $ []
          :schema $ quote $ Fn SearchState (List respo.schema/CoordKey) (-> respo.schema/EventHandler)
        'on-keydown $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-keydown (state candidates cursor)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              let
                  keyboard $ js-ffi.browser/keyboard-event-host $ :original-event e
                  code $ .-key-code keyboard
                cond
                    = keycode/enter code
                    match
                      get candidates $ search-selection state
                      (:some selected-target)
                        do
                          if (.-shift-key? keyboard)
                            d! $ :: :analyze/use-import-def selected-target
                            d! $ :: :writer/select selected-target
                          app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor initial-state
                      (:none) &unit
                  (= keycode/up code)
                    do (.prevent-default! keyboard)
                      when
                        > (search-selection state) 0
                        app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :selection
                          dec $ search-selection state
                  (= keycode/escape code)
                    do
                      d! $ app.updater.router/route-op $ app.updater.router/Route :editor
                      app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor initial-state
                  (= keycode/down code)
                    do (.prevent-default! keyboard)
                      when
                        < (search-selection state)
                          dec $ .len candidates
                        app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :selection
                          inc $ search-selection state
                  (and (.-meta-key? keyboard) (= keycode/b code))
                    app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor $ assoc state :mode
                      if
                        = (:mode state) :ns
                        , :def :ns
                  true $ on-window-keydown (:original-event e) d! $ {} (:name :search)
              , &unit
          :examples $ []
          :schema $ quote $ Fn SearchState (List app.bookmark/%bookmark) (List respo.schema/CoordKey) (-> respo.schema/EventHandler) (:features :js-ffi)
        'on-select $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-select (bookmark cursor)
            fn (e d!)
              hint-fn $ Fn respo.schema/RespoEvent
                Fn *dispatch-op $ -> Unit
                -> Unit
              d! $ :: :writer/select bookmark
              app.client-updater/dispatch-ui! d! $ app.client-updater/UiStateOp :states cursor initial-state
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (List respo.schema/CoordKey) (-> respo.schema/EventHandler)
        'query-length $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn query-length (bookmark)
            match bookmark
              (:def ns' def' f) (count def')
              (:ns ns' f) (count ns')
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (-> Number)
        'search-candidates $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn search-candidates (bookmarks query mode)
            let
                queries $ map (split query "| ")
                  fn (part) (trim part)
                compare-candidates $ fn (a b)
                  hint-fn $ Fn app.bookmark/%bookmark app.bookmark/%bookmark $ -> Number
                  if (blank? query)
                    &compare (bookmark->str a) (bookmark->str b)
                    &compare (query-length a) (query-length b)
              -> bookmarks
                filter $ fn (bookmark)
                  hint-fn $ Fn app.bookmark/%bookmark $ -> Bool
                  match bookmark
                    (:def namespace name focus)
                      and (= mode :def)
                        every? queries $ fn (part) (includes? name part)
                    (:ns namespace focus)
                      and (= mode :ns)
                        every? queries $ fn (part) (includes? namespace part)
                sort compare-candidates
          :examples $ []
          :schema $ quote $ Fn (List app.bookmark/%bookmark) String Tag
            -> $ List app.bookmark/%bookmark
          :tests $ [] $ %{} 'TestEntry (:name |typed-candidates-and-legacy-state)
            :code $ quote $ let
                keep $ %:: app.bookmark/%bookmark :def |demo.main |keep $ []
                keeper $ %:: app.bookmark/%bookmark :def |other.main |keeper $ []
                unicode $ %:: app.bookmark/%bookmark :def |demo.main "|中文🐈" $ []
                namespace $ %:: app.bookmark/%bookmark :ns |demo.main $ []
                candidates $ [] keeper namespace unicode keep
              assert= ([] keep keeper) (search-candidates candidates |keep :def)
              assert= ([] keep keeper) (search-candidates candidates "|ke ep" :def)
              assert= ([] unicode) (search-candidates candidates "|中文🐈" :def)
              assert= ([] namespace) (search-candidates candidates |main :ns)
              assert= ([]) (search-candidates candidates |missing :def)
              assert= ([] keep unicode keeper) (search-candidates candidates | :def)
              assert= ([] namespace) (search-candidates candidates | :ns)
              let
                  restored $ respo.core/pick-state
                    {} $ :data $ {} (:query "|中文🐈") (:selection 2) (:mode :ns)
                    , 'app.comp.search/SearchState initial-state
                assert= "|中文🐈" $ :query restored
                assert= 2 $ search-selection restored
                assert= :ns $ :mode restored
            :tags $ #{} :unit
        'search-selection $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn search-selection (state) (:selection state)
          :examples $ []
          :schema $ quote $ Fn SearchState (-> Number)
        'style-body $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-body
            {} $ |& $ {} (:overflow :auto) (:padding-bottom 80)
          :examples $ []
          :schema $ quote String
        'style-candidate $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-candidate
            {} $ |& $ {} (:padding "|0 8px")
              :color $ hsl 0 0 100 0.6
              :cursor :pointer
          :examples $ []
          :schema $ quote String
        'style-candidate-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-candidate-ns
            {} $ |& $ {} (:font-size 12)
              :color $ hsl 0 0 40
          :examples $ []
          :schema $ quote String
        'style-highlight $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-highlight
            {} $ |& $ {} (:color :white) (:opacity 1)
          :examples $ []
          :schema $ quote String
        'style-last-piece $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-last-piece
            {} $ |& $ {}
              :color $ hsl 0 0 80
          :examples $ []
          :schema $ quote String
        'style-use-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-use-ns
            {}
              |& $ {} (:opacity 0) (:color :white) (:font-size 12)
              (str |. style-candidate "|:hover &")
                {} $ :opacity 0.4
              (str |. style-candidate "| &:hover")
                {} $ :opacity 0.8
              (str |. style-candidate "| &:active")
                {} (:opacity 1) (:transform "|scale(1.02)")
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.search
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp list-> <> span div input a
            respo.comp.space :refer $ =<
            respo.css :refer $ defstyle
            app.polyfill :refer $ text-width*
            app.keycode :as keycode
            app.client-util :as util
            app.style :as style
            app.util.shortcuts :refer $ on-window-keydown
            app.util.dom :refer $ prevent-default!
    'app.comp.theme-menu $ %{} 'FileEntry
      :defs $ {}
        'comp-theme-menu $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-theme-menu (states theme)
            let
                cursor $ decode-map-as
                  .unwrap-or (app.schema/map-field states :cursor) ([])
                  List respo.schema/CoordKey
                raw-state $ .unwrap-or (app.schema/map-field states :data) false
                state $ if (nil? raw-state) false $ decode-map-as raw-state 'Bool
                label $ match theme
                  (:some name) (str name)
                  (:none) "|no theme"
              div
                {}
                  :class-name $ str-spaced css/font-fancy style-theme-menu
                  :on-click $ fn (_event dispatch!)
                    dispatch! $ app.client-updater/UiStateOp :states cursor $ not state
                    , &unit
                <> label
                if state
                  respo.core/keyed->
                    {} (:class-name style-menu)
                      :on-click $ fn (_event _dispatch!) &unit
                    map theme-list $ fn (name)
                      hint-fn $ Fn Tag $ -> respo.schema/ChildPair
                      %{} respo.schema/ChildPair (:key name)
                        :node $ Some $ respo.schema/RenderNode :element
                          div
                            {}
                              :style $ if
                                = theme $ Some name
                                {} $ :color :white
                                {}
                              :class-name style-menu-item
                              :on-click $ fn (_event dispatch!)
                                dispatch! $ :: :user/change-theme name
                                dispatch! $ app.client-updater/UiStateOp :states cursor false
                                , &unit
                            <> $ str name
                  span $ {}
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Option Tag) (-> respo.schema/Component)
        'read-theme $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-theme (raw)
            if (nil? raw) None $ if (tag? raw)
              Some $ decode-map-as raw 'Tag
              match raw
                (:some theme)
                  Some $ decode-map-as theme 'Tag
                (:none) None
                _ $ raise |Expected-optional-theme
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ Option Tag
        'style-menu $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-menu
            {} $ |& $ {} (:position :absolute) (:bottom |100%) (:right 0) (:background-color :black)
              :border $ str "|1px solid " $ hsl 0 0 100 0.2
          :examples $ []
          :schema $ quote String
        'style-menu-item $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-menu-item
            {} $ |& $ {}
              :color $ hsl 0 0 70
              :padding "|0 8px"
          :examples $ []
          :schema $ quote String
        'style-theme-menu $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-theme-menu
            {} $ |& $ {} (:position :relative) (:width 60)
              :color $ hsl 0 0 80 0.4
              :cursor :pointer
              :display :inline-block
          :examples $ []
          :schema $ quote String
        'theme-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def theme-list ([] :star-trail :beginner :curves)
          :examples $ []
          :schema $ quote $ List Tag
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.theme-menu
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            respo-ui.css :as css
            respo.core :refer $ defcomp >> list-> <> span div pre input button a
            respo.comp.inspect :refer $ comp-inspect
            respo.comp.space :refer $ =<
            app.style :as style
            respo.css :refer $ defstyle
    'app.comp.watching $ %{} 'FileEntry
      :defs $ {}
        'comp-watching $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-watching (states frame theme)
            match frame
              (:none)
                div
                  {} $ :style style-container
                  <> "|Session is missing!"
              (:some data) (comp-watching-frame states data theme)
          :examples $ []
          :schema $ quote $ Fn respo.schema/States
            Option $ Map Tag Dynamic
            Option Tag
            -> respo.schema/Component
            :features :io
        'comp-watching-frame $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-watching-frame (states frame theme)
            let
                self? $ decode-map-as
                  .unwrap-or (get frame :self?) false
                  , 'Bool
                working? $ decode-map-as
                  .unwrap-or (get frame :working?) false
                  , 'Bool
                member $ decode-map-as
                  .unwrap-or (get frame :member) ({})
                  Map Tag Dynamic
                member-name $ .unwrap-or
                  app.schema/read-optional-text $ get member :nickname
                  , |Someone
                bookmark $ app.bookmark/read-optional-bookmark $ .unwrap-or (get frame :bookmark) None
                entry $ app.schema/read-optional-code-entry $ .unwrap-or (get frame :expr) None
                focus $ decode-map-as
                  .unwrap-or (get frame :focus) ([])
                  List String
              if self?
                div
                  {} $ :style style-container
                  <> "|Watching at yourself :)" style-title
                div
                  {} (:class-name css/column) (:style style-container)
                  if working?
                    match bookmark
                      (:some selected)
                        match entry
                          (:some selected-entry)
                            watched-entry states selected selected-entry focus $ .unwrap-or theme :star-trail
                          (:none)
                            span $ {} $ :inner-text "|The selected source entry no longer exists."
                      (:none)
                        span $ {} $ :inner-text "|No source entry is selected."
                    span $ {}
                  =< nil 16
                  div ({}) (<> "|Watching mode" style-tip) (=< 16 nil) (<> member-name) (=< 16 nil)
                    <> $ match bookmark
                      (:some selected) (app.bookmark/preview selected)
                      (:none) |
                    =< 16 nil
                    comp-theme-menu (>> states :theme) theme
          :examples $ []
          :schema $ quote $ Fn respo.schema/States (Map Tag Dynamic) (Option Tag) (-> respo.schema/Component) (:features :io)
        'read-watching-frame $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-watching-frame (raw)
            if (nil? raw) None $ if (map? raw)
              Some $ decode-map-as raw $ Map Tag Dynamic
              match raw
                (:none) None
                (:some frame)
                  Some $ decode-map-as frame $ Map Tag Dynamic
                _ $ raise |Expected-optional-watching-frame
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ Option $ Map Tag Dynamic
        'style-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-container
            {} $ :padding "|40px 16px 0 16px"
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-tip $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-tip
            {} (:font-family "|Josefin Sans")
              :background-color $ hsl 0 0 100 0.3
              :border-radius |4px
              :padding "|4px 8px"
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-title
            {} $ :font-family "|Josefin Sans"
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'watched-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn watched-entry (states bookmark entry focus theme)
            div
              {} (:class-name css/flex)
                :style $ {} $ :overflow :auto
              comp-doc (>> states :doc) entry bookmark
              match
                app.schema/read-node $ :code entry
                (app.schema/CirruExprShape expr)
                  comp-expr
                    >> states $ app.bookmark/preview bookmark
                    , expr focus ([]) (#{}) false :inline true false theme 0
                (app.schema/CirruLeafShape leaf)
                  span $ {} $ :inner-text (:text leaf)
          :examples $ []
          :schema $ quote $ Fn respo.schema/States app.bookmark/%bookmark app.schema/CodeEntry (List String) Tag (-> respo.schema/Element) (:features :io)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.watching
          :require
            respo.util.format :refer $ hsl
            respo.core :refer $ defcomp >> <> span div input pre a
            respo.comp.space :refer $ =<
            app.comp.expr :refer $ comp-expr
            app.comp.page-editor :refer $ comp-doc
            app.comp.theme-menu :refer $ comp-theme-menu
            respo-ui.css :as css
            app.bookmark :as bookmark
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'SiteConfig $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct SiteConfig
            :port $ Option Number
            :title String
            :icon String
            :theme String
            :storage-key String
            :storage-file String
          :examples $ []
          :schema $ quote StructDef
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $
              get-env |mode
              , .unwrap-or |release
          :examples $ []
          :schema $ quote Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            SiteConfig :port None :title "|Calcit Editor" :icon |https://cdn.tiye.me/logo/cirru.png :theme |#eeeeff :storage-key |calcit-storage :storage-file |calcit.cirru
          :examples $ []
          :schema $ quote SiteConfig
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
          :require $ app.schema :as schema
    'app.keycode $ %{} 'FileEntry
      :defs $ {}
        'b $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def b 66
          :examples $ []
          :schema $ quote Number
        'backspace $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def backspace 8
          :examples $ []
          :schema $ quote Number
        'c $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def c 67
          :examples $ []
          :schema $ quote Number
        'd $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def d 68
          :examples $ []
          :schema $ quote Number
        'down $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def down 40
          :examples $ []
          :schema $ quote Number
        'e $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def e 69
          :examples $ []
          :schema $ quote Number
        'enter $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def enter 13
          :examples $ []
          :schema $ quote Number
        'escape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def escape 27
          :examples $ []
          :schema $ quote Number
        'f $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def f 70
          :examples $ []
          :schema $ quote Number
        'i $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def i 73
          :examples $ []
          :schema $ quote Number
        'j $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def j 74
          :examples $ []
          :schema $ quote Number
        'k $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def k 75
          :examples $ []
          :schema $ quote Number
        'left $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def left 37
          :examples $ []
          :schema $ quote Number
        'num-4 $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def num-4 52
          :examples $ []
          :schema $ quote Number
        'o $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def o 79
          :examples $ []
          :schema $ quote Number
        'p $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def p 80
          :examples $ []
          :schema $ quote Number
        'period $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def period 190
          :examples $ []
          :schema $ quote Number
        'right $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def right 39
          :examples $ []
          :schema $ quote Number
        's $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def s 83
          :examples $ []
          :schema $ quote Number
        'slash $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def slash 191
          :examples $ []
          :schema $ quote Number
        'space $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def space 32
          :examples $ []
          :schema $ quote Number
        'tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def tab 9
          :examples $ []
          :schema $ quote Number
        'up $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def up 38
          :examples $ []
          :schema $ quote Number
        'v $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def v 86
          :examples $ []
          :schema $ quote Number
        'x $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def x 88
          :examples $ []
          :schema $ quote Number
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.keycode
    'app.polyfill $ %{} 'FileEntry
      :defs $ {}
        'CanvasContextHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait CanvasContextHost (:font 'String)
            .measure-text $ Fn app.polyfill/CanvasContextHost String $ -> app.polyfill/TextMetricsHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :measure-text |measureText
            :writable $ #{} :font
          :schema $ quote Trait
        'CanvasHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait CanvasHost
            .get-context $ Fn app.polyfill/CanvasHost String $ -> app.polyfill/CanvasContextHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :get-context |getContext
          :schema $ quote Trait
        'PolyfillDocumentHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait PolyfillDocumentHost
            .create-element $ Fn app.polyfill/PolyfillDocumentHost String $ -> app.polyfill/CanvasHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :create-element |createElement
          :schema $ quote Trait
        'TextMetricsHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait TextMetricsHost (:width 'Number)
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ quote Trait
        'ctx $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn ctx ()
            let
                document $ unsafe-coerce js/document 'app.polyfill/PolyfillDocumentHost
                canvas $ .create-element document |canvas
              .get-context canvas |2d
          :examples $ []
          :schema $ quote $ Fn (-> CanvasContextHost) (:features :js-ffi)
        'text-width* $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn text-width* (content font-size font-family)
            let
                context $ ctx
              set! (.-font context) (str font-size "|px " font-family)
              unsafe-coerce
                .-width $ .measure-text context content
                , Number
          :examples $ []
          :schema $ quote $ Fn String Number String (-> Number) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.polyfill
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'CirruExpr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def CirruExpr (impl-traits CirruExprShape CirruExprMethods)
          :examples $ []
          :schema $ quote StructDef
        'CirruExprMethods $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defimpl CirruExprMethods app.schema/CirruExprTrait
            .get $ fn (self p)
              hint-fn $ Fn CirruExprShape String $ -> (Option app.schema/CirruNode)
              get (:data self) p
            .get-in $ fn (self pp)
              hint-fn $ Fn CirruExprShape (List String)
                -> $ Option app.schema/CirruNode
              node-at-path self pp
            .nth $ fn (self idx)
              hint-fn $ Fn CirruExprShape Number $ -> (Option app.schema/CirruNode)
              get (:data self)
                .unwrap $ bisection/key-nth (:data self) idx
            .append $ fn (self x)
              hint-fn $ Fn CirruExprShape app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                bisection/assoc-append d x
            .prepend $ fn (self x)
              hint-fn $ Fn CirruExprShape app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                bisection/assoc-prepend d x
            .replace $ fn (self p x)
              hint-fn $ Fn CirruExprShape String app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                assoc d p x
            .replace-nth $ fn (self idx x)
              hint-fn $ Fn CirruExprShape Number app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                bisection/assoc-nth d idx x
            .update-last $ fn (self f)
              hint-fn $ Fn CirruExprShape
                Fn app.schema/CirruNode $ -> app.schema/CirruNode
                -> CirruExprShape
              update-expr-data-at self
                .unwrap $ last $ sort
                  .to-list $ keys $ :data self
                  , &compare
                , f
            .update-nth $ fn (self idx f)
              hint-fn $ Fn CirruExprShape Number
                Fn app.schema/CirruNode $ -> app.schema/CirruNode
                -> CirruExprShape
              update-expr-data-at self
                .unwrap $ bisection/key-nth (:data self) idx
                , f
            .update $ fn (self p f)
              hint-fn $ Fn CirruExprShape String
                Fn app.schema/CirruNode $ -> app.schema/CirruNode
                -> CirruExprShape
              update-expr-data-at self p f
            .assoc-before $ fn (self p x)
              hint-fn $ Fn CirruExprShape String app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                bisection/assoc-before d p x
            .assoc-before-nth $ fn (self idx x)
              hint-fn $ Fn CirruExprShape Number app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                bisection/assoc-before-nth d idx x
            .asspc-after $ fn (self p x)
              hint-fn $ Fn CirruExprShape String app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                bisection/assoc-after d p x
            .asspc-after-nth $ fn (self idx x)
              hint-fn $ Fn CirruExprShape Number app.schema/CirruNode $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                bisection/assoc-after-nth d idx x
            .dissoc $ fn (self p)
              hint-fn $ Fn CirruExprShape String $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                dissoc d p
            .dissoc-nth $ fn (self idx)
              hint-fn $ Fn CirruExprShape Number $ -> CirruExprShape
              update-expr-data self $ fn (d)
                hint-fn $ Fn (Map String app.schema/CirruNode)
                  -> $ Map String app.schema/CirruNode
                dissoc d $ .unwrap $ bisection/key-nth (:data self) idx
            .assoc-in $ fn (self pp x)
              hint-fn $ Fn CirruExprShape (List String) app.schema/CirruNode $ -> CirruExprShape
              assoc-node-path self pp x
            .append-in $ fn (self pp x)
              hint-fn $ Fn CirruExprShape (List String) app.schema/CirruNode $ -> CirruExprShape
              append-node-path self pp x
            .find-with-base $ fn (self x pp)
              hint-fn $ Fn CirruExprShape app.schema/CirruNode (List String)
                -> $ Option $ List String
              find-node-path self x pp None
            .find $ fn (self x)
              hint-fn $ Fn CirruExprShape app.schema/CirruNode $ ->
                Option $ List String
              find-node-path self x ([]) None
            .find-before-with-base $ fn (self x follow pp)
              hint-fn $ Fn CirruExprShape app.schema/CirruNode String (List String)
                -> $ Option $ List String
              find-node-path self x pp $ Some follow
            .find-before $ fn (self x follow)
              hint-fn $ Fn CirruExprShape app.schema/CirruNode String $ ->
                Option $ List String
              find-node-path self x ([]) (Some follow)
            .= $ fn (self x)
              hint-fn $ Fn CirruExprShape app.schema/CirruNode $ -> Bool
              cirru-node-equal? self x
            .dispatch $ fn (self commands)
              hint-fn $ Fn CirruExprShape (List NodeCommand) (-> app.schema/CirruNode)
              dispatch-node-commands self commands
            .compact $ fn (self)
              hint-fn $ Fn CirruExprShape $ -> (List CirruSyntax)
              expr->syntax self
            .cirru-kind $ fn (_self)
              hint-fn $ Fn CirruExprShape $ -> Tag
              , :expr
          :examples $ []
          :schema $ quote Impl
          :tests $ [] $ %{} 'TestEntry (:name |nested-edit-query-and-commands)
            :code $ quote $ let
                keep $ %{} CirruLeaf (:at 1) (:by |author) (:text |keep)
                inside $ %{} CirruLeaf (:at 2) (:by |author) (:text |inside)
                tail $ %{} CirruLeaf (:at 3) (:by |other) (:text |tail)
                nested $ %{} CirruExpr (:at 2) (:by |author)
                  :data $ {} $ |c inside
                root $ %{} CirruExpr (:at 1) (:by |author)
                  :data $ {} (|a keep) (|b nested)
              assert= (Some keep) (.get root |a)
              assert= (Some keep) (.nth root 0)
              assert= (Some inside)
                .get-in root $ [] |b |c
              assert= (Some root)
                .get-in root $ []
              assert= None $ .get-in root $ [] |a |missing
              assert=
                [] |keep ([] |inside) |tail
                node->syntax $ .append root tail
              assert=
                [] |tail |keep $ [] |inside
                node->syntax $ .prepend root tail
              assert=
                [] |keep $ [] |tail
                node->syntax $ .assoc-in root ([] |b |c) tail
              assert=
                [] |keep $ [] |inside |tail
                node->syntax $ .append-in root ([] |b |c) tail
              assert=
                Some $ [] |b |c
                .find root inside
              assert= None $ .find root tail
              assert=
                [] |keep $ [] |inside |tail
                node->syntax $ .dispatch root $ [] (NodeCommand :update |b) (NodeCommand :append tail)
              assert=
                [] |keep $ [] |inside |tail
                node->syntax $ dispatch-node-commands root $ [] (NodeCommand :update-nth 1) (NodeCommand :append tail)
              assert=
                [] |keep $ [] |inside |tail
                node->syntax $ dispatch-node-commands root $ [] (NodeCommand :update-last) (NodeCommand :append tail)
              assert= |tail $ node->syntax $ dispatch-node-commands root
                [] $ NodeCommand :replace tail
              assert=
                [] $ [] |inside
                node->syntax $ dispatch-node-commands root $ [] (NodeCommand :dissoc |a)
              assert=
                [] |tail $ [] |inside
                node->syntax $ dispatch-node-commands root $ [] (NodeCommand :assoc |a tail)
              assert=
                [] |tail |keep $ [] |inside
                node->syntax $ dispatch-node-commands root $ [] (NodeCommand :prepend tail)
              assert= true $ cirru-node-equal? root $ syntax->node
                [] |keep $ [] |inside
                , |other-author 99
              assert=
                [] |keep $ [] |inside
                node->syntax $ app.util/cirru->tree
                  [] |keep $ [] |inside
                  , |author 1
              assert=
                Some $ [] |a
                .find-before
                  %{} CirruExpr (:at 1) (:by |author)
                    :data $ {} (|a keep) (|b tail)
                  , keep |tail
              assert= ([] |keep |tail)
                node->syntax $ .update-last root $ fn (_child)
                  hint-fn $ Fn app.schema/CirruNode $ -> app.schema/CirruNode
                  do tail
            :tags $ #{} :unit
        'CirruExprShape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct :Expr (:by String) (:at Number)
            :data $ Map String app.schema/CirruNode
          :examples $ []
          :schema $ quote StructDef
        'CirruExprTrait $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait CirruExprTrait
            .get $ Fn app.schema/CirruExprShape String $ -> (Option app.schema/CirruNode)
            .get-in $ Fn app.schema/CirruExprShape (List String)
              -> $ Option app.schema/CirruNode
            .nth $ Fn app.schema/CirruExprShape Number $ -> (Option app.schema/CirruNode)
            .append $ Fn app.schema/CirruExprShape app.schema/CirruNode $ -> app.schema/CirruExprShape
            .prepend $ Fn app.schema/CirruExprShape app.schema/CirruNode $ -> app.schema/CirruExprShape
            .replace $ Fn app.schema/CirruExprShape String app.schema/CirruNode $ -> app.schema/CirruExprShape
            .replace-nth $ Fn app.schema/CirruExprShape Number app.schema/CirruNode $ -> app.schema/CirruExprShape
            .update-last $ Fn app.schema/CirruExprShape
              Fn app.schema/CirruNode $ -> app.schema/CirruNode
              -> app.schema/CirruExprShape
            .update-nth $ Fn app.schema/CirruExprShape Number
              Fn app.schema/CirruNode $ -> app.schema/CirruNode
              -> app.schema/CirruExprShape
            .update $ Fn app.schema/CirruExprShape String
              Fn app.schema/CirruNode $ -> app.schema/CirruNode
              -> app.schema/CirruExprShape
            .assoc-before $ Fn app.schema/CirruExprShape String app.schema/CirruNode $ -> app.schema/CirruExprShape
            .assoc-before-nth $ Fn app.schema/CirruExprShape Number app.schema/CirruNode $ -> app.schema/CirruExprShape
            .asspc-after $ Fn app.schema/CirruExprShape String app.schema/CirruNode $ -> app.schema/CirruExprShape
            .asspc-after-nth $ Fn app.schema/CirruExprShape Number app.schema/CirruNode $ -> app.schema/CirruExprShape
            .dissoc $ Fn app.schema/CirruExprShape String $ -> app.schema/CirruExprShape
            .dissoc-nth $ Fn app.schema/CirruExprShape Number $ -> app.schema/CirruExprShape
            .assoc-in $ Fn app.schema/CirruExprShape (List String) app.schema/CirruNode $ -> app.schema/CirruExprShape
            .append-in $ Fn app.schema/CirruExprShape (List String) app.schema/CirruNode $ -> app.schema/CirruExprShape
            .find-with-base $ Fn app.schema/CirruExprShape app.schema/CirruNode (List String)
              -> $ Option $ List String
            .find $ Fn app.schema/CirruExprShape app.schema/CirruNode $ ->
              Option $ List String
            .find-before-with-base $ Fn app.schema/CirruExprShape app.schema/CirruNode String (List String)
              -> $ Option $ List String
            .find-before $ Fn app.schema/CirruExprShape app.schema/CirruNode String $ ->
              Option $ List String
            .= $ Fn app.schema/CirruExprShape app.schema/CirruNode $ -> Bool
            .dispatch $ Fn app.schema/CirruExprShape (List app.schema/NodeCommand) (-> app.schema/CirruNode)
            .compact $ Fn app.schema/CirruExprShape $ -> (List app.schema/CirruSyntax)
            .cirru-kind $ Fn app.schema/CirruExprShape $ -> Tag
          :examples $ []
          :schema $ quote Trait
        'CirruLeaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def CirruLeaf (impl-traits CirruLeafShape CirruLeafMethods)
          :examples $ []
          :schema $ quote StructDef
        'CirruLeafMethods $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defimpl CirruLeafMethods app.schema/CirruLeafTrait
            .= $ fn (self x)
              hint-fn $ Fn CirruLeafShape app.schema/CirruNode $ -> Bool
              match x
                (app.schema/CirruLeafShape other)
                  = (:text self) (:text other)
                (app.schema/CirruExprShape _other) false
            .cirru-kind $ fn (_self)
              hint-fn $ Fn CirruLeafShape $ -> Tag
              , :leaf
          :examples $ []
          :schema $ quote Impl
          :tests $ [] $ %{} 'TestEntry (:name |typed-node-equality-and-origin)
            :code $ quote $ let
                first-leaf $ %{} CirruLeaf (:at 1) (:by |one) (:text |keep)
                same-text $ %{} CirruLeaf (:at 2) (:by |other) (:text |keep)
                different $ %{} CirruLeaf (:at 1) (:by |one) (:text |other)
                expr $ %{} CirruExprShape (:at 1) (:by |one)
                  :data $ {}
                foreign-shape $ defstruct :Leaf (:at Number) (:by String) (:text String)
                foreign $ %{} foreign-shape (:at 1) (:by |one) (:text |keep)
              assert= true $ .= first-leaf same-text
              assert= false $ .= first-leaf different
              assert= false $ .= first-leaf expr
              assert= :leaf $ .cirru-kind first-leaf
              assert= true $ app.client-util/leaf? first-leaf
              assert= false $ app.client-util/leaf? foreign
              assert= false $ app.client-util/leaf? |keep
            :tags $ #{} :unit
        'CirruLeafShape $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct :Leaf (:at Number) (:by String) (:text String)
          :examples $ []
          :schema $ quote StructDef
        'CirruLeafTrait $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait CirruLeafTrait
            .= $ Fn app.schema/CirruLeafShape app.schema/CirruNode $ -> Bool
            .cirru-kind $ Fn app.schema/CirruLeafShape $ -> Tag
          :examples $ []
          :schema $ quote Trait
        'CirruNode $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion CirruNode app.schema/CirruLeafShape app.schema/CirruExprShape
          :examples $ []
          :schema $ quote UnionDef
        'CirruSyntax $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion CirruSyntax String (List app.schema/CirruSyntax)
          :examples $ []
          :schema $ quote UnionDef
        'CodeEntry $ %{} 'CodeEntry
          :doc "|Internal editable entry. source-entry retains the complete official CLI entry view through moves and copies; None denotes a newly created entry. It is source data, not nominal identity or authorization."
          :code $ quote $ def CodeEntry
            defstruct :CodeEntry (:doc String) (:code app.schema/CirruNode) (:examples List)
              :source-entry $ Option String
          :examples $ []
          :schema $ quote StructDef
        'DependencyKey $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum DependencyKey (:def String String) (:reference String String)
          :examples $ []
          :schema $ quote EnumDef
        'DispatchOp $ %{} 'CodeEntry
          :doc "|Framework slot representative for the legacy enum dispatch boundary. This sentinel is never sent."
          :code $ quote $ def DispatchOp (:: :unhandled)
          :examples $ []
          :schema $ quote AnyEnum
        'FileEntry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def FileEntry
            defstruct :FileEntry (:ns app.schema/CodeEntry)
              :defs $ Map String app.schema/CodeEntry
              :source-view $ Option String
          :examples $ []
          :schema $ quote StructDef
        'NodeCommand $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum NodeCommand (:update String) (:update-last) (:update-nth Number) (:replace app.schema/CirruNode) (:dissoc String) (:assoc String app.schema/CirruNode) (:append app.schema/CirruNode) (:prepend app.schema/CirruNode)
          :examples $ []
          :schema $ quote EnumDef
        'NotificationField $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion NotificationField String Number Tag
          :examples $ []
          :schema $ quote UnionDef
        'append-node-path $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn append-node-path (expr path node)
            if (empty? path) (raise |Expected-nonempty-node-path)
              let
                  key $ .unwrap $ first path
                  remaining $ rest path
                if (empty? remaining)
                  assoc expr :data $ bisection/assoc-append (:data expr) node
                  match
                    .unwrap $ get (:data expr) key
                    (app.schema/CirruExprShape child)
                      assoc expr :data $ assoc (:data expr) key $ append-node-path child remaining node
                    (app.schema/CirruLeafShape _leaf) (raise |Expected-expression-child)
          :examples $ []
          :schema $ quote $ Fn CirruExprShape (List String) CirruNode (-> CirruExprShape)
        'assoc-node-path $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn assoc-node-path (expr path node)
            if (empty? path) (raise |Expected-nonempty-node-path)
              let
                  key $ .unwrap $ first path
                  remaining $ rest path
                if (empty? remaining)
                  assoc expr :data $ assoc (:data expr) key node
                  match
                    .unwrap $ get (:data expr) key
                    (app.schema/CirruExprShape child)
                      assoc expr :data $ assoc (:data expr) key $ assoc-node-path child remaining node
                    (app.schema/CirruLeafShape _leaf) (raise |Expected-expression-child)
          :examples $ []
          :schema $ quote $ Fn CirruExprShape (List String) CirruNode (-> CirruExprShape)
        'cirru-compact $ %{} 'CodeEntry
          :doc "|a cloned version of tree->cirru to simplify dependency issues"
          :code $ quote $ defn cirru-compact (x) (node->syntax x)
          :examples $ []
          :schema $ quote $ Fn CirruNode (-> CirruSyntax)
        'cirru-node-equal? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn cirru-node-equal? (a b)
            match a
              (app.schema/CirruLeafShape leaf)
                match b
                  (app.schema/CirruLeafShape other)
                    = (:text leaf) (:text other)
                  (app.schema/CirruExprShape _expr) false
              (app.schema/CirruExprShape expr)
                match b
                  (app.schema/CirruLeafShape _leaf) false
                  (app.schema/CirruExprShape other)
                    let
                        self-keys $ sort
                          .to-list $ keys $ :data expr
                          , &compare
                        other-keys $ sort
                          .to-list $ keys $ :data other
                          , &compare
                      if
                        = (.len self-keys) (.len other-keys)
                        every?
                          range $ .len self-keys
                          fn (idx)
                            hint-fn $ Fn Number $ -> Bool
                            cirru-node-equal?
                              .unwrap $ get (:data expr)
                                .unwrap $ nth self-keys idx
                              .unwrap $ get (:data other)
                                .unwrap $ nth other-keys idx
                        , false
          :examples $ []
          :schema $ quote $ Fn CirruNode CirruNode (-> Bool)
        'configs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def configs
            {} (:port 6001) (:expose-port 6011) (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
              :modules $ []
              :version |0.0.1
          :examples $ []
          :schema $ quote $ Map Tag Dynamic
        'database $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def database
            {}
              :sessions $ do session $ {}
              :users $ {}
              :package |app
              :files $ {}
              :saved-files $ {}
              :configs configs
              :entries $ {}
              :usages-dict $ {}
              :deps-dict $ {}
          :examples $ []
          :schema $ quote $ Map Tag Dynamic
        'dispatch-node-commands $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch-node-commands (expr commands)
            if (empty? commands) (raise |Expected-nonempty-node-commands)
              let
                  more $ rest commands
                match
                  .unwrap $ first commands
                  (:update key)
                    match
                      .unwrap $ get (:data expr) key
                      (app.schema/CirruExprShape child)
                        assoc expr :data $ assoc (:data expr) key $ dispatch-node-commands child more
                      (app.schema/CirruLeafShape _leaf) (raise |Expected-expression-child)
                  (:update-last)
                    let
                        key $ .unwrap $ last
                          sort
                            .to-list $ keys $ :data expr
                            , &compare
                      dispatch-node-commands expr $ prepend more $ NodeCommand :update key
                  (:update-nth idx)
                    let
                        key $ .unwrap $ bisection/key-nth (:data expr) idx
                      dispatch-node-commands expr $ prepend more $ NodeCommand :update key
                  (:replace node) node
                  (:dissoc key)
                    assoc expr :data $ dissoc (:data expr) key
                  (:assoc key node)
                    assoc expr :data $ assoc (:data expr) key node
                  (:append node)
                    assoc expr :data $ bisection/assoc-append (:data expr) node
                  (:prepend node)
                    assoc expr :data $ bisection/assoc-prepend (:data expr) node
          :examples $ []
          :schema $ quote $ Fn CirruExprShape (List NodeCommand) (-> CirruNode)
        'expr->syntax $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expr->syntax (expr)
            -> (:data expr) keys .to-list (sort &compare)
              map $ fn (key)
                hint-fn $ Fn String $ -> CirruSyntax
                node->syntax $ .unwrap $ get (:data expr) key
          :examples $ []
          :schema $ quote $ Fn CirruExprShape
            -> $ List CirruSyntax
        'find-node-path $ %{} 'CodeEntry
          :doc "|Search in bisection key order, matching rendering/serialization. Raw Map iteration is unordered and must not define sibling adjacency or which duplicate occurrence is found first."
          :code $ quote $ defn find-node-path (expr target base follow)
            if (cirru-node-equal? expr target) (Some base)
              loop
                  pairs $ map
                    sort
                      .to-list $ keys $ :data expr
                      , &compare
                    fn (key)
                      hint-fn $ Fn String $ -> (Tuple String app.schema/CirruNode)
                      [] key $ .unwrap $ get (:data expr) key
                if (empty? pairs) None $ let[] (key child)
                  .unwrap $ first pairs
                  let
                      followed? $ match follow
                        (:none) true
                        (:some text)
                          match
                            first $ rest pairs
                            (:none) false
                            (:some next-pair)
                              let[] (_key sibling) next-pair $ match sibling
                                (app.schema/CirruLeafShape leaf)
                                  = text $ :text leaf
                                (app.schema/CirruExprShape _expr) false
                    if
                      and (cirru-node-equal? child target) followed?
                      Some $ conj base key
                      match child
                        (app.schema/CirruLeafShape _leaf)
                          recur $ rest pairs
                        (app.schema/CirruExprShape nested)
                          match
                            find-node-path nested target (conj base key) follow
                            (:some found) (Some found)
                            (:none)
                              recur $ rest pairs
          :examples $ []
          :schema $ quote $ Fn CirruExprShape CirruNode (List String) (Option String)
            -> $ Option $ List String
        'internal-entry-fields $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn internal-entry-fields (raw expected-name)
            if (struct? raw)
              do
                assert= expected-name $ &struct:get-name raw
                &struct:to-map raw
              decode-map-as raw $ Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn Dynamic Tag
            -> $ Map Tag Dynamic
        'map-field $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn map-field (data key) (get data key)
          :examples $ []
          :schema $ quote $ Fn (Map K V) K
            -> $ Option V
            :generics K V
        'node->syntax $ %{} 'CodeEntry
          :doc "|Serialize a fully typed CirruNode recursively in bisection key order. Expr.data is Map<String,CirruNode>; raw legacy Structs must pass read-node before traversal."
          :code $ quote $ defn node->syntax (node)
            match node
              (app.schema/CirruLeafShape leaf) (:text leaf)
              (app.schema/CirruExprShape expr) (expr->syntax expr)
          :examples $ []
          :schema $ quote $ Fn CirruNode (-> CirruSyntax)
          :tests $ []
            %{} 'TestEntry (:name |ordered-nested-syntax)
              :code $ quote $ let
                  leaf $ %{} CirruLeafShape (:at 1) (:by |author) (:text |keep)
                  nested $ %{} CirruExprShape (:at 2) (:by |other)
                    :data $ {}
                  root $ %{} CirruExprShape (:at 3) (:by |author)
                    :data $ {} (|b nested) (|a leaf)
                assert=
                  [] |keep $ []
                  node->syntax root
                assert=
                  [] |keep $ []
                  cirru-compact root
                assert=
                  [] |keep $ []
                  app.util/tree->cirru root
              :tags $ #{} :unit
            %{} 'TestEntry (:name |reject-invalid-legacy-child)
              :code $ quote $ let
                  foreign-shape $ defstruct :Expr (:at Number) (:by String)
                    :data $ Map String Number
                  raw $ %{} foreign-shape (:at 1) (:by |author)
                    :data $ {} $ |a 42
                  rejected $ ref false
                try (read-node raw)
                  fn (error) (reset! rejected true)
                assert= true @rejected
              :tags $ #{} :unit
        'node-at-path $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn node-at-path (node path)
            if (empty? path) (Some node)
              match node
                (app.schema/CirruLeafShape _leaf) None
                (app.schema/CirruExprShape expr)
                  match
                    get (:data expr)
                      .unwrap $ first path
                    (:some child)
                      node-at-path child $ rest path
                    (:none) None
          :examples $ []
          :schema $ quote $ Fn CirruNode (List String)
            -> $ Option CirruNode
        'open-state-fields $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn open-state-fields (raw)
            if (nil? raw) ({})
              if (struct? raw) (&struct:to-map raw)
                decode-map-as raw $ Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn Dynamic
            -> $ Map Tag Dynamic
        'page-data $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def page-data
            {}
              :files $ {}
                :ns-dict $ #{}
                :defs-dict $ #{}
                :changed-files $ {}
              :editor $ {}
                :focus $ []
                :others $ #{}
                :expr nil
          :examples $ []
          :schema $ quote Dynamic
        'read-code-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-code-entry (raw)
            let
                fields $ internal-entry-fields raw :CodeEntry
              %{} CodeEntry
                :doc $ decode-map-as
                  .unwrap $ get fields :doc
                  , 'String
                :code $ read-node $ .unwrap (get fields :code)
                :examples $ decode-map-as
                  .unwrap-or (get fields :examples) ([])
                  List Dynamic
                :source-entry $ read-source-option $ .unwrap-or (get fields :source-entry) None
          :examples $ []
          :schema $ quote $ Fn Raw (-> CodeEntry) (:generics Raw)
        'read-dependency-key $ %{} 'CodeEntry
          :doc "|Read an anonymous dependency key from the editor protocol."
          :code $ quote $ defn read-dependency-key (raw)
            match raw
              (:def namespace name)
                DependencyKey :def (decode-map-as namespace String) (decode-map-as name String)
              (:reference namespace name)
                DependencyKey :reference (decode-map-as namespace String) (decode-map-as name String)
              _ $ raise "|Expected a dependency definition or reference"
          :examples $ []
          :schema $ quote $ Fn T (-> DependencyKey) (:generics T)
        'read-dependency-map $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-dependency-map (raw)
            filter-map-kv
              decode-map-as raw $ Map Dynamic $ Set Dynamic
              fn (key links)
                hint-fn $ Fn Dynamic (Set Dynamic)
                  -> $ MapEntryDecision DependencyKey $ Set DependencyKey
                MapEntryDecision :keep (read-dependency-key key) (.map links read-dependency-key)
          :examples $ []
          :schema $ quote $ Fn T
            -> $ Map DependencyKey $ Set DependencyKey
            :generics T
        'read-dependency-set $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-dependency-set (raw)
            .map
              decode-map-as raw $ Set Dynamic
              , read-dependency-key
          :examples $ []
          :schema $ quote $ Fn T
            -> $ Set DependencyKey
            :generics T
        'read-expr $ %{} 'CodeEntry
          :doc "|Recover a checked CirruNode at the raw state boundary, then narrow the existing union to an expression; reject leaves without weakening the node model."
          :code $ quote $ defn read-expr (raw)
            match (read-node raw)
              (CirruExprShape expr) expr
              _ $ raise "|Expected Cirru expression node"
          :examples $ []
          :schema $ quote $ Fn Raw (-> CirruExprShape) (:generics Raw)
        'read-file-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-file-entry (raw)
            let
                fields $ internal-entry-fields raw :FileEntry
                definitions $ decode-map-as
                  .unwrap $ get fields :defs
                  Map String Dynamic
              %{} FileEntry
                :ns $ read-code-entry $ .unwrap (get fields :ns)
                :defs $ filter-map-kv definitions $ fn (name entry)
                  hint-fn $ Fn String Dynamic $ -> (MapEntryDecision String CodeEntry)
                  MapEntryDecision :keep name $ read-code-entry entry
                :source-view $ read-source-option $ .unwrap-or (get fields :source-view) None
          :examples $ []
          :schema $ quote $ Fn Raw (-> FileEntry) (:generics Raw)
          :tests $ [] $ %{} 'TestEntry (:name |legacy-entry-fields-recover-to-local-model)
            :code $ quote $ let
                node $ syntax->node ([] |ns |demo.main) |fixture 12
                entry $ %{} CodeEntry (:doc |legacy) (:code node)
                  :examples $ []
                  :source-entry None
                expected $ %{} FileEntry (:ns entry)
                  :defs $ {}
                  :source-view None
                legacy $ {}
                  :ns $ dissoc (&struct:to-map entry) :source-entry
                  :defs $ {}
              assert= expected $ read-file-entry $ parse-cirru-edn (format-cirru-edn legacy)
            :tags $ #{} :unit
        'read-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-node (raw)
            if (struct? raw)
              cond
                  &struct:matches? raw CirruLeafShape
                  assert-type raw CirruLeafShape
                (&struct:matches? raw CirruExprShape) (assert-type raw CirruExprShape)
                true $ let
                    fields $ &struct:to-map raw
                    at $ decode-map-as
                      .unwrap $ get fields :at
                      , 'Number
                    by $ decode-map-as
                      .unwrap $ get fields :by
                      , 'String
                  match (&struct:get-name raw)
                    :Leaf $ %{} CirruLeaf (:at at) (:by by)
                      :text $ decode-map-as
                        .unwrap $ get fields :text
                        , 'String
                    :Expr $ let
                        raw-data $ decode-map-as
                          .unwrap $ get fields :data
                          Map String Dynamic
                        data $ filter-map-kv raw-data $ fn (key child)
                          hint-fn $ Fn String Dynamic $ -> (MapEntryDecision String app.schema/CirruNode)
                          MapEntryDecision :keep key $ read-node child
                      %{} CirruExpr (:at at) (:by by) (:data data)
                    _ $ raise |Unknown-Cirru-node-kind
              raise |Expected-Cirru-node-Struct
          :examples $ []
          :schema $ quote $ Fn Raw (-> CirruNode) (:generics Raw)
          :tests $ [] $ %{} 'TestEntry (:name |checked-wire-recovery-keeps-local-identity)
            :code $ quote $ let
                leaf $ %{} CirruLeaf (:at 1) (:by "|中文作者") (:text "|🐈")
                nested $ %{} CirruExpr (:at 2) (:by |other)
                  :data $ {}
                root $ %{} CirruExpr (:at 3) (:by "|中文作者")
                  :data $ {} (|b nested) (|a leaf)
                restored $ read-node $ parse-cirru-edn (format-cirru-edn root)
              assert= true $ identical? root $ read-node root
              assert=
                [] "|🐈" $ []
                node->syntax restored
              assert= true $ cirru-node-equal? root restored
              assert= true $ identical? root $ .unwrap
                node-at-path root $ []
            :tags $ #{} :unit
        'read-optional-code-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-optional-code-entry (raw)
            if (nil? raw) None $ match raw
              (:some entry)
                Some $ read-code-entry entry
              (:none) None
              _ $ raise |Expected-optional-code-entry
          :examples $ []
          :schema $ quote $ Fn Raw
            -> $ Option CodeEntry
            :generics Raw
        'read-optional-file-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-optional-file-entry (raw)
            if (enum? raw)
              match raw
                (:some file)
                  Some $ read-file-entry file
                (:none) None
                _ $ raise |Expected-optional-file-entry
              raise |Expected-optional-file-entry
          :examples $ []
          :schema $ quote $ Fn Raw
            -> $ Option FileEntry
            :generics Raw
          :tests $ [] $ %{} 'TestEntry (:name |optional-file-wire-restores-local-model)
            :code $ quote $ let
                entry $ %{} CodeEntry (:doc |fixture)
                  :code $ syntax->node ([] |ns |demo.main) |fixture 12
                  :examples $ []
                  :source-entry None
                file $ %{} FileEntry (:ns entry)
                  :defs $ {}
                  :source-view None
              assert= None $ read-optional-file-entry $ parse-cirru-edn (format-cirru-edn None)
              assert= (Some file)
                read-optional-file-entry $ parse-cirru-edn $ format-cirru-edn (Some file)
            :tags $ #{} :unit
        'read-optional-text $ %{} 'CodeEntry
          :doc "|Decode a legacy text field, treating both missing and explicit nil as absent."
          :code $ quote $ defn read-optional-text (field)
            match field
              (:none) None
              (:some value)
                if (nil? value) None $ Some $ decode-map-as value String
          :examples $ []
          :schema $ quote $ Fn (Option T)
            -> $ Option String
            :generics T
        'read-source-option $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-source-option (raw)
            if (enum? raw)
              match raw
                (:none) None
                (:some view)
                  Some $ decode-map-as view 'String
                _ $ raise |Expected-optional-source-view
              raise |Expected-optional-source-view
          :examples $ []
          :schema $ quote $ Fn Raw
            -> $ Option String
            :generics Raw
        'router $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def router
            {} (:name nil) (:title nil)
              :data $ {}
              :router nil
          :examples $ []
          :schema $ quote Dynamic
        'session $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def session
            {} (:user-id nil) (:id nil)
              :router $ :: :files
              :notifications $ []
              :writer $ {} (:selected-ns nil) (:draft-ns nil) (:peek-def nil) (:pointer 0)
                :stack $ []
                :picker-coord nil
              :theme :star-trail
          :examples $ []
          :schema $ quote $ Map Tag Dynamic
        'syntax->node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn syntax->node (syntax author timestamp)
            match syntax
              (String text)
                %{} CirruLeaf (:by author) (:at timestamp) (:text text)
              (List children)
                %{} CirruExpr (:by author) (:at timestamp)
                  :data $ loop
                      result $ {}
                      remaining children
                      next-id bisection-core/mid-id
                    if (empty? remaining) result $ recur
                      assoc result next-id $ syntax->node
                        .unwrap $ first remaining
                        , author timestamp
                      rest remaining
                      bisection-core/bisect next-id bisection-core/max-id
          :examples $ []
          :schema $ quote $ Fn CirruSyntax String Number (-> CirruNode)
        'update-expr-data $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-expr-data (self f)
            assoc self :data $ f $ :data self
          :examples $ []
          :schema $ quote $ Fn CirruExprShape
            Fn (Map String CirruNode)
              -> $ Map String CirruNode
            -> CirruExprShape
        'update-expr-data-at $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-expr-data-at (self p f)
            update-expr-data self $ fn (d)
              hint-fn $ Fn (Map String app.schema/CirruNode)
                -> $ Map String app.schema/CirruNode
              update d p f
          :examples $ []
          :schema $ quote $ Fn CirruExprShape String
            Fn CirruNode $ -> CirruNode
            -> CirruExprShape
        'user $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def user
            {} (:name nil) (:id nil) (:nickname nil) (:avatar nil) (:password nil) (:theme :star-trail)
          :examples $ []
          :schema $ quote $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
          :require (bisection-key.core :as bisection-core) (bisection-key.util :as bisection)
    'app.server $ %{} 'FileEntry
      :defs $ {}
        '*client-caches $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *client-caches ({})
          :examples $ []
          :schema $ quote $ Ref
            Map String $ Map Tag Dynamic
        '*reader-db $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reader-db @*writer-db
          :examples $ []
          :schema $ quote $ Ref (Map Tag Dynamic)
        '*writer-db $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *writer-db
            assoc initial-db :sessions $ {}
          :examples $ []
          :schema $ quote $ Ref (Map Tag Dynamic)
        'ChalkHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait ChalkHost
            .gray $ Fn app.server/ChalkHost String $ -> String
            .blue $ Fn app.server/ChalkHost String $ -> String
            .red $ Fn app.server/ChalkHost String $ -> String
            .yellow $ Fn app.server/ChalkHost String $ -> String
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
          :schema $ quote Trait
        'compile-all-files! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn compile-all-files! (_configs) (save-files! None |system)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (-> Unit) (:features :io :js-ffi :state)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op sid)
            when config/dev? $ js/console.log |Action op sid
            match op
              (:effect/save-files) (save-files! None sid)
              (:effect/save-ns namespace)
                save-files!
                  Some $ decode-map-as namespace 'String
                  , sid
              (:ping) &unit
              _ $ reset! *writer-db $ updater @*writer-db op sid (new-op-id) (shared/now-ms)
            , &unit
          :examples $ []
          :schema $ quote $ Fn Dynamic String (-> Unit) (:features :io :js-ffi :state)
        'expose-files! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expose-files! (port)
            let
                server $ createServer $ fn (req res) (hint-fn Async)
                  ; js/console.log (.-url req) (.-headers req)
                  .!setHeader res |Access-Control-Allow-Origin |*
                  .!setHeader res |Access-Control-Allow-Headers |*
                  if
                    = |OPTIONS $ match
                      try-decode-map-as (js-ffi.contract/object-field |IncomingMessage req |method) String
                      (:ok value) value
                      (:err _message) |
                    do (.!writeHead res 200) (.!end res |OK)
                    match
                      match
                        try-decode-map-as (js-ffi.contract/object-field |IncomingMessage req |url) String
                        (:ok value) value
                        (:err _message) |
                      |/ $ .!end res "|echo from Calcit Editor"
                      |/favicon.ico $ do (.!writeHead res 404) (.!end res |)
                      |/load-error $ readFile |./.calcit-error.cirru |utf8 $ make-file-response res
                      |/load-calcit $ readFile |./calcit.cirru |utf8 $ make-file-response res
                      |/calcit-data $ readFile |./calcit.cirru |utf8 $ make-file-response res
                      _ $ do (.!writeHead res 404) (.!end res "|not found. check url")
              .!listen server port $ fn () $ let
                  link $ .blue (unsafe-coerce chalk 'app.server/ChalkHost) (str |http://localhost: port)
                println $ str "|port " port "| ok, local configs exposed on " link
          :examples $ []
          :schema $ quote $ Fn Number (-> Dynamic) (:features :io :js-ffi)
        'initial-db $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def initial-db (storage/load-project-state! storage-file)
          :examples $ []
          :schema $ quote $ Map Tag Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            if config/dev? $ load-console-formatter!
            let
                configs $ decode-map-as
                  .unwrap-or (get initial-db :configs) {}
                  Map Tag Dynamic
                cli-configs $ get-cli-configs!
              if
                = (get cli-configs :op) (Some |compile)
                compile-all-files! configs
                do (start-server! configs) (check-version!)
                  dispatch! (:: :analyze/refresh-usages-dict) |system
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'make-file-response $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn make-file-response (res)
            fn (err content)
              if (non-nil? err)
                do (.!writeHead res 400)
                  .!end res $ format-cirru-edn $ {}
                    :message $ str err
                do (.!setHeader res |Content-Type |text/plain) (.!writeHead res 200) (.!end res content)
          :examples $ []
          :schema $ quote $ Fn Dynamic (-> Dynamic) (:features :js-ffi)
        'new-op-id $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn new-op-id ()
            js-ffi.contract/expect-string |nanoid $ nanoid
          :examples $ []
          :schema $ quote $ Fn (-> String) (:features :js-ffi)
        'on-file-change! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-file-change! ()
            try
              let
                  project $ storage/read-source-project! storage-file
                  db @*writer-db
                  same-source? $ = (get db :source-revision)
                    Some $ :source-revision project
                  same-manifest? $ = (get db :source-manifest-revision)
                    Some $ :source-manifest-revision project
                when
                  not $ and same-source? same-manifest?
                  let
                      next $ watcher/file-change db project |watcher (new-op-id) (shared/now-ms)
                    reset! *writer-db next
                    storage/save-editor-state! storage-file next
                    dispatch! (:: :analyze/refresh-usages-dict) |watcher
                , &unit
              fn (error)
                let
                    detail $ shared/normalize-error error
                  eprintln $ :message detail
                  dispatch!
                    :: :notify/push-message $ [] :error $ :message detail
                    , |watcher
                  , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'read-config-port $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-config-port (configured key)
            let
                fallback $ fn ()
                  hint-fn $ Fn $ -> Number
                  decode-map-as
                    .unwrap $ get schema/configs key
                    , Number
              match configured
                (:none) (fallback)
                (:some value)
                  if (nil? value) (fallback) (decode-map-as value Number)
          :examples $ []
          :schema $ quote $ Fn (Option T) Tag (-> Number) (:generics T)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            println $ .gray (unsafe-coerce chalk 'app.server/ChalkHost) "|code updated."
            clear-twig-caches!
            sync-clients! @*reader-db
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
        'render-loop! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-loop! ()
            if (not= @*reader-db @*writer-db)
              do (reset! *reader-db @*writer-db) (; println "|render loop") (sync-clients! @*reader-db)
            js/setTimeout render-loop! 20
          :examples $ []
          :schema $ quote $ Fn (-> Dynamic) (:features :io :js-ffi :state)
        'run-server! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn run-server! (dispatch! port)
            wss-serve! port $ {}
              :on-open $ fn (sid _socket)
                hint-fn $ Fn String ws-edn.server/NodeWebSocketHost $ -> Unit
                dispatch! (:: :session/connect) sid
                println $ str |client-connected: sid
                , &unit
              :on-data $ fn (sid action)
                hint-fn $ Fn String Dynamic $ -> Unit
                dispatch! action sid
              :on-close $ fn (sid _code)
                hint-fn $ Fn String Number $ -> Unit
                println $ str |client-disconnected: sid
                dispatch! (:: :session/disconnect) sid
              :on-error $ fn (error)
                hint-fn $ Fn JsObject $ -> Unit
                eprintln error
                , &unit
              :class-mapper $ {} (:Expr schema/CirruExpr) (:Leaf schema/CirruLeaf)
          :examples $ []
          :schema $ quote $ Fn
            Fn Dynamic String $ -> Unit
            , Number (-> ws-edn.server/NodeWebSocketServerHost) (:features :io :js-ffi)
        'save-files! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn save-files! (selected sid)
            try
              let
                  db @*writer-db
                  receipt $ storage/save-project! storage-file db selected
                  next $ writer/accept-project-save db receipt selected sid (new-op-id) (shared/now-ms)
                reset! *writer-db next
                storage/save-editor-state! storage-file next
                , &unit
              fn (error)
                let
                    detail $ shared/normalize-error error
                  eprintln $ :message detail
                  reset! *writer-db $ updater @*writer-db
                    :: :notify/push-message $ [] :error $ :message detail
                    , sid (new-op-id) (shared/now-ms)
                  , &unit
          :examples $ []
          :schema $ quote $ Fn (Option String) String (-> Unit) (:features :io :js-ffi :state)
        'start-server! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn start-server! (configs)
            pick-port!
              read-config-port (get configs :port) :port
              fn (unoccupied-port) (run-server! dispatch! unoccupied-port) &unit
            pick-http-port!
              read-config-port (get configs :expose-port) :expose-port
              fn (unoccupied-port) (expose-files! unoccupied-port) &unit
            render-loop!
            watch-file!
            js/process.on |SIGINT $ fn (_code & _args)
              try
                do (storage/save-editor-state! storage-file @*writer-db)
                  println "|Saved editor state in .calcit/editor-state.cirru"
                  js/process.exit
                  , &unit
                fn (error)
                  eprintln $ :message $ shared/normalize-error error
                  , &unit
            , &unit
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (-> Unit) (:features :io :js-ffi :state)
        'storage-file $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def storage-file
            node/path-join (node/cwd) (:storage-file config/site)
          :examples $ []
          :schema $ quote String
        'sync-clients! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn sync-clients! (db)
            wss-each! $ fn (sid _socket)
              hint-fn $ Fn String ws-edn.server/NodeWebSocketHost $ -> Unit
              let
                  session $ result:unwrap-or
                    get-in db $ [] :sessions sid
                    , {}
                  new-store $ twig-container db $ decode-map-as session (Map Tag Dynamic)
                  changes $ match (get @*client-caches sid)
                    (:some old-store)
                      diff-twig old-store new-store $ {} $ :key :id
                    (:none)
                      diff-twig nil new-store $ {} $ :key :id
                when config/dev? $ println "|Changes for" sid |: $ count changes
                if
                  not $ empty? changes
                  do
                    wss-send! sid $ :: :patch changes
                    swap! *client-caches assoc sid new-store
              , &unit
            , &unit
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (-> Unit) (:features :io :js-ffi :state)
        'watch-file! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn watch-file! ()
            gaze
              js-array storage-file $ node/path-join (node/cwd) |deps.cirru
              fn (error watcher)
                if (non-nil? error) (js/console.error error)
                  .!on watcher |changed $ fn (_filepath) (js/setTimeout on-file-change! 20)
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi :state)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.server
          :require (app.schema :as schema)
            app.updater :refer $ updater
            app.util.env :refer $ pick-port! pick-http-port!
            |chalk :default chalk
            |path :as path
            |fs :as fs
            |gaze :default gaze
            |node:http :refer $ createServer
            |node:fs :refer $ readFile
            ws-edn.server :refer $ wss-serve! wss-send! wss-each!
            recollect.twig :refer $ clear-twig-caches!
            recollect.diff :refer $ diff-twig
            app.twig.container :refer $ twig-container
            app.util.env :refer $ check-version!
            app.config :as config
            cumulo-util.file :refer $ write-mildly!
            app.util.env :refer $ get-cli-configs!
            |nanoid :refer $ nanoid
            app.updater.analyze :refer $ parse-all-deps
            js-ffi.node :as node
            js-ffi.shared :as shared
            app.storage :as storage
            app.updater.watcher :as watcher
            app.updater.writer :as writer
    'app.source $ %{} 'FileEntry
      :defs $ {}
        'ImportedFile $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def ImportedFile
            defstruct :ImportedFile (:file app.schema/FileEntry) (:source-view String)
          :examples $ []
          :schema $ quote StructDef
        'SourceProject $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct SourceProject (:package String)
            :files $ Map String app.schema/FileEntry
            :configs $ Map Tag Dynamic
            :entries $ Map String $ Map Tag Dynamic
            :source-config String
            :source-revision String
            :source-templates $ Map Tag String
            :source-manifest-revision String
          :examples $ []
          :schema $ quote StructDef
        'SourceSave $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum SourceSave (:saved String) (:unchanged String)
          :examples $ []
          :schema $ quote EnumDef
        'editor-archive-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn editor-archive-state (db)
            select-keys db $ [] :package :files :saved-files :configs :saved-configs :entries :saved-entries :users :source-revision :source-manifest-revision
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |retain-baselines-without-runtime-state)
            :code $ quote $ let
                archive $ editor-archive-state $ {}
                  :files $ {}
                  :saved-files $ {} $ |pending |original
                  :saved-configs $ {} $ :version |1.0.0
                  :saved-entries $ {}
                  :source-revision |source
                  :source-manifest-revision |manifest
                  :sessions $ {} $ |secret |runtime
                  :usages-dict $ {}
              assert=
                Some $ {} $ |pending |original
                get archive :saved-files
              assert= (Some |manifest) (get archive :source-manifest-revision)
              assert= false $ contains? archive :sessions
              assert= false $ contains? archive :usages-dict
            :tags $ #{} :unit
        'entry-fields $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn entry-fields (raw expected-name)
            if (struct? raw)
              do
                assert= expected-name $ &struct:get-name raw
                &struct:to-map raw
              raise |Expected-CLI-entry-struct
          :examples $ []
          :schema $ quote $ Fn Dynamic Tag
            -> $ Map Tag Dynamic
        'export-cli-file $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn export-cli-file (file templates)
            let
                view $ .unwrap-or (:source-view file)
                  .unwrap $ get templates :file
                raw $ parse-cirru-edn view
                namespace-entry $ parse-cirru-edn $ export-entry (:ns file)
                  .unwrap $ get templates :ns
                  , :NsEntry
                definitions $ filter-map-kv (:defs file)
                  fn (name entry)
                    hint-fn $ Fn String schema/CodeEntry $ -> (MapEntryDecision Symbol Dynamic)
                    MapEntryDecision :keep (to-symbol name)
                      parse-cirru-edn $ export-entry entry
                        .unwrap $ get templates :def
                        , :CodeEntry
              if (struct? raw)
                do
                  assert= :FileEntry $ &struct:get-name raw
                  format-cirru-edn $ &struct:assoc (&struct:assoc raw :ns namespace-entry) :defs definitions
                raise |Expected-official-namespace-view
          :examples $ []
          :schema $ quote $ Fn schema/FileEntry (Map Tag String) (-> String)
        'export-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn export-entry (entry template-view expected-name)
            let
                view $ .unwrap-or (:source-entry entry) template-view
                raw $ parse-cirru-edn view
                syntax $ schema/node->syntax $ schema/read-node (:code entry)
                code $ &cirru-nth
                  parse-cirru $ format-cirru $ [] syntax
                  , 0
              if (struct? raw)
                do
                  assert= expected-name $ &struct:get-name raw
                  format-cirru-edn $ &struct:assoc (&struct:assoc raw :code code) :doc $ :doc entry
                raise |Expected-official-entry-view
          :examples $ []
          :schema $ quote $ Fn schema/CodeEntry String Tag (-> String)
        'import-cli-file $ %{} 'CodeEntry
          :doc "|Read an official CLI namespace view into editor nodes while retaining its complete opaque source view. Only the syntax tree is projected; source metadata remains owned by the CLI."
          :code $ quote $ defn import-cli-file (view author timestamp)
            let
                fields $ entry-fields (parse-cirru-edn view) :FileEntry
                definitions $ decode-map-as
                  .unwrap $ get fields :defs
                  Map Symbol Dynamic
                file $ %{} schema/FileEntry
                  :ns $ import-entry
                    .unwrap $ get fields :ns
                    , :NsEntry author timestamp
                  :defs $ filter-map-kv definitions $ fn (name entry)
                    hint-fn $ Fn Symbol Dynamic $ -> (MapEntryDecision String schema/CodeEntry)
                    MapEntryDecision :keep (to-string name) (import-entry entry :CodeEntry author timestamp)
                  :source-view $ Some view
              %{} ImportedFile (:file file) (:source-view view)
          :examples $ []
          :schema $ quote $ Fn String String Number (-> ImportedFile) (:features :io)
          :tests $ [] $ %{} 'TestEntry (:name |official-view-to-editor-nodes)
            :code $ quote $ let
                view "|%{} 'FileEntry\n  :ns $ %{} 'NsEntry (:doc |namespace-doc)\n    :code $ quote $ ns demo.main\n  :defs $ {}\n    'keep $ %{} 'CodeEntry (:doc |definition-doc)\n      :code $ quote $ defn keep (value) $ [] value |中文 |🐈\n      :examples $ [] $ quote $ keep 1\n      :schema $ quote $ Fn Number $ -> $ List Dynamic\n      :tags $ #{} :fixture\n      :tests $ [] $ %{} 'TestEntry (:name |retained)\n        :code $ quote $ assert= 1 1\n        :tags $ #{} :unit\n"
                imported $ import-cli-file view |fixture 12
                file $ :file imported
                entry $ .unwrap $ get (:defs file) |keep
              assert= view $ :source-view imported
              assert= |namespace-doc $ :doc $ :ns file
              assert= |definition-doc $ :doc entry
              assert= ([] |ns |demo.main)
                schema/node->syntax $ schema/read-node $ :code (:ns file)
              assert=
                [] |defn |keep ([] |value) ([] |[] |value "||中文" "||🐈")
                schema/node->syntax $ schema/read-node $ :code entry
              assert= 1 $ .len $ :examples entry
              assert=
                .unwrap $ get
                  &struct:to-map $ parse-cirru-edn view
                  , :ns
                parse-cirru-edn $ .unwrap $ :source-entry (:ns file)
              assert=
                .unwrap $ get
                  decode-map-as
                    .unwrap $ get
                      &struct:to-map $ parse-cirru-edn view
                      , :defs
                    Map Symbol Dynamic
                  , 'keep
                parse-cirru-edn $ .unwrap $ :source-entry entry
              assert= (:source-entry entry)
                :source-entry $ assoc entry :doc |edited-doc
              let
                  templates $ {} (:file view)
                    :ns $ format-cirru-edn $ .unwrap
                      get
                        entry-fields (parse-cirru-edn view) :FileEntry
                        , :ns
                    :def $ format-cirru-edn $ .unwrap
                      get
                        decode-map-as
                          .unwrap $ get
                            entry-fields (parse-cirru-edn view) :FileEntry
                            , :defs
                          Map Symbol Dynamic
                        , 'keep
                  exported $ export-cli-file file templates
                  restored $ schema/read-file-entry $ parse-cirru-edn (format-cirru-edn file)
                assert= (parse-cirru-edn view) (parse-cirru-edn exported)
                assert= file restored
                assert= (Some view) (:source-view restored)
            :tags $ #{} :unit
        'import-cli-project $ %{} 'CodeEntry
          :doc "|Import only official CLI namespace views. Keep the full CLI config opaque and retain source templates/revision; do not parse or reconstruct the Snapshot root."
          :code $ quote $ defn import-cli-project (view author timestamp)
            let
                fields $ decode-map-as (parse-cirru-edn view) (Map Tag Dynamic)
                namespaces $ decode-map-as
                  .unwrap $ get fields :namespace-views
                  Map String String
                files $ filter-map-kv namespaces $ fn (name entry)
                  hint-fn $ Fn String String $ -> (MapEntryDecision String schema/FileEntry)
                  MapEntryDecision :keep name $ :file $ import-cli-file entry author timestamp
              SourceProject :package
                decode-map-as
                  .unwrap $ get fields :package
                  , 'String
                , :files files :configs
                  decode-map-as
                    .unwrap $ get fields :configs
                    Map Tag Dynamic
                  , :entries
                    decode-map-as
                      .unwrap $ get fields :entries
                      Map String $ Map Tag Dynamic
                    , :source-config
                      decode-map-as
                        .unwrap $ get fields :source-config
                        , 'String
                      , :source-revision
                        decode-map-as
                          .unwrap $ get fields :source-revision
                          , 'String
                        , :source-templates
                          decode-map-as
                            .unwrap $ get fields :source-templates
                            Map Tag String
                          , :source-manifest-revision $ decode-map-as
                            .unwrap $ get fields :source-manifest-revision
                            , 'String
          :examples $ []
          :schema $ quote $ Fn String String Number (-> SourceProject) (:features :io)
        'import-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn import-entry (raw expected-name author timestamp)
            let
                fields $ entry-fields raw expected-name
                syntax $ .unwrap $ get fields :code
                doc $ decode-map-as
                  .unwrap $ get fields :doc
                  , 'String
                examples $ decode-map-as
                  .unwrap-or (get fields :examples) ([])
                  List Dynamic
              %{} schema/CodeEntry (:doc doc) (:examples examples)
                :code $ cirru->tree syntax author timestamp
                :source-entry $ Some $ format-cirru-edn raw
          :examples $ []
          :schema $ quote $ Fn Dynamic Tag String Number (-> schema/CodeEntry) (:features :io)
        'plan-namespace-changes $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn plan-namespace-changes (files saved-files selected templates)
            filter-map-kv (merge saved-files files)
              fn (namespace _file)
                hint-fn $ Fn String schema/FileEntry $ ->
                  MapEntryDecision String $ Option String
                let
                    selected? $ match selected
                      (:some name) (= name namespace)
                      (:none) true
                    current $ get files namespace
                    previous $ get saved-files namespace
                  if
                    or (not selected?) (= current previous)
                    MapEntryDecision :drop
                    match current
                      (:none) (MapEntryDecision :keep namespace None)
                      (:some file)
                        MapEntryDecision :keep namespace $ Some $ export-cli-file file templates
          :examples $ []
          :schema $ quote $ Fn (Map String schema/FileEntry) (Map String schema/FileEntry) (Option String) (Map Tag String)
            -> $ Map String $ Option String
        'read-source-save $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-source-save (raw)
            let
                fields $ decode-map-as raw $ Map Tag Dynamic
                changed? $ decode-map-as
                  .unwrap $ get fields :changed
                  , 'Bool
                revision $ decode-map-as
                  .unwrap $ get fields :source-revision
                  , 'String
              if changed? (SourceSave :saved revision) (SourceSave :unchanged revision)
          :examples $ []
          :schema $ quote $ Fn Input (-> SourceSave) (:generics Input)
        'restore-editor-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn restore-editor-state (project archive)
            let
                read-files $ fn (raw-files)
                  hint-fn $ Fn Dynamic $ -> (Map String schema/FileEntry)
                  filter-map-kv
                    decode-map-as raw-files $ Map String Dynamic
                    fn (name file)
                      hint-fn $ Fn String Dynamic $ -> (MapEntryDecision String schema/FileEntry)
                      MapEntryDecision :keep name $ schema/read-file-entry file
                base $ ->
                  merge schema/database $ &struct:to-map project
                  assoc :saved-files $ :files project
                  assoc :configs $ merge schema/configs $ :configs project
                  assoc :saved-configs $ merge schema/configs $ :configs project
                  assoc :saved-entries $ :entries project
              match archive
                (:none) base
                (:some raw)
                  let
                      fields $ decode-map-as raw $ Map Tag Dynamic
                      revision $ decode-map-as
                        .unwrap $ get fields :source-revision
                        , 'String
                    if
                      not= revision $ :source-revision project
                      raise "|The project Snapshot changed since the editor archive was saved. Keep both files and resolve the source changes before restoring pending edits."
                      if
                        not=
                          decode-map-as
                            .unwrap $ get fields :source-manifest-revision
                            , 'String
                          :source-manifest-revision project
                        raise "|The dependency manifest changed since the editor archive was saved. Keep both files and reload before restoring pending edits."
                        let
                            files $ read-files $ .unwrap (get fields :files)
                            saved-files $ match (get fields :saved-files)
                              (:some saved) (read-files saved)
                              (:none) (:files project)
                            users $ decode-map-as
                              .unwrap-or (get fields :users) ({})
                              Map String $ Map Tag Dynamic
                            configs $ decode-map-as
                              .unwrap-or (get fields :configs) (:configs project)
                              Map Tag Dynamic
                            entries $ decode-map-as
                              .unwrap-or (get fields :entries) (:entries project)
                              Map String $ Map Tag Dynamic
                            package $ decode-map-as
                              .unwrap-or (get fields :package) (:package project)
                              , 'String
                          merge base $ {} (:files files) (:users users) (:entries entries) (:package package)
                            :configs $ merge schema/configs configs
                            :saved-files saved-files
                            :saved-configs $ decode-map-as
                              .unwrap-or (get fields :saved-configs)
                                merge schema/configs $ :configs project
                              Map Tag Dynamic
                            :saved-entries $ decode-map-as
                              .unwrap-or (get fields :saved-entries) (:entries project)
                              Map String $ Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn SourceProject (Option Dynamic)
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry
            :name |pending-edits-require-the-original-source-revision
            :code $ quote $ let
                entry $ %{} schema/CodeEntry (:doc |saved)
                  :code $ schema/syntax->node ([] |ns |demo.main) |source 0
                  :examples $ []
                  :source-entry None
                file $ %{} schema/FileEntry (:ns entry)
                  :defs $ {}
                  :source-view None
                project $ %{} SourceProject (:package |demo)
                  :files $ {} $ |demo.main file
                  :configs $ {} $ :version |1.0.0
                  :entries $ {}
                  :source-config "|{\"keep\": \"all entry metadata\"}"
                  :source-revision |fixture-revision
                  :source-templates $ {}
                  :source-manifest-revision |fixture-manifest
                edited $ struct-with file $ :ns
                  struct-with entry $ :doc |pending
                archive $ {} (:source-revision |fixture-revision)
                  :files $ {} $ |demo.main edited
                  :users $ {} $ |fixture
                    {} $ :nickname "|合成成员"
                  :source-manifest-revision |fixture-manifest
                restored $ restore-editor-state project $ Some
                  parse-cirru-edn $ format-cirru-edn archive
                rejected? $ try
                  do
                    restore-editor-state project $ Some $ assoc archive :source-revision |other-revision
                    , false
                  fn (_error) true
                historical $ struct-with file $ :ns
                  struct-with entry $ :code $ schema/syntax->node ([] |ns |demo.main) |historical-author 21
                manifest-rejected? $ try
                  do
                    restore-editor-state project $ Some $ assoc archive :source-manifest-revision |other-manifest
                    , false
                  fn (_error) true
              assert= true rejected?
              assert=
                Some $ :source-config project
                get restored :source-config
              assert=
                Some $ :files project
                get restored :saved-files
              assert=
                Some $ {} $ |demo.main edited
                get restored :files
              assert= (:files project)
                .unwrap $ get (restore-editor-state project None) :files
              assert=
                Some $ {} $ |demo.main historical
                get
                  restore-editor-state project $ Some $ assoc archive :saved-files
                    {} $ |demo.main historical
                  , :saved-files
              assert= true manifest-rejected?
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.source
          :require (app.schema :as schema)
            app.util :refer $ cirru->tree
    'app.storage $ %{} 'FileEntry
      :defs $ {}
        'load-project-state! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn load-project-state! (snapshot)
            let
                project $ read-source-project! snapshot
                contents $ readEditorArchive snapshot
                archive $ if (nil? contents) None $ Some
                  parse-cirru-edn $ js-ffi.contract/expect-string |editor-state contents
              source/restore-editor-state project archive
          :examples $ []
          :schema $ quote $ Fn String
            -> $ Map Tag Dynamic
            :features :io :js-ffi
        'read-source-project! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-source-project! (snapshot)
            source/import-cli-project
              decode-map-as (readSnapshotEdn snapshot) 'String
              , |source 0
          :examples $ []
          :schema $ quote $ Fn String (-> source/SourceProject) (:features :io :js-ffi)
        'save-editor-state! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn save-editor-state! (snapshot db)
            writeEditorArchive snapshot $ format-cirru-edn $ source/editor-archive-state db
            , &unit
          :examples $ []
          :schema $ quote $ Fn String (Map Tag Dynamic) (-> Unit) (:features :js-ffi)
        'save-project! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn save-project! (snapshot db selected)
            let
                revision $ decode-map-as
                  .unwrap $ get db :source-revision
                  , 'String
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                saved-files $ decode-map-as
                  .unwrap $ get db :saved-files
                  Map String app.schema/FileEntry
                templates $ decode-map-as
                  .unwrap $ get db :source-templates
                  Map Tag String
                configs $ decode-map-as
                  .unwrap $ get db :configs
                  Map Tag Dynamic
                entries $ decode-map-as
                  .unwrap $ get db :entries
                  Map String $ Map Tag Dynamic
                changes $ source/plan-namespace-changes files saved-files selected templates
                settings $ {} (:configs configs) (:entries entries)
              source/read-source-save $ parse-cirru-edn $ decode-map-as
                writeProjectChangesEdn snapshot revision (format-cirru-edn changes) (format-cirru-edn settings)
                , 'String
          :examples $ []
          :schema $ quote $ Fn String (Map Tag Dynamic) (Option String) (-> source/SourceSave) (:features :js-ffi)
        'save-source-files! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn save-source-files! (snapshot revision files saved-files selected templates)
            write-namespace-changes! snapshot revision $ source/plan-namespace-changes files saved-files selected templates
          :examples $ []
          :schema $ quote $ Fn String String (Map String app.schema/FileEntry) (Map String app.schema/FileEntry) (Option String) (Map Tag String) (-> source/SourceSave) (:features :js-ffi)
        'write-namespace-changes! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn write-namespace-changes! (snapshot revision changes)
            source/read-source-save $ parse-cirru-edn $ decode-map-as
              writeSnapshotChangesEdn snapshot revision $ format-cirru-edn changes
              , 'String
          :examples $ []
          :schema $ quote $ Fn String String
            Map String $ Option String
            -> source/SourceSave
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.storage
          :require (app.source :as source)
            |../snapshot-cli.mjs :refer $ readSnapshotEdn writeSnapshotChangesEdn writeProjectChangesEdn readEditorArchive writeEditorArchive
    'app.style $ %{} 'FileEntry
      :defs $ {}
        'button $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle button
            {}
              |& $ {}
                :background-color $ hsl 0 0 100 0
                :text-decoration :underline
                :color $ hsl 0 0 100 0.4
                :min-width 40
                :vertical-align :middle
                :border :none
                :min-width 80
                :line-height |30px
                :font-size 14
                :text-align :center
                :padding "|0 8px"
                :outline :none
                :cursor :pointer
                :transition-duration |200ms
              |&:hover $ {} $ :color (hsl 0 0 100 0.6)
          :examples $ []
          :schema $ quote String
        'input $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle input
            {} $ |& $ merge ui/input
              {}
                :background-color $ hsl 0 0 100 0.16
                :color $ hsl 0 0 100
                :font-family |Menlo,monospace
                :border :none
          :examples $ []
          :schema $ quote String
        'inspector $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def inspector
            {} (:opacity 0.9)
              :background-color $ hsl 0 0 90
              :color :black
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle title
            {} $ |& $ {} (:font-family ui/font-fancy) (:font-size 18) (:font-weight 100)
              :color $ hsl 0 0 80
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.style
          :require (respo-ui.core :as ui)
            respo.util.format :refer $ hsl
            respo.css :refer $ defstyle
    'app.theme $ %{} 'FileEntry
      :defs $ {}
        'base-style-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn base-style-expr (theme)
            match theme (:star-trail star-trail/css-expr) (:curves curves/css-expr) (:beginner beginner/css-expr) (_ |css-expr-unknown)
          :examples $ []
          :schema $ quote $ Fn Tag (-> String)
        'base-style-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn base-style-leaf (theme)
            match theme (:star-trail star-trail/css-leaf) (:curves curves/css-leaf) (:beginner beginner/css-leaf) (_ |css-leaf-unknown)
          :examples $ []
          :schema $ quote $ Fn Tag (-> String)
        'decide-expr-theme $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-expr-theme
            expr has-others? focused? focus-in? tail? layout-mode length depth theme
            match theme
              :star-trail $ star-trail/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth
              :curves $ curves/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth
              :beginner $ beginner/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth
              _ $ {}
          :examples $ []
          :schema $ quote $ Fn app.schema/CirruExprShape Bool Bool Bool Bool Tag Number Number Tag
            -> $ Map Tag respo.schema/CssValue
        'decide-leaf-theme $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-leaf-theme (text focused? first? by-other? theme)
            match theme
              :star-trail $ star-trail/decide-leaf-style text focused? first? by-other?
              :curves $ curves/decide-leaf-style text focused? first? by-other?
              :beginner $ beginner/decide-leaf-style text focused? first? by-other?
              _ $ {}
          :examples $ []
          :schema $ quote $ Fn String Bool Bool Bool Tag
            -> $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.theme
          :require (app.theme.star-trail :as star-trail) (app.theme.curves :as curves) (app.theme.beginner :as beginner)
    'app.theme.beginner $ %{} 'FileEntry
      :defs $ {}
        'css-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def css-expr star-trail/css-expr
          :examples $ []
          :schema $ quote String
        'css-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def css-leaf star-trail/css-leaf
          :examples $ []
          :schema $ quote String
        'decide-expr-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-expr-style (expr has-others? focused? focus-in? tail? layout-mode length depth)
            merge
              star-trail/decide-expr-style expr has-others? focused? focus-in? tail? layout-mode length depth
              , style-expr-beginner
          :examples $ []
          :schema $ quote $ Fn app.schema/CirruExprShape Bool Bool Bool Bool Tag Number Number
            -> $ Map Tag respo.schema/CssValue
        'decide-leaf-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-leaf-style (text focused? first? by-other?)
            merge $ star-trail/decide-leaf-style text focused? first? by-other?
          :examples $ []
          :schema $ quote $ Fn String Bool Bool Bool
            -> $ Map Tag respo.schema/CssValue
        'style-expr-beginner $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-expr-beginner
            {} $ :outline $ str "|1px solid " (hsl 200 80 70 0.2)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.theme.beginner
          :require (app.theme.star-trail :as star-trail)
            respo.util.format :refer $ hsl
    'app.theme.curves $ %{} 'FileEntry
      :defs $ {}
        'css-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def css-expr star-trail/css-expr
          :examples $ []
          :schema $ quote String
        'css-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def css-leaf star-trail/css-leaf
          :examples $ []
          :schema $ quote String
        'decide-expr-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-expr-style (expr has-others? focused? focus-in? tail? layout-mode length depth)
            let
                base $ assert-type
                  {} (:border-radius |16px) (:display :inline-block) (:border-width "|0 1px")
                    :border-color $ hsl 0 0 80 0.5
                    :padding "|4px 8px"
                  Map Tag respo.schema/CssValue
              if focused?
                assoc base :border-color $ hsl 0 0 100 0.8
                , base
          :examples $ []
          :schema $ quote $ Fn app.schema/CirruExprShape Bool Bool Bool Bool Tag Number Number
            -> $ Map Tag respo.schema/CssValue
        'decide-leaf-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-leaf-style (text focused? first? by-other?)
            merge (star-trail/decide-leaf-style text focused? first? by-other?) ({})
          :examples $ []
          :schema $ quote $ Fn String Bool Bool Bool
            -> $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.theme.curves
          :require (app.theme.star-trail :as star-trail)
            respo.util.format :refer $ hsl
            respo.css :refer $ defstyle
    'app.theme.star-trail $ %{} 'FileEntry
      :defs $ {}
        'RegexHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait RegexHost
            .test $ Fn app.theme.star-trail/RegexHost String $ -> Bool
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
          :schema $ quote Trait
        'base-style-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn base-style-expr () css-expr
          :examples $ []
          :schema $ quote $ Fn (-> String)
        'base-style-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn base-style-leaf () style-leaf
          :examples $ []
          :schema $ quote $ Fn
            -> $ Map Tag respo.schema/CssValue
        'css-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-expr
            {} $ |$0 $ {} (:border-width "|0 0 0px 1px") (:border-style :solid) (:min-height 24) (:outline :none) (:padding-left 10) (:font-family |Menlo,monospace) (:font-size 13) (:margin-bottom 2) (:margin-right 1) (:margin-left 8) (:line-height |1em) (:border-radius |8px) (:transition-duration |200ms) (:transition-property |background,opacity,border-color)
              :border-color $ hsl 200 100 76 0.5
          :examples $ []
          :schema $ quote String
        'css-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle css-leaf
            {} $ |$0 style-leaf
          :examples $ []
          :schema $ quote String
        'decide-expr-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-expr-style (expr has-others? focused? focus-in? tail? layout-mode length depth)
            -> ({})
              merge-style-if has-others? $ {} $ :border-color (hsl 0 0 100 0.6)
              merge-style-if focused? $ {} $ :border-color (hsl 0 0 100 0.9)
              merge-style-if focus-in? $ {} $ :opacity 1
              merge-style-if
                and (> length 0) (not tail?) (not= layout-mode :block)
                , style-expr-simple
              merge-style-if tail? style-expr-tail
          :examples $ []
          :schema $ quote $ Fn app.schema/CirruExprShape Bool Bool Bool Bool Tag Number Number
            -> $ Map Tag respo.schema/CssValue
        'decide-leaf-style $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decide-leaf-style (text focused? first? by-other?)
            let
                has-blank? $ or (= text |) (&str:includes? text "| ")
                best-width $ + 8 $ text-width* text leaf-font-size leaf-font-family
                max-width 240
              ->
                {} $ :width $ &max 9 (&min best-width max-width)
                merge-style-if first? $ {} $ :color (hsl 40 85 60)
                merge-style-if (starts-with? text |:)
                  {} $ :color $ hsl 240 30 64
                merge-style-if
                  or (starts-with? text ||) (starts-with? text "|\"")
                  {} $ :color $ hsl 120 60 56
                merge-style-if (starts-with? text "|#\"")
                  {} $ :color $ hsl 300 60 56
                merge-style-if
                  or (= text |true) (= text |false)
                  {} $ :color $ hsl 250 50 60
                merge-style-if (= text |nil)
                  {} $ :color $ hsl 310 60 40
                merge-style-if (> best-width max-width) style-partial
                merge-style-if (&str:includes? text &newline) style-big
                merge-style-if (number-prefix? text) style-number
                merge-style-if has-blank? style-space
                merge-style-if (or focused? by-other?) style-highlight
          :examples $ []
          :schema $ quote $ Fn String Bool Bool Bool
            -> $ Map Tag respo.schema/CssValue
        'leaf-font-family $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def leaf-font-family ui/font-code
          :examples $ []
          :schema $ quote String
        'leaf-font-size $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def leaf-font-size 14
          :examples $ []
          :schema $ quote Number
        'merge-style-if $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn merge-style-if (base condition extra)
            if condition (merge base extra) base
          :examples $ []
          :schema $ quote $ Fn (Map Tag respo.schema/CssValue) Bool (Map Tag respo.schema/CssValue)
            -> $ Map Tag respo.schema/CssValue
        'number-prefix? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn number-prefix? (text)
            let
                pattern $ unsafe-coerce (new js/RegExp |^-?\d) 'app.theme.star-trail/RegexHost
              .test pattern text
          :examples $ []
          :schema $ quote $ Fn String (-> Bool) (:features :js-ffi)
        'style-big $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-big
            {} $ :border-right $ str "|16px solid " (hsl 0 0 30)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-expr-simple $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-expr-simple
            {} (:display :inline-block) (:border-width "|0 0 1px 0") (:min-width 32) (:padding-left 11) (:padding-right 11) (:padding-bottom -1) (:vertical-align :top)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-expr-tail $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-expr-tail
            {} (:display :inline-block) (:vertical-align :top) (:padding-left 10)
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-highlight $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-highlight
            {} $ :background-color $ hsl 0 0 100 0.2
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-leaf
            {} (:line-height |24px) (:height 24) (:margin "|1px 1px") (:padding "|0px 4px") (:background-color :transparent) (:min-width 8) (:font-family leaf-font-family) (:font-size leaf-font-size) (:vertical-align :baseline) (:text-align :left) (:border-width "|1px 1px 1px 1px") (:resize :none) (:white-space :nowrap) (:outline :none) (:border :none) (:border-radius |6px) (:transition-duration |100ms) (:transition-property |background,opacity,border-color)
              :color $ hsl 200 14 60
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-number $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-number
            {} $ :color $ hsl 0 70 40
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-partial $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-partial
            {}
              :border-right $ str "|8px solid " $ hsl 0 0 30
              :padding-right 0
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
        'style-space $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def style-space
            {} $ :background-color $ hsl 0 0 100 0.12
          :examples $ []
          :schema $ quote $ Map Tag respo.schema/CssValue
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.theme.star-trail
          :require
            respo.util.format :refer $ hsl
            respo-ui.core :as ui
            app.polyfill :refer $ text-width*
            app.style :as style
            respo.css :refer $ defstyle
    'app.twig.container $ %{} 'FileEntry
      :defs $ {} $ 'twig-container
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-container (db session)
            let
                user-id $ app.schema/read-optional-text $ get session :user-id
                logged-in? $ .some? user-id
                route $ app.updater.router/read-route $ .unwrap-or (get session :router) (:: :files)
                watching? $ match route
                  (:watching _sid) true
                  _ false
                sessions $ decode-map-as
                  .unwrap-or (get db :sessions) ({})
                  Map String $ Map Tag Dynamic
                users $ decode-map-as
                  .unwrap-or (get db :users) ({})
                  Map String $ Map Tag Dynamic
                files $ decode-map-as
                  .unwrap-or (get db :files) ({})
                  Map String app.schema/FileEntry
                old-files $ decode-map-as
                  .unwrap-or (get db :saved-files) ({})
                  Map String app.schema/FileEntry
                writer $ decode-map-as
                  .unwrap-or (get session :writer) ({})
                  Map Tag Dynamic
                sid $ decode-map-as
                  .unwrap-or (get session :id) |
                  , 'String
              if (or logged-in? watching?)
                {}
                  :session $ dissoc session :router
                  :logged-in? logged-in?
                  :user $ app.twig.user/session-user users session
                  :router $ match route
                    (:files)
                      :: :files $ twig-page-files files
                        app.schema/read-optional-text $ get writer :selected-ns
                        , old-files
                          app.schema/read-optional-text $ get writer :draft-ns
                          , sessions sid $ decode-map-as
                            .unwrap-or (get db :source-templates) ({})
                            Map Tag String
                    (:graph)
                      :: :graph $ {}
                        :package $ .unwrap-or (get db :package) |
                        :configs $ .unwrap-or (get db :configs) ({})
                        :deps-dict $ .unwrap-or (get db :deps-dict) ({})
                        :entries $ .unwrap-or (get db :entries) ({})
                        :writer writer
                    (:editor)
                      :: :editor $ twig-page-editor files old-files sessions users writer sid $ decode-map-as
                        .unwrap-or (get db :usages-dict) ({})
                        Map Dynamic Dynamic
                    (:profile)
                      :: :profile $ {} $ :members (twig-page-members sessions users)
                    (:search)
                      :: :search $ twig-search files
                    (:watching peer-id)
                      :: :watching $ .map (get sessions peer-id)
                        fn (peer)
                          hint-fn $ Fn (Map Tag Dynamic)
                            -> $ Map Tag Dynamic
                          twig-watching peer sid files users
                    (:configs)
                      :: :configs $ {}
                        :configs $ .unwrap-or (get db :configs) ({})
                        :entries $ .unwrap-or (get db :entries) ({})
                  :stats $ {} $ :members-count (count sessions)
                {} (:session session) (:logged-in? false)
                  :stats $ {} $ :members-count 0
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Map Tag Dynamic)
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |guest-watching-missing-peer-and-public-frame)
            :code $ quote $ let
                peer $ {} (:id |peer) (:user-id |user)
                  :router $ :: :editor
                  :writer $ {}
                    :stack $ []
                    :pointer 0
                guest $ {} (:id |viewer) (:user-id nil)
                  :router $ :: :watching |peer
                  :writer $ {}
                db $ {}
                  :files $ {}
                  :saved-files $ {}
                  :sessions $ {} $ |peer peer
                  :users $ {} $ |user
                    {} (:nickname |Public) (:password |synthetic-private)
                frame $ twig-container db guest
                restored $ parse-cirru-edn $ format-cirru-edn frame
                public $ match
                  .unwrap $ get restored :router
                  (:watching value)
                    .unwrap $ app.comp.watching/read-watching-frame value
                  _ $ raise |Expected-watching-route
                missing $ twig-container
                  assoc db :sessions $ {}
                  , guest
                missing-peer? $ match
                  .unwrap $ get missing :router
                  (:watching value)
                    .none? $ app.comp.watching/read-watching-frame value
                  _ false
                login $ twig-container db $ assoc guest :router (:: :files)
              assert= false $ .unwrap $ get frame :logged-in?
              assert= true missing-peer?
              assert= None $ get login :router
              assert= None $ get
                decode-map-as
                  .unwrap $ get public :member
                  Map Tag Dynamic
                , :password
              assert= true $ .some? $ app.comp.watching/read-watching-frame public
              assert= None $ app.comp.watching/read-watching-frame nil
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.container
          :require
            app.twig.user :refer $ twig-user
            app.twig.page-files :refer $ twig-page-files
            app.twig.page-editor :refer $ twig-page-editor
            app.twig.page-members :refer $ twig-page-members
            app.twig.search :refer $ twig-search
            app.twig.watching :refer $ twig-watching
            app.updater.analyze :refer $ parse-all-deps
    'app.twig.member $ %{} 'FileEntry
      :defs $ {} $ 'twig-member
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-member (session user)
            let
                router $ .unwrap-or (get session :router) (:: :files)
                page $ if (enum? router)
                  decode-map-as (&enum:nth router 0) 'Tag
                  raise |Expected-session-router
              let
                  member $ {}
                    :user $ app.twig.user/twig-user user
                    :bookmark $ app.util/to-bookmark $ get session :writer
                    :page page
                match (get session :nickname)
                  (:none) (assoc member :nickname nil)
                  (:some value) (assoc member :nickname value)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Map Tag Dynamic)
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry
            :name |public-member-excludes-password-and-keeps-bookmark
            :code $ quote $ let
                bookmark $ app.bookmark/%bookmark :def |demo.main |render $ [] |1
                session $ {} (:user-id |fixture)
                  :router $ :: :editor
                  :writer $ {} (:pointer 0)
                    :stack $ [] bookmark
                user $ {} (:nickname "|合成成员") (:password |synthetic-secret)
                member $ twig-member session user
                public-user $ decode-map-as
                  .unwrap $ get member :user
                  Map Tag Dynamic
              assert= false $ contains? public-user :password
              assert= (Some "|合成成员") (get public-user :nickname)
              assert= (Some :editor) (get member :page)
              assert= (Some bookmark)
                .unwrap $ get member :bookmark
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.member (:require)
    'app.twig.page-editor $ %{} 'FileEntry
      :defs $ {}
        'bookmark-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn bookmark-entry (files bookmark)
            match
              get files $ app.bookmark/get-namespace bookmark
              (:none) None
              (:some file)
                match bookmark
                  (:ns _namespace _focus)
                    Some $ :ns file
                  (:def _namespace name _focus)
                    get (:defs file) name
          :examples $ []
          :schema $ quote $ Fn (Map String app.schema/FileEntry) app.bookmark/%bookmark
            -> $ Option app.schema/CodeEntry
        'collaborators $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn collaborators (sessions users bookmark session-id)
            filter-map-kv sessions $ fn (sid session)
              hint-fn $ Fn String (Map Tag Dynamic)
                -> $ MapEntryDecision String $ Map Tag Dynamic
              if (= sid session-id) (MapEntryDecision :drop)
                match
                  .unwrap-or (get session :router) (:: :files)
                  (:editor)
                    match
                      app.util/to-bookmark $ get session :writer
                      (:some candidate)
                        if (= candidate bookmark)
                          let
                              user $ app.twig.user/session-user users session
                            MapEntryDecision :keep sid $ {}
                              :focus $ app.bookmark/get-focus candidate
                              :nickname $ .unwrap-or
                                app.schema/read-optional-text $ get user :nickname
                                , |Someone
                              :session-id sid
                          MapEntryDecision :drop
                      (:none) (MapEntryDecision :drop)
                  _ $ MapEntryDecision :drop
          :examples $ []
          :schema $ quote $ Fn
            Map String $ Map Tag Dynamic
            Map String $ Map Tag Dynamic
            , app.bookmark/%bookmark String
              -> $ Map String $ Map Tag Dynamic
        'import-rule-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn import-rule-entry (rule)
            match rule
              (List fields)
                let
                    source $ match
                      .unwrap $ first fields
                      (String text) text
                      (List _nested) (raise |Expected-import-source-token)
                    names $ match
                      .unwrap $ last fields
                      (String alias)
                        [] $ str alias |/
                      (List referred)
                        filter
                          decode-map-as referred $ List String
                          fn (text)
                            hint-fn $ Fn String $ -> Bool
                            not= text |[]
                  [] source names
              (String _text) (raise |Expected-import-rule-list)
          :examples $ []
          :schema $ quote $ Fn app.schema/CirruSyntax
            -> $ Tuple String $ List String
        'namespace-locals $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn namespace-locals (files bookmark)
            match bookmark
              (:ns namespace _focus)
                match (get files namespace)
                  (:some file)
                    Some $ keys $ :defs file
                  (:none) None
              (:def _namespace _name _focus) None
          :examples $ []
          :schema $ quote $ Fn (Map String app.schema/FileEntry) app.bookmark/%bookmark
            -> $ Option $ Set String
        'peek-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn peek-entry (files writer)
            match (get writer :peek-def)
              (:none) None
              (:some raw)
                if (nil? raw) None $ let
                    fields $ decode-map-as raw $ Map Tag Dynamic
                    namespace $ decode-map-as
                      .unwrap $ get fields :ns
                      , 'String
                    name $ decode-map-as
                      .unwrap $ get fields :def
                      , 'String
                  match (get files namespace)
                    (:none) None
                    (:some file)
                      get (:defs file) name
          :examples $ []
          :schema $ quote $ Fn (Map String app.schema/FileEntry) (Map Tag Dynamic)
            -> $ Option app.schema/CodeEntry
        'pick-from-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn pick-from-ns (ns-info)
            let
                code $ app.schema/read-node $ :code (:ns ns-info)
                declarations $ match code
                  (app.schema/CirruExprShape expr) (app.schema/expr->syntax expr)
                  (app.schema/CirruLeafShape _leaf) (raise |Expected-namespace-expression)
                rules $ match (nth declarations 2)
                  (:none) ([])
                  (:some clause)
                    match clause
                      (List parts) (rest parts)
                      (String _text) (raise |Expected-namespace-require-clause)
                imported $ pairs-map $ map rules import-rule-entry
              {} (:imported imported)
                :defined $ keys $ :defs ns-info
          :examples $ []
          :schema $ quote $ Fn app.schema/FileEntry
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |typed-namespace-imports-and-wire-node)
            :code $ quote $ let
                syntax $ [] |ns |demo.main $ [] |:require ([] |lib.core |:as |lib)
                  [] |util.core |:refer $ [] |[] |keep "|中文"
                code $ app.schema/syntax->node syntax |author 1
                entry $ %{} app.schema/CodeEntry (:doc |module) (:code code)
                  :examples $ []
                  :source-entry None
                file $ %{} app.schema/FileEntry (:ns entry)
                  :defs $ {} $ |main! entry
                  :source-view None
                info $ pick-from-ns file
              assert=
                Some $ {}
                  |lib.core $ [] |lib/
                  |util.core $ [] |keep "|中文"
                get info :imported
              assert=
                Some $ #{} |main!
                get info :defined
              let
                  raw-code $ parse-cirru-edn $ format-cirru-edn code
                  restored-file $ %{} app.schema/FileEntry
                    :ns $ %{} app.schema/CodeEntry (:doc |module)
                      :code $ app.schema/read-node raw-code
                      :examples $ []
                      :source-entry None
                    :defs $ {}
                    :source-view None
                assert= (get info :imported)
                  get (pick-from-ns restored-file) :imported
              let
                  no-imports $ app.schema/syntax->node ([] |ns |empty.main) |author 1
                  empty-file $ %{} app.schema/FileEntry
                    :ns $ %{} app.schema/CodeEntry (:doc |) (:code no-imports)
                      :examples $ []
                      :source-entry None
                    :defs $ {}
                    :source-view None
                assert=
                  Some $ {}
                  get (pick-from-ns empty-file) :imported
            :tags $ #{} :unit
        'twig-page-editor $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-page-editor (files old-files sessions users writer session-id usages-dict)
            match
              app.util/to-bookmark $ Some writer
              (:none)
                {}
                  :focus $ []
                  :others $ {}
                  :watchers $ {}
                  :expr None
                  :peek-def None
                  :preview-locals None
                  :picker-choices $ {}
                  :changed :same
                  :usages nil
              (:some bookmark)
                let
                    namespace $ app.bookmark/get-namespace bookmark
                    choices $ if
                      match (get writer :picker-mode)
                        (:none) false
                        (:some value) (non-nil? value)
                      (get files namespace) .map $ fn (file)
                        hint-fn $ Fn app.schema/FileEntry $ -> (Map Tag Dynamic)
                        pick-from-ns file
                      , None
                    usages $ match bookmark
                      (:def namespace name _focus)
                        get usages-dict $ :: :reference namespace name
                      (:ns _namespace _focus) None
                  let
                      response $ {}
                        :focus $ app.bookmark/get-focus bookmark
                        :others $ collaborators sessions users bookmark session-id
                        :watchers $ watchers sessions users session-id
                        :expr $ bookmark-entry files bookmark
                        :peek-def $ peek-entry files writer
                        :preview-locals $ namespace-locals files bookmark
                        :picker-choices $ .unwrap-or choices $ {}
                        :changed $ compare-entry (bookmark-entry files bookmark) (bookmark-entry old-files bookmark)
                    match usages
                      (:none) (assoc response :usages nil)
                      (:some value) (assoc response :usages value)
          :examples $ []
          :schema $ quote $ Fn (Map String app.schema/FileEntry) (Map String app.schema/FileEntry)
            Map String $ Map Tag Dynamic
            Map String $ Map Tag Dynamic
            Map Tag Dynamic
            , String (Map Dynamic Dynamic)
              -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |typed-entry-and-collaboration-wire-roundtrip)
            :code $ quote $ let
                ns-entry $ %{} app.schema/CodeEntry (:doc |Namespace)
                  :examples $ []
                  :source-entry None
                  :code $ app.schema/syntax->node
                    [] |ns |demo $ [] |:require
                    , |source 0
                def-entry $ %{} app.schema/CodeEntry (:doc |Definition)
                  :examples $ []
                  :source-entry None
                  :code $ app.schema/syntax->node
                    [] |defn |run ([]) |true
                    , |source 0
                file $ %{} app.schema/FileEntry (:ns ns-entry)
                  :defs $ {} $ |run def-entry
                  :source-view None
                files $ {} $ |demo file
                old-files $ {} $ |demo
                  app.schema/read-file-entry $ parse-cirru-edn $ format-cirru-edn file
                bookmark $ app.bookmark/%bookmark :def |demo |run $ []
                writer $ {}
                  :stack $ [] bookmark
                  :pointer 0
                  :peek-def $ {} (:ns |demo) (:def |run)
                self $ {} (:id |me) (:user-id |user)
                  :router $ :: :editor
                  :writer writer
                peer $ assoc self :id |peer
                idle $ assoc (assoc self :id |idle) :writer $ {}
                  :stack $ []
                  :pointer 0
                viewer $ assoc (assoc self :id |viewer) :router $ :: :watching |me
                sessions $ {} (|me self) (|peer peer) (|idle idle) (|viewer viewer)
                users $ {} $ |user
                  {} (:id |user) (:nickname |Public) (:password |synthetic-private)
                usages $ {} $
                  :: :reference |demo |run
                  #{} $ :: :def |demo |run
                frame $ twig-page-editor files old-files sessions users writer |me usages
                recovered $ app.schema/read-optional-code-entry $ .unwrap
                  get
                    parse-cirru-edn $ format-cirru-edn frame
                    , :expr
                watching $ app.twig.watching/twig-watching peer |me files users
                empty-frame $ twig-page-editor files files sessions users
                  {} $ :stack $ []
                  , |me $ {}
                ns-frame $ twig-page-editor files files sessions users
                  assoc writer :stack $ [] $ app.bookmark/%bookmark :ns |demo ([])
                  , |me $ {}
              assert= def-entry $ .unwrap recovered
              assert= :same $ .unwrap $ get frame :changed
              assert= (#{} |peer)
                keys $ decode-map-as
                  .unwrap $ get frame :others
                  Map String $ Map Tag Dynamic
              assert= (#{} |viewer)
                keys $ decode-map-as
                  .unwrap $ get frame :watchers
                  Map String $ Map Tag Dynamic
              assert= None $ get
                decode-map-as
                  .unwrap $ get watching :member
                  Map Tag Dynamic
                , :password
              assert= (Some def-entry)
                .unwrap $ get watching :expr
              assert= (Some def-entry)
                .unwrap $ get frame :peek-def
              assert= None $ .unwrap $ get empty-frame :expr
              assert= None $ .unwrap $ get frame :preview-locals
              assert=
                Some $ #{} |run
                app.comp.page-editor/read-preview-locals $ .unwrap $ get ns-frame :preview-locals
              assert= None $ app.comp.page-editor/read-preview-locals nil
              assert=
                Some $ #{} |run
                app.comp.page-editor/read-preview-locals $ #{} |run
              assert= true $ .unwrap $ get watching :working?
            :tags $ #{} :unit
        'watchers $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn watchers (sessions users session-id)
            filter-map-kv sessions $ fn (sid session)
              hint-fn $ Fn String (Map Tag Dynamic)
                -> $ MapEntryDecision String $ Map Tag Dynamic
              match
                .unwrap-or (get session :router) (:: :files)
                (:watching target)
                  if (= target session-id)
                    MapEntryDecision :keep sid $ app.twig.user/session-user users session
                    MapEntryDecision :drop
                _ $ MapEntryDecision :drop
          :examples $ []
          :schema $ quote $ Fn
            Map String $ Map Tag Dynamic
            Map String $ Map Tag Dynamic
            , String
              -> $ Map String $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.page-editor
          :require
            app.util :refer $ same-buffer? tree->cirru
            app.twig.user :refer $ twig-user
            app.util.list :refer $ compare-entry
            app.bookmark :as bookmark
    'app.twig.page-files $ %{} 'FileEntry
      :defs $ {}
        'keys-set $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn keys-set (x) (keys x)
          :examples $ []
          :schema $ quote $ Fn (Map String Dynamic)
            -> $ Set String
        'render-changed-files $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-changed-files (files saved-files)
            filter-map-kv (merge files saved-files)
              fn (namespace _file)
                hint-fn $ Fn String app.schema/FileEntry $ ->
                  MapEntryDecision String $ Map Tag Dynamic
                let
                    file $ get files namespace
                    saved-file $ get saved-files namespace
                    ns-change $ compare-entry
                      file .map $ fn (v)
                        hint-fn $ Fn app.schema/FileEntry $ -> app.schema/CodeEntry
                        :ns v
                      saved-file .map $ fn (v)
                        hint-fn $ Fn app.schema/FileEntry $ -> app.schema/CodeEntry
                        :ns v
                    defs $ match file
                      (:some value) (:defs value)
                      (:none) ({})
                    saved-defs $ match saved-file
                      (:some value) (:defs value)
                      (:none) ({})
                    def-changes $ filter-map-kv (merge defs saved-defs)
                      fn (name _entry)
                        hint-fn $ Fn String app.schema/CodeEntry $ -> (MapEntryDecision String Tag)
                        let
                            change $ compare-entry (get defs name) (get saved-defs name)
                          if
                            = (get defs name) (get saved-defs name)
                            MapEntryDecision :drop
                            MapEntryDecision :keep name change
                  if
                    and (= :same ns-change) (empty? def-changes)
                    MapEntryDecision :drop
                    MapEntryDecision :keep namespace $ {} (:ns ns-change) (:defs def-changes)
          :examples $ []
          :schema $ quote $ Fn (Map String app.schema/FileEntry) (Map String app.schema/FileEntry)
            -> $ Map String Dynamic
          :tests $ [] $ %{} 'TestEntry
            :name |equal-recovered-definitions-do-not-appear-changed
            :code $ quote $ let
                entry $ %{} app.schema/CodeEntry (:doc |same)
                  :code $ app.schema/syntax->node ([] |ns |demo.main) |fixture 12
                  :examples $ []
                  :source-entry None
                copy $ app.schema/read-code-entry $ parse-cirru-edn (format-cirru-edn entry)
                before $ %{} app.schema/FileEntry (:ns entry)
                  :defs $ {} $ |fresh entry
                  :source-view None
                after $ %{} app.schema/FileEntry (:ns entry)
                  :defs $ {} $ |fresh copy
                  :source-view None
              assert= ({})
                render-changed-files
                  {} $ |demo.main after
                  {} $ |demo.main before
            :tags $ #{} :unit
        'session-highlights $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn session-highlights (sessions sid)
            filter-map-kv sessions $ fn (session-id raw-session)
              hint-fn $ Fn String Dynamic $ -> (MapEntryDecision String app.bookmark/%bookmark)
              if (= session-id sid) (MapEntryDecision :drop)
                let
                    session $ decode-map-as raw-session $ Map Tag Dynamic
                    writer $ decode-map-as
                      .unwrap-or (get session :writer) ({})
                      Map Tag Dynamic
                    stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer :stack) ([])
                    pointer $ decode-map-as
                      .unwrap-or (get writer :pointer) 0
                      , 'Number
                  match (nth stack pointer)
                    (:some bookmark) (MapEntryDecision :keep session-id bookmark)
                    (:none) (MapEntryDecision :drop)
          :examples $ []
          :schema $ quote $ Fn (Map String Dynamic) String
            -> $ Map String app.bookmark/%bookmark
          :tests $ [] $ %{} 'TestEntry (:name |other-session-selected-bookmarks)
            :code $ quote $ let
                ns-bookmark $ app.bookmark/%bookmark :ns |demo.main $ [] |1
                def-bookmark $ app.bookmark/%bookmark :def |demo.main |render $ [] |2
                sessions $ {}
                  |self $ {} $ :writer
                    {} $ :stack $ [] ns-bookmark
                  |other $ {} $ :writer
                    {} (:pointer 1)
                      :stack $ [] ns-bookmark def-bookmark
                  |empty $ {} $ :writer
                    {} $ :stack $ []
                  |stale $ {} $ :writer
                    {} (:pointer 4)
                      :stack $ [] ns-bookmark
                  |missing $ {}
                wire $ parse-cirru-edn $ format-cirru-edn sessions
              assert=
                {} $ |other def-bookmark
                session-highlights wire |self
            :tags $ #{} :unit
        'twig-page-files $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-page-files (files selected-ns saved-files draft-ns sessions sid source-templates)
            {}
              :ns-dict $ &map:fold-kv files ({})
                fn (docs key value)
                  hint-fn $ Fn (Map String String) String app.schema/FileEntry $ -> (Map String String)
                  assoc docs key $ :doc $ :ns value
              :defs-dict $ match selected-ns
                (:some ns-name)
                  let
                      file-entry $ assert-type
                        .unwrap $ get files ns-name
                        , 'app.schema/FileEntry
                    &map:fold-kv (:defs file-entry) ({})
                      fn (docs key value)
                        hint-fn $ Fn (Map String String) String app.schema/CodeEntry $ -> (Map String String)
                        assoc docs key $ :doc value
                (:none) ({})
              :changed-files $ render-changed-files files saved-files
              :peeking-file $ match draft-ns
                (:some ns-name) (get files ns-name)
                (:none) None
              :highlights $ session-highlights sessions sid
              :source-templates source-templates
          :examples $ []
          :schema $ quote $ Fn (Map String app.schema/FileEntry) (Option String) (Map String app.schema/FileEntry) (Option String) (Map String Dynamic) String (Map Tag String)
            -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.page-files
          :require $ app.util.list :refer $ compare-entry
    'app.twig.page-members $ %{} 'FileEntry
      :defs $ {} $ 'twig-page-members
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-page-members (sessions users)
            filter-map-kv sessions $ fn (session-id session)
              hint-fn $ Fn String (Map Tag Dynamic)
                -> $ MapEntryDecision String $ Map Tag Dynamic
              MapEntryDecision :keep session-id $ twig-member session $ app.twig.user/lookup-session-user users session
          :examples $ []
          :schema $ quote $ Fn
            Map String $ Map Tag Dynamic
            Map String $ Map Tag Dynamic
            -> $ Map String $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.page-members
          :require $ app.twig.member :refer $ twig-member
    'app.twig.search $ %{} 'FileEntry
      :defs $ {} $ 'twig-search
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-search (files)
            mapcat (&map:to-list files)
              fn (entry)
                hint-fn $ Fn (Tuple String app.schema/FileEntry)
                  -> $ List app.bookmark/%bookmark
                let[] (namespace file) entry $ concat
                  [] $ bookmark/%bookmark :ns namespace $ []
                  map
                    &set:to-list $ keys $ :defs file
                    fn (name)
                      hint-fn $ Fn String $ -> app.bookmark/%bookmark
                      bookmark/%bookmark :def namespace name $ []
          :examples $ []
          :schema $ quote $ Fn (Map String app.schema/FileEntry)
            -> $ List app.bookmark/%bookmark
          :tests $ [] $ %{} 'TestEntry
            :name |source-file-entries-become-recoverable-wire-bookmarks
            :code $ quote $ let
                entry $ %{} app.schema/CodeEntry (:doc |)
                  :examples $ []
                  :source-entry None
                  :code $ app.schema/syntax->node
                    [] |defn |run $ []
                    , |source 0
                file $ %{} app.schema/FileEntry (:source-view None) (:ns entry)
                  :defs $ {} $ |run entry
                wire $ parse-cirru-edn $ format-cirru-edn
                  twig-search $ {} $ |demo file
                recovered $ bookmark/read-bookmarks wire
              assert= 2 $ .len recovered
              assert= true $ includes? recovered $ bookmark/%bookmark :ns |demo ([])
              assert= true $ includes? recovered $ bookmark/%bookmark :def |demo |run ([])
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.search
          :require $ app.bookmark :as bookmark
    'app.twig.user $ %{} 'FileEntry
      :defs $ {}
        'lookup-session-user $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn lookup-session-user (users session)
            match
              app.schema/read-optional-text $ get session :user-id
              (:none) ({})
              (:some id)
                .unwrap-or (get users id) ({})
          :examples $ []
          :schema $ quote $ Fn
            Map String $ Map Tag V
            Map Tag K
            -> $ Map Tag V
            :generics K V
        'session-user $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn session-user (users session)
            twig-user $ lookup-session-user users session
          :examples $ []
          :schema $ quote $ Fn
            Map String $ Map Tag Dynamic
            Map Tag Dynamic
            -> $ Map Tag Dynamic
        'twig-user $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-user (user)
            -> user $ dissoc :password
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic)
            -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.user (:require)
    'app.twig.watching $ %{} 'FileEntry
      :defs $ {} $ 'twig-watching
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn twig-watching (session my-sid files users)
            let
                bookmark $ to-bookmark $ get session :writer
                self? $ = my-sid $ .unwrap-or (get session :id) |
                entry $ bookmark .and-then $ fn (value)
                  hint-fn $ Fn app.bookmark/%bookmark $ -> (Option app.schema/CodeEntry)
                  app.twig.page-editor/bookmark-entry files value
              {}
                :member $ app.twig.user/session-user users session
                :bookmark bookmark
                :router $ .unwrap-or (get session :router) (:: :files)
                :self? self?
                :working? $ and (.some? bookmark) (not self?)
                :focus $ .unwrap-or
                  .map bookmark $ fn (value)
                    hint-fn $ Fn app.bookmark/%bookmark $ -> (List String)
                    app.bookmark/get-focus value
                  []
                :expr entry
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String (Map String app.schema/FileEntry)
            Map String $ Map Tag Dynamic
            -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.twig.watching
          :require
            app.util :refer $ to-bookmark
            app.twig.user :refer $ twig-user
            app.bookmark :refer $ Bookmark
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (db op sid op-id op-time)
            match op
              (:session/connect) (session/connect db sid op-id op-time)
              (:session/disconnect) (session/disconnect db sid op-id op-time)
              (:session/select-ns op-data) (session/select-ns db op-data sid op-id op-time)
              (:user/nickname op-data)
                user/nickname db (decode-map-as op-data 'String) sid op-id op-time
              (:user/log-in op-data)
                user/log-in db
                  decode-map-as op-data $ List String
                  , sid op-id op-time
              (:user/sign-up op-data)
                user/sign-up db
                  decode-map-as op-data $ List String
                  , sid op-id op-time
              (:user/log-out op-data) (user/log-out db &unit sid op-id op-time)
              (:user/change-theme op-data)
                user/change-theme db (decode-map-as op-data 'Tag) sid op-id op-time
              (:router/change op-data)
                router/change db (router/read-route op-data) sid op-id op-time
              (:writer/edit op-data) (writer/edit db op-data sid op-id op-time)
              (:writer/edit-ns) (writer/edit-ns db sid op-id op-time)
              (:writer/select op-data) (writer/select db op-data sid op-id op-time)
              (:writer/point-to op-data) (writer/point-to db op-data sid op-id op-time)
              (:writer/focus op-data)
                writer/focus db
                  decode-map-as op-data $ List String
                  , sid op-id op-time
              (:writer/go-up) (writer/go-up db sid op-id op-time)
              (:writer/go-down op-data)
                writer/go-down db
                  decode-map-as op-data $ Map Tag Dynamic
                  , sid op-id op-time
              (:writer/go-left) (writer/go-left db sid op-id op-time)
              (:writer/go-right) (writer/go-right db sid op-id op-time)
              (:writer/remove-idx op-data)
                writer/remove-idx db (decode-map-as op-data Number) sid op-id op-time
              (:writer/paste op-data) (writer/paste db op-data sid op-id op-time)
              (:writer/save-files op-data)
                writer/save-files db
                  match op-data
                    (:some name)
                      Some $ decode-map-as name 'String
                    (:none) None
                    _ $ raise |Expected-optional-save-namespace
                  , sid op-id op-time
              (:writer/collapse op-data)
                writer/collapse db (decode-map-as op-data Number) sid op-id op-time
              (:writer/move-next) (writer/move-next db sid op-id op-time)
              (:writer/move-previous) (writer/move-previous db sid op-id op-time)
              (:writer/move-order op-data)
                writer/move-order db
                  decode-map-as op-data $ Map Tag Number
                  , sid op-id op-time
              (:writer/finish) (writer/finish db sid op-id op-time)
              (:writer/draft-ns op-data) (writer/draft-ns db op-data sid op-id op-time)
              (:writer/hide-peek op-data) (writer/hide-peek db op-data sid op-id op-time)
              (:writer/picker-mode) (writer/picker-mode db sid op-id op-time)
              (:writer/pick-node op-data) (writer/pick-node db op-data sid op-id op-time)
              (:writer/doc-set path docstring)
                writer/doc-set db (writer/read-edit-bookmark path) (decode-map-as docstring String) sid op-id op-time
              (:ir/add-ns op-data) (ir/add-ns db op-data sid op-id op-time)
              (:ir/add-def op-data) (ir/add-def db op-data sid op-id op-time)
              (:ir/remove-def op-data) (ir/remove-def db op-data sid op-id op-time)
              (:ir/remove-ns op-data) (ir/remove-ns db op-data sid op-id op-time)
              (:ir/prepend-leaf op-data) (ir/prepend-leaf db op-data sid op-id op-time)
              (:ir/append-leaf op-data) (ir/append-leaf db op-data sid op-id op-time)
              (:ir/delete-node op-data) (ir/delete-node db op-data sid op-id op-time)
              (:ir/leaf-after op-data) (ir/leaf-after db op-data sid op-id op-time)
              (:ir/leaf-before op-data) (ir/leaf-before db op-data sid op-id op-time)
              (:ir/swap-left) (ir/swap-left db sid op-id op-time)
              (:ir/expr-before op-data) (ir/expr-before db op-data sid op-id op-time)
              (:ir/expr-after op-data) (ir/expr-after db op-data sid op-id op-time)
              (:ir/expr-replace op-data) (ir/expr-replace db op-data sid op-id op-time)
              (:ir/indent) (ir/indent db sid op-id op-time)
              (:ir/unindent) (ir/unindent db sid op-id op-time)
              (:ir/unindent-leaf) (ir/unindent-leaf db sid op-id op-time)
              (:ir/update-leaf op-data) (ir/update-leaf db op-data sid op-id op-time)
              (:ir/duplicate op-data) (ir/duplicate db op-data sid op-id op-time)
              (:ir/rename op-data) (ir/rename db op-data sid op-id op-time)
              (:ir/cp-ns op-data) (ir/transfer-namespace db op-data false)
              (:ir/mv-ns op-data) (ir/transfer-namespace db op-data true)
              (:ir/delete-entry op-data) (ir/delete-entry db op-data sid op-id op-time)
              (:ir/reset-files) (ir/reset-files db sid op-id op-time)
              (:ir/reset-at op-data) (ir/reset-at db op-data sid op-id op-time)
              (:ir/reset-ns op-data) (ir/reset-ns db op-data sid op-id op-time)
              (:ir/draft-expr op-data) (ir/draft-expr db op-data sid op-id op-time)
              (:ir/replace-file op-data)
                ir/replace-file db (decode-map-as op-data 'String) sid op-id op-time
              (:ir/file-config op-data) (ir/file-config db op-data sid op-id op-time)
              (:ir/clone-ns op-data) (ir/clone-ns db op-data sid op-id op-time)
              (:ir/toggle-comment) (ir/toggle-comment db sid op-id op-time)
              (:ir/fold-to-end) (ir/fold-to-end db sid op-id op-time)
              (:notify/push-message op-data)
                let
                    items $ decode-map-as op-data $ List Dynamic
                    kind $ decode-map-as
                      .unwrap $ .get items 0
                      , Tag
                    text $ decode-map-as
                      .unwrap $ .get items 1
                      , String
                  notify/push-message db kind text sid op-id op-time
              (:notify/clear op-data) (notify/clear db op-data sid op-id op-time)
              (:notify/broadcast op-data) (notify/broadcast db op-data sid op-id op-time)
              (:analyze/goto-def op-data) (analyze/goto-def db op-data sid op-id op-time)
              (:analyze/abstract-def op-data) (analyze/abstract-def db op-data sid op-id op-time)
              (:analyze/peek-def op-data)
                analyze/peek-def db (decode-map-as op-data String) sid op-id op-time
              (:analyze/refresh-usages-dict) (analyze/refresh-usages-dict db sid op-id op-time)
              (:analyze/use-import-def target) (analyze/use-import-def db target sid op-id op-time)
              (:ping) db
              (:configs/update op-data)
                configs/update-configs db
                  decode-map-as op-data $ Map Tag Dynamic
                  , sid op-id op-time
              (:configs/update-entries op-data)
                configs/update-entries db (configs/read-entry-update op-data) sid op-id op-time
              _ $ do (eprintln "|Unknown op:" op) db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require (app.updater.session :as session) (app.updater.user :as user) (app.updater.router :as router) (app.updater.ir :as ir) (app.updater.writer :as writer) (app.updater.notify :as notify) (app.updater.analyze :as analyze) (app.updater.watcher :as watcher) (app.updater.configs :as configs)
    'app.updater.analyze $ %{} 'FileEntry
      :defs $ {}
        'DependencyGraph $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct DependencyGraph
            :dependencies $ Map app.schema/DependencyKey $ Set app.schema/DependencyKey
            :usages $ Map app.schema/DependencyKey $ Set app.schema/DependencyKey
          :examples $ []
          :schema $ quote StructDef
        'DependencyImport $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def DependencyImport
            defenum DependencyImport (:by-as String String)
              :by-refer String $ Set String
          :examples $ []
          :schema $ quote EnumDef
        'abstract-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn abstract-def (db op-data sid op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db sid)
                name $ decode-map-as op-data String
              match bookmark
                (:ns _namespace _focus)
                  raise "|Select a definition before abstracting an expression"
                (:def namespace _definition _focus)
                  let
                      file $ app.updater.writer/read-bookmark-file db bookmark
                      target $ app.bookmark/%bookmark :def namespace name $ []
                      exists? $ contains? (:defs file) name
                      next $ if exists?
                        decode-map-as
                          update-in db ([] :sessions sid :notifications)
                            push-warning op-id op-time $ str name "| already defined!"
                          Map Tag Dynamic
                        let
                            author $ decode-map-as
                              .unwrap-or
                                get-in db $ [] :sessions sid :user-id
                                , |
                              , String
                            selected $ app.updater.writer/read-bookmark-node db bookmark
                            code $ cirru->tree
                              [] |def name $ tree->cirru selected
                              , author op-time
                            entry $ %{} schema/CodeEntry (:doc |) (:code code)
                              :examples $ []
                              :source-entry None
                            with-definition $ app.updater.writer/write-bookmark-entry db target entry
                          app.updater.writer/write-bookmark-node with-definition bookmark $ cirru->tree name author op-time
                    decode-map-as
                      update-in next ([] :sessions sid :writer) (push-bookmark target false)
                      Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'dependency-key->wire $ %{} 'CodeEntry
          :doc "|Keep the legacy keys in dependency maps sent to the client."
          :code $ quote $ defn dependency-key->wire (key)
            match key
              (:def namespace name) (:: :def namespace name)
              (:reference namespace name) (:: :reference namespace name)
          :examples $ []
          :schema $ quote $ Fn schema/DependencyKey (-> AnyEnum) (:open :reflect)
        'goto-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn goto-def (db op-data sid op-id op-time)
            let
                data $ decode-map-as op-data $ Map Tag Dynamic
                text $ decode-map-as
                  .unwrap-or (get data :text) |
                  , String
                reference $ parse-def text
                pkg $ decode-map-as
                  .unwrap-or (get db :package) |
                  , String
                warn $ fn (message)
                  hint-fn $ Fn String $ -> (Map Tag Dynamic)
                  decode-map-as
                    update-in db ([] :sessions sid :notifications) (push-warning op-id op-time message)
                    Map Tag Dynamic
              match (resolve-definition db sid reference)
                (:none)
                  warn $ str "|Cannot locate: " text
                (:some bookmark)
                  match bookmark
                    (:ns _namespace _focus)
                      warn $ str "|handling ns: " bookmark
                    (:def namespace name _focus)
                      if
                        or (= pkg namespace)
                          starts-with? namespace $ str pkg |.
                        let
                            files $ decode-map-as
                              .unwrap $ get db :files
                              Map String app.schema/FileEntry
                            target-file $ get files namespace
                            exists? $ match target-file
                              (:some file)
                                contains? (:defs file) name
                              (:none) false
                          if exists?
                            decode-map-as
                              update-in db ([] :sessions sid :writer) (push-bookmark bookmark true)
                              Map Tag Dynamic
                            if
                              = true $ .unwrap-or (get data :forced?) false
                              let
                                  args $ .unwrap-or (get data :args) ([])
                                  form $ if (list? args) ([] |defn name args)
                                    [] |def name $ []
                                  author $ decode-map-as
                                    .unwrap-or
                                      get-in db $ [] :sessions sid :user-id
                                      , |
                                    , String
                                  entry $ %{} schema/CodeEntry (:doc |)
                                    :code $ cirru->tree form author op-time
                                    :examples $ []
                                    :source-entry None
                                  file $ match target-file
                                    (:some file)
                                      assoc file :defs $ assoc (:defs file) name entry
                                    (:none)
                                      %{} schema/FileEntry
                                        :ns $ %{} schema/CodeEntry (:doc |)
                                          :code $ cirru->tree ([] |ns namespace) author op-time
                                          :examples $ []
                                          :source-entry None
                                        :defs $ {} $ name entry
                                        :source-view None
                                  next-db $ assoc db :files $ assoc files namespace file
                                decode-map-as
                                  update-in next-db ([] :sessions sid :writer) (push-bookmark bookmark false)
                                  Map Tag Dynamic
                              warn $ str "|Does not exist: " bookmark
                        warn $ str "|From external ns: " bookmark
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'parse-all-deps $ %{} 'CodeEntry
          :doc "|main implementation of reading files and build a usages dictionary. Slow at current, need optimizations with mutable data.\n"
          :code $ quote $ defn parse-all-deps (files)
            let
                *usages $ ref $ assert-type ({})
                  Map schema/DependencyKey $ Set schema/DependencyKey
                *deps $ ref $ assert-type ({})
                  Map schema/DependencyKey $ Set schema/DependencyKey
              each (&map:to-list files)
                fn (pair)
                  hint-fn $ Fn (Tuple String schema/FileEntry) (-> Unit)
                  let[] (namespace file) pair $ let
                      defs $ :defs file
                      local-defs $ keys defs
                      ns-expr $ tree->cirru $ schema/read-node
                        :code $ :ns file
                      import-rules $ parse-ns-rules ns-expr
                    each (&map:to-list defs)
                      fn (pair)
                        hint-fn $ Fn (Tuple String schema/CodeEntry) (-> Unit)
                        let[] (definition entry) pair $ let
                            key $ schema/DependencyKey :def namespace definition
                            *entry-deps $ ref $ assert-type (#{}) (Set schema/DependencyKey)
                            collect! $ fn (reference)
                              hint-fn $ Fn schema/DependencyKey $ -> Unit
                              let
                                  entries $ .unwrap-or (get @*usages reference) (#{})
                                swap! *usages assoc reference $ include entries key
                              swap! *entry-deps include reference
                              , &unit
                          parse-bookmarks-collect!
                            tree->cirru $ schema/read-node $ :code entry
                            , local-defs import-rules namespace definition collect!
                          swap! *deps assoc key @*entry-deps
                          , &unit
              DependencyGraph :dependencies @*deps :usages @*usages
          :examples $ []
          :schema $ quote $ Fn (Map String schema/FileEntry) (-> DependencyGraph)
        'parse-bookmarks-collect! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-bookmarks-collect! (tree local-defs import-rules this-ns this-def collect!)
            match tree
              (List children)
                each children $ fn (child)
                  hint-fn $ Fn schema/CirruSyntax $ -> Unit
                  parse-bookmarks-collect! child local-defs import-rules this-ns this-def collect!
              (String leaf)
                let
                    sym $ if (starts-with? leaf |@)
                      &str:slice leaf 1 $ .len leaf
                      , leaf
                  if (contains? local-defs sym)
                    when (not= this-def sym)
                      collect! $ schema/DependencyKey :reference this-ns sym
                    each import-rules $ fn (rule)
                      hint-fn $ Fn DependencyImport $ -> Unit
                      match rule
                        (:by-as namespace alias)
                          let
                              prefix $ str alias |/
                            when (starts-with? sym prefix)
                              collect! $ schema/DependencyKey :reference namespace $ &str:slice sym (.len prefix) (.len sym)
                        (:by-refer namespace definitions)
                          when (contains? definitions sym)
                            collect! $ schema/DependencyKey :reference namespace sym
                      , &unit
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/CirruSyntax (Set String) (List DependencyImport) String String
            Fn schema/DependencyKey $ -> Unit
            -> Unit
        'parse-ns-rules $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-ns-rules (form)
            match form
              (String _leaf) ([])
              (List members)
                match (nth members 2)
                  (:none) ([])
                  (:some section)
                    match section
                      (String _leaf) ([])
                      (List rules)
                        mapcat (rest rules)
                          fn (rule)
                            hint-fn $ Fn schema/CirruSyntax $ -> (List DependencyImport)
                            match rule
                              (String _leaf) ([])
                              (List pieces)
                                match (nth pieces 1)
                                  (:none) ([])
                                  (:some value)
                                    match value
                                      (List _nested) ([])
                                      (String method)
                                        match method
                                          |:as $ [] $ DependencyImport :by-as
                                            decode-map-as
                                              .unwrap $ nth pieces 0
                                              , String
                                            decode-map-as
                                              .unwrap $ nth pieces 2
                                              , String
                                          |:refer $ [] $ DependencyImport :by-refer
                                            decode-map-as
                                              .unwrap $ nth pieces 0
                                              , String
                                            &list:to-set $ decode-map-as
                                              .unwrap $ nth pieces 2
                                              List String
                                          _ $ []
          :examples $ []
          :schema $ quote $ Fn schema/CirruSyntax
            -> $ List DependencyImport
        'peek-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn peek-def (db text sid op-id op-time)
            let
                reference $ parse-def text
                pkg $ decode-map-as
                  .unwrap-or (get db :package) |
                  , String
                warn $ fn (message)
                  hint-fn $ Fn String $ -> (Map Tag Dynamic)
                  decode-map-as
                    update-in db ([] :sessions sid :notifications) (push-warning op-id op-time message)
                    Map Tag Dynamic
              match (resolve-definition db sid reference)
                (:none)
                  warn $ str "|Cannot locate: " text
                (:some bookmark)
                  match bookmark
                    (:ns _namespace _focus)
                      warn $ str "|Unexpected bookmark: " bookmark
                    (:def namespace name _focus)
                      if
                        starts-with? namespace $ str pkg |.
                        let
                            files $ decode-map-as
                              .unwrap $ get db :files
                              Map String app.schema/FileEntry
                            exists? $ match (get files namespace)
                              (:some file)
                                contains? (:defs file) name
                              (:none) false
                          if exists?
                            decode-map-as
                              assoc-in db ([] :sessions sid :writer :peek-def)
                                {} (:ns namespace) (:def name)
                              Map Tag Dynamic
                            warn $ str "|Does not exist: " namespace "| " name
                        warn $ str "|External dep: " namespace
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String String Number
            -> $ Map Tag Dynamic
            :features :io
        'refresh-usages-dict $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn refresh-usages-dict (db sid op-id op-time)
            let
                graph $ parse-all-deps $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
              -> db
                assoc :usages-dict $ wire-dependency-map $ :usages graph
                assoc :deps-dict $ wire-dependency-map $ :dependencies graph
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |typed-graph-preserves-anonymous-wire-keys)
            :code $ quote $ let
                make-entry $ fn (form)
                  hint-fn $ Fn schema/CirruSyntax $ -> schema/CodeEntry
                  %{} schema/CodeEntry (:doc |)
                    :code $ cirru->tree form |fixture 1
                    :examples $ []
                    :source-entry None
                file $ %{} schema/FileEntry
                  :ns $ make-entry $ [] |ns |demo.main
                  :defs $ {}
                    |first $ make-entry $ [] |def |first |1
                    |second $ make-entry $ [] |def |second |first
                  :source-view None
                db $ refresh-usages-dict
                  {} $ :files $ {} (|demo.main file)
                  , |fixture |edit 1
                first-ref $ :: :reference |demo.main |first
                first-def $ :: :def |demo.main |first
                second-def $ :: :def |demo.main |second
              assert=
                {}
                  first-def $ #{}
                  second-def $ #{} first-ref
                .unwrap $ get db :deps-dict
              assert=
                {} $ first-ref $ #{} second-def
                .unwrap $ get db :usages-dict
              assert=
                Some $ #{} $ schema/DependencyKey :reference |demo.main |first
                get
                  schema/read-dependency-map $ parse-cirru-edn $ format-cirru-edn
                    .unwrap $ get db :deps-dict
                  schema/DependencyKey :def |demo.main |second
              assert=
                #{} $ schema/DependencyKey :def |demo.main |second
                schema/read-dependency-set $ .unwrap $ get
                  .unwrap $ get db :usages-dict
                  , first-ref
            :tags $ #{} :unit
        'resolve-definition $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn resolve-definition (db sid reference)
            match
              to-bookmark $ to-writer db sid
              (:none) None
              (:some bookmark)
                let
                    namespace $ app.bookmark/get-namespace bookmark
                    source $ app.updater.writer/read-bookmark-node db $ app.bookmark/%bookmark :ns namespace ([])
                    imports $ parse-deps $ tree->cirru source
                    key $ match reference
                      (:qualified alias _name) alias
                      (:unqualified name) name
                    method $ match reference
                      (:qualified _alias _name) :as
                      (:unqualified _name) :refer
                    name $ match reference
                      (:qualified _alias name) name
                      (:unqualified name) name
                  match (get imports key)
                    (:none)
                      Some $ app.bookmark/%bookmark :def namespace name $ []
                    (:some rule)
                      match rule
                        (:as target)
                          if (= method :as)
                            Some $ app.bookmark/%bookmark :def target name $ []
                            , None
                        (:refer target)
                          if (= method :refer)
                            Some $ app.bookmark/%bookmark :def target name $ []
                            , None
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String app.util/SymbolReference
            -> $ Option app.bookmark/%bookmark
            :features :io
        'use-import-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn use-import-def (db picked sid op-id op-time)
            match
              to-bookmark $ to-writer db sid
              (:none)
                do (eprintln "|no bookmark yet") db
              (:some bookmark)
                match bookmark
                  (:ns _namespace _focus)
                    do (eprintln "|def import not working in ns rules") db
                  (:def current-ns _definition _focus)
                    let
                        author $ decode-map-as
                          app.util/get-required-path db $ [] :sessions sid :user-id
                          , String
                        target $ app.bookmark/read-bookmark picked
                        ns-bookmark $ app.bookmark/%bookmark :ns current-ns $ []
                        ns-tree $ schema/read-expr $ app.updater.writer/read-bookmark-node db ns-bookmark
                        to-tree $ fn (syntax)
                          hint-fn $ Fn schema/CirruSyntax $ -> schema/CirruNode
                          cirru->tree syntax author op-time
                        insert $ fn (state text)
                          hint-fn $ Fn (Map Tag Dynamic) String $ -> (Map Tag Dynamic)
                          let
                              next $ app.updater.writer/write-bookmark-node state bookmark $ to-tree text
                            decode-map-as
                              assoc-in next ([] :sessions sid :router) (:: :editor)
                              Map Tag Dynamic
                      match target
                        (:def pick-ns pick-def _focus)
                          if (= current-ns pick-ns) (insert db pick-def)
                            match
                              schema/find-node-path ns-tree (to-tree pick-ns) ([]) (Some |:refer)
                              (:none)
                                do (eprintln "|Failed to find ns node for refer") db
                              (:some coordinate)
                                let
                                    path $ butlast coordinate
                                    rule $ schema/read-expr $ .unwrap (schema/node-at-path ns-tree path)
                                    def-node $ to-tree pick-def
                                  match
                                    schema/find-node-path rule def-node ([]) None
                                    (:some _existing) (insert db pick-def)
                                    (:none)
                                      let
                                          next-rule $ schema/dispatch-node-commands rule $ [] (schema/NodeCommand :update-last) (schema/NodeCommand :append def-node)
                                          next-tree $ schema/assoc-node-path ns-tree path next-rule
                                          next $ app.updater.writer/write-bookmark-node db ns-bookmark next-tree
                                        insert next pick-def
                        (:ns pick-ns _focus)
                          if (= current-ns pick-ns)
                            do (println "|already in namespace" current-ns) db
                            match
                              schema/find-node-path ns-tree (to-tree pick-ns) ([]) (Some |:as)
                              (:some coordinate)
                                let
                                    rule $ schema/read-expr $ .unwrap
                                      schema/node-at-path ns-tree $ butlast coordinate
                                    alias $ decode-map-as
                                      .unwrap $ last $ schema/expr->syntax rule
                                      , String
                                  insert db $ str alias |/
                              (:none)
                                let
                                    alias $ .unwrap-or
                                      last $ split pick-ns |.
                                      , pick-ns
                                    rule $ to-tree $ [] pick-ns |:as alias
                                    next-tree $ match
                                      schema/find-node-path ns-tree (to-tree |:require) ([]) None
                                      (:some coordinate)
                                        let
                                            path $ butlast coordinate
                                            section $ schema/read-expr $ .unwrap (schema/node-at-path ns-tree path)
                                          schema/assoc-node-path ns-tree path $ schema/dispatch-node-commands section $ [] (schema/NodeCommand :append rule)
                                      (:none)
                                        schema/dispatch-node-commands ns-tree $ [] $ schema/NodeCommand :append
                                          to-tree $ [] |:require $ [] pick-ns |:as alias
                                    next $ app.updater.writer/write-bookmark-node db ns-bookmark next-tree
                                  insert next $ str alias |/
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'wire-dependency-map $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn wire-dependency-map (relations)
            filter-map-kv relations $ fn (key linked)
              MapEntryDecision :keep (dependency-key->wire key) (.map linked dependency-key->wire)
          :examples $ []
          :schema $ quote $ Fn
            Map schema/DependencyKey $ Set schema/DependencyKey
            -> $ Map AnyEnum $ Set AnyEnum
            :open :reflect
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.analyze
          :require
            app.util :refer $ bookmark->path to-writer to-bookmark parse-deps tree->cirru cirru->tree parse-def push-warning
            app.util.stack :refer $ push-bookmark
            app.schema :as schema
    'app.updater.configs $ %{} 'FileEntry
      :defs $ {}
        'EntryUpdate $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum EntryUpdate
            :reset $ Map String $ Map Tag Dynamic
            :merge $ Map String $ Map Tag Dynamic
            :dissoc String
          :examples $ []
          :schema $ quote EnumDef
        'read-entry-update $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-entry-update (raw)
            let
                items $ decode-map-as raw $ List Dynamic
              when
                not= 2 $ .len items
                raise |Expected-two-entry-update-fields
              let[] (raw-operation payload) items $ let
                  operation $ decode-map-as raw-operation 'Tag
                match operation
                  :reset $ EntryUpdate :reset $ decode-map-as payload
                    Map String $ Map Tag Dynamic
                  :merge $ EntryUpdate :merge $ decode-map-as payload
                    Map String $ Map Tag Dynamic
                  :dissoc $ EntryUpdate :dissoc $ decode-map-as payload 'String
                  _ $ raise |Unknown-entry-update-operation
          :examples $ []
          :schema $ quote $ Fn Input (-> EntryUpdate) (:generics Input)
        'update-configs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-configs (db settings session-id op-id op-time)
            if (contains? settings :version)
              raise "|Project version is managed by deps.cirru; use caps version set and reload."
              assoc db :configs $ merge
                decode-map-as
                  .unwrap-or (get db :configs) ({})
                  Map Tag Dynamic
                , settings
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'update-entries $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-entries (db operation session-id op-id op-time)
            let
                entries $ decode-map-as
                  .unwrap-or (get db :entries) ({})
                  Map String $ Map Tag Dynamic
                next $ match operation
                  (:reset value) value
                  (:merge value) (merge entries value)
                  (:dissoc name) (dissoc entries name)
              assoc db :entries next
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) EntryUpdate String String Number
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry
            :name |entry-update-wire-and-manifest-version-ownership
            :code $ quote $ let
                db $ {}
                  :entries $ {}
                  :configs $ {} $ :version |1.0.0
                entry $ {} (:mode :native) (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
                  :modules $ []
                reset $ update-entries db
                  read-entry-update $ [] :reset $ {} (|test entry)
                  , |session |op 1
                merged $ update-entries reset
                  read-entry-update $ [] :merge $ {} (|other entry)
                  , |session |op2 2
                removed $ update-entries merged
                  read-entry-update $ [] :dissoc |test
                  , |session |op3 3
                rejected? $ try
                  do
                    update-configs db
                      {} $ :version |2.0.0
                      , |session |op4 4
                    , false
                  fn (_error) true
              assert=
                Some $ {} $ |test entry
                get reset :entries
              assert=
                Some $ {} $ |other entry
                get removed :entries
              assert= true rejected?
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.configs
    'app.updater.ir $ %{} 'FileEntry
      :defs $ {}
        'NamespaceTransfer $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct NamespaceTransfer (:from String) (:to String)
          :examples $ []
          :schema $ quote StructDef
        'SiblingEdit $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def SiblingEdit
            defenum SiblingEdit (:leaf-before) (:leaf-after) (:expr-before) (:expr-after)
          :examples $ []
          :schema $ quote EnumDef
        'add-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn add-def (db op-data session-id op-id op-time)
            let
                items $ decode-map-as op-data $ List String
                namespace $ .unwrap $ .get items 0
                definition $ .unwrap $ .get items 1
                author $ decode-map-as
                  .unwrap-or
                    get-in db $ [] :sessions session-id :user-id
                    , |
                  , String
                entry $ %{} schema/CodeEntry (:doc |)
                  :code $ cirru->tree
                    [] |defn definition $ []
                    , author op-time
                  :examples $ []
                  :source-entry None
              app.updater.writer/write-bookmark-entry db
                app.bookmark/%bookmark :def namespace definition $ []
                , entry
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'add-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn add-ns (db op-data session-id op-id op-time)
            let
                namespace $ decode-map-as op-data String
                author $ decode-map-as
                  .unwrap-or
                    get-in db $ [] :sessions session-id :user-id
                    , |
                  , String
                entry $ %{} schema/CodeEntry (:doc |)
                  :code $ cirru->tree ([] |ns namespace) author op-time
                  :examples $ []
                  :source-entry None
                file $ %{} schema/FileEntry (:ns entry)
                  :defs $ {}
                  :source-view None
              decode-map-as
                -> db
                  assoc-in ([] :files namespace) file
                  assoc-in ([] :sessions session-id :writer :selected-ns) namespace
                Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'append-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn append-leaf (db op-data session-id op-id op-time) (insert-empty-leaf db session-id op-id op-time true)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'call-replace-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn call-replace-expr (node from to)
            match node
              (app.schema/CirruLeafShape leaf)
                cond
                    = (:text leaf) from
                    assoc leaf :text to
                  (= (:text leaf) (str |@ from))
                    assoc leaf :text $ str |@ to
                  true leaf
              (app.schema/CirruExprShape expr)
                assoc expr :data $ filter-map-kv (:data expr)
                  fn (key child)
                    hint-fn $ Fn String schema/CirruNode $ -> (MapEntryDecision String schema/CirruNode)
                    match (call-replace-expr child from to)
                      (app.schema/CirruLeafShape leaf)
                        if
                          blank? $ :text leaf
                          MapEntryDecision :drop
                          MapEntryDecision :keep key leaf
                      (app.schema/CirruExprShape nested) (MapEntryDecision :keep key nested)
          :examples $ []
          :schema $ quote $ Fn schema/CirruNode String String (-> schema/CirruNode)
        'clone-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn clone-ns (db op-data sid op-id op-time)
            let
                writer $ .unwrap $ to-writer db sid
                selected-ns $ .unwrap-or
                  app.schema/read-optional-text $ get writer :selected-ns
                  , |
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                warn $ fn (text)
                  hint-fn $ Fn String $ -> (Map Tag Dynamic)
                  decode-map-as
                    update-in db ([] :sessions sid :notifications) (push-warning op-id op-time text)
                    Map Tag Dynamic
              if (string? op-data)
                let
                    new-ns $ decode-map-as op-data String
                  cond
                      not $ .includes? new-ns |.
                      warn "|Not a valid string!"
                    (.contains-key? files new-ns)
                      warn $ str new-ns "| already existed!"
                    (not (.contains-key? files selected-ns))
                      warn "|No selected namespace!"
                    true $ let
                        file $ .unwrap $ get files selected-ns
                        ns-entry $ :ns file
                        expr $ schema/read-expr $ :code ns-entry
                        children $ :data expr
                        key $ .unwrap $ key-nth children 1
                        next-expr $ match
                          .unwrap $ get children key
                          (app.schema/CirruLeafShape leaf)
                            do
                              assert "|Old namespace does not match selected namespace" $ = selected-ns $ :text leaf
                              assoc expr :data $ assoc children key $ assoc leaf :text new-ns
                          (app.schema/CirruExprShape _child) (raise "|Expected namespace name leaf")
                        next-file $ assoc file :ns $ assoc ns-entry :code next-expr
                      decode-map-as
                        assoc-in
                          assoc db :files $ assoc files new-ns next-file
                          [] :sessions sid :writer :selected-ns
                          , new-ns
                        Map Tag Dynamic
                warn "|Not a valid string!"
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'delete-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn delete-entry (db op-data session-id op-id op-time)
            let
                bookmark $ app.bookmark/read-bookmark op-data
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                next-files $ match bookmark
                  (:ns namespace _focus) (dissoc files namespace)
                  (:def namespace definition _focus)
                    let
                        file $ .unwrap $ get files namespace
                      assoc files namespace $ assoc file :defs $ dissoc (:defs file) definition
                writer $ .unwrap-or (to-writer db session-id) ({})
                pointer $ decode-map-as
                  .unwrap-or (get writer :pointer) 0
                  , Number
                stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer :stack) ([])
                next-writer $ assoc
                  assoc writer :stack $ dissoc-idx stack pointer
                  , :pointer $ dec pointer
              decode-map-as
                assoc-in (assoc db :files next-files) ([] :sessions session-id :writer) next-writer
                Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'delete-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn delete-node (db _op-data session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
              match (app.bookmark/get-parent bookmark)
                (:none)
                  decode-map-as
                    update-in db ([] :sessions session-id :notifications) (push-warning op-id op-time "|cannot delete from root")
                    Map Tag Dynamic
                (:some parent)
                  let
                      expr $ app.updater.writer/read-bookmark-expr db parent
                      children $ :data expr
                      current $ .unwrap $ last (app.bookmark/get-focus bookmark)
                      child-keys $ sort
                        .to-list $ keys children
                        , &compare
                      idx $ .unwrap $ index-of child-keys current
                      parent-focus $ app.bookmark/get-focus parent
                      next-focus $ if (= 0 idx) parent-focus $ conj parent-focus
                        .unwrap $ get child-keys $ dec idx
                      next $ app.updater.writer/write-bookmark-node db parent $ assoc expr :data (dissoc children current)
                    app.updater.writer/focus next next-focus session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'draft-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn draft-expr (db op-data session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                author $ decode-map-as
                  app.util/get-required-path db $ [] :sessions session-id :user-id
                  , String
              app.updater.writer/write-bookmark-node db bookmark $ cirru->tree op-data author op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'duplicate $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn duplicate (db _op-data session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                parent $ .unwrap $ app.bookmark/get-parent bookmark
                current $ .unwrap $ last (app.bookmark/get-focus bookmark)
                expr $ app.updater.writer/read-bookmark-expr db parent
                children $ :data expr
                child $ .unwrap $ get children current
                key $ key-after children current
                next $ app.updater.writer/write-bookmark-node db parent $ assoc expr :data (assoc children key child)
              app.updater.writer/focus next
                conj (app.bookmark/get-focus parent) key
                , session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'expr-after $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expr-after (db _op-data session-id op-id op-time)
            insert-sibling db session-id op-id op-time $ SiblingEdit :expr-after
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'expr-before $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expr-before (db _op-data session-id op-id op-time)
            insert-sibling db session-id op-id op-time $ SiblingEdit :expr-before
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'expr-replace $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expr-replace (db op-data session-id op-id op-time)
            let
                fields $ decode-map-as op-data $ Map Tag Dynamic
                from $ decode-map-as
                  .unwrap $ get fields :from
                  , String
                to $ decode-map-as
                  .unwrap $ get fields :to
                  , String
                bookmark $ app.bookmark/read-bookmark $ .unwrap (get fields :bookmark)
                node $ app.updater.writer/read-bookmark-node db bookmark
              app.updater.writer/write-bookmark-node db bookmark $ call-replace-expr node from to
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'file-config $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn file-config (db op-data sid op-id op-time)
            match
              get-in db $ [] :sessions sid :writer :selected-ns
              (:ok value)
                if (nil? value) db $ let
                    namespace $ decode-map-as value String
                  decode-map-as
                    app.util/update-in-existing db ([] :files namespace :configs)
                      fn (configs)
                        merge
                          decode-map-as configs $ Map Tag Dynamic
                          decode-map-as op-data $ Map Tag Dynamic
                    Map Tag Dynamic
              (:err error)
                match error
                  (:missing) db
                  (:shape message) (raise message)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'fold-to-end $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn fold-to-end (db session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                author $ decode-map-as
                  app.util/get-required-path db $ [] :sessions session-id :user-id
                  , String
              match (app.bookmark/get-parent bookmark)
                (:none)
                  do (eprintln "|does not work on root element") db
                (:some parent)
                  let
                      end-key $ .unwrap $ last (app.bookmark/get-focus bookmark)
                      expr $ app.updater.writer/read-bookmark-expr db parent
                      children $ :data expr
                      prior $ filter-map-kv children $ fn (k v)
                        hint-fn $ Fn String schema/CirruNode $ -> (MapEntryDecision String schema/CirruNode)
                        if
                          < (&str:compare k end-key) 0
                          MapEntryDecision :keep k v
                          MapEntryDecision :drop
                      boxed $ filter-map-kv children $ fn (k v)
                        hint-fn $ Fn String schema/CirruNode $ -> (MapEntryDecision String schema/CirruNode)
                        if
                          >= (&str:compare k end-key) 0
                          MapEntryDecision :keep k v
                          MapEntryDecision :drop
                      child $ %{} schema/CirruExpr (:at op-time) (:by author) (:data boxed)
                    app.updater.writer/write-bookmark-node db parent $ assoc expr :data $ assoc prior end-key child
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
            :features :io
        'indent $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn indent (db session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                child $ app.updater.writer/read-bookmark-node db bookmark
                author $ decode-map-as
                  app.util/get-required-path db $ [] :sessions session-id :user-id
                  , String
                expr $ %{} schema/CirruExpr (:at op-time) (:by author)
                  :data $ {} $ bisection/mid-id child
                next $ app.updater.writer/write-bookmark-node db bookmark expr
              app.updater.writer/focus next
                conj (app.bookmark/get-focus bookmark) bisection/mid-id
                , session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'insert-empty-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn insert-empty-leaf (db session-id op-id op-time at-end?)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                expr $ app.updater.writer/read-bookmark-expr db bookmark
                children $ :data expr
                key $ if at-end? (key-append children) (key-prepend children)
                author $ decode-map-as
                  app.util/get-required-path db $ [] :sessions session-id :user-id
                  , String
                leaf $ %{} schema/CirruLeaf (:by author) (:at op-time) (:text |)
                updated $ app.updater.writer/write-bookmark-node db bookmark $ assoc expr :data (assoc children key leaf)
              app.updater.writer/focus updated
                conj (app.bookmark/get-focus bookmark) key
                , session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number Bool
            -> $ Map Tag Dynamic
        'insert-sibling $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn insert-sibling (db session-id op-id op-time edit)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                focus $ app.bookmark/get-focus bookmark
                parent $ .unwrap-or (app.bookmark/get-parent bookmark) bookmark
                expr $ app.updater.writer/read-bookmark-expr db parent
                children $ :data expr
                key $ if (empty? focus)
                  match edit
                    (:leaf-after) (key-append children)
                    _ $ raise "|Select a sibling before inserting"
                  let
                      current $ .unwrap $ last focus
                    match edit
                      (:leaf-before) (key-before children current)
                      (:expr-before) (key-before children current)
                      (:leaf-after) (key-after children current)
                      (:expr-after) (key-after children current)
                author $ decode-map-as
                  app.util/get-required-path db $ [] :sessions session-id :user-id
                  , String
                leaf $ %{} schema/CirruLeaf (:at op-time) (:by author) (:text |)
                expression? $ match edit
                  (:expr-before) true
                  (:expr-after) true
                  _ false
                child $ decode-map-as
                  if expression?
                    %{} schema/CirruExpr (:at op-time) (:by author)
                      :data $ {} $ bisection/mid-id leaf
                    , leaf
                  , app.schema/CirruNode
                changed $ app.updater.writer/write-bookmark-node db parent $ assoc expr :data (assoc children key child)
                next-focus $ conj (app.bookmark/get-focus parent) key
              app.updater.writer/focus changed
                if expression? (conj next-focus bisection/mid-id) next-focus
                , session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number SiblingEdit
            -> $ Map Tag Dynamic
        'leaf-after $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn leaf-after (db _op-data session-id op-id op-time)
            insert-sibling db session-id op-id op-time $ SiblingEdit :leaf-after
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'leaf-before $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn leaf-before (db _op-data session-id op-id op-time)
            insert-sibling db session-id op-id op-time $ SiblingEdit :leaf-before
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'prepend-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn prepend-leaf (db op-data session-id op-id op-time) (insert-empty-leaf db session-id op-id op-time false)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'remove-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn remove-def (db op-data session-id op-id op-time)
            let
                selected-ns $ get-in db $ [] :sessions session-id :writer :selected-ns
              update-in db ([] :files selected-ns :defs)
                fn (defs)
                  dissoc (.unwrap-or defs {}) op-data
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'remove-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn remove-ns (db op-data session-id _op-id _op-time)
            let
                namespace $ decode-map-as op-data String
                selected-path $ [] :sessions session-id :writer :selected-ns
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                next-db $ assoc db :files $ dissoc files namespace
              if
                = (get-in db selected-path) (Result :ok namespace)
                decode-map-as (assoc-in next-db selected-path nil) (Map Tag Dynamic)
                , next-db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'rename $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn rename (db op-data session-id op-id op-time)
            let
                data $ decode-map-as op-data $ Map Tag Dynamic
                kind $ decode-map-as
                  .unwrap-or (get data :kind) :unknown
                  , Tag
              if
                and (not= kind :ns) (not= kind :def)
                do (println "|Unexpected kind:" kind) db
                let
                    namespace-fields $ decode-map-as
                      .unwrap $ get data :ns
                      Map Tag String
                    old-ns $ .unwrap $ get namespace-fields :from
                    new-ns $ .unwrap $ get namespace-fields :to
                    files $ decode-map-as
                      .unwrap $ get db :files
                      Map String app.schema/FileEntry
                    file $ .unwrap $ get files old-ns
                  if (= kind :ns)
                    let
                        entry $ :ns file
                        expr $ schema/read-expr $ :code entry
                        children $ :data expr
                        key $ .unwrap $ key-nth children 1
                        child $ match
                          .unwrap $ get children key
                          (app.schema/CirruLeafShape leaf) (assoc leaf :text new-ns)
                          (app.schema/CirruExprShape _expr) (raise "|Expected namespace name leaf")
                        next-entry $ assoc entry :code $ assoc expr :data (assoc children key child)
                        next-files $ assoc (dissoc files old-ns) new-ns $ assoc file :ns next-entry
                      retarget-active-bookmark (assoc db :files next-files) session-id old-ns None new-ns |
                    if
                      not $ contains? files new-ns
                      decode-map-as
                        update-in db ([] :sessions session-id :notifications)
                          push-warning op-id op-time $ str "|no namespace: " new-ns
                        Map Tag Dynamic
                      let
                          fields $ decode-map-as
                            .unwrap $ get data :extra
                            Map Tag String
                          old-name $ .unwrap $ get fields :from
                          new-name $ .unwrap $ get fields :to
                          defs $ :defs file
                          entry $ .unwrap $ get defs old-name
                          expr $ schema/read-expr $ :code entry
                          children $ :data expr
                          annotated? $ match
                            .unwrap $ val-nth children 1
                            (app.schema/CirruLeafShape leaf)
                              starts-with? (:text leaf) |^
                            (app.schema/CirruExprShape _expr) false
                          key $ .unwrap $ key-nth children (if annotated? 2 1)
                          author $ decode-map-as
                            .unwrap-or
                              get-in db $ [] :sessions session-id :user-id
                              , |
                            , String
                          next-entry $ assoc entry :code $ assoc expr :data
                            assoc children key $ cirru->tree new-name author op-time
                          without-old $ assoc files old-ns $ assoc file :defs (dissoc defs old-name)
                          destination $ .unwrap $ get without-old new-ns
                          next-files $ assoc without-old new-ns $ assoc destination :defs
                            assoc (:defs destination) new-name next-entry
                        retarget-active-bookmark (assoc db :files next-files) session-id old-ns (Some old-name) new-ns new-name
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'replace-file $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn replace-file (db view sid op-id op-time)
            let
                author $ match
                  get-in db $ [] :sessions sid :user-id
                  (:ok value) (decode-map-as value 'String)
                  (:err _error) (raise |Missing-session-author)
              match
                get-in db $ [] :sessions sid :writer :draft-ns
                (:ok raw-namespace)
                  if (nil? raw-namespace) db $ let
                      namespace $ decode-map-as raw-namespace 'String
                      imported $ app.source/import-cli-file view author op-time
                    assoc-in db ([] :files namespace) (:file imported)
                (:err _error) db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String String Number
            -> $ Map Tag Dynamic
            :features :io
        'reset-at $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reset-at (db op-data session-id op-id op-time)
            let
                target $ app.updater.writer/read-edit-bookmark op-data
                namespace $ app.bookmark/get-namespace target
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                saved $ decode-map-as
                  .unwrap-or (get db :saved-files) ({})
                  Map String app.schema/FileEntry
                current-file $ get files namespace
                saved-file $ get saved namespace
              match target
                (:ns _namespace _focus)
                  match saved-file
                    (:none)
                      assoc db :files $ dissoc files namespace
                    (:some previous)
                      let
                          file $ .unwrap-or current-file $ assoc previous :defs ({})
                        assoc db :files $ assoc files namespace $ assoc file :ns (:ns previous)
                (:def _namespace definition _focus)
                  let
                      saved-def $ match saved-file
                        (:some previous)
                          get (:defs previous) definition
                        (:none) None
                    match saved-def
                      (:some entry)
                        let
                            file $ .unwrap-or current-file $ assoc (.unwrap saved-file) :defs ({})
                          assoc db :files $ assoc files namespace $ assoc file :defs
                            assoc (:defs file) definition entry
                      (:none)
                        match current-file
                          (:none) db
                          (:some file)
                            assoc db :files $ assoc files namespace $ assoc file :defs
                              dissoc (:defs file) definition
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'reset-files $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reset-files (db session-id op-id op-time)
            assoc db :files $ .unwrap-or (get db :saved-files) {}
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'reset-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reset-ns (db op-data session-id op-id op-time)
            let
                namespace $ decode-map-as op-data String
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                saved $ decode-map-as
                  .unwrap-or (get db :saved-files) ({})
                  Map String app.schema/FileEntry
              assoc db :files $ match (get saved namespace)
                (:some file) (assoc files namespace file)
                (:none) (dissoc files namespace)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'retarget-active-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn retarget-active-bookmark (db sid old-ns old-def new-ns new-def)
            let
                writer $ to-writer db sid
                target $ match (to-bookmark writer)
                  (:none) None
                  (:some bookmark)
                    match bookmark
                      (:ns namespace focus)
                        if
                          and (= namespace old-ns) (.none? old-def)
                          Some $ %bookmark :ns new-ns focus
                          , None
                      (:def namespace definition focus)
                        if (not= namespace old-ns) None $ match old-def
                          (:none)
                            Some $ %bookmark :def new-ns definition focus
                          (:some old-name)
                            if (= definition old-name)
                              Some $ %bookmark :def new-ns new-def focus
                              , None
              match target
                (:none) db
                (:some bookmark)
                  let
                      pointer $ decode-map-as
                        .unwrap-or
                          get (.unwrap writer) :pointer
                          , 0
                        , Number
                    decode-map-as
                      assoc-in db ([] :sessions sid :writer :stack pointer) bookmark
                      Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String (Option String) String String
            -> $ Map Tag Dynamic
        'swap-left $ %{} 'CodeEntry
          :doc "|say we have `a b`, focus at `b`, `:swap-left` moves `b` to left, gets `b a`, and focus at `a` now. internally, path to `a` is maintained."
          :code $ quote $ defn swap-left (db session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                parent $ .unwrap $ app.bookmark/get-parent bookmark
                current $ .unwrap $ last (app.bookmark/get-focus bookmark)
                expr $ app.updater.writer/read-bookmark-expr db parent
                children $ :data expr
                child-keys $ sort
                  .to-list $ keys children
                  , &compare
                idx $ .unwrap $ index-of child-keys current
              if (= idx 0) db $ let
                  left $ .unwrap $ get child-keys (dec idx)
                  child $ .unwrap $ get children current
                  next-data $ assoc-before (dissoc children current) left child
                  next $ app.updater.writer/write-bookmark-node db parent $ assoc expr :data next-data
                app.updater.writer/focus next
                  conj (app.bookmark/get-focus parent) left
                  , session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'toggle-comment $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn toggle-comment (db sid op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db sid)
              match (app.updater.writer/read-bookmark-node db bookmark)
                (app.schema/CirruExprShape expr)
                  let
                      data $ :data expr
                      first-key $ get-min-key data
                      comment-key $ match first-key
                        (:none) None
                        (:some key)
                          match
                            .unwrap $ get data key
                            (app.schema/CirruLeafShape leaf)
                              if
                                = |; $ :text leaf
                                Some key
                                , None
                            (app.schema/CirruExprShape _child) None
                      next-data $ match comment-key
                        (:some key) (dissoc data key)
                        (:none)
                          let
                              author $ match
                                get-in db $ [] :sessions sid :user-id
                                (:ok value)
                                  if (nil? value) | $ decode-map-as value String
                                (:err error)
                                  match error
                                    (:missing) |
                                    (:shape message) (raise message)
                              marker $ cirru->tree |; author op-time
                            assoc-prepend data marker
                    app.updater.writer/write-bookmark-node db bookmark $ assoc expr :data next-data
                (app.schema/CirruLeafShape leaf)
                  do (println "|Toggle comment at wrong place," leaf) db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
            :features :io
        'transfer-namespace $ %{} 'CodeEntry
          :doc "|Validate both names and the source entry before altering the file map."
          :code $ quote $ defn transfer-namespace (db op-data move?)
            let
                transfer $ decode-map-as op-data 'app.updater.ir/NamespaceTransfer
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                source $ .unwrap $ get files (:from transfer)
                next $ if move?
                  dissoc files $ :from transfer
                  , files
              assoc db :files $ assoc next (:to transfer) source
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) T Bool
            -> $ Map Tag Dynamic
            :generics T
          :tests $ [] $ %{} 'TestEntry (:name |checked-namespace-transfer-and-selection)
            :code $ quote $ let
                entry $ %{} app.schema/CodeEntry (:doc |)
                  :code $ app.util/cirru->tree ([] |ns |demo.source) |fixture 1
                  :examples $ []
                  :source-entry None
                file $ %{} app.schema/FileEntry (:ns entry)
                  :defs $ {}
                  :source-view None
                path $ [] :sessions |sid :writer :selected-ns
                db $ {}
                  :files $ {} $ |demo.source file
                  :sessions $ {} $ |sid
                    {} $ :writer $ {} (:selected-ns |demo.source)
                names $ {} (:from |demo.source) (:to |demo.copy)
                copied $ transfer-namespace db names false
                moved $ transfer-namespace db names true
              assert= (Result :ok file)
                get-in copied $ [] :files |demo.copy
              assert= (Result :ok file)
                get-in copied $ [] :files |demo.source
              assert= (Result :ok file)
                get-in moved $ [] :files |demo.copy
              assert=
                Some $ {} $ |demo.copy file
                get moved :files
              assert= (Result :ok |demo.source)
                get-in (remove-ns copied |demo.copy |sid |edit 1) path
              assert=
                Result :err $ PathError :missing
                get-in (remove-ns copied |demo.source |sid |edit 1) path
            :tags $ #{} :unit
        'unindent $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn unindent (db session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                expr $ app.updater.writer/read-bookmark-expr db bookmark
                children $ :data expr
              match (app.bookmark/get-parent bookmark)
                (:none)
                  if
                    = 1 $ .len children
                    let
                        key $ .unwrap $ get-min-key children
                      app.updater.writer/write-bookmark-node db bookmark $ .unwrap $ get children key
                    , db
                (:some parent)
                  let
                      base $ app.updater.writer/read-bookmark-expr db parent
                      base-data $ :data base
                      key $ .unwrap $ last (app.bookmark/get-focus bookmark)
                      keys-in-order $ sort $ &set:to-list (keys base-data)
                      child-keys $ sort $ &set:to-list (keys children)
                      index $ .unwrap $ index-of keys-in-order key
                      limit $ .unwrap-or
                        .get keys-in-order $ inc index
                        , bisection/max-id
                      next-data $ loop
                          data base-data
                          remaining child-keys
                          next-key key
                        match (first remaining)
                          (:none) data
                          (:some child-key)
                            recur
                              assoc data next-key $ .unwrap $ get children child-key
                              rest remaining
                              bisection/bisect next-key limit
                    app.updater.writer/write-bookmark-node db parent $ assoc base :data next-data
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'unindent-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn unindent-leaf (db session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                parent $ .unwrap-or (app.bookmark/get-parent bookmark) bookmark
                expr $ app.updater.writer/read-bookmark-expr db parent
                children $ :data expr
              if
                = 1 $ .len children
                let
                    key $ .unwrap $ get-min-key children
                    updated $ app.updater.writer/write-bookmark-node db parent $ .unwrap (get children key)
                  app.updater.writer/focus updated (app.bookmark/get-focus parent) session-id op-id op-time
                , db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'update-leaf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-leaf (db op-data session-id op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db session-id)
                author $ decode-map-as
                  app.util/get-required-path db $ [] :sessions session-id :user-id
                  , String
                fields $ decode-map-as op-data $ Map Tag Dynamic
              match (app.updater.writer/read-bookmark-node db bookmark)
                (app.schema/CirruLeafShape leaf)
                  let
                      op-at $ get fields :at
                      op-text $ get fields :text
                    if
                      and (.some? op-at) (.some? op-text)
                      let
                          at $ decode-map-as (.unwrap op-at) Number
                        if
                          > at $ :at leaf
                          let
                              text $ decode-map-as (.unwrap op-text) String
                            app.updater.writer/write-bookmark-node db bookmark $ %{} schema/CirruLeaf (:at at) (:by author) (:text text)
                          do (println "|invalid updata op:" op-data) db
                      do (println "|invalid updata op:" op-data) db
                (app.schema/CirruExprShape _expr) (raise "|Expected Cirru leaf node")
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.ir
          :require (app.schema :as schema) (bisection-key.core :as bisection)
            app.util.list :refer $ dissoc-idx
            bisection-key.util :refer $ key-before key-after key-prepend key-append assoc-prepend key-nth assoc-nth val-nth get-min-key assoc-before
            app.bookmark :refer $ Bookmark %bookmark
            app.util :refer $ expr? leaf? bookmark->path to-writer to-bookmark cirru->tree push-warning
    'app.updater.notify $ %{} 'FileEntry
      :defs $ {}
        'broadcast $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn broadcast (db op-data sid op-id op-time)
            let
                user-id $ decode-map-as
                  app.util/get-required-path db $ [] :sessions sid :user-id
                  , String
                user-name $ decode-map-as
                  app.util/get-required-path db $ [] :users user-id :name
                  , String
                message $ str user-name "|: " op-data
                sessions $ decode-map-as
                  .unwrap $ get db :sessions
                  Map String $ Map Tag Dynamic
                next-sessions $ filter-map-kv sessions $ fn (id session)
                  hint-fn $ Fn String (Map Tag Dynamic)
                    -> $ MapEntryDecision String $ Map Tag Dynamic
                  MapEntryDecision :keep id $ assoc session :notifications $
                    push-info op-id op-time message
                    get session :notifications
              assoc db :sessions next-sessions
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'clear $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn clear (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :notifications) ([])
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'push-message $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn push-message (db kind text sid op-id op-time)
            decode-map-as
              update-in db ([] :sessions sid :notifications) (app.util/push-notification kind op-id op-time text)
              Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Tag String String String Number
            -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.notify
          :require $ app.util :refer $ push-info
    'app.updater.router $ %{} 'FileEntry
      :defs $ {}
        'Route $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Route (:files) (:graph) (:editor) (:profile) (:search) (:configs) (:watching String)
          :examples $ []
          :schema $ quote EnumDef
        'change $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn change (db route session-id _op-id _op-time)
            assoc-in db ([] :sessions session-id :router) (route->wire route)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Route String String Number
            -> $ Map Tag Dynamic
        'read-route $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-route (raw)
            match raw
              (:files) (Route :files)
              (:graph) (Route :graph)
              (:editor) (Route :editor)
              (:profile) (Route :profile)
              (:search) (Route :search)
              (:configs) (Route :configs)
              (:watching sid)
                Route :watching $ decode-map-as sid 'String
              _ $ raise |Unknown-editor-route
          :examples $ []
          :schema $ quote $ Fn Raw (-> Route) (:generics Raw)
        'route->wire $ %{} 'CodeEntry
          :doc "|Encode a typed route as the original anonymous WebSocket enum."
          :code $ quote $ defn route->wire (route)
            match route
              (:files) (:: :files)
              (:graph) (:: :graph)
              (:editor) (:: :editor)
              (:profile) (:: :profile)
              (:search) (:: :search)
              (:configs) (:: :configs)
              (:watching sid) (:: :watching sid)
          :examples $ []
          :schema $ quote $ Fn Route (-> AnyEnum) (:open :reflect)
          :tests $ [] $ %{} 'TestEntry
            :name |checked-local-routes-retain-anonymous-wire-protocol
            :code $ quote $ do
              assert= (:: :files)
                route->wire $ read-route $ :: :files
              assert= (:: :watching |peer)
                route->wire $ read-route $ :: :watching |peer
              assert=
                :: :router/change $ :: :watching |peer
                route-op $ Route :watching |peer
              assert= true $ try
                do
                  read-route $ :: :unknown
                  , false
                fn (_error) true
            :tags $ #{} :unit
        'route-op $ %{} 'CodeEntry
          :doc "|Encode a typed navigation request using the existing WebSocket action format."
          :code $ quote $ defn route-op (route)
            :: :router/change $ route->wire route
          :examples $ []
          :schema $ quote $ Fn Route (-> AnyEnum) (:open :reflect)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.router
    'app.updater.session $ %{} 'FileEntry
      :defs $ {}
        'connect $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn connect (db session-id op-id op-time)
            assoc-in db ([] :sessions session-id)
              merge schema/session $ {} $ :id session-id
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'disconnect $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn disconnect (db session-id op-id op-time)
            update db :sessions $ fn (session) (dissoc session session-id)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'select-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn select-ns (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :writer :selected-ns) op-data
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.session
          :require $ app.schema :as schema
    'app.updater.user $ %{} 'FileEntry
      :defs $ {}
        'change-theme $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn change-theme (db theme sid _op-id _op-time)
            -> db
              assoc-in
                [] :users (session-user-id db sid) :theme
                , theme
              assoc-in ([] :sessions sid :theme) theme
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Tag String String Number
            -> $ Map Tag Dynamic
        'log-in $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn log-in (db credentials session-id op-id op-time)
            let[] (username password) credentials $ let
                users $ decode-map-as
                  .unwrap-or (get db :users) ({})
                  Map String $ Map Tag Dynamic
                sessions $ decode-map-as
                  .unwrap-or (get db :sessions) ({})
                  Map String $ Map Tag Dynamic
                session $ .unwrap-or (get sessions session-id) ({})
                maybe-user $ find-first
                  fn (user)
                    hint-fn $ Fn (Map Tag Dynamic) (-> Bool)
                    = username $ .unwrap-or (get user :name) |
                  &set:to-list $ distinct-values users
                next $ match maybe-user
                  (:some user)
                    if
                      = (md5 password)
                        .unwrap-or (get user :password) |
                      assoc session :user-id $ .unwrap-or (get user :id) |
                      assoc session :notifications $
                        push-warning op-id op-time $ str "|Wrong password for " username
                        get session :notifications
                  (:none)
                    assoc session :notifications $
                      push-warning op-id op-time $ str "|No user named: " username
                      get session :notifications
              assoc db :sessions $ assoc sessions session-id next
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List String) String String Number
            -> $ Map Tag Dynamic
        'log-out $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn log-out (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :user-id) nil
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Unit String String Number
            -> $ Map Tag Dynamic
        'nickname $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn nickname (db nickname sid _op-id _op-time)
            assoc-in db
              [] :users (session-user-id db sid) :nickname
              if (blank? nickname) |Someone nickname
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String String Number
            -> $ Map Tag Dynamic
        'session-user-id $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn session-user-id (db sid)
            match
              get-in db $ [] :sessions sid :user-id
              (:ok value) (decode-map-as value 'String)
              (:err _error) (raise |Missing-session-user-id)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String (-> String)
        'sign-up $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn sign-up (db op-data session-id op-id op-time)
            let[] (username password) op-data $ let
                users $ decode-map-as
                  .unwrap-or (get db :users) ({})
                  Map String $ Map Tag Dynamic
              let
                  maybe-user $ find-first
                    fn (user)
                      hint-fn $ Fn (Map Tag Dynamic) (-> Bool)
                      = username $ .unwrap-or (get user :name) |
                    &set:to-list $ distinct-values users
                let
                    new-user-id $ str |u $ count users
                  if (.some? maybe-user)
                    update-in db ([] :sessions session-id :notifications)
                      push-warning op-id op-time $ str "|Name is taken: " username
                    -> db
                      assoc-in ([] :sessions session-id :user-id) new-user-id
                      assoc-in ([] :users new-user-id)
                        merge schema/user $ {} (:id new-user-id) (:name username) (:nickname username)
                          :password $ md5 password
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List String) String String Number
            -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.user
          :require
            app.util :refer $ find-first push-warning
            app.util.compile :refer $ md5
            app.schema :as schema
    'app.updater.watcher $ %{} 'FileEntry
      :defs $ {}
        'choose-source-version $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn choose-source-version (label previous current incoming)
            if (= current previous) incoming $ if
              or (= incoming previous) (= incoming current)
              , current $ raise
                str "|Source changed while editor has pending changes: " label
          :examples $ []
          :schema $ quote $ Fn String T T T (-> T) (:generics T)
          :tests $ [] $ %{} 'TestEntry
            :name |three-way-choice-retains-local-and-rejects-overlap
            :code $ quote $ do
              assert= |remote $ choose-source-version |config |base |base |remote
              assert= |local $ choose-source-version |config |base |local |base
              assert= |same $ choose-source-version |config |base |same |same
              assert= true $ try
                do (choose-source-version |config |base |local |remote) false
                fn (_error) true
            :tags $ #{} :unit
        'file-change $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn file-change (db project _sid _op-id _op-time)
            let
                canonical $ source/restore-editor-state project None
                previous $ decode-map-as
                  .unwrap $ get db :saved-files
                  Map String app.schema/FileEntry
                current $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                files $ refresh-files previous current $ :files project
                configs $ choose-source-version |configs
                  decode-map-as
                    .unwrap $ get db :saved-configs
                    Map Tag Dynamic
                  decode-map-as
                    .unwrap $ get db :configs
                    Map Tag Dynamic
                  decode-map-as
                    .unwrap $ get canonical :configs
                    Map Tag Dynamic
                entries $ choose-source-version |entries
                  decode-map-as
                    .unwrap $ get db :saved-entries
                    Map String $ Map Tag Dynamic
                  decode-map-as
                    .unwrap $ get db :entries
                    Map String $ Map Tag Dynamic
                  :entries project
              ->
                merge db $ &struct:to-map project
                assoc :files files
                assoc :saved-files $ :files project
                assoc :configs configs
                assoc :saved-configs $ .unwrap $ get canonical :configs
                assoc :entries entries
                assoc :saved-entries $ :entries project
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) source/SourceProject String String Number
            -> $ Map Tag Dynamic
        'refresh-files $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn refresh-files (previous current incoming)
            filter-map-kv (merge previous current incoming)
              fn (namespace _file)
                hint-fn $ Fn String schema/FileEntry $ -> (MapEntryDecision String schema/FileEntry)
                match
                  choose-source-version namespace (get previous namespace) (get current namespace) (get incoming namespace)
                  (:none) (MapEntryDecision :drop)
                  (:some file) (MapEntryDecision :keep namespace file)
          :examples $ []
          :schema $ quote $ Fn (Map String schema/FileEntry) (Map String schema/FileEntry) (Map String schema/FileEntry)
            -> $ Map String schema/FileEntry
          :tests $ [] $ %{} 'TestEntry (:name |nonoverlap-add-remove-and-pending-namespace)
            :code $ quote $ let
                a $ %{} schema/FileEntry
                  :defs $ {}
                  :source-view None
                  :ns $ %{} schema/CodeEntry (:doc |)
                    :examples $ []
                    :source-entry None
                    :code $ schema/syntax->node ([] |ns |demo) |source 0
                b $ assoc a :ns $ assoc (:ns a) :doc |remote
                pending $ assoc a :ns $ assoc (:ns a) :doc |pending
                previous $ {} (|same a) (|remote a) (|pending a) (|removed a)
                current $ assoc previous |pending pending
                incoming $ {} (|same a) (|remote b) (|pending a) (|added b)
                next $ refresh-files previous current incoming
              assert= (Some pending) (get next |pending)
              assert= (Some b) (get next |remote)
              assert= (Some b) (get next |added)
              assert= None $ get next |removed
              assert= true $ try
                do
                  refresh-files previous current $ assoc incoming |pending b
                  , false
                fn (_error) true
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.watcher
          :require (app.source :as source) (app.schema :as schema)
    'app.updater.writer $ %{} 'FileEntry
      :defs $ {}
        'accept-project-save $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn accept-project-save (db receipt selected sid op-id op-time)
            -> (accept-source-save db receipt selected sid op-id op-time)
              assoc :saved-configs $ decode-map-as
                .unwrap $ get db :configs
                Map Tag Dynamic
              assoc :saved-entries $ decode-map-as
                .unwrap $ get db :entries
                Map String $ Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.source/SourceSave (Option String) String String Number
            -> $ Map Tag Dynamic
        'accept-source-save $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn accept-source-save (db receipt selected sid op-id op-time)
            let
                revision $ match receipt
                  (:saved value) value
                  (:unchanged value) value
              assoc (save-files db selected sid op-id op-time) :source-revision revision
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.source/SourceSave (Option String) String String Number
            -> $ Map Tag Dynamic
          :tests $ [] $ %{} 'TestEntry
            :name |partial-save-baseline-and-revision-follow-the-receipt
            :code $ quote $ let
                entry $ %{} schema/CodeEntry (:doc |saved)
                  :code $ schema/syntax->node ([] |ns |demo.main) |source 0
                  :examples $ []
                  :source-entry None
                file $ %{} schema/FileEntry (:ns entry)
                  :defs $ {}
                  :source-view None
                changed $ struct-with file $ :ns
                  struct-with entry $ :doc |pending
                db $ {} (:source-revision |old)
                  :files $ {} (|demo.main changed) (|demo.other changed)
                  :saved-files $ {} (|demo.main file) (|demo.other file) (|demo.removed file)
                  :users $ {} $ |fixture
                    {} $ :name "|合成成员"
                  :sessions $ {} $ |session
                    {} (:user-id |fixture)
                      :notifications $ []
                partial $ accept-source-save db (app.source/SourceSave :saved |new) (Some |demo.main) |session |op 42
                baseline $ decode-map-as
                  .unwrap $ get partial :saved-files
                  Map String app.schema/FileEntry
                removed $ accept-source-save partial (app.source/SourceSave :saved |next) (Some |demo.removed) |session |op2 43
                all-saved $ accept-source-save removed (app.source/SourceSave :unchanged |next) None |session |op3 44
                messages $ match
                  get-in partial $ [] :sessions |session :notifications
                  (:ok value)
                    decode-map-as value $ List $ Map Tag Dynamic
                  (:err _error) (raise |Missing-save-notification)
              assert= (Some |new) (get partial :source-revision)
              assert= (Some changed) (get baseline |demo.main)
              assert= (Some file) (get baseline |demo.other)
              assert= None $ get
                decode-map-as
                  .unwrap $ get removed :saved-files
                  Map String app.schema/FileEntry
                , |demo.removed
              assert= (get all-saved :files) (get all-saved :saved-files)
              assert= (Some |next) (get all-saved :source-revision)
              assert= 1 $ count messages
              assert= (Some "|合成成员 modified ns demo.main!")
                get
                  .unwrap $ first messages
                  , :text
            :tags $ #{} :unit
        'collapse $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn collapse (db idx session-id op-id op-time)
            decode-map-as
              update-in db ([] :sessions session-id :writer)
                fn (writer)
                  hint-fn $ Fn (Option Dynamic)
                    -> $ Map Tag Dynamic
                  let
                      fields $ decode-map-as
                        .unwrap-or writer $ {}
                        Map Tag Dynamic
                      stack $ app.bookmark/read-bookmarks $ .unwrap (get fields :stack)
                    assoc
                      assoc fields :stack $ slice stack idx
                      , :pointer 0
              Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Number String String Number
            -> $ Map Tag Dynamic
        'doc-set $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn doc-set (db bookmark docstring sid op-id op-time)
            write-bookmark-entry db bookmark $ assoc (read-bookmark-entry db bookmark) :doc docstring
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.bookmark/%bookmark String String String Number
            -> $ Map Tag Dynamic
        'draft-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn draft-ns (db op-data sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer)
                assoc (.unwrap-or writer {}) :draft-ns op-data
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'edit $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn edit (db op-data session-id op-id op-time)
            let
                bookmark $ read-edit-bookmark op-data
              -> db
                update-in ([] :sessions session-id :writer) (push-bookmark bookmark false)
                assoc-in ([] :sessions session-id :router) (:: :editor)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'edit-ns $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn edit-ns (db sid op-id op-time)
            let
                writer $ to-writer db sid
              match (to-bookmark writer)
                (:some bookmark)
                  decode-map-as
                    update-in db ([] :sessions sid :writer)
                      push-bookmark
                        %bookmark :ns (app.bookmark/get-namespace bookmark) ([])
                        , false
                    Map Tag Dynamic
                (:none) db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'finish $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn finish (db sid op-id op-time)
            update-in db ([] :sessions sid :writer)
              fn (writer)
                hint-fn $ Fn (Option Dynamic)
                  -> $ Map Tag Dynamic
                let
                    writer-map $ decode-map-as
                      .unwrap-or writer $ {}
                      Map Tag Dynamic
                    pointer $ decode-map-as
                      .unwrap-or (get writer-map :pointer) 0
                      , Number
                    stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer-map :stack) ([])
                    next-stack $ if
                      > (count stack) pointer
                      dissoc-idx stack pointer
                      , stack
                  -> writer-map (assoc :stack next-stack)
                    assoc :pointer $ if (> pointer 0) (dec pointer) pointer
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'focus $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn focus (db next-focus session-id op-id op-time)
            let
                writer $ .unwrap $ app.util/to-writer db session-id
                pointer $ decode-map-as
                  .unwrap-or (get writer :pointer) 0
                  , Number
              decode-map-as
                app.util/update-in-existing db ([] :sessions session-id :writer :stack pointer)
                  fn (raw-bookmark)
                    let
                        bookmark $ app.bookmark/read-bookmark raw-bookmark
                      match bookmark
                        (:def namespace definition _focus) (%bookmark :def namespace definition next-focus)
                        (:ns namespace _focus) (%bookmark :ns namespace next-focus)
                Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (List String) String String Number
            -> $ Map Tag Dynamic
        'go-down $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn go-down (db op-data session-id op-id op-time)
            let
                writer $ .unwrap $ app.util/to-writer db session-id
                tail? $ .unwrap-or (get op-data :tail?) false
                stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer :stack) ([])
                pointer $ decode-map-as
                  .unwrap-or (get writer :pointer) 0
                  , Number
                bookmark $ Bookmark $ .unwrap (get stack pointer)
                target-expr $ read-bookmark-expr db bookmark
                target-data $ :data target-expr
              if
                = 0 $ count target-data
                , db $ -> db $ update-in ([] :sessions session-id :writer :stack pointer)
                  fn (b)
                    hint-fn $ Fn (Option Dynamic) (-> app.bookmark/%bookmark)
                    app.bookmark/update-focus
                      Bookmark $ app.bookmark/read-bookmark $ .unwrap b
                      fn (focus)
                        hint-fn $ Fn (List String)
                          -> $ List String
                        conj focus $ if tail?
                          .unwrap $ get-max-key target-data
                          .unwrap $ get-min-key target-data
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'go-left $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn go-left (db session-id op-id op-time)
            let
                writer $ .unwrap $ app.util/to-writer db session-id
                stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer :stack) ([])
                pointer $ decode-map-as
                  .unwrap-or (get writer :pointer) 0
                  , Number
                bookmark $ .unwrap $ get stack pointer
                current-focus $ app.bookmark/get-focus bookmark
              if (empty? current-focus) db $ let
                  parent-focus $ butlast current-focus
                  parent-bookmark $ match bookmark
                    (:def namespace definition _focus) (%bookmark :def namespace definition parent-focus)
                    (:ns namespace _focus) (%bookmark :ns namespace parent-focus)
                  last-coord $ .unwrap $ last current-focus
                  base-expr $ read-bookmark-expr db parent-bookmark
                  base-data $ :data base-expr
                  child-keys $ sort $ &set:to-list (keys base-data)
                  idx $
                    index-of child-keys last-coord
                    , .unwrap-or 0
                  next-coord $ if (= 0 idx) last-coord $ .unwrap
                    .get child-keys $ dec idx
                focus db (conj parent-focus next-coord) session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'go-right $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn go-right (db session-id op-id op-time)
            let
                writer $ .unwrap $ app.util/to-writer db session-id
                stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer :stack) ([])
                pointer $ decode-map-as
                  .unwrap-or (get writer :pointer) 0
                  , Number
                bookmark $ .unwrap $ get stack pointer
                current-focus $ app.bookmark/get-focus bookmark
              if (empty? current-focus) db $ let
                  parent-focus $ butlast current-focus
                  parent-bookmark $ match bookmark
                    (:def namespace definition _focus) (%bookmark :def namespace definition parent-focus)
                    (:ns namespace _focus) (%bookmark :ns namespace parent-focus)
                  last-coord $ .unwrap $ last current-focus
                  base-expr $ read-bookmark-expr db parent-bookmark
                  base-data $ :data base-expr
                  child-keys $ sort $ &set:to-list (keys base-data)
                  idx $
                    index-of child-keys last-coord
                    , .unwrap-or 0
                  next-coord $ if
                    = idx $ dec $ .len child-keys
                    , last-coord $ .unwrap
                      .get child-keys $ inc idx
                focus db (conj parent-focus next-coord) session-id op-id op-time
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'go-up $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn go-up (db session-id op-id op-time)
            let
                writer $ .unwrap $ app.util/to-writer db session-id
                stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer :stack) ([])
                pointer $ decode-map-as
                  .unwrap-or (get writer :pointer) 0
                  , Number
                bookmark $ .unwrap $ get stack pointer
              match (app.bookmark/get-parent bookmark)
                (:some parent)
                  focus db (app.bookmark/get-focus parent) session-id op-id op-time
                (:none) db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'hide-peek $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn hide-peek (db op-data sid op-id op-time)
            assoc-in db ([] :sessions sid :writer :peek-def) nil
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'move-next $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn move-next (db sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer)
                hint-fn $ Fn (Option Dynamic)
                  -> $ Map Tag Dynamic
                let
                    writer-map $ decode-map-as
                      .unwrap-or writer $ {}
                      Map Tag Dynamic
                    pointer $ decode-map-as
                      .unwrap-or (get writer-map :pointer) 0
                      , Number
                    stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer-map :stack) ([])
                  assoc writer-map :pointer $ if
                    >= pointer $ dec $ count stack
                    , pointer $ inc pointer
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'move-order $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn move-order (db op-map sid op-id op-time)
            let
                from-idx $
                  get op-map :from
                  , .unwrap-or 0
                to-idx $
                  get op-map :to
                  , .unwrap-or 0
              decode-map-as
                update-in db ([] :sessions sid :writer)
                  fn (writer)
                    hint-fn $ Fn (Option Dynamic)
                      -> $ Map Tag Dynamic
                    let
                        writer-map $ decode-map-as
                          .unwrap-or writer $ {}
                          Map Tag Dynamic
                        pointer $ decode-map-as
                          .unwrap-or (get writer-map :pointer) 0
                          , Number
                        stack $ app.bookmark/read-bookmarks $ .unwrap-or (get writer-map :stack) ([])
                        next-pointer $ cond
                            = pointer from-idx
                            , to-idx
                          (or (< pointer (.unwrap-or (min ([] from-idx to-idx)) 0)) (> pointer (.unwrap-or (max ([] from-idx to-idx)) 0)))
                            , pointer
                          true $ if (> from-idx to-idx) (inc pointer) (dec pointer)
                        moved $
                          get stack from-idx
                          , .unwrap
                        next-stack $ if (< from-idx to-idx)
                          concat
                            slice stack 0 $ Some from-idx
                            slice stack (inc from-idx)
                              Some $ inc to-idx
                            [] moved
                            slice stack $ inc to-idx
                          concat
                            slice stack 0 $ Some to-idx
                            [] moved
                            slice stack to-idx $ Some from-idx
                            if
                              >= (inc from-idx) (.len stack)
                              []
                              slice stack $ inc from-idx
                      -> writer-map (assoc :pointer next-pointer) (assoc :stack next-stack)
                Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Map Tag Number) String String Number
            -> $ Map Tag Dynamic
        'move-previous $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn move-previous (db sid op-id op-time)
            -> db $ update-in ([] :sessions sid :writer)
              fn (writer)
                hint-fn $ Fn (Option Dynamic)
                  -> $ Map Tag Dynamic
                let
                    writer-map $ decode-map-as
                      .unwrap-or writer $ {}
                      Map Tag Dynamic
                    pointer $ decode-map-as
                      .unwrap-or (get writer-map :pointer) 0
                      , Number
                  assoc writer-map :pointer $ if (> pointer 0) (dec pointer) 0
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'paste $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn paste (db op-data sid op-id op-time)
            let
                bookmark $ .unwrap $ to-bookmark (to-writer db sid)
              if (list? op-data)
                let
                    author $ match
                      get-in db $ [] :sessions sid :user-id
                      (:ok value)
                        if (nil? value) | $ decode-map-as value String
                      (:err error)
                        match error
                          (:missing) |
                          (:shape message) (raise message)
                  write-bookmark-node db bookmark $ cirru->tree op-data author op-time
                , db
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'pick-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn pick-node (db op-data sid op-id op-time)
            let
                user-id $ decode-map-as
                  app.util/get-required-path db $ [] :sessions sid :user-id
                  , String
                writer $ .unwrap $ to-writer db sid
                bookmark $ app.bookmark/read-bookmark $ .unwrap (get writer :picker-mode)
                syntax $ app.util/normalize-cirru op-data
                node $ schema/syntax->node syntax user-id op-time
                updated $ write-bookmark-node db bookmark node
                code $ if (string? op-data) op-data $ let
                    printed $ stringify-s-expr syntax
                  if
                    > (count printed) 40
                    str
                      slice printed 0 $ Some 40
                      , |...
                    , printed
              decode-map-as
                -> updated
                  assoc-in ([] :sessions sid :writer) (dissoc writer :picker-mode)
                  update-in ([] :sessions sid :notifications)
                    push-info op-id op-time $ str "|picked " code
                Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
            :features :io
        'picker-mode $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn picker-mode (db session-id op-id op-time)
            update-in db ([] :sessions session-id :writer)
              fn (writer)
                hint-fn $ Fn (Option Dynamic)
                  -> $ Map Tag Dynamic
                let
                    writer-map $ decode-map-as
                      .unwrap-or writer $ {}
                      Map Tag Dynamic
                  if
                      get writer-map :picker-mode
                      , .some?
                    dissoc writer-map :picker-mode
                    match (to-bookmark writer)
                      (:some bookmark) (assoc writer-map :picker-mode bookmark)
                      (:none) writer-map
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String String Number
            -> $ Map Tag Dynamic
        'point-to $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn point-to (db op-data session-id op-id op-time)
            assoc-in db ([] :sessions session-id :writer :pointer) op-data
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'read-bookmark-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-bookmark-entry (db bookmark)
            let
                file $ read-bookmark-file db bookmark
              match bookmark
                (:ns _namespace _focus) (:ns file)
                (:def _namespace definition _focus)
                  .unwrap $ get (:defs file) definition
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.bookmark/%bookmark (-> schema/CodeEntry)
        'read-bookmark-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-bookmark-expr (db bookmark)
            match (read-bookmark-node db bookmark)
              (app.schema/CirruExprShape expr) expr
              _ $ raise "|Expected Cirru expression node"
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.bookmark/%bookmark (-> schema/CirruExprShape)
        'read-bookmark-file $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-bookmark-file (db bookmark)
            decode-map-as
              app.util/get-required-path db $ [] :files $ app.bookmark/get-namespace bookmark
              , app.schema/FileEntry
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.bookmark/%bookmark (-> schema/FileEntry)
        'read-bookmark-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn read-bookmark-node (db bookmark)
            let
                entry $ read-bookmark-entry db bookmark
                root $ schema/read-node $ :code entry
              .unwrap $ schema/node-at-path root $ app.bookmark/get-focus bookmark
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.bookmark/%bookmark (-> schema/CirruNode)
        'read-edit-bookmark $ %{} 'CodeEntry
          :doc "|Check anonymous wire :ns / :def targets, validate String payloads and construct a local bookmark with the existing empty focus path."
          :code $ quote $ defn read-edit-bookmark (raw)
            if (enum? raw)
              match raw
                (:ns namespace)
                  %bookmark :ns (decode-map-as namespace String) ([])
                (:def namespace definition)
                  %bookmark :def (decode-map-as namespace String) (decode-map-as definition String) ([])
                _ $ raise "|Unknown editor bookmark target"
              raise "|Expected editor bookmark target enum"
          :examples $ []
          :schema $ quote $ Fn Dynamic (-> app.bookmark/%bookmark)
        'remove-idx $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn remove-idx (db idx session-id op-id op-time)
            decode-map-as
              update-in db ([] :sessions session-id :writer)
                fn (writer)
                  hint-fn $ Fn (Option Dynamic)
                    -> $ Map Tag Dynamic
                  let
                      fields $ decode-map-as
                        .unwrap-or writer $ {}
                        Map Tag Dynamic
                      stack $ app.bookmark/read-bookmarks $ .unwrap (get fields :stack)
                      pointer $ decode-map-as
                        .unwrap $ get fields :pointer
                        , Number
                    assoc
                      assoc fields :stack $ dissoc-idx stack idx
                      , :pointer $ if
                        and (> pointer 0) (<= idx pointer)
                        dec pointer
                        , pointer
              Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Number String String Number
            -> $ Map Tag Dynamic
        'save-files $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn save-files (db selected sid op-id op-time)
            let
                files $ decode-map-as
                  .unwrap $ get db :files
                  Map String app.schema/FileEntry
                saved $ decode-map-as
                  .unwrap-or (get db :saved-files) ({})
                  Map String app.schema/FileEntry
                next-saved $ match selected
                  (:none) files
                  (:some name)
                    match (get files name)
                      (:some file) (assoc saved name file)
                      (:none) (dissoc saved name)
                users $ decode-map-as
                  .unwrap-or (get db :users) ({})
                  Map String $ Map Tag Dynamic
                author $ match
                  get-in db $ [] :sessions sid :user-id
                  (:ok raw-id)
                    if (nil? raw-id) |Guest $ let
                        user $ .unwrap-or
                          get users $ decode-map-as raw-id 'String
                          {}
                      .unwrap-or
                        app.schema/read-optional-text $ get user :name
                        , |Guest
                  (:err _error) |Guest
                description $ match selected
                  (:none) "| saved files!"
                  (:some name) (str "| modified ns " name |!)
                sessions $ decode-map-as
                  .unwrap-or (get db :sessions) ({})
                  Map String $ Map Tag Dynamic
              -> db (assoc :saved-files next-saved)
                assoc :sessions $ filter-map-kv sessions $ fn (session-id session)
                  hint-fn $ Fn String (Map Tag Dynamic)
                    -> $ MapEntryDecision String $ Map Tag Dynamic
                  MapEntryDecision :keep session-id $ assoc session :notifications $
                    push-info op-id op-time $ str author description
                    get session :notifications
                dissoc :ir
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) (Option String) String String Number
            -> $ Map Tag Dynamic
        'select $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn select (db op-data session-id op-id op-time)
            let
                bookmark $ read-edit-bookmark op-data
              -> db
                update-in ([] :sessions session-id :writer) (push-bookmark bookmark false)
                assoc-in ([] :sessions session-id :router) (:: :editor)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) Dynamic String String Number
            -> $ Map Tag Dynamic
        'write-bookmark-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn write-bookmark-entry (db bookmark entry)
            let
                file $ read-bookmark-file db bookmark
                next-file $ match bookmark
                  (:ns _namespace _focus) (assoc file :ns entry)
                  (:def _namespace definition _focus)
                    assoc file :defs $ assoc (:defs file) definition entry
              decode-map-as
                assoc-in db
                  [] :files $ app.bookmark/get-namespace bookmark
                  , next-file
                Map Tag Dynamic
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.bookmark/%bookmark schema/CodeEntry
            -> $ Map Tag Dynamic
        'write-bookmark-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn write-bookmark-node (db bookmark node)
            let
                entry $ read-bookmark-entry db bookmark
                path $ app.bookmark/get-focus bookmark
                next-node $ if (empty? path) node $ schema/assoc-node-path
                  schema/read-expr $ :code entry
                  , path node
              write-bookmark-entry db bookmark $ assoc entry :code next-node
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) app.bookmark/%bookmark schema/CirruNode
            -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater.writer
          :require
            app.util.stack :refer $ push-bookmark
            app.util.list :refer $ dissoc-idx
            app.schema :as schema
            bisection-key.util :refer $ get-min-key get-max-key
            app.bookmark :refer $ %bookmark Bookmark
            app.util :refer $ bookmark->path to-writer to-bookmark push-info cirru->tree stringify-s-expr
    'app.util $ %{} 'FileEntry
      :defs $ {}
        'ImportBinding $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum ImportBinding (:as String) (:refer String)
          :examples $ []
          :schema $ quote EnumDef
        'SymbolReference $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def SymbolReference
            defenum SymbolReference (:qualified String String) (:unqualified String)
          :examples $ []
          :schema $ quote EnumDef
        'bookmark->path $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn bookmark->path (bookmark) (app.bookmark/to-path bookmark)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark
            -> $ List app.bookmark/PathSegment
        'bookmark-full-str $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn bookmark-full-str (bookmark)
            match bookmark
              (:def ns' def' f) (str ns' |/ def')
              (:ns ns' f) (str ns' |/)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark (-> String)
        'cirru->tree $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn cirru->tree (xs author timestamp)
            schema/syntax->node (normalize-cirru xs) author timestamp
          :examples $ []
          :schema $ quote $ Fn Dynamic String Number (-> schema/CirruNode) (:features :io)
        'expr? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn expr? (x)
            and (struct? x)
              = :Expr $ &struct:get-name x
          :examples $ []
          :schema $ quote $ Fn Input (-> Bool) (:generics Input)
        'find-first $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn find-first (f xs)
            find xs $ fn (x) (f x)
          :examples $ []
          :schema $ quote $ Fn
            Fn T $ -> Bool
            List T
            -> $ Option T
            :generics T
        'get-required-path $ %{} 'CodeEntry
          :doc "|Read a required editor path; propagate missing/shape errors instead of converting failure into absence."
          :code $ quote $ defn get-required-path (data path)
            match (get-in data path)
              (:ok value) value
              (:err error)
                raise $ str "|Required editor path unavailable: " error
          :examples $ []
          :schema $ quote $ Fn Dynamic (List K) (-> Dynamic) (:generics K)
        'hide-empty-fields $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn hide-empty-fields (x)
            filter-map-kv x $ fn (k v)
              hint-fn $ Fn K V $ -> (MapEntryDecision K V)
              if (nil? v) (MapEntryDecision :drop) (MapEntryDecision :keep k v)
          :examples $ []
          :schema $ quote $ Fn (Map K V)
            -> $ Map K V
            :generics K V
        'kinds $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def kinds (#{} :ns :def)
          :examples $ []
          :schema $ quote Dynamic
        'leaf? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn leaf? (x)
            and (struct? x)
              = :Leaf $ &struct:get-name x
          :examples $ []
          :schema $ quote $ Fn Input (-> Bool) (:generics Input)
        'normalize-cirru $ %{} 'CodeEntry
          :doc "|Checked legacy Cirru input boundary. Preserve quoted wrappers and recursively normalize valid String/List syntax; reject unsupported values instead of inserting nil nodes."
          :code $ quote $ defn normalize-cirru (raw)
            decode-map-as (normalize-legacy-cirru-data raw) 'app.schema/CirruSyntax
          :examples $ []
          :schema $ quote $ Fn Input (-> schema/CirruSyntax) (:generics Input) (:features :io)
          :tests $ [] $ %{} 'TestEntry (:name |legacy-quoted-syntax-boundary)
            :code $ quote $ do
              assert=
                [] |keep ([] "|中文" "|🐈") ([])
                normalize-cirru $ [] |keep ([] "|中文" "|🐈") ([])
              assert=
                [] |keep $ [] "|中文"
                normalize-cirru $ cirru-quote $ keep ("中文")
              assert= ([] |keep)
                normalize-cirru $ :: 'quote $ [] |keep
              assert=
                [] $ [] |keep
                normalize-cirru $ [] $ :: 'quote ([] |keep)
              let
                  rejected $ ref false
                try
                  normalize-cirru $ [] |keep $ [] 42
                  fn (error) (reset! rejected true)
                assert= true @rejected
            :tags $ #{} :unit
        'normalize-legacy-cirru-data $ %{} 'CodeEntry
          :doc "|Legacy-only raw syntax adapter: unwrap quoted enum/CirruQuote wrappers and preserve String/List payloads. Its result is not trusted until normalize-cirru performs one complete recursive CirruSyntax decode."
          :code $ quote $ defn normalize-legacy-cirru-data (raw)
            cond
                enum? raw
                do
                  if
                    not $ or
                      &= 'quote $ &enum:nth raw 0
                      &= :quote $ &enum:nth raw 0
                    eprintln "|unknown tuple from cirru:" raw
                  normalize-legacy-cirru-data $ &enum:nth raw 1
              (cirru-quote? raw)
                normalize-legacy-cirru-data $ &cirru-quote:to-list raw
              (list? raw)
                map
                  decode-map-as raw $ List Dynamic
                  fn (child)
                    hint-fn $ Fn Dynamic $ -> Dynamic
                    normalize-legacy-cirru-data child
              (string? raw) raw
              true $ raise |Expected-Cirru-string-or-list
          :examples $ []
          :schema $ quote $ Fn Dynamic (-> Dynamic) (:features :io)
        'now! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn now! () (js-ffi.shared/now-ms)
          :examples $ []
          :schema $ quote $ Fn (-> Number) (:features :js-ffi)
        'parse-def $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-def (text)
            let
                clean-text $ &str:replace text |@ |
              if (&str:includes? clean-text |/)
                let
                    pieces $ split clean-text |/
                  SymbolReference :qualified
                    .unwrap $ .get pieces 0
                    .unwrap $ .get pieces 1
                let
                    dot $ .unwrap-or (str-find-index clean-text |.) -1
                  SymbolReference :unqualified $ if (&>= dot 0) (&str:slice clean-text 0 dot) clean-text
          :examples $ []
          :schema $ quote $ Fn String (-> SymbolReference)
        'parse-deps $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-deps (form)
            match form
              (String _leaf) ({})
              (List members)
                let
                    clause $ find (slice members 2)
                      fn (item)
                        hint-fn $ Fn schema/CirruSyntax $ -> Bool
                        match item
                          (String _text) false
                          (List values)
                            match (first values)
                              (:none) false
                              (:some head)
                                match head
                                  (String text) (= text |:require)
                                  (List _nested) false
                  match clause
                    (:none) ({})
                    (:some section)
                      match section
                        (String _text) ({})
                        (List rules)
                          fold (rest rules) ({})
                            fn (result item)
                              hint-fn $ Fn (Map String ImportBinding) schema/CirruSyntax $ -> (Map String ImportBinding)
                              match item
                                (String _text) result
                                (List rule)
                                  merge result $ parse-require rule
          :examples $ []
          :schema $ quote $ Fn schema/CirruSyntax
            -> $ Map String ImportBinding
            :features :io
        'parse-require $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn parse-require (rule)
            let
                first-item $ .unwrap $ first rule
                piece $ match first-item
                  (String marker)
                    if (= marker |[]) (rest rule) rule
                  (List _members) rule
                namespace $ decode-map-as
                  .unwrap $ .get piece 0
                  , String
                method $ decode-map-as
                  .unwrap $ .get piece 1
                  , String
                extra $ .unwrap $ .get piece 2
              match method
                |:as $ let
                    alias $ decode-map-as extra String
                  {} $ alias $ ImportBinding :as namespace
                |:refer $ match extra
                  (String _invalid) (raise "|Expected a list of referred names")
                  (List names)
                    fold names ({})
                      fn (result name)
                        hint-fn $ Fn (Map String ImportBinding) schema/CirruSyntax $ -> (Map String ImportBinding)
                        let
                            text $ decode-map-as name String
                          if (= text |[]) result $ assoc result text $ ImportBinding :refer namespace
                |:default $ let
                    text $ decode-map-as extra String
                  {} $ text $ ImportBinding :refer namespace
                _ $ do (println "|Unknown referring:" piece) ({})
          :examples $ []
          :schema $ quote $ Fn (List schema/CirruSyntax)
            -> $ Map String ImportBinding
            :features :io
        'prepend-data $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn prepend-data (x) ([] :data x)
          :examples $ []
          :schema $ quote $ Fn Number
            -> $ List Dynamic
        'push-info $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn push-info (op-id op-time text) (push-notification :info op-id op-time text)
          :examples $ []
          :schema $ quote $ Fn String Number String
            -> $ Fn (Option Dynamic)
              -> $ List $ Map Tag schema/NotificationField
        'push-notification $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn push-notification (kind op-id op-time text)
            fn (xs)
              hint-fn $ Fn (Option Dynamic)
                -> $ List $ Map Tag schema/NotificationField
              conj
                decode-map-as
                  .unwrap-or xs $ []
                  List $ Map Tag app.schema/NotificationField
                decode-map-as
                  {} (:id op-id) (:kind kind) (:text text) (:time op-time)
                  Map Tag app.schema/NotificationField
          :examples $ []
          :schema $ quote $ Fn Tag String Number String
            -> $ Fn (Option Dynamic)
              -> $ List $ Map Tag schema/NotificationField
        'push-warning $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn push-warning (op-id op-time text) (push-notification :warning op-id op-time text)
          :examples $ []
          :schema $ quote $ Fn String Number String
            -> $ Fn (Option Dynamic)
              -> $ List $ Map Tag schema/NotificationField
        'stringify-s-expr $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn stringify-s-expr (x)
            match x
              (String text)
                if (includes? text "| ") (to-lispy-string text) text
              (List xs)
                str "|("
                  join-string (map xs stringify-s-expr) "| "
                  , "|)"
          :examples $ []
          :schema $ quote $ Fn schema/CirruSyntax (-> String)
          :tests $ [] $ %{} 'TestEntry (:name |recursive-syntax-rendering)
            :code $ quote $ do
              assert= |keep $ stringify-s-expr |keep
              assert= "|(f (g 中文) 🐈)" $ stringify-s-expr $ [] |f ([] |g "|中文") "|🐈"
              assert= "|()" $ stringify-s-expr $ []
            :tags $ #{} :unit
        'to-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn to-bookmark (writer)
            let
                fields $ decode-map-as
                  .unwrap-or writer $ {}
                  Map Tag Dynamic
                stack $ app.bookmark/read-bookmarks $ .unwrap-or (get fields :stack) ([])
                pointer $ decode-map-as
                  .unwrap-or (get fields :pointer) 0
                  , 'Number
              nth stack pointer
          :examples $ []
          :schema $ quote $ Fn (Option Dynamic)
            -> $ Option app.bookmark/%bookmark
          :tests $ [] $ %{} 'TestEntry
            :name |missing-writer-and-stale-pointer-have-no-bookmark
            :code $ quote $ let
                bookmark $ app.bookmark/%bookmark :ns |demo.main $ []
                writer $ {} (:pointer 3)
                  :stack $ [] bookmark
              assert= None $ to-bookmark None
              assert= None $ to-bookmark $ Some
                parse-cirru-edn $ format-cirru-edn writer
            :tags $ #{} :unit
        'to-writer $ %{} 'CodeEntry
          :doc "|Read an optional session writer: missing is None; malformed intermediate shapes and non-map writers fail explicitly."
          :code $ quote $ defn to-writer (db session-id)
            match
              get-in db $ [] :sessions session-id :writer
              (:ok value)
                Some $ decode-map-as value $ Map Tag Dynamic
              (:err error)
                match error
                  (:missing) None
                  (:shape message) (raise message)
          :examples $ []
          :schema $ quote $ Fn (Map Tag Dynamic) String
            -> $ Option $ Map Tag Dynamic
        'tree->cirru $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn tree->cirru (x) (schema/node->syntax x)
          :examples $ []
          :schema $ quote $ Fn schema/CirruNode (-> schema/CirruSyntax)
        'update-in-existing $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn update-in-existing (data path f)
            assoc-in data path $ f $ get-required-path data path
          :examples $ []
          :schema $ quote $ Fn Dynamic (List K)
            Fn Dynamic $ -> Dynamic
            -> Dynamic
            :generics K
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util
          :require (app.schema :as schema) (bisection-key.core :as bisection)
            app.bookmark :refer $ Bookmark
    'app.util.compile $ %{} 'FileEntry
      :defs $ {}
        'CryptoModuleHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait CryptoModuleHost
            .create-hash $ Fn app.util.compile/CryptoModuleHost String $ -> app.util.compile/HashHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
            :names $ {} $ :create-hash |createHash
          :schema $ quote Trait
        'HashHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait HashHost
            .update $ Fn app.util.compile/HashHost String $ -> app.util.compile/HashHost
            .digest $ Fn app.util.compile/HashHost String $ -> String
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
          :schema $ quote Trait
        'md5 $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn md5 (s)
            let
                host $ unsafe-coerce crypto 'app.util.compile/CryptoModuleHost
                hash $ host .create-hash |md5
                updated $ hash .update s
              updated .digest |hex
          :examples $ []
          :schema $ quote $ Fn String (-> String) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util.compile
          :require $ |crypto :default crypto
    'app.util.detect $ %{} 'FileEntry
      :defs $ {}
        'ServerHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait ServerHost
            .once $ Fn app.util.detect/ServerHost String Dynamic $ -> app.util.detect/ServerHost
            .listen $ Fn app.util.detect/ServerHost Number String $ -> app.util.detect/ServerHost
            .close $ Fn app.util.detect/ServerHost $ -> Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :node)
          :schema $ quote Trait
        'port-taken? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn port-taken? (port next-fn)
            let
                create-server $ unsafe-coerce net/createServer $ Fn (-> app.util.detect/ServerHost)
                tester $ create-server
              tester .once |error $ fn (err)
                let
                    taken? $ match
                      try-decode-map-as (js-ffi.contract/object-field |Error err |code) String
                      (:ok code) (= code |EADDRINUSE)
                      (:err _message) false
                  if taken? (next-fn None true)
                    next-fn
                      Some $ shared/normalize-error err
                      , false
              tester .once |listening $ fn ()
                tester .once |close $ fn () $ next-fn None false
                tester .close
              tester .listen port |0.0.0.0
          :examples $ []
          :schema $ quote $ Fn Number
            Fn (Option shared/JsError) Bool $ -> Unit
            -> ServerHost
            :features :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util.detect
          :require (|net :as net) (js-ffi.shared :as shared)
    'app.util.dom $ %{} 'FileEntry
      :defs $ {}
        'ClipboardHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait ClipboardHost
            .write-text $ Fn app.util.dom/ClipboardHost String $ -> app.util.dom/ClipboardPromiseHost
            .read-text $ Fn app.util.dom/ClipboardHost $ -> app.util.dom/ClipboardPromiseHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:read-text |readText) (:write-text |writeText)
          :schema $ quote Trait
        'ClipboardPromiseHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait ClipboardPromiseHost
            .then-text $ Fn app.util.dom/ClipboardPromiseHost
              Fn String $ -> Unit
              -> app.util.dom/ClipboardPromiseHost
            .catch-error $ Fn app.util.dom/ClipboardPromiseHost
              Fn Dynamic $ -> Unit
              -> app.util.dom/ClipboardPromiseHost
            .then-value $ Fn app.util.dom/ClipboardPromiseHost
              Fn Dynamic $ -> Unit
              -> app.util.dom/ClipboardPromiseHost
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:catch-error |catch) (:then-text |then) (:then-value |then)
          :schema $ quote Trait
        'EventHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait EventHost
            .prevent-default! $ Fn app.util.dom/EventHost $ -> Unit
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} $ :prevent-default! |preventDefault
          :schema $ quote Trait
        'NavigatorHost $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait NavigatorHost (:clipboard 'app.util.dom/ClipboardHost)
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object)
          :schema $ quote Trait
        'copy-silently! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn copy-silently! (x)
            let
                navigator $ unsafe-coerce js/navigator 'app.util.dom/NavigatorHost
                clipboard $ .-clipboard navigator
                promise $ .write-text clipboard x
                handled $ .then-value promise $ fn (_)
                  hint-fn $ Fn Dynamic $ -> Unit
                  println |Copied.
                  , &unit
              .catch-error handled $ fn (error)
                hint-fn $ Fn Dynamic $ -> Unit
                js/console.error "|Failed to copy:" error
                , &unit
              , &unit
          :examples $ []
          :schema $ quote $ Fn String (-> Unit) (:features :io :js-ffi)
        'do-copy-logics! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn do-copy-logics! (d! x message)
            let
                navigator $ unsafe-coerce js/navigator 'app.util.dom/NavigatorHost
                clipboard $ .-clipboard navigator
                promise $ .write-text clipboard x
                handled $ .then-value promise $ fn (_)
                  hint-fn $ Fn Dynamic $ -> Unit
                  d! $ :: :notify/push-message $ [] :info message
                  , &unit
              .catch-error handled $ fn (error)
                hint-fn $ Fn Dynamic $ -> Unit
                js/console.error "|Failed to copy:" error
                d! $ :: :notify/push-message $ [] :error (str "|Failed to copy! " error)
                , &unit
              , &unit
          :examples $ []
          :schema $ quote $ Fn
            Fn *dispatch-op $ -> Unit
            , String String (-> Unit) (:features :js-ffi)
        'focus! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn focus! ()
            js-ffi.browser/request-animation-frame! $ fn (timestamp)
              match (js-ffi.browser/query-selector |.cirru-focused)
                (:some target) (js-ffi.browser/element-focus! target)
                (:none) (println "|[Editor] .cirru-focused not found")
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi)
        'focus-search! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn focus-search! ()
            js/setTimeout
              fn () $ match (js-ffi.browser/query-selector |.search-input)
                (:some target) (js-ffi.browser/element-focus! target)
                (:none) &unit
              , 200
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'prevent-default! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn prevent-default! (raw-event)
            let
                event $ unsafe-coerce raw-event 'app.util.dom/EventHost
              .prevent-default! event
              , &unit
          :examples $ []
          :schema $ quote $ Fn Dynamic (-> Unit) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util.dom
          :require
            respo.core :refer $ style
            respo.render.html :refer $ style->html
    'app.util.env $ %{} 'FileEntry
      :defs $ {}
        'check-version! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn check-version! ()
            let
                directory $ path/dirname $ url/fileURLToPath js/import.meta.url
                pkg $ js/JSON.parse $ fs/readFileSync (path/join directory |../package.json) |utf8
                version $ js-ffi.contract/expect-string |package.version $ js-ffi.contract/object-field |package pkg |version
                name $ js-ffi.contract/expect-string |package.name $ js-ffi.contract/object-field |package pkg |name
                color $ unsafe-coerce chalk 'app.server/ChalkHost
                promise $ unsafe-coerce (latest-version name) 'js-ffi.shared/PromiseHost
                requested $ .then! promise $ fn (raw)
                  hint-fn $ Fn (JsNullish JsObject) (-> Unit)
                  let
                      current $ js-ffi.contract/expect-string |latest-version raw
                    println $ if (= version current) (str "|Running latest version " version)
                      .yellow color $ str "|Update is available tagged " current "|, current one is " version
                  , &unit
              .catch! requested $ fn (error)
                hint-fn $ Fn (JsNullish JsObject) (-> Unit)
                let
                    detail $ js-ffi.shared/normalize-error error
                  eprintln $ .yellow color $ str "|Failed to request version: " (:message detail)
                , &unit
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :io :js-ffi)
        'get-cli-configs! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-cli-configs! ()
            {} $ :op $ node/env-or |op |
          :examples $ []
          :schema $ quote $ Fn
            -> $ Map Tag Dynamic
        'pick-http-port! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn pick-http-port! (port next-fn)
            port-taken? port $ fn (err taken?)
              if (err .some?)
                raise $ :message $ err .unwrap
                if taken?
                  do
                    println $ str |port: port |in-use
                    pick-http-port! (inc port) next-fn
                  next-fn port
              , &unit
          :examples $ []
          :schema $ quote $ Fn Number
            Fn Number $ -> Unit
            -> app.util.detect/ServerHost
            :features :io :js-ffi
        'pick-port! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn pick-port! (port next-fn)
            port-taken? port $ fn (err taken?)
              if (err .some?)
                raise $ :message $ err .unwrap
                if taken?
                  do
                    println $ str |port: port |in-use
                    pick-port! (inc port) next-fn
                  do
                    println $ str |port: port |ok-edit-on: $ str |http://editor.calcit-lang.org?port= port
                    next-fn port
              , &unit
          :examples $ []
          :schema $ quote $ Fn Number
            Fn Number $ -> Unit
            -> app.util.detect/ServerHost
            :features :io :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util.env
          :require (|chalk :default chalk)
            app.util.detect :refer $ port-taken?
            |latest-version :default latest-version
            |path :as path
            |url :as url
            |fs :as fs
            js-ffi.node :as node
    'app.util.list $ %{} 'FileEntry
      :defs $ {}
        'cirru-form? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn cirru-form? (x)
            if (string? x) true $ if (list? x) (every? x cirru-form?) false
          :examples $ []
          :schema $ quote $ Fn Input (-> Bool) (:generics Input)
        'compare-entry $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn compare-entry (new-x old-x)
            match new-x
              (:none)
                match old-x
                  (:none) :same
                  (:some _) :remove
              (:some new-value)
                match old-x
                  (:none) :add
                  (:some old-value)
                    if (= old-value new-value) :same :changed
          :examples $ []
          :schema $ quote $ Fn (Option T) (Option T) (-> Tag) (:generics T)
        'dissoc-idx $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dissoc-idx (xs idx)
            if
              or (< idx 0)
                > idx $ dec $ count xs
              raise "|Index out of bound!"
            cond
                = 0 idx
                slice xs 1
              (= idx (dec (count xs)))
                butlast xs
              true $ concat (take xs idx)
                drop xs $ inc idx
          :examples $ []
          :schema $ quote $ Fn (List T) Number
            -> $ List T
            :generics T
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util.list
    'app.util.shortcuts $ %{} 'FileEntry
      :defs $ {}
        'on-paste! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-paste! (d!)
            let
                navigator $ unsafe-coerce js/navigator 'app.util.dom/NavigatorHost
                clipboard $ .-clipboard navigator
                promise $ .read-text clipboard
                handled $ .then-text promise $ fn (text)
                  hint-fn $ Fn String $ -> Unit
                  println "|read from text..."
                  let
                      cirru-code $ parse-cirru-list text
                    match (first cirru-code)
                      (:some syntax)
                        d! $ :: :writer/paste $ normalize-cirru syntax
                      (:none)
                        d! $ :: :notify/push-message $ [] :error "|Not valid code"
                  , &unit
              .catch-error handled $ fn (error)
                hint-fn $ Fn Dynamic $ -> Unit
                js/console.error "|Not able to read from paste:" error
                d! $ :: :notify/push-message $ [] :error "|Failed to paste!"
                , &unit
              , &unit
          :examples $ []
          :schema $ quote $ Fn
            Fn *dispatch-op $ -> Unit
            -> Unit
            :features :io :js-ffi
        'on-window-keydown $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-window-keydown (event dispatch! router)
            if (non-nil? router)
              let
                  keyboard $ js-ffi.browser/keyboard-event-host event
                  meta? $ or (.-meta-key? keyboard) (.-ctrl-key? keyboard)
                  shift? $ .-shift-key? keyboard
                  code $ .-key-code keyboard
                cond
                    and meta? $ or (= code keycode/p) (= code keycode/o)
                    do
                      dispatch! $ app.updater.router/route-op $ app.updater.router/Route :search
                      focus-search!
                      .prevent-default! keyboard
                  (and meta? (= code keycode/e))
                    dispatch! $ :: :writer/edit-ns
                  (and meta? (not shift?) (= code keycode/j))
                    do (.prevent-default! keyboard)
                      dispatch! $ :: :writer/move-next
                  (and meta? (not shift?) (= code keycode/i))
                    dispatch! $ :: :writer/move-previous
                  (and meta? (= code keycode/k))
                    dispatch! $ :: :writer/finish
                  (and meta? (= code keycode/s))
                    do (.prevent-default! keyboard)
                      dispatch! $ :: :effect/save-files
                      dispatch! $ :: :analyze/refresh-usages-dict
                  (and meta? shift? (= code keycode/f))
                    dispatch! $ app.updater.router/route-op $ app.updater.router/Route :files
                  (and meta? (not shift?) (= code keycode/period))
                    dispatch! $ :: :writer/picker-mode
                  true nil
            , &unit
          :examples $ []
          :schema $ quote $ Fn Dynamic
            Fn *dispatch-op $ -> Unit
            , Dynamic (-> Unit) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util.shortcuts
          :require (app.keycode :as keycode)
            app.util.dom :refer $ focus-search!
            app.util :refer $ normalize-cirru
    'app.util.stack $ %{} 'FileEntry
      :defs $ {}
        '=bookmark? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn =bookmark? (a b)
            match a
              (:def a-ns a-def a-f)
                match b
                  (:def b-ns b-def b-f)
                    and (= a-ns b-ns) (= a-def b-def)
                  (:ns b-ns b-f) false
              (:ns a-ns a-f)
                match b
                  (:def b-ns b-def b-f) false
                  (:ns b-ns b-f) (= a-ns b-ns)
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark app.bookmark/%bookmark (-> Bool)
        'index-of-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn index-of-bookmark (stack bookmark idx)
            if (empty? stack) -1 $ let
                first-bookmark $ assert-type
                  .unwrap $ first stack
                  , 'app.bookmark/%bookmark
              if (=bookmark? bookmark first-bookmark) idx $ recur (rest stack) bookmark $ inc idx
          :examples $ []
          :schema $ quote $ Fn (List app.bookmark/%bookmark) app.bookmark/%bookmark Number (-> Number)
        'push-bookmark $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn push-bookmark (bookmark forced?)
            fn (writer)
              hint-fn $ Fn (Option Dynamic)
                -> $ Map Tag Dynamic
              let
                  writer-fields $ decode-map-as
                    .unwrap-or writer $ {}
                    Map Tag Dynamic
                let
                    pointer $ .unwrap $ get writer-fields :pointer
                    stack $ .unwrap $ get writer-fields :stack
                  let
                      pointer $ decode-map-as pointer Number
                    let
                        stack $ app.bookmark/read-bookmarks stack
                      let
                          idx $ index-of-bookmark stack bookmark 0
                        if
                          or forced? $ < idx 0
                          -> writer-fields
                            assoc :stack $ cond
                                empty? stack
                                [] bookmark
                              (= pointer (dec (count stack)))
                                conj stack bookmark
                              (=bookmark? bookmark (.unwrap (get stack (inc pointer))))
                                , stack
                              true $ concat
                                take stack $ inc pointer
                                [] bookmark
                                drop stack $ inc pointer
                            assoc :pointer $ if (empty? stack) 0 $ inc pointer
                          -> writer-fields $ assoc :pointer idx
          :examples $ []
          :schema $ quote $ Fn app.bookmark/%bookmark Bool
            -> $ Fn (Option Dynamic)
              -> $ Map Tag Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.util.stack
