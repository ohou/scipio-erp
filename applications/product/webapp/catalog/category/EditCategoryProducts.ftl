<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<#assign menuHtml>
  <@menu type="section" inlineItems=true>
  <#if activeOnly>
    <li><a href="<@ofbizUrl>EditCategoryProducts?productCategoryId=${productCategoryId!}&amp;activeOnly=false</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.ProductActiveAndInactive}</a></li>
  <#else>
    <li><a href="<@ofbizUrl>EditCategoryProducts?productCategoryId=${productCategoryId!}&amp;activeOnly=true</@ofbizUrl>" class="${styles.button_default!}">${uiLabelMap.ProductActiveOnly}</a></li>
  </#if>
  </@menu>
</#assign>
<@section title="${uiLabelMap.PageTitleEditCategoryProducts}" menuHtml=menuHtml>
      <#macro categoryProductsNav>
        <@menu type="button">
          <li><a href="<@ofbizUrl>EditCategoryProducts?productCategoryId=${productCategoryId!}&amp;VIEW_SIZE=${viewSize}&amp;VIEW_INDEX=${viewIndex-1}&amp;activeOnly=${activeOnly.toString()}</@ofbizUrl>" class="${styles.button_default!}<#if (viewIndex <= 1)> disabled</#if>">${uiLabelMap.CommonPrevious}</a></li>
          <li><span class="text-entry">${lowIndex} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</span></li>
          <li><a class="${styles.button_default!}" href="<@ofbizUrl>EditCategoryProducts?productCategoryId=${productCategoryId!}&amp;VIEW_SIZE=${viewSize}&amp;VIEW_INDEX=${viewIndex+1}&amp;activeOnly=${activeOnly.toString()}</@ofbizUrl>" class="${styles.button_default!}<#if (listSize <= highIndex)> disabled</#if>">${uiLabelMap.CommonNext}</a></li>
        </@menu>
      </#macro>
      
      <#if (listSize > 0)>
        <@categoryProductsNav />
      </#if>

        <#if (listSize == 0)>
           <@table type="data-complex" autoAltRows=true cellspacing="0" class="basic-table">
           <@thead>
              <@tr class="header-row">
                 <@th>${uiLabelMap.ProductProductNameId}</@th>
                 <@th>${uiLabelMap.CommonFromDateTime}</@th>
                 <@th align="center">${uiLabelMap.ProductThruDateTimeSequenceQuantity} ${uiLabelMap.CommonComments}</@th>
                 <@th>&nbsp;</@th>
              </@tr>
           </@thead>
           </@table>
        <#else>
           <form method="post" action="<@ofbizUrl>updateCategoryProductMember</@ofbizUrl>" name="updateCategoryProductForm">
              <input type="hidden" name="VIEW_SIZE" value="${viewSize}"/>
              <input type="hidden" name="VIEW_INDEX" value="${viewIndex}"/>
              <input type="hidden" name="activeOnly" value="${activeOnly.toString()}" />
              <input type="hidden" name="productCategoryId" value="${productCategoryId!}" />
              <@table type="data-complex" autoAltRows=true cellspacing="0" class="basic-table">
                <@thead>
                 <@tr class="header-row">
                    <@th>${uiLabelMap.ProductProductNameId}</@th>
                    <@th>${uiLabelMap.CommonFromDateTime}</@th>
                    <@th align="center">${uiLabelMap.ProductThruDateTimeSequenceQuantity} ${uiLabelMap.CommonComments}</@th>
                    <@th>&nbsp;</@th>
                 </@tr>
                </@thead>
              <#assign rowCount = 0>
              <#list productCategoryMembers as productCategoryMember>
                <#assign suffix = "_o_" + productCategoryMember_index>
                <#assign product = productCategoryMember.getRelatedOne("Product", false)>
                <#assign hasntStarted = false>
                <#if productCategoryMember.fromDate?? && nowTimestamp.before(productCategoryMember.getTimestamp("fromDate"))><#assign hasntStarted = true></#if>
                <#assign hasExpired = false>
                <#if productCategoryMember.thruDate?? && nowTimestamp.after(productCategoryMember.getTimestamp("thruDate"))><#assign hasExpired = true></#if>
                  <@tr valign="middle">
                    <@td>
                      <#if (product.smallImageUrl)??>
                         <a href="<@ofbizUrl>EditProduct?productId=${(productCategoryMember.productId)!}</@ofbizUrl>" class="${styles.button_default!}"><img alt="Small Image" src="<@ofbizContentUrl>${product.smallImageUrl}</@ofbizContentUrl>" class="cssImgSmall" align="middle" /></a>
                      </#if>
                      <a href="<@ofbizUrl>EditProduct?productId=${(productCategoryMember.productId)!}</@ofbizUrl>" class="${styles.button_default!}"><#if product??>${(product.internalName)!}</#if> [${(productCategoryMember.productId)!}]</a>
                    </@td>
                    <#assign colorStyle><#if hasntStarted> style="color: red;"</#if></#assign>
                    <@td style=colorStyle>${(productCategoryMember.fromDate)!}</@td>
                    <@td align="center">
                        <input type="hidden" name="productId${suffix}" value="${(productCategoryMember.productId)!}" />
                        <input type="hidden" name="productCategoryId${suffix}" value="${(productCategoryMember.productCategoryId)!}" />
                        <input type="hidden" name="fromDate${suffix}" value="${(productCategoryMember.fromDate)!}" />
                        <#if hasExpired><#assign class="alert"></#if>
                        <@htmlTemplate.renderDateTimeField name="thruDate${suffix}" event="" action="" className="${class!''}"  title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="${(productCategoryMember.thruDate)!}" size="25" maxlength="30" id="thruDate${suffix}" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                        <input type="text" size="5" name="sequenceNum${suffix}" value="${(productCategoryMember.sequenceNum)!}" />
                        <input type="text" size="5" name="quantity${suffix}" value="${(productCategoryMember.quantity)!}" />
                        <br />
                        <textarea name="comments${suffix}" rows="2" cols="40">${(productCategoryMember.comments)!}</textarea>
                    </@td>
                    <@td align="center">
                      <a href="javascript:document.deleteProductFromCategory_o_${rowCount}.submit()" class="${styles.button_default!}">${uiLabelMap.CommonDelete}</a>
                    </@td>
                  </@tr>
                  <@tr valign="middle" groupLast=true>
                      <@td colspan="4" align="center">
                          <input type="submit" value="${uiLabelMap.CommonUpdate}" style="font-size: x-small;" />
                          <input type="hidden" value="${productCategoryMembers.size()}" name="_rowCount" />
                      </@td>
                  </@tr>
                  <#assign rowCount = rowCount + 1>
              </#list>
              </@table>
           </form>
           <#assign rowCount = 0>
           <#list productCategoryMembers as productCategoryMember>
           <form name="deleteProductFromCategory_o_${rowCount}" method="post" action="<@ofbizUrl>removeCategoryProductMember</@ofbizUrl>">
              <input type="hidden" name="VIEW_SIZE" value="${viewSize}"/>
              <input type="hidden" name="VIEW_INDEX" value="${viewIndex}"/>
              <input type="hidden" name="productId" value="${(productCategoryMember.productId)!}" />
              <input type="hidden" name="productCategoryId" value="${(productCategoryMember.productCategoryId)!}"/>
              <input type="hidden" name="fromDate" value="${(productCategoryMember.fromDate)!}"/>
              <input type="hidden" name="activeOnly" value="${activeOnly.toString()}"/>
           </form>
           <#assign rowCount = rowCount + 1>
           </#list>        
      </#if>
    
      <#if (listSize > 0)>
        <@categoryProductsNav />
      </#if>
