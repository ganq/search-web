package com.mysoft.b2b.search.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by ganq on 018 14/12/18.
 */
public class SearchTDK {


    private String title;
    private String desc;
    private String keyword;

    public Map<String,String> getTDKMap(){
        Map<String,String> map = new HashMap<String, String>();
        map.put("title",this.title);
        map.put("desc",this.desc);
        map.put("keyword",this.keyword);
        return map;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
}
