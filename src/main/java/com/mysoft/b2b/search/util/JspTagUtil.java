package com.mysoft.b2b.search.util;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@SuppressWarnings({"unchecked","rawtypes"})
public class JspTagUtil {

	private static Logger logger = LoggerFactory.getLogger(JspTagUtil.class);

	/**
	 * 
	 * 将给定的字符串截取到指定长度并加上省略符后返回（一个中文字算两个字符长度，一个英文算一个字符长度）
	 * 
	 * @param str
	 *            源字符串
	 * @param len
	 *            指定长度
	 * @param ellipsis
	 *            截取后加上的省略符号
	 * @return String 截取后的字符串
	 */
	public static String cutStr2(String str, int len, String ellipsis) {
		if (str == null || str.length() < 1)
			return "";
		Integer length = str.length();
		if (length <= len)
			return str;
		Integer count = 0, i = 0;
		for (; i < length; i++) {
			char c = str.charAt(i);
			if (c >= 255)
				count += 2;
			else
				count++;
			// 中止
			if (count > len)
				break;
		}
		return str.substring(0, i) + ellipsis;
	}

	/**
	 * 将给定的字符串截取到指定长度并加上省略符后返回（一个中文字算一个字符长度，两个英文算一个字符长度）
	 * 如cutString("abc王de",3)为"abc王d..."
	 * 
	 * @param src
	 *            源字符串
	 * @param length
	 *            指定长度
	 * @param ellipsis
	 *            截取后加上的省略符号
	 * @return String 截取后的字符串
	 */
	public static String cutStr(String src, int length, String ellipsis) {
		if (src == null || src.length() < 1)
			return "";

		length = length * 2;
		StringBuilder sb = new StringBuilder();
		int counter = 0;
		for (int i = 0; i < src.length(); i++) {
			char c = src.charAt(i);
			if (c < 255) {
				counter++;
			} else {
				counter = counter + 2;
			}
			if (counter > length) {
				break;
			}
			sb.append(c);
		}
		if (sb.toString().equals(src)) {
			return src;
		}
		return sb.append(ellipsis).toString();
	}

	/**
	 * 默认最后以"..."结尾
	 */
	public static String cutStr(String src, Integer length) {
		return cutStr(src, length, "...");
	}

