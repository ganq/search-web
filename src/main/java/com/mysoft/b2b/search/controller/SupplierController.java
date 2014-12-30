package com.mysoft.b2b.search.controller;

import com.mysoft.b2b.basicsystem.settings.api.DictionaryService;
import com.mysoft.b2b.basicsystem.settings.api.Region;
import com.mysoft.b2b.basicsystem.settings.api.RegionNode;
import com.mysoft.b2b.bizsupport.api.*;
import com.mysoft.b2b.bizsupport.api.OperationCategoryService.DataType;
import com.mysoft.b2b.cms.api.AdpositionService;
import com.mysoft.b2b.commons.taglib.DomainTag;
import com.mysoft.b2b.search.api.SupplierSearchService;
import com.mysoft.b2b.search.param.SupplierParam;
import com.mysoft.b2b.search.util.CommonUtil;
import com.mysoft.b2b.search.util.TDKUtil;
import com.mysoft.b2b.search.vo.SearchCategoryVO;
import com.mysoft.b2b.search.vo.SupplierVO;
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
public class SupplierController {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private OnlineService onlineService;

    @Autowired
    private QualificationService qualificationService;

    @Autowired
    private QualificationLevelService qualificationLevelService;

    @Autowired
    private SupplierSearchService supplierSearchService;

    @Autowired
    private DomainService domainService;

    @Autowired
    private OperationCategoryService operationCategoryService;

    @Autowired
    private AdpositionService adpositionService;

    @Autowired
    private CommonUtil commonUtil;

    @Autowired
    private TDKUtil tdkUtil;

    private Map<String, List<RegionNode>> regionArea = new LinkedHashMap<String, List<RegionNode>>();

    @PostConstruct
    public void init() {
        regionArea = commonUtil.getRegionArea();
    }

    @RequestMapping(value = "/supplier", method = RequestMethod.GET)
    public String supplier(Model model, SupplierParam supplierParam, HttpServletRequest request) {
        try {

            String errorUrl = commonUtil.checkCategory(DataType.SUPPLIER, supplierParam);
            if (!StringUtils.isBlank(errorUrl)) {
                return errorUrl;
            }

            supplierParam.setPageSize(10);
            supplierParam.setKeyword(commonUtil.separateStringByLen(supplierParam.getKeyword(), 50).trim());

            // 设置userid和userType 统计搜索用
            String[] userIdAndType = commonUtil.getUserIdAndType(request);
            supplierParam.setUserId(userIdAndType[0]);
            supplierParam.setUserType(userIdAndType[1]);
            supplierParam.setIpAddress(request.getRemoteAddr());


            Map<String, Object> result = supplierSearchService.getSearchResult(supplierParam);
            List<SupplierVO> searchResult = (List<SupplierVO>) result.get("searchResult");
            List<String> supplierIds = new ArrayList<String>();
            // 设置供应商旗舰店的url
            if (searchResult != null) {
                for (SupplierVO supplierVO : searchResult) {
                    String domain = domainService.getDomainByCompanyId(supplierVO.getSupplierId());
                    String newUrl;
                    if (domain.equalsIgnoreCase(supplierVO.getSupplierId())) {//默认url
                        newUrl = DomainTag.getDomainUrlByKey("g.archives", "/") + domain;
                    } else { // 二级域名
                        newUrl = DomainTag.getDomainUrlByKey("mainpage", "/").replace("www", domain);
                    }
                    supplierVO.setSupplierUrl(newUrl);
                    supplierIds.add(supplierVO.getSupplierId());
                }
            }
            model.addAttribute("supplierIds", StringUtils.join(supplierIds.toArray(), ","));

            List<SearchCategoryVO> level3Category = (List<SearchCategoryVO>) result.get("level3Category");
            model.addAllAttributes(commonUtil.getLvl3MenuIsExpandAndScroll(level3Category, supplierParam.getCodelevel3()));

            result.put("searchResult", searchResult);
            model.addAttribute("regionArea", regionArea);
            model.addAttribute("currentCategoryCode", getCurrentCategoryCode(supplierParam.getCodelevel2(), result));
            model.addAllAttributes(result);

            model.addAllAttributes(getCurrentParam(supplierParam, result));

            model.addAttribute("encodeKeyword", commonUtil.replaceKeywordStr(supplierParam.getKeyword()));
            model.addAttribute("adPosition", commonUtil.getAdposition("recruit_ad_list"));
            model.addAllAttributes(tdkUtil.getPageTDK(DataType.SUPPLIER, supplierParam));
        } catch (Exception e) {
            logger.error("Search supplier controller error", e);
        }

        return "supplier";
    }

    /**
     * 获取当前已选择的参数
     */
    private Map<String, Object> getCurrentParam(SupplierParam supplierParam, Map<String, Object> searchResult) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("currentLocation", "不限");
        map.put("currentRegcapital", "不限");
        map.put("currentQualification", "不限");
        map.put("currentQualificationLevel", "不限");
        map.put("currentEstablishYear", "不限");


        Region region = dictionaryService.getRegionByCode(supplierParam.getLocation());
        if (region != null) {
            map.put("currentLocation", region.getName());
        } else {
            if ("china".equals(supplierParam.getLocation())) {
                map.put("currentLocation", "全国");
            }
        }

        if (!StringUtils.isBlank(supplierParam.getRegisteredcapital()) && NumberUtils.isNumber(supplierParam.getRegisteredcapital())) {
            map.put("currentRegcapital", supplierParam.getRegisteredcapital());
        }

        if (!StringUtils.isBlank(supplierParam.getYear()) && NumberUtils.isNumber(supplierParam.getYear())) {
            map.put("currentEstablishYear", supplierParam.getYear());
        }

        if (!StringUtils.isBlank(supplierParam.getQualification())) {
            Qualification qualification = qualificationService.getQualificationByCode(supplierParam.getQualification());
            if (qualification != null) {
                map.put("currentQualification", qualification.getQualificationName());
            }
        }

        if (!StringUtils.isBlank(supplierParam.getQualificationLevel())) {
            QualificationLevel qualificationLevel = qualificationLevelService.getQualificationLevelByCode(supplierParam.getQualificationLevel());
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