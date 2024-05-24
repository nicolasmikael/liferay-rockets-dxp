<#assign hasCategories=false />
<#if entries?has_content>
    <@clay.row>
        <#list entries as entry>
            <#assign categories=entry.getCategories() />
            <#if categories?has_content>
                <#assign hasCategories=true />
                <@clay.col md="12">
                    <div class="btn bg-dark d-flex results-header mb-3">
                        <h3 class="poppins-semibold text-white">
                            Categorias
                        </h3>
                    </div>
                    <@displayCategories categories=categories />
                </@clay.col>
            </#if>
        </#list>
        <#if !hasCategories>
            ${renderRequest.setAttribute("PORTLET_CONFIGURATOR_VISIBILITY", true)}
            <div class="alert alert-info w-100">
                <@liferay_ui.message key="there-are-no-categories" />
            </div>
        </#if>
    </@clay.row>
</#if>
<#macro displayCategories
    categories>
    <#if categories?has_content>
        <ul class="categories d-block">
            <#list categories as category>
                <li class="btn btn-light m-1 poppins-semibold ">
                    <#assign categoryURL=renderResponse.createRenderURL() />
                    ${categoryURL.setParameter("resetCur", "true")}
                    ${categoryURL.setParameter("categoryId", category.getCategoryId()?string)}
                    <a class="text-decoration-none text-dark" href="${categoryURL}">
                        ${category.getName()}
                    </a>
                    <#if serviceLocator??>
                        <#assign
                            assetCategoryService=serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryService")
                            childCategories=assetCategoryService.getChildCategories(category.getCategoryId()) />
                        <@displayCategories categories=childCategories />
                    </#if>
                </li>
            </#list>
        </ul>
    </#if>
</#macro>