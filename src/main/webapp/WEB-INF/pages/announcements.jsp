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
	
	<link href="<my:link domain="jcs.static" uri="/res1.5/plugins/backTools/backTools.css"/>" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/common.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/layout.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/module/forms.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/module/tables.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/web/page/search_global.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/web/page/search_info.css" />" rel="stylesheet"/>
	<link rel="shortcut icon" href='<my:link domain="jcs.static" uri="/favicon.ico" />' type="image/x-icon" />
	<link rel="icon" href='<my:link domain="jcs.static" uri="/favicon.ico" />' type="image/x-icon" />
	<script src='<my:link domain="jcs.static" uri="/res1.5/js/common/jquery-1.10.2.min.js" />'></script>
    <script src="<my:link domain="jcs.static" uri="/res1.5/plugins/backTools/jquery.backTools.js"/>"></script>
	<script type="text/javascript">
		$(function(){
			$("#searchTxt").val("${encodeKeyword}");
		});
	</script>
	</head>
	<c:set value="${totalRecordNum}" var="resultSize"/>
	<c:set var="appendKeyword" value="?keyword="/>
	<c:if test="${not empty announcementParam.keyword}">
		<c:set var="appendKeyword" value="?keyword=${t:urlEncode(announcementParam.keyword)}"/>		
	</c:if>
	
	<c:if test="${not empty announcementParam.codeKeyLevel1 }">
		<c:set var="appendcodeKey1" value="/${announcementParam.codeKeyLevel1}"/>
	</c:if>
	<c:if test="${not empty announcementParam.codelevel2 }">
		<c:set var="appendcode2" value="-${announcementParam.codelevel2}"/>
	</c:if>
	<c:if test="${not empty announcementParam.codelevel3 }">
		<c:set var="appendcode3" value="-${announcementParam.codelevel3}"/>
	</c:if>
	<c:if test="${not empty announcementParam.location }">
		<c:set var="appendLocation" value="&location=${t:escapeHtml(announcementParam.location)}"/>
	</c:if>
	<c:if test="${not empty announcementParam.state }">
		<c:set var="appendState" value="&state=${t:escapeHtml(announcementParam.state)}"/>
	</c:if>
	<c:if test="${not empty announcementParam.regcapital }">
		<c:set var="appendRegcapital" value="&regcapital=${t:escapeHtml(announcementParam.regcapital)}"/>
	</c:if>
	<c:if test="${not empty announcementParam.qualification }">
		<c:set var="appendQualification" value="&qualification=${t:escapeHtml(announcementParam.qualification)}"/>
	</c:if>
	<c:if test="${not empty announcementParam.qualificationLevel }">
		<c:set var="appendQualificationLevel" value="&qualificationLevel=${t:escapeHtml(announcementParam.qualificationLevel)}"/>
	</c:if>
	<c:if test="${not empty announcementParam.sdatesort }">
		<c:set var="appendSdatesort" value="&sdatesort=${t:escapeHtml(announcementParam.sdatesort)}"/>
	</c:if>
	<c:if test="${not empty announcementParam.pdatesort }">
		<c:set var="appendPdatesort" value="&pdatesort=${t:escapeHtml(announcementParam.pdatesort)}"/>
	</c:if>
	<c:set var="pageKey" value="bidding" />
	<c:if test="${empty appendcode2 }">
		<c:set var="urlItem" value="/${pageKey}${appendcodeKey1 }.html${appendKeyword}&codelevel3=${announcementParam.codelevel3}"/>
	</c:if>
	<c:if test="${not empty appendcode2 }">
		<c:set var="urlItem" value="/${pageKey}${appendcodeKey1 }${appendcode2 }${appendcode3 }.html${appendKeyword}"/>
	</c:if>
	
	<c:set var="pageUrl" scope="request" value="${urlItem}${appendLocation }${appendState }${appendRegcapital }${appendQualification }${appendQualificationLevel }${appendSdatesort }${appendPdatesort }"/>
	<body data-allcount="${totalRecordNum }">
	<html:include page="top"/>
	<html:include page="nav"/>
    <div id="content" class="container clear">
    	<div class="wrap">
    	<c:if test="${not empty relatedCategory}">
        <div class="sidebar">
        	<h3>所有类目</h3>
            	<ul id="sidebarList" class="sidebar_list ${empty announcementParam.keyword?'sidebar_dblist':'' }">
            	<c:forEach items="${relatedCategory}" var="rc" varStatus="rci">
            	<c:set value="" var="category_show"/>
				<c:if test="${(not empty announcementParam.codelevel2 and rc.code == currentCategoryCode) or 
				(not empty announcementParam.codelevel1 and rc.code == announcementParam.codelevel1) }">
					<c:set value="active" var="category_show"/>
				</c:if>
				<c:if test="${empty announcementParam.codelevel2 and empty announcementParam.codelevel1 }">
					<c:set value="active" var="first_category_show"/>
				</c:if>
				
                <li class="${category_show} ${rci.first?first_category_show:'' }"  >
                    <h3><em></em>
                    <a href="/${pageKey}/${rc.pinyin }.html${not empty announcementParam.keyword?appendKeyword:''}" title ="${rc.name}">${rc.name}<c:if test="${not empty announcementParam.keyword }">(${rc.count })</c:if></a>
                    </h3>
                    <ul>
                    <c:forEach  items="${rc.childrenList }" var="rcc" varStatus="rcci">
                    <li class="${announcementParam.codelevel2 == rcc.code?'active':''}">
                    	<a href="/${pageKey}/${rc.pinyin }-${rcc.code }.html${not empty announcementParam.keyword?appendKeyword:''}"                     	
                    	title="${rcc.name}">${rcc.name}<c:if test="${not empty announcementParam.keyword }"><em>(${rcc.count })</em></c:if></a>
                    </li>
                    </c:forEach>
                    </ul>
                </li>
                </c:forEach>
                </ul>
                 <%@include file="common/adPosition.jsp"%>
                <div class="QRcode ADbox mt10">
                	<img src="<my:link domain="jcs.static" uri="/res1.5/img/web/global/qrcode.jpg"/>" alt="云采购服务号">
                </div>
        </div>   
        <div class="content">
       		<c:if test="${not empty announcementParam.keyword }">
    			<div class="search_condition"><strong>${fn:escapeXml(announcementParam.keyword) }</strong>（共 <em>${totalRecordNum}</em> 个结果）</div>
    		</c:if>
    		
    		<c:if test="${(empty announcementParam.keyword) and (not empty announcementParam.codelevel1 or not empty announcementParam.codelevel2)}">
    			<div class="search_condition">默认筛选（共 <em>${totalRecordNum}</em> 个结果）</div>
    		</c:if>
				<c:if test="${not empty level3Category }">
				<div class="serarch_content ${isExpand?'unfold':''} " id="level3CategoryDiv">
					<div class="scroll">
						<ul  class="clear">
							<c:forEach items="${level3Category }" var="l3c">
								<c:if test="${empty appendcode2 }">
									<c:set var="lvl3Url" value="/${pageKey}${appendcodeKey1 }.html${appendKeyword}&codelevel3=${l3c.code }"/>
								</c:if>
								<c:if test="${not empty appendcode2 }">
									<c:set var="lvl3Url" value="/${pageKey}${appendcodeKey1 }${appendcode2 }-${l3c.code }.html${not empty announcementParam.keyword?appendKeyword:''}"/>
								</c:if>
								
								<li title="${l3c.name }<c:if test="${not empty announcementParam.keyword }">(${l3c.count })</c:if>"><a class="${t:arrayContains(fn:split(announcementParam.codelevel3,','),l3c.code)?'active':'' }" 
								href="${lvl3Url }">${l3c.name }
								<em>(${l3c.count })</em>
								</a></li>
							</c:forEach> 
						</ul>
					</div>
					<c:if test="${fn:length(level3Category) > 15}">
						<div class="view_more"><a href="javascript:;" class="">${isExpand?'收起':'查看更多' }</a></div>
					</c:if>
				</div>
				</c:if>
				<div class="table_info">
					<div class="search_table" id="search-table">
						<label class="search_label" style="padding-left: 11px">
							<span class="filter_span">招标所在地</span>
							<div class="filter down-list">
								<div class="txt_common areadl_input">
				              		<label style="width:50%">${currentLocation }</label>
				              		<i></i>
				              	</div>
				            
				            	<div class="areadl_wrap" style="">
			              		<span><a class="areadl_select" href="${urlItem}${appendState }${appendRegcapital }${appendQualification }${appendQualificationLevel }">不限</a></span>
			              		
			              		<c:forEach items="${regionArea }" var="area" varStatus="ai">
			              		<h4><span>${area.key }</span></h4>
			              		<ul class="areadl_list clear">
			              			<c:forEach items="${area.value }" var="province" varStatus="pi">
			              				<li >
			              					<a href="${urlItem }&location=${province.code }${appendState }${appendRegcapital }${appendQualification }${appendQualificationLevel }">${province.name }${empty province.childRegionNodes?'':'<i></i>'}</a>
			              					<c:if test="${not empty province.childRegionNodes }">
				              					<ul>
				              					<c:forEach items="${province.childRegionNodes }" var="city">
				              						<li><a href="${urlItem }&location=${city.code }${appendState }${appendRegcapital }${appendQualification }${appendQualificationLevel }">${city.name }</a></li>
				              					</c:forEach>
				              					</ul>
			              					</c:if>
			              				</li>
			              			</c:forEach>
			              		</ul>
			              		</c:forEach>
			              	</div>		
				          </div>
				          </label>
				          <%-- <c:if test="${(not empty announcementParam.codelevel2 or not empty announcementParam.codelevel3) and not empty relatedQualification}">
							<label class="search_label" style="border-right:none ">
								<span class="filter_span">资质</span>
								<div class="aptitude down-list">
									<div class="txt_common inputbox">
										<label title="${currentQualification }">${currentQualification }</label>
										<span class="triangle fr"></span>
									</div>
									<div class="listbox" style="display: none;">
										<ul>
											<li><a href="/${pageKey}-${appendcodeKey1 }-${appendcode2 }-${appendcode3 }-${appendLocation }-${appendState }-${appendRegcapital }--.html${appendKeyword}">不限</a></li>
											<c:forEach items="${relatedQualification }" var="rq">
												<li><a href="/${pageKey}-${appendcodeKey1 }-${appendcode2 }-${appendcode3 }-${appendLocation }-${appendState }-${appendRegcapital }-${rq.qualificationCode }-.html${appendKeyword}">${rq.qualificationName }</a></li>
											</c:forEach>
										</ul>
									</div>
								</div>
							</label>
							<label class="search_label" >
								<span class="filter_span">等级≤</span>
								<div class="aptitude down-list">
									<div class="txt_common inputbox" style="width: 65px">
										<label title="${currentQualificationLevel }">${currentQualificationLevel }</label>
										<span class="triangle fr"></span>
									</div>
									<div class="listbox" style="display: none;">
										<ul>
											<li><a href="/${pageKey}-${appendcodeKey1 }-${appendcode2 }-${appendcode3 }-${appendLocation }-${appendState }-${appendRegcapital }-${appendQualification }-.html${appendKeyword}">不限</a></li>
											<c:forEach items="${relatedQualificationLevel }" var="rq">
												<li><a href="/${pageKey}-${appendcodeKey1 }-${appendcode2 }-${appendcode3 }-${appendLocation }-${appendState }-${appendRegcapital }-${rq.qualificationCode }-${rq.levelCode }.html${appendKeyword}">${rq.levelName }</a></li>
											</c:forEach>
										</ul>
									</div>
								</div>
							</label>
						</c:if> --%>
				          <label class="search_label">
				          	<span class="filter_span">状态</span>
				          	<div class="state down-list">
				          		<div class="txt_common inputbox">
				          			<label title="${currentState }">${currentState }</label>
				          			<span class="triangle fr"></span>
				          		</div>
				          		<div class="listbox" style="display: none;">
					          		<ul>
					          			<c:forEach items="${stateMap }" var="sm" varStatus="smi">
					          				<c:if test="${not smi.first }">
					          					<c:set var="v" value="&state=${sm.key }"/>
					          				</c:if>
					          				<li><a href="${urlItem }${appendLocation }${v}${appendRegcapital }${appendQualification }${appendQualificationLevel }">${sm.value }</a></li>
					          			</c:forEach>
					          		</ul>
				          		</div>
				          	</div>
				          </label>
						<label class="search_label">
							<span class="filter_span">注册资本要求 ≤ </span>
							<div class="fund down-list">
								<div class="txt_common inputbox regcatitalFilter">
									<label style="display: inline-block;" title="${currentRegcapital }">${currentRegcapital }</label>
									<span class="fr" style="display: none;"></span>
									<input id="regcapitalTxt"  type="text" value="${currentRegcapital eq '不限'?'':currentRegcapital }" style="display: none;" onkeydown="javascript:if(event.keyCode==13) regSure(this.value);"
									t_value="" o_value="" onkeypress="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onkeyup="if(!this.value.match(/^[\+\-]?\d*?\.?\d*?$/))this.value=this.t_value;else this.t_value=this.value;if(this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?)?$/))this.o_value=this.value" onblur="if(!this.value.match(/^(?:[\+\-]?\d+(?:\.\d+)?|\.\d*?)?$/))this.value=this.o_value;else{if(this.value.match(/^\.\d+$/))this.value=0+this.value;if(this.value.match(/^\.$/))this.value=0;this.o_value=this.value}">
								</div>
								<div class="listbox" style="display: none;">
									<a href="javsscript:;" class="butt_subm" id="regcapitalSureBtn">确定</a>
								</div>
          					</div>
          					<span class="filter_span">万元</span>
          				</label>
						
						<label class="search_label" style="border-right:none ">
								<c:set var="psort" value=""/>
								<c:set var="ssort" value=""/>
								<c:if test="${(empty announcementParam.pdatesort or announcementParam.pdatesort=='0') }">
									<c:set var="psort" value="pdatesort=1"/>
								</c:if>
								<c:if test="${announcementParam.pdatesort=='1' }"><c:set var="psort" value="pdatesort=0"/></c:if>
								<c:if test="${(empty announcementParam.sdatesort or announcementParam.sdatesort=='0') }">
									<c:set var="ssort" value="sdatesort=1"/>
								</c:if>
								<c:if test="${announcementParam.sdatesort=='1' }"><c:set var="ssort" value="sdatesort=0"/></c:if>
								
							
							<%-- <a href="/${pageKey}-${appendcodeKey1 }-${appendcode2 }-${appendcode3 }-${appendLocation }-${appendState }-${appendRegcapital }-${appendQualification }-${appendQualificationLevel }.html${appendKeyword}" 
							class="${(empty announcementParam.sdatesort and empty announcementParam.pdatesort)?'btn_common btn_orange':'' } btn_size_search" >默认</a>
							 --%>
							 
							<c:if test="${empty announcementParam.sdatesort }">
								<c:set var="sdatecionClass" value="spanicon2"/>
								<c:set var="sdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${announcementParam.sdatesort == '0'}">
								<c:set var="sdatecionClass" value="spanicon3"/>
								<c:set var="sdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${announcementParam.sdatesort == '1'}">
								<c:set var="sdatecionClass" value="spanicon4"/>
								<c:set var="sdatecionTitle" value="升"/>
							</c:if>
							
							<c:if test="${empty announcementParam.pdatesort }">
								<c:set var="pdatecionClass" value="spanicon2"/>
								<c:set var="pdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${announcementParam.pdatesort == '0'}">
								<c:set var="pdatecionClass" value="spanicon3"/>
								<c:set var="pdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${announcementParam.pdatesort == '1'}">
								<c:set var="pdatecionClass" value="spanicon4"/>
								<c:set var="pdatecionTitle" value="升"/>
							</c:if>
							<c:if test="${not empty announcementParam.keyword}">
							<a href="${urlItem }${appendLocation }${appendState }${appendRegcapital }${appendQualification }${appendQualificationLevel }" 
							style="display: inline-block;vertical-align: bottom;" class="${(empty announcementParam.pdatesort and empty announcementParam.sdatesort)?'btn_common btn_orange btn_size_30':'' }">相关度</a>
							</c:if>			
							
							<a href="${urlItem }${appendLocation }${appendState }${appendRegcapital }${appendQualification }${appendQualificationLevel }&${psort }" 
							style="display: inline-block;vertical-align: bottom;" title="点击后按照发布日期${pdatecionTitle }序排列"
							class="${(not empty announcementParam.pdatesort)?'btn_common btn_orange btn_size_30':'' }">
							发布日期<span class="${pdatecionClass}"></span></a>
							
							<a href="${urlItem }${appendLocation }${appendState }${appendRegcapital }${appendQualification }${appendQualificationLevel }&${ssort }" 
							style="display: inline-block;vertical-align: bottom;" title="点击后按照截止时间${sdatecionTitle }序排列"
							class="${(not empty announcementParam.sdatesort)?'btn_common btn_orange btn_size_30':'' }">
							截止时间<span class='${sdatecionClass }'></span></a>
						
						</label>
						<label class="search_label" style="float: right;">
							<a class="btn_common btn_silvery btn_size_30 btn_reset" href="/${pageKey}${appendcodeKey1 }${appendcode2 }.html${appendKeyword}">清空</a>
						</label>
					</div>
					<div class="tender_cont">
						<ul class="tender_list">
							<c:forEach items="${searchResult}" var="elem">
							
							<c:set var="titleAlt" value="${t:replaceForRegex(elem.title)}"/>
							
							
							<li>
				              <div class="tender_title">
				                <h3 class="${elem.state == '5'?'active':''}"><a  target="_blank" href="<my:link domain="zhaobiao" uri="/bidding-${elem.biddingId}.html" />" title="${titleAlt}">${elem.title}</a></h3>
				                <span class="date"><fmt:formatDate value="${elem.publishTime }" pattern="yyyy/MM/dd"/> 发布</span>
				              </div>
				              <div class="tender_view">
				                <a href="<my:link domain="zhaobiao" uri="/bidding-${elem.biddingId}.html" />" target="_blank">
									<c:if test="${empty elem.projectImage}">
										<c:if test="${empty elem.developerLogo }">
											<img  src="<my:link uri='/res1.5/img/developer/global/default.jpg' domain='jcs.static'/>" alt="${titleAlt }" >
										</c:if>
										<c:if test="${not empty elem.developerLogo }">
								   			<img src="<my:link uri='/company/${elem.developerId}.185x110.jpg?v=${elem.developerLogo }' domain="img.static"/>" alt="${titleAlt}">
								   		</c:if>
								    </c:if>
								    <c:if test="${not empty elem.projectImage}">
								   		 <img src="<my:link uri="/netdiskimg/developer-proj/${elem.projectImage}.185x110.jpg" domain="img.static"/>" alt="${titleAlt}">
								    </c:if>	
								    </a>
				              </div>
				              <div class="tender_cont">
				                <div class="tender_detail">
				                  <p class="tender_split">
				                  	<span>${fn:escapeXml(elem.developerShortName) }</span>
				                  	<span>${elem.projectCity }</span>
				                  	<c:if test="${not empty elem.projectName }"><span>${fn:escapeXml(elem.projectName) }</span></c:if>
				                  </p>
				                  <p class="tender_project">
				                  	<c:if test="${not empty elem.projectType }"><span>项目类型：${fn:escapeXml(elem.projectType) }</span></c:if>
									<c:if test="${elem.projectArea > 0}"><span>占地面积：<fmt:formatNumber value="${elem.projectArea }" pattern="#,###.##"/>万㎡</span></c:if>
									<c:if test="${elem.projectTotArea > 0}"><span>建筑面积：<fmt:formatNumber value="${elem.projectTotArea }" pattern="#,###.##"/>万㎡</span></c:if>
				                  </p>
				                  <p class="tender_range">招标范围：
				                  	<c:if test="${not empty announcementParam.keyword }">
				                  		${not empty elem.biddingRange?t:splitHlField(elem.biddingRange):'无' }
				                  	</c:if>
				                  	<c:if test="${empty announcementParam.keyword }">
				                  		${not empty elem.biddingRange?t:cutStr(elem.biddingRange,85):'无' }
				                  	</c:if>
				                  	
				                  </p>
				                </div>
				                <div class="tender_desc">
				                  
				                  <div class="tender_status ${(elem.state == '3' or elem.state == '4')?'hover_show':''}">
				                  	<c:if test="${elem.state == '2' }">
										<a target="_blank" href="<my:link domain="zhaobiao" uri="/bidding-${elem.biddingId}.html" />" class="tender_status_view">
										<p>立即报名</p>
										<div data-title="${elem.registerEndDate }">仅剩 ${t:getRemainingTime(elem.registerEndDate) }</div>
										</a>
									</c:if>
				                    <c:if test="${elem.state == '3' or elem.state == '4'}">
										<a href="javascript:;" class="btn_common btn_disable">已截止<div><fmt:formatDate value="${elem.registerEndDate}" pattern="yyyy-MM-dd"/></div></a>
									</c:if>
									
									<c:if test="${elem.state == '5'}">
										<div class="tender_bidding">
											<label>中标单位：</label>
											<div>${t:cutStr(elem.biddingCompany,25) }</div>
										</div>
									</c:if>
				                  </div>
				                  
				                  <div class="tender_meta">
				                    <span class="tipsbox_wrap">
				                  <span class="tender_condition">报名条件</span>
				                  <div class="tipsbox">
												<ul>
													<li>
														<label style="width: 110px">服务/产品分类：</label>
														<span style="width: 350px" title="${t:collectionJoinToString(elem.scCategoryName,' ') }">${t:collectionJoinToString(elem.scCategoryName,' ') }</span>
													</li>
													<li>
														
														
														<label>服务资质：</label>
														<c:set value="${t:collectionJoinToString(elem.scQualificationName,' ') }" var="listQual"/>
														<span title="${listQual }" style="width: 390px">${empty listQual?'不限':listQual }</span>
														
														
													</li>
													<li>
														<label>成立年限：</label>
														<span style="width:105px">
														<c:if test="${elem.scBuildYears <=0 }">不限</c:if>
														<c:if test="${elem.scBuildYears >0 }">${elem.scBuildYears }年及以上</c:if>
														</span>
														
														<label>注册资本：</label>
														<span>
														<c:if test="${elem.scRegCapital <=0 }">不限</c:if>
														<c:if test="${elem.scRegCapital >0 }"><fmt:formatNumber value="${elem.scRegCapital }" pattern="#,###"/>万元及以上</c:if>
														</span>
													</li>
													<li>
														<label>服务区域：</label>
														<span style="width:105px">${fn:length(elem.scServiceAreaName) <= 0?'不限':t:collectionJoinToString(elem.scServiceAreaName,' ') }</span>
														
														<label >项目案例：</label>
														<span style="width:205px">
														<c:if test="${elem.scCaseNum <=0 }">不限</c:if>
														<c:if test="${elem.scCaseNum >0 }">${elem.scCaseNum }个及以上</c:if><c:if test="${elem.scIsLimitServiceAreaCase }">(仅限于服务区域的案例)</c:if>
														</span>									
													</li>
												</ul>
											</div>
				                </span>
				                    <c:if test="${elem.state != '5'}">
				                    <span class="tender_readed followNums" data-pid="${elem.biddingId }">0人关注</span>
				                    </c:if> 
				                  </div>
				                </div>
				              </div>
				            </li>
							</c:forEach>
						</ul>
					    <div class="page_info">
					      <p:html 
							url="${pageUrl }" 
							pagesize="${announcementParam.pageSize}" 
							page="${announcementParam.page }" 
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
        </c:if>
    </div>   
    <div class="search_bottom">
			    <form action="/${pageKey}.html" method="get">
			     <label>重新搜索</label>
			     <input type="text" class="txt_common" name="keyword">
			     <input type="submit" class="btn_common" value="搜索">
			  	</form>
			</div>
		<script src='<my:link domain="jcs.static" uri="/res1.5/js/web/page/search.js" />'></script>
		<script src='<my:link domain="jcs.static" uri="/res1.5/js/common/dialog.js" />'></script>
		<script>
			function regSure(regcapital){
				location.href = "${urlItem }${appendLocation }${appendState}&regcapital="+regcapital+"${appendQualification }${appendQualificationLevel }";
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
				
				$("#intelligentFilterBtn").click(function(){
					if($(this).data("isonline").toString() == "true"){
						location.href = $(this).data("href");
					}else{
						mysoft.confirm("请先以供应商的身份登录系统！您确定登录吗？",{
							callback:[
							          function(){
							        	  window.open($("#intelligentFilterBtn").data("href"), "_blank");
							          },
							          function(){}
							          ]
						});
					}
					
				});
				$("#level3CategoryDiv>div").scrollTop(parseInt("${scrollLength}",10));
				var pvUrl ='<my:link domain="portal" uri="/pv/query.do?pageId=${biddingIds}&pvType=bidding" />';
				$.getJSON(pvUrl +"&callback=?",function(data) {
					$(".tender_list li .followNums").each(function(k,v) {
						$(this).text(data[$(this).data("pid")] + "人已关注");	
					});
                });
			});     
	        	    
		</script>
		<html:include page="bottom" />		
	</body>
</html>