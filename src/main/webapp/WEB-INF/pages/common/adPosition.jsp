<%@ page language="java" %>
<div>
<c:forEach items="${adPosition}" var="ad">
    <a href="${ad.url}" target="_blank"><img class="mt5" src="<my:link domain='img.static' uri='/advise/${ad.imgPath}' />" width="200" height="80" alt="${ad.adDesc}"/></a>
</c:forEach>
</div>
