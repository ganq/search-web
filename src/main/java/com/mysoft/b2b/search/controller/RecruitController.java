package com.mysoft.b2b.search.controller;

import com.mysoft.b2b.basicsystem.settings.api.DictionaryService;
import com.mysoft.b2b.basicsystem.settings.api.Region;
import com.mysoft.b2b.basicsystem.settings.api.RegionNode;
import com.mysoft.b2b.bizsupport.api.OperationCategoryService;
import com.mysoft.b2b.bizsupport.api.OperationCategoryService.DataType;
import com.mysoft.b2b.cms.api.AdpositionService;
import com.mysoft.b2b.search.api.RecruitSearchService;
import com.mysoft.b2b.search.param.RecruitParam;
import com.mysoft.b2b.search.util.CommonUtil;
import com.mysoft.b2b.search.util.TDKUtil;
import com.mysoft.b2b.search.vo.RecruitVO;
import com.mysoft.b2b.search.vo.SearchCategoryVO;
import com.mysoft.b2b.sso.api.OnlineService;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@SuppressWarnings("unchecked")
public class RecruitController {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    private RecruitSearchService recruitSearchService;

    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private OnlineService onlineService;

    @Autowired
    private OperationCategoryService operationCategoryService;

    @Autowired
    private AdpositionService adpositionService;

    @Autowired
    private CommonUtil commonUtil;

    @Autowired
    private TDKUtil tdkUtil;

    private Map<String, List<RegionNode>> regionArea = new LinkedHashMap<String, List<RegionNode>>();

    private Map<String, String> stateMap = new LinkedHashMap<String, String>();

    @PostConstruct
    public void init() {
        regionArea = commonUtil.getRegionArea();
        stateMap.put(null, "不限");
        stateMap.put("1", "报名中");
        stateMap.put("2,3", "已截止");
    }


    @RequestMapping(value = "/recruit", method = RequestMethod.GET)
    public String recruit(Model model, RecruitParam recruitParam, HttpServletRequest request) {
        try {

            String errorUrl = commonUtil.checkCategory(DataType.BID, recruitParam);
            if (!StringUtils.isBlank(errorUrl)) {
                return errorUrl;
            }

            // 设置userid和userType 统计搜索用
            String[] userIdAndType = commonUtil.getUserIdAndType(request);
            recruitParam.setUserId(userIdAndType[0]);
            recruitParam.setUserType(userIdAndType[1]);
            recruitParam.setIpAddress(request.getRemoteAddr());
            recruitParam.setPageSize(10);
            recruitParam.setKeyword(commonUtil.separateStringByLen(recruitParam.getKeyword(), 50).trim());
            Map<String, Object> result = recruitSearchService.getSearchResult(recruitParam);

            List<RecruitVO> searchResult = (List<RecruitVO>) result.get("searchResult");
            List<String> recruitIds = new ArrayList<String>();
            if (searchResult != null) {
                for (RecruitVO recruitVO : searchResult) {
                    recruitIds.add(recruitVO.getRecruitId());
                }
            }
            model.addAttribute("recruitIds", StringUtils.join(recruitIds.toArray(), ","));

            List<SearchCategoryVO> level3Category = (List<SearchCategoryVO>) result.get("level3Category");
            model.addAllAttributes(commonUtil.getLvl3MenuIsExpandAndScroll(level3Category, recruitParam.getCodelevel3()));

            model.addAttribute("regionArea", regionArea);
            model.addAttribute("currentCategoryCode", getCurrentCategoryCode(recruitParam.getCodelevel2(), result));
            model.addAllAttributes(result);
            model.addAttribute("stateMap", stateMap);
            model.addAllAttributes(getCurrentParam(recruitParam, result));

            model.addAttribute("encodeKeyword", commonUtil.replaceKeywordStr(recruitParam.getKeyword()));

            model.addAttribute("adPosition", commonUtil.getAdposition("recruit_ad_list"));
            model.addAllAttributes(tdkUtil.getPageTDK(DataType.BID, recruitParam));

        } catch (Exception e) {
            logger.error("Search recruit controller error", e);
        }

        return "recruit";
    }

    /**
     * 获取当前已选择的参数
     */
    private Map<String, Object> getCurrentParam(RecruitParam recruitParam, Map<String, Object> searchResult) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("currentLocation", "不限");
        map.put("currentState", stateMap.containsKey(recruitParam.getState()) ? stateMap.get(recruitParam.getState()) : "不限");
        map.put("currentRegcapital", "不限");

        Region region = dictionaryService.getRegionByCode(recruitParam.getLocation());
        if (region != null) {
            map.put("currentLocation", region.getName());
        }
        if ("china".equals(recruitParam.getLocation())) {
            map.put("currentLocation", "全国");
        }

        if (!StringUtils.isBlank(recruitParam.getRegcapital()) && NumberUtils.isNumber(recruitParam.getRegcapital())) {
            map.put("currentRegcapital", recruitParam.getRegcapital());
        }

        return map;
    }

    /**
     * 得到当前搜索结果分类的上级分类编码
     */
    private String getCurrentCategoryCode(String fccode, Map<String, Object> result) {
        String currentCategoryCode = "";
        if (!StringUtils.isBlank(fccode)) {
            List<SearchCategoryVO> bcnList = (List<SearchCategoryVO>) result.get("relatedCategory");
            for (SearchCategoryVO searchCategoryVO : bcnList) {
                String parentCode = StringUtils.defaultString(searchCategoryVO.getCode());
                boolean checked = false;
                for (SearchCategoryVO child : searchCategoryVO.getChildrenList()) {
                    if (fccode.equals(child.getCode())) {
                        checked = true;
                        break;
                    }
                }
                if (checked) {
                    currentCategoryCode = parentCode;
                    break;
                }
            }
        }
        return currentCategoryCode;
    }


}