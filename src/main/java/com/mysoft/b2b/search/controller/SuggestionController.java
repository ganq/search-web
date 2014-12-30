package com.mysoft.b2b.search.controller;

import com.mysoft.b2b.search.api.SearchSuggestService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.map.util.JSONPObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RequestMapping("/suggestion")
@Controller
public class SuggestionController {

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
    private SearchSuggestService searchSuggestService;

    @RequestMapping(value = "/{module}", method = RequestMethod.GET)
    @ResponseBody
    public JSONPObject index(@PathVariable String module, @RequestParam String k, @RequestParam String callback) {
        try {
            Map<String, Map<String, Long>> result = new HashMap<String, Map<String, Long>>();
            result.put("result", Collections.<String, Long>emptyMap());

            if (StringUtils.isBlank(k)) {
                return new JSONPObject(callback, result);
            }

            result.put("result", searchSuggestService.getSearchSuggestion(k.trim(), module));

            return new JSONPObject(callback, result);

        } catch (Exception e) {
            logger.error("Search SuggestionController error", e);
        }

        return null;
    }


}