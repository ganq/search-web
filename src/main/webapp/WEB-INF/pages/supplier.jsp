<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://mysoft.com/taglib/domain" prefix="my" %>
<%@ taglib uri="http://mysoft.com/taglib/page" prefix="p" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>    
<%@ taglib uri="http://mysoft.com/taglib/search/util" prefix="t" %>
<%@ taglib uri="http://mysoft.com/taglib/includeHtml" prefix="html" %>
<!DOCTYPE html>
<html>
	<head>
	<meta mame="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

    <c:set var="metaDesc" value="${desc}"/>
    <c:set var="metaKeywords" value="${keyword}"/>
    <c:set var="pageTitle" value="${title}"/>

	<meta name="description" content="${metaDesc }" />
	<meta name="keywords" content="${metaKeywords }" />
    <meta id="shareContent" summary="{{meta|description}}" pic="{{$|.tender_list .tender_view img:eq(0)|#header .logo img}}" >
    <title>${pageTitle }</title>
	<script src='<my:link domain="jcs.static" uri="/res1.5/js/common/jquery-1.10.2.min.js" />'></script>
	<link href="<my:link domain="jcs.static" uri="/res1.5/plugins/backTools/backTools.css"/>" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/common.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/layout.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/module/forms.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/module/tables.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/web/page/search_global.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/web/page/search_supplier.css" />" rel="stylesheet"/>
	<link rel="shortcut icon" href='<my:link domain="jcs.static" uri="/favicon.ico" />' type="image/x-icon" />
	<link rel="icon" href='<my:link domain="jcs.static" uri="/favicon.ico" />' type="image/x-icon" />
	<script type="text/javascript">
		$(function(){
			$("#searchTxt").val("${encodeKeyword}");
		});
	</script>
	</head>
	<c:set value="${totalRecordNum}" var="resultSize"/>
	<c:set var="appendKeyword" value="?keyword="/>
	<c:if test="${not empty supplierParam.keyword}">
		<c:set var="appendKeyword" value="?keyword=${t:urlEncode(supplierParam.keyword)}"/>
	</c:if>
	
	
	<c:if test="${not empty supplierParam.codeKeyLevel1 }">
		<c:set var="appendcodeKey1" value="/${supplierParam.codeKeyLevel1}"/>
	</c:if>
	<c:if test="${not empty supplierParam.codelevel2 }">
		<c:set var="appendcode2" value="-${supplierParam.codelevel2}"/>
	</c:if>
	<c:if test="${not empty supplierParam.codelevel3 }">
		<c:set var="appendcode3" value="-${supplierParam.codelevel3}"/>
	</c:if>
	<c:if test="${not empty supplierParam.location }">
		<c:set var="appendLocation" value="&location=${t:escapeHtml(supplierParam.location)}"/>
	</c:if>
	<c:if test="${not empty supplierParam.year }">
		<c:set var="appendYear" value="&year=${t:escapeHtml(supplierParam.year)}"/>
	</c:if>
	<c:if test="${not empty supplierParam.registeredcapital }">
		<c:set var="appendRegcapital" value="&registeredcapital=${t:escapeHtml(supplierParam.registeredcapital)}"/>
	</c:if>
	<c:if test="${not empty supplierParam.qualification }">
		<c:set var="appendQualification" value="&qualification=${t:escapeHtml(supplierParam.qualification)}"/>
	</c:if>
	<c:if test="${not empty supplierParam.qualificationLevel }">
		<c:set var="appendQualificationLevel" value="&qualificationLevel=${t:escapeHtml(supplierParam.qualificationLevel)}"/>
	</c:if>
	<c:if test="${not empty supplierParam.yearsort }">
		<c:set var="appendYearsort" value="&yearsort=${t:escapeHtml(supplierParam.yearsort)}"/>
	</c:if>
	<c:if test="${not empty supplierParam.regsort }">
		<c:set var="appendRegsort" value="&regsort=${t:escapeHtml(supplierParam.regsort)}"/>
	</c:if>
	<c:set var="pageKey" value="supplier" />
	<c:if test="${empty appendcode2 }">
		<c:set var="urlItem" value="/${pageKey}${appendcodeKey1 }.html${appendKeyword}&codelevel3=${supplierParam.codelevel3}"/>
	</c:if>
	<c:if test="${not empty appendcode2 }">
		<c:set var="urlItem" value="/${pageKey}${appendcodeKey1 }${appendcode2 }${appendcode3 }.html${appendKeyword}"/>
	</c:if>
	
	<c:set var="pageUrl" scope="request" value="${urlItem}${appendLocation }${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }${appendYearsort }${appendRegsort }"/>
	<body data-allcount="${totalRecordNum }">
	<html:include page="top"/>
	<html:include page="nav"/>
    <div id="content" class="container clear">
    	<div class="wrap">
    	<c:if test="${not empty relatedCategory}">
        <div class="sidebar">
            <h3>所有类目</h3>
            <ul id="sidebarList" class="sidebar_list ${empty supplierParam.keyword?'sidebar_dblist':'' }">
            	<c:forEach items="${relatedCategory}" var="rc" varStatus="rci">
            	<c:set value="" var="category_show"/>
				<c:if test="${(not empty supplierParam.codelevel2 and rc.code == currentCategoryCode) or (not empty supplierParam.codelevel1 and rc.code == supplierParam.codelevel1)}">
					<c:set value="active" var="category_show"/>
				</c:if>
				<c:if test="${empty supplierParam.codelevel2 and empty supplierParam.codelevel1 }">
					<c:set value="active" var="first_category_show"/>
				</c:if>
                <li class="${category_show} ${rci.first?first_category_show:'' }">
                    <h3><em></em>
                    <a href="/${pageKey}/${rc.pinyin }.html${not empty supplierParam.keyword?appendKeyword:''}" title ="${rc.name}">${rc.name}<c:if test="${not empty supplierParam.keyword }">(${rc.count })</c:if></a>
                    </h3>
                    <ul>
                    <c:forEach  items="${rc.childrenList }" var="rcc" varStatus="rcci">
                    <li class="${supplierParam.codelevel2 == rcc.code?'active':''}" ${not empty supplierParam.keyword?'style="float:none;width:100%"':'' }>
                    	<a href="/${pageKey}/${rc.pinyin }-${rcc.code }.html${not empty supplierParam.keyword?appendKeyword:''}" 
                    	title="${rcc.name}">${rcc.name}<c:if test="${not empty supplierParam.keyword }"><em>(${rcc.count })</em></c:if></a>
                    </li>
                    </c:forEach>
                    </ul>
                </li>
                </c:forEach>
           </ul>
           <%@include file="common/adPosition.jsp"%>
        </div>
        <div class="content">
        	
    		<c:if test="${not empty supplierParam.keyword }">
    			<div class="search_condition"><strong>${fn:escapeXml(supplierParam.keyword) }</strong>（共 <em>${totalRecordNum}</em> 个结果）</div>
    		</c:if>
    		
    		<c:if test="${empty supplierParam.keyword and (not empty supplierParam.codelevel1 or not empty supplierParam.codelevel2)}">
    			<div class="search_condition">默认筛选（共 <em>${totalRecordNum}</em> 个结果）</div>
    		</c:if>
			
			<c:if test="${not empty level3Category }">
			<div class="serarch_content ${isExpand?'unfold':''}" id="level3CategoryDiv" >
				<div class="scroll">
					<ul class="clear">
						<c:forEach items="${level3Category }" var="l3c">
							<c:if test="${empty appendcode2 }">
								<c:set var="lvl3Url" value="/${pageKey}${appendcodeKey1 }.html${appendKeyword}&codelevel3=${l3c.code }"/>
							</c:if>
							<c:if test="${not empty appendcode2 }">
								<c:set var="lvl3Url" value="/${pageKey}${appendcodeKey1 }${appendcode2 }-${l3c.code }.html${not empty supplierParam.keyword?appendKeyword:''}"/>
							</c:if>
						
							<li title="${l3c.name }<c:if test="${not empty supplierParam.keyword }">(${l3c.count })</c:if>"><a class="${t:arrayContains(fn:split(supplierParam.codelevel3,','),l3c.code)?'active':'' }" 
							href="${lvl3Url }">${l3c.name }
							<em>(${l3c.count })</em>
							</a></li>
						</c:forEach> 
					</ul>
				</div>
				<c:if test="${fn:length(level3Category) > 15 }">
					<div class="view_more"><a href="javascript:;" class="">${isExpand?'收起':'查看更多' }</a></div>
				</c:if>
				<div class="clear"></div>
			</div>
			</c:if>
			<c:if test="${not empty recommendWords }">
				<div style="margin-bottom: 10px;background:#F8FAC1;padding: 0 0 0 15px;border:1px solid #d2d2d2;line-height: 30px; ">
				<span style="color: red">您可能想找：</span>
				<c:forEach items="${recommendWords }" var="rw">
					<a href='<my:link uri="/supplier.html?keyword=${t:urlEncode(rw) }" domain="mainpage"></my:link>'>${rw }</a>&nbsp;
				</c:forEach>
				</div>
			</c:if>
			<div class="table_info">
				<div class="search_table" id="search-table">
					<label class="search_label">
						<span class="filter_span">服务覆盖</span>
						<div class="filter down-list">
							<div class="txt_common areadl_input">
			              		<label title="${currentLocation }">${currentLocation }</label>
			              		<i></i>
			              	</div>
			              	
			              	<div class="areadl_wrap" style="">
			              		<span><a class="areadl_select" href="${urlItem }&location=china${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }">全国</a></span>
			              		<span class="areadl_right"><a class="areadl_select" href="${urlItem }${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }">不限</a></span>
			              		
			              		<c:forEach items="${regionArea }" var="area" varStatus="ai">
			              		<h4><span>${area.key }</span></h4>
			              		<ul class="areadl_list clear">
			              			<c:forEach items="${area.value }" var="province" varStatus="pi">
			              				<li >
			              					<a href="${urlItem }&location=${province.code }${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }">${province.name }${empty province.childRegionNodes?'':'<i></i>'}</a>
			              					<c:if test="${not empty province.childRegionNodes }">
				              					<ul>
				              					<c:forEach items="${province.childRegionNodes }" var="city">
				              						<li><a href="${urlItem }&location=${city.code }${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }">${city.name }</a></li>
				              					</c:forEach>
				              					</ul>
			              					</c:if>
			              				</li>
			              			</c:forEach>
			              		</ul>
			              		</c:forEach>
			              	</div>			            
			          </div>
			          <span class="filter_span">${currentLocation eq "全国" ? "范围" : "全境" }</span>
			        </label>
			        <c:if test="${(not empty supplierParam.codelevel2 or not empty supplierParam.codelevel3) and not empty relatedQualification}">
						<label class="search_label" style="border-right:none ">
							<span class="filter_span">资质</span>
							<div class="aptitude down-list">
								<div class="txt_common inputbox">
									<label title="${currentQualification }">${currentQualification }</label>
									<span class="triangle fr"></span>
								</div>
								<div class="listbox" style="display: none;">
									<ul>
										<li><a href="${urlItem }${appendLocation }${appendYear }${appendRegcapital }">不限</a></li>
										<c:forEach items="${relatedQualification }" var="rq">
											<li><a href="${urlItem }${appendLocation }${appendYear }${appendRegcapital }&qualification=${rq.qualificationCode }">${rq.qualificationName }</a></li>
										</c:forEach>
									</ul>
								</div>
							</div>
						</label>
						<label class="search_label" >
							<span class="filter_span">等级≥</span>
							<div class="aptitude down-list">
								<div class="txt_common inputbox" style="width:50px">
									<label title="${currentQualificationLevel }" style="width: 50%">${currentQualificationLevel }</label>
									<span class="triangle fr"></span>
								</div>
								<div class="listbox" style="display: none;">
									<ul>
										<li><a href="${urlItem }${appendLocation }${appendYear }${appendRegcapital }${appendQualification }">不限</a></li>
										<c:forEach items="${relatedQualificationLevel }" var="rq">
											<li><a href="${urlItem }${appendLocation }${appendYear }${appendRegcapital }&qualification=${rq.qualificationCode }&qualificationLevel=${rq.levelCode }">${rq.levelName }</a></li>
										</c:forEach>
									</ul>
								</div>
							</div>
						</label>
					</c:if>
					<label class="search_label">
						<span class="filter_span">注册资本≥</span>
						<div class="fund down-list">
							<div class="txt_common inputbox regcatitalFilter">
								<label style="display: inline-block;" title="${currentRegcapital }">${currentRegcapital }</label>
								<span class="fr" style="display: none;"></span>
								<input id="regcapitalTxt"  type="text" value="${currentRegcapital eq '不限'?'':currentRegcapital  }" style="display: none;" onkeydown="javascript:if(event.keyCode==13) regSure(this.value);"
								t_value="" o_value="" onkeypress="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onkeyup="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onblur="if(!this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?|\.\d*?)?$/))this.value=this.o_value;else{if(this.value.match(/^\.\d+$/))this.value=0+this.value;if(this.value.match(/^\.$/))this.value=0;this.o_value=this.value}">
							</div>
							<div class="listbox" style="display: none;">
								<a href="javsscript:;" class="butt_subm" id="regcapitalSureBtn">确定</a>
							</div>
         					</div>
         					<span class="filter_span">万元</span>
         				</label>
         				
         			<label class="search_label">
						<span class="filter_span">成立年限≥</span>
						<div class="fund down-list">
							<div class="txt_common inputbox regcatitalFilter">
								<label style="display: inline-block;" title="${currentEstablishYear}">${currentEstablishYear }</label>
								<span class="fr" style="display: none;"></span>
								<input id="yearTxt"  type="text" value="${currentEstablishYear eq '不限'?'':currentEstablishYear  }" style="display: none;" onkeydown="javascript:if(event.keyCode==13) yearSure(this.value);" 
								t_value="" o_value="" onkeypress="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onkeyup="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onblur="if(!this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?|\.\d*?)?$/))this.value=this.o_value;else{if(this.value.match(/^\.\d+$/))this.value=0+this.value;if(this.value.match(/^\.$/))this.value=0;this.o_value=this.value}">
							</div>
							<div class="listbox" style="display: none;">
								<a href="javascript:;" class="butt_subm" id="yearSureBtn">确定</a>
							</div>
         					</div>
         					<span class="filter_span">年</span>
         				</label>
					<label class="search_label" style="float: right">
						<a class="btn_common btn_silvery btn_size_30 btn_reset"  href="/${pageKey}${appendcodeKey1 }${appendcode2 }.html${appendKeyword}">清空</a>
					</label>
				</div>
				<div class="search_table search_sort">
         <label class="search_label" style="border-right:none ">
							<c:set var="rsort" value=""/>
							<c:set var="ysort" value=""/>
							<c:if test="${(empty supplierParam.regsort or supplierParam.regsort=='0') }">
								<c:set var="rsort" value="regsort=1"/>
							</c:if>
							<c:if test="${supplierParam.regsort=='1' }"><c:set var="rsort" value="regsort=0"/></c:if>
							<c:if test="${(empty supplierParam.yearsort or supplierParam.yearsort=='0') }">
								<c:set var="ysort" value="yearsort=1"/>
							</c:if>
							<c:if test="${supplierParam.yearsort=='1' }"><c:set var="ysort" value="yearsort=0"/></c:if>
							
										
						 
						<c:if test="${empty supplierParam.yearsort }">
							<c:set var="yeariconClass" value="spanicon2"/>
							<c:set var="yeariconTitle" value="降"/>
						</c:if>
						<c:if test="${supplierParam.yearsort == '0'}">
							<c:set var="yeariconClass" value="spanicon3"/>
							<c:set var="yeariconTitle" value="降"/>
						</c:if>
						<c:if test="${supplierParam.yearsort == '1'}">
							<c:set var="yeariconClass" value="spanicon4"/>
							<c:set var="yeariconTitle" value="升"/>
						</c:if>
						
						<c:if test="${empty supplierParam.regsort }">
							<c:set var="regiconClass" value="spanicon2"/>
							<c:set var="regiconTitle" value="降"/>
						</c:if>
						<c:if test="${supplierParam.regsort == '0'}">
							<c:set var="regiconClass" value="spanicon3"/>
							<c:set var="regiconTitle" value="降"/>
						</c:if>
						<c:if test="${supplierParam.regsort == '1'}">
							<c:set var="regiconClass" value="spanicon4"/>
							<c:set var="regiconTitle" value="升"/>
						</c:if>
						<c:if test="${not empty supplierParam.keyword}">
						<a href="${urlItem }${appendLocation }${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }" 
						style="display: inline-block;vertical-align: bottom;" 
						class="${(empty supplierParam.yearsort and empty supplierParam.regsort)?'btn_common btn_orange btn_size_30':'' }">
						相关度</a>
						</c:if>
						<a href="${urlItem }${appendLocation }${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }&${rsort }" 
						style="display: inline-block;vertical-align: bottom;" title="点击后按照注册资本${regiconTitle }序排列"
						class="${(not empty supplierParam.regsort)?'btn_common btn_orange btn_size_30':'' }">
						注册资本<span class='${regiconClass }'></span></a>
					
						<a href="${urlItem }${appendLocation }${appendYear }${appendRegcapital }${appendQualification }${appendQualificationLevel }&${ysort }" 
						style="display: inline-block;vertical-align: bottom;" title="点击后按照成立年份${yeariconTitle }序排列"
						class="${(not empty supplierParam.yearsort)?'btn_common btn_orange btn_size_30':'' }">
						成立年份<span class="${yeariconClass}"></span></a>
						
					</label>
        		</div>
				
				<div class="supplier_cont">
					<ul class="supplier_list">
					<c:forEach items="${searchResult}" var="elem">
					<li>
						<div class="supplier_left">
							<h3><c:if test="${not empty elem.supplierType }"><i>${elem.supplierType }</i></c:if><a href="${empty elem.supplierUrl?'javascript:;':elem.supplierUrl }" target="_blank">${elem.companyName}</a></h3>
							<p class="supplier_split ${fn:length(fn:escapeXml(elem.legalName)) > 0 ? '':'no_corp' }">
								<c:if test="${fn:length(fn:escapeXml(elem.legalName)) > 0 }"><span class="supplier_split_name">公司法人：${fn:escapeXml(elem.legalName) }</span></c:if>
								<span class="supplier_split_date">成立年份：${fn:escapeXml(elem.establishYear) }</span>
								<span class="supplier_split_capital">注册资本：<c:if test="${elem.regCapital > 0 }">
									<fmt:formatNumber value="${elem.regCapital }" pattern="#,###"/>万元<c:if test="${elem.currency ne '人民币'}">(${elem.currency})</c:if>
								</c:if>
                                <c:if test="${elem.regCapital <= 0 or empty elem.regCapital}">
                                    无需验资
                                </c:if>
								</span>
							</p>
							<p class="service">业务范围：<c:if test="${not empty supplierParam.keyword }">
								${empty elem.businessScope?'无':t:cutHtmlStr(t:splitHlField(elem.businessScope),40) }
							</c:if>
							<c:if test="${empty supplierParam.keyword }">
								${empty elem.businessScope?'无':t:cutStr(elem.businessScope,40) }
							</c:if>
							  
							</p>
							<p class="area">服务区域：${empty elem.projectLocation?'无':t:splitHlField(t:collectionJoinToString(elem.projectLocation,"、")) }</p>
							<p class="address">公司地址：
							<c:choose>
              					<c:when test="${empty elem.regProvinceName and  empty elem.regCityName}">无</c:when>
              					<c:otherwise>
              						<c:if test="${elem.regProvinceName eq elem.regCityName }">${elem.regProvinceName }市${fn:escapeXml(elem.regAddress) }</c:if>
              						<c:if test="${elem.regProvinceName ne elem.regCityName }">${elem.regProvinceName }省${elem.regCityName }市${fn:escapeXml(elem.regAddress) }</c:if>
              					</c:otherwise>
              				</c:choose>
              				</p>
						</div>
						<div class="supplier_middle">
							<dl class="supplier_aptitude">	
								<c:if test="${empty elem.supplierType }">	
								<c:set var="showQual" value="${false }"/>					
								<c:if test="${t:listContains(elem.searchBasicCategoryName,'工程') or t:listContains(elem.searchBasicCategoryName,'勘察设计') or
								t:listContains(elem.searchBasicCategoryName,'服务与咨询')}">
									<dt><strong>资质</strong><span class="c_orange"> (${fn:length(elem.qualificationLevelName) })</span></dt>
									<c:forEach var="elemQl" items="${t:setHlListSort(elem.qualificationLevelName) }" begin="0" end="1">
										<dd title="${t:replaceHtml(elemQl) }">${elemQl }</dd>
									</c:forEach>
									<c:set var="showQual" value="${true }"/>
								</c:if>								
								<c:if test="${!showQual and (t:listContains(elem.searchBasicCategoryName,'材料') or t:listContains(elem.searchBasicCategoryName,'设备') or
								t:listContains(elem.searchBasicCategoryName,'营销与行政'))}">
									<dt><strong>产品</strong><span class="c_orange"> (${fn:length(elem.productName) })</span></dt>
									<c:forEach var="elemQl" items="${t:setHlListSort(elem.productName) }" begin="0" end="1">
										<dd title="${t:replaceHtml(elemQl) }">${elemQl }</dd>
									</c:forEach>
								</c:if>								
								</c:if>
								
								<c:if test="${not empty elem.supplierType }">					
								<c:if test="${elem.supplierType eq '服务' or elem.supplierType eq '工程'}">
									<dt><strong>资质</strong><span class="c_orange"> (${fn:length(elem.qualificationLevelName) })</span></dt>
									<c:forEach var="elemQl" items="${t:setHlListSort(elem.qualificationLevelName) }" begin="0" end="1">
										<dd title="${t:replaceHtml(elemQl) }">${elemQl }</dd>
									</c:forEach>
									
								</c:if>								
								<c:if test="${elem.supplierType eq '厂商' or elem.supplierType eq '总代' or elem.supplierType eq '经销'}">
									<dt><strong>产品</strong><span class="c_orange"> (${fn:length(elem.productName) })</span></dt>
									<c:forEach var="elemQl" items="${t:setHlListSort(elem.productName) }" begin="0" end="1">
										<dd title="${t:replaceHtml(elemQl) }">${elemQl }</dd>
									</c:forEach>
								</c:if>								
								</c:if>
							</dl>
							<dl class="supplier_case">
								<dt><strong>案例</strong><span class="c_orange"> (${fn:length(elem.projectName) })</span></dt>
								<c:forEach var="elemPn" items="${elem.projectName }" begin="0" end="1">
									<dd title="${t:escapeHtml(elemPn) }">${fn:escapeXml(elemPn) }</dd>
								</c:forEach>
							</dl>
						</div>
						<div class="supplier_right">
							<div class="supplier_status hover_show">
								<div class="supplier_honner cardCanClick" style="cursor:pointer" data-url="${empty elem.supplierUrl?'':elem.supplierUrl }">${elem.defaultAward }<div>供应商旗舰店<span></span></div></div>
							</div>
							<div class="supplier_meta">
							<c:if test="${elem.authTag }">
								<span class="supplier_auth">明源审核</span>
							</c:if>
							<c:if test="${elem.medalLevel == 1 }">
           						<span class="supplier_medal">金牌供应商</span>
           					</c:if>
           					<c:if test="${elem.medalLevel == 2 }">
           						<span class="supplier_medal">银牌供应商</span>
           					</c:if>
           					<c:if test="${elem.medalLevel == 3 }">
           						<span class="supplier_medal">铜牌供应商</span>
           					</c:if>
           					<c:if test="${elem.medalLevel == 0}">
           						<span class="supplier_readed" data-pid="${elem.supplierId }">0人已关注</span>
           					</c:if>
							</div>
						</div>
					</li>
	            	</c:forEach>
	            	</ul>
	            	<div class="page_info">
	            		<p:html 
							url="${pageUrl }" 
							pagesize="${supplierParam.pageSize}" 
							page="${supplierParam.page }" 
							allrows="${totalRecordNum}"
							domain="" 
							/>
					</div>
        		</div>
			</div>
			<c:if test="${resultSize <= 0}">
				<div style="text-align:center;margin: 100px 0px">抱歉，没有找到符合条件的记录</div>
		    </c:if>
            
            
        </div>
        
        </c:if>
        </div>
        <c:if test="${empty relatedCategory}">
        <div style="text-align:center;margin: 100px 0px">抱歉，没有找到符合条件的记录</div>
        <c:if test="${not empty recommendWords }">
				<div style="text-align: center;">
				您可能想找：
				<c:forEach items="${recommendWords }" var="rw">
					<a href='<my:link uri="/supplier.html?keyword=${t:urlEncode(rw) }" domain="mainpage"/>'>${rw }</a>
				</c:forEach>
				</div>
			</c:if>
        </c:if>
        </div>
        <div class="search_bottom">
            <form action="/supplier.html" method="get">
	            <label>重新搜索</label>
	            <input type="text" class="txt_common" name="keyword">
	            <input type="submit" class="btn_common" value="搜索">
          	</form>
       	</div>
    	<script src="<my:link domain="jcs.static" uri="/res1.5/plugins/backTools/jquery.backTools.js"/>"></script>
		<script src='<my:link domain="jcs.static" uri="/res1.5/js/web/page/search.js" />'></script>
		<script>
			function yearSure(year){
				location.href = "${urlItem }${appendLocation }&year="+year+"${appendRegcapital}${appendQualification }${appendQualificationLevel }";				
			}
			function regSure(regcapital){
				location.href = "${urlItem }${appendLocation }${appendYear}&registeredcapital="+regcapital+"${appendQualification }${appendQualificationLevel }";
			}
			$(function(){
				$(".areaSelect").click(function(){
					//$(this).addClass("select").siblings("li").removeClass("select");
					$("#areaDiv" + $(this).data("index")).show().siblings(".areaDiv").hide();
				});
				$(".provinceSelect").click(function(){
					$("#provinceDiv" + $(this).data("index")).show().siblings(".provinceDiv").hide();
				});
				$("#regcapitalSureBtn").click(function(){
					regSure($("#regcapitalTxt").val());
					
				});
				
				$("#yearSureBtn").click(function(){
					yearSure($("#yearTxt").val());
					
				});
				$("#level3CategoryDiv>div").scrollTop(parseInt("${scrollLength}",10));
				
				var pvUrl ='<my:link domain="portal" uri="/pv/query.do?pageId=${supplierIds}&pvType=supplier" />';
				$.getJSON(pvUrl +"&callback=?",function(data) {
					$(".supplier_list li .supplier_readed").each(function(k,v) {
						$(this).text(data[$(this).data("pid")] + "人已关注");	
					});
                });

			});     
	        	    
		</script>
		<html:include page="bottom" />	
		
	</body>
</html>