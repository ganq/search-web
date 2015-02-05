package com.mysoft.b2b.search.controller;

import com.mysoft.b2b.bizsupport.api.DomainService;
import com.mysoft.b2b.commons.taglib.DomainTag;
import com.mysoft.b2b.search.api.DeveloperSearchService;
import com.mysoft.b2b.search.param.DeveloperParam;
import com.mysoft.b2b.search.util.CommonUtil;
import com.mysoft.b2b.search.util.TDKUtil;
import com.mysoft.b2b.search.vo.DeveloperVO;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;


@Controller
@SuppressWarnings("unchecked")
public class DeveloperController {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    private DeveloperSearchService developerSearchService;

    @Autowired
    private DomainService domainService;

    @Autowired
    private CommonUtil commonUtil;

    @Autowired
    private TDKUtil tdkUtil;

    @RequestMapping(value = "/developer", method = RequestMethod.GET)
    public String developer(Model model, DeveloperParam developerParam, HttpServletRequest request) {
        try {
            developerParam.setPageSize(10);
            developerParam.setKeyword(commonUtil.separateStringByLen(developerParam.getKeyword(), 50).trim());
            // 设置userid和userType 统计搜索用
            String[] userIdAndType = commonUtil.getUserIdAndType(request);
            developerParam.setUserId(userIdAndType[0]);
            developerParam.setUserType(userIdAndType[1]);
            developerParam.setIpAddress(request.getRemoteAddr());

            Map<String, Object> result = developerSearchService.getSearchResult(developerParam);
            List<DeveloperVO> searchResult = (List<DeveloperVO>) result.get("searchResult");
            // 设置开发商旗舰店的url
            if (searchResult != null) {
                for (DeveloperVO developerVO : searchResult) {
                    String domain = domainService.getDomainByCompanyId(developerVO.getDeveloperId());
                    developerVO.setDeveloperUrl(DomainTag.getDomainUrlByKey("mainpage", "/").replace("www", domain));
                }
            }

            result.put("searchResult", searchResult);
            model.addAllAttributes(result);

            model.addAttribute("encodeKeyword", commonUtil.replaceKeywordStr(developerParam.getKeyword()));
            model.addAttribute("slider", commonUtil.readTxtFileContent("/www/target/images/www/kfssearchslider.html"));
            model.addAllAttributes(tdkUtil.getPageTDK(null, developerParam));

        } catch (Exception e) {
            logger.error("Search developer controller error", e);
        }

        return "developer";
    }

}