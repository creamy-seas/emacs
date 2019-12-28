function OrgNode(_div, _heading, _link, _depth, _parent, _base_id, _toc_anchor) {
    var t = this;
    t.DIV = _div, t.BASE_ID = _base_id, t.IDX = -1, t.HEADING = _heading, t.L = _link, t.HAS_HIGHLIGHT = !1, t.PARENT = _parent, t.DIRTY = !1, t.STATE = OrgNode.STATE_FOLDED, t.TOC = _toc_anchor, t.DEPTH = _depth, t.FOLDER = null, t.CHILDREN = new Array, t.NAV = "", t.BUTTONS = null, null != t.PARENT && (t.PARENT.addChild(this), t.hide());
    var folder = document.getElementById("text-" + t.BASE_ID);
    if (null == folder && _base_id) {
        var fid = _base_id.substring(4);
        folder = document.getElementById("text-" + fid)
    }
    null != folder && (t.FOLDER = folder), t.isTargetFor = new Object, t.isTargetFor["#" + t.BASE_ID] = 2, OrgNode.findTargetsIn(t.isTargetFor, t.HEADING, 1), OrgNode.findTargetsIn(t.isTargetFor, t.FOLDER, 3)
}

function OrgHtmlManagerKeyEvent(e) {
    var c;
    if (e || (e = window.event), e.which ? c = e.which : e.keyCode && (c = e.keyCode), !e.ctrlKey) {
        var s = String.fromCharCode(c);
        org_html_manager.CONSOLE_INPUT.value = e.shiftKey ? org_html_manager.CONSOLE_INPUT.value + s : org_html_manager.CONSOLE_INPUT.value + s.toLowerCase(), org_html_manager.getKey()
    }
}

