<#assign AssetCategoryLocalService=serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService") />
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <#if entries?has_content>
        <#list entries as entry>
            <div class="container">
                <ul class="navbar-nav mr-auto">
                    <#list AssetCategoryLocalService.getEntryCategories(entry.getEntryId()) as navItem>
                        <#assign nav_item_css_class=navItem.getName() />
                        <#if navItem.isSelected()>
                            <#assign
                                nav_item_css_class="selected active" />
                        </#if>
                        <li class="navbar-item ${nav_item_css_class}">
                            <a href="${navItem.getURL()}" class="btnbtn btn-light m-1 poppins-semibold">
                                ${navItem.getName()}
                            </a>
                        </li>
                    </#list>
                </ul>
            </div>
        </#list>
    </#if>
</nav>