	/**
	 * url编码
	 */
	public static String urlEncode(String url) {
		if (StringUtils.isBlank(url)) {
			return "";
		}

		try {
			return URLEncoder.encode(url, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			logger.info("url encode error:" + e);
		}
		return url;
	}

	/**
	 * 解码html代码
	 */
	public static String escapeHtml(String html) {
		if (StringUtils.isBlank(html)) {
			return "";
		}
		return StringEscapeUtils.escapeHtml3(String.valueOf(html));

	}

	/**
	 * 得到和今天相隔日期的字符串
	 * 
	 * @param apartDays
	 *            相隔天数
	 */
	public static String getDateStrFromApartDays(int apartDays) {
		Calendar c = Calendar.getInstance();
		c.add(Calendar.DATE, apartDays);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		return df.format(c.getTime());
	}

	/**
	 * 得到今天的字符串
	 */
	public static String todayToStr() {
		return getDateStrFromApartDays(0);
	}

	/**
	 * 截取带html标签的字符串
	 */
	public static String cutHtmlStr(String param, int maxLength) {

		String end = "...";

		StringBuilder result = new StringBuilder();
		int n = 0;
		char temp;
		boolean isCode = false; // 是不是HTML代码
		boolean isHTML = false; // 是不是HTML特殊字符,如&nbsp;
		for (int i = 0; i < param.length(); i++) {
			temp = param.charAt(i);
			if (temp == '<') {
				isCode = true;
			} else if (temp == '&') {
				isHTML = true;
			} else if (temp == '>' && isCode) {
				n = n - 1;
				isCode = false;
			} else if (temp == ';' && isHTML) {
				isHTML = false;
			}
			if (!isCode && !isHTML) {
				n = n + 1;
				// UNICODE码字符占两个字节
				/*if ((temp + "").getBytes().length > 1) {
					n = n + 1;
				}*/
			}
			result.append(temp);
			if (n >= maxLength) {
				break;
			}
		}
		
		// 取出截取字符串中的HTML标记
		String temp_result = result.toString().replaceAll("(>)[^<>]*(<?)", "$1$2");
		// 去掉不需要结素标记的HTML标记
		temp_result = temp_result
				.replaceAll(
						"</?(AREA|BASE|BASEFONT|BODY|BR|COL|COLGROUP|DD|DT|FRAME|HEAD|HR|HTML|IMG|INPUT|ISINDEX|LI|LINK|META|OPTION|P|PARAM|TBODY|TD|TFOOT|TH|THEAD|TR|area|base|basefont|body|br|col|colgroup|dd|dt|frame|head|hr|html|img|input|isindex|li|link|meta|option|p|param|tbody|td|tfoot|th|thead|tr)[^<>]*/?>",
						"");
		// 去掉成对的HTML标记
		temp_result = temp_result.replaceAll("<([a-zA-Z]+)[^<>]*>(.*?)</\\1>", "$2");
		// 用正则表达式取出标记
		Pattern p = Pattern.compile("<([a-zA-Z]+)[^<>]*>");
		Matcher m = p.matcher(temp_result);
		List<String> endHTML = new ArrayList<String>();
		while (m.find()) {
			endHTML.add(m.group(1));
		}
		// 补全不成对的HTML标记
		for (int i = endHTML.size() - 1; i >= 0; i--) {
			result.append("</");
			result.append(endHTML.get(i));
			result.append(">");
		}
		if (param.replaceAll("<[^>]*>","").length() > maxLength) {
			result.append(end);
		}
		return result.toString();

	}

	/**
	 * 用正则表达式替换
	 */
	public static String replaceForRegex(String src){
		if (StringUtils.isBlank(src)) {
			return  "";
		}
		return src.replaceAll("<([a-zA-Z]+)[^<>]*>(.*?)</\\1>", "$2");
	}
	
	/**
	 * 替换html标签
	 */
	public static String replaceHtml(String src){
		if (src == null || "".equals(src)) {
			return  "";
		}
		return src.replaceAll("<[^>]*>","").replace("\"", "\\\"").replace("'", "\'");
	}
	
	
	/**
	 * 用字符串连接一个集合
	 */
	public static String collectionJoinToString(Collection collection,String str){
		if (collection == null || collection.isEmpty()) {
			return  "";
		}
		StringBuilder sb = new StringBuilder(collection.size());
		for (Object object : collection) {
			sb.append(object == null ? "" : object.toString() + str);
		}
		return sb.delete(sb.length()-1, sb.length()).toString();
	}
	/** 
	 * 判断数组中有没有某元素
	 */
	public static boolean arrayContains(String [] array,String item){
		
		return ArrayUtils.contains(array, item);
	}
	
	/**
	 * 合并或者删除某个数组元素
	 */
	public static String deleteOrMergeArrayItem(String arrayStr,String item,String spea){
		if (StringUtils.isEmpty(arrayStr)) {
			return item;
		}
		String [] array = arrayStr.split(spea);
		if (ArrayUtils.contains(array, item)) {
			return StringUtils.join(ArrayUtils.removeElement(array, item), spea);
		}else{
			return StringUtils.join(array,spea) + spea + item;
		}
	}
	
	/**
	 *根据一个时间获取离当前时间的天数小时
	 */
	public static String getRemainingTime(Date date){
		
		if (date == null ) {
			return "0天0小时";
		}

		Date dateNow = new Date();
		
		// 当天可报名
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.DAY_OF_YEAR, 1);
		date = c.getTime();
		if (date.before(dateNow)) {
			return "0天0小时";
		}
		
		//当前时间
		long now = dateNow.getTime();
		//未来时间
		long future = date.getTime();
		
		long msOfHour = 1000 * 60 * 60 ;
		long msOfDay = msOfHour * 24;
		
		long diff = future - now;
		long diff_day = diff / msOfDay;
		long diff_hour = (diff % msOfDay) / msOfHour;
		
		return diff_day + "天" + diff_hour + "小时";
	}
	
	/**
	 * 调整高亮显示的list的排序
	 */
	public static List setHlListSort(List list){
		
		if (list == null) {
			return null;
		}
		
		Collections.sort(list,new Comparator() {

			@Override
			public int compare(Object o1, Object o2) {
				if (ObjectUtils.toString(o1).contains("</em>") && ObjectUtils.toString(o2).contains("</em>")) {
					return 0;
				}else if (ObjectUtils.toString(o1).contains("</em>") && !ObjectUtils.toString(o2).contains("</em>")) {
					return -1;
				}else if (!ObjectUtils.toString(o1).contains("</em>") && ObjectUtils.toString(o2).contains("</em>")) {
					return 1;
				}else{
					return 0;
				}
			}
		});
		
		
		return list;
	}
	
