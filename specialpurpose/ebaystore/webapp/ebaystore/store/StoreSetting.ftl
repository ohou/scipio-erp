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
<@script>
    function countAreaChars(areaName, limit, charleft)
    {
        if (areaName.value.length > limit){
           areaName.value=areaName.value.substring(0,limit);
        }else{
          charleft.innerHTML = (limit - areaName.value.length) + " ${uiLabelMap.CommonCharactorsLeft}";
        }
    }
    function retrieveThemeColorSchemeByThemeId(url, themeId, productStoreId){
        var pars = 'themeId='+themeId+'&amp;productStoreId='+productStoreId;

        jQuery.ajax({
         url: url,
         type: "GET",
         data: pars,
         beforeStart: function() {document.getElementById('loading').innerHTML = ' ${uiLabelMap.CommonPleaseWait}';},
             success: function(data) {
                if (data != null && data.storeColorSchemeMap){
                    var resp = eval("("+data.storeColorSchemeMap+")");
                    if (resp.storeColorPrimary!=null) document.getElementById('storePrimaryColor').value =  resp.storeColorPrimary;
                    if (resp.storeColorAccent!=null) document.getElementById('storeSecondaryColor').value = resp.storeColorAccent;
                    if (resp.storeColorSecondary!=null) document.getElementById('storeAccentColor').value = resp.storeColorSecondary;

                    if (resp.storeFontTypeFontFaceValue!=null) selectOption( document.getElementById('storeNameFont'),resp.storeFontTypeFontFaceValue);
                    if (resp.storeFontTypeNameFaceColor!=null) document.getElementById('storeNameFontColor').value = resp.storeFontTypeNameFaceColor;
                    if (resp.storeFontTypeSizeFaceValue!=null) selectOption( document.getElementById('storeNameFontSize'), resp.storeFontTypeSizeFaceValue);

                    if (resp.storeFontTypeTitleColor!=null) document.getElementById('storeTitleFontColor').value = resp.storeFontTypeTitleColor;
                    if (resp.storeFontTypeFontTitleValue!=null) selectOption( document.getElementById('storeTitleFont'),resp.storeFontTypeFontTitleValue);
                    if (resp.storeFontSizeTitleValue!=null) selectOption( document.getElementById('storeTitleFontSize'),resp.storeFontSizeTitleValue);

                    if (resp.storeFontTypeDescColor!=null) document.getElementById('storeDescFontColor').value = resp.storeFontTypeDescColor;
                    if (resp.storeFontTypeFontDescValue!=null) selectOption( document.getElementById('storeDescFont'),resp.storeFontTypeFontDescValue);
                    if (resp.storeDescSizeValue!=null) selectOption( document.getElementById('storeDescFontSize'),resp.storeDescSizeValue);
                }
                 document.getElementById('loading').innerHTML = '';
         }
        });
    }

    function selectOption(myselect, val){
        for (var i=0; i<myselect.options.length; i++){
             if ( myselect.options[i].value == val){
                 myselect.options[i].selected=true;
                 break;
             }

        }
    }
    function switchTheme(url, themeId, productStoreId){
        var size = document.StoreSettingForm.storeThemeType.length;
        var selectTheme = '';
        for(i=0;i<size;i++){
            if (document.StoreSettingForm.storeThemeType[i].checked){
                selectTheme = document.StoreSettingForm.storeThemeType[i].value;
                break;
            }
        }
        if (selectTheme == 'Basic') {
            //retrieve basic theme by ajax then print new select list
            document.StoreSettingForm.storeAdvancedTheme.disabled = true;
            document.StoreSettingForm.storeAdvancedThemeColor.disabled = true;

            document.StoreSettingForm.storeBasicTheme.disabled = false;
            document.StoreSettingForm.storePrimaryColor.disabled = false;
            document.StoreSettingForm.storeSecondaryColor.disabled = false;
            document.StoreSettingForm.storeAccentColor.disabled = false;

            document.StoreSettingForm.storeNameFont.disabled = false;
            document.StoreSettingForm.storeNameFontSize.disabled = false;
            document.StoreSettingForm.storeNameFontColor.disabled = false;

            document.StoreSettingForm.storeTitleFont.disabled = false;
            document.StoreSettingForm.storeTitleFontSize.disabled = false;
            document.StoreSettingForm.storeTitleFontColor.disabled = false;

            document.StoreSettingForm.storeDescFont.disabled = false;
            document.StoreSettingForm.storeDescFontSize.disabled = false;
            document.StoreSettingForm.storeDescFontColor.disabled = false;
            document.StoreSettingForm.themeType.value = "Basic";

        } else if (selectTheme == 'Advanced') {
            document.StoreSettingForm.themeType.value = "Advanced";
            document.StoreSettingForm.storeBasicTheme.disabled = true;
            document.StoreSettingForm.storePrimaryColor.disabled = true;
            document.StoreSettingForm.storeSecondaryColor.disabled = true;
            document.StoreSettingForm.storeAccentColor.disabled = true;

            document.StoreSettingForm.storeNameFont.disabled = true;
            document.StoreSettingForm.storeNameFontSize.disabled = true;
            document.StoreSettingForm.storeNameFontColor.disabled = true;

            document.StoreSettingForm.storeTitleFont.disabled = true;
            document.StoreSettingForm.storeTitleFontSize.disabled = true;
            document.StoreSettingForm.storeTitleFontColor.disabled = true;

            document.StoreSettingForm.storeDescFont.disabled = true;
            document.StoreSettingForm.storeDescFontSize.disabled = true;
            document.StoreSettingForm.storeDescFontColor.disabled = true;

            document.StoreSettingForm.storeAdvancedTheme.disabled = false;
            document.StoreSettingForm.storeAdvancedThemeColor.disabled = false;
        }
    }
