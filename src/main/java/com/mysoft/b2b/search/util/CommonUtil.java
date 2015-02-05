package com.mysoft.b2b.search.util;

import com.mysoft.b2b.basicsystem.settings.api.DictionaryService;
import com.mysoft.b2b.basicsystem.settings.api.Region;
import com.mysoft.b2b.basicsystem.settings.api.RegionNode;
import com.mysoft.b2b.bizsupport.api.BasicCategory;
import com.mysoft.b2b.bizsupport.api.OperationCategoryService;
import com.mysoft.b2b.bizsupport.api.OperationCategoryService.DataType;
import com.mysoft.b2b.cms.api.AdInfoDo;
import com.mysoft.b2b.cms.api.AdpositionService;
import com.mysoft.b2b.search.param.BaseParam;
import com.mysoft.b2b.search.param.SearchLocation;
import com.mysoft.b2b.search.vo.SearchCategoryVO;
import com.mysoft.b2b.sso.api.OnlineService;
import com.mysoft.b2b.sso.api.OnlineUser;
import com.mysoft.b2b.sso.api.utils.CookieUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.*;

@SuppressWarnings("unused")
@Component("commonUtil")
public class CommonUtil {

	
	private Logger logger = LoggerFactory.getLogger(CommonUtil.class);

    @Autowired
    private DictionaryService dictionaryService;

    @Autowired
    private OnlineService onlineService;

    @Autowired
    private OperationCategoryService operationCategoryService;

    @Autowired
    private AdpositionService adpositionService;
	/**
	 * 获取行政区划区域
	 */
	public Map<String, List<RegionNode>> getRegionArea() {
		List<String> ignoreArea = Arrays.asList("北京","天津","上海","重庆","澳门","香港","台湾");
		
		Map<String, List<RegionNode>> regionMap = new LinkedHashMap<String, List<RegionNode>>();
		for (int i = 0;i<SearchLocation.values().length; i++) {
			String area = SearchLocation.values()[i].getLocationCode();
			List<Region> regions = dictionaryService.getRegionsByArea(area);
			List<RegionNode> provinceCity = new ArrayList<RegionNode>();
			//Map<Region,List<Region>> province = new LinkedHashMap<Region,List<Region>>();
			for (Region region : regions) {
				RegionNode rn = dictionaryService.getRegionHierarchyByCode(region.getCode());
				if (ignoreArea.contains(region.getName())) {
					rn.setChildRegionNodes(null);
				}
				provinceCity.add(rn);	
				;
			}
			regionMap.put(SearchLocation.values()[i].getLocationName(),provinceCity);
		}
		return regionMap;
	}
	
	/**
	 * 如果超过len长度则切割一个字符串
	 */
	public String separateStringByLen(String str, int len){
		if (StringUtils.isBlank(str)) {
			return "";
		}
		return str.length() >= len ? str.substring(0,len) : str;
	}

    /**
     * 计算三级分类是否展开和滚动距离
     */
	public Map<String,Object> getLvl3MenuIsExpandAndScroll(List<SearchCategoryVO> level3Category,String lvl3Code){
		Map<String,Object> resultMap = new HashMap<String, Object>();
		if (level3Category == null || level3Category.isEmpty()) {
			return resultMap;
		}


		boolean isExpand = true;
		int scrollLength = 0;
		int lvl3CodePosition = 0;
		if (!StringUtils.isBlank(lvl3Code)) {
			for (int i = 0 ; i < level3Category.size() ; i++) {
				SearchCategoryVO searchCategoryVO = level3Category.get(i);
				if (lvl3Code.equals(searchCategoryVO.getCode())) {
					lvl3CodePosition = i + 1;
					break;
				}
			}	
		}		
		int col = 4 ;
		int defaultRow = 3;
		int scrollRow = 6;
		int rowHeight = 30 ;
		if ((lvl3CodePosition  >= 0 && lvl3CodePosition <= defaultRow * col)) {
			isExpand = false;
		}else if (lvl3CodePosition  > scrollRow * col ){
			int row = lvl3CodePosition % col == 0 ? lvl3CodePosition / col : (lvl3CodePosition / col) +1;
			scrollLength = rowHeight * (row - 1);
		}
		resultMap.put("isExpand",isExpand);
		resultMap.put("scrollLength",scrollLength);
		return resultMap;
	}
	
