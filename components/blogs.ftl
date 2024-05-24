<#assign blogsEntryLocalService=serviceLocator.findService("com.liferay.blogs.service.BlogsEntryLocalService") />
<#assign AssetCategoryLocalService=serviceLocator.findService("com.liferay.asset.kernel.service.AssetCategoryLocalService") />
<#if entries?has_content>
    <div class="container pt-4">
        <div class="row row-cols-1">
            <#list entries as entry>
                <div class="col">
                    <div class="card border-light shadow-none mb-3">
                        <#assign blog=blogsEntryLocalService.getBlogsEntry(entry.getClassPK()) />
                        <#assign assetRenderer=entry.getAssetRenderer() />
                        <#assign viewURL=assetPublisherHelper.getAssetViewURL(renderRequest, renderResponse, entry) />
                        <#if assetLinkBehavior !="showFullContent">
                            <#assign viewURL=assetRenderer.getURLViewInContext(renderRequest, renderResponse, viewURL) />
                        </#if>
                        <div class="row no-gutters align-items-center">
                            <div class="col-md-6">
                                <a href="${viewURL}"><img class="img-fluid rounded" src="${blog.getSmallImageURL(themeDisplay)}" alt=""></a>
                            </div>
                            <div class="col-md-6">
                                <div class="card-body">
                                    <a class="card-title poppins-bold" href="${viewURL}">
                                        <h3>
                                            ${blog.getTitle()}
                                        </h3>
                                    </a>
                                    <b class="card-text poppins-light">
                                        ${blog.getModifiedDate()?date}
                                    </b>
                                    <p class="card-text poppins-regular">
                                        ${blog.getSubtitle()}
                                    </p>
                                    <div class="d-flex flex-wrap">
                                        <#list AssetCategoryLocalService.getEntryCategories(entry.getEntryId()) as entryCat>
                                            <#assign catName=entryCat.getName()>
                                                <#assign categoryURL=renderResponse.createRenderURL() />
                                                <a href="${categoryURL}" class="btn btn-light m-1 poppins-semibold">
                                                    ${catName}
                                                </a>
                                        </#list>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </#list>
        </div>
    </div>
</#if>