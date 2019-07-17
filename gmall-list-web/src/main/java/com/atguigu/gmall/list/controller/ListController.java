package com.atguigu.gmall.list.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.atguigu.gmall.bean.*;
import com.atguigu.gmall.service.AttrService;
import com.atguigu.gmall.service.ListService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.*;

@Controller
public class ListController {

    @Reference
    ListService listService;

    @Reference
    AttrService attrService;

    //由于没有首页index页面,要模拟从首页点击catalog3Id进入该页面,应该访问URL:http://localhost:8083/list.html?catalog3Id=5
    @RequestMapping("list.html")
    public String list(SkuLsParam skuLsParam, ModelMap map){

        List<SkuLsInfo> skuLsInfoList = listService.search(skuLsParam);
        
        //封装平台属性的列表
        List<BaseAttrInfo> baseAttrInfos = getAttrValueIds(skuLsInfoList);
        //根据skuLsParam,删除baseAttrInfos中的重复属性。比如用户选择内存8G,则将内存属性添加到面包屑并删除。
        //这里使用iterator可以删除特定位置符合条件的元素。否则List删除元素比较麻烦。
        String[] valueId = skuLsParam.getValueId();
        List<Crumb> crumbs = new ArrayList<>();  //面包屑
        if(valueId != null && valueId.length > 0 && baseAttrInfos != null){
            for (String s : valueId) {

                //制作面包屑
                String urlParamForCrumb = getUrlParamForCrumb(skuLsParam, s);

                Iterator<BaseAttrInfo> iterator = baseAttrInfos.iterator();
                while(iterator.hasNext()){
                    BaseAttrInfo baseAttrInfo = iterator.next();
                    List<BaseAttrValue> attrValueList = baseAttrInfo.getAttrValueList();
                    for (BaseAttrValue baseAttrValue : attrValueList) {
                        if(baseAttrValue.getId().equals(s)){
                            //封装好面包屑
                            Crumb crumb = new Crumb();
                            crumb.setValueName(baseAttrValue.getValueName());  //面包屑name
                            crumb.setUrlParam(urlParamForCrumb);
                            crumbs.add(crumb);

                            iterator.remove();  //当前游标所在位置的元素删除;即在页面上选择某个属性后该属性添加到面包屑并删除
                        }
                    }
                }
            }
        }

        String urlParam = getUrlParam(skuLsParam);

        map.put("urlParam", urlParam);
        map.put("attrList", baseAttrInfos);
        map.put("attrValueSelectedList", crumbs);
        map.put("skuLsInfoList", skuLsInfoList);
        
        return "list";
    }

    //sku的平台属性列表
    private List<BaseAttrInfo> getAttrValueIds(List<SkuLsInfo> skuLsInfos){
        Set<String> valueIds = new HashSet<>();
        for(SkuLsInfo lsInfo : skuLsInfos){
            List<SkuLsAttrValue> skuLsAttrValues = lsInfo.getSkuAttrValueList();
            for (SkuLsAttrValue skuLsAttrValue : skuLsAttrValues) {
                String valueId = skuLsAttrValue.getValueId();
                valueIds.add(valueId);
            }
        }

        //根据去重后的id集合检索,关联到的平台属性列表
        List<BaseAttrInfo> baseAttrInfos = attrService.getAttrListByValueIds(valueIds);

        return baseAttrInfos;
    }

    //制作面包屑URL
    private String getUrlParamForCrumb(SkuLsParam skuLsParam, String id){
        String urlParam = "";

        String[] valueId = skuLsParam.getValueId();
        String catalog3Id = skuLsParam.getCatalog3Id();
        String keyword = skuLsParam.getKeyword();

        //keyword和catalog3Id中一定有一个不为空,前者对应搜索框搜索,后者对应首页从属性分类点击
        if(StringUtils.isNotBlank(keyword)){
            if(StringUtils.isBlank(urlParam)){
                urlParam = "keyword=" + keyword;
            }else {
                urlParam = urlParam + "&keyword=" + keyword;
            }
        }
        if(StringUtils.isNotBlank(catalog3Id)){
            if(StringUtils.isBlank(urlParam)){
                urlParam = "catalog3Id=" + catalog3Id;
            }else {
                urlParam = urlParam + "&catalog3Id=" + catalog3Id;
            }
        }
        if(valueId != null && valueId.length > 0){
            for (String s : valueId) {
                if(!id.equals(s)){
                    urlParam = urlParam + "&valueId=" + s;
                }
            }
        }

        return urlParam;
    }

    //制作普通URL
    private String getUrlParam(SkuLsParam skuLsParam){
        String urlParam = "";

        String[] valueId = skuLsParam.getValueId();
        String catalog3Id = skuLsParam.getCatalog3Id();
        String keyword = skuLsParam.getKeyword();

        //keyword和catalog3Id中一定有一个不为空,前者对应搜索框搜索,后者对应首页从属性分类点击
        if(StringUtils.isNotBlank(keyword)){
            if(StringUtils.isBlank(urlParam)){
                urlParam = "keyword=" + keyword;
            }else {
                urlParam = urlParam + "&keyword=" + keyword;
            }
        }
        if(StringUtils.isNotBlank(catalog3Id)){
            if(StringUtils.isBlank(urlParam)){
                urlParam = "catalog3Id=" + catalog3Id;
            }else {
                urlParam = urlParam + "&catalog3Id=" + catalog3Id;
            }
        }
        if(valueId != null && valueId.length > 0){
            for (String s : valueId) {
                urlParam = urlParam + "&valueId=" + s;
            }
        }

        return urlParam;
    }
}