function OrgHtmlManagerLoadCheck() {
    org_html_manager.init()
}
OrgNode.STATE_FOLDED = 0, OrgNode.STATE_HEADLINES = 1, OrgNode.STATE_UNFOLDED = 2, OrgNode.findTargetsIn = function(safe, container, priority) {
    if (container) {
        var a = container.getElementsByTagName("a");
        if (a)
            for (var i = 0; i < a.length; ++i) {
                var n = a[i].getAttribute("id");
                n ? safe["#" + n] = priority : (n = a[i].getAttribute("name"), n && (safe["#" + n] = priority))
            }
    }
}, OrgNode.hideElement = function(e) {
    e && e.style && (e.style.display = "none", e.style.visibility = "hidden")
}, OrgNode.showElement = function(e) {
    e && e.style && (e.style.display = "block", e.style.visibility = "visible")
}, OrgNode.unhideElement = function(e) {
    e.style.display = "", e.style.visibility = ""
}, OrgNode.isHidden = function(e) {
    return "none" == e.style.display || "hidden" == e.style.visibility ? !0 : !1
}, OrgNode.toggleElement = function(e) {
    "none" == e.style.display ? (e.style.display = "block", e.style.visibility = "visible") : (e.style.display = "none", e.style.visibility = "hidden")
}, OrgNode.textNodeToIdx = function(dom, org) {
    for (; 1 != dom.nodeType || -1 == dom.attributes.id.value.indexOf("outline-container-");) dom = dom.parentNode;
    var base_id = dom.attributes.id.value.substr(18);
    return OrgNode.idxForBaseId(base_id, org)
}, OrgNode.idxForBaseId = function(base, org) {
    if (org.BASE_ID == base) return org;
    for (var i = 0; i < org.CHILDREN.length; ++i) {
        var o = OrgNode.idxForBaseId(idx, org.CHILDREN[i]);
        if (null != o) return o
    }
    return null
}, OrgNode.prototype.addChild = function(child) {
    return this.CHILDREN.push(child), this.PARENT
}, OrgNode.prototype.hide = function() {
    OrgNode.hideElement(this.DIV), this.PARENT && this.PARENT.hide()
}, OrgNode.prototype.show = function() {
    OrgNode.showElement(this.DIV), this.DEPTH > 2 && this.PARENT.show()
}, OrgNode.prototype.showAllChildren = function() {
    for (var i = 0; i < this.CHILDREN.length; ++i) this.CHILDREN[i].showAllChildren();
    this.show()
}, OrgNode.prototype.hideAllChildren = function() {
    for (var i = 0; i < this.CHILDREN.length; ++i) this.CHILDREN[i].hideAllChildren();
    this.hide()
}, OrgNode.prototype.setLinkClass = function(on) {
    this.TOC && (this.TOC.className = on ? "current" : "visited_after_load")
}, OrgNode.prototype.fold = function(hide_folder) {
    if (this.PARENT && (this.PARENT.DIRTY = !0), this.DIRTY && (this.DIRTY = !1, this.STATE = OrgNode.STATE_UNFOLDED), null != this.FOLDER)
        if (this.STATE == OrgNode.STATE_FOLDED)
            if (this.CHILDREN.length) {
                this.STATE = OrgNode.STATE_HEADLINES, OrgNode.hideElement(this.FOLDER);
                for (var i = 0; i < this.CHILDREN.length; ++i) this.CHILDREN[i].setState(OrgNode.STATE_HEADLINES)
            } else hide_folder || (this.STATE = OrgNode.STATE_UNFOLDED, OrgNode.showElement(this.FOLDER));
    else if (this.STATE == OrgNode.STATE_HEADLINES) {
        this.STATE = OrgNode.STATE_UNFOLDED, OrgNode.showElement(this.FOLDER);
        for (var i = 0; i < this.CHILDREN.length; ++i) this.CHILDREN[i].setState(OrgNode.STATE_UNFOLDED)
    } else {
        this.STATE = OrgNode.STATE_FOLDED, OrgNode.hideElement(this.FOLDER);
        for (var i = 0; i < this.CHILDREN.length; ++i) this.CHILDREN[i].setState(OrgNode.STATE_FOLDED)
    }
}, OrgNode.prototype.setState = function(state) {
    for (var t = this, i = 0; i < t.CHILDREN.length; ++i) t.CHILDREN[i].setState(state);
    switch (state) {
        case OrgNode.STATE_FOLDED:
            OrgNode.hideElement(t.FOLDER), OrgNode.hideElement(t.DIV);
            break;
        case OrgNode.STATE_HEADLINES:
            OrgNode.hideElement(t.FOLDER), OrgNode.showElement(t.DIV);
            break;
        default:
            OrgNode.showElement(t.FOLDER), OrgNode.showElement(t.DIV)
    }
    t.STATE = state
};
var org_html_manager = {
    MOUSE_HINT: 0,
    BODY: null,
    PLAIN_VIEW: 0,
    CONTENT_VIEW: 1,
    ALL_VIEW: 2,
    INFO_VIEW: 3,
    SLIDE_VIEW: 4,
    VIEW: this.CONTENT_VIEW,
    LOCAL_TOC: !1,
    LINK_HOME: 0,
    LINK_UP: 0,
    LINKS: "",
    RUN_MAX: 1200,
    RUN_INTERVAL: 100,
    HIDE_TOC: !1,
    TOC_DEPTH: 0,
    STARTUP_MESSAGE: 0,
    POSTAMBLE: null,
    BASE_URL: document.URL,
    Q_PARAM: "",
    ROOT: null,
    NODE: null,
    TITLE: null,
    INNER_TITLE: !1,
    LOAD_CHECK: null,
    WINDOW: null,
    SECS: new Array,
    REGEX: /(#)(.*$)/,
    SID_REGEX: /(^#)(sec-\d+([._]\d+)*$)/,
    UNTAG_REGEX: /<[^>]+>/i,
    ORGTAG_REGEX: /^(.*)<span\s+class=[\'\"]tag[\'\"]>(<span[^>]+>[^<]+<\/span>)+<\/span>/i,
    TRIMMER: /^(\s*)([^\s].*)(\s*)$/,
    TOC: null,
    RUNS: 0,
    HISTORY: new Array(50),
    HIST_INDEX: 0,
    SKIP_HISTORY: !1,
    FIXED_TOC: !1,
    CONSOLE: null,
    CONSOLE_INPUT: null,
    CONSOLE_LABEL: null,
    CONSOLE_OFFSET: "50px",
    OCCUR: "",
    SEARCH_REGEX: "",
    SEARCH_HL_REGEX: new RegExp('(<span class="org-info-js_search-highlight">)([^<]*?)(</span>)', "gi"),
    MESSAGING: 0,
    MESSAGING_INPLACE: 1,
    MESSAGING_TOP: 2,
    HELPING: !1,
    READING: !1,
    READ_COMMAND: "",
    READ_COMMAND_NULL: "_0",
    READ_COMMAND_HTML_LINK: "_1",
    READ_COMMAND_ORG_LINK: "_2",
    READ_COMMAND_PLAIN_URL_LINK: "_03",
    LAST_VIEW_MODE: 0,
    TAB_INDEX: 1e3,
    SEARCH_HIGHLIGHT_ON: !1,
    TAGS: {},
    SORTED_TAGS: new Array,
    TAGS_INDEX: null,
    CLICK_TIMEOUT: null,
    SECNUM_MAP: {},
    TOC_LINK: null,
    HOOKS: {
        run_hooks: !1,
        onShowSection: [],
        onReady: []
    },
    setup: function() {
        var t = this;
        if (window.orgInfoHooks) {
            for (var i in orgInfoHooks) t.HOOKS[i] = orgInfoHooks[i];
            t.HOOKS.run_hooks = !1
        }
        if (location.search)
            for (var sets = location.search.substring(1).split("&"), i = 0; i < sets.length; ++i) {
                var pos = sets[i].indexOf("=");
                if (-1 != pos) {
                    var v = sets[i].substring(pos + 1),
                        k = sets[i].substring(0, pos);
                    switch (k) {
                        case "TOC":
                        case "TOC_DEPTH":
                        case "MOUSE_HINT":
                        case "HELP":
                        case "VIEW":
                        case "HIDE_TOC":
                        case "LOCAL_TOC":
                        case "OCCUR":
                            t.set(k, decodeURIComponent(v))
                    }
                }
            }
        t.VIEW = t.VIEW ? t.VIEW : t.PLAIN_VIEW, t.VIEW_BUTTONS = t.VIEW_BUTTONS && "0" != t.VIEW_BUTTONS ? !0 : !1, t.STARTUP_MESSAGE = t.STARTUP_MESSAGE && "0" != t.STARTUP_MESSAGE ? !0 : !1, t.LOCAL_TOC = t.LOCAL_TOC && "0" != t.LOCAL_TOC ? t.LOCAL_TOC : !1, t.HIDE_TOC = t.TOC && "0" != t.TOC ? !1 : !0, t.INNER_TITLE = t.INNER_TITLE && "title_above" != t.INNER_TITLE ? !1 : !0, t.FIXED_TOC && "0" != t.FIXED_TOC ? (t.FIXED_TOC = !0, t.HIDE_TOC = !1) : t.FIXED_TOC = !1, t.LINKS += (t.LINK_UP && t.LINK_UP != document.URL ? '<a href="' + t.LINK_UP + '">Up</a> / ' : "") + (t.LINK_HOME && t.LINK_HOME != document.URL ? '<a href="' + t.LINK_HOME + '">HOME</a> / ' : "") + '<a href="javascript:org_html_manager.showHelp();">HELP</a> / ', t.LOAD_CHECK = window.setTimeout("OrgHtmlManagerLoadCheck()", 50)
    },
    trim: function(s) {
        return this.TRIMMER.exec(s), RegExp.$2
    },
    removeTags: function(s) {
        if (s)
            for (; s.match(this.UNTAG_REGEX);) s = s.substr(0, s.indexOf("<")) + s.substr(s.indexOf(">") + 1);
        return s
    },
    removeOrgTags: function(s) {
        if (s.match(this.ORGTAG_REGEX)) {
            var matches = this.ORGTAG_REGEX.exec(s);
            return matches[1]
        }
        return s
    },
    init: function() {
        var t = this;
        if (t.RUNS++, t.BODY = document.getElementById("content"), null == t.BODY) {
            if (5 > t.RUNS) return t.LOAD_CHECK = window.setTimeout("OrgHtmlManagerLoadCheck()", t.RUN_INTERVAL), void 0;
            t.BODY = document.getElementsByTagName("body")[0]
        }
        if (t.PREA = document.getElementById("preamble"), t.POST = document.getElementById("postamble"), null == t.PREA && (t.PREA = t.BODY), null == t.POST && (t.POST = t.BODY), t.WINDOW || (t.WINDOW = document.createElement("div"), t.WINDOW.style.marginBottom = "40px", t.WINDOW.id = "org-info-js-window"), document.getElementById("table-of-contents"), !t.initFromTOC() && t.RUNS < t.RUN_MAX) return t.LOAD_CHECK = window.setTimeout("OrgHtmlManagerLoadCheck()", t.RUN_INTERVAL), void 0;
        var start_section = 0,
            start_section_explicit = !1;
        if ("" != location.hash) {
            t.BASE_URL = t.BASE_URL.substring(0, t.BASE_URL.indexOf("#"));
            for (var i = 0; i < t.SECS.length; ++i)
                if (t.SECS[i].isTargetFor[location.hash]) {
                    start_section = i, start_section_explicit = 1;
                    break
                }
        }
        "" != location.search && (t.Q_PARAM = t.BASE_URL.substring(t.BASE_URL.indexOf("?")), t.BASE_URL = t.BASE_URL.substring(0, t.BASE_URL.indexOf("?"))), t.convertLinks();
        var pa = document.getElementById("postamble");
        pa && (t.POSTAMBLE = pa);
        var b = t.BODY,
            n = b.firstChild;
        if (3 == n.nodeType) {
            var neu = n.cloneNode(!0),
                p = document.createElement("p");
            p.id = "text-before-first-headline", p.appendChild(neu), b.replaceChild(p, n)
        }
        if (t.CONSOLE = document.createElement("div"), t.CONSOLE.innerHTML = '<form action="" style="margin:0px;padding:0px;" onsubmit="org_html_manager.evalReadCommand(); return false;"><table id="org-info-js_console" style="width:100%;margin:0px 0px 0px 0px;border-style:none;" cellpadding="0" cellspacing="0" summary="minibuffer"><tbody><tr><td id="org-info-js_console-icon" style="padding:0px 0px 0px 0px;border-style:none;">&#160;</td><td style="width:100%;vertical-align:middle;padding:0px 0px 0px 0px;border-style:none;"><table style="width:100%;margin:0px 0px 0px 0px;border-style:none;" cellpadding="0" cellspacing="2"><tbody><tr><td id="org-info-js_console-label" style="white-space:nowrap;padding:0px 0px 0px 0px;border-style:none;"></td></tr><tr><td style="width:100%;vertical-align:middle;padding:0px 0px 0px 0px;border-style:none;"><input type="text" id="org-info-js_console-input" onkeydown="org_html_manager.getKey();" onclick="this.select();" maxlength="150" style="width:100%;padding:0px;margin:0px 0px 0px 0px;border-style:none;" value=""/></td></tr></tbody></table></td><td style="padding:0px 0px 0px 0px;border-style:none;">&#160;</td></tr></tbody></table></form>', t.CONSOLE.style.position = "relative", t.CONSOLE.style.marginTop = "-" + t.CONSOLE_OFFSET, t.CONSOLE.style.top = "-" + t.CONSOLE_OFFSET, t.CONSOLE.style.left = "0px", t.CONSOLE.style.width = "100%", t.CONSOLE.style.height = "40px", t.CONSOLE.style.overflow = "hidden", t.CONSOLE.style.verticalAlign = "middle", t.CONSOLE.style.zIndex = "9", t.CONSOLE.style.border = "1px solid #cccccc", t.CONSOLE.id = "org-info-js_console-container", t.BODY.insertBefore(t.CONSOLE, t.BODY.firstChild), t.MESSAGING = !1, t.CONSOLE_LABEL = document.getElementById("org-info-js_console-label"), t.CONSOLE_INPUT = document.getElementById("org-info-js_console-input"), document.onkeypress = OrgHtmlManagerKeyEvent, t.VIEW == t.INFO_VIEW) t.infoView(start_section), t.showSection(start_section), window.setTimeout(function() {
            window.scrollTo(0, 0)
        }, 100);
        else if (t.VIEW == t.SLIDE_VIEW) t.slideView(start_section), t.showSection(start_section);
        else {
            var v = t.VIEW;
            t.plainView(start_section, 1), t.ROOT.DIRTY = !0, t.ROOT_STATE = OrgNode.STATE_UNFOLDED, t.toggleGlobaly(), v > t.PLAIN_VIEW && t.toggleGlobaly(), v == t.ALL_VIEW && t.toggleGlobaly(), start_section_explicit && t.showSection(start_section)
        }
        "" != t.OCCUR && (t.CONSOLE_INPUT.value = t.OCCUR, t.READ_COMMAND = "o", t.evalReadCommand()), t.STARTUP_MESSAGE && t.warn("This page uses org-info.js. Press '?' for more information.", !0), t.HOOKS.run_hooks = !0, t.runHooks("onReady", this.NODE)
    },
    initFromTOC: function() {
        var t = this;
        if (1 == t.RUNS || !t.ROOT) {
            var toc = document.getElementById("table-of-contents");
            if (null == toc) return !1;
            var heading = null,
                i = 0;
            for (i; null == heading && 7 > i; ++i) heading = toc.getElementsByTagName("h" + i)[0];
            heading.onclick = function() {
                org_html_manager.fold(0)
            }, heading.style.cursor = "pointer", t.MOUSE_HINT && (heading.onmouseover = function() {
                org_html_manager.highlightHeadline(0)
            }, heading.onmouseout = function() {
                org_html_manager.unhighlightHeadline(0)
            }), t.FIXED_TOC ? (heading.setAttribute("onclick", "org_html_manager.toggleGlobaly();"), t.ROOT = new OrgNode(null, t.BODY.getElementsByTagName("h1")[0], "javascript:org_html_manager.navigateTo(0);", 0, null), t.TOC = new OrgNode(toc, heading, "javascript:org_html_manager.navigateTo(0);", i, null), t.NODE = t.ROOT) : (t.ROOT = new OrgNode(null, t.BODY.getElementsByTagName("h1")[0], "javascript:org_html_manager.navigateTo(0);", 0, null), t.HIDE_TOC ? (t.TOC = new OrgNode(toc, "", "javascript:org_html_manager.navigateTo(0);", i, null), t.NODE = t.ROOT, OrgNode.hideElement(toc)) : (t.TOC = new OrgNode(toc, heading, "javascript:org_html_manager.navigateTo(0);", i, t.ROOT), t.TOC.IDX = 0, t.NODE = t.TOC, t.SECS.push(t.TOC))), t.TOC && (t.TOC.FOLDER = document.getElementById("text-table-of-contents"))
        }
        var theIndex = t.TOC.FOLDER.getElementsByTagName("ul")[0];
        if (!t.ulToOutlines(theIndex)) return !1;
        var fn = document.getElementById("footnotes");
        if (fn) {
            for (var fnheading = null, c = fn.childNodes, i = 0; i < c.length; ++i)
                if ("footnotes" == c[i].className) {
                    fnheading = c[i];
                    break
                }
            var sec = t.SECS.length;
            fnheading.onclick = function() {
                org_html_manager.fold("" + sec)
            }, fnheading.style.cursor = "pointer", t.MOUSE_HINT && (fnheading.onmouseover = function() {
                org_html_manager.highlightHeadline("" + sec)
            }, fnheading.onmouseout = function() {
                org_html_manager.unhighlightHeadline("" + sec)
            });
            var link = "javascript:org_html_manager.navigateTo(" + sec + ")",
                fnsec = new OrgNode(fn, fnheading, link, 1, t.ROOT, "footnotes");
            t.SECS.push(fnsec)
        }
        return t.TOC_DEPTH && t.cutToc(theIndex, 1), t.TITLE = document.getElementsByClassName("title")[0], t.INNER_TITLE && !t.FIXED_TOC && t.VIEW != t.SLIDE_VIEW && (t.INNER_TITLE = t.TITLE.cloneNode(!0), t.SECS[0].DIV.insertBefore(t.INNER_TITLE, t.SECS[0].DIV.firstChild), OrgNode.hideElement(t.TITLE)), t.build(), t.NODE = t.SECS[0], t.BODY.insertBefore(t.WINDOW, t.NODE.DIV), !0
    },
    ulToOutlines: function(ul) {
        if (ul.hasChildNodes() && !ul.scanned_for_org) {
            for (var i = 0; i < ul.childNodes.length; ++i)
                if (0 == this.liToOutlines(ul.childNodes[i])) return !1;
            ul.scanned_for_org = 1
        }
        return !0
    },
    liToOutlines: function(li) {
        if (!li.scanned_for_org) {
            for (var i = 0; i < li.childNodes.length; ++i) {
                var c = li.childNodes[i];
                switch (c.nodeName) {
                    case "A":
                        var newHref = this.mkNodeFromHref(c);
                        if (0 == newHref) return !1;
                        c.href = newHref, c.tabIndex = this.TAB_INDEX, c.onfocus = function() {
                            org_html_manager.TOC_LINK = this
                        }, null == this.TOC_LINK && (this.TOC_LINK = c), this.TAB_INDEX++;
                        break;
                    case "UL":
                        return this.ulToOutlines(c)
                }
            }
            li.scanned_for_org = 1
        }
        return !0
    },
    cutToc: function(ul, cur_depth) {
        if (cur_depth++, ul.hasChildNodes())
            for (var i = 0; i < ul.childNodes.length; ++i)
                for (var li = ul.childNodes[i], j = 0; j < li.childNodes.length; ++j) {
                    var c = li.childNodes[j];
                    "UL" == c.nodeName && (cur_depth > this.TOC_DEPTH ? li.removeChild(c) : this.cutToc(c, cur_depth))
                }
    },
    mkNodeFromHref: function(anchor) {
        if (s = anchor.href, s.match(this.REGEX)) {
            var matches = this.REGEX.exec(s),
                id = matches[2],
                h = document.getElementById(id);
            if (null == h) return !1;
            var div = h.parentNode,
                sec = this.SECS.length,
                depth = div.className.substr(8);
            h.onclick = function() {
                org_html_manager.fold("" + sec)
            }, h.style.cursor = "pointer", this.MOUSE_HINT && (h.onmouseover = function() {
                org_html_manager.highlightHeadline("" + sec)
            }, h.onmouseout = function() {
                org_html_manager.unhighlightHeadline("" + sec)
            });
            var link = "javascript:org_html_manager.navigateTo(" + sec + ")";
            if (depth > this.NODE.DEPTH) this.NODE = new OrgNode(div, h, link, depth, this.NODE, id, anchor);
            else if (2 == depth) this.NODE = new OrgNode(div, h, link, depth, this.ROOT, id, anchor);
            else {
                for (var p = this.NODE; p.DEPTH > depth;) p = p.PARENT;
                this.NODE = new OrgNode(div, h, link, depth, p.PARENT, id, anchor)
            }
            this.SECS.push(this.NODE);
            var spans = h.getElementsByTagName("span");
            if (spans)
                for (var i = 0; i < spans.length; ++i)
                    if ("tag" == spans[i].className)
                        for (var tags = spans[i].innerHTML.split("&nbsp;"), j = 0; j < tags.length; ++j) {
                            var t = this.removeTags(tags[j]);
                            this.TAGS[t] || (this.TAGS[t] = new Array, this.SORTED_TAGS.push(t)), this.TAGS[t].push(sec)
                        } else spans[i].className.match(this.SECNUM_REGEX) && (this.SECNUM_MAP[this.trim(spans[i].innerHTML)] = this.NODE);
            return this.NODE.hide(), link
        }
        return s
    },
    build: function() {
        for (var index_name = this.TITLE.innerHTML, i = 0; i < this.SECS.length; ++i) {
            this.SECS[i].IDX = i;
            var html = '<table class="org-info-js_info-navigation" width="100%" border="0" style="border-bottom:1px solid black;"><tr><td colspan="3" style="text-align:left;border-style:none;vertical-align:bottom;"><span style="float:left;display:inline;text-align:left;">Top: <a accesskey="t" href="javascript:org_html_manager.navigateTo(0);">' + index_name + "</a></span>" + '<span style="float:right;display:inline;text-align:right;font-size:70%;">' + this.LINKS + '<a accesskey="m" href="javascript:org_html_manager.toggleView(' + i + ');">toggle view</a></span>' + '</td></tr><tr><td style="text-align:left;border-style:none;vertical-align:bottom;width:22%">';
            if (html += i > 0 ? '<a accesskey="p" href="' + this.SECS[i - 1].L + '" title="Go to: ' + this.removeTags(this.SECS[i - 1].HEADING.innerHTML) + '">Previous</a> | ' : "Previous | ", html += i < this.SECS.length - 1 ? '<a accesskey="n" href="' + this.SECS[i + 1].L + '" title="Go to: ' + this.removeTags(this.SECS[i + 1].HEADING.innerHTML) + '">Next</a>' : "Next", html += '</td><td style="text-align:center;vertical-align:bottom;border-style:none;width:56%;">', html += i > 0 && this.SECS[i].PARENT.PARENT ? '<a href="' + this.SECS[i].PARENT.L + '" title="Go to: ' + this.removeTags(this.SECS[i].PARENT.HEADING.innerHTML) + '">' + '<span style="font-variant:small-caps;font-style:italic;">' + this.SECS[i].PARENT.HEADING.innerHTML + "</span></a>" : '<span style="font-variant:small-caps;font-style:italic;">' + this.SECS[i].HEADING.innerHTML + "</span>", html += '</td><td style="text-align:right;vertical-align:bottom;border-style:none;width:22%">', html += i + 1 + "</td></tr></table>", this.SECS[i].BUTTONS = document.createElement("div"), this.SECS[i].BUTTONS.innerHTML = '<div class="org-info-js_header-navigation" style="display:inline;float:right;text-align:right;font-size:70%;font-weight:normal;">' + this.LINKS + '<a accesskey="m" href="javascript:org_html_manager.toggleView(' + i + ');">toggle view</a></div>', this.SECS[i].FOLDER ? this.SECS[i].DIV.insertBefore(this.SECS[i].BUTTONS, this.SECS[i].HEADING) : this.SECS[i].DIV.hasChildNodes() && this.SECS[i].DIV.insertBefore(this.SECS[i].BUTTONS, this.SECS[i].DIV.firstChild), this.VIEW_BUTTONS || OrgNode.hideElement(this.SECS[i].BUTTONS), this.SECS[i].NAV = html, 0 < this.SECS[i].CHILDREN.length && this.LOCAL_TOC) {
                var navi2 = document.createElement("div");
                navi2.className = "org-info-js_local-toc", html = "Contents:<br /><ul>";
                for (var k = 0; k < this.SECS[i].CHILDREN.length; ++k) html += '<li><a href="' + this.SECS[i].CHILDREN[k].L + '">' + this.removeTags(this.removeOrgTags(this.SECS[i].CHILDREN[k].HEADING.innerHTML)) + "</a></li>";
                html += "</ul>", navi2.innerHTML = html, "above" == this.LOCAL_TOC ? this.SECS[i].FOLDER ? this.SECS[i].FOLDER.insertBefore(navi2, this.SECS[i].FOLDER.firstChild) : this.SECS[i].DIV.insertBefore(navi2, this.SECS[i].DIV.getElementsByTagName("h" + this.SECS[i].DEPTH)[0].nextSibling) : this.SECS[i].FOLDER ? this.SECS[i].FOLDER.appendChild(navi2) : this.SECS[i].DIV.appendChild(navi2)
            }
        }
        this.SORTED_TAGS.sort()
    },
    set: function(eval_key, eval_val) {
        if ("VIEW" == eval_key) {
            var pos = eval_val.indexOf("_"); - 1 != pos && (this.INNER_TITLE = eval_val.substr(pos + 1), eval_val = eval_val.substr(0, pos));
            var overview = this.PLAIN_VIEW,
                content = this.CONTENT_VIEW,
                showall = this.ALL_VIEW,
                info = this.INFO_VIEW,
                info_title_above = this.INFO_VIEW,
                slide = this.SLIDE_VIEW;
            eval("this." + eval_key + "=" + eval_val + ";")
        } else "HELP" == eval_key ? eval("this.STARTUP_MESSAGE=" + eval_val + ";") : eval_val ? eval("this." + eval_key + "='" + eval_val + "';") : eval("this." + eval_key + "=0;")
    },
    convertLinks: function() {
        this.HIDE_TOC ? 0 : 1;
        var j;
        this.SECS.length - 1;
        var links = document.getElementsByTagName("a");
        for (j = 0; j < links.length; ++j)
            for (var href = links[j].href.replace(this.BASE_URL, ""), k = 0; k < this.SECS.length; ++k)
                if (this.SECS[k].isTargetFor[href]) {
                    links[j].href = "javascript:org_html_manager.navigateTo(" + k + ")";
                    break
                }
    },
    showSection: function(sec) {
        var t = this,
            section = parseInt(sec),
            last_node = t.NODE,
            hook = "onShowSection";
        if (t.HIDE_TOC && t.NODE == t.TOC && !t.FIXED_TOC && (OrgNode.hideElement(t.TOC.DIV), t.PLAIN_VIEW == t.VIEW)) {
            t.ROOT.showAllChildren();
            for (var i = 0; i < t.ROOT.CHILDREN.length; ++i) t.ROOT.CHILDREN[i].STATE = OrgNode.STATE_UNFOLDED, t.ROOT.CHILDREN[i].fold()
        }
        if ("?/toc/?" != sec && null != t.TOC_LINK && t.TOC_LINK.blur(), "?/toc/?" == sec || !isNaN(section) && t.SECS[section])
            if ("?/toc/?" == sec && t.HIDE_TOC) hook = "onShowToc", t.NODE = t.TOC, t.ROOT.hideAllChildren(), t.INFO_VIEW == t.VIEW ? t.WINDOW.innerHTML = t.NODE.DIV.innerHTML : t.NODE.setState(OrgNode.STATE_UNFOLDED), window.scrollTo(0, 0);
            else if (t.NODE = t.SECS[section], t.SLIDE_VIEW == t.VIEW || t.INFO_VIEW == t.VIEW) {
            OrgNode.hideElement(t.NODE.BUTTONS), t.NODE.setState(OrgNode.STATE_UNFOLDED);
            for (var i = 0; i < t.NODE.CHILDREN.length; ++i) t.NODE.CHILDREN[i].hide();
            t.WINDOW.innerHTML = t.SLIDE_VIEW == t.VIEW ? t.NODE.DIV.innerHTML : t.NODE.NAV + t.NODE.DIV.innerHTML, t.NODE.hide(), t.FIXED_TOC || OrgNode.hideElement(document.body), last_node.IDX != t.NODE.IDX && "?/toc/?" != sec && window.location.replace(t.BASE_URL + t.Q_PARAM + t.getDefaultTarget()), t.FIXED_TOC || OrgNode.showElement(document.body)
        } else t.VIEW_BUTTONS || OrgNode.hideElement(last_node.BUTTONS), OrgNode.showElement(t.NODE.BUTTONS), t.NODE.setState(OrgNode.UNFOLDED), t.NODE.show(), last_node.IDX != t.NODE.IDX && window.location.replace(t.BASE_URL + t.Q_PARAM + t.getDefaultTarget()), 0 == t.NODE.IDX ? window.scrollTo(0, 0) : t.NODE.DIV.scrollIntoView(!0);
        last_node.setLinkClass(), t.NODE.setLinkClass(!0), t.runHooks(hook, {
            last: last_node,
            current: t.NODE
        })
    },
    plainView: function(sec, skip_show_section) {
        var t = this;
        document.onclick = null, document.ondblclick = null, t.VIEW = t.PLAIN_VIEW, OrgNode.hideElement(t.WINDOW), t.INNER_TITLE && OrgNode.hideElement(t.INNER_TITLE), OrgNode.showElement(t.TITLE), t.WINDOW.firstChild && t.WINDOW.removeChild(t.WINDOW.firstChild), t.ROOT.showAllChildren();
        for (var i = 0; i < t.ROOT.CHILDREN.length; ++i) t.ROOT.CHILDREN[i].STATE = OrgNode.STATE_UNFOLDED, t.ROOT.CHILDREN[i].fold();
        skip_show_section || t.showSection(sec), t.POSTAMBLE && OrgNode.showElement(t.POSTAMBLE), 0 == t.NODE.IDX ? window.scrollTo(0, 0) : t.NODE.DIV.scrollIntoView(!0)
    },
    infoView: function(sec, skip_show_section) {
        var t = this;
        document.onclick = null, document.ondblclick = null, t.VIEW = t.INFO_VIEW, t.unhighlightHeadline(t.NODE.IDX), t.INNER_TITLE && !t.FIXED_TOC && (OrgNode.showElement(t.INNER_TITLE), OrgNode.hideElement(t.TITLE)), OrgNode.showElement(t.WINDOW), t.ROOT.hideAllChildren(), t.TOC && !t.FIXED_TOC && OrgNode.hideElement(t.TOC.DIV), t.POSTAMBLE && OrgNode.showElement(t.POSTAMBLE), skip_show_section || t.showSection(sec), window.scrollTo(0, 0)
    },
    slideView: function(sec, skip_show_section) {
        var t = this;
        t.VIEW = t.SLIDE_VIEW, t.unhighlightHeadline(t.NODE.IDX), OrgNode.hideElement(t.TITLE), t.INNER_TITLE && OrgNode.hideElement(t.INNER_TITLE), t.TOC && OrgNode.hideElement(t.TOC.DIV), OrgNode.showElement(t.TITLE), OrgNode.showElement(t.WINDOW), t.ROOT.hideAllChildren(), OrgNode.hideElement(t.TOC.DIV), t.POSTAMBLE && OrgNode.hideElement(t.POSTAMBLE), t.adjustSlide(sec), skip_show_section || t.showSection(sec)
    },
    adjustSlide: function(sec, show) {
        var nextForward = !0,
            nextBack = !0,
            next = !1;
        if (sec > this.NODE.IDX && (next = !0), null == show && (next = !0), next) {
            for (var n = this.SECS[sec].FOLDER.firstChild; null != n; n = n.nextSibling)
                if ("UL" == n.nodeName)
                    for (var lis = n.getElementsByTagName("li"), i = 1; i < lis.length; ++i) {
                        var l = lis[i];
                        OrgNode.hideElement(l), nextForward = !1
                    }
        } else
            for (var lists = this.WINDOW.getElementsByTagName("ul"), n = 0; n < lists.length; ++n)
                for (var lis = lists[n].getElementsByTagName("li"), i = 1; i < lis.length; ++i) {
                    var l = lis[i];
                    if (show > 0) {
                        if (OrgNode.isHidden(l)) {
                            OrgNode.unhideElement(l), i < lis.length - 1 && (nextForward = !1), i > 0 && (nextBack = !1);
                            break
                        }
                    } else if (!OrgNode.isHidden(l) && i > 1) {
                        nextBack = !1, OrgNode.hideElement(lis[i - 1]);
                        break
                    }
                }
        document.onclick = nextForward ? function() {
            org_html_manager.scheduleClick("org_html_manager.nextSection(org_html_manager.NODE.IDX + 1)")
        } : function() {
            org_html_manager.scheduleClick("org_html_manager.adjustSlide(org_html_manager.NODE.IDX, +1)")
        }, document.ondblclick = nextBack ? function() {
            org_html_manager.scheduleClick("org_html_manager.previousSection()")
        } : function() {
            org_html_manager.scheduleClick("org_html_manager.adjustSlide(" + this.NODE.IDX + ", -1)")
        }
    },
    toggleView: function(sec) {
        var t = this;
        t.Q_PARAM = "", t.removeWarning(), t.VIEW == t.INFO_VIEW ? t.plainView(sec) : t.infoView(sec)
    },
    fold: function(sec) {
        var t = this;
        t.removeWarning();
        var section = parseInt(sec);
        t.SECS[section].fold(), t.VIEW_BUTTONS || OrgNode.hideElement(t.NODE.BUTTONS), t.NODE = t.SECS[section], OrgNode.showElement(t.NODE.BUTTONS)
    },
    toggleGlobaly: function() {
        var t = this;
        if (t.ROOT.DIRTY && (t.ROOT.STATE = OrgNode.STATE_UNFOLDED), OrgNode.STATE_UNFOLDED == t.ROOT.STATE) {
            for (var i = 0; i < t.ROOT.CHILDREN.length; ++i) t.ROOT.CHILDREN[i].STATE = OrgNode.STATE_UNFOLDED, t.ROOT.CHILDREN[i].fold(!0);
            t.ROOT.STATE = OrgNode.STATE_UNFOLDED, t.ROOT.STATE = OrgNode.STATE_FOLDED
        } else if (OrgNode.STATE_FOLDED == t.ROOT.STATE) {
            for (var i = 0; i < t.ROOT.CHILDREN.length; ++i) t.ROOT.CHILDREN[i].fold(!0);
            t.ROOT.STATE = OrgNode.STATE_HEADLINES
        } else {
            for (var i = 0; i < t.ROOT.CHILDREN.length; ++i) t.ROOT.CHILDREN[i].fold();
            t.ROOT.STATE = OrgNode.STATE_UNFOLDED
        }
        t.ROOT.DIRTY = !1
    },
    executeClick: function(func) {
        var t = this;
        t.READING ? (t.endRead(), t.hideConsole()) : t.MESSAGING && t.removeWarning(), eval(func), null != t.CLICK_TIMEOUT && (t.CLICK_TIMEOUT = null)
    },
    scheduleClick: function(func, when) {
        null == when && (when = 250), null == this.CLICK_TIMEOUT ? this.CLICK_TIMEOUT = window.setTimeout("org_html_manager.executeClick(" + func + ")", when) : (window.clearTimeout(this.CLICK_TIMEOUT), this.CLICK_TIMEOUT = null)
    },
    nextSection: function() {
        var T = this,
            i = T.NODE.IDX + 1;
        i < T.SECS.length ? T.navigateTo(i) : T.warn("Already last section.")
    },
    previousSection: function() {
        var t = this,
            i = t.NODE.IDX;
        i > 0 ? t.navigateTo(i - 1) : t.warn("Already first section.")
    },
    navigateTo: function(sec) {
        var t = this;
        t.READING ? (t.endRead(), t.hideConsole()) : t.MESSAGING && t.removeWarning(), t.VIEW == t.SLIDE_VIEW && t.adjustSlide(sec), t.pushHistory(sec, t.NODE.IDX), t.showSection(sec)
    },
    pushHistory: function(command, undo) {
        var t = this;
        t.SKIP_HISTORY || (t.HISTORY[t.HIST_INDEX] = new Array(command, undo), t.HIST_INDEX = (t.HIST_INDEX + 1) % 50), t.SKIP_HISTORY = !1, t.CONSOLE_INPUT.value = ""
    },
    popHistory: function(foreward) {
        var t = this;
        if (foreward)
            if (t.HISTORY[t.HIST_INDEX]) {
                var s = parseInt(t.HISTORY[t.HIST_INDEX][0]);
                isNaN(s) && "?/toc/?" != t.HISTORY[t.HIST_INDEX][0] ? (t.SKIP_HISTORY = !0, t.CONSOLE_INPUT.value = t.HISTORY[t.HIST_INDEX][0], t.getKey()) : (t.showSection(t.HISTORY[t.HIST_INDEX][0]), t.CONSOLE_INPUT.value = ""), t.HIST_INDEX = (t.HIST_INDEX + 1) % 50, t.HBO = 0
            } else t.HFO && history.length ? history.forward() : (t.HFO = 1, t.warn("History: No where to foreward go from here. Any key and `B' to move to next file in history."));
        else if (t.HISTORY[t.HIST_INDEX - 1]) {
            t.HIST_INDEX = 0 == t.HIST_INDEX ? 49 : t.HIST_INDEX - 1;
            var s = parseInt(t.HISTORY[t.HIST_INDEX][1]);
            isNaN(s) && "?/toc/?" != t.HISTORY[t.HIST_INDEX][1] ? (t.SKIP_HISTORY = !0, t.CONSOLE_INPUT.value = t.HISTORY[t.HIST_INDEX][1], t.getKey()) : (t.showSection(t.HISTORY[t.HIST_INDEX][1]), t.CONSOLE_INPUT.value = ""), t.HFO = 0
        } else t.HBO && history.length ? history.back() : (t.HBO = 1, t.warn("History: No where to back go from here. Any key and `b' to move to previous file in history."))
    },
    warn: function(what, harmless, value) {
        var t = this;
        null == value && (value = ""), t.CONSOLE_INPUT.value = value, harmless || (t.CONSOLE_LABEL.style.color = "red"), t.CONSOLE_LABEL.innerHTML = "<span style='float:left;'>" + what + "</span>" + "<span style='float:right;color:#aaaaaa;font-weight:normal;'>(press any key to proceed)</span>", t.showConsole(), window.setTimeout(function() {
            org_html_manager.CONSOLE_INPUT.value = value
        }, 50)
    },
    startRead: function(command, label, value, shortcuts) {
        var t = this;
        null == value && (value = ""), null == shortcuts && (shortcuts = ""), t.READ_COMMAND = command, t.READING = !0, t.CONSOLE_LABEL.innerHTML = "<span style='float:left;'>" + label + "</span>" + "<span style='float:right;color:#aaaaaa;font-weight:normal;'>(" + shortcuts + "RET to close)</span>", t.showConsole(), document.onkeypress = null, t.CONSOLE_INPUT.focus(), t.CONSOLE_INPUT.onblur = function() {
            org_html_manager.CONSOLE_INPUT.focus()
        }, window.setTimeout(function() {
            org_html_manager.CONSOLE_INPUT.value = value
        }, 50)
    },
    endRead: function() {
        var t = this;
        t.READING = !1, t.READ_COMMAND = "", t.CONSOLE_INPUT.onblur = null, t.CONSOLE_INPUT.blur(), document.onkeypress = OrgHtmlManagerKeyEvent
    },
    removeWarning: function() {
        var t = this;
        t.CONSOLE_LABEL.style.color = "#333333", t.hideConsole()
    },
    showConsole: function() {
        var t = this;
        t.MESSAGING || (t.VIEW == t.PLAIN_VIEW ? (t.BODY.removeChild(t.BODY.firstChild), t.NODE.DIV.insertBefore(t.CONSOLE, t.NODE.DIV.firstChild), t.NODE.DIV.scrollIntoView(!0), t.MESSAGING = t.MESSAGING_INPLACE) : (t.MESSAGING = t.MESSAGING_TOP, window.scrollTo(0, 0)), t.CONSOLE.style.marginTop = "0px", t.CONSOLE.style.top = "0px")
    },
    hideConsole: function() {
        var t = this;
        t.MESSAGING && (t.CONSOLE.style.marginTop = "-" + t.CONSOLE_OFFSET, t.CONSOLE.style.top = "-" + t.CONSOLE_OFFSET, t.CONSOLE_LABEL.innerHTML = "", t.CONSOLE_INPUT.value = "", t.MESSAGING_INPLACE == t.MESSAGING && (t.NODE.DIV.removeChild(t.NODE.DIV.firstChild), t.BODY.insertBefore(t.CONSOLE, t.BODY.firstChild), 0 != t.NODE.IDX && t.NODE.DIV.scrollIntoView()), t.MESSAGING = !1)
    },
    getKey: function() {
        var t = this,
            s = t.CONSOLE_INPUT.value;
        if (0 == s.length) return t.HELPING ? (t.showHelp(), void 0) : (t.MESSAGING && !t.READING && t.removeWarning(), void 0);
        if (t.MESSAGING && !t.READING) return t.removeWarning(), void 0;
        if (t.HELPING) return t.showHelp(), t.CONSOLE_INPUT.value = "", void 0;
        if (!t.READING) {
            if (t.CONSOLE_INPUT.value = "", t.CONSOLE_INPUT.blur(), t.HIDE_TOC && t.TOC == t.NODE && "v" != s && "V" != s && "	" != s) s = "b";
            else {
                if ("	" == s) return !0;
                s = t.trim(s)
            }
            if (1 == s.length)
                if ("b" == s) t.popHistory();
                else if ("B" == s) t.popHistory(!0);
            else if ("c" == s) t.removeSearchHighlight(), (t.VIEW == t.INFO_VIEW || t.VIEW == t.SLIDE_VIEW) && t.showSection(t.NODE.IDX);
            else if ("i" == s) t.FIXED_TOC || (t.HIDE_TOC ? t.navigateTo("?/toc/?") : 0 != t.NODE.IDX && t.navigateTo(0)), null != t.TOC_LINK && t.TOC_LINK.focus();
            else {
                if ("m" == s) return t.toggleView(t.NODE.IDX), void 0;
                if ("x" == s) t.slideView(t.NODE.IDX);
                else if ("n" == s)
                    if (t.NODE.STATE == OrgNode.STATE_FOLDED && t.VIEW == t.PLAIN_VIEW) t.showSection(t.NODE.IDX);
                    else {
                        if (!(t.NODE.IDX < t.SECS.length - 1)) return t.warn("Already last section."), void 0;
                        t.navigateTo(t.NODE.IDX + 1)
                    } else {
                    if ("N" == s) {
                        if (t.NODE.IDX < t.SECS.length - 1)
                            for (var d = t.NODE.DEPTH, idx = t.NODE.IDX + 1; idx < t.SECS.length - 1 && t.SECS[idx].DEPTH >= d;) {
                                if (t.SECS[idx].DEPTH == d) return t.navigateTo(idx), void 0;
                                ++idx
                            }
                        return t.warn("No next sibling."), void 0
                    }
                    if ("p" == s) {
                        if (!(t.NODE.IDX > 0)) return t.warn("Already first section."), void 0;
                        t.navigateTo(t.NODE.IDX - 1)
                    } else if ("P" == s) {
                        if (t.NODE.IDX > 0)
                            for (var d = t.NODE.DEPTH, idx = t.NODE.IDX - 1; idx >= 0 && t.SECS[idx].DEPTH >= d;) {
                                if (t.SECS[idx].DEPTH == d) return t.navigateTo(idx), void 0;
                                --idx
                            }
                        t.warn("No previous sibling.")
                    } else if ("q" == s) window.confirm("Really close this file?") && window.close();
                    else if ("<" == s || "t" == s) 0 != t.NODE.IDX ? t.navigateTo(0) : window.scrollTo(0, 0);
                    else if (">" == s || "E" == s || "e" == s) t.SECS.length - 1 != t.NODE.IDX ? t.navigateTo(t.SECS.length - 1) : t.SECS[t.SECS.length - 1].DIV.scrollIntoView(!0);
                    else if ("v" == s) window.innerHeight ? window.scrollBy(0, window.innerHeight - 30) : document.documentElement.clientHeight ? window.scrollBy(0, document.documentElement.clientHeight - 30) : window.scrollBy(0, document.body.clientHeight - 30);
                    else if ("V" == s) window.innerHeight ? window.scrollBy(0, -(window.innerHeight - 30)) : document.documentElement.clientHeight ? window.scrollBy(0, -(document.documentElement.clientHeight - 30)) : window.scrollBy(0, -(document.body.clientHeight - 30));
                    else if ("u" == s) t.NODE.PARENT != t.ROOT && (t.NODE = t.NODE.PARENT, t.showSection(t.NODE.IDX));
                    else if ("W" == s) t.plainView(t.NODE.IDX), t.ROOT.DIRTY = !0, t.ROOT_STATE = OrgNode.STATE_UNFOLDED, t.toggleGlobaly(), t.toggleGlobaly(), t.toggleGlobaly(), window.print();
                    else if ("f" == s) t.VIEW != t.INFO_VIEW && (t.NODE.fold(), t.NODE.DIV.scrollIntoView(!0));
                    else if ("F" == s) t.VIEW != t.INFO_VIEW && (t.toggleGlobaly(), t.NODE.DIV.scrollIntoView(!0));
                    else if ("?" == s || "¿" == s) t.showHelp();
                    else if ("C" == s) t.SORTED_TAGS.length ? t.showTagsIndex() : t.warn("No Tags found.");
                    else if ("H" == s && t.LINK_HOME) window.document.location.href = t.LINK_HOME;
                    else if ("h" == s && t.LINK_UP) window.document.location.href = t.LINK_UP;
                    else {
                        if ("l" == s) return "" != t.OCCUR ? t.startRead(t.READ_COMMAND_HTML_LINK, "Choose HTML-link type: 's' = section, 'o' = occur") : (t.startRead(s, "HTML-link:", '<a href="' + t.BASE_URL + t.getDefaultTarget() + '">' + document.title + ", Sec. '" + t.removeTags(t.NODE.HEADING.innerHTML) + "'</a>", "C-c to copy, "), window.setTimeout(function() {
                            org_html_manager.CONSOLE_INPUT.select()
                        }, 100)), void 0;
                        if ("L" == s) return "" != t.OCCUR ? t.startRead(t.READ_COMMAND_ORG_LINK, "Choose Org-link type: 's' = section, 'o' = occur") : (t.startRead(s, "Org-link:", "[[" + t.BASE_URL + t.getDefaultTarget() + "][" + document.title + ", Sec. '" + t.removeTags(t.NODE.HEADING.innerHTML) + "']]", "C-c to copy, "), window.setTimeout(function() {
                            org_html_manager.CONSOLE_INPUT.select()
                        }, 100)), void 0;
                        if ("U" == s) return "" != t.OCCUR ? t.startRead(t.READ_COMMAND_PLAIN_URL_LINK, "Choose Org-link type: 's' = section, 'o' = occur") : (t.startRead(s, "Plain URL Link:", t.BASE_URL + t.getDefaultTarget(), "C-c to copy, "), window.setTimeout(function() {
                            org_html_manager.CONSOLE_INPUT.select()
                        }, 100)), void 0;
                        if ("g" == s) return t.startRead(s, "Enter section number:"), void 0;
                        if ("o" == s) return "" != t.OCCUR ? t.startRead(s, "Occur:", t.OCCUR, "RET to use previous, DEL ") : t.startRead(s, "Occur:", t.OCCUR), window.setTimeout(function() {
                            org_html_manager.CONSOLE_INPUT.value = org_html_manager.OCCUR, org_html_manager.CONSOLE_INPUT.select()
                        }, 100), void 0;
                        if ("s" == s) return "" != t.OCCUR ? t.startRead(s, "Search forward:", t.OCCUR, "RET to use previous, DEL ") : t.startRead(s, "Search forward:", t.OCCUR), window.setTimeout(function() {
                            org_html_manager.CONSOLE_INPUT.value = org_html_manager.OCCUR, org_html_manager.CONSOLE_INPUT.select()
                        }, 100), void 0;
                        if ("S" == s) return "" == t.OCCUR ? (s = "s", t.startRead(s, "Search forward:")) : (t.READ_COMMAND = s, t.evalReadCommand()), void 0;
                        if ("r" == s) return "" != t.OCCUR ? t.startRead(s, "Search backwards:", t.OCCUR, "RET to use previous, DEL ") : t.startRead(s, "Search backwards:", t.OCCUR), window.setTimeout(function() {
                            org_html_manager.CONSOLE_INPUT.value = org_html_manager.OCCUR, org_html_manager.CONSOLE_INPUT.select()
                        }, 100), void 0;
                        if ("R" == s) return "" == t.OCCUR ? (s = "r", t.startRead(s, "Search backwards:")) : (t.READ_COMMAND = s, t.evalReadCommand()), void 0
                    }
                }
            }
        }
    },
    evalReadCommand: function() {
        var t = this,
            command = t.READ_COMMAND,
            result = t.trim(t.CONSOLE_INPUT.value);
        if (t.endRead(), "" == command || "" == result) return t.hideConsole(), void 0;
        if ("g" == command) {
            var sec = t.SECNUM_MAP[result];
            return null != sec ? (t.hideConsole(), t.navigateTo(sec.IDX), void 0) : (t.warn("Goto section: no such section.", !1, result), void 0)
        }
        if ("s" == command) {
            if ("" == result) return !1;
            t.SEARCH_HIGHLIGHT_ON && t.removeSearchHighlight();
            var restore = t.OCCUR,
                plus = 0;
            result == t.OCCUR && plus++, t.OCCUR = result, t.makeSearchRegexp();
            for (var i = t.NODE.IDX + plus; i < t.SECS.length; ++i)
                if (t.searchTextInOrgNode(i)) return t.OCCUR = result, t.hideConsole(), t.navigateTo(t.SECS[i].IDX), void 0;
            return t.warn("Search forwards: text not found.", !1, t.OCCUR), t.OCCUR = restore, void 0
        }
        if ("S" == command) {
            for (var i = t.NODE.IDX + 1; i < t.SECS.length; ++i)
                if (t.searchTextInOrgNode(i)) return t.hideConsole(), t.navigateTo(t.SECS[i].IDX), void 0;
            return t.warn("Search forwards: text not found.", !1, t.OCCUR), void 0
        }
        if ("r" == command) {
            if ("" == result) return !1;
            t.SEARCH_HIGHLIGHT_ON && t.removeSearchHighlight();
            var restore = t.OCCUR;
            t.OCCUR = result;
            var plus = 0;
            result == t.OCCUR && plus++, t.makeSearchRegexp();
            for (var i = t.NODE.IDX - plus; i > -1; --i)
                if (t.searchTextInOrgNode(i)) return t.hideConsole(), t.navigateTo(t.SECS[i].IDX), void 0;
            return t.warn("Search backwards: text not found.", !1, t.OCCUR), t.OCCUR = restore, void 0
        }
        if ("R" == command) {
            for (var i = t.NODE.IDX - 1; i > -1; --i)
                if (result = t.removeTags(t.SECS[i].HEADING.innerHTML), t.searchTextInOrgNode(i)) return t.hideConsole(), t.navigateTo(t.SECS[i].IDX), void 0;
            return t.warn("Search backwards: text not found.", !1, t.OCCUR), void 0
        }
        if ("o" == command) {
            if ("" == result) return !1;
            t.SEARCH_HIGHLIGHT_ON && t.removeSearchHighlight();
            var restore = t.OCCUR;
            t.OCCUR = result, t.makeSearchRegexp();
            for (var occurs = new Array, i = 0; i < t.SECS.length; ++i) t.searchTextInOrgNode(i) && occurs.push(i);
            if (0 == occurs.length) return t.warn("Occur: text not found.", !1, t.OCCUR), t.OCCUR = restore, void 0;
            t.hideConsole(), t.PLAIN_VIEW != t.VIEW && t.plainView(), t.ROOT.DIRTY = !0, t.toggleGlobaly();
            for (var i = 0; i < t.SECS.length; ++i) OrgNode.showElement(t.SECS[i].DIV), OrgNode.hideElement(t.SECS[i].FOLDER);
            for (var i = occurs.length - 1; i >= 1; --i) OrgNode.showElement(t.SECS[occurs[i]].FOLDER);
            t.showSection(occurs[0])
        } else if (command == t.READ_COMMAND_ORG_LINK) {
            var c = result.charAt(0);
            "s" == c ? (t.startRead(t.READ_COMMAND_NULL, "Org-link to this section:", "[[" + t.BASE_URL + t.getDefaultTarget() + "][" + document.title + ", Sec. '" + t.removeTags(t.NODE.HEADING.innerHTML) + "']]", "C-c to copy, "), window.setTimeout(function() {
                org_html_manager.CONSOLE_INPUT.select()
            }, 100)) : "o" == c ? (t.startRead(t.READ_COMMAND_NULL, "Org-link, occurences of <i>&quot;" + t.OCCUR + "&quot;</i>:", "[[" + t.BASE_URL + "?OCCUR=" + t.OCCUR + "][" + document.title + ", occurences of '" + t.OCCUR + "']]", "C-c to copy, "), window.setTimeout(function() {
                org_html_manager.CONSOLE_INPUT.select()
            }, 100)) : t.warn(c + ": No such link type!")
        } else if (command == t.READ_COMMAND_HTML_LINK) {
            var c = result.charAt(0);
            "s" == c ? (t.startRead(t.READ_COMMAND_NULL, "HTML-link to this section:", '<a href="' + t.BASE_URL + t.getDefaultTarget() + '">' + document.title + ", Sec. '" + t.removeTags(t.NODE.HEADING.innerHTML) + "'</a>", "C-c to copy, "), window.setTimeout(function() {
                org_html_manager.CONSOLE_INPUT.select()
            }, 100)) : "o" == c ? (t.startRead(t.READ_COMMAND_NULL, "HTML-link, occurences of <i>&quot;" + t.OCCUR + "&quot;</i>:", '<a href="' + t.BASE_URL + "?OCCUR=" + t.OCCUR + '">' + document.title + ", occurences of '" + t.OCCUR + "'</a>", "C-c to copy, "), window.setTimeout(function() {
                org_html_manager.CONSOLE_INPUT.select()
            }, 100)) : t.warn(c + ": No such link type!")
        } else if (command == t.READ_COMMAND_PLAIN_URL_LINK) {
            var c = result.charAt(0);
            "s" == c ? (t.startRead(t.READ_COMMAND_NULL, "Plain-link to this section:", t.BASE_URL + t.getDefaultTarget(), "C-c to copy, "), window.setTimeout(function() {
                org_html_manager.CONSOLE_INPUT.select()
            }, 100)) : "o" == c ? (t.startRead(t.READ_COMMAND_NULL, "Plain-link, occurences of <i>&quot;" + t.OCCUR + "&quot;</i>:", t.BASE_URL + "?OCCUR=" + t.OCCUR, "C-c to copy, "), window.setTimeout(function() {
                org_html_manager.CONSOLE_INPUT.select()
            }, 100)) : t.warn(c + ": No such link type!")
        }
    },
    getDefaultTarget: function(node) {
        null == node && (node = this.NODE);
        var loc = "#" + this.NODE.BASE_ID;
        for (var s in node.isTargetFor)
            if (!s.match(this.SID_REGEX)) {
                loc = s;
                break
            }
        return loc
    },
    makeSearchRegexp: function() {
        var tmp = this.OCCUR.replace(/>/g, "&gt;").replace(/</g, "&lt;").replace(/=/g, "\\=").replace(/\\/g, "\\\\").replace(/\?/g, "\\?").replace(/\)/g, "\\)").replace(/\(/g, "\\(").replace(/\./g, "[^<>]").replace(/\"/g, "&quot;");
        this.SEARCH_REGEX = new RegExp(">([^<]*)?(" + tmp + ")([^>]*)?<", "ig")
    },
    searchTextInOrgNode: function(i) {
        var t = this,
            ret = !1;
        return null != t.SECS[i] ? (t.SEARCH_REGEX.test(t.SECS[i].HEADING.innerHTML) && (ret = !0, t.setSearchHighlight(t.SECS[i].HEADING), t.SECS[i].HAS_HIGHLIGHT = !0, t.SEARCH_HIGHLIGHT_ON = !0), t.SEARCH_REGEX.test(t.SECS[i].FOLDER.innerHTML) && (ret = !0, t.setSearchHighlight(t.SECS[i].FOLDER), t.SECS[i].HAS_HIGHLIGHT = !0, t.SEARCH_HIGHLIGHT_ON = !0), ret) : !1
    },
    setSearchHighlight: function(dom) {
        var tmp = dom.innerHTML;
        dom.innerHTML = tmp.replace(this.SEARCH_REGEX, '>$1<span class="org-info-js_search-highlight">$2</span>$3<')
    },
    removeSearchHighlight: function() {
        for (var t = this, i = 0; i < t.SECS.length; ++i)
            if (t.SECS[i].HAS_HIGHLIGHT) {
                for (; t.SEARCH_HL_REGEX.test(t.SECS[i].HEADING.innerHTML);) {
                    var tmp = t.SECS[i].HEADING.innerHTML;
                    t.SECS[i].HEADING.innerHTML = tmp.replace(t.SEARCH_HL_REGEX, "$2")
                }
                for (; t.SEARCH_HL_REGEX.test(t.SECS[i].FOLDER.innerHTML);) {
                    var tmp = t.SECS[i].FOLDER.innerHTML;
                    t.SECS[i].FOLDER.innerHTML = tmp.replace(t.SEARCH_HL_REGEX, "$2")
                }
                t.SECS[i].HAS_HIGHLIGHT = !1
            }
        t.SEARCH_HIGHLIGHT_ON = !1
    },
    highlightHeadline: function(h) {
        var i = parseInt(h);
        this.PLAIN_VIEW == this.VIEW && this.MOUSE_HINT && ("underline" == this.MOUSE_HINT ? this.SECS[i].HEADING.style.borderBottom = "1px dashed #666666" : this.SECS[i].HEADING.style.backgroundColor = this.MOUSE_HINT)
    },
    unhighlightHeadline: function(h) {
        var i = parseInt(h);
        "underline" == this.MOUSE_HINT ? this.SECS[i].HEADING.style.borderBottom = "" : this.SECS[i].HEADING.style.backgroundColor = ""
    },
    showHelp: function() {
        var t = this;
        t.READING ? t.endRead() : t.MESSAGING && t.removeWarning(), t.HELPING = t.HELPING ? 0 : 1, t.HELPING ? (t.LAST_VIEW_MODE = t.VIEW, t.PLAIN_VIEW == t.VIEW && t.infoView(!0), t.WINDOW.innerHTML = 'Press any key or <a href="javascript:org_html_manager.showHelp();">click here</a> to proceed.<h2>Keyboard Shortcuts</h2><table cellpadding="3" rules="groups" frame="hsides" style="caption-side:bottom;margin:20px;border-style:none;" border="0";><caption><small>org-info.js, v.###VERSION###</small></caption><tbody><tr><td><code><b>? / &iquest;</b></code></td><td>show this help screen</td></tr></tbody><tbody><tr><td><code><b></b></code></td><td><b>Moving around</b></td></tr><tr><td><code><b>n / p</b></code></td><td>goto the next / previous section</td></tr><tr><td><code><b>N / P</b></code></td><td>goto the next / previous sibling</td></tr><tr><td><code><b>t / E</b></code></td><td>goto the first / last section</td></tr><tr><td><code><b>g</b></code></td><td>goto section...</td></tr><tr><td><code><b>u</b></code></td><td>go one level up (parent section)</td></tr><tr><td><code><b>i / C</b></code></td><td>show table of contents / tags index</td></tr><tr><td><code><b>b / B</b></code></td><td>go back to last / forward to next visited section.</td></tr><tr><td><code><b>h / H</b></code></td><td>go to main index in this directory / link HOME page</td></tr></tbody><tbody><tr><td><code><b></b></code></td><td><b>View</b></td></tr><tr><td><code><b>m / x</b></code></td><td>toggle the view mode between info and plain / slides</td></tr><tr><td><code><b>f / F</b></code></td><td>fold current section / whole document (plain view only)</td></tr></tbody><tbody><tr><td><code><b></b></code></td><td><b>Searching</b></td></tr><tr><td><code><b>s / r</b></code></td><td>search forward / backward....</td></tr><tr><td><code><b>S / R</b></code></td><td>search again forward / backward</td></tr><tr><td><code><b>o</b></code></td><td>occur-mode</td></tr><tr><td><code><b>c</b></code></td><td>clear search-highlight</td></tr></tbody><tbody><tr><td><code><b></b></code></td><td><b>Misc</b></td></tr><tr><td><code><b>l / L / U</b></code></td><td>display HTML link / Org link / Plain-URL</td></tr><tr><td><code><b>v / V</b></code></td><td>scroll down / up</td></tr><tr><td><code><b>W</b></code></td><td>Print</td></tr></tbody></table><br />Press any key or <a href="javascript:org_html_manager.showHelp();">click here</a> to proceed.', window.scrollTo(0, 0)) : (t.PLAIN_VIEW == t.LAST_VIEW_MODE ? t.plainView() : t.SLIDE_VIEW == t.LAST_VIEW_MODE && t.slideView(), t.showSection(t.NODE.IDX))
    },
    showTagsIndex: function() {
        var t = this;
        if (t.READING ? t.endRead() : t.MESSAGING && t.removeWarning(), t.HELPING = t.HELPING ? 0 : 1, t.HELPING) {
            if (t.LAST_VIEW_MODE = t.VIEW, t.PLAIN_VIEW == t.VIEW && t.infoView(!0), null == t.TAGS_INDEX) {
                t.TAGS_INDEX = 'Press any key or <a href="javascript:org_html_manager.showTagsIndex();">click here</a> to proceed.<br /><br />Click the headlines to expand the contents.<h2>Index of Tags</h2>';
                for (var i = 0; i < t.SORTED_TAGS.length; ++i) {
                    var tag = t.SORTED_TAGS[i],
                        fid = "org-html-manager-sorted-tags-" + tag;
                    t.TAGS_INDEX += "<a href=\"javascript:OrgNode.toggleElement(document.getElementById('" + fid + "'));\"><h3>" + tag + "</h3></a>" + '<div id="' + fid + '" style="visibility:hidden;display:none;"><ul>';
                    for (var j = 0; j < t.TAGS[tag].length; ++j) {
                        var idx = t.TAGS[tag][j];
                        t.TAGS_INDEX += '<li><a href="javascript:org_html_manager.showSection(' + idx + ');">' + t.SECS[idx].HEADING.innerHTML + "</a></li>"
                    }
                    t.TAGS_INDEX += "</ul></div>"
                }
                t.TAGS_INDEX += '<br />Press any key or <a href="javascript:org_html_manager.showTagsIndex();">click here</a> to proceed.'
            }
            t.WINDOW.innerHTML = t.TAGS_INDEX, window.scrollTo(0, 0)
        } else t.PLAIN_VIEW == t.LAST_VIEW_MODE ? t.plainView() : t.SLIDE_VIEW == t.LAST_VIEW_MODE && t.slideView(), t.showSection(t.NODE.IDX)
    },
    runHooks: function(name, args) {
        if (this.HOOKS.run_hooks && this.HOOKS[name])
            for (var i = 0; i < this.HOOKS[name].length; ++i) this.HOOKS[name][i](this, args)
    },
    addHook: function(name, func) {
        "run_hooks" != name && this.HOOKS[name].push(func)
    },
    removeHook: function(name, func) {
        if (this.HOOKS[name])
            for (var i = this.HOOKS[name].length - 1; i >= 0; --i) this.HOOKS[name][i] == func && this.HOOKS[name].splice(i, 1)
    }
};
! function() {}.call(this),
    function() {}.call(this);