	/**
	 * 检查一个list里面是否包含item
	 */
	public static boolean listContains(List list,String item){
		if (list == null || list.isEmpty()) {
			return false;
		}
		for (Object object : list) {
			if (ObjectUtils.toString(object).equals(item)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 分割高亮字段 将高亮部分提前显示
	 */
	public static String splitHlField(String value){
		
		if (StringUtils.isBlank(value)) {
			return "";
		}
		// 得到第一次出现高亮标记的位置
		int firstFlagIndex = value.indexOf("<em");
		if (firstFlagIndex < 0) { // 没有高亮则直接返回
			return value;
		}else if (firstFlagIndex >=0 && firstFlagIndex <= 15) {// 高亮标记在第15个字之前
			if (replaceHtml(value).length() > 30) {			//去掉高亮之后整体字符大于30则裁剪之后返回，否则直接返回
				return cutHtmlStr(value, 50);
			}else{
				return value;
			}
		}else if (firstFlagIndex > 15) {			//高亮标记在15字以后
			int subStrEndIndex = value.length(); 
			//从高亮标记位置截取到字符末尾，如果不够30则再向前取相应长度字符
			String withoutHtmlStr = replaceHtml(value.substring(firstFlagIndex,subStrEndIndex));
			int prefixShowLen = 30 - withoutHtmlStr.length();
			prefixShowLen = prefixShowLen < 0 ? 0 :prefixShowLen; 
			
			int subStrStartIndex = firstFlagIndex>=prefixShowLen?firstFlagIndex-prefixShowLen:0;
			String prefix = value.substring(subStrStartIndex,firstFlagIndex);
			
			return  (subStrStartIndex==0?"":"...") + prefix + value.substring(firstFlagIndex,subStrEndIndex);
		}
		return "";
	}
	
	
	
	public static void main(String[] args) {
		
		/*Date date = new Date();
		
		date.setMonth(5);
		date.setDate(16);
		date.setHours(0);  家装：小户型,公寓,别墅,普通住宅,局部装修
公装：KTV,商铺,餐厅/酒楼,美容/美发,娱乐场所,酒店,展厅,办公室,写字楼,厂房,学校,医院
		date.setMinutes(0);
		date.setSeconds(0);
		System.out.println(getRemainingTime(date));*/
		
		//System.out.println(splitHlField("家装：局部装修<em class=\"search_highlight\">公装：KTV</em>,商铺,餐厅/酒楼,美容/美发,娱乐商铺,餐厅/酒楼,美容/美发,<em class=\"search_highlight\">公装：KTV</em>"));
		
		//
		//System.out.println(replaceHtml("<p><strong>阿斯顿发送到撒的发撒的发生撒的发上的发撒的</strong></p>\n\n<p>撒的发撒的四大法师的<span style=\"font-family:宋体\">撒<span style=\"font-family:仿宋_gb2312\">的<span style=\"font-size:8px\">发上的发撒的四大法师的撒的飞</span></span></span></p>"));
		
		
		//System.out.println(org.apache.commons.lang3.StringEscapeUtils.escapeHtml3("<p><strong>阿斯顿发送到撒的发撒的发生撒的发上的发撒的</strong></p>\n\n<p>撒的发撒的四大法师的<span style=\"font-family:宋体\">撒<span style=\"font-family:仿宋_gb2312\">的<span style=\"font-size:8px\">发上的发撒的四大法师的撒的飞</span></span></span></p>"));
		
		
		//System.out.println(cutStr(replaceHtml("和信房地产有限公司成立于1997年，是目前中国西部最具代表性的房地产企业之一，曾先后多次荣获“四川房地产开发企业综合实力100强”、“四川房地产开发企业最大市场占有份额50强”、“成都地产最具竞争力企业”等荣誉称号。  公司已成功开发了“谕亭苑”、“万家和花园”、“万家和新城花园”、“英伦世家”、“水沐天城”、“和信·派都”多个商住项目，已为数千户人家，数万业主提供了高品质理想居住住区。公司业务还涉及星级酒店、5A写字楼、集中商业等多类物业形态的投资与开发。和信房产秉承“不断学习，求新求变的创新精神；坚持不懈，艰苦创业的奋斗精神；风雨同舟，共谋发展的敬业精神；以人为本，高效多能的管理精神”的企业精神，自成立伊始，就立足于长远的品牌建设，进行了企业定位和品牌内涵提炼。通过十余年的项目运作和有的放矢的品牌推广，“志存高远、诚筑未来”的企业理念已广受市场认同，“思想决胜未来，创造永无止境”的企业形象已深入人心。公司致力于探求实用与品质、价格与价值、时尚与经典、超前与现实、理性和激情之最佳平衡点，不断推陈出新。无论是从宏观的规划到细节品质的雕琢，还是从现实的使用到将来的延伸价值，公司均从消费者的角度出发，始终坚持以消费者的需求和利益为重心，尊重生活、尊重生活的主人，以锻造品质为基准，以创新为手段，建造更舒适、更符合现代人居习惯的高尚人文社区。 同时，公司站在企业公民的高度，关注民生，回馈社会。多年来，公司的慈善捐赠遍及文教、扶贫、救灾等多个领域，其企业公民形象深得社会的认同与赞赏。经过数年的稳健发展，和信房产逐步形成了自身独特的核心竞争力。面对市场更加细分、竞争更加激烈的未来，公司向自己提出了更高要求——锐意进取，追求卓越！同时，我们将立足本土，面向全国，培养一支年轻而充满活力的经营管理团队，保持领先的产品研发及创新能力，成为全国知名的专业性品牌房地产企业！"),70));
		System.out.println(escapeHtml("1\"></a><a>ddd</a>"));
		
	}
}
