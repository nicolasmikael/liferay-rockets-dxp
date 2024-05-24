<#assign
    destination="/search"
    searchInputId=namespace + stringUtil.randomId() />
<#if searchBarPortletDisplayContext.getDestinationFriendlyURL()?has_content>
    <#assign destination=searchBarPortletDisplayContext.getDestinationFriendlyURL() />
</#if>
<@liferay_aui.fieldset cssClass="search-bar">
    <@liferay_aui.input
        cssClass="search-bar-empty-search-input"
        name="emptySearchEnabled"
        type="hidden"
        value=searchBarPortletDisplayContext.isEmptySearchEnabled() />
    <div class="input-group ${searchBarPortletDisplayContext.isLetTheUserChooseTheSearchScope()?then("search-bar-scope","search-bar-simple")}">
        <#if searchBarPortletDisplayContext.isLetTheUserChooseTheSearchScope()>
            <div class="input-group-item input-group-item-shrink input-group-prepend">
                <button aria-label="${languageUtil.get(locale, "submit")}" class="btn btn-outline-secondary" type="submit">
                    Buscar
                </button>
            </div>
            <@liferay_aui.select
                cssClass="search-bar-scope-select"
                id="${namespace}selectScope"
                label=""
                name=htmlUtil.escape(searchBarPortletDisplayContext.getScopeParameterName())
                title="scope"
                useNamespace=false
                wrapperCssClass="input-group-item input-group-item-shrink input-group-prepend search-bar-search-select-wrapper">
                <@liferay_aui.option
                    label="this-site"
                    selected=searchBarPortletDisplayContext.isSelectedCurrentSiteSearchScope()
                    value=searchBarPortletDisplayContext.getCurrentSiteSearchScopeParameterString() />
                <#if searchBarPortletDisplayContext.isAvailableEverythingSearchScope()>
                    <@liferay_aui.option
                        label="everything"
                        selected=searchBarPortletDisplayContext.isSelectedEverythingSearchScope()
                        value=searchBarPortletDisplayContext.getEverythingSearchScopeParameterString() />
                </#if>
                </@>
                <#assign data={ "test-id" : "searchInput"
                    } />
                <@liferay_aui.input
                    autoFocus=true
                    autocomplete="off"
                    cssClass="search-bar-keywords-input"
                    data=data
                    id=searchInputId
                    label=""
                    name=htmlUtil.escape(searchBarPortletDisplayContext.getKeywordsParameterName())
                    placeholder=searchBarPortletDisplayContext.getInputPlaceholder()
                    title=languageUtil.get(locale, "search" )
                    type="text"
                    useNamespace=false
                    value=htmlUtil.escape(searchBarPortletDisplayContext.getKeywords())
                    wrapperCssClass="input-group-item input-group-append search-bar-keywords-input-wrapper" />
                <#else>
                    <div class="input-group-item search-bar-keywords-input-wrapper">
                        <input
                            autoFocus=true
                            autocomplete="off"
                            class="form-control input-group-inset input-group-inset-after search-bar-keywords-input "
                            data-qa-id="searchInput"
                            id=${searchInputId}
                            name="${htmlUtil.escape(searchBarPortletDisplayContext.getKeywordsParameterName())}"
                            placeholder="Buscar"
                            title="${languageUtil.get(locale, "search")}"
                            type="text"
                            value="${htmlUtil.escape(searchBarPortletDisplayContext.getKeywords())}" />
                        <div class="input-group-inset-item input-group-inset-item-after">
                            <button aria-label="${languageUtil.get(locale, "submit")}" class="btn btn-outline-secondary" type="submit">
                                Buscar
                            </button>
                        </div>
                        <@liferay_aui.input
                            name=htmlUtil.escape(searchBarPortletDisplayContext.getScopeParameterName())
                            type="hidden"
                            value=searchBarPortletDisplayContext.getScopeParameterValue() />
                    </div>
        </#if>
    </div>
</@liferay_aui.fieldset>
<#if searchBarPortletDisplayContext.isSuggestionsEnabled()>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
    <script>
    $(function() {
        const inputElement = $("#${searchInputId}");
        const getURL = (request) => {
            let serviceURL = new URL(Liferay.ThemeDisplay.getPathContext() + "${searchBarPortletDisplayContext.getSuggestionsURL()}", Liferay.ThemeDisplay.getPortalURL());
            const scopeIfDefined = "${searchBarPortletDisplayContext.isSelectedEverythingSearchScope()?then('everything', 'this-site')}";
            const scopeIfLetUserChoose = $("#${namespace}selectScope").val();
            serviceURL.searchParams.append("currentURL", window.location.href);
            serviceURL.searchParams.append("destinationFriendlyURL", "${destination}");
            serviceURL.searchParams.append("groupId", themeDisplay.getScopeGroupId());
            serviceURL.searchParams.append("keywordsParameterName", "${searchBarPortletDisplayContext.getKeywordsParameterName()}");
            serviceURL.searchParams.append("plid", themeDisplay.getPlid());
            serviceURL.searchParams.append("scope", "${searchBarPortletDisplayContext.isLetTheUserChooseTheSearchScope()?c}" == 'true' ? scopeIfLetUserChoose : scopeIfDefined);
            serviceURL.searchParams.append("search", request.term);
            return serviceURL;
        };
        $.widget("custom.catcomplete", $.ui.autocomplete, {
            _create: function() {
                this._super();
                this.widget().menu("option", "items", "> :not(.dropdown-subheader)");
            },
            _renderMenu: function(ul, items) {
                ul.addClass("dropdown-menu");
                ul.css('max-width', inputElement.width());
                let that = this,
                    currentCategory = "";
                $.each(items, function(index, item) {
                    let li;
                    if (item.category != currentCategory) {
                        ul.append('<div class="dropdown-subheader">' + item.category + "</div>");
                        currentCategory = item.category;
                    }
                    li = that._renderItemData(ul, item);
                });
            },
            _renderItem: function(ul, item) {
                const aLink = $('<a class="dropdown-item" href="' + item.attributes.assetURL + '">')
                    .append('<p class="list-group-text text-dark">' +
                        Liferay.Util.escapeHTML(item.text) + '</p>')
                    .append('<p class="list-group-text text-truncate text-2">' +
                        Liferay.Util.escapeHTML(item.attributes.assetSearchSummary) + '</p>');
                return $(aLink).appendTo(ul);
            }
        });
        $(inputElement).catcomplete({
            minLength: ${searchBarPortletDisplayContext.getSuggestionsDisplayThreshold()},
            source: function(request, response) {
                $.ajax({
                    url: getURL(request),
                    method: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    headers: {
                        "Accept-Language": themeDisplay.getBCP47LanguageId(),
                        "Content-Type": "application/json",
                        "X-csrf-token": Liferay.authToken
                    },
                    data: JSON.stringify(${searchBarPortletDisplayContext.getSuggestionsContributorConfiguration()}),
                    success: function(data) {
                        const list = [];
                        $.each(data.items, function(index, item) {
                            const category = item.displayGroupName;
                            $.each(item.suggestions, function(index, suggestion) {
                                list.push({...suggestion, category});
                            });
                        });
                        response(list);
                    }
                });
            },
            focus: function(event, ui) {
                return false;
            },
            messages: {
                noResults: '',
                results: function() {}
            },
            select: function(event, ui) {
                return false;
            }
        });
    });
    </script>
</#if>