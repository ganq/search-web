package com.mysoft.b2b.search.util;

import com.mysoft.b2b.bizsupport.api.*;
import com.mysoft.b2b.search.model.SearchTDK;
import com.mysoft.b2b.search.param.AnnouncementParam;
import com.mysoft.b2b.search.param.BaseParam;
import com.mysoft.b2b.search.param.DeveloperParam;
import com.mysoft.b2b.search.param.RecruitParam;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;

import java.text.MessageFormat;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * Created by ganq on 018 14/12/18.
 */
public class TDKUtil {

    private SearchTDK biddingRoot;
    private SearchTDK biddingCategory;
    private SearchTDK biddingWithKeyword;

    private SearchTDK supplierRoot;
    private SearchTDK supplierCategory;
    private SearchTDK supplierWithKeyword;

    private SearchTDK recruitRoot;
    private SearchTDK recruitCategory;
    private SearchTDK recruitWithKeyword;

    private SearchTDK developerRoot;
    private SearchTDK developerWithKeyword;

    @Autowired
    private OperationCategoryService operationCategoryService;
    /**
     *得到分类目录下的TDK
     */
    private Map<String,String> getCategoryTDK(OperationCategoryService.DataType dataType, BaseParam baseParam, String categoryName){
        Map<String,String> map = new HashMap<String, String>();
        if (dataType == OperationCategoryService.DataType.BID){
            if (baseParam instanceof AnnouncementParam){
                map = this.biddingCategory.getTDKMap();
            }
            if (baseParam instanceof RecruitParam){
                map = this.recruitCategory.getTDKMap();
            }
        }
        if (dataType == OperationCategoryService.DataType.SUPPLIER){
            map = this.supplierCategory.getTDKMap();
        }
        for (Map.Entry<String,String> entry : map.entrySet()){
            entry.setValue(MessageFormat.format(entry.getValue(), categoryName));
        }
        return map;
    }

    /**
     * 得到一级目录的TDK
     */
    private Map<String,String> getFirstCategoryTDK(OperationCategoryService.DataType dataType, BaseParam baseParam,BasicCategory basicCategoryLevel){
        // 招标
        if (dataType == OperationCategoryService.DataType.BID && baseParam instanceof AnnouncementParam) {
            BidOperationCategory bidOperationCategory = (BidOperationCategory)basicCategoryLevel;
            SEOModel seoModel = bidOperationCategory.getSeoModel();
            // 中台有设置SEO，则优先选择
            if (seoModel != null) {
                Map<String,String> map = new HashMap<String, String>();
                map.put("title",seoModel.getTitle());
                map.put("desc",seoModel.getDescription());
                map.put("keyword",seoModel.getKeywords());
                return map;
            }else{
                return getCategoryTDK(dataType, baseParam, basicCategoryLevel.getCategoryName());
            }

        }
        // 招募 （目前招募和招标共用运营分类）
        if (dataType == OperationCategoryService.DataType.BID && baseParam instanceof RecruitParam) {
            return getCategoryTDK(dataType, baseParam, basicCategoryLevel.getCategoryName());
        }
        // 供应商
        if (dataType == OperationCategoryService.DataType.SUPPLIER) {
            SupplierOperationCategory supplierOperationCategory = (SupplierOperationCategory)basicCategoryLevel;
            SEOModel seoModel = supplierOperationCategory.getSeoModel();
            if (seoModel != null) {
                Map<String,String> map = new HashMap<String, String>();
                map.put("title",seoModel.getTitle());
                map.put("desc",seoModel.getDescription());
                map.put("keyword",seoModel.getKeywords());
                return map;
            }else{
                return getCategoryTDK(dataType, baseParam, basicCategoryLevel.getCategoryName());
            }
        }
        return null;
    }

    /**
     *得到根目录下的TDK
     */
    private Map<String,String> getRootCategoryTDK(OperationCategoryService.DataType dataType, BaseParam baseParam){

        Map<String,String> map = new HashMap<String, String>();

        // 招标
        if (dataType == OperationCategoryService.DataType.BID && baseParam instanceof AnnouncementParam) {
            map = this.biddingRoot.getTDKMap();
        }
        // 招募 （目前招募和招标共用运营分类）
        if (dataType == OperationCategoryService.DataType.BID && baseParam instanceof RecruitParam) {
            map = this.recruitRoot.getTDKMap();
        }
        // 供应商
        if (dataType == OperationCategoryService.DataType.SUPPLIER) {
            map = this.supplierRoot.getTDKMap();
        }
        // 开发商
        if (dataType == null && baseParam instanceof DeveloperParam){
            map = this.developerRoot.getTDKMap();
        }

        return map;
    }

