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
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/web/page/search_recruit.css" />" rel="stylesheet"/>
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
	<c:if test="${not empty recruitParam.keyword}">
		<c:set var="appendKeyword" value="?keyword=${t:urlEncode(recruitParam.keyword)}"/>		
	</c:if>
	
	<c:if test="${not empty recruitParam.codeKeyLevel1 }">
		<c:set var="appendcodeKey1" value="/${recruitParam.codeKeyLevel1}"/>
	</c:if>
	<c:if test="${not empty recruitParam.codelevel2 }">
		<c:set var="appendcode2" value="-${recruitParam.codelevel2}"/>
	</c:if>
	<c:if test="${not empty recruitParam.codelevel3 }">
		<c:set var="appendcode3" value="-${recruitParam.codelevel3}"/>
	</c:if>
	<c:if test="${not empty recruitParam.location }">
		<c:set var="appendLocation" value="&location=${t:escapeHtml(recruitParam.location)}"/>
	</c:if>
	<c:if test="${not empty recruitParam.state }">
		<c:set var="appendState" value="&state=${t:escapeHtml(recruitParam.state)}"/>
	</c:if>
	<c:if test="${not empty recruitParam.regcapital }">
		<c:set var="appendRegcapital" value="&regcapital=${t:escapeHtml(recruitParam.regcapital)}"/>
	</c:if>
	<c:if test="${not empty recruitParam.sdatesort }">
		<c:set var="appendSdatesort" value="&sdatesort=${t:escapeHtml(recruitParam.sdatesort)}"/>
	</c:if>
	<c:if test="${not empty recruitParam.pdatesort }">
		<c:set var="appendPdatesort" value="&pdatesort=${t:escapeHtml(recruitParam.pdatesort)}"/>
	</c:if>
	<c:set var="pageKey" value="zm" />
	<c:if test="${empty appendcode2 }">
		<c:set var="urlItem" value="/${pageKey}${appendcodeKey1 }.html${appendKeyword}&codelevel3=${recruitParam.codelevel3}"/>
	</c:if>
	<c:if test="${not empty appendcode2 }">
		<c:set var="urlItem" value="/${pageKey}${appendcodeKey1 }${appendcode2 }${appendcode3 }.html${appendKeyword}"/>
	</c:if>
	
	<c:set var="pageUrl" scope="request" value="${urlItem}${appendLocation }${appendState }${appendRegcapital }${appendSdatesort }${appendPdatesort }"/>
	<body data-allcount="${totalRecordNum }">
	<html:include page="top"/>
	<html:include page="nav"/>
    <div id="content" class="container clear">
    	<div class="wrap">
    	<c:if test="${not empty relatedCategory}">
        <div class="sidebar">
        	<h3>所有类目</h3>
            	<ul id="sidebarList" class="sidebar_list ${empty recruitParam.keyword?'sidebar_dblist':'' }">
            	<c:forEach items="${relatedCategory}" var="rc" varStatus="rci">
            	<c:set value="" var="category_show"/>
				<c:if test="${(not empty recruitParam.codelevel2 and rc.code == currentCategoryCode) or 
				(not empty recruitParam.codelevel1 and rc.code == recruitParam.codelevel1) }">
					<c:set value="active" var="category_show"/>
				</c:if>
				<c:if test="${empty recruitParam.codelevel2 and empty recruitParam.codelevel1 }">
					<c:set value="active" var="first_category_show"/>
				</c:if>
				
                <li class="${category_show} ${rci.first?first_category_show:'' }"  >
                    <h3><em></em>
                    <a href="/${pageKey}/${rc.pinyin }.html${not empty recruitParam.keyword?appendKeyword:''}" title ="${rc.name}">${rc.name}<c:if test="${not empty recruitParam.keyword }">(${rc.count })</c:if></a>
                    </h3>
                    <ul>
                    <c:forEach  items="${rc.childrenList }" var="rcc" varStatus="rcci">
                    <li class="${recruitParam.codelevel2 == rcc.code?'active':''}">
                    	<a href="/${pageKey}/${rc.pinyin }-${rcc.code }.html${not empty recruitParam.keyword?appendKeyword:''}"                     	
                    	title="${rcc.name}">${rcc.name}<c:if test="${not empty recruitParam.keyword }"><em>(${rcc.count })</em></c:if></a>
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
       		<c:if test="${not empty recruitParam.keyword }">
    			<div class="search_condition"><strong>${fn:escapeXml(recruitParam.keyword) }</strong>（共 <em>${totalRecordNum}</em> 个结果）</div>
    		</c:if>
    		
    		<c:if test="${(empty recruitParam.keyword) and (not empty recruitParam.codelevel1 or not empty recruitParam.codelevel2)}">
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
									<c:set var="lvl3Url" value="/${pageKey}${appendcodeKey1 }${appendcode2 }-${l3c.code }.html${not empty recruitParam.keyword?appendKeyword:''}"/>
								</c:if>
								
								<li title="${l3c.name }<c:if test="${not empty recruitParam.keyword }">(${l3c.count })</c:if>"><a class="${t:arrayContains(fn:split(recruitParam.codelevel3,','),l3c.code)?'active':'' }" 
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
							<span class="filter_span">招募区域</span>
							<div class="filter down-list">
								<div class="txt_common areadl_input">
				              		<label style="width:50%">${currentLocation }</label>
				              		<i></i>
				              	</div>
				            
				            	<div class="areadl_wrap" style="">
                                <span><a class="areadl_select" href="${urlItem}${appendState }${appendRegcapital }&location=china">全国</a></span>
			              		<span class="areadl_right"><a class="areadl_select" href="${urlItem}${appendState }${appendRegcapital }">不限</a></span>
			              		
			              		<c:forEach items="${regionArea }" var="area" varStatus="ai">
			              		<h4><span>${area.key }</span></h4>
			              		<ul class="areadl_list clear">
			              			<c:forEach items="${area.value }" var="province" varStatus="pi">
			              				<li >
			              					<a href="${urlItem }&location=${province.code }${appendState }${appendRegcapital }">${province.name }${empty province.childRegionNodes?'':'<i></i>'}</a>
			              					<c:if test="${not empty province.childRegionNodes }">
				              					<ul>
				              					<c:forEach items="${province.childRegionNodes }" var="city">
				              						<li><a href="${urlItem }&location=${city.code }${appendState }${appendRegcapital }">${city.name }</a></li>
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
					          				<li><a href="${urlItem }${appendLocation }${v}${appendRegcapital }">${sm.value }</a></li>
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
								<c:if test="${(empty recruitParam.pdatesort or recruitParam.pdatesort=='0') }">
									<c:set var="psort" value="pdatesort=1"/>
								</c:if>
								<c:if test="${recruitParam.pdatesort=='1' }"><c:set var="psort" value="pdatesort=0"/></c:if>
								<c:if test="${(empty recruitParam.sdatesort or recruitParam.sdatesort=='0') }">
									<c:set var="ssort" value="sdatesort=1"/>
								</c:if>
								<c:if test="${recruitParam.sdatesort=='1' }"><c:set var="ssort" value="sdatesort=0"/></c:if>
								
							

							 
							<c:if test="${empty recruitParam.sdatesort }">
								<c:set var="sdatecionClass" value="spanicon2"/>
								<c:set var="sdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${recruitParam.sdatesort == '0'}">
								<c:set var="sdatecionClass" value="spanicon3"/>
								<c:set var="sdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${recruitParam.sdatesort == '1'}">
								<c:set var="sdatecionClass" value="spanicon4"/>
								<c:set var="sdatecionTitle" value="升"/>
							</c:if>
							
							<c:if test="${empty recruitParam.pdatesort }">
								<c:set var="pdatecionClass" value="spanicon2"/>
								<c:set var="pdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${recruitParam.pdatesort == '0'}">
								<c:set var="pdatecionClass" value="spanicon3"/>
								<c:set var="pdatecionTitle" value="降"/>
							</c:if>
							<c:if test="${recruitParam.pdatesort == '1'}">
								<c:set var="pdatecionClass" value="spanicon4"/>
								<c:set var="pdatecionTitle" value="升"/>
							</c:if>
							<c:if test="${not empty recruitParam.keyword}">
							<a href="${urlItem }${appendLocation }${appendState }${appendRegcapital }"
							style="display: inline-block;vertical-align: bottom;" class="${(empty recruitParam.pdatesort and empty recruitParam.sdatesort)?'btn_common btn_orange btn_size_30':'' }">相关度</a>
							</c:if>			
							
							<a href="${urlItem }${appendLocation }${appendState }${appendRegcapital }&${psort }"
							style="display: inline-block;vertical-align: bottom;" title="点击后按照发布日期${pdatecionTitle }序排列"
							class="${(not empty recruitParam.pdatesort)?'btn_common btn_orange btn_size_30':'' }">
							发布日期<span class="${pdatecionClass}"></span></a>
							
							<a href="${urlItem }${appendLocation }${appendState }${appendRegcapital }&${ssort }"
							style="display: inline-block;vertical-align: bottom;" title="点击后按照截止时间${sdatecionTitle }序排列"
							class="${(not empty recruitParam.sdatesort)?'btn_common btn_orange btn_size_30':'' }">
							截止时间<span class='${sdatecionClass }'></span></a>
						
						</label>
						<label class="search_label" style="float: right;">
							<a class="btn_common btn_silvery btn_size_30 btn_reset" href="/${pageKey}${appendcodeKey1 }${appendcode2 }.html${appendKeyword}">清空</a>
						</label>
					</div>
					<div class="tender_cont">
						<ul class="tender_list">
							<c:forEach items="${searchResult}" var="elem">
							
							<c:set var="titleAlt" value="${t:replaceForRegex(elem.subject)}"/>
							<li>
				              <div class="tender_title">
				                <h3 class=""><a  target="_blank" href="<my:link domain="zm" uri="/detail-${elem.recruitId}.html" />" title="${titleAlt}">${elem.subject}</a></h3>
				                <span class="date"><fmt:formatDate value="${elem.publishTime }" pattern="yyyy/MM/dd"/> 发布</span>
				              </div>
				              <div class="tender_view">
				                <a href="<my:link domain="zm" uri="/detail-${elem.recruitId}.html" />" target="_blank">
                                    <c:if test="${empty elem.image }">
                                        <img  src="<my:link uri='/res1.5/img/developer/global/default.jpg' domain='jcs.static'/>" alt="${titleAlt }" >
                                    </c:if>
                                    <c:if test="${not empty elem.image }">
                                        <img src="<my:link uri='/company/${elem.companyId}.185x110.jpg?v=${elem.image }' domain="img.static"/>" alt="${titleAlt}">
                                         <%--<img src="<my:link uri="/netdiskimg/recruit/${elem.image}.185x110.jpg" domain="img.static"/>" alt="${titleAlt}">--%>
                                    </c:if>
								</a>
				              </div>
				              <div class="tender_cont">
				                <div class="tender_detail">
				                  <p class="tender_split">
				                  	<span>${fn:escapeXml(elem.companyShortName) }</span>
				                  	<span>${t:cutStr(t:collectionJoinToString(elem.serviceAreaCityName,"," ),25 ) }</span>
				                  </p>
				                  <p class="tender_range">报名条件：
				                  	<c:if test="${not empty recruitParam.keyword }">
				                  		${not empty elem.registerCondition?t:splitHlField(elem.registerCondition):'无' }
				                  	</c:if>
				                  	<c:if test="${empty recruitParam.keyword }">
				                  		${not empty elem.registerCondition?t:cutStr(elem.registerCondition,85):'无' }
				                  	</c:if>
				                  	
				                  </p>
				                </div>
				                <div class="tender_desc">
				                  
				                  <div class="tender_status ${(elem.state == '2' or elem.state == '3')?'hover_show':''}">
				                  	<c:if test="${elem.state == '1' }">
										<a target="_blank" href="<my:link domain="zm" uri="/detail-${elem.recruitId}.html" />" class="tender_status_view">
										<p>立即报名</p>
										<div data-title="${elem.registerEndDate }">仅剩 ${t:getRemainingTime(elem.registerEndDate) }</div>
										</a>
									</c:if>
				                    <c:if test="${elem.state == '2' or elem.state == '3'}">
										<a href="javascript:;" class="btn_common btn_disable">已截止<div><fmt:formatDate value="${elem.registerEndDate}" pattern="yyyy-MM-dd"/></div></a>
									</c:if>

				                  </div>
				                  
				                  <div class="tender_meta">
                                      <span class="tender_readed followNums" data-pid="${elem.recruitId }">0人关注</span>
				                  </div>
				                </div>
				              </div>
				            </li>
							</c:forEach>
						</ul>
					    <div class="page_info">
					      <p:html 
							url="${pageUrl }" 
							pagesize="${recruitParam.pageSize}" 
							page="${recruitParam.page }" 
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
				location.href = "${urlItem }${appendLocation }${appendState}&regcapital="+regcapital;
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

				$("#level3CategoryDiv>div").scrollTop(parseInt("${scrollLength}",10));
				var pvUrl ='<my:link domain="portal" uri="/pv/query.do?pageId=${recruitIds}&pvType=supplier_recruit_activity_item" />';
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