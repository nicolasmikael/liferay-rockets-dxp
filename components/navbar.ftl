<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <#if entries?has_content>
        <div class="container">
            <ul class="navbar-nav mr-auto">
                <#list entries as navItem>
                    <#assign nav_item_css_class=navItem.getName() />
                    <#if navItem.isSelected()>
                        <#assign
                            nav_item_css_class="selected active" />
                    </#if>
                    <li class="navbar-item ${nav_item_css_class}">
                        <a href="${navItem.getURL()}" class="nav-link text-light poppins-semibold">
                            ${navItem.getName()}
                        </a>
                    </li>
                </#list>
            </ul>
            <div class="row align-items-center">
                <div class="mt-2 px-2 ">
                    <@liferay.search_bar />
                </div>
                <div class="px-2">
                    <@liferay.user_personal_bar />
                </div>
            </div>
        </div>
    </#if>
</nav>
<style>
#p_p_id_com_liferay_portal_search_web_search_bar_portlet_SearchBarPortlet_INSTANCE_templateSearch_ .portlet-content {
    background-color: transparent;
}
</style>