    /**
     *得到关键字搜索场景下的TDK
     */
    private Map<String,String> getTDKWithKeyword(OperationCategoryService.DataType dataType, BaseParam baseParam){
        Map<String,String> map = new HashMap<String, String>();

        // 招标
        if (dataType == OperationCategoryService.DataType.BID && baseParam instanceof AnnouncementParam) {
            map = this.biddingWithKeyword.getTDKMap();
        }
        // 招募 （目前招募和招标共用运营分类）
        if (dataType == OperationCategoryService.DataType.BID && baseParam instanceof RecruitParam) {
            map = this.recruitWithKeyword.getTDKMap();
        }
        // 供应商
        if (dataType == OperationCategoryService.DataType.SUPPLIER) {
            map = this.supplierWithKeyword.getTDKMap();
        }
        // 开发商
        if (dataType == null && baseParam instanceof DeveloperParam){
            map = this.developerWithKeyword.getTDKMap();
        }
        for (Map.Entry<String,String> entry : map.entrySet()){
            entry.setValue(MessageFormat.format(entry.getValue(), JspTagUtil.escapeHtml(baseParam.getKeyword())));
        }
        return map;
    }


    /**
     * 设置页面TDK
     */
    public Map<String,String> getPageTDK(OperationCategoryService.DataType dataType, BaseParam baseParam){
        if (!StringUtils.isBlank(baseParam.getKeyword())){
            return getTDKWithKeyword(dataType,baseParam);
        }
        if (!StringUtils.isBlank(baseParam.getCodelevel3())) {
            BasicCategory basicCategoryLevel3 = operationCategoryService.getCategoryByCode(dataType, baseParam.getCodelevel3());
            if (basicCategoryLevel3 != null){
                return getCategoryTDK(dataType, baseParam, basicCategoryLevel3.getCategoryName());
            }
        }else{
            if(!StringUtils.isBlank(baseParam.getCodelevel2())) {
                BasicCategory basicCategoryLevel2 = operationCategoryService.getCategoryByCode(dataType, baseParam.getCodelevel2());
                if (basicCategoryLevel2 != null){
                    return getCategoryTDK(dataType, baseParam, basicCategoryLevel2.getCategoryName());
                }
            }else {
                BasicCategory basicCategoryLevel = operationCategoryService.getCategoryBydirectoryName(dataType, baseParam.getCodeKeyLevel1());
                if (basicCategoryLevel != null) {
                    return getFirstCategoryTDK(dataType,baseParam,basicCategoryLevel);
                }
            }
        }
        if (StringUtils.isBlank(baseParam.getCodelevel3()) && StringUtils.isBlank(baseParam.getCodelevel2()) &&
                StringUtils.isBlank(baseParam.getCodeKeyLevel1())) {
            return getRootCategoryTDK(dataType, baseParam);
        }

        Map<String,String> map = new HashMap<String, String>();
        map.put("title","搜索-明源云采购");
        map.put("desc","搜索-明源云采购");
        map.put("keyword","搜索-明源云采购");
        return map;

    }

    public SearchTDK getBiddingRoot() {
        return biddingRoot;
    }

    public void setBiddingRoot(SearchTDK biddingRoot) {
        this.biddingRoot = biddingRoot;
    }

    public SearchTDK getBiddingCategory() {
        return biddingCategory;
    }

    public void setBiddingCategory(SearchTDK biddingCategory) {
        this.biddingCategory = biddingCategory;
    }

    public SearchTDK getBiddingWithKeyword() {
        return biddingWithKeyword;
    }

    public void setBiddingWithKeyword(SearchTDK biddingWithKeyword) {
        this.biddingWithKeyword = biddingWithKeyword;
    }

    public SearchTDK getSupplierRoot() {
        return supplierRoot;
    }

    public void setSupplierRoot(SearchTDK supplierRoot) {
        this.supplierRoot = supplierRoot;
    }

    public SearchTDK getSupplierCategory() {
        return supplierCategory;
    }

    public void setSupplierCategory(SearchTDK supplierCategory) {
        this.supplierCategory = supplierCategory;
    }

    public SearchTDK getSupplierWithKeyword() {
        return supplierWithKeyword;
    }

    public void setSupplierWithKeyword(SearchTDK supplierWithKeyword) {
        this.supplierWithKeyword = supplierWithKeyword;
    }

    public SearchTDK getRecruitRoot() {
        return recruitRoot;
    }

    public void setRecruitRoot(SearchTDK recruitRoot) {
        this.recruitRoot = recruitRoot;
    }

    public SearchTDK getRecruitCategory() {
        return recruitCategory;
    }

    public void setRecruitCategory(SearchTDK recruitCategory) {
        this.recruitCategory = recruitCategory;
    }

    public SearchTDK getRecruitWithKeyword() {
        return recruitWithKeyword;
    }

    public void setRecruitWithKeyword(SearchTDK recruitWithKeyword) {
        this.recruitWithKeyword = recruitWithKeyword;
    }

    public SearchTDK getDeveloperRoot() {
        return developerRoot;
    }

    public void setDeveloperRoot(SearchTDK developerRoot) {
        this.developerRoot = developerRoot;
    }

    public SearchTDK getDeveloperWithKeyword() {
        return developerWithKeyword;
    }

    public void setDeveloperWithKeyword(SearchTDK developerWithKeyword) {
        this.developerWithKeyword = developerWithKeyword;
    }
}
