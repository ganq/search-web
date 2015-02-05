<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/layout.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/common.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/module/tables.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/module/forms.css" />" rel="stylesheet"/>
	<link href="<my:link domain="jcs.static" uri="/res1.5/css/web/page/find_developer.css" />" rel="stylesheet"/>
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
	<c:if test="${not empty developerParam.keyword}">
		<c:set var="appendKeyword" value="?keyword=${t:urlEncode(developerParam.keyword)}"/>
	</c:if>
	
	<c:set var="pageKey" value="developer" />
	<c:set var="pageUrl" scope="request" value="${pageKey }.html${appendKeyword}${empty appendKeyword?'?':'&'}"/>
	<body data-allcount="${totalRecordNum }">
	<html:include page="top"/>
	<html:include page="nav"/>
	<div id="content" class="container clear">
		<c:if test="${not empty searchResult}">
		<div class="wrap clear">
			<div class="developer_box">
				<ul class="developer_list clear">
					<c:forEach items="${searchResult}" var="elem">
					<li>
						<div class="developer_view">
							<a class="img" target="_blank" href="${empty elem.developerUrl?'javascript:;':elem.developerUrl }"  >
								<c:if test="${elem.companyLogo != null && elem.companyLogo !='' }">
									<img src='<my:link uri='/company/${elem.developerId}.250x100.jpg?v=${elem.companyLogo }' domain="img.static"/>' alt="${t:replaceHtml(elem.developerName) }" />
								</c:if>
								<c:if test="${elem.companyLogo == null || elem.companyLogo =='' }">
									<img src='<my:link domain="jcs.static" uri="/res1.5/img/developer/global/company_default.gif"/>' alt="${t:replaceHtml(elem.developerName) }"/>
								</c:if>
		          			</a>
		          			<c:if test="${elem.biddingCount > 0 or  elem.biddingHistoryCount > 0 or elem.recruitCount > 0}">
		          			<p>
                                <c:if test="${elem.recruitCount > 0 }">
                                    <label>正在招募：</label><span><strong>${elem.recruitCount }</strong>条</span>&nbsp;&nbsp;
                                    <c:if test="${elem.biddingCount > 0 }">
                                        <label>正在招标：</label><span><strong>${elem.biddingCount }</strong>条</span>&nbsp;&nbsp;
                                    </c:if>
                                    <c:if test="${elem.biddingCount <= 0 and elem.biddingHistoryCount > 0}">
                                        <label>历史招标：</label><span><strong>${elem.biddingHistoryCount }</strong>条</span>
                                    </c:if>
                                </c:if>
                                <c:if test="${elem.recruitCount <= 0 }">
                                    <c:if test="${elem.biddingCount > 0 }">
                                        <label>正在招标：</label><span><strong>${elem.biddingCount }</strong>条</span>&nbsp;&nbsp;
                                    </c:if>
                                    <c:if test="${elem.biddingHistoryCount > 0 }">
								        <label>历史招标：</label><span><strong>${elem.biddingHistoryCount }</strong>条</span>
                                    </c:if>
                                </c:if>
				            </p>
				            </c:if>
						</div>
						<div class="developer_cont">
							<h3>
                                <a target="_blank" href="${empty elem.developerUrl?'javascript:;':elem.developerUrl }"  title="${t:replaceHtml(elem.developerName) }">${elem.developerName}</a>
                                <c:if test="${elem.authorize}">
                                    <a target="_blank" href="${elem.developerUrl}warrant.html" class="m_icon accredit" title="明源云采购已获得该开发商独家授权"></a>
                                </c:if>
                            </h3>
							<p class="projects"><label>项目信息<c:if test="${not empty elem.projectInfo }">（${elem.projectCount }个）</c:if>：</label>
							<span>
							<c:if test="${not empty developerParam.keyword }">
								${t:cutHtmlStr(t:splitHlField(elem.projectInfo),65) }
							</c:if>
							<c:if test="${empty developerParam.keyword }">
								${t:cutStr(elem.projectInfo,65) }
							</c:if>
							
							</span>
							</p>
							<p class="address"><label>公司地址：</label>${elem.regLocation }</p>
						</div>
						<a class="developer_enter" target="_blank" href="${empty elem.developerUrl?'javascript:;':elem.developerUrl }">进入企业专区>></a>
					</li>
					</c:forEach>
				</ul>
				<div class="page_info">
					<p:html 
						url="${pageUrl }" 
						pagesize="${developerParam.pageSize}" 
						page="${developerParam.page }" 
						allrows="${totalRecordNum}"
						domain="" 
						/>
				</div>
			</div>
			${slider }
		</div>
		</c:if>
		<c:if test="${empty searchResult}">
        	<div style="text-align:center;margin: 100px 0px">抱歉，没有找到符合条件的记录</div>
        </c:if>
	</div>
		
	    <script src="<my:link domain="jcs.static" uri="/res1.5/plugins/backTools/jquery.backTools.js"/>"></script>
		<script src='<my:link domain="jcs.static" uri="/res1.5/js/web/page/search.js" />'></script>
		<script>   
			$(function(){
				loadBid();
			});
			function loadBid() {
	            var detail = '<my:link domain="zhaobiao" uri="/bidding-" />';
	            $.ajax({
	                type : 'GET',
	                url: '<my:link domain="portal" uri="/bidding/lastBid.jsonp?num=10&callback=?" />',
	                timeout: 20000,
	                cache:false,
	                dataType : 'jsonp',
	                jsonp: 'callback',
	                success: function (data, textStatus) {
	                	$('.dev_sect_box .newbidding').append("<ul></ul>");
	                    $.each(data, function (index, item) {
	                        $('.dev_sect_box .newbidding ul').append('<li><a href=\"' + detail + item.biddingId + '.html\" target=\"_blank\" title=\"' + item.title + '\">' + item.title + '</a></li>');
	                    });
	                },
	                complete: function (XMLHttpRequest) {
	                    $('.dev_sect_box .newbidding .loading').remove();
	                }
	            });
	        }

		</script>
		<html:include page="bottom" />		
	</body>
</html>