	/**
	 * 获取当前登录用户的userId 和userType
	 */
	public String [] getUserIdAndType(HttpServletRequest request){
		String ssoid = CookieUtils.getSsoid(request);
		String companyType = StringUtils.defaultString(CookieUtils.getCookie(request, "companyType"));
		OnlineUser onlineUser = onlineService.getOnlineUser(ssoid);
		String userId = onlineUser == null ? "" : onlineUser.getUserId();
		String userType = "guest";
		if(!StringUtils.isBlank(companyType)){
			userType = "1".equals(companyType)?"supplier":"developer";
		}
		return new String [] {userId,userType};
	}
	
	public String replaceKeywordStr(String keyword){
		return keyword.replaceAll("\"", "\\\\\"").replaceAll("\\/", "\\\\/");
	}
	
	
	/**
	 * 检查供应商，招标预告页面的分类路径是否正确
	 */
	public String checkCategory(DataType dataType,BaseParam baseParam  ){
		
		BasicCategory basicCategoryLevel3 = operationCategoryService.getCategoryByCode(dataType, baseParam.getCodelevel3());
		BasicCategory basicCategoryLevel2 = operationCategoryService.getCategoryByCode(dataType, baseParam.getCodelevel2());
		BasicCategory basicCategoryLevel1 = operationCategoryService.getCategoryBydirectoryName(dataType, baseParam.getCodeKeyLevel1());
		
		if (!StringUtils.isBlank(baseParam.getCodeKeyLevel1())) {
			if (basicCategoryLevel1 != null) {
				baseParam.setCodelevel1(basicCategoryLevel1.getCategoryCode());
			}else{
                logger.info("URL中1级分类拼音查询分类不存在，跳转404");
				return "error/404";	
			}
		}
		
		if (!StringUtils.isBlank(baseParam.getCodelevel3())) {
			if (basicCategoryLevel3 == null) {
                logger.info("URL中3级分类查询不存在，跳转404");
				return "error/404";
			}
		}else {
			if(!StringUtils.isBlank(baseParam.getCodelevel2())) {
				if (basicCategoryLevel2 == null) {
                    logger.info("URL中2级分类查询不存在，跳转404");
					return "error/404";
				}
			}
		}
		
		if (basicCategoryLevel1 != null && basicCategoryLevel2 != null && basicCategoryLevel3 !=null) {
			if (!basicCategoryLevel3.getParentCode().equals(basicCategoryLevel2.getCategoryCode()) || 
				!basicCategoryLevel2.getParentCode().equals(basicCategoryLevel1.getCategoryCode())) {
                logger.info("URL中各级分类不匹配，跳转404");
				return "error/404";
			}
		}else if(basicCategoryLevel1 != null && basicCategoryLevel2 != null){
			if (!basicCategoryLevel2.getParentCode().equals(basicCategoryLevel1.getCategoryCode())) {
                logger.info("URL中2级分类和1级分类不匹配，跳转404");
				return "error/404";
			}
		}
		return "";
	}

    /**
     * 获取广告位数据
     * type ："ad_developer_list" recruit_ad_list
     */
    public List<AdInfoDo> getAdposition(String type){
       return adpositionService.getAdviseListByCodeTopRandomSize(type, 5);

    }


    /**
     * 读取文件
     */
    public String readTxtFileContent(String path) {

        if (!new File(path).exists()) {
            logger.error("file :'" + path + "' not found!");
            return "";
        }

        InputStreamReader inputReader = null;
        BufferedReader bufferReader = null;
        StringBuilder strBuider = new StringBuilder();
        try {
            InputStream inputStream = new FileInputStream(path);
            inputReader = new InputStreamReader(inputStream,"UTF-8");
            bufferReader = new BufferedReader(inputReader);

            // 读取一行
            String line = null;
            while ((line = bufferReader.readLine()) != null) {
                strBuider.append(line);
            }

        } catch (IOException e) {
            logger.error("Read file error :" + e.getMessage());
        } finally {
            try {
                inputReader.close();

                if (bufferReader != null) {
                    bufferReader.close();
                }
                if (inputReader != null) {
                    inputReader.close();
                }
            } catch (IOException e) {
                logger.error("close file stream error :" + e.getMessage());
            }
        }
        return strBuider.toString();
    }

}
