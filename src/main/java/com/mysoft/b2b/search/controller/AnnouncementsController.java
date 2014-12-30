package com.mysoft.b2b.search.controller;

import com.mysoft.b2b.basicsystem.settings.api.DictionaryService;
import com.mysoft.b2b.basicsystem.settings.api.Region;
import com.mysoft.b2b.basicsystem.settings.api.RegionNode;
import com.mysoft.b2b.bizsupport.api.*;
import com.mysoft.b2b.bizsupport.api.OperationCategoryService.DataType;
import com.mysoft.b2b.cms.api.AdpositionService;
import com.mysoft.b2b.search.api.AnnouncementSearchService;
import com.mysoft.b2b.search.param.AnnouncementParam;
import com.mysoft.b2b.search.util.CommonUtil;
import com.mysoft.b2b.search.util.TDKUtil;
import com.mysoft.b2b.search.vo.AnnouncementsVO;
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
public class AnnouncementsController {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    private AnnouncementSearchService announcementSearchService;

    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private OnlineService onlineService;

    @Autowired
    private QualificationService qualificationService;

    @Autowired
    private QualificationLevelService qualificationLevelService;

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
        stateMap.put("2", "招标中");
        stateMap.put("3,4", "已截止");
        stateMap.put("5", "已中标");
    }


    @RequestMapping(value = "/announcements", method = RequestMethod.GET)
    public String announcements(Model model, AnnouncementParam announcementParam, HttpServletRequest request) {
        try {


            String errorUrl = commonUtil.checkCategory(DataType.BID, announcementParam);
            if (!StringUtils.isBlank(errorUrl)) {
                return errorUrl;
            }

            // 设置userid和userType 统计搜索用
            String[] userIdAndType = commonUtil.getUserIdAndType(request);
            announcementParam.setUserId(userIdAndType[0]);
            announcementParam.setUserType(userIdAndType[1]);
            announcementParam.setIpAddress(request.getRemoteAddr());

            announcementParam.setPageSize(10);
            announcementParam.setKeyword(commonUtil.separateStringByLen(announcementParam.getKeyword(), 50).trim());
            Map<String, Object> result = announcementSearchService.getSearchResult(announcementParam);

            List<AnnouncementsVO> searchResult = (List<AnnouncementsVO>) result.get("searchResult");
            List<String> biddingIds = new ArrayList<String>();
            if (searchResult != null) {
                for (AnnouncementsVO announcementsVO : searchResult) {
                    biddingIds.add(announcementsVO.getBiddingId());
                }
            }
            model.addAttribute("biddingIds", StringUtils.join(biddingIds.toArray(), ","));

            List<SearchCategoryVO> level3Category = (List<SearchCategoryVO>) result.get("level3Category");
            model.addAllAttributes(commonUtil.getLvl3MenuIsExpandAndScroll(level3Category, announcementParam.getCodelevel3()));

            model.addAttribute("regionArea", regionArea);
            model.addAttribute("currentCategoryCode", getCurrentCategoryCode(announcementParam.getCodelevel2(), result));
            model.addAllAttributes(result);
            //是否登录
            /*model.addAttribute("isOnline",isOnline);
			model.addAttribute("isSupplierLogin",onlineUser!=null && "1".equals(onlineUser.getCompanyType()));*/
            model.addAttribute("stateMap", stateMap);
            model.addAllAttributes(getCurrentParam(announcementParam, result));

            model.addAttribute("encodeKeyword", commonUtil.replaceKeywordStr(announcementParam.getKeyword()));
            model.addAttribute("adPosition", commonUtil.getAdposition("recruit_ad_list"));
            model.addAllAttributes(tdkUtil.getPageTDK(DataType.BID, announcementParam));
        } catch (Exception e) {
            logger.error("Search Announcements controller error", e);
        }

        return "announcements";
    }

    /**
     * 获取当前已选择的参数
     */
    private Map<String, Object> getCurrentParam(AnnouncementParam announcementParam, Map<String, Object> searchResult) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("currentLocation", "不限");
        map.put("currentState", stateMap.containsKey(announcementParam.getState()) ? stateMap.get(announcementParam.getState()) : "不限");
        map.put("currentRegcapital", "不限");
        map.put("currentQualification", "不限");
        map.put("currentQualificationLevel", "不限");

        Region region = dictionaryService.getRegionByCode(announcementParam.getLocation());
        if (region != null) {
            map.put("currentLocation", region.getName());
        }

        if (!StringUtils.isBlank(announcementParam.getRegcapital()) && NumberUtils.isNumber(announcementParam.getRegcapital())) {
            map.put("currentRegcapital", announcementParam.getRegcapital());
        }

        if (!StringUtils.isBlank(announcementParam.getQualification())) {
            Qualification qualification = qualificationService.getQualificationByCode(announcementParam.getQualification());
            if (qualification != null) {
                map.put("currentQualification", qualification.getQualificationName());
            }
        }

        if (!StringUtils.isBlank(announcementParam.getQualificationLevel())) {
            QualificationLevel qualificationLevel = qualificationLevelService.getQualificationLevelByCode(announcementParam.getQualificationLevel());
            if (qualificationLevel != null) {
                map.put("currentQualificationLevel", qualificationLevel.getLevelName());
            }
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