</@section>

<@section title="${uiLabelMap.ProductAddProductCategoryMember}">
        <@table type="fields" cellspacing="0" class="basic-table">
            <@tr><@td>
                <form method="post" action="<@ofbizUrl>addCategoryProductMember</@ofbizUrl>" style="margin: 0;" name="addProductCategoryMemberForm">
                    <input type="hidden" name="productCategoryId" value="${productCategoryId!}" />
                    <input type="hidden" name="activeOnly" value="${activeOnly.toString()}" />
                    <div>
                        <span>${uiLabelMap.ProductProductId}</span>
                        <@htmlTemplate.lookupField formName="addProductCategoryMemberForm" name="productId" id="productId" fieldFormName="LookupProduct"/>
                        <br/>
                        <span>${uiLabelMap.CommonFromDate}</span>
                        <@htmlTemplate.renderDateTimeField name="fromDate" event="" action="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="" size="25" maxlength="30" id="fromDate1" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                        <span class="tooltip">${uiLabelMap.CommonRequired}</span>
                          <br />
                          <span>${uiLabelMap.CommonComments}</span> <textarea name="comments" rows="2" cols="40"></textarea>
                          <input type="submit" value="${uiLabelMap.CommonAdd}" />
                    </div>
                </form>
            </@td></@tr>
        </@table>
