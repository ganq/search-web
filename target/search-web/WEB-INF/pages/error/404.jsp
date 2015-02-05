<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib uri="http://mysoft.com/taglib/domain" prefix="my" %>
<%@ taglib uri="http://mysoft.com/taglib/includeHtml" prefix="html" %>
<%
	response.setStatus(404);
%>
<!DOCTYPE html>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>您所访问的页面不存在 - 明源地产云采购</title>
<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/common.css"/>" rel="stylesheet"/>
<link href="<my:link domain="jcs.static" uri="/res1.5/css/common/layout.css"/>" rel="stylesheet"/>
<link rel="shortcut icon" href="<my:link domain="jcs.static" uri="/favicon.ico"/>" type="image/x-icon" />
<link rel="icon" href="<my:link domain="jcs.static" uri="/favicon.ico"/>" type="image/x-icon" />
<link href="<my:link domain="jcs.static" uri="/res1.5/plugins/backTools/backTools.css"/>" rel="stylesheet"/>
<link href="<my:link domain="jcs.static" uri="/res1.5/css/web/page/system_page.css"/>" rel="stylesheet"/>
<script type="text/javascript" src="<my:link domain="jcs.static" uri="/res1.5/js/common/jquery-1.10.2.min.js"/>"></script>
</head>

<body>
		<!-- 导航  -->
		<html:include page="site_nav"></html:include>
		
    <!-- 主体内容begin -->
    <div class="system_content stystem_404">
        <div class="info">
            <span class="cartoon notfound"></span>
            <div class="tips">
              <h2>抱歉！您所访问的页面不存在！</h2>
              <p>或者可以看看您可能感兴趣的信息</p>
            </div>
            <ul class="guide_link">
              <li>
                <a href="<my:link domain="mainpage" uri="/bidding.html"/>">
                  <img src="<my:link domain="jcs.static" uri="/res1.5/img/web/page/system_page/tenders.jpg"/>" alt="查看招标信息">
                  <span class="bg"></span>
                  <p>查看招标信息</p>
                </a>
              </li>
              <li>
                <a href="<my:link domain="mainpage" uri="/developer.html"/>">
                  <img src="<my:link domain="jcs.static" uri="/res1.5/img/web/page/system_page/developer.jpg"/>" alt="查找开发商">
                  <span class="bg"></span>
                  <p>查找开发商</p>
                </a>
              </li>
              <li>
                <a href="<my:link domain="info" uri="/"/>">
                  <img src="<my:link domain="jcs.static" uri="/res1.5/img/web/page/system_page/news.jpg"/>" alt="查看采购资讯">
                  <span class="bg"></span>
                  <p>查看采购资讯</p>
                </a>
              </li>
            </ul>
        </div>
        <p class="buttons">
          <a class="btn_common btn_size_40" href="<my:link domain="mainpage" uri="/"/>">&lt;&lt;返回首页</a>
        </p>
    </div>
    <!-- 主体内容end -->
    
    <script type="text/javascript" src="<my:link domain="jcs.static" uri="/res1.5/plugins/backTools/jquery.backTools.js"/>"></script>
</body>
</html>