</@script>

  <#if parameters.ebayStore?has_content>
    <#assign ebayStore = parameters.ebayStore!>
    <#--${ebayStore}-->
    <form name="StoreSettingForm" id="StoreSettingForm" method="post" action="<@ofbizUrl>editEbayStoreDetail</@ofbizUrl>">
        <input type="hidden" name="themeType" value="${themeType!}"/>
        <input type="hidden" name="storeUrl" value="${ebayStore.storeUrl!}"/>
        <input type="hidden" name="storeLogoId" value="${ebayStore.storeLogoId!}"/>
        <input type="hidden" name="storeLogoName" value="${ebayStore.storeLogoName!}"/>
        <input type="hidden" name="productStoreId" value="${parameters.productStoreId!}"/>
      <fieldset>
      
      <@fields type="default">
            <@field type="input" label=uiLabelMap.EbayStoreStoreName>
                <@field type="input" name="storeName" value="${ebayStore.storeName!}" events={"keydown":"countAreaChars(document.StoreSettingForm.storeName,35,document.getElementById('charsleft1'));",
                    "keyup":"countAreaChars(document.StoreSettingForm.storeName,35,document.getElementById('charsleft1'));"} />
                <div id="charsleft1"></div>
            </@field>
            <@field type="generic" label=uiLabelMap.EbayStoreStoreDesc>
                <@field type="textarea" rows="4" cols="80" name="storeDesc"
                    events={"keydown":"countAreaChars(document.StoreSettingForm.storeDesc,300,document.getElementById('charsleft2'));", 
                    "keyup":"countAreaChars(document.StoreSettingForm.storeDesc,300,document.getElementById('charsleft2'));"}>${ebayStore.storeDesc!}</@field>
                <div id="charsleft2"></div>
            </@field>
            <@field type="display" label=uiLabelMap.EbayStoreStoreURL>
                <a href="${ebayStore.storeUrl!}" target="_blank">${ebayStore.storeUrl!}</a>
            </@field>
            <@field type="input" label=uiLabelMap.EbayStoreStoreLogoURL name="storeLogoURL" size="50" value="${ebayStore.storeLogoURL!}"/>
            <@field type="generic" label="">
               <@field type="radio" name="storeThemeType" checked=(themeType! == "Basic") value="Basic" onClick="javascript:switchTheme();" label="Basic Theme" /> <#-- default="default" -->
               <@field type="radio"  name="storeThemeType" checked=(themeType! == "Advanced") value="Advanced" onClick="javascript:switchTheme();" label="Advanced Theme" /> 
            </@field>
            <#-- advance Theme -->
             <@field type="select" label=uiLabelMap.EbayStoreStoreAdvancedTheme id="storeAdvancedTheme" name="storeAdvancedTheme">
               <#if storeAdvanceThemeOptList?has_content>
                 <#list storeAdvanceThemeOptList as storeAdvanceThemeOpt>
                    <option value="${storeAdvanceThemeOpt.storeThemeId!}"
                    <#if ebayStore.storeThemeId.equals(storeAdvanceThemeOpt.storeThemeId!)>selected="selected"</#if>>
                    ${storeAdvanceThemeOpt.storeThemeName!}</option>
                  </#list>
               </#if>
             </@field>
            <#if storeAdvancedThemeColorOptList?has_content>
            <@field type="select" label=uiLabelMap.EbayStoreStoreAdvancedThemeColor name="storeAdvancedThemeColor">
              <#list storeAdvancedThemeColorOptList as storeAdvancedThemeColorOpt>
                <option value="${storeAdvancedThemeColorOpt.storeColorSchemeId!}"
                <#if ebayStore.storeColorSchemeId.equals(storeAdvancedThemeColorOpt.storeColorSchemeId!)>selected="selected"</#if>>
                ${storeAdvancedThemeColorOpt.storeColorName!}</option>
              </#list>
            </@field>
            </#if>
            <#-- Basic Theme -->
            <@field type="generic" label=uiLabelMap.EbayStoreStoreBasicTheme>
                <#assign currentStoreThemeIdAndSchemeId = ebayStore.storeThemeId?string+"-"+ebayStore.storeColorSchemeId?string>
                <@field type="select" id="storeBasicTheme" name="storeBasicTheme" onChange="javascript:retrieveThemeColorSchemeByThemeId('<@ofbizUrl>retrieveThemeColorSchemeByThemeId</@ofbizUrl>',this.value,'${parameters.productStoreId!}');">
                  <#if storeThemeOptList?has_content>
                    <#list storeThemeOptList as storeThemeOpt>
                      <#assign storeThemeIdAndSchemeId = storeThemeOpt.storeThemeId+"-"+storeThemeOpt.storeColorSchemeId>
                      <option value="${storeThemeIdAndSchemeId!}" 
                        <#if currentStoreThemeIdAndSchemeId == storeThemeIdAndSchemeId!>selected="selected"</#if>>
                        ${storeThemeOpt.storeColorSchemeName!}
                      </option>
                    </#list>
                  </#if>
                </@field>
                <div id="loading"></div>
            </@field>
            <@field type="display" label="">
                <b>${uiLabelMap.EbayStoreStoreColorTheme}</b>
            </@field>
            <@field type="generic" label=uiLabelMap.EbayStoreStorePrimaryColor>
                ${uiLabelMap.CommonNbr}<@field type="input" inline=true id="storePrimaryColor" name="storePrimaryColor" size="10" value="${ebayStore.storeColorPrimary!}"/>
            </@field>
            <@field type="generic" label=uiLabelMap.EbayStoreStoreSecondColor>
                ${uiLabelMap.CommonNbr}<@field type="input" inline=true id="storeSecondaryColor" name="storeSecondaryColor" size="10" value="${ebayStore.storeColorSecondary!}"/>
            </@field>
            <@field type="generic" label=uiLabelMap.EbayStoreStoreAccentColor>
                ${uiLabelMap.CommonNbr}<@field type="input" inline=true id="storeAccentColor" name="storeAccentColor" size="10" value="${ebayStore.storeColorAccent!}"/>
            </@field>
      </@fields>

      <@fields type="default-manual">
        <#-- TODO? convert? -->
        <@table type="fields"> <#-- orig: class="basic-table" --> <#-- orig: cellspacing="0" -->
            <@tr>
              <@td align="right" valign="middle">${uiLabelMap.EbayStoreStoreChangeFont}</@td>
              <@td valign="middle">
                <@table type="fields" class="+${styles.table_spacing_tiny_hint!}" width="450"> <#-- orig: class="" --> <#-- orig: cellspacing="" -->
                    <@tr>
                        <@td><b>Font</b></@td>
                        <@td><b>Font size</b></@td>
                        <@td><b>Font color</b></@td>
                    </@tr>
                </@table>
              </@td>
            </@tr>
            <@tr>
              <@td align="right" valign="middle">${uiLabelMap.EbayStoreStoreName}</@td>
              <@td valign="middle">
               <#if storeFontTheme??>
                    <#if ebayStore.storeNameColor??>
                        <#assign storeFontColor = ebayStore.storeNameColor!>
                    <#else>
                        <#assign storeFontColor = storeFontTheme.storeFontTypeNameFaceColor!>
                    </#if>
                    <@table type="fields" class="+${styles.table_spacing_tiny_hint!}" width="450"> <#-- orig: class="" --> <#-- orig: cellspacing="" -->
                        <@tr>
                            <@td>
                                <@field type="select" id="storeNameFont" name="storeNameFont">
                                    <#list storeFontTheme.storeFontTypeFontFaceList as storeFontTypeFontFace>
                                        <option <#if storeFontTypeFontFace.storeFontValue.equals(ebayStore.storeNameFontFace)>selected="selected"</#if> value="${storeFontTypeFontFace.storeFontName!}">${storeFontTypeFontFace.storeFontName!}</option>
                                    </#list>
                                </@field>
                            </@td>
                            <@td>
                                <@field type="select" id="storeNameFontSize" name="storeNameFontSize">
                                    <#list storeFontTheme.storeFontTypeSizeFaceList as storeFontTypeSizeFace>
                                        <option <#if storeFontTypeSizeFace.storeFontSizeValue.equals(ebayStore.storeNameFontFaceSize)>selected="selected"</#if> value="${storeFontTypeSizeFace.storeFontSizeName!}">${storeFontTypeSizeFace.storeFontSizeName!}</option>
                                    </#list>
                                </@field>
                            </@td>
                            <@td>
                                ${uiLabelMap.CommonNbr}<field  id="storeNameFontColor" type="input" container=false size="10" name="storeNameFontColor" value="${storeFontColor!}"/>
                            </@td>
                        </@tr>
                    </@table>
                    </#if>
              </@td>
            </@tr>
            <@tr>
              <@td align="right" valign="middle">${uiLabelMap.EbayStoreStoreSectionTitle}</@td>
              <@td valign="middle">
               <#if storeFontTheme??>
                    <#if ebayStore.storeTitleColor??>
                        <#assign storeTitleColor = ebayStore.storeTitleColor!>
                    <#else>
                        <#assign storeTitleColor = storeFontTheme.storeFontTypeTitleColor!>
                    </#if>
                    <@table type="fields" class="+${styles.table_spacing_tiny_hint!}" width="450"> <#-- orig: class="" --> <#-- orig: cellspacing="" -->
                        <@tr>
                            <@td>
                                <@field type="select" id="storeTitleFont" name="storeTitleFont">
                                    <#list storeFontTheme.storeFontTypeFontTitleList as storeFontTypeFontTitle>
                                        <option <#if storeFontTypeFontTitle.storeFontValue.equals(ebayStore.storeTitleFontFace)>selected="selected"</#if> value="${storeFontTypeFontTitle.storeFontName!}">${storeFontTypeFontTitle.storeFontName!}</option>
                                    </#list>
                                </@field>
                            </@td>
                            <@td>
                                <@field type="select" id="storeTitleFontSize" name="storeTitleFontSize">
                                    <#list storeFontTheme.storeFontSizeTitleList as storeFontSizeTitle>
                                        <option <#if storeFontSizeTitle.storeFontSizeValue.equals(ebayStore.storeTitleFontFaceSize)>selected="selected"</#if> value="${storeFontSizeTitle.storeFontSizeName!}">${storeFontSizeTitle.storeFontSizeName!}</option>
                                    </#list>
                                </@field>
                            </@td>
                            <@td>
                                ${uiLabelMap.CommonNbr}<input id="storeTitleFontColor" type="text" size="10" name="storeTitleFontColor" value="${storeTitleColor!}"/>
                            </@td>
                        </@tr>
                    </@table>
                    </#if>
              </@td>
            </@tr>
            <@tr>
              <@td align="right" valign="middle">${uiLabelMap.EbayStoreStoreDesc}</@td>
              <@td valign="middle">
              <#if storeFontTheme??>
                    <#if ebayStore.storeDescColor??>
                        <#assign storeDescColor = ebayStore.storeDescColor!>
                    <#else>
                        <#assign storeDescColor = storeFontTheme.storeFontTypeDescColor!>
                    </#if>
                    <@table type="fields" class="+${styles.table_spacing_tiny_hint!}" width="450"> <#-- orig: class="" --> <#-- orig: cellspacing="" -->
                        <@tr>
                            <@td>
                                <@field type="select" id="storeDescFont" name="storeDescFont">
                                    <#list storeFontTheme.storeFontTypeFontDescList as storeFontTypeFontDesc>
                                        <option <#if storeFontTypeFontDesc.storeFontValue.equals(ebayStore.storeDescFontFace!)>selected="selected"</#if> value="${storeFontTypeFontDesc.storeFontName!}">${storeFontTypeFontDesc.storeFontName!}</option>
                                    </#list>
                                </@field>
                            </@td>
                            <@td>
                                <@field type="select" id="storeDescFontSize" name="storeDescFontSize">
                                    <#list storeFontTheme.storeDescSizeList as storeDescSize>
                                        <option <#if storeDescSize.storeFontSizeValue.equals(ebayStore.storeDescSizeCode)>selected="selected"</#if> value="${storeDescSize.storeFontSizeName!}">${storeDescSize.storeFontSizeName!}</option>
                                    </#list>
                                </@field>
                            </@td>
                            <@td>
                                ${uiLabelMap.CommonNbr}<@field id="storeDescFontColor" container=false type="input" size="10" name="storeDescFontColor" value="${storeDescColor!}"/>
                            </@td>
                        </@tr>
                    </@table>
                    </#if>
              </@td>
            </@tr>
        </@table>
      </@fields>

      <@fields type="default">
        <@field type="select" label=uiLabelMap.EbayStoreStoreHeaderDisplay id="storeCustomHeaderLayout" name="storeCustomHeaderLayout">
            <#list ebayStore.storeCustomHeaderLayoutList as storeCustomHeaderLayout>
               <option <#if storeCustomHeaderLayout.storeCustomHeaderLayoutValue.equals(ebayStore.storeCustomHeaderLayout)>selected="selected"</#if> value="${storeCustomHeaderLayout.storeCustomHeaderLayoutName!}">${storeCustomHeaderLayout.storeCustomHeaderLayoutValue!}</option>
            </#list>
        </@field>
        <@field type="textarea" label="" rows="8" cols="40" name="storeCustomHeader">${ebayStore.storeCustomHeader!}</@field>
        <@field type="select" label=uiLabelMap.EbayStoreStoreHeaderStyle id="storeHeaderStyle" name="storeHeaderStyle">
            <#list ebayStore.storeHeaderStyleList as storeHeaderStyle>
               <option <#if storeHeaderStyle.storeHeaderStyleValue.equals(ebayStore.storeHeaderStyle)>selected="selected"</#if> value="${storeHeaderStyle.storeHeaderStyleName!}">${storeHeaderStyle.storeHeaderStyleValue!}</option>
            </#list>
        </@field>
        <#--tr>
          <@td align="right" valign="middle">Home Page :</@td>
          <@td valign="middle">
                <input type="text" id="homePage" name="homePage" value="${ebayStore.storeHomePage!}"/>
          </@td>
        </tr-->
        <@field type="select" label=uiLabelMap.EbayStoreStoreItemListDesplay id="storeItemLayout" name="storeItemLayout">
            <#list ebayStore.storeItemLayoutList as storeItemLayout>
               <option <#if storeItemLayout.storeItemLayoutValue.equals(ebayStore.storeItemLayoutSelected)>selected="selected"</#if> value="${storeItemLayout.storeItemLayoutName!}">${storeItemLayout.storeItemLayoutValue!}</option>
            </#list>
        </@field>
        <@field type="select" label=uiLabelMap.EbayStoreStoreItemSortOrder id="storeItemSortOrder" name="storeItemSortOrder">
            <#list ebayStore.storeItemSortOrderList as storeItemSortOrder>
               <option <#if storeItemSortOrder.storeItemSortLayoutValue.equals(ebayStore.storeItemSortOrderSelected)>selected="selected"</#if> value="${storeItemSortOrder.storeItemSortLayoutName!}">${storeItemSortOrder.storeItemSortLayoutValue!}</option>
            </#list>
        </@field>
        <#--tr>
          <@td align="right" valign="middle">Custom Listing Header Display :</@td>
          <@td valign="middle">
            <select id="storeCustomListingHeaderDisplay" name="storeCustomListingHeaderDisplay">
                <#list ebayStore.storeCustomListingHeaderDisplayList as storeCustomListingHeaderDisplay>
                    <option <#if storeCustomListingHeaderDisplay.storeCustomHeaderLayoutValue.equals(ebayStore.storeCustomListingHeaderDisplayValue)>selected="selected"</#if> value="${storeCustomListingHeaderDisplay.storeCustomHeaderLayoutValue!}">${storeCustomListingHeaderDisplay.storeCustomHeaderLayoutValue!}</option>
                </#list>
            </select>
          </@td>
        </tr-->
        <@field type="select" label=uiLabelMap.EbayStoreStoreMerchDisplay id="storeMerchDisplay" name="storeMerchDisplay">
            <#list ebayStore.storeMerchDisplayList as storeMerchDisplay>
               <option <#if storeMerchDisplay.merchDisplayCodeValue.equals(ebayStore.storeMerchDisplay)>selected="selected"</#if> value="${storeMerchDisplay.merchDisplayCodeName!}">${storeMerchDisplay.merchDisplayCodeValue!}</option>
            </#list>
        </@field>
        <@field type="select" label=uiLabelMap.EbayStoreStoreSubscriptionLevel id="storeMerchDisplay" name="storeSubscriptionDisplay">
            <#list ebayStore.storeSubscriptionLevelList as storeSubscriptionLevel>
               <option <#if storeSubscriptionLevel.storeSubscriptionLevelCodeValue.equals(ebayStore.storeSubscriptionLevel)>selected="selected"</#if> value="${storeSubscriptionLevel.storeSubscriptionLevelCodeName!}">${storeSubscriptionLevel.storeSubscriptionLevelCodeValue!}</option>
            </#list>
        </@field>
        <@field type="submit" text=uiLabelMap.CommonSubmit name="submitButton" class="+${styles.link_run_sys!} ${styles.action_update!}" />

        <@script>
            document.getElementById('charsleft1').innerHTML =  (35 - document.StoreSettingForm.storeName.value.length)  + " charactors left.";
            document.getElementById('charsleft2').innerHTML =  (300 - document.StoreSettingForm.storeDesc.value.length)  + " charactors left.";
        </@script>

      </@fields>

      </fieldset>
    </form>
  </#if>
<@script>
    <#if themeType! == "Basic">
        document.StoreSettingForm.storeAdvancedTheme.disabled = true;
        document.StoreSettingForm.storeAdvancedThemeColor.disabled = true;
    <#elseif themeType! == "Advanced">
        document.StoreSettingForm.storeBasicTheme.disabled = true;
        document.StoreSettingForm.storePrimaryColor.disabled = true;
        document.StoreSettingForm.storeSecondaryColor.disabled = true;
        document.StoreSettingForm.storeAccentColor.disabled = true;
        
        document.StoreSettingForm.storeNameFont.disabled = true;
        document.StoreSettingForm.storeNameFontSize.disabled = true;
        document.StoreSettingForm.storeNameFontColor.disabled = true;
        
        document.StoreSettingForm.storeTitleFont.disabled = true;
        document.StoreSettingForm.storeTitleFontSize.disabled = true;
        document.StoreSettingForm.storeTitleFontColor.disabled = true;
        
        document.StoreSettingForm.storeDescFont.disabled = true;
        document.StoreSettingForm.storeDescFontSize.disabled = true;
        document.StoreSettingForm.storeDescFontColor.disabled = true;
    </#if>
</@script>