</@section>

<@section title="${uiLabelMap.ProductCopyProductCategoryMembersToAnotherCategory}">
        <@table type="fields" cellspacing="0" class="basic-table">
            <@tr><@td>
                <form method="post" action="<@ofbizUrl>copyCategoryProductMembers</@ofbizUrl>" style="margin: 0;" name="copyCategoryProductMembersForm">
                    <input type="hidden" name="productCategoryId" value="${productCategoryId!}" />
                    <input type="hidden" name="activeOnly" value="${activeOnly.toString()}" />
                    <div>
                        <span>${uiLabelMap.ProductTargetProductCategory}</span>
                        <@htmlTemplate.lookupField formName="copyCategoryProductMembersForm" name="productCategoryIdTo" id="productCategoryIdTo" fieldFormName="LookupProductCategory"/>
                        <br />
                        <span>${uiLabelMap.ProductOptionalFilterWithDate}</span>
                        <@htmlTemplate.renderDateTimeField name="validDate" event="" action="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="" size="25" maxlength="30" id="validDate1" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                        <br />
                        <span>${uiLabelMap.ProductIncludeSubCategories}</span>
                        <select name="recurse">
                            <option value="N">${uiLabelMap.CommonN}</option>
                            <option value="Y">${uiLabelMap.CommonY}</option>
                        </select>
                        <input type="submit" value="${uiLabelMap.CommonCopy}" />
                    </div>
                </form>
            </@td></@tr>
        </@table>
</@section>

<@section title="${uiLabelMap.ProductExpireAllProductMembers}">
        <@table type="fields" cellspacing="0" class="basic-table">
            <@tr><@td>
                <form method="post" action="<@ofbizUrl>expireAllCategoryProductMembers</@ofbizUrl>" style="margin: 0;" name="expireAllCategoryProductMembersForm">
                    <input type="hidden" name="productCategoryId" value="${productCategoryId!}" />
                    <input type="hidden" name="activeOnly" value="${activeOnly.toString()}" />
                    <div>
                        <span>${uiLabelMap.ProductOptionalExpirationDate}</span>
                        <@htmlTemplate.renderDateTimeField name="thruDate" event="" action="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="" size="25" maxlength="30" id="thruDate2" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                        &nbsp;&nbsp;<input type="submit" value="${uiLabelMap.CommonExpireAll}" />
                    </div>
                </form>
            </@td></@tr>
        </@table>
</@section>

<@section title="${uiLabelMap.ProductRemoveExpiredProductMembers}">
        <@table type="fields" cellspacing="0" class="basic-table">
            <@tr><@td>
                <form method="post" action="<@ofbizUrl>removeExpiredCategoryProductMembers</@ofbizUrl>" style="margin: 0;" name="removeExpiredCategoryProductMembersForm">
                    <input type="hidden" name="productCategoryId" value="${productCategoryId!}" />
                    <input type="hidden" name="activeOnly" value="${activeOnly.toString()}" />
                    <div>
                        <span>${uiLabelMap.ProductOptionalExpiredBeforeDate}</span>
                        <@htmlTemplate.renderDateTimeField name="validDate" event="" action="" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" value="" size="25" maxlength="30" id="validDate2" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                        &nbsp;&nbsp;<input type="submit" value="${uiLabelMap.CommonRemoveExpired}" />
                    </div>
                </form>
            </@td></@tr>
        </@table>
</@section>
